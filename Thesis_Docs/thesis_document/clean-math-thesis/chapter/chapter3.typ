= The forward problem <chap:forward>
In this chapter, we will present a Lagrangian that describes the system of the solid sample oscillating between the transducers in the Resonant Ultrasound Spectroscopy setup. To determine the frequencies, we will use the Rayleigh-Ritz method to express the displacements in terms of basis functions and, finally, extremize the Lagrangian to obtain the equation for the generalized eigenvalue problem. Solving this will allow us to derive the resonance frequencies from the constants. This is, solving the forward problem. 
 
#v(1cm)

== The forward problem: Getting the resonance frequencies from the elastic constants
The kinetic energy for a 3D elastic body oscillating inside the setup of the Resonant Ultrasound Spectroscopy is given by: 

$ K = 1/2 integral_V rho dot(u)^2 d V, $<eq:kinetic_raw>

where $rho$ is the density of the sample, $V$ is the volume and $dot(u)$ is the displacement velocity. Assuming periodic behaviour such that $dot(u) = omega u$ and expressing $u^2$ as $u^2 = sum_(i=0)^2 u_i^2 = sum_(i=0)^2 sum_(k=0)^2 delta_(i k) u_i u_k$, the kinetic energy can be expressed as the following #cite(<Leisure_1997>): 

$ K = 1/2 integral_V rho omega^2 ( delta_(i k) u_i u_k ) d V. $<eq:kinetic_middle>

On the other hand, the potential energy density is given by @eq:raw_potential_energy_density. Expressing it with the full index notation (not Voigt notation) and integrating over all the volume of the sample we get: 

$ U = 1/2 integral_V C_(i j k l) epsilon_(i j) epsilon_(k l) d V. $<eq:U_raw_raw>

Replacing the definition of the strain tensor components given by @eq:strain_tensor in @eq:U_raw_raw, we get a new expression for the potential energy:

$ U = 1/2 integral_V  C_(i j k l) (partial u_i)/(partial r_j) (partial u_k)/(partial r_l) d V, $<eq:potential_raw>

where $r_0 = x$, $r_1 = y$, and $r_2 = z$. Using Rayleigh-Ritz method #cite(<Migliori_1993>) $u_i$ displacements can be expressed in terms of base functions the following way:

$ u_i =  a_(i lambda mu nu) phi.alt_(lambda mu nu). $ <eq:u_in_terms_basis_func>

Every term in @eq:u_in_terms_basis_func follows the rule: $lambda + mu + nu lt.eq N_g$, where $N_g$ is the maximum degree of the basis functions and is chosen arbitrarily. The higher this number, the greater the number of frequencies obtained from the problem. However, the computational time will also increase, scaling with the 9th power as $N_g$ increases #cite(<Leisure_1997>). The family of basis functions used in the present project is given by: 

$ phi.alt_(lambda mu nu) = (x/L_x)^lambda (y/L_y)^mu (z/L_z)^nu = X^lambda Y^mu Z^nu, $<eq:Basis_functions>

where $L_x$, $L_y$, $L_z$ are the lengths of the sample in $x$, $y$, $z$ respectively. Replacing $u_i$ from @eq:u_in_terms_basis_func in @eq:kinetic_raw and @eq:potential_raw we get new expressions to kinetic energy and potential energy (remember that the conditions $lambda_1 + mu_1 + nu_1 lt.eq N_g$ and $lambda_2 + mu_2 + nu_2 lt.eq N_g$ must be met): 

$ K = 1/2 rho omega^2 a_(i lambda_1 mu_1 nu_1) Epsilon_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) a_(k lambda_2 mu_2 nu_2), $<eq:kinetic_final>

$ U = 1/2 a_(i lambda_1 mu_1 nu_1) Gamma_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) a_(k lambda_2 mu_2 nu_2), $<eq:potential_final>

where 

$ Epsilon_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) = integral_V delta_( i k) phi.alt_(i lambda_1 mu_1 nu_1) phi.alt_(k lambda_2 mu_2 nu_2) d V $<eq:E_matrix>

