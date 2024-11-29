= The forward problem <chap:forward>
In this chapter, we will present a Lagrangian that describes the system of the solid sample oscillating between the transducers in the Resonant Ultrasound Spectroscopy setup. To determine the frequencies, we will use the Rayleigh-Ritz method to express the displacements in terms of basis functions and, finally, extremize the Lagrangian to obtain the equation for the generalized eigenvalue problem. Solving this will allow us to derive the resonance frequencies from the constants.
 
#v(1cm)

The kinetic energy for a 3D elastic body oscillating inside the setup of the Resonant Ultrasound Spectroscopy is given by: 

$ K = 1/2 integral_V rho dot(u)^2 d V, $<eq:kinetic_raw>

where $rho$ is the density of the sample, $V$ is the volume and $dot(u)$ is the displacement velocity. Assuming periodic behaviour such that $dot(u) = omega u$ and expressing $u^2$ as $u^2 = sum_(i=0)^2 u_i^2 = sum_(i=0)^2 sum_(k=0)^2 delta_("ik") u_i u_k$, the kinetic energy can be expressed as the following #cite(<Leisure_1997>): 

$ K = 1/2 integral_V rho omega^2 (sum_(i=0)^2 sum_(k=0)^2 delta_("ik") u_i u_k ) d V. $<eq:kinetic_middle>

On the other hand, the potential energy density is given by @eq:potential_energy_density. Expressing it with the full index notation and integrating over all the volume of the sample we get: 

$ U = 1/2 integral_V sum_(i=0)^2 sum_(j=0)^2 sum_(k=0)^2 sum_(l=0)^2 C_("ijkl") epsilon_("ij") epsilon_("kl") d V. $<eq:U_raw_raw>

Replacing the definition of the strain tensor components given by @eq:strain_tensor in @eq:U_raw_raw, we get a new expression for the potential energy:

$ U = 1/2 integral_V sum_(i=0)^2 sum_(j=0)^2 sum_(k=0)^2 sum_(l=0)^2 C_("ijkl") (partial u_i)/(partial r_j) (partial u_k)/(partial u_l) d V. $<eq:potential_raw>

Using Rayleigh-Ritz method #cite(<Migliori_1993>) $u_i$ displacements can be expressed in terms of base functions the following way:

$ u_i = sum_(lambda, mu, nu = 0)^(lambda + mu + nu lt.eq N_g) a_(i lambda mu nu) phi.alt_(i lambda mu nu), $ <eq:u_in_terms_basis_func>

where $N_g$ is the maximum degree of the basis functions and is, chosen arbitrarily. The higher this number, the greater the number of frequencies obtained from the problem. However, the computational time will also increase, scaling with the 9th power as $N_g$ increases #cite(<Leisure_1997>). The family of basis functions that was used in the present project is given by: 

$ phi.alt_(i lambda mu nu) = (x/L_x)^lambda (y/L_y)^mu (z/L_z)^nu = X^lambda Y^mu Z^nu, $

where $L_x$, $L_y$, $L_z$ are the lengths of the sample in $x$, $y$, $z$ respectively. Replacing $u_i$ from @eq:u_in_terms_basis_func in @eq:kinetic_raw and @eq:potential_raw we get new expressions to kinetic energy and potential energy: 

$ K = 1/2 rho omega^2 sum_(i=0)^2 sum_(k=0)^2 sum_(lambda_1, mu_1, nu_1 = 0)^(lambda_1 + mu_1 + nu_1 lt.eq N_g) sum_(lambda_2, mu_2, nu_2 = 0)^(lambda_2 + mu_2 + nu_2 lt.eq N_g) a_(i lambda_1 mu_1 nu_1) (Epsilon_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2)) a_(i lambda_2 mu_2 nu_2), $<eq:kinetic_final>

$ U = 1/2 sum_(i=0)^2 sum_(k=0)^2 sum_(lambda_1, mu_1, nu_1 = 0)^(lambda_1 + mu_1 + nu_1 lt.eq N_g) sum_(lambda_2, mu_2, nu_2 = 0)^(lambda_2 + mu_2 + nu_2 lt.eq N_g) a_(i lambda_1 mu_1 nu_1) (Gamma_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2)) a_(i lambda_2 mu_2 nu_2), $<eq:potential_final>

where 

$ Epsilon_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) = integral_V delta_( i k) phi.alt_(i lambda_1 mu_1 nu_1) phi.alt_(k lambda_2 mu_2 nu_2) d V $<eq:E_matrix>

and

$ Gamma_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) = sum_(j=0)^2 sum_(l=0)^2 C_("ijkl") integral_V (partial phi.alt_(i lambda_1 mu_1 nu_1))/(partial r_j) (partial phi.alt_(k lambda_2 mu_2 nu_2))/(partial r_l) d V. $<eq:Gamma_matrix>

The constants $a_(i lambda mu nu)$ can be organized inside a vector $arrow(a)$, while the values of $Epsilon_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2)$ and $Gamma_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2)$ can be organized inside the matrices $arrow.l.r(Epsilon)$ and $arrow.l.r(Gamma)$. This way, we can express the kinetic and potential energy in terms of vector and matrix products: 

$ K = 1/2 rho omega^2 arrow(a)^T arrow.l.r(Epsilon) arrow(a), $ <eq:kinetic_matrix>

$ U = 1/2 arrow(a)^T arrow.l.r(Gamma) arrow(a), $ <eq:potential_matrix>

obtaining the following Lagrangian: 

$ cal(L) = K - U = 1/2 rho omega^2 arrow(a)^T arrow.l.r(Epsilon) arrow(a) - 1/2 arrow(a)^T arrow.l.r(Gamma) arrow(a). $ <eq:Lagrangian_final>

By extremizing the Lagrangian, $(partial cal(L))/(partial arrow(a)) = 0$, a generalized eigenvalue problem is obtained. Solving this generalized eigenvalue problem makes it possible to determine the resonance frequencies of the solid (which are among the eigenvalues) based on its elastic constants. The generalized eigenvalue problem to be solved is shown below:

$ rho omega^2 arrow.l.r(Epsilon) arrow(a) = arrow.l.r(Gamma) arrow(a) $<eq:raw_eig_problem>

TODO: Replace the basis functions and express gamma in terms of adimensional coordinates
