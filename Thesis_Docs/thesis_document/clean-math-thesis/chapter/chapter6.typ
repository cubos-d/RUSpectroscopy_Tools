= The inverse problem

In this chapter, we will explore the training process of different models, whose purpose is to predict the variable $phi_K$ for the isotropic case and the variables $phi_Kappa$ and $phi_a$ for the cubic case. We will examine the training, testing, and validation data generation processes, and perform an exploratory analysis of them. Then, we will present different metrics that demonstrate the performance of the models in predicting their respective phi values. Finally, we will show the performance of the entire pipeline proposed in @chap:transformations and summarized in @fig:diagram_inverse, fed with different models, to predict the elastic constants of different materials whose values are reported in literature.

== Data generation and its analysis

Each row of values representing a piece of data is composed of two geometric variables, the target variables, and the relationships between the eigenvalues. In the isotropic case, each row of data is composed of a value each of $eta$, $beta$, $phi_K$, $xi_1$, $xi_2$, $xi_3$, $xi_4$, and $xi_5$. In the cubic case, each row of data is composed of a value each of $eta$, $beta$, $phi_Kappa$, $phi_a$, and 20 composition values from $chi_0$ to $chi_19$. These data were generated based on the crystal structure and the nature of the variables themselves.

=== Distribution of geometric variables $eta$ and $beta$<sec:eta_beta_generation>
Regardless of the crystal structure, each value of $eta$ and $beta$ was generated in such a way that it would be uniformly distributed over the surface of a sphere, where $eta$ is the polar angle and $beta$ is the azimuthal angle, in the region where $eta$ is between 0 and $0.61 pi$ and $beta$ is between 0 and $pi$, as shown in @fig:geometrical_features_distribution.

#figure(
  image("../images/geo_feat_dist.png", width: 40%),
  caption: [Distribution of the features $eta$ and $beta$.]
)<fig:geometrical_features_distribution>

This way each possible aspect ratio (relation between $L_x$, $L_y$ and $L_z$) has equal representation in the data set. 

=== Data generation in isotropic case<sec:data_gen_isotropic>

- Each value of $phi_K$ was uniformly distributed between 0 and $pi/2$.
- Each pair of values $eta$ and $beta$ were generated according to @sec:eta_beta_generation. 
- Each group of values from $xi_0$ to $xi_4$ were generated the following way:
  + Get $K$ and $G$ replacing $phi_K$ into equations @eq:isotropic_K_relation and @eq:isotropic_G_relation with a value of $M = 1$.
  + Obtain $lambda_n$ replacing the values of $K$, $G$, $eta$ and $beta$ into @eq:eig_final and @eq:Peso_matrix_def.
  + Get the values of $xi_n$ dividing each eigenvalue by the next one: $xi_n = lambda_n/lambda_(n+1)$. 

=== Data generation in cubic case<sec:data_gen_cubic>

- Each pair of values $eta$ and $beta$ were generated according to @sec:eta_beta_generation. 
- Each pair of values $phi_Kappa$ and $phi_a$ were generated in the same way as $eta$ and $beta$. $phi_Kappa$ and $phi_a$ are uniformly distributed over the surface of a sphere where $phi_Kappa$ is the polar angle and $phi_a$ is the azimuthal angle in a region of $phi_Kappa$ between 0 and $pi/2$ and $phi_a$ between 0 and $pi/2$, as shown in @fig:targets_distribution. Similar to the distribution of geometrical features, here we can see that every proportion between $Kappa$, $a$ and $mu$ is equally represented in the dataset.  

#figure(
  image("../images/targets_distribution.png", width: 40%),
  caption: [Distribution if the targets $phi_Kappa$ and $phi_a$.]
)<fig:targets_distribution>

- Each group of values from $chi_0$ to $chi_19$ were generated the following way: 
  + Get $Kappa$, $a$ and $mu$ replacing $phi_Kappa$ and $phi_a$ in equations @eq:cubic_K_relation, @eq:cubic_a_relation and @eq:cubic_mu_relation, with a value of $M = 1$.
  + Perform a forward problem replacing $Kappa$, $a$ and $mu$ in equations @eq:cubic_constant_matrix_definitive, @eq:eig_final and @eq:Peso_matrix_def to get the eigenvalues $lambda_n$.
  + Get the compositions $chi_n$ from @eq:chi_definition.

=== Data analysis in isotropic case

A total of 252474 data rows were generated with variables distributed as described in @sec:data_gen_isotropic. Lets see the correlation matrix, calculated with these data, of the features of the isotropic case:

#figure(
  image("../images/corr_matrix_isotropic.png", width: 50%),
  caption: [Correlation matrix of the features in the isotropic case.]
)<fig:correlation_matrix_isotropic>

As seen in @fig:correlation_matrix_isotropic the features have a moderate or low correlation. That is good sign because it mean that different features hold different information. Now lets take a look at the mutual information between the target and the features:

#figure(
  image("../images/MI_phiK.png", width: 50%),
  caption: [Mutual information between features and target $phi_K$ in isotropic case.]
)<fig:MI_isotropic>

Here we can see that the lower $xi_n$ are the one that most affect the target. That implies that the lower frequencies are the ones that most affect the target $phi_K$. 

