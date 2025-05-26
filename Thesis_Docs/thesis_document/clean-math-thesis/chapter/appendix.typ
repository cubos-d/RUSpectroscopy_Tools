#let constant_list = csv("../cubico_L4.csv")
#let error_list = csv("../Errores_L4.csv")
#import table: cell, header

#set heading(numbering: none)  // Heading numbering
= Appendix
#counter(heading).update(1)

#set heading(numbering: "A.1", supplement: [Appendix])  // Defines Appendix numbering

== Some useful integrals for different shapes<apx:integrals>

If the sample is a parallelepiped, the integrals (evaluated from -1 to 1 in $X, Y$ and $Z$) inside the expressions @eq:E_matrix_def and @eq:Gamma_matrix_def can be written as:

$ integral_V X^p Y^q Z^r d X d Y d Z = 8/((p+1)(q+1)(r+1)), $

where the coefficients $p, q$ and $r$ depend on $lambda_1, lambda_2, mu_1, mu_2, nu_1$ and $nu_2$. If the sample is an spheroid, that integral can be written the following way #cite(<Visscher_1991>):

$ integral_V X^p Y^q Z^r d X d Y d Z = (pi/2 (p-1)!! (q-1)!! (r-1)!!)/(p + q + r + 3)!!. $

In the case of cylinders the integral is given by the following expression #cite(<Visscher_1991>): 

$ integral_V X^p Y^q Z^r d X d Y d Z = (4 pi (p-1)!! (q-1)!!)/((r+1)(p+q+2)!!). $

Is worth to note that, for any shape, the value of the integral is zero if any of the exponents $p$, $q$ or $r$ is odd. This is because the integral of an odd function between $-b$ and $b$, where $b$ is a real positive arbitrary value, is zero.

== The Rayleigh-Ritz Method<apx:Rayleigh-ritz>

The Rayleigh method reduces a system with infinitely many degrees of freedom to one with a finite number. Rather than deriving or solving a differential equation, the method approximates the solution by directly minimizing a functional which is, in this case, the Lagrangian $L$. This is done by selecting a finite number of parameters in a trial (assumed) solution. The approach is particularly suitable for problems like harmonic oscillators (both classical and quantum) and elasticity problems like the one outlined in this work #cite(<Arora_2008>).

Ritz later extended Rayleigh’s method by formalizing the requirement that the trial (or basis) functions form a complete set. This extension allows for a more general and systematic application of the method, and it ensures that the approximation converges to the true solution as more basis functions are included #cite(<Arora_2008>).

To illustrate the method, consider the problem of determining a function $y(x)$ that minimizes the following functional:

$ U = integral_(x_0)^(x_1) F(x, y', y'', dots) d x, $

where $F$ is a given function, $y' = (d y)/(d x)$ and $y'' = (d^2 y)/(d x^2)$ #cite(<Arora_2008>). The function $y(x)$ is restricted to a class of functions that satisfy certain linear forced boundary conditions. This function can be approximated as a sum of basis functions as shown below: 

$ y_(n)(x) = sum_(i=1)^(n) alpha_i g_(i)(x). $

Here, $alpha_i$ are undetermined constants, and $g_(i)(x)$ are some given functions, called basis functions. To ensure that the algebraic equations resulting from Ritz approximation have a solution, and the approximate solution converges to the true solution of the problem as the value of $n$ is increased, the functions $g_(i)(x)$ should satisfy the following conditions #cite(<Arora_2008>):

- $g_(i)(x)$ must have the same boundary conditions of $y_(x)$.
- $g_(i)(x)$ must satisfy the homogeneous form of the specified boundary conditions.
- $g_(i)(x)$ should be continuous. 
- All $g_(i)(x)$ must be linearly independent and complete between $x_0$ and $x_1$.

For a set of functions to be linearly independent, the only solution to the system presented in equation @eq:linear_independence should be $alpha_i = 0$ #cite(<Arora_2008>).

$ sum_(i=1)^(n) alpha_i g_(i)(x) = 0 $<eq:linear_independence>

On the other hand, a set of functions $g_(i)(x)$ is complete in the interval $(x_0, x_1)$ when the mean squared error defined as

$ M_n = integral_(x_0)^(x_1) (y(x) - y_(n)(x))^2 d x, $

can be arbitrarily small as we increase the value of $n$, or in other words when 

$ lim_(n arrow inf) M_n = 0. $

Using the basis function expansion for $y(x)$, the functional $U$ is reduced to a function of the parameters, $alpha_i$; i.e., $U_n = U_(n)(alpha_i)$. The condition $delta U = 0$ gives equations for solution of $alpha_i$ #cite(<Arora_2008>). In this case, the $alpha_i$ parameters are just the $a_(i lambda mu nu)$ parameters mentioned in @chap:forward and, when applying the condition of $delta U = 0$, we are extremizing the Lagrangian. This yields to an eigenvalue problem like the one outlined in @chap:forward. 
/*
This is done by approximating a function—in this case, the displacement vector $arrow(u)$—based on the foundational concept of Rayleigh's principle. The key idea is to express the target function as a weighted sum of simpler, predefined functions that approximate its behavior. According to the Ritz approach, the trial function $f(x)$ is constructed as a linear combination of basis functions, and truncated to an arbitrary degree $N$ #cite(<Rosenhouse_2001>):

$ f(x) = sum_(i=1)^(N) alpha_i phi_(i)(x), $

Here, $alpha_i$ are scalar coefficients, and $phi_(i)(x)$ are chosen basis functions that form a complete set #cite(<Migliori_1993>), often indexed by their degree $i$. For instance, if Legendre polynomials are used, the index $i$ corresponds to the polynomial degree. In this formulation, the overall shape or structure of the approximation is determined by the choice of functions $phi_(i)(x)$, while the specific values are adjusted via the coefficients $alpha_i$ to best approximate the true solution #cite(<Rosenhouse_2001>).
*/
#pagebreak()

== Reported and predicted values of cubic constants and error predictions<apx:cubic_constants>

=== Reported and predicted values of cubic elastic constants

All the references of the reported values in @table:reported_and_predicted_constants_p1, @table:reported_and_predicted_constants_p2, @table:reported_and_predicted_constants_p3 and @table:reported_and_predicted_constants_p4 can be found in table S7 of supplementary material of Fukuda et al's work #cite(<Fukuda_2023>).

#figure(
  table(
    columns: 10,
    [],
    cell([*Reported (GPa)*], colspan: 3),
    cell([*Fukuda et al (GPa)*], colspan: 3),
    cell([*Present Work (GPa)*], colspan: 3),
    [], [*$C_(11)$*], [*$C_(12)$*], [*$C_(44)$*], 
    [*$C_(11)$*], [*$C_(12)$*], [*$C_(44)$*],
    [*$C_(11)$*], [*$C_(12)$*], [*$C_(44)$*],
    ..constant_list.flatten().slice(10*1,10*31),
  ),
  caption: [List of reported and  predicted values of elastic constants of different cubic materials, part 1.]
)<table:reported_and_predicted_constants_p1>

