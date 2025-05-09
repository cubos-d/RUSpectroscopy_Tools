#let constant_list = csv("../cubico_L4.csv")
#let error_list = csv("../Errores_L4.csv")
#import table: cell, header

#set heading(numbering: none)  // Heading numbering
= Appendix
#counter(heading).update(1)

#set heading(numbering: "A.1", supplement: [Appendix])  // Defines Appendix numbering

== Some useful integrals for different shapes<apx:integrals>

If the sample is a parallelepiped, the integrals (evaluated from -1 to 1 in $X, Y$ and $Z$) inside the expressions @eq:E_matrix_def and @eq:Gamma_matrix_def can be written as:

$ integral_V X^p Y^q Z^r d X d Y d Z = 1/((p+1)(q+1)(r+1)), $

where the coefficients $p, q$ and $r$ depend on $lambda_1, lambda_2, mu_1, mu_2, nu_1$ and $nu_2$. If the sample is an spheroid, that integral can be written the following way #cite(<Visscher_1991>):

$ integral_V X^p Y^q Z^r d X d Y d Z = ((p-1)!! (q-1)!! (r-1)!!)/(p + q + r + 3)!!. $


== Rayleigh-Ritz Method<apx:Rayleigh-ritz>

Here we describe Rayleigh-Ritz method

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