and

$ Gamma_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) = sum_(j=0)^2 sum_(l=0)^2 C_(i j k l) integral_V (partial phi.alt_(i lambda_1 mu_1 nu_1))/(partial r_j) (partial phi.alt_(k lambda_2 mu_2 nu_2))/(partial r_l) d V. $<eq:Gamma_matrix>

The constants $a_(i lambda mu nu)$ can be organized inside a vector $arrow(a)$. The organization of this vector can be arbitrary as long it is consistent with the organization of the values of $arrow.l.r(Epsilon)$ and $arrow.l.r(Gamma)$ in their respective matrices. In the present project, all the combinations of $lambda, mu, nu$ concerning the displacement in $x$ ($u_x$) were put first, then the values concerning the displacement in $y$ ($u_y$) and finally the values concerning the displacement in $z$ ($u_z$), creating the vector in three blocks. In each block, we have all the possible combinations of $lambda, mu, nu$ where $lambda + mu + nu lt.eq N_g$. Each block was generated according the following code in C:
#figure(
  table(
    columns: 1, 
  [```C
int **generate_combinations(int N) {
    int R = ((N + 1) * (N + 2) * (N + 3))/6;

    int **combi = (int **)malloc(R * sizeof(int *));
    for (int i = 0; i < R; i++)
	{
        combi[i] = (int *)malloc(3 * sizeof(int));
    }

    int l = 0;
    for (int n = 0; n <= N; n++) {
        for (int i = 0; i <= n; i++) {
            for (int j = 0; j <= n - i; j++) {
                int k = n - i - j;
                combi[l][0] = i;
                combi[l][1] = j;
                combi[l][2] = k;
                l++;
            }
        }
    }
    return combi;
}
```
    ],
  ),
  caption: [Code to generate all the possible combinations where $lambda + mu + nu lt.eq N_g$.]
)<code:index_combinations>

In @code:index_combinations, we can see the pointer "combi" as a matrix where each row is a combination of indices $lambda, mu, nu$. The first column contains the value of $lambda$ the second one contains the value of $mu$ and the third one contains the value of $nu$. The values of each block in $arrow(a)$ are arranged in the same order as the rows in the "combi" matrix are arranged. For example, with a value of $N_g = 1$ we get the following vector $arrow(a)$:

$ arrow(a) = mat(a_(x 000), a_(x 001), a_(x 010), a_(x 100), a_(y 000), a_(y 001), a_(y 010), a_(y 100), a_(z 000), a_(z 001), a_(z 010), a_(z 100))^T $<eq:whois_baby_a>

Note that each block have the combinations of indices 000, 001, 010 and 100. With an $N_g = 2$ we get the following $arrow(a)$:

$ arrow(a) = mat(a_(x 000), a_(x 001), a_(x 010), a_(x 100), a_(x 200), a_(x 011), a_(x 020), a_(x 101), a_(x 110), a_(x 200), a_(y 000), a_(y 001), a_(y 010), dots)^T $<eq:whois_a>

On the other hand, the values of $Epsilon_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2)$ and $Gamma_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2)$ can be organized inside the matrices $arrow.l.r(Epsilon)$ and $arrow.l.r(Gamma)$. In those matrices, the row position is determined by the indices before the semicolon ($i, lambda_1, mu_1, nu_1$) in the same order the indexes $i, lambda, mu, nu$ are organized in $arrow(a)$, while the column position is determined by the indices after the semicolon ($k, lambda_2, mu_2, nu_2$), also in the same order as the indexes in $arrow(a)$.

Here is an example of $arrow.l.r(Epsilon)$ matrix built with a value of $N_g = 1$: 

