import numpy as np 
import pandas as pd
import scipy
import os
import itertools
import sys
from rusmodules import eigenvals, data_generation

def generate_pars(data_frame, N_geo):
    pars = []
    for i in data_frame.index:
        for j in range(N_geo):
            dat_actual = dict()
            Lx = np.random.uniform(data_frame["min_Lx"][i], data_frame["max_Lx"][i])
            Ly = np.random.uniform(data_frame["min_Ly"][i], data_frame["max_Ly"][i])
            Lz = np.random.uniform(data_frame["min_Lz"][i], data_frame["max_Lz"][i])
            ds = np.sort([Lx, Ly, Lz])
            tam = (ds[0]**2 + ds[1]**2 + ds[2]**2)**0.5
            div = float(data_frame["G"][i])/float(data_frame["K"][i])
            dat_actual["phi_K"] = np.arctan(div)
            dat_actual["eta"] = 2*np.arccos(ds[2]/tam)
            dat_actual["beta"] = 4*np.arctan(ds[0]/ds[1])
            pars.append(dat_actual)
        #fin for
    #fin for 
    return tuple(pars)
#fin generate_pars


def generate_fixed_exp(path, path_src, Ng, N_geo, shape, mode = "Magnitude", N_vals = 20):
    datos_mat = pd.read_csv(path_src, index_col = 0)
    pars = generate_pars(datos_mat, N_geo)
    exponents = {"Magnitude": 1, "Sum": 2}
    for a, param in enumerate(pars):
        x_K = (np.cos(param["phi_K"]))**exponents[mode]
        x_mu = (np.sin(param["phi_K"]))**exponents[mode]
        constant_relations = {"x_K": x_K, "x_mu": x_mu}
        data_vals = eigenvals.get_eigenvalues_from_crystal_structure(Ng, constant_relations, param["eta"], param["beta"], shape)
        vals = data_vals["eig"]
        keys_eigen = tuple(map(lambda x: "eig_" + str(x), range(N_vals)))
        for i in range(N_vals):
            param[keys_eigen[i]] = vals[i]
        #fin for
        possible_shapes = ("Parallelepiped", "Cylinder", "Ellipsoid")
        for shape_i in possible_shapes:
            param[shape_i] = 1 if shape == shape_i else 0
        #fin for
        with open(path, "a+t") as f:
            if a == 0:
                f.write(",".join(list(param.keys())) + "\n")
            #fin if 
            f.write(",".join(list(map(lambda x: str(x), param.values()))) + "\n")
        #fin with
    #fin for 
    #return pd.DataFrame(pars)
#fin función

if __name__ == "__main__":
    path_src = "input_data/semireal_isotropic_data.csv"
    path_destino = "input_data/KG_semiexp_" + str(os.getpid()) + ".csv"
    df_ejemplo = pd.read_csv(path_src, index_col = 0) 
    #a = generate_pars(df_ejemplo, 2)
    generate_fixed_exp(path_destino, path_src, 6, 2, "Parallelepiped")
    #print(pd.DataFrame(a))
