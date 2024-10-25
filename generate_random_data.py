import numpy as np 
import pandas as pd
import scipy
import os 
from datamodules import preproc
from rusmodules import rus, eigenvals, geometry

if __name__ == "__main__":
    Finura = 1000
    C_rank = {"K": {"min": 0, "max": 1, "Finura": Finura}, "mu": {"min": 4, "max":9, "Finura": Finura}}
    values_test = gen_random_parameters(6, C_rank, Finura ,"Parallelepiped")
    print(pd.DataFrame(values_test))

