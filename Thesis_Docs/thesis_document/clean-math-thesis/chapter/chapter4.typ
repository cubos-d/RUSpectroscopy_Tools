= Making the inverse problem a simpler one <chap:transformations>

In the previous chapter we discussed how to get the resonance frequencies of a sample given the elastic constants, the mass (or density) and the dimensions of the sample, in Resonant Ultrasound Spectroscopy. This was called: The Forward Problem. In this chapter we will discuss some variable transformations, and other tricks to solve the inverse problem, before attempting to solve it yet. We will discuss why it is important to simplify the problem and make such transformations and which transformations we will do to simplify the inverse problem.  

#v(1cm)

== Why we need to make some tweaks before solving the inverse problem

To solve the inverse problem we would need to make a model that is able to predict the elastic constants $C_(i j)$ given the mass or the density of the sample $m$ or $rho$, the dimensions of the sample $L_x, L_y, L_z$ and the resonance frequencies $omega_n$. This way, we can generate data with different values of constants, mass, and dimensions. Then perform forward problems for each combination of parameters and save the computed frequencies. With that data we can train a machine learning model that receives the frequencies, mass and dimensions as features, and tries to predict the constants as the targets. Easy as pie right? Wrong!. Solving this problem is way too complex and needs to be simplified for the following reasons, even supposing that we are solving the inverse problem just for the isotropic case, which is the easiest and only has two independent constants: 

- We need to, either generate data of all possible dimensions with $L_i$ ranging between 0 and infinite, which is quite difficult not to say impossible, or generate data for a very specific range of dimensions, which would make our model useless for solving the problem for samples out of that range. Here we want our solution to work well regardless the dimensions or the size of the sample. It should work with every parallelepiped sample. 

- We need to generate data of the constants in some unknown range in principle. To know the range we can search some common values of constants of some known materials in literature, but that would make our model only useful to predict known constants, and that is not the objective. We want to make a tool able to predict the constants of unknown materials. Fortunately physics dictate the limits those constants have, and Mouhat's study explains those limits quite well #cite(<Mouhat_2014>). In the case of cubic solids those limits were explained in @section:Constant_Restrictions. According to those limits we will transform the constant data, in a way that the targets have a well defined range.   

- As we will see later, the frequencies are not fully independent. They have heavy collinearity, which is a problem, because lots of features are giving us basically the same information. 

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

$ Kai_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) = sum_(j=0)^2 sum_(l=0)^2 L_(j l)/R C_(i j k l) integral_V (partial X^(lambda_1) Y^(mu_1) Z^(nu_1) )/(partial b_j) (partial X^(lambda_2) Y^(mu_2) Z^(nu_2) )/(partial b_l) d X d Y d Z, $<eq:Peso_matrix_def>

where $L_(j l) = L_(6 - j - l)$ if $j != l$. Else $L_(j l) = (L_x L_y L_z)/L_j^2$.

From the equations @eq:eig_final and @eq:Peso_matrix_def we can note that $lambda$ eigenvalues do not depend on the size of the sample. They only depend on the values of the constants and the shape of the sample (but not it's size).

== Defining the shape of a 3D sample with two parameters

TODO: Define $eta$ and $beta$ and explian why these two parameters can define the shape of a solid. 
