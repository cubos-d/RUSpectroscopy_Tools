= The inverse problem<chap:inverse_problem>

In this chapter, we will explore the training process of different machine learning models, whose purpose is to predict the variable $phi_K$ for the isotropic case and the variables $phi_Kappa$ and $phi_a$ for the cubic case. We will examine the training, testing, and validation data generation processes, and perform an exploratory analysis on them. Then, we will present different metrics that demonstrate the performance of the models in predicting their respective $phi$ values. Finally, we will show the performance of the entire pipeline proposed in @chap:transformations and summarized in @fig:diagram_inverse, fed with different models, to predict the elastic constants of different materials, from isotropic and cubic crystal families, whose values are reported in literature.

== Data generation and its analysis

Data consists of entry rows where an entry of the dataset is composed of two geometric variables, the target variables, and the relationships between the eigenvalues. In the isotropic case, each row of data is composed of a value each of $eta$, $beta$, $phi_K$, $xi_0$, $xi_1$, $xi_2$, $xi_3$, and $xi_4$. In the cubic case, each row of data is composed of a value each of $eta$, $beta$, $phi_Kappa$, $phi_a$, and 20 composition values from $chi_0$ to $chi_19$. These data were generated based on the crystal structure. 

=== Distribution of geometric variables $eta$ and $beta$<sec:eta_beta_generation>
Regardless of the crystal structure, each value of $eta$ and $beta$ was generated in such a way that it would be uniformly distributed over the surface of a sphere, where $eta$ is the polar angle and $beta$ is the azimuthal angle. 

The data was generated inside a region where $eta$ lies between 0 and $0.61 pi$ and $beta$ ranges between 0 and $pi$, as shown in @fig:geometrical_features_distribution.

#figure(
  image("../images/geo_feat_dist.png", width: 40%),
  caption: [Distribution of the features $eta$ and $beta$ over the unit sphere.]
)<fig:geometrical_features_distribution>

This uniform distribution of data over the surface of a sphere was done using the methods described in the work of Deserno #cite(<Deserno_2004>). Since during the evaluation of the inverse problem shown in @fig:diagram_inverse, we are forcing the largest dimension to be $L_z$ and the shortest dimensions to be $L_y$, every possible aspect ratio is represented as a single point inside the above mentioned region on the surface of the sphere. In other words, each aspect ratio has its unique pair of values of $eta$ and $beta$. 

For example, an aspect ratio of 3:4:5 has a value of $eta = 2 arctan(1) = 0.5 pi$ and $beta = 4 arctan(3/4) = 0.82 pi$, and an aspect ratio of 1:8:7 has a value of $eta = 2 arctan(sqrt(50)/8) = 0.46 pi$ and $beta = 4 arctan(1/7) = 0.18 pi$. Both aspect ratios have the same probability of being generated. The same can be said for every aspect ratio.

This equal representation is important because it allows a model to learn more generalized patterns, improving its performance. For example, a model trained with as dataset where 80% of its entries are composed of values of $beta < pi/2$ and 20% of its entries are composed of values of beta $beta > pi/2$ can have problems predicting data whose values of $beta$ is greater than $pi/2$. This is an example of a biased dataset. Even if we get a good model trained with tons of biased data, we can get the same good, or even a better model training it with fewer entries of balanced data, and wasting less time and computational resources in the training process.  

=== Data generation in the isotropic case<sec:data_gen_isotropic>

- Each value of $phi_K$ was uniformly distributed between 0 and $pi/2$.
- Each pair of values $eta$ and $beta$ were generated according to @sec:eta_beta_generation. 
- Each group of values from $xi_0$ to $xi_4$ were generated in the following way:
  + Get $K$ and $G$ replacing $phi_K$ into equations @eq:isotropic_K_relation and @eq:isotropic_G_relation with a value of $M = 1$.
  + Obtain $lambda_n$ replacing the values of $K$, $G$, $eta$ and $beta$ into @eq:eig_final and @eq:Peso_matrix_def.
  + Get the values of $xi_n$ dividing eigenvalues as follows: $xi_n = lambda_n/lambda_(n+1)$. 

=== Data generation in the cubic case<sec:data_gen_cubic>

- Each pair of values $eta$ and $beta$ were generated according to @sec:eta_beta_generation. 
- Each pair of values $phi_Kappa$ and $phi_a$ were generated in the same way as $eta$ and $beta$. $phi_Kappa$ and $phi_a$ are uniformly distributed over the surface of a sphere where $phi_Kappa$ is the polar angle and $phi_a$ is the azimuthal angle.
- The data was generated inside a region where $phi_Kappa$ is  between 0 and $pi/2$ and $phi_a$ is between 0 and $pi/2$, as shown in @fig:targets_distribution. Similar to the distribution of geometrical features; here, we can see that every proportion between $Kappa$, $a$ and $mu$ is equally represented in the dataset. The equal representation of the targets is as important as the equal representation of the features for the same reasons exposed in @sec:eta_beta_generation. 

