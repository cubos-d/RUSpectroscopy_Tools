import numpy as np
import matplotlib.pyplot as plt
from rusmodules import eigenvals

shape = "Parallelepiped"
phia = np.arctan(1)
phiK = np.arctan(4/3)
phis = {"phi_a": phia, "phi_K": phiK}
eta = np.pi/2
beta = np.pi
Ng1 = 6
Ng2 = 20
eigs_6 = eigenvals.forward_standard(phis, eta, beta, shape, Ng1)["eig"][:20]
eigs_20 = eigenvals.forward_standard(phis, eta, beta, shape, Ng2)["eig"][:20]
eigs_6[1:] = eigs_6[0]*eigs_6[1:]
eigs_20[1:] = eigs_20[0]*eigs_20[1:]

errors = np.abs(eigs_6 - eigs_20)/eigs_20
print(errors)
