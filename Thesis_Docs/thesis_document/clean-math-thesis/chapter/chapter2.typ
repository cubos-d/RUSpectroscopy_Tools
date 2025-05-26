= Elasticity in Solids<chap:elastic_theory>

In this chapter, we will explore some essential concepts in the theory of elasticity in solids, which are necessary for understanding the forward problem, discussed in @chap:forward, and the inverse problem, outlined in @chap:transformations and @chap:inverse_problem, of resonant ultrasound spectroscopy (RUS). The theory of elasticity plays a crucial role in acoustic measurements. As we will see in @section:Constant_Restrictions, acoustic data determine derivatives of the free energy with respect to atomic positions, and provide important information of the physics of the material, like piezoelectric and thermoelectric phenomena, etc #cite(<Maynard_2024>). Also the measurement of acoustic properties as function of temperature or pressure is related to other fundamental thermodynamic quantities like the specific heat, Debye temperature, and can be used to check theoretical models #cite(<Maynard_2024>). Some other applications of acoustic measurements of solids include determining the phonon distribution function of diamond, checking the life cycle of nuclear fuel like plutonium, finding rare materials with high electrical conductivity and low thermal conductivity to create thermoelectric devices, and studying the ample spectrum of piezoelectric materials #cite(<Maynard_2024>). A solid understanding of acoustic measurements requires a foundation in the theory of elasticity, which will be presented in detail in the following sections.    

#v(1cm)

== The displacement vector and the strain tensor

Let's call the position vector from a point inside an unstressed solid to some origin $arrow(r)$. Now let's apply a force to the body so it deforms. The point $arrow(r)$ moves to $arrow(r) + arrow(u)(arrow(r))$. Here, $arrow(u)$ is the displacement of such point from equilibrium position to another position. We call it the displacement vector. If $arrow(u)$ was constant throughout space, so the displacements of all points in the solid are the same, which means $(partial arrow(u))/(partial x) = (partial arrow(u))/(partial y) = (partial arrow(u))/(partial z) = 0$, the body would simply be translated and will not have any deformation. To have a deformation any of the previous derivatives must be non-zero. In fact, all the information on the deformations and rotations of the solid is contained in those derivatives. The most simple, coordinate independent way, to express the values of those derivatives is by the gradient of $arrow(u)$. This gradient is a second-rank tensor denoted by $arrow.l.r(W)$ #cite(<Thorne>): 

$ arrow.l.r(W) = arrow(nabla) arrow(u). $<eq:u_gradient>

In Cartesian coordinates one can express the gradient of a vector field as a matrix, where each row is the gradient of the individual components of the field. This yields to a well known matrix with a special name: the Jacobian, which is given by the following expression: 

$ arrow(nabla) arrow(u) = mat((partial arrow(u))/(partial x),  (partial arrow(u))/(partial y), (partial arrow(u))/(partial z)) =
  mat(arrow(nabla)^T u_x; arrow(nabla)^T u_y; arrow(nabla)^T u_z) = 
  mat((partial u_x)/(partial x),(partial u_x)/(partial y), (partial u_x)/(partial z); 
      (partial u_y)/(partial x),(partial u_y)/(partial y), (partial u_y)/(partial z);
      (partial u_z)/(partial x),(partial u_z)/(partial y), (partial u_z)/(partial z)). $<eq:MrJacobian>


In other words, in a Cartesian coordinate system the components of $arrow.l.r(W)$ are: 

$ W_(i j) = (partial u_i) / (partial r_j), $<eq:strain_components>

where $r_1 = x, r_2 = y$ and $r_3 = z$. This tensor can be decomposed as the sum of its symmetric and its antisymmetric parts, as shown below: 

$ arrow.l.r(W) = arrow.l.r(W)^("sym") + arrow.l.r(W)^("anti")= 1/2 (arrow.l.r(W) + arrow.l.r(W)^T) + 1/2 (arrow.l.r(W) - arrow.l.r(W)^T). $<eq:strain_descomposition>

The curl of $arrow(u)$ contains all the information about rotations of the solid. For example, if the solid rotates an angle $phi$ around the z axis, the curl of the displacement would be just $arrow(nabla) times arrow(u) = 2 phi hat(z)$. In cartesian coordinates

$ arrow(nabla) times arrow(u) = mat((partial u_z)/(partial y) - (partial u_y)/(partial z); (partial u_x)/(partial z) - (partial u_z)/(partial x); (partial u_y)/(partial x) - (partial u_x)/(partial y)). $<eq:curl_operator>

