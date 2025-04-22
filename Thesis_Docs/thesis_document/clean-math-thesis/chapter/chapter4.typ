= First attempts of solving the inverse problem<chap:failure>

In this chapter we explore the initial attempts to solve the inverse problem. Here we will explain how we generated uniform distribution of data of the bulk modulus ($K$), shear modulus ($G$) dimensions of the sample between some fixed ranges, and the perform a forward problem for each row of data to get the values of the frequencies, so with that data we could train a model that was able to predict the bulk and shear modulus of isotropic solid. Then we will explain how we made some exploratory data analysis (EDA) to check how the frequencies were distributed and check which transformations could improve the model. With the EDA done, a polynomial regression model, for each target (bulk modulus $K$ and shear modulus $G$) was performed with no success. This will show us that even for the simplest crystal structure (isotropic) the problem is very complex, and some additional steps and transformations must be done in order to get a successful model, as we will see in @chap:transformations.  

#v(1cm)

== Data Generation

The data to train and test the model was constructed with 32678 rows, where each row had a value of $K$ and $G$ uniformly distributed between 0.3 $"G" "din"/("cm")^2$ and 5.6 $"G" "din"/("cm")^2$, a value of density $rho$ uniformly distributed between 0.2 $g/("cm")^3$ and a value for each length $L_x, L_y$ and $L_z$ uniformly distributed between 0.1 $"cm"$ and 1$"cm"$. Each row also had their respective frequencies of the forward problem performed with the $K$, $G$, dimensions and density data previously mentioned. 

The codes made to generate the data, visualize data, train the models and evaluate the models make extensive use of the following Python libraries:
- numpy #cite(<numpy>) 
- pandas #cite(<pandas>) 
- matplotlib #cite(<matplotlib>)
- scipy #cite(<scipy>)
- scikit-learn #cite(<scikit-learn>)

Having that data, we can see the distribution of the squared frequencies $omega_n^2$. For example, for the first frequency the distribution was:

#figure(
  image("../images/omega_distribution.png", width: 75%),
  caption: [Distribution of the first frequency.]
)<fig:omega_distribution>

We can see in @fig:omega_distribution that the first frequency is distributed near log-normal distribution. This gives an idea of how the omegas should be transformed in principle. To confirm that @fig:qq_plot shows a QQ-plot of the logarithm of the first frequency for a normal distribution:

#figure(
  image("../images/qq_plot.png", width: 75%),
  caption: [QQ-plot for a normal distribution of the logarithms of the first frequency]
)<fig:qq_plot>

We can see in @fig:qq_plot that the orderes values of $log(omega_0^2)$ are close to its theoretical quantiles. This means that $log(omega_0^2)$ distributes close to normal distribution, as we can see in @fig:normal_w:

#figure(
  image("../images/omega_log_distribution.png", width: 75%),
  caption: [Distribution of $log(omega_0^2)$] 
)<fig:normal_w>

Making regressions with normal distributed features is a lot easier than making them with log-normal distributed features. The next step was to take a look at how correlated the variables were. TO do that we need to compute the correlation matrix, which is represented as an image in @fig:corr_matrix1: 

#figure(
  image("../images/corr_matrix1.png", width: 75%),
  caption: [Correlation matrix between variables including features and targets. Here dx, dy and dx are $L_x$, $L_y$ and $L_z$ respectively, and w0 is $omega_0^2$, w1 is $omega_1^2$, and so on.]
)<fig:corr_matrix1>

We can see in @fig:corr_matrix1, that the features are heavily correlated. This indicates that the problem is a very complex one, because the frequencies, which are the features, hold almost the same information. Thus we need some variable transformations, so we can train a model with more independent features. Nevertheless, several attempts to perform a regression were made. These included linear regressions and polynomial regressions, but all of them yielded poor fits just in the train data. The best model achieved a value of mean absolute percentage error of 1.31, which means more than 100% of average error. Not even fitting the data in a 9th grade polynomial regression could ever overfit it. This lets us see that the problem is not trivial and very complex, and it is necessary to simplify it before even attempting to perform any fit. One possible solution to this problem is to reduce features and targets and make the model fit the simplest problem possible. 
