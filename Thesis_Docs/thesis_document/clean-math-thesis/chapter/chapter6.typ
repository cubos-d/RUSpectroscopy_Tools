= The inverse problem

In this chapter, we will explore the training process of different machine learning models, whose purpose is to predict the variable $phi_K$ for the isotropic case and the variables $phi_Kappa$ and $phi_a$ for the cubic case. We will examine the training, testing, and validation data generation processes, and perform an exploratory analysis on them. Then, we will present different metrics that demonstrate the performance of the models in predicting their respective $phi$ values. Finally, we will show the performance of the entire pipeline proposed in @chap:transformations and summarized in @fig:diagram_inverse, fed with different models, to predict the elastic constants of different materials, from isotropic and cubic crystal families, whose values are reported in literature.

== Data generation and its analysis

Data consists of entry rows where an entry of the dataset is composed of two geometric variables, the target variables, and the relationships between the eigenvalues. In the isotropic case, each row of data is composed of a value each of $eta$, $beta$, $phi_K$, $xi_0$, $xi_1$, $xi_2$, $xi_3$, and $xi_4$. In the cubic case, each row of data is composed of a value each of $eta$, $beta$, $phi_Kappa$, $phi_a$, and 20 composition values from $chi_0$ to $chi_19$. These data were generated based on the crystal structure.

=== Distribution of geometric variables $eta$ and $beta$<sec:eta_beta_generation>
Regardless of the crystal structure, each value of $eta$ and $beta$ was generated in such a way that it would be uniformly distributed over the surface of a sphere, where $eta$ is the polar angle and $beta$ is the azimuthal angle. 

The data was generated inside a region where $eta$ is between 0 and $0.61 pi$ and $beta$ is between 0 and $pi$, as shown in @fig:geometrical_features_distribution.

#figure(
  image("../images/geo_feat_dist.png", width: 40%),
  caption: [Distribution of the features $eta$ and $beta$ over the unit sphere.]
)<fig:geometrical_features_distribution>

This uniform distribution of data over the surface of a sphere was done using the methods described in the work of Deserno #cite(<Deserno_2004>). Since, during the evaluation of the inverse problem shown in @fig:diagram_inverse, we are forcing the largest dimension to be $L_z$ and the shortest dimensions to be $L_y$, every possible aspect ratio is represented as a single point inside the mentioned region on the surface of the sphere. In other words, each aspect ratio has its unique pair of values of $eta$ and $beta$. 

For example, an aspect ratio of 3:4:5 has a value of $eta = 2 arctan(1) = 0.5 pi$ and $beta = 4 arctan(3/4) = 0.82 pi$, and an aspect ratio of 1:8:7 has a value of $eta = 2 arctan(sqrt(50)/8) = 0.46 pi$ and $beta = 4 arctan(1/7) = 0.18 pi$. Both aspect ratios the same probability of being generated. The same can be said for every other aspect ratio. This way each aspect ratio on the surface of the sphere has equal representation in the dataset.

This equal representation is important because it allows a model to learn more generalized patterns improving its performance. For example, a model trained with as dataset where 80% of its entries are composed of values of $beta < pi/2$ and 20% of its entries are composed of values of beta $beta > pi/2$ can have problems predicting data whose values of $beta$ is greater than $pi/2$. This is an example of a biased dataset. Even if we get a good model trained with tons of biased data, we can get the same good, or even a better model training it with fewer entries of balanced data, and wasting less time and computational resources in the training process.  

=== Data generation in isotropic case<sec:data_gen_isotropic>

- Each value of $phi_K$ was uniformly distributed between 0 and $pi/2$.
- Each pair of values $eta$ and $beta$ were generated according to @sec:eta_beta_generation. 
- Each group of values from $xi_0$ to $xi_4$ were generated in the following way:
  + Get $K$ and $G$ replacing $phi_K$ into equations @eq:isotropic_K_relation and @eq:isotropic_G_relation with a value of $M = 1$.
  + Obtain $lambda_n$ replacing the values of $K$, $G$, $eta$ and $beta$ into @eq:eig_final and @eq:Peso_matrix_def.
  + Get the values of $xi_n$ dividing eigenvalues as follows: $xi_n = lambda_n/lambda_(n+1)$. 

=== Data generation in cubic case<sec:data_gen_cubic>

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

A total of 252474 data entries were generated with variables distributed as described in @sec:data_gen_isotropic. In @chap:transformations we reduced redundancy of geometric variables. Now we're going to explore if there is any redundancy inside the relation between eigenvalues. For that purpose the correlation matrix will be calculated. As mentioned in @chap:failure every element of the correlation matrix has the Pearson product-moment correlation coefficient, which measures the lineal dependence between two features #cite(<Raschka_2022>). If any coefficient is close to 1 or -1 means that two features are heavily correlated, which means that they are holding the same information. Thus, when a value close to 1 or -1 is found the dataset may carry redundant information from a pair of highly correlated features, which means that one of them can be eliminated. On the other hand if we find values close to 0, it means independence between a pair of features, which means that every feature is holding different information that cannot be ignored.   

