import numpy as np
import pandas as pd
from . import geometry

def gen_random_C(dict_C, key):
    """
    DOCUMENTAR
    """
    min_value = dict_C[key]["min"] * (1/dict_C[key]["Finura"])
    max_value = dict_C[key]["max"]
    multi = (max_value - min_value)
    return multi*np.random.rand(dict_C[key]["Finura"]) + min_value
#fin get_random_C

def gen_random_parameters(Ng, C_rank, Np, shape):
    """
    DOCUMENTAR
    """
    max_eta = {"Parallelepiped": 0.5*np.pi, "Cylinder": np.pi, "Ellipsoid": 0.5*np.pi}
    max_beta = {"Parallelepiped": np.pi, "Cylinder": np.pi, "Ellipsoid": np.pi}
    geometry_options = {"Parallelepiped": {"theta": True, "phi": True}, 
                        "Cylinder": {"theta": False, "phi": True},
                        "Ellipsoid": {"theta": True, "phi": True}}
    keys_dims = ("eta", "beta")
    values_param = np.array(tuple(map(lambda x: gen_random_C(C_rank, x), C_rank.keys()))).T
    values_dims = geometry.generate_sphere_surface_points_random(Np, max_eta[shape], max_beta[shape], geometry_options[shape])
    index_total_combinations = range(Np) 
    C_dir = lambda C_keys, combi: dict(zip(C_keys, combi))
    total_vals = tuple(map(lambda x: {**C_dir(C_rank.keys(), values_param[x]), **C_dir(keys_dims, values_dims[x])}, index_total_combinations))
    return total_vals 


def gen_combinatorial_parameters(Ng, C_rank, Np_dim, shape):
    """
    TODO: DOCUMENTAR
    """
    max_eta = {"Parallelepiped": 0.5*np.pi, "Cylinder": np.pi, "Ellipsoid": 0.5*np.pi}
    max_beta = {"Parallelepiped": np.pi, "Cylinder": np.pi, "Ellipsoid": np.pi}
    geometry_options = {"Parallelepiped": {"theta": True, "phi": True}, 
                        "Cylinder": {"theta": False, "phi": True},
                        "Ellipsoid": {"theta": True, "phi": True}}

    N_dir = 2
    keys_dims = ("eta", "beta")
    combinations_param = np.array(tuple(itertools.product(*(np.linspace(C_rank[key]["min"] 
                        + (1/C_rank[key]["Finura"]), C_rank[key]["max"]*(1 - (1/C_rank[key]["Finura"])), 
                        C_rank[key]["Finura"]) for key in C_rank.keys()))))
    combinations_dims = geometry.generate_sphere_surface_points(Np_dim, max_eta[shape], max_beta[shape], geometry_options[shape])
    index_total_combinations = np.array(tuple(itertools.product(range(len(combinations_param)), range(len(combinations_dims)))))
    C_dir = lambda C_keys, combi: dict(zip(C_keys, combi))
    total_combinations = tuple(map(lambda x: {**C_dir(C_rank.keys(), combinations_param[x[0]]), **C_dir(keys_dims, combinations_dims[x[1]])}, index_total_combinations))
    return total_combinations
#fin funcion


