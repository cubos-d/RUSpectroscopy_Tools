import os
import numpy as np
import pandas as pd
import joblib
from datetime import datetime

from sklearn.model_selection import train_test_split, GridSearchCV
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import PowerTransformer, PolynomialFeatures, MinMaxScaler
from sklearn.compose import ColumnTransformer
from sklearn.metrics import r2_score, mean_squared_error, mean_absolute_error, mean_absolute_percentage_error, root_mean_squared_error
from sklearn.compose import TransformedTargetRegressor
from sklearn.ensemble import RandomForestRegressor
from sklearn.multioutput import MultiOutputRegressor
from sklearn.decomposition import KernelPCA

start_time = datetime.now()

str_to_ndarray = lambda x: np.fromstring(x, sep=' ')

path = os.path.join('..', '..', 'data', 'KG_combin.csv')
kg_data = pd.read_csv(path, converters={'eigvals': str_to_ndarray})

num_omegas = 29

for q in range(num_omegas):
    kg_data['omega2_' + str(q)] = kg_data['eigvals'].apply(lambda arr: arr[6 + q]) / kg_data['rho']

kg_data = kg_data.drop(columns=['eigvals'])

# Leave only rows with shape == parallelepiped
kg_data = kg_data[kg_data['shape'] == 'parallelepiped']

# Drop shape column
kg_data = kg_data.drop(columns=['shape'])

threshold = 50
for i in range(10):
    kg_data = kg_data[kg_data[f'omega2_{i}'] <= threshold]

columns_to_keep = ['K', 'G', 'rho', 'dx', 'dy', 'dz', 'omega2_0', 'omega2_13', 'omega2_26']
kg_data = kg_data[columns_to_keep]


for n_components in range(2,20,3):
    
    print(f'n_components={n_components}')

    kg_data_copy = kg_data.copy()

    # Separación de features y target
    X = kg_data_copy.drop(['K', 'G'], axis=1)
    y = kg_data_copy[['K', 'G']]  # Multioutput target

    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, shuffle=True)

    sqrt_columns = ['rho', 'dx', 'dy', 'dz']
    omega_columns = ['omega2_0', 'omega2_13', 'omega2_26']

    # Numeric columns for transformation
    numeric_columns = sqrt_columns + omega_columns

    # Feature transformer
    feature_transformer = ColumnTransformer(transformers=[
        ('power', PowerTransformer(method='yeo-johnson'), numeric_columns),
    ], remainder='drop')

    # Polynomial features
    polynomial_transformer = PolynomialFeatures(degree=3, interaction_only=False, include_bias=False)

    kpca = KernelPCA(n_components=n_components, kernel='rbf', gamma=15)

    # Pipeline with MultiOutputRegressor
    pipeline = Pipeline(steps=[
        ('feature_transformation', feature_transformer),
        ('pca', kpca),
        ('scaling', MinMaxScaler()),
        ('regression', MultiOutputRegressor(RandomForestRegressor(n_estimators=200, max_depth=None, n_jobs=-1)))
    ])


    # TransformedTargetRegressor for multioutput
    model = TransformedTargetRegressor(regressor=pipeline, func=np.sqrt, inverse_func=np.square)

    # Fit the model
    model.fit(X_train, y_train)

    # Save the model
    joblib.dump(model, f'models/parallel_rf_power_3_multioutput.pkl')


    # Predict on test set
    y_pred = model.predict(X_test)

    # Evaluate the model on the test set
    r2 = r2_score(y_test, y_pred, multioutput='uniform_average')
    rmse = root_mean_squared_error(y_test, y_pred)
    mse = mean_squared_error(y_test, y_pred)
    mae = mean_absolute_error(y_test, y_pred)
    mape = mean_absolute_percentage_error(y_test, y_pred)

    def get_metrics(y_true, y_pred):
        # 1. Residuals (Errors)
        residuals = y_true - y_pred
        # 2. Absolute Errors
        absolute_errors = np.abs(residuals)
        # 3. Squared Errors
        squared_errors = residuals**2
        # MAE and Standard Deviation for MAE
        mae = np.mean(absolute_errors)
        std_mae = np.sqrt(np.mean((absolute_errors - mae)**2))
        # MSE and Standard Deviation for MSE
        mse = np.mean(squared_errors)
        std_mse = np.sqrt(np.mean((squared_errors - mse)**2))
        # RMSE and Standard Deviation for RMSE
        rmse = np.sqrt(mse)
        std_rmse = np.sqrt(np.mean((residuals - np.mean(residuals))**2))
        print(f"MSE: {mse:.4f}, Std Dev of MSE: {std_mse:.4f}")
        print(f"RMSE: {rmse:.4f}, Std Dev of RMSE: {std_rmse:.4f}")
        print(f"MAE: {mae:.4f}, Std Dev of MAE: {std_mae:.4f}")

        return r2, rmse, mae, mape

    print(get_metrics(y_test, y_pred))

    print("\nTest Set Metrics:")
    print(f'R2: {r2:.4f}')
    print(f'MSE: {mse:.4f}')
    print(f'RMSE: {rmse:.4f}')
    print(f'MAE: {mae:.4f}')
    print(f'MAPE: {mape:.4f}')

end_time = datetime.now()
elapsed_time = end_time - start_time
print(f"\nElapsed Time: {elapsed_time}")
