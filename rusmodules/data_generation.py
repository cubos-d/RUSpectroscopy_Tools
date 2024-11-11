import numpy as np
import pandas as pd
import itertools
from . import geometry

def gen_random_C(dict_C, key):
    """
    Generate N random values of a given constant with an uniform distribution

    Arguments: 
    dict_C -- <dict>: A dictionary containing the rank of the constants and
        how many of them will be included in the parameters generated.
    key -- <string>: Name of the constant 

    Returns:
    params -- <np.array>: N(Finura) constants dsitributed uniformly between the min and the 
        max given.

    """
    min_value = dict_C[key]["min"] * (1/dict_C[key]["Finura"])
    max_value = dict_C[key]["max"]
    multi = (max_value - min_value)
    return multi*np.random.rand(dict_C[key]["Finura"]) + min_value
#fin get_random_C

def gen_random_parameters(C_rank, Np, shape):
    """
    Generate random parameters (without executing forward problem yet). Each parameter
    generated will have a random uniform distribution for the constants and each geome
    tric parameter will be distributed in an uniform way over the surface of the sphere. 
    It works despie the crystal structure
    
    Arguments:
    C_rank -- <dict>: A dictionary containing the rank of the constants and how many of 
        them will be included in the parameters generated. 
        It mus be written the following way:{"constant_name1": {"min": <float>, "max": 
        <float>, "Finura": <int>}, "constant_name2": {"min": ...}, "constant_name3": 
        {"min": ...}, ...}
    Np_dim -- <int>: Aproximate number of geometries to add to the combinations. 
    shape -- <string>: Shape of the sample. Currently supports: Parallelepiped, 
        Cylinder and Ellipsoid

    Returns: 
    total_combinations -- <tuple>: Returns a tuple of dictionaries, where each dictionary
        contains the information of a single combination of constants and parameters. Each 
        dictionary is ready to be filled with the eigenvalues once the forward problem is 
        run with this tuple of dicts. 

    """
    max_eta = {"Parallelepiped": 0.61*np.pi, "Cylinder": np.pi, "Ellipsoid": 0.61*np.pi}
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


def gen_combinatorial_parameters(C_rank, Np_dim, shape):
    """
    Generate combinatorial parameters (without executing forward problem yet) of every 
    possible combination of Constants with every combination of geometries (distributed
    over a sphere). It works despie the crystal structure
    
    Arguments:
    C_rank -- <dict>: A dictionary containing the rank of the constants and how many of 
        will be included in the combinations. It mus be written the following way: 
        {"constant_name1": {"min": <float>, "max": <float>, "Finura": <int>}, 
        "constant_name2": {"min": ...}, "constant_name3": {"min": ...}, ...}
    Np_dim -- <int>: Aproximate number of geometries to add to the combinations. 
    shape -- <string>: Shape of the sample. Currently supports: Parallelepiped, Cylinder
        and Ellipsoid

    Returns: 
    total_combinations -- <tuple>: Returns a tuple of dictionaries, where each dictionary
        contains the information of a single combination of constants and parameters. Each 
        dictionary is ready to be filled with the eigenvalues once the forward problem is 
        run with this tuple of dicts. 
    """
    max_eta = {"Parallelepiped": 0.61*np.pi, "Cylinder": np.pi, "Ellipsoid": 0.61*np.pi}
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


