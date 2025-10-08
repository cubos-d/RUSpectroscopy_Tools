import numpy as np
import pandas as pd
import rusmodules
import os
from rusmodules import rus
from rusmodules import eigenvals, inverse
import scipy
import matplotlib.pyplot as plt
import time
import torch
os.environ["KERAS_BACKEND"] = "torch"
import keras

np.set_printoptions(suppress = True)
shape = 0 # 0: parallelepiped, 1: cilinder, 2: ellipsoid 
alphas = (1.0, np.pi/4, np.pi/6)
alpha = alphas[shape]
"""
#Datos del FeGa
Ng = 12
rho = 7.979 #g/cm^3
nombre_archivo = 'constantesFeGa.csv'
"""

"""
#Datos del SmB6
Ng = 16
rho = 4.869 #g/cm^3
nombre_archivo = 'constantesSmB6.csv' #Mbar
"""
A = 1
#Datos del URu2Si2
Ng = 6
m = 0.1254 #g 9.84029 #9.839 #g/cm^3 
m_p = (A**3) * m
nombre_archivo = 'constant_data/constantesFeGa.csv' #Mbar


C_const = np.genfromtxt(nombre_archivo, delimiter=',', skip_header=0, dtype=float)
#geometry = np.array([0.30529,0.20353,0.25334]) #cm  FeGa
#geometry = np.array([0.10872, 0.13981, 0.01757]) #cm SmB6
#geometry = np.array([0.29605, 0.29138, 0.31034])
geometry = np.array([0.30529, 0.20353, 0.25334]) #cm URu2Si2
geometry_p = A * geometry
#vol = alpha*np.prod(geometry)
r = (sum(geometry**2))**0.5
Gamma = rus.gamma_matrix(Ng, C_const, geometry, shape)
E = rus.E_matrix(Ng, shape)
vals, vects = scipy.linalg.eigh(a = Gamma/r, b = E)
#print("Norma: ", np.linalg.norm(gamma - gamma.T))
#print("Norma: ", np.linalg.norm(E - E.T))
sq_freq = vals[6:]*(r/m)
freq = (vals[6:]*(r/m))**0.5
freq_vueltas = freq*(1/(2*np.pi))
print("Original:")
print("Eigs completos:")
print(vals[6:6+12])
vals_new = vals[6:]
vals_new[1:] = vals_new[1:]/vals_new[0]
print("Eigs relativos:")
print(vals_new[:12])
print("Frecuencias en MHz:")
print(freq_vueltas[:12])
print("!^^! !^^! Getting GPU device info !^^! !^^!")
print(torch.cuda.get_device_properties(torch.device("cuda")))
path_modelo = "notebooks/models/cubico_L4.keras"
modelo = keras.models.load_model(path_modelo)
stats_modelo = pd.read_csv(path_modelo[:-6]+"_stats.csv")
stats_modelo = stats_modelo.set_index("Unnamed: 0")
dic_stats = dict(map(lambda x: (x, dict(map(lambda y: (y, stats_modelo[y][x]),stats_modelo.keys()))), ["mean", "std"]))
modelo_datos = {"model": modelo, **dic_stats}
print("Getting results of inverse problem")
results = inverse.inverse_problem(m, freq, geometry, modelo_datos)
print(results)
print("*** SO the post-computed frequencies were: ... ****")
post_freq_hz = results["frequencies"]*(1/(2*np.pi))
print(post_freq_hz)