On the other hand, an element of the antisymmetric part of $arrow.l.r(W)$ is 

$ W^("anti")_(i j) = 1/2 ((partial u_i)/(partial r_j) - (partial u_j)/(partial r_i)). $<eq:w_antisym>

Here we can see the antisymmetric part of $arrow.l.r(W)$ and $arrow(nabla) times arrow(u)$ hold the exact same information. In fact we can see the relation between the two here: 

$ W^("anti")_(i j) = 1/2 sum_(k=1)^(3) epsilon.alt_(i j k) (arrow(nabla) times arrow(u))_k, $<eq:anti_curl_relation>

where $epsilon.alt_(i j k)$ is the Levi-Civita symbol. This way we can see that the antisymmetric part of $arrow.l.r(W)$ holds the information about the rotations of the solid.  

In order to understand where the information about deformation comes from, we have to go back to the deformed solid, where some point inside of it moved from $arrow(r)$ to $arrow(r)_("New") = arrow(r) + arrow(u)$. Now let's think of two points $A$ and $B$ inside the material, which are originally separated by $d arrow(r)$. After a deformation $A$ moves to $A_("New")$ and $B$ moves to $B_("New")$, so that the new separation is the following #cite(<Leisure_2017>):

$ d arrow(r)_("New") = d arrow(r) + d arrow(u). $<eq:r_new>

Let's consider the difference in the square of the distance between the two points and how it changes with the deformation #cite(<Leisure_2017>): 

$ d r_("New")^2 = d r^2 + 2 d arrow(r) dot d arrow(u) + d u^2. $<eq:defo_distances>

Given that $arrow(u)$ is function of $arrow(r)$, we can express each component of $d arrow(u)$ the following way #cite(<Leisure_2017>):

$ d u_i = sum_(j = 1)^(3)(partial u_i)/(partial r_j) d r_j. $<eq:ui_changes>

Replacing @eq:ui_changes into @eq:defo_distances we get 

$ d r_("New")^2 = d r^2 + 2 sum_(i=1)^(3) sum_(j=1)^(3) (partial u_i)/(partial r_j) d r_j d r_i + sum_(i=1)^(3) sum_(j=1)^(3) sum_(l=1)^(3) ((partial u_i)/(partial r_j) d r_j ) ((partial u_i)/(partial r_l) d r_l ). $

Rearranging the indices and doing some algebra we get to the following expression #cite(<Leisure_2017>):

$ d r_("New")^2 - d r^2 = sum_(i=1)^(3) sum_(j=1)^(3) ((partial u_i)/(partial r_j) + (partial u_j)/(partial r_i) + sum_(l=1)^(3) (partial u_l)/(partial r_i) (partial u_l)/(partial r_j)) d r_i d r_j. $<eq:a_deformation>

Let's define a new tensor $arrow.l.r(epsilon)$ (whose name will be given later) such that 

$ d r_("New")^2 - d r^2 = sum_(i=1)^(3) sum_(j=1)^(3) 2 epsilon_(i j) d r_i d r_j, $ <eq:a_deformation_again>

then 

$ epsilon_(i j) = 1/2 ((partial u_i)/(partial r_j) + (partial u_j)/(partial r_i) + sum_(l=1)^(3) (partial u_l)/(partial r_i) (partial u_l)/(partial r_j)). $<eq:raw_strain>

For small deformations we can neglect the last term in equation @eq:raw_strain, because it is of second order and we will only consider lineal deformations #cite(<Leisure_2017>). This is known as linear elasticity. Note that only deformations (not rotations) affect $d r_("New")^2 - d r^2$ and also that the $(partial u_i)/(partial r_j)$ and $(partial u_j)/(partial r_i)$ terms in $epsilon_(i j)$ make the symmetric part of $arrow.l.r(W)$. This tensor $arrow.l.r(epsilon)$ is no other than the strain tensor, which is the tensor that gives us all the information about deformations in the linear regime#cite(<Thorne>). Removing the neglected terms, we get the final expression for the strain tensor:  

$ epsilon_(i j) = 1/2 ((partial u_i) / (partial r_j) + (partial u_j) / (partial r_i)) = W^("sym")_(i j). $<eq:strain_tensor>

Notice that, by construction, the strain tensor is symmetric, $epsilon_(i j) = epsilon_(j i).$

== The stress tensor and the generalized Hooke's law

