= Training some machine learning models

In the present chapter we will explore the training and the test processes .

== Exploratory data analysis for the cubic case

OK THERE IS A LOT TO WRITE AND DEFINE BEFORE SHOWING MUTUAL INFO. The following is a short analysis that will be paraphrased in the final version:

Let's take a look at the mutual information. Ok @fig:MI_cubic looks meh! It was obvious, because $eta$ and $beta$ were created independently from $phi_K$ and $phi_a$. What is comforting me is the fact that the first compositions are, apparently, the ones which most affect the targets. 

#figure(
  image("../images/MI_phia_phiK.png", width:100%),
  caption: [Mutual information between the features and the targets in the cubic case.]
)<fig:MI_cubic>