#figure(
  image("../images/targets_distribution.png", width: 40%),
  caption: [Distribution of the targets $phi_Kappa$ and $phi_a$ over the unit sphere.]
)<fig:targets_distribution>

- Each group of values from $chi_0$ to $chi_19$ were generated the following way: 
  + Get $Kappa$, $a$ and $mu$ replacing $phi_Kappa$ and $phi_a$ in equations @eq:cubic_K_relation, @eq:cubic_a_relation and @eq:cubic_mu_relation, with a value of $M = 1$.
  + Perform a forward problem replacing $Kappa$, $a$ and $mu$ in equations @eq:cubic_constant_matrix_definitive, @eq:eig_final and @eq:Peso_matrix_def to get the eigenvalues $lambda_n$.
  + Get the compositions $chi_n$ from @eq:chi_definition.

=== Exploratory data analysis for the isotropic case<sec:isotropic_exploration>

The behavior of the values of $xi_n$ as a function of $phi_K$ was explored for different values of $eta$ and $beta$. @fig:pretty_sample_of_xi_vs_phiK shows this behavior for $eta = 0.31 pi$ and $beta = 0.5 pi$. 

#figure(
  image("../images/xi_exploration.png", width: 75%),
  caption: [First 5 values of $xi_n$ as a function of $phi_K$ for values of $eta = 0.31 pi$ and $beta = 0.5 pi$.]
)<fig:pretty_sample_of_xi_vs_phiK>

Plots of $xi_n$ as a function of $phi_K$ for other values of $eta$ and $beta$ are shown in @apx:phiK_plots. We can observe in @fig:pretty_sample_of_xi_vs_phiK and the figures of @apx:phiK_plots that there is no pair of values of $phi_K$ with the same  values of $xi_0$, $xi_1$, $xi_2$, $xi_3$ and $xi_4$. In other words, each value of $phi_K$ has it's unique set of the first 5 values of $xi_n$. This is the reason why only 5 values of $phi_K$ were fed into the models discussed in @sec:isotropic_results. We can also observe that the plots in @fig:pretty_sample_of_xi_vs_phiK and in @apx:phiK_plots are very similar to several ReLU functions concatenated. This is the reason why a neural network was trained as we will see later. 

A total of 252474 data entries were generated with variables distributed as described in @sec:data_gen_isotropic. In @chap:transformations we reduced redundancy of geometric variables. Now we're going to explore if there is any redundancy among all $xi_n$ values. For that purpose the correlation matrix will be calculated. As mentioned in @chap:failure every element of the correlation matrix has the Pearson product-moment correlation coefficient, which measures the lineal dependence between two features #cite(<Raschka_2022>). If any coefficient is close to 1 or -1 means that two features are heavily correlated (positively or negatively, respectively), which means that they are holding the same information. Thus, when a value close to 1 or -1 is found the dataset may carry redundant information from a pair of highly correlated features, which means that one of them can be eliminated. On the other hand, if we find correlation values close to 0, it means independence between a pair of features, which, in turn, means that every feature is holding different information that cannot be ignored.   

Let's see the correlation matrix, calculated with these data, of the features of the isotropic case:

#figure(
  image("../images/corr_matrix_isotropic.png", width: 55%),
  caption: [Correlation matrix of the features in the isotropic case.]
)<fig:correlation_matrix_isotropic>

As seen in @fig:correlation_matrix_isotropic the features have a moderate or low correlation, being the correlation of 0.55 between $beta$ and $xi_4$ the case with highest absolute value correlation. While this indicates a moderate positive linear relationship, is not high enough to suggest strong redundancy between these features. In other words although, $beta$ and $xi_4$ may share some information, they are still sufficiently independent to be considered complementary rather than redundant. This supports the inclusion of both variables in a model, as each likely contributes unique information that may improve the model's predictive performance. Given that every other pair of features have less absolute correlation, all of them will be included as well in any model to be trained. In other words, all features shown in @fig:correlation_matrix_isotropic are not redundant and will be fed in both of machine learning models studied in @sec:isotropic_results. 

Compared to the correlation matrix in @fig:corr_matrix1 the features in @fig:correlation_matrix_isotropic have lower correlation, which means that the transformed features ($xi_n$, $eta$ and $beta$) are better candidates for the prediction of their respective target than the raw features ($L_x$, $L_y$, $L_z$, $rho$ and $omega_n$). 

