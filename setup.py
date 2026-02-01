from setuptools import setup, Extension 
import numpy as np 

extra_compile_flags = ["-fopenmp"]
extra_link_flags = ["-fopenmp"]

setup(
    name = "ruspectroscopy_tools",
    version = "0.0.3",
    description = "A tool to solve the inverse problem in RUS (Resonant Ultrasound Spectroscopy) of cubic materials using Machine Learning",
    long_description = open("README.md").read(),
    long_description_content_type = "text/markdown",
    author = "Alejandro Cubillos",
    author_email = "alejandro4cm@gmail.com",
    url = "https://github.com/cubos-d/RUSpectroscopy_Tools",
    # This picks up all python files in the rusmodules directory
    packages = ["rusmodules"], 
    ext_modules = [
        Extension(
            "rusmodules.rus",
            sources = ["rusmodules/rus.c"],
            include_dirs = [np.get_include()],
            extra_compile_args = extra_compile_flags,
            extra_link_args = extra_link_flags,
        )
    ],
    # IMPORTANT: Add your runtime dependencies here
    install_requires = [
        "numpy",
        "pandas",
        "scipy",
        "matplotlib"
    ],
    classifiers = [
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    license = "MIT",
    python_requires = ">=3.12",
    setup_requires = ["numpy"],
)