$ arrow.l.r(Epsilon) = integral_V mat(1, z, y, x, 0, 0, 0, 0, 0, 0, 0, 0;
                           z, z^2, y z, x z, 0, 0, 0, 0, 0, 0, 0, 0;
                           y, z y, y^2, x y, 0, 0, 0, 0, 0, 0, 0, 0;
                           x, x z, x y, x^2, 0, 0, 0, 0, 0, 0, 0, 0;
                           0, 0, 0, 0, 1, z, y, x, 0, 0, 0, 0, ;
                           0, 0, 0, 0, z, z^2, y z, x z, 0, 0, 0, 0;
                           0, 0, 0, 0, y, y z, y^2, x y, 0, 0, 0, 0;
                           0, 0, 0, 0, x, x z, x y, x^2, 0, 0, 0, 0;
                           0, 0, 0, 0, 0, 0, 0, 0, 1, z, y, x;
                           0, 0, 0, 0, 0, 0, 0, 0, z, z^2, y z, x z;
                           0, 0, 0, 0, 0, 0, 0, 0, y, y z, y^2, x y;
                           0, 0, 0, 0, 0, 0, 0, 0, x, x z, x y, x^2;
                          ) d V, $<eq:E_matrix_example>

This way, we can express the kinetic and potential energy in terms of vector and matrix products: 

$ K = 1/2 rho omega^2 arrow(a)^T arrow.l.r(Epsilon) arrow(a), $ <eq:kinetic_matrix>

$ U = 1/2 arrow(a)^T arrow.l.r(Gamma) arrow(a), $ <eq:potential_matrix>

Finally, having both the potential and kinetic energy we have the following expression for the Lagrangian: 

$ cal(L) = K - U = 1/2 rho omega^2 arrow(a)^T arrow.l.r(Epsilon) arrow(a) - 1/2 arrow(a)^T arrow.l.r(Gamma) arrow(a). $ <eq:Lagrangian_final>

By extremizing the Lagrangian, $(delta cal(L))/(delta arrow(a)) = 0$, a generalized eigenvalue problem is obtained #cite(<Leisure_1997>). Solving this generalized eigenvalue problem makes it possible to determine the resonance frequencies of the solid (which are among the eigenvalues) based on its elastic constants. The generalized eigenvalue problem to be solved is shown below:

$ rho omega^2 arrow.l.r(Epsilon) arrow(a) = arrow.l.r(Gamma) arrow(a). $<eq:raw_eig_problem>

Finally, replacing the basis functions of equation @eq:Basis_functions in @eq:E_matrix and @eq:Gamma_matrix,  and then cancelling the $L_x L_y L_z$ in each side of the equation @eq:raw_eig_problem we have that an element of the $arrow.l.r(Epsilon)$ matrix is given by: 

$ Epsilon_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) = integral_V delta_(i k) X^(lambda_1 + lambda_2) Y^(mu_1 + mu_2) Z^(nu_1 + nu_2) d X d Y d Z, $<eq:E_matrix_def>

and an element of the $arrow.l.r(Gamma)$ matrix is given by: 

$ Gamma_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) = sum_(j=0)^2 sum_(l=0)^2 C_(i j k l)/(L_j L_l) integral_V (partial X^(lambda_1) Y^(mu_1) Z^(nu_1) )/(partial b_j) (partial X^(lambda_2) Y^(mu_2) Z^(nu_2) )/(partial b_l) d X d Y d Z, $<eq:Gamma_matrix_def>

where $b_j = r_j/L_j$. In other words: $b_0 = x/L_x = X, b_1 = y/L_y = Y$ and $b_2 = z/L_z = Z$.


//PLACE HERE THE EXAMPLE OF GAMMA MATRIX


== Examples of eigenvalues spectra for a sphere isotropic material

Using @eq:Peso_matrix_def we can get the eigenvalues $omega_n$ of a spheric solid, made of an isotropic material with relation between the Bulk Modulus $K$ and the shear modulus $G$ of $K/G = 7/1$, in the following scatterplot: 
#figure(
  image("../images/eigenvals_degeneration.png", width: 100%),
  caption: "Eigenvalues of a spheric isotropic solid with relation of bulk modulus:shear modulus of 7:1"

) <fig:degenerate_eigenvalues>

It can be noted that there is a lot of degenerate eigenvalues, and the number of degenerate eigenvalues in each level is odd. This is due to the isotropic nature of the material, and it's spherical geometry.  


