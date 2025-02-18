= Elasticity in Solids<chap:elastic_theory>

In this chapter, we will explore some essential concepts in the theory of elasticity in solids, which are necessary for understanding the forward problem, discussed in @chap:forward, and the inverse problem, outlined in [], of Resonant Ultrasound Spectroscopy. 

#v(1cm)

== The displacement vector and the strain tensor

Label the position of a point inside an unstressed solid, relative to some origin, by its position vector $arrow(r)$. Let a force to be applied, so the body deforms and the point moves from $arrow(r)$ to $arrow(r) + arrow(u)_((arrow(r)))$. If $arrow(u)$ was constant, the body would simply be translated and will not have any deformation. To produce a deformation we must make the displacement $arrow(u)$ change from one location to another. The most simple, coordinate independent way to quantify those changes is by the gradient of $arrow(u)$. This gradient is a second-rank tensor denoted by $arrow.l.r(W)$ #cite(<Thorne>): 

$ arrow.l.r(W) = arrow(nabla) arrow(u). $<eq:u_gradient>

In a Cartesian coordinate system the components of $arrow.l.r(W)$ are: 

$ W_(i j) = (partial u_i) / (partial r_j). $<eq:strain_components>

This tensor can be expressed as the sum of it's symmetric part and it's antisymmetric part, as shown below: 

$ arrow.l.r(W) = 1/2 arrow.l.r(W)_("sym") + 1/2 arrow.l.r(W)_("anti")= 1/2 (arrow.l.r(W) + arrow.l.r(W)^T) + 1/2 (arrow.l.r(W) - arrow.l.r(W)^T). $<eq:strain_descomposition>

The antisymmetric part describes a pure rotation of the solid, which is not related to the deformation of the solid, and elastic materials don't resist rotations. For this reason the symmetric part of $arrow.l.r(W)$ is given a special name: the strain tensor $arrow.l.r(epsilon)$. The components of the strain tensor are related to the displacements as shown below #cite(<Thorne>): 

$ epsilon_(i j) = 1/2 ((partial u_i) / (partial r_j) + (partial u_j) / (partial r_i)) $<eq:strain_tensor>

== Stress tensor and generalized Hooke's law

The forces per unit area acting on an infinitesimal element of an elastic solid are represented by the stress tensor $arrow.l.r(sigma)$. @fig:stress_tensor illustrates how each component of the stress tensor exerts force per unit area on each face of an infinitesimal cube.

#figure(
  image("../images/stress_tensor1.png", width: 65%),
  caption: "Stress tensor represented in a cubic infinitesimal element of the solid sample"

) <fig:stress_tensor>

Just like the strain tensor, the stress tensor is also symmetric, as long as no torques are applied to the infinitesimal element of our solid. That is, $sigma_(i j) = sigma_(j i)$. In this way, the stress applied to our solid sample is related to the strain through the generalized Hooke's law, which states the following #cite(<Leisure_1997>):

$ sigma_(i j) = C_(i j k l) epsilon_(k l). $ <eq:hookes_law>

Here $C_(i j k l)$ are the elastic constants. As we will see later, the elastic constants correspond to the second derivative of the free energy with respect to strain. Apparently, there are 81 independent elastic constants. However, it is possible to simplify. On one hand, the strain tensor is symmetric: $epsilon_(k l) = epsilon_(l k)$. This means that we can determine the same component $sigma_(i j)$ of the stress tensor as follows:

$ sigma_(i j) = C_(i j k l) epsilon_(k l) = C_(i j k l) epsilon_(l k), $

which implies that:

$ C_(i j k l) = C_(i j l k). $<eq:first_constant_reduction>

As mentioned earlier, the stress matrix is also symmetric in the absence of torques, $sigma_(i j) = sigma_(j i)$. Applying the generalized Hooke’s law to both sides of the equation, we have: 

$ C_(i j k l) epsilon_(k l) =  C_(j i k l) epsilon_(k l),  $

which implies that:

$ C_(i j k l) = C_(j i k l). $<eq:second_constant_reduction>

The symmetry relations found allow us to interchange the first two indices and the last two indices of the elastic constants tensor. This reduces the number of independent constants from 81 to 36. Each pair of indices can be organized in 6 ways, meaning the elastic constants tensor $arrow.l.r(C)$ can be rewritten as a 6x6 matrix by replacing each pair of indices with a new one according to @table:Voigt_transform. The same can be done with the strain tensor and the stress tensor, which can be rewritten as a 6-component vector. This way of representing a symmetric tensor as a vector or a tensor of reduced order is known as Voigt notation #cite(<Jamal_2014>).

#figure(
  table(
  columns: 3,
  stroke: none,
    table.hline(stroke: .6pt),
    table.vline(stroke: .6pt),
    [i index], table.vline(stroke: .6pt),[j index], table.vline(stroke: .6pt), [new index m],
    table.hline(stroke: .6pt),
    [0], [0], [0],
    [1], [1], [1],
    [2], [2], [2],
    [1], [2], [3],
    [0], [2], [4],
    [0], [1], [5],
    table.vline(stroke: .6pt),
    table.hline(stroke: .6pt),
  ), 
  caption: "Index pair transformation of elasticity tensor, strain tensor and stress tensor.",
)<table:Voigt_transform>

With these new indices, the elastic potential energy per unit volume $upsilon$ can be expressed as follows:

$ upsilon = 1/2 C_(m n)epsilon_(m)epsilon_(n). $<eq:potential_energy_density>

From this, it can be seen that the indices n and m can be interchanged, which implies that $ C_(m n) = C_(n m)$. Returning to the old notation, we have
$ C_(i j k l) = C_(k l i j). $<eq:third_contant_reduction> 

Thus the tensor $arrow.l.r(C)$ has 21 independent constants in the most general case. 

== Restrictions between the constants in every crystal structure


