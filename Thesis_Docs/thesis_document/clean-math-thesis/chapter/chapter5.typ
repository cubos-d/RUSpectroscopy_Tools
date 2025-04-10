= Making the inverse problem a simpler one <chap:transformations>

In the previous chapter we discussed how to get the resonance frequencies of a sample given the elastic constants, the mass (or density) and the dimensions of the sample, in Resonant Ultrasound Spectroscopy. This was called: The Forward Problem. In this chapter we will discuss some variable transformations, and other tricks to solve the inverse problem, before attempting to solve it yet. We will discuss why it is important to simplify the problem and make such transformations and which transformations we will do to simplify the inverse problem.  

#v(1cm)

== Why we need to make some tweaks before solving the inverse problem

To solve the inverse problem we would need to make a model that is able to predict the elastic constants $C_(i j)$ given the mass or the density of the sample $m$ or $rho$, the dimensions of the sample $L_x, L_y, L_z$ and the resonance frequencies $omega_n$. This way, we can generate data with different values of constants, mass, and dimensions. Then perform forward problems for each combination of parameters and save the computed frequencies. With that data we can train a machine learning model that receives the frequencies, mass and dimensions as features, and tries to predict the constants as the targets. We saw in @chap:failure that this was a very complex problem and it must be simplified for the following reasons, even supposing that we are solving the inverse problem just for the isotropic case, which is the easiest and only has two independent constants: 

- We need to, either generate data of all possible dimensions with $L_i$ ranging between 0 and infinite, which is quite difficult not to say impossible, or generate data for a very specific range of dimensions, which would make our model useless for solving the problem for samples out of that range. Here we want our solution to work well regardless the dimensions or the size of the sample. It should work with every parallelepiped sample. 

- We need to generate data of the constants in some unknown range in principle. To know the range we can search some common values of constants of some known materials in literature, but that would make our model only useful to predict known constants, and that is not the objective. We want to make a tool able to predict the constants of unknown materials. Fortunately physics dictate the limits those constants have, and Mouhat's study explains those limits quite well #cite(<Mouhat_2014>). In the case of cubic solids those limits were explained in @section:Constant_Restrictions. According to those limits we will transform the constant data, in a way that the targets have a well defined range.   

- As we saw in @fig:corr_matrix1, the frequencies are not fully independent. They have heavy collinearity, which is a problem, because lots of features are giving us basically the same information. 

- The simpler the problem, the better. The less features a problem has to receive the better. The same can be said with the targets (yes, we can get rid of one of the targets!). 

In summary, we cannot just feed a model with some data generated with forward problems, with the frequencies, mass and dimensions as the features and the constants as the targets. 

== Getting eigenvalues that are independent of the size of the sample

We can see from the equations @eq:Gamma_matrix_def and @eq:raw_eig_problem, that the squared frequencies $omega^2$ depend on the size of the sample. If we measure the frequencies of a certain sample, let's call them $omega_(i)^2$, and then measure the frequencies of a second sample of the same material, same shape, but different size, for example two times the size of the first sample, $L_(x 2) = 2 L_(x 1), L_(y 2) = 2 L_(y 1), L_(z 2) = 2 L_(z 1)$, we will get as a result that the squared frequencies of the second sample are 4 times the frequencies of the first sample. In other words, with the second sample we would get the following frequencies: $4 omega_(i)^2$. We want to be able to get the constants of every sample regardless the size of the sample.

Let's multiply to both sides of the equation @eq:raw_eig_problem the following: $V/R$, where $V$ is the volume of the sample and 

$ R = sqrt(L_x^2 + L_y^2 + L_z^2). $<eq:R>

This way the @eq:raw_eig_problem is now as follows: 

 $ rho V omega^2/R arrow.l.r(Epsilon) arrow(a) = V/R arrow.l.r(Gamma) arrow(a). $<eq:eig_preparing>

Let's define a new matrix $arrow.l.r(Kai) = V/R arrow.l.r(Gamma)$. With this definition we have the final generalized eigenvalue problem to solve: 