The deformations of a material occur thanks to external forces that are being applied to it. However, long-range forces (or body forces, which apply to all material at once) such as gravity are ignored in the present treatment #cite(<Leisure_2017>). This is because, such forces don't produce any deformation on the material, and molecular forces are assumed to be short range #cite(<Leisure_2017>). The forces causing deformation differ depending on the position within the solid. That's why it is convenient to consider forces per unit area, which are called stresses. These stresses are represented in the stress tensor $arrow.l.r(sigma)$. @fig:stress_tensor shows the geometrical meaning of the stress tensor.  

#figure(
  image("../images/stress_tensor1.png", width: 70%),
  caption: [Stress tensor represented in a cubic infinitesimal element of the solid sample. Image taken from #cite(<Leisure_2017>).]

) <fig:stress_tensor>

The stress component, $sigma_(i j)$, is defined as the force per unit area acting in the direction of $hat(r)_i$ axis on a face of the cube perpendicular to the $hat(r)_j$ direction.  For example, $sigma_(x z)$ is the force per unit of area acting in the $x$ direction in the face perpendicular to the $z$ axis, that is on the $x y$ plane. The stresses are exerted on the cube by the surrounding material. By convention, positive normal components are taken as pointing outward #cite(<Leisure_2017>). 

To understand the relationship between stress and strain, it is useful to recall the familiar 1D Hooke's law, given by: $F = k x$, where $F$ is the force applied to a spring, $x$ is the resulting extension, and $k$ is the spring constant. This equation expresses a linear relationship between force and displacement in elastic systems. In continuum mechanics, this idea is generalized: instead of simple scalar quantities, we deal with stress and strain tensors, and the proportionality constant becomes a fourth-rank tensor.

This way, the stress applied to our solid sample is related to the strain through the generalized Hooke's law, which states the following #cite(<Leisure_1997>):

$ sigma_(i j) = C_(i j k l) epsilon_(k l). $ <eq:hookes_law>

From here on out, we will use Einstein's notation, where repeated indices mean that there is a sum of the terms. For example, for the generalized Hooke's law, the expression $sigma_(i j) = sum_(k=1)^(3) sum_(l=1)^(3) C_(i j k l) epsilon_(k l)$ becomes the equation @eq:hookes_law. Just like the strain tensor, the stress tensor is also symmetric, as long as no torques are applied to the infinitesimal element of our solid. That is, $sigma_(i j) = sigma_(j i)$. For example, if we want no torques applied in the $x$ axis, is necessary for $sigma_(y z)$ and $sigma_(z y)$ to be equal in order to avoid rotations on $x$ axis, as we can see in @fig:stress_tensor. The same can be said for the other axes.  Here $C_(i j k l)$ are the components of a fourth-rank tensor known as the elasticity tensor. Its components are the elastic constants, which are material dependent only. As we will see later, the elastic constants correspond to the second derivative of the free energy with respect to strain. In principle, there are 81 independent elastic constants. However, we will see that there are, in fact, less independent constants. As we saw earlier the strain tensor is symmetric: $epsilon_(k l) = epsilon_(l k)$. This means that we can determine the same component $sigma_(i j)$ of the stress tensor as follows:

$ sigma_(i j) = C_(i j k l) epsilon_(k l) = C_(i j k l) epsilon_(l k), $

which implies that

$ C_(i j k l) = C_(i j l k). $<eq:first_constant_reduction>

Moreover, remembering that the stress tensor is also symmetric in the absence of torques, $sigma_(i j) = sigma_(j i)$. Applying the generalized Hooke’s law for both $sigma_(i j)$ and $sigma_(j i)$, we have: 

$ C_(i j k l) epsilon_(k l) =  C_(j i k l) epsilon_(k l),  $

which implies that

$ C_(i j k l) = C_(j i k l). $<eq:second_constant_reduction>

As mentioned before, four indices ($i, j, k$ and $l$ in $C_(i j k l)$) each with 3 possible values (1, 2 and 3) yield to 81 constant values in $arrow.l.r(C)$ matrix. However given the symmetry relations above, some of the constants in $arrow.l.r(C)$ are repeated. For example $C_(1 2 1 1) = C_(2 1 1 1)$. If we count only the non-repeated constants, we would have only 36 independent constants. That is because each pair of indices ($i, j$) and ($k, l$) has six possible combinations as shown in each row in @table:Voigt_transform. This lets us rewrite the matrix $arrow.l.r(C)$ as a 6x6 matrix, with $m$ as the row index and $n$ as the column index, where 36 values can be stored. The transformation rules from a pair of indices ($i$, $j$) to $m$ and ($k$, $l$) to $n$ is listed in @table:Voigt_transform. This transformation can be also applied to the strain tensor, allowing us to rewrite it as a six component vector. Representing a symmetric tensor as a vector or as a tensor of reduced order, as mentioned before, is known as Voigt notation #cite(<Jamal_2014>). 