In addition to examining linear correlations, it is also important to evaluate nonlinear relationships between features and the target variable. This is where mutual information becomes particularly useful.

Mutual information is a measure of the amount of information that one variable contains about another variable. It is the reduction of uncertainty of one variable due to the knowledge of the other #cite(<Cover_2005>). In other words, mutual information is capable of showing the statistical dependency between the target and some feature beyond the linear approximation provided by the correlation matrix. Mutual information is given by the following expression #cite(<Cover_2005>): 

$ I = sum_y sum_x P_(x, y) ln(P_(x, y)/(P_x P_y)), $<eq:mutual_info_disc>

where $P_(x, y)$ is the joint probability between the two variables, and $P_x$ and $P_y$ are the marginal probabilities of variables $x$ and $y$ respectively #cite(<Cover_2005>). When dealing with continuous variables, we have to change the sums in @eq:mutual_info_disc for integrals and change the probabilities for probability density functions: 

$ I = integral_y integral_x rho_((x,y)) ln(rho_((x,y))/(rho_((x)) rho_((y)) )). $<eq:mutual_info_cont>

A value of zero in mutual information $I$, between a feature and the target, indicates no statistical dependency between them, meaning that the feature provides no information about the target, meaning that the target is independent from the feature. On the other hand, a high value of mutual information indicates a strong dependency between the target and the feature. By computing mutual information between each feature and the target, we can identify which features are likely to contribute most meaningfully to a predictive model.  

Now lets take a look at the mutual information between the target and the features, computed with scikit-learn, to see which one has the grater contribution to the target #cite(<scikit-learn>):

#figure(
  image("../images/MI_phiK.png", width: 60%),
  caption: [Mutual information between features and target $phi_K$ in isotropic case.]
)<fig:MI_isotropic>

We can see that, in principle, $eta$ and $beta$ hold no relation with the target with a value of near 0 in the mutual information. That was expected because data of $eta$ and $beta$ was generated independently from the data of $phi_K$. Nevertheless that doesn't mean that $eta$ and $beta$ should be discarded as a features, because $xi_n$ depend on $eta$ and $beta$, and they are necessary info for the prediction of $phi_K$. On the other hand, we can see that $xi_0$ shows the highest mutual information score with the target $phi_K$, suggesting it has the most influence on the output variable. This is also expected, since the first frequency is the one that the highest influence either in $K$ or $G$. We can see that other values of $xi_n$ also have some influence in the target, which means that it is convenient to take into account all of them when training the model.   

=== Exploratory data analysis for the cubic case

A total of 858387 data entries were generated with variables distributed as described in @sec:data_gen_cubic. As we did in the isotropic case in @sec:isotropic_exploration, we will check if there is any redundancy between the compositions $chi_n$ by computing the correlation matrix of the features, which is shown below: 

#figure(
  image("../images/corr_matrix_cubic.png", width: 70%),
  caption: [Correlation matrix of the features in the cubic model.]
)<fig:correlation_matrix_cubic>

As seen in @fig:correlation_matrix_cubic, in the cubic case the features have a moderate to low correlation, being the correlation of 0.57 between $beta$ and $chi_0$ the case with highest absolute correlation value. As well as the highest absolute correlation in isotropic case, here $beta$ and $chi_0$ may share some information, but they are still sufficiently independent to be considered complementary rather than redundant. This means it is convenient to include both variables in the model. Given that the absolute correlation between the other pairs is even lower, it is convenient to include all the features listed in @fig:correlation_matrix_cubic inside the model studied in @sec:cubic_results. We can see in general that all the features shown in @fig:correlation_matrix_cubic have low collinearity, which implies a high degree of independence.

As done in @sec:isotropic_exploration, we will identify which features contribute meaningfully to the targets in the cubic case. To to that, the mutual information between all the features and the targets $phi_Kappa$ and $phi_a$ was performed. @fig:MI_cubic shows the results of such computation:

#figure(
  image("../images/MI_phia_phiK.png", width:100%),
  caption: [Mutual information between the features and the targets in the cubic case.]
)<fig:MI_cubic>

As expected $eta$ and $beta$ have almost zero values in mutual info between them and $phi_a$, because $eta$ and $beta$ were generated independently from $phi_Kappa$ and $phi_a$. This also makes sense since the elastic constants don't depend on the dimensions of the sample, which implies that, in theory, mutual information between geometric features and elastic constants should be zero. This also happens in the isotropic case in @fig:MI_isotropic. Nevertheless $beta$ and $phi_Kappa$ have a non negligible value of mutual information, which means that there are certain ranges of combinations of  $beta$ and $phi_Kappa$ that are underrepresented. In other words, there are some holes in the spheres of @fig:geometrical_features_distribution and @fig:targets_distribution. For example, if we were going to compute mutual information between $x$ and $y$ variables in @table:MI_data_example, the result would be zero, but if we remove one data entry of the table, for example $x = 3$ and $y = 13$, and compute the mutual information again, the result would be $(1/2)(log(4/3) + log(8/9)) = 0.085$ or non-zero. This is because, in this case, the combination of $x = 3$ with $y = 13$ is underrepresented. Something similar might be happening in the dataset of the cubic case.  

