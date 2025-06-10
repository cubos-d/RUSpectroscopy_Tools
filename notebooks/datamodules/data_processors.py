import numpy as np
import pandas as pd
import sklearn
from sklearn.metrics import r2_score, mean_absolute_error, root_mean_squared_error, make_scorer, mean_absolute_percentage_error

def preprocess_data(d_frame, N_eig, target, opt = True, compositions = True, angle_targets = True):
    """
    Takes a dataframe with standarized geometry, targets as angles,
    and with divided eigenvalues the following way: 
    new_eigen = eigen_{n-1}/eigen{n}. Also returns a the
    dataframe only with the first N_eig fist eigenvalues.

    New bug, I mean feature: Now this function will return compositions
    instead of modified lambdas if the user whishes so. And this option
    will be enabled by default. 

    Arguments:
    d_frame -- <pd.DataFrame> Data frame to be transformed. Of course it
        will be copied. 
    N_eig -- <int>: Number of eigenvalues we want to be in the final 
        data frame
    target -- <list> or <string>: Target or targets in form of angles. 
    compositions -- <boolean>: Set True if you want this
        function to return compositions (x_n = (lambda_n - lambda_{n-1})
        /lambda_N)
    opt -- <boolean>: Only enter False if the inputs are non relative 
        eigenvalues or are frequencies directly. 

    Returns:
    dat_copy -- <pd.DataFrame>: Properly transformed data frame to be
        fed to a machine learning model
    """
    features_eig = list(map(lambda x: "eig_" + str(x+1), range(N_eig)))
    features_dim = ["eta", "beta"]
    feature_especial = ["eig_0"]
    target_f = [target] if isinstance(target, str) else target
    features_tot = target_f + feature_especial + features_dim + features_eig
    dat_copy = d_frame.copy()
    if angle_targets:
        dat_copy[target] = d_frame[target]/(np.pi/2)
    key_fin = "eig_" + str(N_eig)
    for i in range(N_eig):
        key_mod = "eig_" + str(i+1)
        prev_key = "eig_" + str(i)
        if i == 0:
            if compositions: 
                dat_copy["x_0"] = 1/d_frame[key_fin] if opt else d_frame[prev_key]/d_frame[key_fin]
                dat_copy["x_1"] = (d_frame[key_mod] - 1)/d_frame[key_fin] if opt else (d_frame[key_mod] - d_frame[prev_key])/d_frame[key_fin] 
            #fin if
            dat_copy[key_mod] = 1/d_frame[key_mod] if opt else d_frame[prev_key]/d_frame[key_mod] 
        else:
            if compositions:
                key_comp = "x_" + str(i+1)
                dat_copy[key_comp] = (d_frame[key_mod] - d_frame[prev_key])/d_frame[key_fin]
            #fin if 
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
    if compositions:
        features_tot = features_tot + list(map(lambda x: "x_" + str(x), range(N_eig + 1))) 
    return dat_copy[features_tot]
#fin procesar_datos

def scale(d_frame, statistical_data = {}):
    dat_copy = d_frame.copy()
    if len(statistical_data.keys()) == 0:
        for key in d_frame.keys():
            dat_copy[key] = (d_frame[key] - np.average(d_frame[key]))/np.std(d_frame[key])
        #fin for
    else: 
        for key in d_frame.keys():
            dat_copy[key] = (d_frame[key] - statistical_data[key]["mean"])/statistical_data[key]["std"]
        #fin for 
    #fin if
    return dat_copy
#fin función

def create_additional_geometric_features(d_frame):
    features_dim = ["eta", "beta"]
    d_frame["g0"] = np.cos(0.5*d_frame["eta"])*np.tan(0.25*d_frame["beta"])
    d_frame["g1"] = np.cos(0.5*d_frame["eta"])/np.tan(0.25*d_frame["beta"])
    d_frame["g2"] = np.tan(0.5*d_frame["eta"])*np.sin(0.5*d_frame["eta"])*np.sin(0.25*d_frame["beta"])*np.cos(0.25*d_frame["beta"])
    d_frame["g3"] = np.sin(0.5*d_frame["eta"])*np.cos(0.25*d_frame["beta"])
    d_frame["g4"] = np.sin(0.5*d_frame["eta"])*np.sin(0.25*d_frame["beta"])
    d_frame["g5"] = np.cos(0.5*d_frame["eta"])
#fin función 

def get_SDAE(y, y_gorro):
    mat_comp = np.c_[y, y_gorro]
    MAE = abs(mat_comp[:,0] - mat_comp[:,1])
    return np.std(MAE)