$ lambda arrow.l.r(Epsilon) arrow(a) = arrow.l.r(Kai) arrow(a). $<eq:eig_final>

Here 

$ lambda = m omega^2/R, $<eq:def_lambda>

and an element of the matrix $arrow.l.r(Kai)$ is given by:  

$ Kai_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) = L_(j l)/R C_(i j k l) integral_V (partial X^(lambda_1) Y^(mu_1) Z^(nu_1) )/(partial b_j) (partial X^(lambda_2) Y^(mu_2) Z^(nu_2) )/(partial b_l) d X d Y d Z, $<eq:Peso_matrix_def>

where $L_(j l) = L_(6 - j - l)$ if $j != l$. Else $L_(j l) = (L_x L_y L_z)/L_j^2$.

From the equations @eq:eig_final and @eq:Peso_matrix_def we can note that $lambda$ eigenvalues do not depend on the size of the sample, because $L_(j l)/R$ does not change with the size of the sample, and only changes with the proportions of $L_x$, $L_y$ and $L_z$. In summary, the eigenvalues $lambda$ only depend on the values of the elastic constants and the aspect ratio of the sample. This way we can eliminate the feature of the sample size, encoded in the variables $L_x$, $L_y$ and $L_z$, and we will see how right now. 

== Defining the shape of a three spatial dimensional (3D) sample with two parameters<sec:eta_beta_definition>

To define the aspect ratio of a solid we would need only 2 parameters, for example we would need, $L_x/L_y$ and $L_y/L_z$. Nevertheless, defining the range of those values in which our data will be is quite difficult. Both $L_x/L_y$ and $L_y/L_z$ can be arbitrarily big, which doesn't solve the problem of having clear range of feature data generation. So we could define the following parameters $g_x = L_x/(L_x + L_y + L_z)$ and $g_y = L_y/(L_x + L_y + L_z)$, knowing that both have values between 0 and 1. This parameters are better, but are a little tricky to generate, because we cannot just generate some arbitrary numbers between 0 and 1, for example generating a value $g_x = 0.5$ and a value of $g_y = 0.6$, because the following condition must be met: $g_x + g_y lt.eq 1$. Still, is possible to generate values of those parameters respecting the restriction, but there is a way to approach this problem in a simpler and easier way. 

Let's recall the parameter $R$ we defined in @eq:R. This is no other that the length of a line that goes from one vertex of the parallelepiped to it opposite vertex. Imagine now that the solid is inside a sphere of radius $R$ with one vertex at the origin and the opposite vertex touching the surface of the sphere as shown in the following figure:

#figure(
  image("../images/space_sphere.png", width: 60%),
  caption: [Sample of a parallelepiped solid inside a sphere.]
)<fig:aspect_ratio_space> 

Here one can easily see the dimensions of the solid as coordinates of the vertex opposite to the origin, where:

$ L_x = R sin(theta) cos(phi), L_y = R sin(theta) sin(phi), L_z = R cos(theta). $

The angles $theta$ and $phi$ can represent any point of the surface of such sphere, thus they are also capable to represent any aspect ratio of the solid. For example, an aspect ratio of 3:4:5, can be represented with the following angles: $theta = arctan(sqrt(3^2 + 4^2)/5) = arctan(1) = pi/4$, $phi = arctan(4/3) = 0.29 pi$. Given there is no solid with negative lengths, so angles above $pi/2$ are forbidden, we can generate data representing every aspect ratio, generating values of $theta$ and $phi$ between 0 and $pi/2$. However, the eigenvalues of a solid with $L_x = 5$, $L_y = 4$ and $L_z = 3$ will be the same ones as the same solid with dimensions $L_x = 4$, $L_y = 5$ and $L_z = 3$, and both cases yield to different values of $theta$ and $phi$. In other words, there is a lot of redundancy that can be eliminated. To start removing redundancy, lets define some new angles, in a new sphere space, that will let us spot redundancies more easily. The fist one will be our new polar angle $eta$, which is defined as: 

$ eta = 2 theta, $<eq:eta_definition>

