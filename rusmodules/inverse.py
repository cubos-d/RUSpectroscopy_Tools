from . import eigenvals
import numpy as np
import pandas as pd

def get_predicted_C(eigs_orig, eta, beta, phis_pred, shape = "Parallelepiped", Ng = 6, method = "Full_freqs"):
    """
    Get the predicted values of the elastic constants given the
    predicted values of phi (relations between K, a and mu), the 
    first eigenvalue (given in pressure units) and the geometric
    relations eta and beta. 

    Arguments:
    lambda_0 -- <float> First eigenvalue of the sample given in
            pressure units. 
    eta -- <float> First relation in the dimensions of the sample:
             cos(2*eta) = lz/(lx^2 + ly^2 + lz^2).
    beta -- <float> Second relation in the dimensions of the sample:
            cos(beta) = lx/(lx^2 + ly^2).
    phis_pred -- <dict> Dictionary containing the relations between
            the elastic constants. For example, in cubic material
            the dictionary must be written this way: {"phi_K": <float>,
            "phi_a": <float>}
    shape -- <string> Shape of the sample. Currently only supports one of these
            values: "Parallelepiped", "Cylinder", and "Ellipsoid".
    Ng -- <int> Maximum degree of the basis function in the forward problem. 

    Returns:
    A dictionary containing the following: {"C00": <float>, "C01":
            <float>, "C33": <float>}. In other words a dictionary
            containing the values of the predicted elastic 
            constants. 
    """
    data_forward = eigenvals.forward_standard(phis_pred, eta, beta, shape, Ng)
    eigs = data_forward["eig"]
    #Magnitude = lambda_0/eigs[0]
    Magnitude_0 = eigs_orig[0]/eigs[0]
    if method == "Full_freqs":
        Magnitude = (Magnitude_0/len(eigs_orig))*(1 + sum(map(lambda i: eigs_orig[i]/eigs[i], range(1, len(eigs_orig)))))
    else:
        Magnitude = Magnitude_0
    #fin if 
    if len(phis_pred) == 1:
        K = Magnitude*np.cos(phis_pred["phi_K"])
        mu = Magnitude*np.sin(phis_pred["phi_K"])
        C_pred = {"C00": K + (4/3)*mu, "C01": K - (2/3)*mu, "C33": mu}
    elif len(phis_pred) == 2:
        K = Magnitude*np.cos(phis_pred["phi_K"])
        a = Magnitude*np.sin(phis_pred["phi_K"])*np.cos(phis_pred["phi_a"])
        mu = Magnitude*np.sin(phis_pred["phi_K"])*np.sin(phis_pred["phi_a"])
        C_pred = {"C00": K + 2*a, "C01": K - a, "C33": mu}
    else: 
        raise ValueError("Crystal structures above cubic are still not supported")
    #fin if 
    return C_pred
#fin función

def get_compositions(eigenvalues, Nmax = 20):
    """
    Transforms the eigenvalues given by the forward problem to 
    compositions of a spectrum. 

    Arguments: 
    eigenvalues -- <np.array> Array of the eigenvalues given 
            by the forward problem. 
    Nmax -- <int> Number of compositions to be calculated. 

    Returns:
    A np.array with the compositions
    """
    ind_fin = Nmax - 1
    compositions = np.zeros(Nmax)
    for i in range(ind_fin):
        if i == 0:
            compositions[0] = 1/eigenvalues[ind_fin]
            compositions[1] = (eigenvalues[1] - 1)/eigenvalues[ind_fin]
        else:
            compositions[i+1] = (eigenvalues[i+1] - eigenvalues[i])/eigenvalues[ind_fin]
        #fin if 
    #fin for 
    return compositions
#fin if

def scale(d_frame, mean, standard_dev):
    """
    Scales the data substracting by a given mean and then dividing 
    by a given standard deviation. 

    Arguments:
    d_frame -- <pd.DataFrame> Data frame containing the row of data 
            to be standarized
    mean -- <dict> Dictionary containing every mean value of every
            feature, given in this format: {"eta": <float>, "beta":
            <float>, "x_0": <float>, "x_1": <float>, ...}
    standard_dev -- <dict> Dictionary containing every standard deviation 
            value of every feature, given in this format: {"eta": <float>, 
            "beta": <float>, "x_0": <float>, "x_1": <float>, ...}

    Returns:

    A data frame with the feature values standarized. 
 
    """
    dat_copy = d_frame.copy()
    for key in d_frame.keys():
        dat_copy[key] = (d_frame[key] - mean[key])/standard_dev[key]
    #fin for
    return dat_copy