#figure(
  table(
    columns: 10,
    [*$x$*], [1], [1], [1], [2], [2], [2], [3], [3], [3],
    [*$y$*], [5], [9], [13], [5], [9], [13], [5], [9], [13],
  ),
  caption: [Toy combinatorial data between two variables $x$ and $y$.]
)<table:MI_data_example>


Nevertheless the mutual information between $beta$ and $phi_Kappa$ is still lower than the majority of the values of mutual information between $phi_kappa$ and the compositions $chi_n$. On the other hand, the lowest values of $chi_n$ like $chi_0$, $chi_1$, $chi_2$ and $chi_3$ show the highest mutual information score with both targets, suggesting that they have the most influence on the output variables. This is also expected because a higher dependence between the elastic constants and the first resonance frequencies is expected. In fact, we can observe that, by far the variable with most influence on the targets is $chi_1$, and that's because $chi_1$ has information of both first and second frequency: remember that $chi_1 = (lambda_1 - lambda_0)/lambda_19 = (omega_1^2 - omega_0^2)/omega_19^2$. Both of these frequencies are expected to be highly influential in the elastic constants. Given the correlation matrix and mutual information results it is convenient to take into account all features as well.

The EDA performed in both cases, isotropic and cubic, goes to show that the variable transformations defined in @chap:transformations are highly nontrivial and physically meaningful. This will be showed in more detail below, when discussing the performance of the ML models implemented for each case. 

== Results of the isotropic model<sec:isotropic_results>

In the case of isotropic solids, two models were trained. One of them was a polynomial regression of 4th degree, and the other was a small sequential neural network. Let's see how the two performed on the transformed dataset discussed before. 

In a polynomial regression a target $y$ is modelled in terms of some features $x_i$ as a polynomial whose terms are all possible multiplications between the features up to Nth grade. The value of N is chosen as an hyperparameter. For example, in the case of a 4th polynomial degree the target $y$ is modeled in terms of the features as shown in @eq:4th_grade_poly_reg. Here, Einstein's notation is not used in order to clearly see the limits of the sums: 

$ y = sum_(i = 1)^(N_"feat") sum_(j = i)^(N_"feat") sum_(k = j)^(N_"feat") sum_(l=k)^(N_"feat") A_(i j k l) x_i x_j x_k x_l, $<eq:4th_grade_poly_reg>

where $N_"feat"$ is the number of features. 

On the other hand, the sequential neural network was made of 3 hidden layers: the first one had 64 neurons, the second one had 32 neurons and the third one had 8 neurons. The input layer had 7 neurons (same as the number of features) and the output layer had 1 neuron (representing the target $phi_K$). Initially an architecture with the following neurons in each hidden layer was chosen: 16, 10, 8. This was because this initial neural network has approximately the same number of parameters as the polynomial regression of 4th degree done before (330 parameters for the regression and 360 for the initial neural network). Then more neurons were being added until the MAE was reduced below 0.03. As we see later no overfitting was observed.  The architecture of the final neural network is shown in @fig:nn_isotropic.

#figure(
  image("../images/nn_iso.png", width:90%),
  caption: [Architecture of the neural network trained to predict $phi_K$ in the isotropic case. Image generated with NN-SVG tool #cite(<LeNail_2019>).]
)<fig:nn_isotropic>

Before any training, the target was scaled in a way it had values between 0 and 1, as follows: 

$ tilde(phi)_K = phi_K/(pi/2). $<eq:target1_normalized>

A difference between a value $tilde(phi)_K^("real")$ and a predicted value $tilde(phi)_K^("predicted")$ can be interpreted as the error relative to the domain of $phi_K$. For example, a difference of 0.02 means that the predicted value has a deviation of 2% of $pi/2$. In other words a deviation of 2% of $phi_K$'s domain. This way the Mean Absolute Error (MAE) can be seen as the deviation in the prediction of the model given in pieces of the target's domain, or as an angular error. For example, a MAE of 0.02 means that the model is deviated 0.02 domains ($0.02 * pi/2$) or has an error of 1.8 degrees in average. In a similar way the RMSE can be interpreted as the root square deviation given in pieces of domains, on average. MAE and Root Mean Square Error (RMSE) are defined in @chap:failure.

