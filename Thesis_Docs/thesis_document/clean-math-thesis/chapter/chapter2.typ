= Elasticity in Solids<chap:elastic_theory>

In this chapter, we will explore some essential concepts in the theory of elasticity in solids, which are necessary for understanding the forward problem, discussed in @chap:forward, and the inverse problem, outlined in @chap:transformations/* and chapter 5*/, of Resonant Ultrasound Spectroscopy. The theory of elasticity plays a crucial role in acoustic measurements which give very important information of the fundamental physics in a material #cite(<Maynard_2024>). As we will see in this chapter in @section:Constant_Restrictions, acoustic data determine derivatives of free energy with respect to atomic positions, and provide important information of the physics of the material, like piezoelectric and thermoelectric phenomena, etc #cite(<Maynard_2024>). Also the measurement of acoustic properties taken as function of temperature or pressure is related to other fundamental thermodynamic quantities like the state equation, specific heat, Debye temperature, and can be used to check theoretical models #cite(<Maynard_2024>). Some other applications of acoustic measurements of solids include determining the phonon distribution function of diamond, checking the life cycle of nuclear fuel like plutonium, finding rare materials with high electrical conductivity and low thermal conductivity to create thermoelectric devices and studying the ample spectrum of piezoelectric materials #cite(<Maynard_2024>).    

#v(1cm)

== The displacement vector and the strain tensor

Let's call the position vector from a point inside an unstressed solid to some origin $arrow(r)$. Now let's apply a force to the body so it deforms and the point moves from $arrow(r)$ to $arrow(r) + arrow(u)(arrow(r))$. Here $arrow(u)$ is the displacement of such point from equilibrium position to another position. We call it the displacement vector. If $arrow(u)$ was constant throughout space, so the displacements of all points in the solid are the same and there is no change of displacement respect to any coordinate $x$, $y$ or $z$, which means $(partial arrow(u))/(partial x) = (partial arrow(u))/(partial y) = (partial arrow(u))/(partial z) = 0$, the body would simply be translated and will not have any deformation. To have a deformation any of the previous derivatives must be non-zero. In fact, all the information on the deformations and rotations of the solid is contained in those derivatives. The most simple, coordinate independent way to express the values of those derivatives is by the gradient of $arrow(u)$. This gradient is a second-rank tensor denoted by $arrow.l.r(W)$ #cite(<Thorne>): 

$ arrow.l.r(W) = arrow(nabla) arrow(u). $<eq:u_gradient>

In Cartesian coordinates one can express the gradient of a vector function as a matrix, where each row is the gradient of the individual components of the function. This yields to a well known matrix with a special name: the Jacobian, which is the following: 

$ arrow(nabla) arrow(u) = mat((partial arrow(u))/(partial x),  (partial arrow(u))/(partial y), (partial arrow(u))/(partial z)) =
  mat(arrow(nabla)^T u_x; arrow(nabla)^T u_y; arrow(nabla)^T u_z) = 
  mat((partial u_x)/(partial x),(partial u_x)/(partial y), (partial u_x)/(partial z); 
      (partial u_y)/(partial x),(partial u_y)/(partial y), (partial u_y)/(partial z);
      (partial u_z)/(partial x),(partial u_z)/(partial y), (partial u_z)/(partial z)). $<eq:MrJacobian>


In other words, in a Cartesian coordinate system the components of $arrow.l.r(W)$ are: 

$ W_(i j) = (partial u_i) / (partial r_j), $<eq:strain_components>

where $r_1 = x, r_2 = y$ and $r_3 = z$. This tensor can be expressed as the sum of its symmetric part and its antisymmetric part, as shown below: 

$ arrow.l.r(W) = arrow.l.r(W)^("sym") + arrow.l.r(W)^("anti")= 1/2 (arrow.l.r(W) + arrow.l.r(W)^T) + 1/2 (arrow.l.r(W) - arrow.l.r(W)^T). $<eq:strain_descomposition>

The curl of $arrow(u)$ contains all the information about rotations of the solid. For example, if the solid rotates an angle $phi$ around the z axis, the curl of the displacement would be just $arrow(nabla) times arrow(u) = 2 phi hat(z)$. The curl of the displacement in cartesian coordinates is: 