#fin función

def inverse_standard(x_n, eta, beta, model_data, include_x0 = True):
    """
    Predicts the values of phi (the relations between the
    elastic constants) given  the compositions, the geometric
    parameters and a ML model. 

    Arguments:
    x_n -- <np.array> Compositions or eigenvalues transformations
    eta -- <float> First relation in the dimensions of the sample:
             cos(2*eta) = lz/(lx^2 + ly^2 + lz^2).
    beta -- <float> Second relation in the dimensions of the sample:
            cos(beta) = lx/(lx^2 + ly^2).
    model_data -- <dict> A dictionary containing the following: The Keras or 
            scikit-learn model, the mean and the standars deviation of 
            every feature the following way: {"model": <keras.model>,
            "mean": {"eta": <float>, "beta": <float>, "x_0": <float>,
            ...}, "std": {"eta": <float>, "beta": <float>, ...}}
    include_x0 -- <bool> Some models don't include x0 as a feature. 
            If that's the case turn it into False, but in any case
            there MUST be a x_0 fed to the function. 

    Returns:
    Predicted values of phi. For example, if the sample is cubic,
            it will return 2 values between 0 and pi/2.
    """
    if include_x0:
        dict_x = dict(map(lambda i: ("x_" + str(i), x_n[i]), range(len(x_n))))
    else:
        dict_x = dict(map(lambda i: ("x_" + str(i), x_n[i]), range(1, len(x_n))))
    #fin if 
    dict_geo = {"eta": eta, "beta": beta}
    dict_tot = {**dict_geo, **dict_x}
    data_frame = pd.DataFrame(dict_tot, index = [0])
    if isinstance(model_data, dict):
        data_frame = scale(data_frame, model_data["mean"], model_data["std"])
        y = model_data["model"].predict(data_frame)
    else:
        y = model_data.predict(data_frame)
    #fin if
    phis = (np.pi/2)*y
    return phis
#fin función

def get_constants(eigs, eta, beta, model_data, include_x0 = True, Nmax = 20, shape = "Parallelepiped", Ng = 6):
    """
    This function predicts the elastic constants, given the 
    eigenvalues (as returned in the forward problem), the 
    geometrical parameters eta and beta, and finally, the
    keras or scikit-learn model. 

    Arguments:
    eigs -- <np.array> Normalized eigenvalues of the rus forward problem. 
            Thefirst element `vals[0]` is the first eigenvalue (lambda_0) and 
            has the same units and order of magnitude as the given elastic
            constants. The rest of the elements (vals[1:]) are the relation
            between the i-th eigenvalue and the first eigenvalue (lambda_i /
            lambda_0). Each eigenvalue is:
            lambda_i = (m (omega_i)^2) / r) where r is: r = (lx^2 + ly^2 + 
            lz^2)^(1/2).
    eta -- <float> First relation in the dimensions of the sample:
             cos(2*eta) = lz/(lx^2 + ly^2 + lz^2).
    beta -- <float> Second relation in the dimensions of the sample:
            cos(beta) = lx/(lx^2 + ly^2).
    model_data -- <dict> A dictionary containing the following: The Keras or 
            scikit-learn model, the mean and the standars deviation of 
            every feature the following way: {"model": <keras.model>,
            "mean": {"eta": <float>, "beta": <float>, "x_0": <float>,
            ...}, "std": {"eta": <float>, "beta": <float>, ...}}
    include_x0 -- <bool> Some models don't include x0 as a feature. 
            If that's the case turn it into False, but in any case
            there MUST be a x_0 fed to the function.

    Returns: 
    Predicted values of the elastic constants. It will be returned in a
            dictionary like this: {"C00": <float>, "C01": <float>, "C02":
            <float>}. 
    """
    #lambda_0 = eigs[0]
    xn = get_compositions(eigs, Nmax)
    phi_pred = inverse_standard(xn, eta, beta, model_data, include_x0)[0,:]
    dic_phi = dict()
    if len(phi_pred) == 1:
        dic_phi["phi_K"] = phi_pred[0]
    elif len(phi_pred) == 2:
        dic_phi["phi_a"] = phi_pred[0]
        dic_phi["phi_K"] = phi_pred[1]
    else:
        raise ValueError("Crystal structures above cubic are not supported yet!")
    #fin if
    pred_C = get_predicted_C(eigs, eta, beta, dic_phi, shape, Ng)
    return pred_C
#fin función
 


if __name__ == "__main__":
    print("Hello")
