= Introduction<chap:introduction>

Ultrasonic measurements have long been a valuable tool in the study of condensed matter. They enable the determination of a material’s elastic constants, which are fundamentally important as they are directly linked to the atomic structure. Moreover, these constants are related to the thermal properties of solids through Debye theory. When combined with thermal expansion measurements, elastic constants can also be used to derive the equation of state for various thermodynamic functions #cite(<Leisure_1997>).

One of the experimental techniques used to obtain the elastic constants of a solid is Resonant Ultrasound Spectroscopy (RUS). This method involves placing a solid sample between two piezoelectric transducers, which hold the sample at two of its edges #cite(<Migliori_1993>). For solids with well-defined geometries—such as cubes or parallelepipeds—the transducers typically contact two of the sample’s vertices, as illustrated in @fig:rus_setup. This configuration ensures that the sample maintains free boundary conditions during the measurement.

In RUS, the sample is usually shaped into simple geometries like parallelepipeds, cylinders, or ellipsoids. The technique does not directly measure the elastic constants. Instead, it captures the resonance frequencies of the sample. To acquire these frequencies, the first transducer excites the sample by oscillating at a given frequency, subjecting it to periodic compression and release. A frequency sweep is performed across a range, and the second transducer detects the response. When the driving frequency matches a natural resonance frequency of the sample, the second transducer registers an amplified signal #cite(<Leisure_1997>). The experimental setup is shown in the following figure:

#figure(
  image("../images/rus_setup.png", width: 35%),
  caption: [Setup of the RUS technique, taken from #cite(<Lakes_2004>).]
) <fig:rus_setup>

If the elastic constants of the material are known in advance, the resonance frequencies can be readily predicted by solving a generalized eigenvalue problem (as presented in @eq:raw_eig_problem), which will be described in detail in @chap:forward. The process of computing the resonance frequencies from the elastic constants, the mass, and the geometry of the sample is summarized in @fig:diagram:forward and is known as the forward problem:

#figure(
  image("../images/Forward Diagram.png", width: 60%),
  caption: [Inputs and outputs of the Forward problem.]
) <fig:diagram:forward>

In contrast, the inverse problem consists of determining the elastic constants from the resonance frequencies, the mass, and the geometry of the sample, as illustrated in @fig:diagram_inverse_basic. Solving this inverse problem for cubic solids using a machine learning approach is the main objective of this work.

Traditionally, the inverse problem has been addressed through iterative methods that repeatedly solve the forward problem until the elastic constants that minimize the error between the measured and computed frequencies are found. One such method is the Levenberg–Marquardt algorithm, a nonlinear least-squares optimization technique #cite(<Fukuda_2023>). However, this method presents notable limitations. First, it can be computationally intensive. Second, it requires a good initial guess for the elastic constants, meaning that some prior knowledge or approximation of the constants must be available before the method can converge reliably #cite(<Fukuda_2023>).

#figure(
  image("../images/Inverse_diagram_basic.png", width: 60%),
  caption: [Summary of the parts that make up the approach of the inverse problem in this work.]  
) <fig:diagram_inverse_basic>

A fast and reliable method for solving the inverse problem—one that does not require a close initial guess—is highly desirable. In this context, machine learning (ML) offers a promising alternative. ML models can learn complex relationships between input features (such as resonance frequencies and geometric parameters) and target variables (such as elastic constants), making them suitable for addressing inverse problems in physical systems.

Several previous studies have explored the use of machine learning techniques to predict elastic constants. For instance, Li et al. developed a model to predict the elastic constants of orthotropic steel sheets #cite(<Li_2024>), Liu et al. trained a convolutional neural network to estimate the elastic properties of yttrium–aluminum–garnet (YAG) ceramic samples #cite(<Liu_2023>), and Rossin et al. applied Bayesian inference to predict the elastic constants of cobalt–nickel superalloys #cite(<Rossin_2021>). However, these models were tailored to specific materials and did not offer general applicability.

To the best of our knowledge, the only work that proposed a general model capable of predicting the elastic constants for arbitrary cubic materials was the study by Fukuda et al. #cite(<Fukuda_2023>). This work serves as the primary reference and benchmark for this study.

In 2023, Fukuda et al. developed a series of models to solve the inverse problem for solids with a cubic crystal structure and a parallelepiped shape having a fixed aspect ratio of 3:4:5 #cite(<Fukuda_2023>). Their approach involved transforming each resonance frequency spectrum—comprising 100 frequency values—into an image. This image was then fed into a convolutional neural network (CNN) trained to classify the spectrum into one of 16 predefined groups, each corresponding to a specific range of possible elastic constant ratios. After classification, the spectrum was passed to a regression model corresponding to its assigned group to predict the elastic constants #cite(<Fukuda_2023>).

This work introduces a more general method that can handle samples with any aspect ratio, while using only 20 frequencies instead of 100. The theoretical foundation required to understand this approach begins with a review of the theory of elasticity in solids, presented in @chap:elastic_theory. The formulation and numerical implementation of the forward problem—used to compute resonance frequencies from known elastic constants—is described in detail in @chap:forward. The exploratory data analysis (EDA) and initial modeling attempts, including linear and polynomial regression methods, are discussed in @chap:failure, and they highlight the challenges that motivated the development of a more robust strategy. The details of the proposed inverse problem approach, including the variable transformations and model architecture, are presented in @chap:transformations and @chap:inverse_problem. The results and performance of the model developed in this work for predicting the elastic constants of cubic materials are evaluated and discussed in @chap:inverse_problem. In @chap:conclusions_outlook we summarize the main results of this work, and propose potential and interesting avenues of future research.  