#figure(
  table(
  columns: 3,
  stroke: none,
    table.hline(stroke: .6pt),
    table.vline(stroke: .6pt),
    [i or k index], table.vline(stroke: .6pt),[j or l index], table.vline(stroke: .6pt), [new index m or n],
    table.hline(stroke: .6pt),
    [1], [1], [1],
    [2], [2], [2],
    [3], [3], [3],
    [2], [3], [4],
    [1], [3], [5],
    [1], [2], [6],
    table.vline(stroke: .6pt),
    table.hline(stroke: .6pt),
  ), 
  caption: "Voigt notation showing each index pair transformation of the elasticity tensor, the strain tensor and the stress tensor.",
)<table:Voigt_transform>

Following the rules of Voigt notation described in @table:Voigt_transform we can write the elastic constants matrix $arrow.l.r(C)$ as 

$ arrow.l.r(C) = mat(
  C_(1111), C_(1122), C_(1133), C_(1123), C_(1113), C_(1112);
  C_(2211), C_(2222), C_(2233), C_(2223), C_(2213), C_(2212);
  C_(3311), C_(3322), C_(3333), C_(3323), C_(3313), C_(3312);
  C_(2311), C_(2322), C_(2333), C_(2323), C_(2313), C_(2312);
  C_(1311), C_(1322), C_(1333), C_(1323), C_(1313), C_(1312);
  C_(1211), C_(1222), C_(1233), C_(1223), C_(1213), C_(1212);
), $

and the strain tensor in its reduced vector form as

$ arrow.l.r(epsilon) = mat(epsilon_(11);epsilon_(22);epsilon_(33);2 epsilon_(23);2 epsilon_(13);2 epsilon_(12)). $

Now let's define the potential energy per unit of volume $upsilon$ originated from elastic linear deformations #cite(<Leisure_1997>):

$ upsilon = 1/2 C_(i j k l) epsilon_(i j)epsilon_(k l). $<eq:raw_potential_energy_density>

Using Voigt notation, equation @eq:raw_potential_energy_density can be expressed as follows:

$ upsilon = 1/2 C_(m n)epsilon_(m)epsilon_(n). $<eq:potential_energy_density>

From this, it can be seen that the indices n and m can be interchanged, which implies that $ C_(m n) = C_(n m)$. Returning to the old notation, we have
$ C_(i j k l) = C_(k l i j). $<eq:third_contant_reduction> 

For example, $C_(1133) = C_(13)$, $C_(1323) = C_(2313) = C_(54) = C_(45)$ and $C_(1112) = C_(1121) = C_(16) = C_(61)$. 

Thus the tensor $arrow.l.r(C)$ has 21 independent elastic constants in the most general case. However, due to symmetries, different crystal structures may have less independent constants. In this study, we will see the particular case of isotropic solids which have only two independent elastic constants, and cubic solids, which have only three. 

== Restrictions between the constants in every crystal structure<section:Constant_Restrictions>

The free energy, which depends on the strain tensor, must remain invariant under any rotation belonging to the SO(3) group in the case of an isotropic solid. Additionally, it must be convex—that is, it should possess a global minimum that is finite. The only way to satisfy both of these conditions is for the free energy to depend on the square of the trace of the strain tensor and the trace of the square of the strain tensor, as shown in equation @eq:energy_for_isotropic_solids:

$ f - f_0 = lambda tr(arrow.l.r(epsilon))^2 + 2 G tr(arrow.l.r(epsilon)^2), $<eq:energy_for_isotropic_solids>

where $f$ is the free energy density, $f_0$ is the free energy density at the equilibrium and, $lambda$ and $G$ are known as the Lamé parameters #cite(<Landau_1986>). Note that $tr(arrow.l.r(R) arrow.l.r(epsilon) arrow.l.r(R)^T) = tr(arrow.l.r(R) arrow.l.r(R)^T arrow.l.r(epsilon)) = tr(arrow.l.r(epsilon))$ and $tr(arrow.l.r(R) arrow.l.r(epsilon) arrow.l.r(R)^T arrow.l.r(R) arrow.l.r(epsilon) arrow.l.r(R)^T) = tr(arrow.l.r(R) arrow.l.r(R)^T arrow.l.r(epsilon)^2) = tr(arrow.l.r(epsilon)^2)$. Here, $arrow.l.r(R)$ is any rotation matrix belonging to the SO(3) group.