Lets see the correlation matrix, calculated with these data, of the features of the isotropic case:

#figure(
  image("../images/corr_matrix_isotropic.png", width: 50%),
  caption: [Correlation matrix of the features in the isotropic case.]
)<fig:correlation_matrix_isotropic>

As seen in @fig:correlation_matrix_isotropic the features have a moderate or low correlation, being the correlation of 0.55 between $beta$ and $xi_4$ the case with highest absolute correlation. While this indicates a moderate positive linear relationship, is not high enough to suggest strong redundancy between these features. In other words although, $beta$ and $xi_4$ may share some information, they are still sufficiently independent to be considered complementary rather than redundant. This supports the inclusion of both variables in a model, as each likely contributes unique information that may improve the model's predictive performance. Given that every other pair of features have less absolute correlation, all of them will be included as well in any model to be trained. In other words, all features shown in @fig:correlation_matrix_isotropic are not redundant and will be fed in both of machine learning models studied in @sec:isotropic_results. 

In addition to examining linear correlations, it is also important to evaluate nonlinear relationships between features and the target variable. This is where mutual information becomes particularly useful.

Mutual information is a measure of the amount of information that one variable contains about another variable. It is the reduction of uncertainty of one variable due to the knowledge of the other #cite(<Cover_2005>). In other words, mutual information is capable of showing us the statistical dependency between the target and some feature. Mutual information is given by the following expression #cite(<Cover_2005>): 

$ I = sum_y sum_x P_(x, y) ln(P_(x, y)/(P_x P_y)), $<eq:mutual_info_disc>

where $P_(x, y)$ is the joint probability between the two variables, and $P_x$ and $P_y$ are the marginal probabilities of variables $x$ and $y$ respectively #cite(<Cover_2005>). When dealing with continuous variables, we have to change the sums in @eq:mutual_info_disc for integrals and change the probabilities for probability density functions: 

$ I = integral_y integral_x rho_((x,y)) ln(rho_((x,y))/(rho_((x)) rho_((y)) )). $<eq:mutual_info_cont>

A value of zero in mutual information $I$, between a feature and the target, indicates no statistical dependency between them, meaning that the feature provides no information about the target, meaning that the target is independent from the feature. On the other hand a high value of mutual information indicates a strong dependency between the target and the feature. By computing mutual information between each feature and the target, we can identify which features are likely to contribute most meaningfully to a predictive model.  

Now lets take a look at the mutual information between the target and the features, computed with scikit-learn, to see which one has the grater contribution to the target #cite(<scikit-learn>):

#figure(
  image("../images/MI_phiK.png", width: 60%),
  caption: [Mutual information between features and target $phi_K$ in isotropic case.]
)<fig:MI_isotropic>

We can see that, in principle, $eta$ and $beta$ hold no relation with the target with a value of near 0 in the mutual information. That was expected because data of $eta$ and $beta$ was generated independently from the data of $phi_K$. Nevertheless that doesn't mean that $eta$ and $beta$ are not correlated to $phi_K$. On the other hand we can see that $xi_0$ shows the highest mutual information score with the target $phi_K$, suggesting it has the most influence on the output variable. This is also expected, since the first frequency is the one that the highest influence either in $K$ or $G$. We can see that other values of $xi_n$ also have some influence in the target, which means that it is convenient to take into account all of them when training the model.   

=== Exploratory data analysis for the cubic case

A total of 858387 data entries were generated with variables distributed as described in @sec:data_gen_cubic. As well as we did in the isotropic case in @sec:isotropic_exploration, we will check if there is any redundancy between the compositions $chi_n$ computing the correlation matrix of the features, which is shown below: 

#figure(
  image("../images/corr_matrix_cubic.png", width: 70%),
  caption: [Correlation matrix of the features in the cubic model.]
)<fig:correlation_matrix_cubic>

As seen in @fig:correlation_matrix_cubic, in the cubic case the features have a moderate to low correlation, being the correlation of 0.57 between $beta$ and $chi_0$ the case with highest absolute correlation. As well as the highest absolute correlation in isotropic case, here $beta$ and $chi_0$ may share some information, but they are still sufficiently independent to be considered complementary rather than redundant. This means it is convenient to include both variables in the model. Given that the absolute correlation between the other pairs is even lower, it is convenient to include all the features listed in @fig:correlation_matrix_cubic inside the model studied in @sec:cubic_results. We can see in general that all the features shown in @fig:correlation_matrix_cubic have low collinearity, which implies a high degree of independence.