and the second one will be our new azimuthal angle called $beta$, which is defined as:

$ beta = 4 phi. $<eq:beta_definition>

Angle $eta$ is defined between 0 and $pi$ and $beta$ is defined between 0 and $2 pi$. Now the dimensions are related to these new angles as follows:

$ L_x = R sin(1/2 eta) cos(1/4 beta), L_y = R sin(1/2 eta) sin(1/4 beta), L_z = R cos(1/2 eta). $<eq:dim_in_terms_of_eta_and_beta>

These transformed angles yield to values of $L_x$, $L_y$ and $L_z$ that are always positive allowing us to move all around the new sphere, shown in []. For example a value of $eta$ of $pi/2$ (in the equator of the new sphere) means that $L_z = sqrt(L_x^2 + L_y^2)$, a value of $eta$ close to 0 means that $L_z >> sqrt(L_x^2 + L_y^2)$ and a value of $eta$ close to $pi$ means that $L_z << sqrt(L_x^2 + L_y^2)$. On the other hand a value of $beta$ of $pi$ means that $L_x = L_y$, a value of $beta$ close to 0 means that $L_x >> L_y$ and a value of $beta$ close to $2 pi$ means that $L_x << L_y$. If we assign always the largest dimension as $L_z$ and the lowest dimension as $L_y$, some values of $eta$ and $beta$ we can represent all possible aspect ratio of the solids using angles of $eta$ between 0 and $0.61 pi$ (this last value covers the case where $L_x = L_y = L_z$) and angles of $beta$ between 0 and $pi$. In those ranges there is still some redundancy, but in general, redundancy has been significantly reduced, and now we are able to generate data representing all the possible ratios in the dimensions of the solid.   

// Figure of sphere in eta, beta space. This one can be 2D.

In summary, $eta$ and $beta$ values can represent every aspect ratio of the sample and the eigenvalues $lambda_n$ only depend on the aspect ratio. Thus the eigenvalues $lambda_n$ depend on $eta$ and $beta$, but not $R$. When training the machine learning model instead of having three geometrical features $L_x$, $L_y$ and $L_z$ now we have only two: $eta$ and $beta$. In terms of the dimensions we get the following expressions for the new features: 

$ eta = 2 arctan(sqrt(L_x^2 + L_y^2)/L_z), $<eq:def_eta>
and 

$ beta = 4 arctan(L_y/L_x). $<eq:def_beta> 

== Setting new targets according to the elastic constant restrictions

One of the biggest problems of making a model to solve the inverse problem is to know how to generate the constants that will make up the training data. As we saw in @chap:failure, some constant values were generated according to a literature review. However, this is problematic, because there is no guarantee that the model trained with such values will find correctly a elastic constant value which is very different from the ones found in literature. As we did with the dimensions, we need the model to be able to work to any constant value despite it order of magnitude. We will see that it is possible to get the relations between the constants using a machine learning model, and then its magnitude just by doing some multiplications.

=== Setting new targets in isotropic case

Imagine an isotropic solid, lets call it solid A, with a bulk modulus of $K_A = 4$ and with a shear modulus of $G_A = 3$, with some given dimensions, where we perform a forward problem, using @eq:Peso_matrix_def to get its eigenvalues, which are $lambda_(A 0)$, $lambda_(A 1)$, $lambda_(A 2)$, ..., $lambda_(A n)$. Now imagine an isotropic solid, lets call it solid B, with the same dimensions and shape, but with bulk modulus of $K_B = 8$ and shear modulus of $G_B = 6$. If we perform a forward problem to get the eigenvalues of solid B we get: $lambda_(B 0) = 2 lambda_(A 0)$, $lambda_(B 1) = 2 lambda_(A 1)$, $lambda_(B 2) = 2 lambda_(A 2)$, ..., $lambda_(B n) = 2 lambda_(A n)$. In other words, due to the linear nature of @eq:Peso_matrix_def, if we double the values of the constants (keeping the same proportions), we would just double each of the eigenvalues. This means that the eigenvalues are proportional to the magnitude of the constants, defined as $M = sqrt(K^2 + G^2)$. In other words $lambda_(A n)/M_A = lambda_(B n)/M_B$, or: 

