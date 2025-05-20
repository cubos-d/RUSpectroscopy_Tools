= The forward problem <chap:forward>
In this chapter, we will present a Lagrangian approach that describes a solid sample oscillating between the transducers in the resonant ultrasound spectroscopy setup. To determine the frequencies, we will use the Rayleigh-Ritz method to express the displacements in terms of basis functions and, finally, extremize the Lagrangian to obtain a generalized eigenvalue problem relating resonance frequencies to the elasticity tensor. Solving this eigenproblem will allow us to derive the resonance frequencies from the elastic constants. This is known as the forward problem. 
 
#v(1cm)

== The forward problem: Resonance frequencies from elastic constants
The kinetic energy for a three spatial dimensional (3D) elastic oscillating body is given by

$ K = 1/2 integral_V rho dot(u)^2 d V, $<eq:kinetic_raw>

where $rho$ is the density of the sample, $V$ is its volume and $dot(u)$ is the velocity. Assuming harmonic behavior such that $dot(u) = plus.minus i omega u$ and expressing $u^2$ as $u^2 = sum_(i=0)^2 u_i^2 = sum_(i=0)^2 sum_(k=0)^2 delta_(i k) u_i u_k$, the kinetic energy can be expressed as the following #cite(<Leisure_1997>): 

$ K = 1/2 integral_V rho omega^2 ( delta_(i k) u_i u_k ) d V. $<eq:kinetic_middle>

On the other hand, the potential energy density is given by @eq:raw_potential_energy_density. Expressing it with the full index notation (not Voigt notation) and integrating over all the volume of the sample we get the potential energy of an elastic body of volume $V$: 

$ U = 1/2 integral_V C_(i j k l) epsilon_(i j) epsilon_(k l) d V. $<eq:U_raw_raw>

Replacing the definition of the strain tensor components given by @eq:strain_tensor in @eq:U_raw_raw, we get a new expression for the potential energy:

$ U = 1/2 integral_V  C_(i j k l) (partial u_i)/(partial r_j) (partial u_k)/(partial r_l) d V, $<eq:potential_raw>

where $r_1 = x$, $r_2 = y$, and $r_3 = z$. Using Rayleigh-Ritz method, described in @apx:Rayleigh-ritz, the $u_i$ displacements can be expressed in terms of basis functions the following way #cite(<Migliori_1993>):

$ u_i =  a_(i lambda mu nu) phi.alt_(lambda mu nu), $ <eq:u_in_terms_basis_func>

where $phi.alt_(lambda mu nu)$ is a function of a given basis (for example $phi.alt_(1 2 3) = (x/L_x) (y/L_y)^2 (z/L_z)^3$) and $a_(i lambda mu nu)$ is a coefficient, called weight. Every term in @eq:u_in_terms_basis_func follows the rule: $lambda + mu + nu lt.eq N_g$, where $N_g$ is the maximum degree of the basis functions and is chosen arbitrarily. The higher this number is, the more accurate the approximation to $vec(u)$ is and the greater the number of frequencies obtained. However, the computational time will also increase, scaling with the 9th power as $N_g$ increases #cite(<Leisure_1997>). The family of basis functions used in this work are given by 

$ phi.alt_(lambda mu nu) = (x/L_x)^lambda (y/L_y)^mu (z/L_z)^nu = X^lambda Y^mu Z^nu, $<eq:Basis_functions>

where $L_x$, $L_y$, $L_z$ are the lengths of the sample in the $x$, $y$, $z$ directions, respectively. Replacing $u_i$ from @eq:u_in_terms_basis_func in @eq:kinetic_raw and @eq:potential_raw we get new expressions for the kinetic energy and the potential energy (remember that the conditions $lambda_1 + mu_1 + nu_1 lt.eq N_g$ and $lambda_2 + mu_2 + nu_2 lt.eq N_g$ must be met): 

$ K = 1/2 rho omega^2 a_(i lambda_1 mu_1 nu_1) Epsilon_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) a_(k lambda_2 mu_2 nu_2), $<eq:kinetic_final>