$ arrow(nabla) times arrow(u) = mat((partial u_z)/(partial y) - (partial u_y)/(partial z); (partial u_x)/(partial z) - (partial u_z)/(partial x); (partial u_y)/(partial x) - (partial u_x)/(partial y)). $<eq:curl_operator>

On the other hand, an element of the antisymmetric part of $arrow.l.r(W)$ is: 

$ W^("anti")_(i j) = 1/2 ((partial u_i)/(partial r_j) - (partial u_j)/(partial r_i)). $<eq:w_antisym>

Here we can see the antisymmetric part of $arrow.l.r(W)$ and $arrow(nabla) times arrow(u)$ hold the exact same information. In fact we can see the relation between the two here: 

$ W^("anti")_(i j) = 1/2 sum_(k=1)^(3) epsilon.alt_(i j k) (arrow(nabla) times arrow(u))_k, $<eq:anti_curl_relation>

where $epsilon.alt_(i j k)$ is the Levi-Civita symbol. This way we can see that the antisymmetric part of $arrow.l.r(W)$ holds the information about the rotations of the solid.  

In order to understand where the information about deformation comes from, we have to go back to the deformed solid where some point inside of it moved from $arrow(r)$ to $arrow(r)_("New") = arrow(r) + arrow(u)$. Now let's think in two points inside the material $A$ and $B$, which are originally separated by $d arrow(r)$. After a deformation $A$ moves from $A$ to $A_("New")$ and $B$ moves from $B$ to $B_("New")$, so that the new separation is the following #cite(<Leisure_2017>):

$ d arrow(r)_("New") = d arrow(r) + d arrow(u). $<eq:r_new>

Let's consider the difference in the square of the distance between the two points and how it changes with the deformation #cite(<Leisure_2017>): 

$ d r_("New")^2 = d r^2 + 2 d arrow(r) dot d arrow(u) + d u^2. $<eq:defo_distances>

Given that $arrow(u)$ is function of $arrow(r)$, we can express each component of $d arrow(u)$ the following way #cite(<Leisure_2017>):

$ d u_i = sum_(j = 1)^(3)(partial u_i)/(partial r_j) d r_j. $<eq:ui_changes>

Replacing @eq:ui_changes into @eq:defo_distances we get: 

$ d r_("New")^2 = d r^2 + 2 sum_(i=1)^(3) sum_(j=1)^(3) (partial u_i)/(partial r_j) d r_j d r_i + sum_(i=1)^(3) sum_(j=1)^(3) sum_(l=1)^(3) ((partial u_i)/(partial r_j) d r_j ) ((partial u_i)/(partial r_l) d r_l ). $

Rearranging the indices and doing some algebra we get to the following expression #cite(<Leisure_2017>):

$ d r_("New")^2 - d r^2 = sum_(i=1)^(3) sum_(j=1)^(3) ((partial u_i)/(partial r_j) + (partial u_j)/(partial r_i) + sum_(l=1)^(3) (partial u_l)/(partial r_i) (partial u_l)/(partial r_j)) d r_i d r_j. $<eq:a_deformation>

Let's define a new tensor $arrow.l.r(epsilon)$ (whose name will be given later) such that 

$ d r_("New")^2 - d r^2 = sum_(i=1)^(3) sum_(j=1)^(3) 2 epsilon_(i j) d r_i d r_j, $ <eq:a_deformation_again>

and 

$ epsilon_(i j) = 1/2 ((partial u_i)/(partial r_j) + (partial u_j)/(partial r_i) + sum_(l=1)^(3) (partial u_l)/(partial r_i) (partial u_l)/(partial r_j)). $<eq:raw_strain>

For small deformations we can neglect the last term in equation @eq:raw_strain, because it is a second order term and we will only consider lineal deformations #cite(<Leisure_2017>). This is known as linear elasticity. Note that only deformations (not rotations) affect $d r_("New")^2 - d r^2$ and also that the remaining terms in $epsilon_(i j)$ makes it the symmetric part of $arrow.l.r(W)$. This tensor $arrow.l.r(epsilon)$ is no other than the strain tensor which is the tensor that gives us all the information about deformations #cite(<Thorne>). Removing the neglected terms, we get the final expression for the strain tensor:  