=== Results of the polynomial regression

Fitting $phi_K$ in terms of the features $eta$, $beta$, $xi_0$, $xi_1$, $xi_2$, $xi_3$and $xi_4$ with a polynomial of 4th degree was done splitting 80% of the data for training and 20% for testing. 
 
The performance metrics of the model are shown in the following table: 
#figure(
  table(
    columns: 3,
    [], [*Train*], [*Test*],
    [*MAE*], [0.093], [0.094],
    [*RMSE*], [0.128], [0.201],
    [*$R^2$*], [0.80], [0.51],
  ),
  caption: [Results of the linear regression model.]
)<table:linear_resgression_results>

As we can see here, the values of $R^2$ and RMSE tells us that the model is overfitting, and still the target has an average error of 9% of $pi/2$ or 9% of the domain of $phi_K$, which can be further improved. Nevertheless this model was able to predict its target with similar performance metrics as the best model shown in @chap:failure. In fact this model was tested also with the data generated to train and test the first polynomial model, shown in @chap:failure, and the performance metrics for the prediction of $phi_K$ were: $"MAE" = 0.084$ and $R^2 = 0.78$. The model with shortest MAE shown in @chap:failure had a test MAE value of $0.337 "Tdyn"/"cm"^2$ which is 6% of its domain (6% of $5.3 "Tdyn"/"cm"^2)$, which is 3% below the percentage error of the polynomial regression model. Nevertheless, the best model of @chap:failure was a complex random forest model fed with polynomial features of degree 3, while this model is just a linear regression fed with polynomial features of degree 4. In other words a very complex model outlined in @chap:failure is having similar metrics as a simple polynomial model shown here. This proves that the feature and target transformations proposed in @chap:transformations are able to improve any model drastically. Now we're going to see the performance of a neural network. 


=== Results of the neural network

Splitting 60% of the data for training, 20% for validation and 20% for testing, the sequential neural network described in @fig:nn_isotropic was trained. The activation function of all input layers was ReLu and the activation of the last layer was the following custom function: 

$ g(x) = (1/N) log((1 + e^(N x))/(1 + e^(N (x-1)))). $

This function was chosen because it returns values between 0 and 1, and is similar to $y = x$ when $x$ is between 0 and 1, close to 0 if $x < 0$ and 1 if $x > 1$ for large values of $N$. The highest possible value of $N$ was chosen, which was $N=20$. Values of $N gt.eq 21$ yielded to NaN metrics during the training. This way the target was going to have values between 0 and 1. However, as we will see later in the cubic case, the hard sigmoid performs better because it has a similar behavior but makes the training a lot faster and doesn't yield to NaN values during training.  

The training of the model was performed using Keras 3.0 #cite(<keras>) in Python, using Torch #cite(<torch>) as backend with an AMD 6600M GPU. It took 72 minutes to complete the training. Full system specifications of the PC used to train the models can be seen in @apx:specs. The learning rate and batch size were tuned monitoring the MSE and RMSE in the first 5 epochs during the training of the model. A learning rate of 0.0005 and batch size of 16 ensured smooth and stable updates, fast convergence and 41 second of training per epoch, as shown in @fig:train_history_isotropic. Default values of learning rate of 0.001 and batch size of 32 yielded a faster training, but a slightly slower convergence. Batches under 16 yielded to large training times with very little enhancement in convergence.  

The performance metrics of this model are shown in @table:NN1_results: 

#figure(
  table(
    columns: 4,
    [], [*Train*], [*Validation*], [*Test*],
    [*MAE*], [0.024], [0.024],  [0.024],
    [*RMSE*], [0.038], [0.039], [0.040],
    [*$R^2$*], [0.982], [0.981],  [0.980],
  ),
  caption: [Results of the small sequential neural network.]
)<table:NN1_results>

@table:NN1_results presents the performance metrics of the trained neural network on the training, validation, and test datasets. The results are highly consistent across all three sets, indicating that the model generalizes well and is not overfitted. The Mean Absolute Error (MAE) remains at approximately 0.024 in all datasets. Since the target variable $tilde(phi)_K$ corresponds to $phi_K/(0.5 pi)$, this translates to an average angular prediction error of approximately $0.012 pi$ radians, or around 2.16 degrees, which is a very small deviation given that $phi_K$ ranges from 0 to $pi/2$.

The Root Mean Square Error (RMSE) values are similarly low, reinforcing the model’s accuracy, while the $R^2$ scores remain above 0.98 in all cases. This indicates that over 98% of the variance in the target variable is being captured by the model — a strong sign of model performance, especially given the compact architecture and relatively small input size (only 7 features).