As done in @sec:isotropic_exploration, we will identify which features contribute meaningfully to the targets in the cubic case. To to that, the mutual information between all the features and the targets $phi_Kappa$ and $phi_a$ was performed. @fig:MI_cubic shows the results of such computation:

#figure(
  image("../images/MI_phia_phiK.png", width:100%),
  caption: [Mutual information between the features and the targets in the cubic case.]
)<fig:MI_cubic>

As expected $eta$ and $beta$ have almost zero values in mutual info between them and $phi_a$, because $eta$ and $beta$ were generated independently from $phi_Kappa$ and $phi_a$. Nevertheless $beta$ and $phi_Kappa$ have a non negligible value of mutual information, which means that there are certain ranges of combinations of  $beta$ and $phi_Kappa$ that are underrepresented. In other words, there are some holes in the spheres of @fig:geometrical_features_distribution and @fig:targets_distribution. Nevertheless the mutual information between $beta$ and $phi_Kappa$ is still lower than the majority of the values of mutual information between $phi_kappa$ and the compositions $chi_n$. On the other hand the lower values of $chi_n$ like $chi_0$, $chi_1$, $chi_2$ and $chi_3$ show the highest mutual information score with both targets, suggesting that they have the most influence on the output variables. This is also expected because a higher dependence between the elastic constants and the first resonance frequencies is expected. In fact, we can observe that, by far the variable with most influence on the targets is $chi_1$, and that's because $chi_1$ has information of both first and second frequency: remember that $chi_1 = (lambda_1 - lambda_0)/lambda_19 = (omega_1^2 - omega_0^2)/omega_19^2$. Both of these frequencies are expected to be highly influential in the elastic constants. Given the correlation matrix and mutual information results it is convenient to take into account all features as well. 

== Results of the isotropic model<sec:isotropic_results>

In the case of isotropic solids, two models were trained. One of them was a polynomial regression of 4th degree, and the other one was a small sequential neural network. Lets see how the two performed.

In a polynomial regression a target $y$ is modelled in terms of some features $x_i$ as a polynomial whose terms are all possible multiplications between the features up to Nth grade. The value of N is chosen arbitrarily. For example, in the case of a 4th polynomial degree the target $y$ is modeled ins terms of the features as follows: 

$ y = sum_(i=1)^(N_"feat")A_i x_i^4 + B_i x_i^3 + C_i x_i^2 + D_i x_i + sum_(i=1)^(N_"feat" - 1) sum_(j = i+ 1)^(N_"feat") epsilon_(i j) (E_(i j) x_i^2 x_j^2 + F_(i j) x_i x_j) + \ sum_(i=1)^(N_"feat") sum_(j=i)^(N_"feat") epsilon_(i j) ( G_(i j) x_i^3 x_j + H_(i j) x_i^2 x_j) + sum_(i=1)^(N_"feat") sum_(j=1)^(N_"feat" - 1) sum_(k = j + 1)^(N_"feat") epsilon_(i j k) I_(i j k) x_i^2 x_j x_k + \ sum_(i=1)^(N_"feat" - 2) sum_(j=i+1)^(N_"feat" - 1) sum_(k = j + 1)^(N_"feat") epsilon_(i j k) J_(i j k) x_i x_j x_k + sum_(i = 1)^(N_"feat" - 3) sum_(j=i+1)^(N_"feat" - 2) sum_(k=j+1)^(N_"feat" -1) sum_(l = k+1)^(N_"feat") epsilon_(i j k l) K_(i j k l) x_i x_j x_k x_l + L, $

where $N_"feat"$ is the number of features, $epsilon$ is equal to zero if any of its indices is repeated and the capital latin letters are the coefficients to be fitted.  

=== Results of the polynomial regression

Fitting $phi_K$ in terms of the features $eta$, $beta$, $xi_0$, $xi_1$, $xi_2$, $xi_3$and $xi_4$ with a polynomial of 4th degree was done splitting 80% of the data for training and 20% for testing. 

Before training, the target was modified in a way it had values between 0 and 1, as follows: 

$ tilde(phi)_K = phi_K/(pi/2). $<eq:target1_normalized>

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

As we can see here, the coefficient of determination is tells us that the model is overfitting, and still the target has an average error over the domain of 9%, which can be further improved. Nevertheless this model was able to predict the relation between $K$ and $G$ better than any model tried in @chap:failure. In fact this model was tested also with the data generated to train and test the first polynomial model and the results were: $"MAE" = 0.084$ and $R^2 = 0.78$. Much better than any result shown in @chap:failure. This proves that the variable transformations made in @chap:transformations are able to improve any model drastically. Now we're going to see the performance of a neural network. 
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

== Results of the cubic model<sec:cubic_results>

Coloque aquí todas las gráficas y métricas, así como la comparación con el trabajo de Fukuda. 
