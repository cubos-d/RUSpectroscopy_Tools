import numpy as np
from rusmodules import eigenvals
from rusmodules import rus
import scipy

K = 1.137564; mu = 0.925310
Ng = 10
shape = "Parallelepiped"
A = 1
eta = 1.337486
beta = 2.600392
const_rel = {"x_K": A*K, "x_mu": A*mu}
relative_0_eig = eigenvals.get_eigenvalues_from_crystal_structure(Ng, const_rel, eta, beta, shape)["eig"]
relative_eig = np.zeros(5)
#print(relative_0_eig[:5])
for i in range(5):
    relative_eig[i] = 1/relative_0_eig[i+1] if i == 0 else relative_0_eig[i]/relative_0_eig[i+1]
    relative_eig[i] = np.log(relative_eig[i])
#fin for 
print(relative_eig)

#geometry = np.array([0.345791, 0.454774, 0.722980])
geometry = np.array([0.345791, 0.722980, 0.454774])  
C_iso = eigenvals.get_elastic_constants({"K": K, "mu": mu})  
Gamma = rus.gamma_matrix(Ng, C_iso, geometry, 0)
E = rus.E_matrix(Ng, 0)
vals = scipy.linalg.eigvalsh(Gamma, b = E)
vals_fin = vals[6:]
rel_eig = np.zeros(5)
for i in range(5):
    rel_eig[i] = vals_fin[i]/vals_fin[i+1]
    rel_eig[i] = np.log(rel_eig[i])
#fin for
print(rel_eig)