$ lambda_n prop M, $<eq:prop_M_lambda>

for a given relation between $K$ and $G$. 

Now lets define a new variable $xi$, related to the eigenvalues, where $xi_n = lambda_n/lambda_(n + 1)$. The values of $xi$ for both solid A and solid B are just the same. We have created a new variable that only depends on the relation between $K$ and $G$, but does not depend on the magnitude of those variables. $xi$ is not the only variable representing the relation between eigenvalues. For example, we have $chi_n = (lambda_n - lambda_(n-1))/lambda_N $, which will be explained later and also depend only on the relation between $K$ and $G$. In other words, the relation between eigenvalues (represented in $xi_n$ or $chi_n$) depend only on the relations between constants and the aspect ratio of the sample. As we saw in @sec:eta_beta_definition a good way to represent the relation between variables, having a well defined range is with angles. Let's define a new variable that holds the information about the relation between $K$ and $G$, called $phi_K$:

$ phi_K = arctan(G/K). $<eq:phiK_def_isotropic>

This new variable is defined between 0 and $pi/2$, which makes it a perfect candidate to be the new target of a machine learning model. But once we have a model able to predict $phi_K$ given the relations between eigenvalues, $eta$ and $beta$, we need a way to calculate $sqrt(K^2 + G^2)$ to then calculate then $K$ and $G$. Fortunately that is not complicated, and we can do it following these steps:

- Predict $phi_K$ using the relations between the eigenvalues ($xi_n$ or $chi_n$), $eta$ and $beta$ as the features. 
- Establish an arbitrary base value of magnitude, for example $sqrt(K_("base")^2 + G_("base")^2) = 1$ and calculate a base value of $K$ and $G$ using: 
$ K_("base") = M cos(phi_K), $ 
$ G_("base") = M sin(phi_K). $
- Compute the eigenvalues of the "base" constants performing a forward problem. Lets call them $lambda_0^("fwd"), lambda_1^("fwd")$, etc. Note that the relation between eigenvalues obtained from this forward problem ($xi_n^("fwd")$ or $chi_n^("fwd")$) must be equal to the original eigenvalues ($xi_n$ or $chi_n$).
- Get the real magnitude $sqrt(K^2 + G^2)$, using the proportion relation mentioned in @eq:prop_M_lambda, with any of the eigenvalues (not necessarily $lambda_0$): $ sqrt(K^2 + G^2) = (lambda_0/lambda_0^("fwd")) sqrt(K_("base")^2 + G_("base")^2). $<eq:M_determination1>
- Finally, get the constants $K$ and $G$ the following way: 
$ K = cos(phi_K), $<eq:isotropic_K_relation> 
$ G = sin(phi_K). $<eq:isotropic_G_relation>

In summary, the problem of getting a model able to predict $K$ and $G$ given the frequencies $omega_n$, the dimensions $L_x$, $L_y$, $L_z$, and the density $rho$ has been transformed into a simpler problem able to predict $phi_K$ given the relation between eigenvalues $xi_n$ of $chi_n$ and the geometric parameters $eta$ and $beta$.

=== Setting new targets in cubic case<sec:cubic_targets>

In the cubic case the elastic constant matrix has the form shown in @eq:cubic_constant_matrix. Lets define the following new variables based on the restrictions specified in @eq:restrictions_cubic_solids:

$ Kappa = 1/3 (C_11 + 2C_12); a = 1/3(C_11 - C_12); mu = C_44. $<eq:cubic_const_tranf>

With these new variables the constant matrix of a cubic solid can be expressed as follows: 

$ arrow.l.r(C) = mat(
  Kappa + 2a, Kappa - a, Kappa - a, 0, 0, 0;
  Kappa - a, Kappa + 2a, Kappa - a, 0, 0, 0;
  Kappa - a, Kappa - a, Kappa + 2a, 0, 0, 0;
  0, 0, 0, mu, 0, 0;
  0, 0, 0, 0, mu, 0;
  0, 0, 0, 0, 0, mu;
) $<eq:cubic_constant_matrix_definitive>

