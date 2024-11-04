import numpy as np
import pandas as pd
import scipy
import os
import itertools
from rusmodules import eigenvals, data_generation

def generate_data_isotropic(path, Ng, data_gen,shape, mode = "Magnitude", N_vals = 100):
    if data_gen["type"] == "combi":
        pars = data_generation.gen_combinatorial_parameters({"phi_K": {"min": 0, "max": np.pi/2, "Finura": data_gen["N_const"]}}, data_gen["N_geo"], shape)
    else:
        pars = data_generation.gen_random_parameters({"phi_K": {"min": 0, "max": np.pi/2, "Finura": data_gen["N_data"]}}, data_gen["N_data"], shape)
    #fin if 
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
    data_gen = {"type": "combi",
                "N_const": 10,
                "N_geo": 6,
                "N_data": 20,
                }
    ruta_archivo = "input_data/" + data_gen["type"] +"_" + str(os.getpid()) + ".csv"
    generate_data_isotropic(ruta_archivo, 6, data_gen, "Parallelepiped")  