#figure(
  table(
    columns: 10,
    [],
    cell([*Reported (GPa)*], colspan: 3),
    cell([*Fukuda et al (GPa)*], colspan: 3),
    cell([*Present Work (GPa)*], colspan: 3),
    [], [*$C_(11)$*], [*$C_(12)$*], [*$C_(44)$*], 
    [*$C_(11)$*], [*$C_(12)$*], [*$C_(44)$*],
    [*$C_(11)$*], [*$C_(12)$*], [*$C_(44)$*],
    ..constant_list.flatten().slice(10*31,10*61),
  ),
  caption: [List of reported and  predicted values of elastic constants of different cubic materials, part 2.]
)<table:reported_and_predicted_constants_p2>

#figure(
  table(
    columns: 10,
    [],
    cell([*Reported (GPa)*], colspan: 3),
    cell([*Fukuda et al (GPa)*], colspan: 3),
    cell([*Present Work (GPa)*], colspan: 3),
    [], [*$C_(11)$*], [*$C_(12)$*], [*$C_(44)$*], 
    [*$C_(11)$*], [*$C_(12)$*], [*$C_(44)$*],
    [*$C_(11)$*], [*$C_(12)$*], [*$C_(44)$*],
    ..constant_list.flatten().slice(10*61,10*96),
  ),
  caption: [List of reported and  predicted values of elastic constants of different cubic materials, part 3.]
)<table:reported_and_predicted_constants_p3>

#figure(
  table(
    columns: 10,
    [],
    cell([*Reported (GPa)*], colspan: 3),
    cell([*Fukuda et al (GPa)*], colspan: 3),
    cell([*Present Work (GPa)*], colspan: 3),
    [], [*$C_(11)$*], [*$C_(12)$*], [*$C_(44)$*], 
    [*$C_(11)$*], [*$C_(12)$*], [*$C_(44)$*],
    [*$C_(11)$*], [*$C_(12)$*], [*$C_(44)$*],
    ..constant_list.flatten().slice(10*96,10*112),
  ),
  caption: [List of reported and  predicted values of elastic constants of different cubic materials, part 4.]
)<table:reported_and_predicted_constants_p4>

Table 17, Table 18, Table 19 and Table 20 show the non-absolute percentage error ("NaErr"), defined in equation @eq:non_absolute_error, of the predicted values of Fukuda et al and the predicted values of the present work.

#figure(
  table(
    columns: 7,
    [],
    cell([*Fukuda et al (%)*], colspan: 3),
    cell([*Present Work (%)*], colspan: 3),
    [], [*$C_(11)$*], [*$C_(12)$*], [*$C_(44)$*], 
    [*$C_(11)$*], [*$C_(12)$*], [*$C_(44)$*],
    ..error_list.flatten().slice(7*1, 7*13),
  ),
  caption: [List of errors of the predicted constants in Fukuda et al's work and present work, part 1.]
)<table:errors_p1>