#fin función

def get_mape(y, y_gorro):
    """

    """
    cosines = np.c_[np.cos(y), np.cos(y_gorro)]
    sines = np.c_[np.sin(y), np.sin(y_gorro)]
    MAE_cos = abs(cosines[:,0] - cosines[:,1])/cosines[:,0]
    MAE_sin = abs(sines[:,0] - sines[:,1])/sines[:,0]
    resp = dict()
    resp["mean"] = np.average(0.5*MAE_cos + 0.5*MAE_sin)
    resp["sdev"] = np.std(0.5*MAE_cos + 0.5*MAE_sin)
    return resp
#fin get shape

def get_metrics(X, y, model, mapes = False):
    """
    This is a function just to return some metrics given the real values
    "y", the features X and any model that has the "fit" method. 
    """
    y_gorro = model.predict(X)
    R2 = r2_score(y, y_gorro)
    RMSE = root_mean_squared_error(y, y_gorro)
    MAE = mean_absolute_error(y, y_gorro)
    SDAE = get_SDAE(y, y_gorro)
    resp = {"R2": R2, "RMSE": RMSE, "MAE": MAE, "SDAE": SDAE}
    if mapes:
        mapes_data = get_mape(y, y_gorro)
        resp["MAPE"] = mapes_data["mean"]
        resp["SDPE"] = mapes_data["sdev"]
    #fin if 
    return resp
#fin función

def transform_full_sized_data_isotropic(KG_data, N_eig):
    """
    This function Transform a full sized data (with units) to a standard form
    (adimensionalized). Only owrks for isotropic data 
    """
    new_data = KG_data.copy()
    del new_data["rho"]
    for q in range(N_eig+1):#nondeg_minlen):
        new_data['eig_' + str(q)] = new_data['eigvals'].apply(lambda arr: arr[6 + q])
    #fin for 
    new_data = new_data.drop(columns=['eigvals'])

    new_data["phi_K"] = np.arctan(new_data["G"]/new_data["K"])
    indexes = new_data.index
    new_data["eta"] = np.ones(len(new_data))
    new_data["beta"] = np.ones(len(new_data))
    new_data["R"] = np.ones(len(new_data))
    new_data["V"] = np.ones(len(new_data))
    for i in indexes:
        lis_or = np.sort([new_data["dx"][i], new_data["dy"][i], new_data["dz"][i]])
        r = (lis_or[0]**2 + lis_or[1]**2 + lis_or[2]**2)**0.5
        new_data.loc[i, "R"] = r
        new_data.loc[i, "eta"] = 2*np.arccos(lis_or[2]/r)
        new_data.loc[i, "beta"] = 4*np.arctan(lis_or[0]/lis_or[1])
        new_data.loc[i, "V"] = lis_or[0]*lis_or[1]*lis_or[2]
    #fin for
    for i in range(N_eig + 1):
        key_i = "eig_" + str(i) 
        new_data.loc[:, key_i] = (new_data["V"]*new_data[key_i])/new_data["R"]
    #fin for 
    del new_data["V"]
    del new_data["R"]
    return new_data.copy()
#fin función

def transform_experimental_data_isotropic(KG_data, N_eig, keys_eig):  
    new_data = KG_data.copy()
    new_data["phi_K"] = np.arctan(new_data["G"]/new_data["K"])
    indexes = new_data.index
    new_data["eta"] = np.ones(len(new_data))
    new_data["beta"] = np.ones(len(new_data))
    new_data["R"] = np.ones(len(new_data))
    new_data["V"] = np.ones(len(new_data))
    for i in indexes:
        lis_or = np.sort([new_data["dx"][i], new_data["dy"][i], new_data["dz"][i]])
        r = (lis_or[0]**2 + lis_or[1]**2 + lis_or[2]**2)**0.5
        new_data.loc[i, "R"] = r
        new_data.loc[i, "eta"] = 2*np.arccos(lis_or[2]/r)
        new_data.loc[i, "beta"] = 4*np.arctan(lis_or[0]/lis_or[1])
        new_data.loc[i, "V"] = lis_or[0]*lis_or[1]*lis_or[2]
    #fin for
    for i in range(N_eig + 1):
        key_obj_i = "eig_" + str(i)
        key_scr_i = keys_eig + str(i)
        new_data[key_obj_i] = (new_data["rho"]*new_data["V"]*new_data[key_scr_i])/new_data["R"]
        del new_data[key_scr_i]
    #fin for 
    del new_data["V"]
    del new_data["R"]
    return new_data.copy()