// The antisymmetric part describes only rotations of the solid, which are not related to its deformation, and elastic materials don't resist rotations. For this reason the symmetric part of $arrow.l.r(W)$ is given a special name: the strain tensor $arrow.l.r(epsilon)$. The components of the strain tensor are related to the displacements as shown below #cite(<Thorne>): 

$ epsilon_(i j) = 1/2 ((partial u_i) / (partial r_j) + (partial u_j) / (partial r_i)) = W^("sym")_(i j). $<eq:strain_tensor>

== Stress tensor and generalized Hooke's law

The deformations of a material occur thanks to external forces that are being applied to it #cite(<Leisure_2017>). However, long-range forces (or body forces, which apply to all material at once) such as gravity are ignored in the present treatment #cite(<Leisure_2017>). This is because, such forces don't produce any deformation on the material, and molecular forces are assumed to be short range #cite(<Leisure_2017>). The forces causing deformation differ depending on the position within the solid. That's why it is convenient to consider forces per unit area, which are called stresses. These stresses are represented in the stress tensor $arrow.l.r(sigma)$. @fig:stress_tensor shows what we've described.  

#figure(
  image("../images/stress_tensor1.png", width: 70%),
  caption: [Stress tensor represented in a cubic infinitesimal element of the solid sample. Image taken from #cite(<Leisure_2017>).]

) <fig:stress_tensor>

The stress, $sigma_(i j)$, is defined as the force per unit area acting in the direction of $r_i$ axis on a face of the cube perpendicular to the $r_j$ direction #cite(<Leisure_2017>).  For example, $sigma_(x z)$ is the force per unit of area acting in the $x$ direction in the face perpendicular to the $z$ axis. The stresses are exerted on the cube by the surrounding material #cite(<Leisure_2017>). By convention, positive normal components are taken as pointing outward #cite(<Leisure_2017>). This way, the stress applied to our solid sample is related to the strain through the generalized Hooke's law, which states the following #cite(<Leisure_1997>):

$ sigma_(i j) = C_(i j k l) epsilon_(k l). $ <eq:hookes_law>

From here on out, we will use the Einstein's notation, where repeated indices mean that there is a sum of the terms. /* with the same index */For example, for the generalized Hooke's law, the expression $sigma_(i j) = sum_(k=1)^(3) sum_(l=1)^(3) C_(i j k l) epsilon_(k l)$ becomes the equation @eq:hookes_law. Just like the strain tensor, the stress tensor is also symmetric, as long as no torques are applied to the infinitesimal element of our solid. That is, $sigma_(i j) = sigma_(j i)$. For example, if we want no torques applied in the $x$ axis, is necessary for $sigma_(y z)$ and $sigma_(z y)$ to be equal in order to avoid rotations on $x$ axis, as we can see in @fig:stress_tensor. The same can be said for the other axes.  Here $C_(i j k l)$ are the elastic constants. As we will see later, the elastic constants correspond to the second derivative of the free energy with respect to strain. In principle, there are 81 independent elastic constants. However, we will see that there are, in fact, less independent constants. As we saw earlier the strain tensor is symmetric: $epsilon_(k l) = epsilon_(l k)$. This means that we can determine the same component $sigma_(i j)$ of the stress tensor as follows:

$ sigma_(i j) = C_(i j k l) epsilon_(k l) = C_(i j k l) epsilon_(l k), $

which implies that:

$ C_(i j k l) = C_(i j l k). $<eq:first_constant_reduction>

Remember that the stress matrix is also symmetric in the absence of torques, $sigma_(i j) = sigma_(j i)$. Applying the generalized Hooke’s law to both sides of the equation, we have: 

$ C_(i j k l) epsilon_(k l) =  C_(j i k l) epsilon_(k l),  $

which implies that:

$ C_(i j k l) = C_(j i k l). $<eq:second_constant_reduction>