#figure(
  table(
    columns: 7,
    [],
    cell([*Fukuda et al (%)*], colspan: 3),
    cell([*Present Work (%)*], colspan: 3),
    [], [*$C_(11)$*], [*$C_(12)$*], [*$C_(44)$*], 
    [*$C_(11)$*], [*$C_(12)$*], [*$C_(44)$*],
    ..error_list.flatten().slice(7*13, 7*50),
  ),
  caption: [List of errors of the predicted constants in Fukuda et al's work and present work, part 2.]
)<table:errors_p2>

#figure(
  table(
    columns: 7,
    [],
    cell([*Fukuda et al (%)*], colspan: 3),
    cell([*Present Work (%)*], colspan: 3),
    [], [*$C_(11)$*], [*$C_(12)$*], [*$C_(44)$*], 
    [*$C_(11)$*], [*$C_(12)$*], [*$C_(44)$*],
    ..error_list.flatten().slice(7*50, 7*87),
  ),
  caption: [List of errors of the predicted constants in Fukuda et al's work and present work, part 3.]
)<table:errors_p3>

#figure(
  table(
    columns: 7,
    [],
    cell([*Fukuda et al (%)*], colspan: 3),
    cell([*Present Work (%)*], colspan: 3),
    [], [*$C_(11)$*], [*$C_(12)$*], [*$C_(44)$*], 
    [*$C_(11)$*], [*$C_(12)$*], [*$C_(44)$*],
    ..error_list.flatten().slice(7*87, 7*112),
  ),
  caption: [List of errors of the predicted constants in Fukuda et al's work and present work, part 4.]
)<table:errors_p4>


== Specifications of the computer used to train the models and generate some training data<apx:specs>

- Model: Minisforum HX99G mini PC
- CPU: AMD Ryzen 9 6900HX
- Memory: 32 GB
- GPU: AMD Radeon RX 6600M
- GPU Memory: 8GB
- OS: Fedora Linux 41 (Server Edition) x86_64
- Python version: 3.13.3
- ROCm version: 6.3
- Torch version: 2.7

#pagebreak()

== Plots of $xi_n$ as a function of $phi_K$<apx:phiK_plots>

#figure(
  table(
    columns: 3,
    image("../images/nn_7/eta=0.12,beta=0.14_.png"),
    image("../images/nn_7/eta=0.12,beta=0.42_.png"),
    image("../images/nn_7/eta=0.18,beta=0.4_.png"),
    image("../images/nn_7/eta=0.18,beta=0.7_.png"),
    image("../images/nn_7/eta=0.18,beta=0.9_.png"),
    image("../images/nn_7/eta=0.25,beta=0.07_.png"),
    image("../images/nn_7/eta=0.25,beta=0.38_.png"),
    image("../images/nn_7/eta=0.25,beta=0.61_.png"),
    image("../images/nn_7/eta=0.25,beta=0.84_.png"),
    image("../images/nn_7/eta=0.31,beta=0.06_.png"),
    image("../images/nn_7/eta=0.31,beta=0.24_.png"),
    image("../images/nn_7/eta=0.31,beta=0.62_.png"),
    image("../images/nn_7/eta=0.31,beta=0.93_.png"),
    image("../images/nn_7/eta=0.43,beta=0.10_.png"),
    image("../images/nn_7/eta=0.43,beta=0.31_.png"),
  ),
  caption: [Real and predicted values of $xi_n$ as a function of $phi_K$ for different values of $eta$ and $beta$.]
)<table:phiK_plots>

#figure(
  table(
    columns: 3,
    image("../images/nn_7/eta=0.43,beta=0.57_.png"),
    image("../images/nn_7/eta=0.43,beta=0.68_.png"),
    image("../images/nn_7/eta=0.43,beta=0.84_.png"),
    image("../images/nn_7/eta=0.43,beta=0.94_.png"),
    image("../images/nn_7/eta=0.43,beta=1.0_.png"),
    image("../images/nn_7/eta=0.5,beta=0.05_.png"),
    image("../images/nn_7/eta=0.5,beta=0.15_.png"),
    image("../images/nn_7/eta=0.5,beta=0.26_.png"),
    image("../images/nn_7/eta=0.5,beta=0.36_.png"),
    image("../images/nn_7/eta=0.5,beta=0.47_.png"),
    image("../images/nn_7/eta=0.5,beta=0.57_.png"),
    image("../images/nn_7/eta=0.5,beta=0.68_.png"),
    image("../images/nn_7/eta=0.5,beta=0.78_.png"),
    image("../images/nn_7/eta=0.5,beta=0.89_.png"),
    image("../images/nn_7/eta=0.5,beta=0.94_.png"),
  ),
  caption: [Real and predicted values of $xi_n$ as a function of $phi_K$ for different values of $eta$ and $beta$ continued.]
)<table:phiK_plots2>


/*
#table(
  columns: 2,
  column-gutter: 3em,
  stroke: none,
  [$C_0$], [functions with compact support],
  [$overline(RR)$], [extended real numbers $RR union {oo}$],
)

#table(
  columns: 2,
  column-gutter: 1.55em,
  stroke: none,
  [iff], [if and only if],
  [s.t.], [such that],
  [w.r.t.], [with respect to],
  [w.l.o.g], [without loss of generality],
)
*/
