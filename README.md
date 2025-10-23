# RUSpectroscopy_tools

Some functions for solving forward and inverse problems in Resonant Ultrasound Spectroscopy. 

### Forward:
A C extension module for getting the resonance frequencies given the estic constants, the dimension and the shpe of the sample.

### Inverse
Uses a neural network model to get the constants of a cubic (more complex crystal structures coming soon) solid 
(parallelepiped shape, other shapes comming soon) given the dimensions and 20 resonence frequencies. No rotations supported yet. 

## Authors

- Alejandro Cubillos - alejandro4cm@outlook.com/ja.cubillos10@uniandes.edu.co
- Julián Rincón 

If any of the following code is useful to you please cite: 
Cubillos Muñoz, J.  (2025).  A machine learning approach to the inverse problem in resonant ultrasound spectroscopy of cubic and isotropic solids.    Universidad de los Andes.  Available at: https://hdl.handle.net/1992/77055

## Installation 
```bash
pip3 install ruspectroscopy-tools
```
## Import: 
```python
from rusmodules import rus
```

## Forward Problem Usage:

### Getting the resonance frequencies from the elastic constants: 
```python
from rusmodules import eigenvals 

frequencies = eigenvals.forward_problem(m, C, dimensions, N, shape)
```

Where:
* m <float> Is the mass of the sample
* N <int> represents the maximim grade of the polynomials of the basis functions (default: 6)
* C <np.array> 6x6 matrix with the elastic constants
* dimensions <np.array> (3,) shape array containing the dimensions of the sample: [Lx, Ly, Lz]
* shape <str> Currently supports "Parallelepiped", "Cylinder" and "Ellipsoid"

### Getting the elastic constants from the resonence frequencies: 
```python
from rusmodules import inverse

inverse_data = inverse.inverse_problem(m, omega, dimensions, model_data)
```

Where: 
* m <float> Is the mass of the sample
* omega <np.array> Resonance omegas (frequencies in radians NOT in Hz)
* dimensions <np.array> (3,) shape array containing the dimensions of the sample: [Lx, Ly, Lz]
* model_data <dict> A dictionary containing the machine learning model and statistics of the training data that was used to generate the model. 

The machine learning models can be found in hugging face: [TODO: Upload the models to hugging face] and the statistics of each model can be found in https://github.com/jacubillos10/RUSpectroscopy_Tools/tree/develop/notebooks/models.  

### Inverse Problem example usage
```python
import os
import numpy as np
from rusmodules import inverse
import torch
os.environ["KERAS_BACKEND"] = "torch"
import keras
import pandas as pd
m = 0.1254 #g
path_model = "~/models/cubico_L4.keras" #Local path where the .keras model is stored
model = keras.models.load_model(path_model)
omega = [0.24020712, 0.26393711, 0.27870822, ...]
dimensions = np.array([0.30529, 0.20353, 0.25334])
training_mean = {"eta": 1.18, "beta": 1.57, "x_0": 0.04, "x_1": 0.03, ...} #Mean values of training data
training_std = {"eta": 0.46, "beta": 0.91, "x_0": 0.05, "x_1": } #Standard deviation values of training data
model_data = {"mean": training_mean, "std": training_std, "model": model}
inverse_data = inverse.inverse_problem(m, omega, dimensions, model_data)
```

The dictionary that returns inverse_problem function looks like this:
```python
inverse_data = {'constants': {'C00': np.float64(1.30054267050163), 'C01': np.float64(1.1006489848946313), 'C33': np.float64(0.8854417640647991)}, 'MAE': np.float64(0.02978091807048346), 'frequencies': array([1.50926584, 1.65836575, 1.75117538, 2.01686081, 2.06256988,
       2.19098222, 2.34152748, 2.8107501 , 2.89962897, 2.90586193,
       2.98053128, 3.01687171, 3.04870302, 3.0491472 , 3.11933117,
       3.54120588, 3.65460307, 3.69446139, 3.75998903, 3.78313654])}
```
The returned frequencies in radians (NOT Hz) are the ones to compare to the original frequencies. MAE is the mean absolute error between the experimental frequencies and the computed frequencies (both in radians) from the predicted constants. 

