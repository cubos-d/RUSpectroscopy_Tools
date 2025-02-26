= Background Theory <chap:forward>
In this chapter, we will present a Lagrangian that describes the system of the solid sample oscillating between the transducers in the Resonant Ultrasound Spectroscopy setup. To determine the frequencies, we will use the Rayleigh-Ritz method to express the displacements in terms of basis functions and, finally, extremize the Lagrangian to obtain the equation for the generalized eigenvalue problem. Solving this will allow us to derive the resonance frequencies from the constants.
 
#v(1cm)

== The forward problem: Getting the resonance frequencies from the elastic constants
The kinetic energy for a 3D elastic body oscillating inside the setup of the Resonant Ultrasound Spectroscopy is given by: 

$ K = 1/2 integral_V rho dot(u)^2 d V, $<eq:kinetic_raw>

where $rho$ is the density of the sample, $V$ is the volume and $dot(u)$ is the displacement velocity. Assuming periodic behaviour such that $dot(u) = omega u$ and expressing $u^2$ as $u^2 = sum_(i=0)^2 u_i^2 = sum_(i=0)^2 sum_(k=0)^2 delta_("ik") u_i u_k$, the kinetic energy can be expressed as the following #cite(<Leisure_1997>): 

$ K = 1/2 integral_V rho omega^2 ( delta_(i k) u_i u_k ) d V. $<eq:kinetic_middle>

On the other hand, the potential energy density is given by @eq:potential_energy_density. Expressing it with the full index notation and integrating over all the volume of the sample we get: 

$ U = 1/2 integral_V C_(i j k l) epsilon_(i j) epsilon_(k l) d V. $<eq:U_raw_raw>

Replacing the definition of the strain tensor components given by @eq:strain_tensor in @eq:U_raw_raw, we get a new expression for the potential energy:

$ U = 1/2 integral_V  C_(i j k l) (partial u_i)/(partial r_j) (partial u_k)/(partial r_l) d V, $<eq:potential_raw>

where $r_0 = x$, $r_1 = y$, and $r_2 = z$. Using Rayleigh-Ritz method #cite(<Migliori_1993>) $u_i$ displacements can be expressed in terms of base functions the following way:

$ u_i =  a_(i lambda mu nu) phi.alt_(i lambda mu nu). $ <eq:u_in_terms_basis_func>

Every term in @eq:u_in_terms_basis_func follows thw rule: $lambda + mu + nu lt.eq N_g$, where $N_g$ is the maximum degree of the basis functions and is chosen arbitrarily. The higher this number, the greater the number of frequencies obtained from the problem. However, the computational time will also increase, scaling with the 9th power as $N_g$ increases #cite(<Leisure_1997>). The family of basis functions used in the present project is given by: 

$ phi.alt_(i lambda mu nu) = (x/L_x)^lambda (y/L_y)^mu (z/L_z)^nu = X^lambda Y^mu Z^nu, $<eq:Basis_functions>

where $L_x$, $L_y$, $L_z$ are the lengths of the sample in $x$, $y$, $z$ respectively. Replacing $u_i$ from @eq:u_in_terms_basis_func in @eq:kinetic_raw and @eq:potential_raw we get new expressions to kinetic energy and potential energy (remember that the conditions $lambda_1 + mu_1 + nu_1 lt.eq N_g$ and $lambda_2 + mu_2 + nu_2 lt.eq N_g$ must be met): 

$ K = 1/2 rho omega^2 a_(i lambda_1 mu_1 nu_1) Epsilon_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) a_(i lambda_2 mu_2 nu_2), $<eq:kinetic_final>

$ U = 1/2 a_(i lambda_1 mu_1 nu_1) Gamma_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) a_(i lambda_2 mu_2 nu_2), $<eq:potential_final>

where 

$ Epsilon_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) = integral_V delta_( i k) phi.alt_(i lambda_1 mu_1 nu_1) phi.alt_(k lambda_2 mu_2 nu_2) d V $<eq:E_matrix>

and

$ Gamma_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) = sum_(j=0)^2 sum_(l=0)^2 C_(i j k l) integral_V (partial phi.alt_(i lambda_1 mu_1 nu_1))/(partial r_j) (partial phi.alt_(k lambda_2 mu_2 nu_2))/(partial r_l) d V. $<eq:Gamma_matrix>


The constants $a_(i lambda mu nu)$ can be organized inside a vector $arrow(a)$, while the values of $Epsilon_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2)$ and $Gamma_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2)$ can be organized inside the matrices $arrow.l.r(Epsilon)$ and $arrow.l.r(Gamma)$. This way, we can express the kinetic and potential energy in terms of vector and matrix products: 

$ K = 1/2 rho omega^2 arrow(a)^T arrow.l.r(Epsilon) arrow(a), $ <eq:kinetic_matrix>

$ U = 1/2 arrow(a)^T arrow.l.r(Gamma) arrow(a), $ <eq:potential_matrix>

obtaining the following Lagrangian: 

$ cal(L) = K - U = 1/2 rho omega^2 arrow(a)^T arrow.l.r(Epsilon) arrow(a) - 1/2 arrow(a)^T arrow.l.r(Gamma) arrow(a). $ <eq:Lagrangian_final>

