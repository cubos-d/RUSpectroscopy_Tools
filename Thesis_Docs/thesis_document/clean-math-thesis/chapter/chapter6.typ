= Training some machine learning models

Here we talk about machine learning models that were trained to predict $phi_K$ and $phi_a$, which were the polynomial one and the neural network. Before all of that we put some EDA made, like correlation matrices and mutual information analysis.

== The following will be inside chapter 6

OK THERE IS A LOT TO WRITE AND DEFINE BEFORE SHOWING MUTUAL INFO. The following is a short analysis that will be paraphrased in the final version:

Let's take a look at the mutual information. Ok @fig:MI_cubic looks meh! It was obvious, because $eta$ and $beta$ were created independently from $phi_K$ and $phi_a$. What is comforting me is the fact that the first compositions are, apparently, the ones which most affect the targets. 

#figure(
  image("../images/MI_phia_phiK.png", width:100%),
  caption: [Mutual information between the features and the targets in the cubic case.]
)<fig:MI_cubic>