Given that $sigma_(i j) =  (partial f)/(partial epsilon_(i j))$, one can express the stress tensor, for an isotropic solid, as follows: 

$ arrow.l.r(sigma) = lambda tr(arrow.l.r(epsilon)) arrow.l.r(I) + 2 G arrow.l.r(epsilon), $<eq:hookes_law_isotropic>

where, $arrow.l.r(I)$ is the identity. The strain tensor can be further decomposed as a sum of its traceless part and its trace multiplied by the identity, as shown in the following equation: 

$ arrow.l.r(epsilon) = 1/3 tr(arrow.l.r(epsilon)) arrow.l.r(I) + arrow.l.r(Xi). $<eq:strain_decomposition>

Here, $arrow.l.r(Xi)$ is the traceless part of $arrow.l.r(epsilon)$, which is the part that contains the information of shear deformations that don't change the volume of the solid. On the other hand, the term $1/3 tr(arrow.l.r(epsilon)) arrow.l.r(I)$ contains the information of normal deformations that change the volume of the solid. Replacing $arrow.l.r(epsilon)$ from equation @eq:strain_decomposition into @eq:hookes_law_isotropic we get the following expression: 

$ arrow.l.r(sigma) = lambda tr(arrow.l.r(epsilon)) arrow.l.r(I) + 2/3 G tr(arrow.l.r(epsilon)) arrow.l.r(I) + 2 G arrow.l.r(Xi) = K tr(arrow.l.r(epsilon)) arrow.l.r(I) + 2 G arrow.l.r(Xi). $<eq:stress_tensor_isotropic>

Here, $K = lambda + 2/3 G$ is called the bulk modulus because it is related to volume change deformations and $G$ is called the shear modulus because it is related to shear deformations #cite(<Thorne>). 

This way, for an isotropic solid, the elastic constant matrix, using Voigt notation is given by 

$ arrow.l.r(C) = mat(
  K + 4/3 G, K - 2/3 G, K - 2/3 G, 0, 0, 0;
  K - 2/3 G, K + 4/3 G, K - 2/3 G, 0, 0, 0;
  K - 2/3 G, K - 2/3 G, K + 4/3 G, 0, 0, 0;
  0, 0, 0, G, 0, 0;
  0, 0, 0, 0, G, 0;
  0, 0, 0, 0, 0, G;
). $

A similar procedure for deriving the elastic constant matrix can be carried out for cubic solids. However, this derivation is quite extensive and falls outside the scope of this work. A detailed explanation can be found in Ref #cite(<Thomas_1966>). For a cubic solid, the elastic constant matrix expressed in Voigt notation is given by

$ arrow.l.r(C) = mat(
  C_(11), C_(12), C_(12), 0, 0, 0;
  C_(12), C_(11), C_(12), 0, 0, 0;
  C_(12), C_(12), C_(11), 0, 0, 0;
  0, 0, 0, C_(44), 0, 0;
  0, 0, 0, 0, C_(44), 0;
  0, 0, 0, 0, 0, C_(44);
). $<eq:cubic_constant_matrix>

In order for a solid to be a feasible one, it must be mechanically stable. That is, its free energy as a  function of the different strains must be in a minimum. This implies that the elastic constants matrix, whose components are described in @eq:stability_criteria 

$ C_(i j) = (partial^2 f)/(partial epsilon_i partial epsilon_j), $<eq:stability_criteria>

must be definite positive, or in other words, its eigenvalues must be all positive #cite(<Mouhat_2014>). This implies that all the leading principal minors of $arrow.l.r(C)$ (determinants of its upper-left k by k sub-matrix, $1 lt.eq k lt.eq 6$) are positive #cite(<Mouhat_2014>). This is known as the "Born stability criteria". In the case of isotropic solids the bulk and shear moduli must follow the restrictions: 

$ K > 0;" "G > 0. $<eq:restrictions_iso_solids>

In the case of cubic solids the elastic constants matrix must follow the following restrictions #cite(<Mouhat_2014>): 

$ C_(11) + 2C_(12) > 0; " "C_(11) - C_(12) > 0; " " C_(44) > 0. $<eq:restrictions_cubic_solids>

These restrictions will be of crucial importance when defining new variables in @chap:transformations.