$ U = 1/2 a_(i lambda_1 mu_1 nu_1) Gamma_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) a_(k lambda_2 mu_2 nu_2), $<eq:potential_final>

where 

$ Epsilon_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) = integral_V delta_( i k) phi.alt_(lambda_1 mu_1 nu_1) phi.alt_(lambda_2 mu_2 nu_2) d V $<eq:E_matrix>

and

$ Gamma_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) = C_(i j k l) integral_V (partial phi.alt_(lambda_1 mu_1 nu_1))/(partial r_j) (partial phi.alt_(lambda_2 mu_2 nu_2))/(partial r_l) d V. $<eq:Gamma_matrix>

The weights $a_(i lambda mu nu)$ can be organized in a vector $arrow(a)$. Here, all the combinations of $lambda, mu, nu$ concerning the displacement in $x$ ($u_x$) were put first, then the values concerning the displacement in $y$ ($u_y$) and finally the values concerning the displacement in $z$ ($u_z$), creating the vector in three $N_g$ dimensional blocks. In each block, we have all the possible combinations of $lambda, mu, nu$ where $lambda + mu + nu lt.eq N_g$. Each block was generated according the following code in C:
#figure(
  table(
    columns: 1, 
  [```C
int **generate_combinations(int N) {
    int R = ((N + 1) * (N + 2) * (N + 3))/6;

    int **combi = (int **)malloc(R * sizeof(int *));
    for (int i = 0; i < R; i++) {
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

In @code:index_combinations, we can see the pointer "combi" as a matrix where each row is a combination of indices $lambda, mu, nu$. The first column contains the value of $lambda$, the second one contains the value of $mu$, and the third one contains the value of $nu$. The values of each block in $arrow(a)$ are arranged in the same order as the rows in the "combi" matrix are arranged. For example, with a value of $N_g = 1$ we get the following vector $arrow(a)$:

$ arrow(a) = mat(a_(x 000), a_(x 001), a_(x 010), a_(x 100), a_(y 000), a_(y 001), a_(y 010), a_(y 100), a_(z 000), a_(z 001), a_(z 010), a_(z 100))^T. $<eq:whois_baby_a>

Note that each block have the combinations of indices 000, 001, 010 and 100. With an $N_g = 2$ we get the following $arrow(a)$:

$ arrow(a) = mat(a_(x 000), a_(x 001), a_(x 010), a_(x 100), a_(x 002), a_(x 011), a_(x 020), a_(x 101), a_(x 110), a_(x 200), a_(y 000), a_(y 001), a_(y 010), dots)^T $<eq:whois_a>

On the other hand, the values of $Epsilon_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2)$ and $Gamma_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2)$ can be organized in matrices $arrow.l.r(Epsilon)$ and $arrow.l.r(Gamma)$. In those matrices, the row position is determined by the indices before the semicolon ($i, lambda_1, mu_1, nu_1$) in the same order the indices $i, lambda, mu, nu$ are organized in $arrow(a)$, while the column position is determined by the indices after the semicolon ($k, lambda_2, mu_2, nu_2$), also in the same order as the indices in $arrow(a)$. Equation @eq:E_matrix_example shows an example of an $arrow.l.r(Epsilon)$ matrix built for $N_g = 1$.

This way, we can express the kinetic and potential energies in terms of vector and matrix products: 

$ K = 1/2 rho omega^2 arrow(a)^T arrow.l.r(Epsilon) arrow(a), $ <eq:kinetic_matrix>

$ U = 1/2 arrow(a)^T arrow.l.r(Gamma) arrow(a). $ <eq:potential_matrix>

Finally, having both the potential and kinetic energies we have the following expression for the Lagrangian: 

$ L = K - U = 1/2 rho omega^2 arrow(a)^T arrow.l.r(Epsilon) arrow(a) - 1/2 arrow(a)^T arrow.l.r(Gamma) arrow(a). $ <eq:Lagrangian_final>

By extremizing the Lagrangian, $(delta L)/(delta arrow(a)) = 0$, a generalized eigenvalue problem is obtained #cite(<Leisure_1997>)

$ rho omega^2 arrow.l.r(Epsilon) arrow(a) = arrow.l.r(Gamma) arrow(a). $<eq:raw_eig_problem>

As shown below in @eq:Gamma_matrix_def, the matrix $arrow.l.r(Gamma)$ depends on the elastic constants, $C_(i j k l)$, and the dimensions of the sample, $L_x$, $L_y$ and $L_z$. Solving this generalized eigenvalue problem makes it possible to determine the resonance frequencies of the solid, contained in the eigenvalues, based on the elasticity tensor. Replacing the basis functions of equation @eq:Basis_functions in @eq:E_matrix and @eq:Gamma_matrix,  and then cancelling the $L_x L_y L_z$ in each side of equation @eq:raw_eig_problem we have that an element of the $arrow.l.r(Epsilon)$ matrix is given by: 

$ Epsilon_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) = integral_V delta_(i k) X^(lambda_1 + lambda_2) Y^(mu_1 + mu_2) Z^(nu_1 + nu_2) d X d Y d Z, $<eq:E_matrix_def>

and an element of the $arrow.l.r(Gamma)$ matrix is given by: 

$ Gamma_(i lambda_1 mu_1 nu_1 ; k lambda_2 mu_2 nu_2) = C_(i j k l)/(L_j L_l) integral_V (partial X^(lambda_1) Y^(mu_1) Z^(nu_1) )/(partial b_j) (partial X^(lambda_2) Y^(mu_2) Z^(nu_2) )/(partial b_l) d X d Y d Z, $<eq:Gamma_matrix_def>

where $b_j = r_j/L_j$. In other words: $b_1 = x/L_x = X$, $b_2 = y/L_y = Y$ and $b_3 = z/L_z = Z$. Note that both matrices $arrow.l.r(Epsilon)$ and $arrow.l.r(Gamma)$ are symmetric. Also, $arrow.l.r(Epsilon)$ must be definite positive in order for the eigenvalues to be all real and positive. In particular, $arrow.l.r(Epsilon)$ is a special matrix, whose name is the Gram matrix. This matrix contains all possible inner products between the basis functions. This matrix defines the distances within the Rayleigh-Ritz manifold defined by the basis. For example, if the basis functions were normalized Legendre polynomials, this matrix would be just the identity. 

Here is an example of $arrow.l.r(Epsilon)$ matrix built with a value of $N_g = 1$: 

$ arrow.l.r(Epsilon) = integral_V mat(1, Z, Y, X, 0, 0, 0, 0, 0, 0, 0, 0;
                           Z, Z^2, Y Z, X Z, 0, 0, 0, 0, 0, 0, 0, 0;
                           Y, Y Z, Y^2, X Y, 0, 0, 0, 0, 0, 0, 0, 0;
                           X, X Z, X Y, X^2, 0, 0, 0, 0, 0, 0, 0, 0;
                           0, 0, 0, 0, 1, Z, Y, X, 0, 0, 0, 0, ;
                           0, 0, 0, 0, Z, Z^2, Y Z, X Z, 0, 0, 0, 0;
                           0, 0, 0, 0, Y, Y Z, Y^2, X Y, 0, 0, 0, 0;
                           0, 0, 0, 0, X, X Z, X Y, X^2, 0, 0, 0, 0;
                           0, 0, 0, 0, 0, 0, 0, 0, 1, Z, Y, X;
                           0, 0, 0, 0, 0, 0, 0, 0, Z, Z^2, Y Z, X Z;
                           0, 0, 0, 0, 0, 0, 0, 0, Y, Y Z, Y^2, X Y;
                           0, 0, 0, 0, 0, 0, 0, 0, X, X Z, X Y, X^2;
                          ) d X d Y d Z. $<eq:E_matrix_example>

Also, we can see an example of $arrow.l.r(Gamma)$ matrix built with a value of $N_g = 1$ below:

$ arrow.l.r(Gamma) = integral_V mat(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
  0, C_55/L_z^2, C_56/(L_y L_z), C_15/(L_x L_z), 0, C_45/L_z^2, C_25/(L_y L_z), C_56/(L_x L_z), 0, C_35/L_z^2, C_45/(L_y L_z), C_55/(L_x L_z);
  0, C_56/(L_y L_z), C_66/L_y^2, C_56/(L_x L_y), 0, C_46/(L_y L_z), C_26/L_y^2, C_66/(L_x L_y), 0, C_36/(L_y L_z), C_46/L_y^2, C_56/(L_x L_y);
  0, C_15/(L_x L_z), C_56/(L_x L_y), C_11/L_x^2, 0, C_14/(L_x L_z), C_12/(L_x L_y), C_16/L_x^2, 0, C_13/(L_x L_z), C_14/(L_x L_y), C_15/L_x^2;
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
  0, C_45/L_z^2, C_46/(L_y L_z), C_14/(L_x L_z), 0, C_44/L_z^2, C_24/(L_y L_z), C_46/(L_x L_z), 0, C_34/L_z^2, C_44/(L_y L_z), C_45/(L_x L_z);
  0, C_25/(L_y L_z), C_26/L_y^2, C_12/(L_x L_y), 0, C_24/(L_y L_z), C_22/L_y^2, C_26/(L_x L_y), 0, C_23/(L_y L_z), C_24/L_y^2, C_25/(L_x L_y);
  0, C_56/(L_x L_z), C_66/(L_x L_y), C_16/L_x^2, 0, C_46/(L_x L_z), C_26/(L_x L_y), C_66/L_x^2, 0, C_36/(L_x L_z), C_46/(L_x L_y), C_56/L_x^2;
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
  0, C_35/L_z^2, C_36/(L_y L_z), C_13/(L_x L_z), 0, C_43/L_z^2, C_23/(L_y L_z), C_36/(L_x L_z), 0, C_33/L_z^2, C_34/(L_y L_z), C_35/(L_x L_z);
  0, C_45/(L_y L_z), C_46/L_y^2, C_14/(L_x L_y), 0, C_44/(L_y L_z), C_24/L_y^2, C_46/(L_x L_y), 0, C_34/(L_y L_z), C_44/L_y^2, C_35/(L_x L_y);
  0, C_55/(L_x L_z), C_56/(L_x L_y), C_15/L_x^2, 0, C_45/(L_x L_z), C_25/(L_x L_y), C_56/L_x^2, 0, C_35/(L_x L_z), C_45/(L_x L_y), C_55/L_x^2;) d X d Y d Z. $<eq:Gamma_matrix_example>


For example, in the third row we have the following values for the first 4 indices: $i = 1, lambda_1 = 0, mu_1 = 1, nu_1 = 0$, and in the second column we have the following values for the last 4 indices $k = 1, lambda_2 = 0, mu_2 = 0, nu_2 = 1$. Note that $arrow.l.r(Epsilon)$ matrix is made out of 3 diagonal blocks of identical matrices. Each block has $N_b times N_b$ dimensions, where $N_b = 1/6 (N_g + 1)(N_g + 2)(N_g + 3)$. In the case of $N_g = 1$ we can see in @eq:E_matrix_example that each block is 4x4 in size. 


== Examples of resonance spectra for isotropic and cubic materials

Using @eq:raw_eig_problem, @eq:E_matrix_def and @eq:Gamma_matrix_def, we are able to get the resonance frequencies given the elastic constants, dimensions and shape of a sample. In other words, with these equations we are able to solve the forward problem. All the codes made to implement those equations and solve the forward problem are found in the repo https://github.com/jacubillos10/RUSpectroscopy_Tools. The code to generate the $arrow.l.r(Epsilon)$ and $arrow.l.r(Gamma)$ matrices can be found in rusmodules/rus.c. The generalized eigenvalue problem is solved using linalg.eigh function for symmetric matrices in scipy #cite(<scipy>). 

Running the above mentioned codes we got the values of  $omega_n/omega_0$ of a solid sphere, made of an isotropic material with relation between the bulk modulus $K$ and the shear modulus $G$ of $K/G = 7/1$, in the following scatterplot: 
#figure(
  image("../images/eigenvals_degeneration.png", width: 60%),
  caption: "Eigenvalues of a spheric isotropic solid with relation of bulk modulus:shear modulus of 7:1"

)<fig:degenerate_eigenvalues>

It can be noted that there are degenerate eigenvalues, and the number of degenerate eigenvalues in each level is always odd. This is due to the isotropic nature of the material, and its spherical geometry, associated to the rotations group in 3D, SO(3), which is the relevant symmetry group here. The values of $omega_n/omega_0$ of a solid sphere, made of a cubic material were also computed. These values are shown in the scatterplot below:

#figure(
  image("../images/eigenvals_degeneration_cubic.png", width: 60%),
  caption: [Eigenvalues of a spheric solid, with cubic crystal structure, with $C_11$:$C_12$:$C_44$ relation of 7:3:1.]
)<fig:degenerate_eigenvalues_cubic>
We can observe in @fig:degenerate_eigenvalues_cubic that there are less degenerate eigenvalues in the cubic case, respect to the isotropic case. This is expected since the cubic crystal structure have less symmetry then the isotropic crystal structure. There is still some degenerate eigenvalues in the cubic case due to the spherical geometry of the sample.

To check if the code was running correctly the figures 4 and 5 of reference #cite(<Visscher_1991>) were replicated in @fig:cyl_elli_frequencies. The plot at the left side shows the frequencies for a family of cylinder samples, while the plot at the right side shows the frequencies for a family of ellipsoids. Values below 0.5 of the aspect ratio indicator indicates that the height of the sample is held constant at 2 and the diameter/height ratio is varied linearly from 0 at the origin and 1 at the center of the plot, or when aspect ratio indicator reaches 0.5. Values above 0.5 of the aspect ratio indicator mean that the diameter is held constant at 2 and the height is linearly decreased to 0 at the end of the plot, when the aspect ratio indicator reaches 1.  

#figure(
  image("../images/cylinder_ellipsoid_frequencies_replication.png", width: 90%),
  caption: [Resonant frequencies of a family of cylinder isotropic samples on the left, and ellipsoid isotropic samples on the right, both with $K = 3$, $mu = 1$ and $rho = 1$. All frequency values were generated using a value of $N_g=8$.] 
)<fig:cyl_elli_frequencies>

We can see in the plot at the left of @fig:cyl_elli_frequencies that there are modes which frequencies are independent of the cylinder's diameter for any aspect ratio, which are no other than the torsional modes #cite(<Visscher_1991>) and were also observed in Visscher's work. Also we can observe modes whose frequencies are independent of the cylinder's height, at the right side of the plot. This ones are called compressional Young's modulus normal modes #cite(<Visscher_1991>). We can see that the plots inside @fig:cyl_elli_frequencies are just identical as those in figures 4 and 5 reported in reference #cite(<Visscher_1991>), which indicates that the code is solving the forward problem correctly.  

These pair of figures were also made for cubic solids, shown in @fig:cyl_elli_frequencies_cubic. We can see there that some of the compressional Young's modulus modes and torsional modes are still present. A difference between the plots in the isotropic case shown in @fig:cyl_elli_frequencies and the plots in the cubic case shown in @fig:cyl_elli_frequencies_cubic, is that the cubic modes have some inflection points and can make some oscillations across the aspect ratio indicator. 

#figure(
  image("../images/cylinder_ellipsoid_replications_cubic.png", width: 88%),
  caption: [Resonant frequencies of a family of cylinder cubic samples on the left, and ellipsoid cuboic samples on the right, both with $C_11 = 7$, $C_12 = 1$ and $C_44 = 1$. All frequency values were generated using a value of $N_g=8$.]
)<fig:cyl_elli_frequencies_cubic>