/*The symmetry relations found allow us to interchange the first two indices and the last two indices of the elastic constants tensor. This reduces the number of independent constants from 81 to 36. That's because, in principle we needed $3^4 = 81$ constants for the four indexes, each one with three possible values. Now we need only $6^2 = 36$ constants for the two pair of indexes, each with six possible values. Each pair of indices can be organized in six ways, meaning the elastic constants tensor $arrow.l.r(C)$ can be rewritten as a 6x6 matrix by replacing each pair of indices with a new one according to @table:Voigt_transform. The same can be done with the strain tensor and the stress tensor, which can be rewritten as a 6-component vector. This way of representing a symmetric tensor as a vector or a tensor of reduced order is known as Voigt notation #cite(<Jamal_2014>). */

As mentioned before, four indices ($i, j, k$ and $l$ in $C_(i j k l)$) each with 3 possible values (1, 2 and 3) yield to 81 constant values in $arrow.l.r(C)$ matrix. However given the symmetry relations found, some of the constants inside $arrow.l.r(C)$ are repeated. For example $C_(1 2 1 1) = C_(2 1 1 1)$. If we count only the non-repeated constants, we would have only 36 independent constants. That is because each pair of indices ($i, j$) and ($k, l$) has six possible combinations as shown in each row in @table:Voigt_transform. This lets us rewrite the matrix $arrow.l.r(C)$ as a 6x6 matrix, with $m$ as the row index and $n$ as the column index, where 36 values can be stored. The transformation rules from a pair of indices [$i$, $j$] to $m$ and [$k$, $l$] to $n$ is listed in @table:Voigt_transform. This transformation can be also applied to the strain tensor, allowing us to rewrite it as a six component vector. Representing a symmetric tensor as a vector or as a tensor of reduced order, as mentioned before is known as Voigt notation #cite(<Jamal_2014>). 

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
  caption: "Voigt notation showing each index pair transformation of elasticity tensor, strain tensor and stress tensor.",
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

$ arrow.l.r(epsilon) = mat(epsilon_(11);epsilon_(22);epsilon_(33);epsilon_(23);epsilon_(13);epsilon_(12)). $

Now let's define the potential energy per unit of volume $upsilon$ originated from elastic linear deformations #cite(<Leisure_1997>):

$ upsilon = 1/2 C_(i j k l) epsilon_(i j)epsilon_(k l). $<eq:raw_potential_energy_density>

Using Voight notation, the elastic potential energy per unit volume $upsilon$ can be expressed as follows:

$ upsilon = 1/2 C_(m n)epsilon_(m)epsilon_(n). $<eq:potential_energy_density>

From this, it can be seen that the indices n and m can be interchanged, which implies that $ C_(m n) = C_(n m)$. Returning to the old notation, we have
$ C_(i j k l) = C_(k l i j). $<eq:third_contant_reduction> 

For example, $C_(1133) = C_(13)$, $C_(1323) = C_(2313) = C_(54) = C_(45)$ and $C_(1112) = C_(1121) = C_(16) = C_(61)$. 

Thus the tensor $arrow.l.r(C)$ has 21 independent constants in the most general case. However, due to symmetries, different crystal structures have less independent constants. In this study we will see the particular case of isotropic solids which have only two independent constants and cubic solids, which have only three independent constants. 

== Restrictions between the constants in every crystal structure<section:Constant_Restrictions>

For a cubic solid, due to it's symmetries, the matrix of elastic constants, using Voigt notation is given by: 

$ arrow.l.r(C) = mat(
  C_(11), C_(12), C_(12), 0, 0, 0;
  C_(12), C_(11), C_(12), 0, 0, 0;
  C_(12), C_(12), C_(11), 0, 0, 0;
  0, 0, 0, C_(44), 0, 0;
  0, 0, 0, 0, C_(44), 0;
  0, 0, 0, 0, 0, C_(44);
) $

In order for a solid to be a feasible one, it must be mechanically stable. That is, it's free energy in function of the different strains must be in a minimum. This implies that the elastic constants matrix, which is #cite(<Mouhat_2014>): 

$ C_(i j) = 1/V_0 ((partial^2 E)/(partial epsilon_i partial epsilon_j)), $

must be definite positive, or in other words, its eigenvalues must be all positive. This is known as the "Born stability criteria". In the case of cubic solids the elastic constants matrix must follow the following restrictions #cite(<Mouhat_2014>): 

$ C_(11) + 2C_(12) > 0; C_(11) - C_(12) > 0; C_(44) > 0 $<eq:restrictions_cubic_solids>