These results demonstrate that the neural network is capable of reliably estimating the angle $phi_K$ from the input features with both high precision and robust generalization across unseen data.

#figure(
  image("../images/train_val_history_isotropic.png", width: 70%),
  caption: [Train history of the neural network model in the isotropic case. As it can be seen there is no sign of overfitting.]
)<fig:train_history_isotropic>

@fig:train_history_isotropic shows the evolution of the Mean Absolute Error (MAE) for both the training and validation sets across epochs. Overall, both curves exhibit a consistent downward trend, indicating that the model is effectively learning and improving its predictive accuracy over epochs. The validation MAE closely follows the training MAE throughout the training process, with only minor fluctuations. This behavior suggests that the model is not overfitting and is generalizing well to unseen data. The slight oscillations observed in the validation curve are expected due to the stochastic nature of training with a small batch size. Notably, even in the later epochs, the validation MAE continues to improve, albeit at a slower rate, indicating that the model may not have fully converged. 

//Presentar las graficas que muestran los valores del phi_K predicho con los datos combinatoriales. 

== Results of the cubic model<sec:cubic_results>

In the case of cubic solids, only one model was trained: a feed-forward neural network with an architecture represented in the following piece of code: 

#figure(
  table(
    columns: 1, 
  [```Python
    modelo = keras.models.Sequential()
    modelo.add(keras.layers.Dense(256, activation = def_act, 
      input_shape = (n_input_data,)))
    modelo.add(keras.layers.Dense(1024, activation = def_act))
    modelo.add(keras.layers.Dense(1400, activation = def_act))
    modelo.add(keras.layers.Dense(2490, activation = def_act))
    modelo.add(keras.layers.Dense(6333, activation = def_act))
    modelo.add(keras.layers.Dense(6295, activation = def_act))
    modelo.add(keras.layers.Dense(2566, activation = def_act))
    modelo.add(keras.layers.Dense(2004, activation = def_act))
    modelo.add(keras.layers.Dense(1086, activation = def_act))
    modelo.add(keras.layers.Dense(700, activation = def_act))
    modelo.add(keras.layers.Dense(384, activation = def_act))
    modelo.add(keras.layers.Dense(64, activation = def_act))
    modelo.add(keras.layers.Dense(2, activation = 'hard_sigmoid'))
    modelo.compile(optimizer = keras.optimizers.Adam(learning_rate = lr_var), 
      loss = 'mse', metrics = ['mae']) 
  ```
    ],
  ),
  caption: [Architecture of the neural network used to predict the targets $phi_Kappa$ and $phi_a$ of a cubic crystal.]
)<code:nn_cubic>

Every line of ```Python modelo.add(keras.layers.Dense(N_neurons, activation)``` in @code:nn_cubic indicates the addition of a new layer, with the number of neurons as its first argument and the activation function as the second argument. Every one of the hidden layers in the model has ReLU as its activation function (```Python def_act = 'relu'```) and the output layer has a hard sigmoid as its activation function. 

Before any training, the target variables in the cubic case were modified like $phi_K$ in the isotropic case: 

$ tilde(phi)_Kappa = phi_Kappa/(pi/2); tilde(phi)_a = phi_a/(pi/2). $<eq:targets_normalized>

This guarantees that the new targets are in the range between 0 and 1. Just like the isotropic case, any difference between a real value of $tilde(phi)_Kappa$ or $phi_a$ can be interpreted as the error in pieces of domain of $phi_Kappa$ or $phi_a$. This way, the MAE is the average value of this error. In a similar way RMSE can be interpreted as the root squared deviation given in pieces of domains, of given in units $pi/2$, on average. Here, fitting $tilde(phi)_Kappa$ and $tilde(phi)_a$ in terms of the features $eta$, $beta$ and the compositions from $chi_0$ to $chi_19$ was done splitting 76% of the data for training, 12% of the data for validation and 12% of the data for testing. This split was used to allocate more data to training, given the significantly larger and more complex architecture of the model. The training of the model was performed using Keras #cite(<keras>). The hardware specifications are the same as the training of the neural network in the isotropic model and can be found in @apx:specs. The learning rate was kept the same (```Python lr_var = 0.0005```) as the learning rate of the neural network in the isotropic model, as there was no need to modify it. The batch size was increased to 160 given that the cubic case has 3.4 more data entries than the isotropic case, so this number had to be increased in order reduce the training time.

The results of the model are shown in @table:NN2_results:

