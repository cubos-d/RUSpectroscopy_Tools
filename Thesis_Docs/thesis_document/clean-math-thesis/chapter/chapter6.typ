= The inverse problem

In this chapter, we will explore the training process of different models, whose purpose is to predict the variable $phi_K$ for the isotropic case and the variables $phi_Kappa$ and $phi_a$ for the cubic case. We will examine the training, testing, and validation data generation processes, and perform an exploratory analysis of them. Then, we will present different metrics that demonstrate the performance of the models in predicting their respective phi values. Finally, we will show the performance of the entire pipeline proposed in @chap:transformations and summarized in @fig:diagram_inverse, fed with different models, to predict the elastic constants of different materials whose values are reported in literature.

== Data generation and its analysis

Each row of values representing a piece of data is composed of two geometric variables, the target variables, and the relationships between the eigenvalues. In the isotropic case, each row of data is composed of a value each of $eta$, $beta$, $phi_K$, $xi_1$, $xi_2$, $xi_3$, $xi_4$, and $xi_5$. In the cubic case, each row of data is composed of a value each of $eta$, $beta$, $phi_Kappa$, $phi_a$, and 20 composition values from $chi_0$ to $chi_19$. These data were generated based on the crystal structure and the nature of the variables themselves.

=== Distribution of geometric variables $eta$ and $beta$<sec:eta_beta_generation>
Regardless of the crystal structure, each value of $eta$ and $beta$ was generated in such a way that it would be uniformly distributed over the surface of a sphere, where $eta$ is the polar angle and $beta$ is the azimuthal angle, in the region where $eta$ is between 0 and $0.61 pi$ and $beta$ is between 0 and $pi$, as shown in Figure X.

// Place figure X here

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
- Each pair of values $phi_Kappa$ and $phi_a$ were generated in the same way as $eta$ and $beta$. $phi_Kappa$ and $phi_a$ are uniformly distributed over the surface of a sphere where $phi_Kappa$ is the polar angle and $phi_a$ is the azimuthal angle in a region of $phi_Kappa$ between 0 and $pi/2$ and $phi_a$ between 0 and $pi/2$, as shown in the figure Y. 

//Place figure Y here.

- Each group of values from $chi_0$ to $chi_19$ were generated the following way: 
  + Get $Kappa$, $a$ and $mu$ replacing $phi_Kappa$ and $phi_a$ in equations @eq:cubic_K_relation, @eq:cubic_a_relation and @eq:cubic_mu_relation, with a value of $M = 1$.
  + Perform a forward problem replacing $Kappa$, $a$ and $mu$ in equations @eq:cubic_constant_matrix_definitive, @eq:eig_final and @eq:Peso_matrix_def to get the eigenvalues $lambda_n$.
  + Get the compositions $chi_n$ from @eq:chi_definition.

=== Data analysis in isotropic case

A total of 252474 data rows were generated with variables distributed as described in @sec:data_gen_isotropic. Lets see the correlation matrix, calculated with these data, of the features of the isotropic case:

//Place figure of correlation matrix here.

As seen in figure Z the features have a moderate or low correlation. That is good sign because it mean that different features hold different information. Now lets take a look at the mutual information between the target and the features:

//Place mutual information here (for isotropic case)

Here we can see that the lower $xi_n$ are the one that most affect the target. That implies that the lower frequencies are the ones that most affect the target $phi_K$. 

=== Data analysis in cubic case

A total of 858387 data rows were generated with variables distributed as described in @sec:data_gen_cubic. Lets see the correlation matrix, calculated with these data, of the features of the cubic case: 

//Place correlation matrix here (for cubic case)

As seen in figure Z the features have a moderate to low correlation. Here we have the same good sign that implies that every feature holds different information. Now if we take a look of the mutual information between features and targets, we see the following:

#figure(
  image("../images/MI_phia_phiK.png", width:100%),
  caption: [Mutual information between the features and the targets in the cubic case.]
)<fig:MI_cubic>

Here we can see that the lower $chi_n$ are the one that most affect the target. That implies that the lower frequencies are the ones that most affect the targets $phi_Kappa$ and $phi_a$. Given the results of the correlation matrix we can be confident enough to feed the data into a model. Lets check some of them.  

== Results of the isotropic model

In the case of isotropic solids, two models were trained. One of them was a polynomial regression of 4th degree, and the other one was a small sequential neural network. Lets see how the two performed.

=== Results of the polynomial regression

=== Results of the neural network

== Results of the cubic model

