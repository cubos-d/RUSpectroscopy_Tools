import numpy as np
import pandas as pd
import scipy
import os
import itertools
from datamodules import preproc
from rusmodules import eigenvals, data_generation

def generate_combinatorial_data_isotropic(path, Ng, Np_const, Np_geo, shape, mode = "Magnitude", N_vals = 100):
    pars = gen_combinatorial_parameters(Ng, {"phi_K": {"min": 0, "max": np.pi/2, "Finura": Np_const}}, Np_geo, shape)
    exponents = {"Magnitude": 1, "Sum": 2}
    for a, param in enumerate(pars):
        param["x_K"] = (np.cos(param["phi_K"]))**exponents[mode]
        param["x_mu"] = (np.sin(param["phi_K"]))**exponents[mode]
        constant_relations = {"x_K": param["x_K"], "x_mu": param["x_mu"]}
        data_vals = eigenvals.get_eigenvalues_from_crystal_structure(Ng, constant_relations, param["eta"], param["beta"], shape)
        vals = data_vals["eig"]
        keys_eigen = tuple(map(lambda x: "eig_" + str(x), range(N_vals)))
        for i in range(N_vals):
            param[keys_eigen[i]] = vals[i]
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
    """
    """
    ruta_archivo = "input_data/" + "combi_" + str(os.getpid()) + ".csv"
    generate_combinatorial_data_isotropic(ruta_archivo, 6, 10, 4, "Parallelepiped")  
