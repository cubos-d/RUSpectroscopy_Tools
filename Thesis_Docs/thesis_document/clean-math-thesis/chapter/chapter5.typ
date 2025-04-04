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

In equation @eq:eig_final $lambda = m omega^2/R$ and an element of the matrix $arrow.l.r(Kai)$ is given by:  

$ Kai_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) = sum_(j=1)^3 sum_(l=1)^3 L_(j l)/R C_(i j k l) integral_V (partial X^(lambda_1) Y^(mu_1) Z^(nu_1) )/(partial b_j) (partial X^(lambda_2) Y^(mu_2) Z^(nu_2) )/(partial b_l) d X d Y d Z, $<eq:Peso_matrix_def>

where $L_(j l) = L_(6 - j - l)$ if $j != l$. Else $L_(j l) = (L_x L_y L_z)/L_j^2$.

From the equations @eq:eig_final and @eq:Peso_matrix_def we can note that $lambda$ eigenvalues do not depend on the size of the sample, because $L_(j l)/R$ does not change with the size of the sample, and only changes with the proportions of $L_x$, $L_y$ and $L_z$. In summary, the eigenvalues $lambda$ only depend on the values of the elastic constants and the aspect ratio of the sample. This way we can eliminate the feature of the sample size, encoded in the variables $L_x$, $L_y$ and $L_z$, and we will see how right now. 

== Defining the shape of a 3D sample with two parameters

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

$ L_x = R sin(1/2 eta) cos(1/4 beta), L_y = R sin(1/2 eta) cos(1/4 beta), L_z = R cos(1/2 eta). $<eq:dim_in_terms_of_eta_and_beta>

These transformed angles yield to values of $L_x$, $L_y$ and $L_z$ that are always positive allowing us to move all around the new sphere. For example a value of $eta$ of $pi/2$ (in the equator of the new sphere) means that $L_z = sqrt(L_x^2 + L_y^2)$, a value of $eta$ close to 0 means that $L_z >> sqrt(L_x^2 + L_y^2)$ and a value of $eta$ close to $pi$ means that $L_z << sqrt(L_x^2 + L_y^2)$. On the other hand a value of $beta$ of $pi$ means that $L_x = L_y$, a value of $beta$ close to 0 means that $L_x >> L_y$ and a value of $beta$ close to $2 pi$ means that $L_x << L_y$. 

lets assign the largest dimension as $L_z$ always and the lowest dimension as $L_y$.  

OK THERE IS A LOT TO WRITE AND DEFINE BEFORE SHOWING MUTUAL INFO. The following is a short analysis that will be paraphrased in the final version:

Let's take a look at the mutual information. Ok @fig:MI_cubic looks meh! It was obvious, because $eta$ and $beta$ were created independently from $phi_K$ and $phi_a$. What is comforting me is the fact that the first compositions are, apparently, the ones which most affect the targets. 

#figure(
  image("../images/MI_phia_phiK.png", width:100%),
  caption: [Mutual information between the features and the targets in the cubic case.]
)<fig:MI_cubic>
