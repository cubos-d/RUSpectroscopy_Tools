# RUSpectroscopy_tools

- A tool to solve the inverse problem in RUS (Resonant Ultrasound Spectroscopy) of cubic materials using Machine Learning.

- Model used for the tool available at [HuggingFace](https://huggingface.co/Cubos/InverseRUS).

- Solves forward problem also using all your CPU cores (written in C). Working on support for GPU

## Forward

A C extension module for getting the resonance frequencies given the estic constants, the dimension and the shpe of the sample.

## Inverse

Uses a neural network model to get the constants of a cubic (more complex crystal structures coming soon) solid
(parallelepiped shape, other shapes comming soon) given the dimensions and 20 resonence frequencies. No rotations supported yet.

## Authors

- Alejandro Cubillos - [mail1](alejandro4cm@gmail.com) [mail2](ja.cubillos10@uniandes.edu.co)
- Julián Rincón

If the tool or any of the code is useful to you please cite:

Cubillos Muñoz, J.  (2025).  A machine learning approach to the inverse problem in resonant ultrasound spectroscopy of cubic and isotropic solids.    Universidad de los Andes.  Available at: [Repositorio Seneca Uniandes](https://hdl.handle.net/1992/77055)

## Installation

```bash
pip3 install ruspectroscopy-tools
```

## Import

```python
from rusmodules import rus
```

## Forward Problem Usage

### Getting the resonance frequencies from the elastic constants

```python
from rusmodules import eigenvals 

frequencies = eigenvals.forward_problem(m, C, dimensions, N, shape)
```

Where:

- m (float) Is the mass of the sample

- N (int) represents the maximim grade of the polynomials of the basis functions (default: 6)

- C (np.array) 6x6 matrix with the elastic constants

- dimensions (np.array>) (3,) shape array containing the dimensions of the sample: [Lx, Ly, Lz]

- shape (str) Currently supports "Parallelepiped", "Cylinder" and "Ellipsoid"

## Inverse problem usage

### Getting the elastic constants from the resonence frequencies

```python
from rusmodules import inverse

inverse_data = inverse.inverse_problem(m, omega, dimensions, model_data)
```

Where:

- m (float) Is the mass of the sample

- omega (np.array) Resonance omegas (frequencies in radians NOT in Hz)

- dimensions (np.array) (3,) shape array containing the dimensions of the sample: [Lx, Ly, Lz]

- model_data (dict) A dictionary containing the machine learning model and statistics of the training data that was used to generate the model.

The machine learning models can be found in hugging face: [Cubos/HuggingFace](https://huggingface.co/Cubos/InverseRUS/tree/main) and the statistics of each model can be found in [Means and Averages of the feeding](https://github.com/cubos-d/RUSpectroscopy_Tools/tree/develop/notebooks/models).  

### Inverse Problem example usage

To use the model you must download it from huggingFace and store it in you preferred location i.e: **./models/**:

```bash
mkdir models
wget https://huggingface.co/Cubos/InverseRUS/resolve/main/cubico_L4.keras
```

To use the model trained in this work you can follow this example.
The stats of the training data of the model can be found at [repo/notebooks/models/cubico_L4.csv](https://raw.githubusercontent.com/cubos-d/RUSpectroscopy_Tools/refs/heads/develop/notebooks/models/cubico_L4_stats.csv).

```python
import os
import numpy as np
from rusmodules import inverse
import torch
os.environ["KERAS_BACKEND"] = "torch"
import keras
import pandas as pd

m = 0.1254 #g
path_model = "models/cubico_L4.keras"
stats_model = pd.read_csv("https://raw.githubusercontent.com/cubos-d/RUSpectroscopy_Tools/refs/heads/main/notebooks/models/cubico_L4_stats.csv")
stats_model = stats_model.set_index("Unnamed: 0")
dic_stats = dict(map(lambda x: (x, dict(map(lambda y: (y, stats_model[y][x]),stats_model.keys()))), ["mean", "std"]))
model = keras.models.load_model(path_model)
omega = [1.50926584, 1.65836575, 1.75117538, 2.01686081, 2.06256988,
       2.19098222, 2.34152748, 2.8107501 , 2.89962897, 2.90586193,
       2.98053128, 3.01687171, 3.04870302, 3.0491472 , 3.11933117,
       3.54120588, 3.65460307, 3.69446139, 3.75998903, 3.78313654] #This must be a list of 20 values all in units of radians
dimensions = np.array([0.30529, 0.20353, 0.25334]) #cm
model_data = {**dic_stats, "model": model}
inverse_data = inverse.inverse_problem(m, omega, dimensions, model_data)
```

The dictionary that returns inverse_problem (inverse_data) function looks like this:

```python
{
       'constants': {
              'C00': np.float64(1.30054267050163), 
              'C01': np.float64(1.1006489848946313), 
              'C33': np.float64(0.8854417640647991)
       }, 
       'MAE': np.float64(0.02978091807048346), 
       'frequencies': array([1.52869445, 1.67824553, 1.77995932, 
        2.04882852, 2.09089336, 2.226468  , 2.35439033, 2.75882012, 
        2.85318217, 2.93387907, 3.00654262, 3.0245675 , 3.04501862, 
        3.05716655, 3.06015376, 3.5581114 , 3.56426523, 3.65992212, 
        3.69013139, 3.75229874])
}
```

The returned frequencies in radians (NOT Hz) are the ones to compare to the original frequencies. MAE is the mean absolute error between the experimental frequencies and the computed frequencies from the predicted constants.
