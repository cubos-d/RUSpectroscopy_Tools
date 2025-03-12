= Making the inverse problem a simpler one <chap:transformations>

== Simplifying the problem: Getting eigenvalues that are independent of the size of the sample

We can see from the equations @eq:Gamma_matrix_def and @eq:raw_eig_problem, that the squared frequencies $omega^2$ depend on the size of the sample. If we measure the frequencies of a certain sample, let's call them $omega_(i)^2$, and then measure the frequencies of a second sample of the same material, same shape, but different size, for example two times the size of the first sample, $L_(x 2) = 2 L_(x 1), L_(y 2) = 2 L_(y 1), L_(z 2) = 2 L_(z 1)$, we will get as a result that the squared frequencies of the second sample are 4 times the frequencies of the first sample. In other words, with the second sample we would get the following frequencies: $4 omega_(i)^2$. We want to be able to get the constants of every sample regardless the size of the sample.

Let's multiply to both sides of the equation @eq:raw_eig_problem the following: $V/R$, where $V$ is the volume of the sample and 

$ R = sqrt(L_x^2 + L_y^2 + L_z^2). $<eq:R>

This way the @eq:raw_eig_problem is now as follows: 

 $ rho V omega^2/R arrow.l.r(Epsilon) arrow(a) = V/R arrow.l.r(Gamma) arrow(a). $<eq:eig_preparing>

Let's define a new matrix $arrow.l.r(Kai) = V/R arrow.l.r(Gamma)$. With this definition we have the final generalized eigenvalue problem to solve: 

$ lambda arrow.l.r(Epsilon) arrow(a) = arrow.l.r(Kai) arrow(a). $<eq:eig_final>

In equation @eq:eig_final $lambda = m omega^2/R$ and an element of the matrix $arrow.l.r(Kai)$ is given by:  

$ Kai_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) = sum_(j=0)^2 sum_(l=0)^2 L_(j l)/R C_(i j k l) integral_V (partial X^(lambda_1) Y^(mu_1) Z^(nu_1) )/(partial b_j) (partial X^(lambda_2) Y^(mu_2) Z^(nu_2) )/(partial b_l) d X d Y d Z, $<eq:Peso_matrix_def>

where $L_(j l) = L_(3 - j - l)$ if $j != l$. Else $L_(j l) = (L_x L_y L_z)/L_j^2$.

From the equations @eq:eig_final and @eq:Peso_matrix_def we can note that $lambda$ eigenvalues do not depend on the size of the sample. They only depend on the values of the constants and the shape of the sample (but not it's size).

== Defining the shape of a 3D sample with two parameters

TODO: Define $eta$ and $beta$ and explian why these two parameters can define the shape of a solid. 
