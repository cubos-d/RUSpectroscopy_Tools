import numpy as np
import matplotlib.pyplot as plt
from rusmodules import eigenvals

K = 7
mu = 1

C = np.array([[K + (4/3)*mu, K - (2/3)*mu, K - (2/3)*mu, 0.0, 0.0, 0.0],
              [K - (2/3)*mu, K + (4/3)*mu, K - (2/3)*mu, 0.0, 0.0, 0.0],
              [K - (2/3)*mu, K - (2/3)*mu, K + (4/3)*mu, 0.0, 0.0, 0.0],
              [0.0, 0.0, 0.0, mu, 0.0, 0.0],
              [0.0, 0.0, 0.0, 0.0, mu, 0.0],
              [0.0, 0.0, 0.0, 0.0, 0.0, mu]]) 

eta = 2*np.arccos(1/(3**0.5))
beta = 4*np.arctan(1)
eigs = eigenvals.get_eigenvalues(6, C, eta, beta, "Ellipsoid")["eig"]
#eigs[1:] = eigs[1:] * eigs[0]
eigs[0] = 1
eigs_show = eigs[:64]
fig = plt.figure()
ax1 = fig.add_subplot(111)
ax1.set_xlabel("# of eigenvalue")
ax1.set_ylabel(r"$\frac{\lambda_n}{\lambda_0}$", rotation=0, labelpad=15, fontsize = 16)
ax1.scatter(range(len(eigs_show)), eigs_show, color = "red")
plt.show()
plt.close()

Finura = 500
N_eigs = 10
min_eta = np.pi/(Finura)
max_eta = (np.pi) - min_eta
etas = np.linspace(min_eta, max_eta, Finura)
data_plots = np.zeros((N_eigs, Finura))
for i in range(Finura):
    eigs_i = eigenvals.get_eigenvalues(6, C, etas[i], beta, "Ellipsoid")["eig"][:N_eigs]
    eigs_i[1:] = eigs_i[1:] * eigs_i[0]
    data_plots[:,i] = eigs_i
#fin for
fig2 = plt.figure()
ax2 = fig2.add_subplot(111)
ax2.set_xlabel("eta")
ax2.set_ylabel(r"$\lambda$ (GPa)")
ax2.plot(etas, data_plots.T)
plt.show()