Each of the new variables, has now the following restrictions: 

$ Kappa > 0; a > 0; mu >0. $

Just like the isotropic case, here the eigenvalues are also proportional to the magnitude of the constants. For example the eigenvalues of a solid with values of $Kappa = 5$, $a = 4$ and $mu = 3$ will be half the eigenvalues of a solid, with the same dimensions, with values of $Kappa = 10$, $a = 8$ and $mu = 6$. Thus the following applies to cubic solids: 

$ lambda_n prop M = sqrt(Kappa^2 + a^2 + mu^2), $<eq:prop_M_lambda2>

for a given relation between $Kappa$, $a$ and $mu$. Also in this case the relations between eigenvalues depend only on the relations between constants and the aspect ratio of the sample. The relations between constants will be represented here with the following angles: 

$ phi_Kappa = arctan(sqrt(a^2 + mu^2)/Kappa), $

and, 

$ phi_a = arctan(mu/a). $

In the case of cubic solids, the relation between eigenvalues will be represented only by the variable $chi_n = (lambda_n - lambda_(n-1))/lambda_N$, where $N$ is the maximum number of eigenvalues used, because to train a model able to predict $phi_a$ and $phi_Kappa$ we will need to use more eigenvalues. To be exact $N = 20$ eigenvalues. This makes $xi_n$ a bad candidate for use as a feature, because for large $n$, like $n = 20$, all the values of $xi_n$ will be very close to 1. In the present work the variables $chi_n$ were given a special name: "compositions". This is because $chi_n$ represents the percentage of occupation of the gap between two eigenvalues in the whole spectrum from 0 to the Nth eigenvalue (20th in this case). The first composition $chi_0$ is defined differently as the others: $chi_0 = lambda_0/lambda_N$. Similar to the isotropic case we can create a model able to predict $phi_Kappa$ and $phi_a$ given the values of $chi_n$, $eta$ and $beta$. Once we have that model, we perform the following steps to get $Kappa$, $a$ and $mu$:

- Predict $phi_Kappa$ and $phi_a$ using the values of $chi_n$, $eta$ and $beta$ as the features. 
- Establish an arbitrary base value of magnitude, for example $M = sqrt(Kappa_("base")^2 + a_("base")^2 + mu_("base")^2) = 1$ and calculate a base value of $Kappa$, $a$ and $mu$ using: 
$ Kappa_("base") = M cos(phi_Kappa), $
$ a_("base") = M sin(phi_Kappa)cos(phi_a), $
$ mu_("base") = M sin(phi_Kappa)sin(phi_a). $
- Compute the eigenvalues of the "base" constants performing a forward problem. Lets call them $lambda_0^("fwd"), lambda_1^("fwd")$, etc. Note that the relation between eigenvalues obtained from this forward problem $chi_n^("fwd")$ must be equal to the original eigenvalues $chi_n$.
- Get the real magnitude $sqrt(Kappa^2 + a^2 + mu^2)$, using the proportion relation mentioned in @eq:prop_M_lambda2, with any of the eigenvalues (not necessarily $lambda_0$): $ sqrt(Kappa^2 + a^2 + mu^2) = (lambda_0/lambda_0^("fwd")) sqrt(Kappa_("base")^2 + a_("base")^2 + mu_("base")^2). $<eq:M_determination1>
- Finally, get the constants $Kappa$, $a$ and $mu$ the following way: 
$ Kappa = cos(phi_K), $<eq:cubic_K_relation> 
$ a = sin(phi_Kappa)cos(phi_a), $<eq:cubic_a_relation>
$ mu = sin(phi_Kappa)sin(phi_a). $<eq:cubic_mu_relation>

All the transformations of features and targets, or in general, the transformation of the inverse problem can be summarized in the following flow diagram: 

#figure(
  image("../images/Inverse_diagram.png", width: 100%),
  caption: [Summary of the parts that make up the approach of the inverse problem in the present work.]  
) <fig:diagram_inverse>


