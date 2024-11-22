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
from sklearn.neural_network import MLPRegressor

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


# Separación de features y target
X = kg_data.drop(['K', 'G'], axis=1)
y = kg_data[['K', 'G']]  # Multioutput target

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



# Pipeline with MultiOutputRegressor
pipeline = Pipeline(steps=[
    ('feature_transformation', feature_transformer),
    ('polynomial', polynomial_transformer),
    ('scaling', MinMaxScaler()),
    ('regression', MLPRegressor(max_iter=1000))
])

param_grid = {
    'regression__hidden_layer_sizes': [(64, 32, 8), (128, 64, 32), (128, 64)],  
    'regression__activation': ['relu', 'tanh'],   
    'regression__solver': ['adam', 'sgd'],  
    'regression__alpha': [0.0001, 0.001, 0.01],  
    'regression__learning_rate': ['constant', 'adaptive'], 
}

scorer = make_scorer(mean_squared_error, greater_is_better=False)  # Minimize MSE

regressor = GridSearchCV(
    estimator=pipeline,
    param_grid=param_grid,
    scoring=scorer,
    cv=5,  
    n_jobs=-1  
)

# TransformedTargetRegressor for multioutput
model = TransformedTargetRegressor(regressor=regressor, func=np.sqrt, inverse_func=np.square)

# Fit the model
model.fit(X_train, y_train)

# Save the model
joblib.dump(model, f'models/parallel_rf_power_3_multioutput_NN.pkl')


# Predict on test set
y_pred = model.predict(X_test)

# Evaluate the model on the test set
r2 = r2_score(y_test, y_pred, multioutput='uniform_average')
rmse = root_mean_squared_error(y_test, y_pred)
mse = mean_squared_error(y_test, y_pred)
mae = mean_absolute_error(y_test, y_pred)
mape = mean_absolute_percentage_error(y_test, y_pred)

def get_metrics(y_true, y_pred):
    residuals = y_true - y_pred
    absolute_errors = np.abs(residuals)
    squared_errors = residuals**2
    mae = np.mean(absolute_errors)
    std_mae = np.sqrt(np.mean((absolute_errors - mae)**2))
    mse = np.mean(squared_errors)
    std_mse = np.sqrt(np.mean((squared_errors - mse)**2))
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
