import numpy as np
import pandas as pd

def preprocess_data(d_frame, N_eig, target, opt = True):
    """
    Takes a dataframe with standarized geometry, targets as angles,
    and with divided eigenvalues the following way: 
    new_eigen = eigen_{n-1}/eigen{n}. Also returns a the
    dataframe only with the first N_eig fist eigenvalues.

    Arguments:
    d_frame -- <pd.DataFrame> Data frame to be transformed. Of course it
        will be copied. 
    N_eig -- <int>: Number of eigenvalues we want to be in the final 
        data frame
    target -- <list>, <string>: Target or targets in form of angles. 

    Returns:
    dat_copy -- <pd.DataFrame>: Properly transformed data frame to be
        fed to a machine learning model
    """
    features_eig = list(map(lambda x: "eig_" + str(x+1), range(N_eig)))
    features_dim = ["eta", "beta"]
    feature_especial = ["eig_0"]
    features_tot = [target] + feature_especial + features_dim + features_eig
    dat_copy = d_frame.copy()
    dat_copy[target] = d_frame[target]/(np.pi/2)
    for i in range(N_eig):
        key_mod = "eig_" + str(i+1)
        prev_key = "eig_" + str(i)
        if i == 0:  
            dat_copy[key_mod] = 1/d_frame[key_mod] if opt else d_frame[prev_key]/d_frame[key_mod]
        else:
            dat_copy[key_mod] = d_frame[prev_key]/d_frame[key_mod]
        #fin if 
    #fin for
    for i in range(N_eig):
        col = "eig_" + str(i+1)
        #dat_copy[col] = np.log(dat_copy[col])
    #fin for 
    dat_copy = dat_copy.dropna()
    try:
        problematic_rows = dat_copy[(~np.isfinite(dat_copy)).any(axis=1) | (dat_copy.abs() > np.finfo(np.float64).max).any(axis=1)]
        problematic_indices = problematic_rows.index
        dat_copy = dat_copy.drop(index=problematic_indices)
    except:
        pass #HEHE!!! I will figure out how to make this line less dangerous 
    #fin exception
    return dat_copy[features_tot]
#fin procesar_datos

def get_metrics(X, y, model):
    """
    This is a function just to return some metrics given the real values
    "y", the features X and any model that has the "fit" method. 
    """
    y_gorro = model.predict(X)
    R2 = r2_score(y, y_gorro)
    RMSE = root_mean_squared_error(y, y_gorro)
    MAE = mean_absolute_error(y, y_gorro)
    return {"R2": R2, "RMSE": RMSE/(np.pi/2), "MAE": MAE/(np.pi/2)}
#fin función

def transform_full_sized_data_isotropic(KG_data):
    new_data = KG_data.copy()
    del new_data["rho"]
    for q in range(N_eig+1):#nondeg_minlen):
        new_data['eig_' + str(q)] = new_data['eigvals'].apply(lambda arr: arr[6 + q])
    #fin for 
    datos_kg_random = datos_kg_random.drop(columns=['eigvals'])