By extremizing the Lagrangian, $(delta cal(L))/(delta arrow(a)) = 0$, a generalized eigenvalue problem is obtained #cite(<Leisure_1997>). Solving this generalized eigenvalue problem makes it possible to determine the resonance frequencies of the solid (which are among the eigenvalues) based on its elastic constants. The generalized eigenvalue problem to be solved is shown below:

$ rho omega^2 arrow.l.r(Epsilon) arrow(a) = arrow.l.r(Gamma) arrow(a). $<eq:raw_eig_problem>

Finally, replacing the basis functions of equation @eq:Basis_functions in @eq:E_matrix and @eq:Gamma_matrix,  and then cancelling the $L_x L_y L_z$ in each side of the equation @eq:raw_eig_problem we have that an element of the $arrow.l.r(Epsilon)$ matrix is given by: 

$ Epsilon_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) = integral_V delta_(i k) X^(lambda_1 + lambda_2) Y^(mu_1 + mu_2) Z^(nu_1 + nu_2) d X d Y d Z, $<eq:E_matrix_def>

and an element of the $arrow.l.r(Gamma)$ matrix is given by: 

$ Gamma_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) = sum_(j=0)^2 sum_(l=0)^2 C_(i j k l)/(L_j L_l) integral_V (partial X^(lambda_1) Y^(mu_1) Z^(nu_1) )/(partial b_j) (partial X^(lambda_2) Y^(mu_2) Z^(nu_2) )/(partial b_l) d X d Y d Z, $<eq:Gamma_matrix_def>

where $b_j = r_j/L_j$. In other words: $b_0 = x/L_x = X, b_1 = y/L_y = Y$ and $b_2 = z/L_z = Z$.

== Simplifying the problem: Getting eigenvalues that are independent of the size of the sample

We can see from the equations @eq:Gamma_matrix_def and @eq:raw_eig_problem, that the squared frequencies $omega^2$ depend on the size of the sample. If we measure the frequencies of a certain sample, let's call them $omega_(i)^2$, and then measure the frequencies of a second sample of the same material, same shape, but different size, for example two times the size of the first sample, $L_(x 2) = 2 L_(x 1), L_(y 2) = 2 L_(y 1), L_(z 2) = 2 L_(z 1)$, we will get as a result that the squared frequencies of the second sample are 4 times the frequencies of the first sample. In other words, with the second sample we would get the following frequencies: $4 omega_(i)^2$. We want to be able to get the constants of every sample regardless the size of the sample.

Let's multiply to both sides of the equation @eq:raw_eig_problem the following: $V/R$, where $V$ is the volume of the sample and 

$ R = sqrt(L_x^2 + L_y^2 + L_z^2). $<eq:R>

This way the @eq:raw_eig_problem is now as follows: 

 $ rho V omega^2/R arrow.l.r(Epsilon) arrow(a) = V/R arrow.l.r(Gamma) arrow(a). $<eq:eig_preparing>

Let's define a new matrix $arrow.l.r(Kai) = V/R arrow.l.r(Gamma)$. With this definition we have the final generalized eigenvalue problem to solve: 

$ lambda arrow.l.r(Epsilon) arrow(a) = arrow.l.r(Kai) arrow(a). $<eq:eig_final>

In equation @eq:eig_final $lambda = m omega^2/R$ and an element of the matrix $arrow.l.r(Kai)$ is given by:  

$ Kai_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) = sum_(j=0)^2 sum_(l=0)^2 L_(j l)/R C_(i j k l) integral_V (partial X^(lambda_1) Y^(mu_1) Z^(nu_1) )/(partial Re_j) (partial X^(lambda_2) Y^(mu_2) Z^(nu_2) )/(partial Re_l) d X d Y d Z, $<eq:Peso_matrix_def>

where $L_(j l) = L_(3 - j - l)$ if $j != l$. Else $L_(j l) = (L_x L_y L_z)/L_j^2$.

From the equations @eq:eig_final and @eq:Peso_matrix_def we can note that $lambda$ eigenvalues do not depend on the size of the sample. They only depend on the values of the constants and the shape of the sample (but not it's size).

== Examples of eigenvalues spectra for a sphere isotropic material

Using @eq:Peso_matrix_def we can get the eigenvalues $lambda_n$ of a spheric solid, made of an isotropic material with relation between the Bulk Modulus $K$ and the shear modulus $G$ of $K/G = 7/1$, in the following scatterplot: 
#figure(
  image("../images/eigenvals_degeneration.png", width: 100%),
  caption: "Eigenvalues of a spheric isotropic solid with relation of bulk modulus:shear modulus of 7:1"

) <fig:degenerate_eigenvalues>

It can be noted that there is a lot of degenerate eigenvalues, and the number of degenerate eigenvalues in each leves is odd. This is due to the isotropic nature of the material, and it's sphericalñ geometry.  

== Defining the shape of a 3D sample with two parameters

TODO: Define $eta$ and $beta$ and explian why these two parameters can define the shape of a solid. 
