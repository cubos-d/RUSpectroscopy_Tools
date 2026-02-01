import numpy as np
import rusmodules
from rusmodules import eigenvals
import matplotlib.pyplot as plt
import time

phi_K = 0.2773734352080893
eta = 0.7291454067183892
beta = 2.1807516889272844
shape = "Ellipsoid"

dic_comps = {"x_K": np.cos(phi_K), "x_mu": np.sin(phi_K)}
dic_rel_eigenvals = eigenvals.get_eigenvalues_from_crystal_structure(6, dic_comps, eta, beta, shape)
rel_eigenvals = dic_rel_eigenvals["eig"][:5]
print(rel_eigenvals)