=== Data analysis in cubic case

A total of 858387 data rows were generated with variables distributed as described in @sec:data_gen_cubic. Lets see the correlation matrix, calculated with these data, of the features of the cubic case: 

#figure(
  image("../images/corr_matrix_cubic.png", width: 70%),
  caption: [Correlation matrix of the features in the cubic model.]
)<fig:correlation_matrix_cubic>

As seen in @fig:correlation_matrix_cubic the features have a moderate to low correlation. Here we have the same good sign that implies that every feature holds different information. Now if we take a look of the mutual information between features and targets, we see the following:

#figure(
  image("../images/MI_phia_phiK.png", width:100%),
  caption: [Mutual information between the features and the targets in the cubic case.]
)<fig:MI_cubic>

Here we can see that the lower $chi_n$ are the one that most affect the target. That implies that the lower frequencies are the ones that most affect the targets $phi_Kappa$ and $phi_a$. Given the results of the correlation matrix we can be confident enough to feed the data into a model. Lets check some of them.  

== Results of the isotropic model

In the case of isotropic solids, two models were trained. One of them was a polynomial regression of 4th degree, and the other one was a small sequential neural network. Lets see how the two performed.

=== Results of the polynomial regression

Fitting $phi_K$ in terms of the features $eta$, $beta$, $xi_0$, $xi_1$, $xi_2$, $xi_3$and $xi_4$ with a polynimial of 4th degree was done splitting 80% of the data for training and 20% for testing. 

Before studying the metrics of the model, the target was standarized in a way it had values between 0 and 1. The standarized target is the following: 

$ tilde(phi_K) = phi_K/(pi/2). $<eq:target1_normalized>

This way we can study we can give a meaning to the Mean Absolute Error (MAE) as the percentaje of deviation of the prediction of the model respect the domain of the target. MAE is defined in @chap:failure.

The results of the model are shown in the following table: 
#figure(
  table(
    columns: 3,
    [], [*Train*], [*Test*],
    [*MAE*], [0.093], [0.094],
    [*$R^2$*], [0.80], [0.51],
  ),
  caption: [Results of the linear regression model.]
)<table:linear_resgression_results>

As we can see here, the coefficient of determination is tells us that the model is overfitting, and still the target has an average error over the domain of 9%, which can be further improved. Nevertheless this model was able to predict the relation between $K$ and $G$ better than any model tried in @chap:failure. In fact this model was tested also with the data generated to train and test the first polinomial model and the results were: $"MAE" = 0.084$ and $R^2 = 0.78$. Much better than any result shown in @chap:failure. This proves that the variable transformations made in @chap:transformations are able to improve any model drastically. Now we're going to see the performance of a neural network. 
/*
$ "MAE" = (1/N_("data")) sum_(m = 1)^(N_"data") abs(tilde(phi_(K m)^("real")) - tilde(phi_(K m)^("predicted"))). $<eq:MAE_def>

Also another metric that will give us an idea of how well the model is fitting the data is the coefficient of determination $R^2$, which is defined as: 

$ R^2 = 1 - "SSE"/"SST", $

where,

$ "SSE" = sum_(m = 1)^(N_"data") (tilde(phi_(K m)) - tilde())^2 $
*/
=== Results of the neural network

Splitting 60% of the data for training, 20% for validation and 20% for testing, a sequential neural network with 3 hidden layers, with 64 neurons in the first, 32 neurons in the second and 8 neurond in the third was trained. The activation function of all hidden layers was ReLU and the activation of the last layer was the following custom function: 

$ g(x) = (1/20) log((1 + e^(20x))/(1 + e^(19x)).) $

This function is similar to $y = x$ when $x$ is between 0 and 1, close to 0 if $x < 0$ and 1 if $x > 1$. This way the target was going to have values between 0 and 1. However, as we will see later in the cubic case, the hard sigmoid performs better because it has the same advatages but makes the training a lot faster. The learning rate of the model was 0.0005 and batch size was 16. 

The training of the model was performed using Keras 3.0 in python, using torch as the backend with an AMD 6600M GPU. It took 72 minutes to complete the training. Full system specs of the PC used to train the models can be seen in @apx:specs. 


The results of this model are shown in @table:NN1_results: 

#figure(
  table(
    columns: 4,
    [], [*Train*], [*Validation*], [*Test*],
    [*MAE*], [0.024], [0.024],  [0.024],
    [*$R^2$*], [0.982], [0.981],  [0.980],
  ),
  caption: [Results of the small sequential neural network.]
)<table:NN1_results>

As we can see this neural network is capable of predicting $phi_K$ with an error of 2.4% of its domain. Also there is no sign of overfitting as it can be seen in the similar results between test and train. The history of the errors during training confirms what has been just stated: 

#figure(
  image("../images/train_val_history_isotropic.png", width: 70%),
  caption: [Train history of the neural network model in the isotropic case. As it can be seen there is no sign of overfitting.]
)<fig:train_history_isotropic>

//Presentar las graficas que muestran los valores del phi_K predicho con los datos combinatoriales. 

== Results of the cubic model

Coloque aquí todas las gráficas y métricas, así como la comparación con el trabajo de Fukuda. 