#figure(
  table(
    columns: 4,
    [], [*Train*], [*Validation*], [*Test*],
    [*MAE*], [0.018], [0.028],  [0.028],
    [*RMSE*], [0.036], [0.061], [0.062],
    [*$R^2$*], [0.973], [0.924],  [0.922],
  ),
  caption: [Results of the sequential neural network in the cubic case.]
)<table:NN2_results>

The model achieves a Mean Absolute Error (MAE) of 0.018 on the training set and 0.028 on both the validation and test sets. This indicates that the model predicts each angle with an average error of approximately $0.014 pi$ radians, or roughly 2.52 degrees, which is a very small angular error given the full possible range of $phi_Kappa$ or $phi_a$. The RMSE values further support this, with values of 0.036 for training and approximately 0.061 and 0.062 for validation and test sets, suggesting that larger individual errors are rare but do occur slightly more in unseen data.

The $R^2$ score is 0.973 on the training set, dropping to 0.924 on the validation set and 0.922 on the test set. This drop, along with the increase in MAE and RMSE, indicates that the model has begun to slightly overfit to the training data. This is consistent with the learning curve behavior that can be observed in @fig:train_history_cubic, where a small divergence between training and validation error was noted in the later epochs.

#figure(
  image("../images/train_val_history.png", width: 70%),
  caption: [Train history of the neural network in the cubic case. The plot behavior in the final epochs suggests mild overfitting. Nevertheless its generalization capabilities remain strong.]
)<fig:train_history_cubic>

The overall trend demonstrates successful learning, with both training and validation MAE decreasing significantly during the early epochs. However, in the later stages of training, a slight divergence begins to emerge between the training and validation curves. While the training MAE continues to decrease steadily, the validation MAE begins to plateau and exhibits minor fluctuations. This behavior suggests the onset of mild overfitting, where the model starts to learn patterns specific to the training data that do not generalize perfectly to unseen data.

This is not unexpected given the very large capacity of the model, with millions of parameters and no explicit regularization mechanisms such as dropout, weight decay, or early stopping, the network can easily begin to memorize training data. Despite this, the final validation MAE remains very low (around 0.028), corresponding to an angular error of approximately $0.014 pi$ radians or 2.43 degrees, which is still highly accurate given the scale of the target. Given the small divergence between the train MAE and validation MAE in @fig:train_history_cubic none of the mentioned regularization methods were used. 

== Performance of the whole pipeline of the inverse problem

The previous section (@sec:cubic_results) presented the performance of a model able to predict $phi_Kappa$ and $phi_a$. Nevertheless the main objective of the inverse problem, in the cubic case, is to predict the elastic constants. To do that it is necessary to follow the steps described in @sec:cubic_targets or, in other words, place the neural network model inside the "Predict" box inside the pipeline described in @fig:diagram_inverse. This pipeline can be evaluated with some reported values of elastic constants of cubic materials reported by Fukuda et al #cite(<Fukuda_2023>), which also trained a model to predict the cubic elastic constants. This means that we can evaluate the present work pipeline with those constants and also compare this approach with Fukuda et al's model. 

To evaluate the pipeline a forward problem was performed (getting the eigenvalues $lambda_n$) on every material reported in @apx:cubic_constants, with an aspect ratio of the sample of 3:4:5, which is the aspect ratio where the Fukuda et al's model was trained. Then for every material, the elastic constants were predicted with the pipeline. All the predicted elastic constants can be found in @table:reported_and_predicted_constants_p1, @table:reported_and_predicted_constants_p2, @table:reported_and_predicted_constants_p3 and @table:reported_and_predicted_constants_p4 inside @apx:cubic_constants. With both the reported elastic constants and the predicted constants, a value of non-absolute percentage error $"NaErr"$ (which was the metric used by Fukuda et al #cite(<Fukuda_2023>)) and a value of absolute percentage error $"AbsErr"$ was calculated the following way: 

$ "NaErr" = 100 times (C_(i j)^("reported") - C_(i j )^("predicted"))/C_(i j)^("reported"), $<eq:non_absolute_error>

where $C_(i j)$ is any of the three elastic constants and,

$ "AbsErr" = abs("NaErr"). $

The average and the standard deviation were calculated for the predictions of the Fukuda et al's model and the predictions of the present work pipeline in @table:Fukuda_comparison. Note that the average of $"AbsErr"$ is no other than the MAPE (Mean Absolute Percentage Error) defined in @chap:failure. All the calculated errors ($"NaErr"$) for each material can be found in @table:errors_p1, @table:errors_p2, @table:errors_p3 and @table:errors_p4 inside @apx:cubic_constants.

