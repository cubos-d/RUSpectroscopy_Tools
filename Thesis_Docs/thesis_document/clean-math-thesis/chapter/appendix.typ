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
== Spect of the computer used<apx:specs>
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