#figure(
  table(
    columns: 7,
    [], [*$C_11$ mean*], [*$C_11$ std*], [*$C_12$ mean*], [*$C_12$ std*], [*$C_44$ mean*], [*$C_33$ std*],
    [*$"AbsErr"$ PP*], [4.14], [3.87],  [8.31], [8.50], [2.44], [2.86],
    [*$"AbsErr"$ Fukuda et al*], [5.15], [5.36], [10.90], [11.94], [7.78], [12.92],
    [*$"NaErr"$ PP*], [-1.94], [5.32],  [-2.68], [11.58], [-0.13], [3.75],
    [*$"NaErr"$ Fukuda et al*], [1.13], [7.35], [2.31], [16.00], [-0.71], [15.07],
  ),
  caption: [Comparison between the mean percentage errors and its standard deviations between the present work's pipeline and Fukuda et al's model #cite(<Fukuda_2023>). The rows with "PP" mean Present Pipeline.]
)<table:Fukuda_comparison>

@table:Fukuda_comparison shows that all values of MAPE are lower for the present pipeline, with lower standard deviations. That means that the present pipeline has more predictive power than Fukuda et al's model, which was trained with more powerful hardware (Fukuda's Nvidia RTX 3090 vs the Radeon 6600M of the present work), more data (3672000 of data entries in Fukuda's work vs 656414 data entries of the present work), and more eigenvalues (100 eigenvalues in Fukuda's case and 20 eigenvalues in the present work). Also box plots showing the quantiles of $"NaErr"$ and $"AbsErr"$ are shown in @fig:box_plot_nonabs_error and @fig:box_plot_abs_error:

#figure(
  image("../images/box_plot_result1.png", width: 70%),
  caption: [Quantiles of the non absolute percentage errors of the predicted constants of Fukuda et al's model and present pipeline. "PP" means Present Pipeline. ]
)<fig:box_plot_nonabs_error>

#figure(
  image("../images/box_plot_result2.png", width: 70%),
  caption: [Quantiles of the absolute percentage errors of the predicted constants of Fukuda et al's model and present pipeline. "PP" means Present Pipeline. ]
)<fig:box_plot_abs_error>

Both box plots shows evidence of similar predicting power of $C_11$ constant in both models (Fukuda et al's model and present pipeline). Here Fukuda et al's model is slightly superior. Nevertheless the predicting power of the other two constants is superior in the present pipeline according to @fig:box_plot_nonabs_error and @fig:box_plot_abs_error.

In summary the present pipeline is able to predict the cubic elastic constants with smaller errors than Fukuda el at's model, having less resources and time during training. Also the present pipeline is able to predict the elastic constants of every parallelepiped sample despite its proportions. This was achieved thanks to the fact that the present pipeline uses a model that predicts targets in a well defined range (all of them are between 0 and $pi/2$) and following the restrictions of thermodynamic stability mentioned in @chap:elastic_theory, while Fukuda et al's model doesn't follow those restrictions. 

To see how the predictions of the present pipeline compare to the reported values of the elastic constants, a scatter plot of the reported constant vs the predicted constants was made for each of the three independent elastic constants: 

#figure(
  image("../images/c_xx_predictions.png", width: 95%),
  caption: [Reported values in $x$ axis vs predicted values in $y$ axis.]
)<fig:cxx_predictions>

We can observe in @fig:cxx_predictions that the present pipeline has strong predictive power for low values of $C_11$, between 0 and 300 GPa. The predicting power for greater values fades the grater the value of $C_11$ is. This might be because, after predicting $phi_Kappa$ and $phi_a$ values, when using equation @eq:M_determination_cubic, the errors scale with $lambda_0$, which is proportional to any of the elastic constants. In other words, one can have the same error in $cos(phi_Kappa)$, for example, regardless the value of $C_11$, but $M$ in equation @eq:cubic_K_relation is greater when the constants are greater, which yields to a bigger error in $K$.  


The prediction of the $C_12$ constant is the most challenging one for the present pipeline, as shown in @fig:cxx_predictions. There is lots of points of data distant from the line $y = x$. This might be because $C_12$ has information about both shear and bulk stresses. Also, $C_12$ is carrying the error of two predictions: $K$ and $a$.


On the other hand $C_44$ is the easiest constant for the present pipeline to predict. This might be because it only carries the prediction error of $mu$, and also, is has only information about shear stresses, which are typically lower than bulk stresses. We can observe in @fig:cxx_predictions that almost all the point are over the line $y = x$, which means an almost perfect prediction of this constant.

Finally is worth to mention that the codes made to generate the data, visualize data, train the models and evaluate the models make extensive use of the following Python libraries:
- numpy #cite(<numpy>) 
- pandas #cite(<pandas>) 
- matplotlib #cite(<matplotlib>)
- scipy #cite(<scipy>)
- scikit-learn #cite(<scikit-learn>)
