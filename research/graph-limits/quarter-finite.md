# A finite regularity proof of the one-quarter bound

This proof gives the same $M(n)\le(1/4+o(1))n^2$ conclusion using finite matrices. It also identifies the two different approximation accuracies needed when collecting pairs of edges of the same color. [Graph-limit proof](quarter.md)

Use the uniform probability measure on the $n$ rows and the $n$ columns of the adjacency matrix $G$, and first assume the coloring proper with $n$ available colors. For a color $c$, put mass $1/n$ on each of its oriented entries to obtain a matching measure $\mu_c$. Its two marginals are bounded by the uniform measure. The average over colors is the matrix $G$ times uniform area. Set $Q=\mathbb E_c\mu_c^{\otimes2}$.

## Finite counting inequalities

For a zero-one mask $H$ define $F=H(x,y')H(x',y)$ and $J=\int F\,dQ$. For every rectangle $A\times B$ of row measure $a$,
$$
\left(\int_{A\times B}G\right)^2\le J+2a\int_{A\times B}(1-H). \tag{1}
$$
Indeed the mean square of $\mu_c(A\times B)$ bounds the left side. For one missing crossed entry its row marginal is at most one and the average restricted column marginal is at most $a$. The two possible missing entries give the second term in (1).

For a partition $P$ of the vertices let $U_P$ be the matrix of average densities on its pairs of classes. Suppose $Q_1$ has $L$ classes, $R$ refines $Q_1$, and $H=1_{\{U_{Q_1}>1/2+\delta/4\}}$. Then
$$
(\delta/2)J\le 1/n+2\|U_R-U_{Q_1}\|_1+2L^4\|G-U_R\|_\square . \tag{2}
$$
To see this, integrate $F[G(x,y')+G(x',y)-1]$ against $Q$. Its positive part costs at most $1/n$ from coincident entries. Replacing $G$ by $U_R$ costs at most $L^4\|G-U_R\|_\square$ for each crossed entry, since $F$ is the sum of at most $L^4$ products of four class indicators. For each color and product, the corresponding cross marginal factors into two functions bounded by one. Replacing $U_R$ by $U_{Q_1}$ costs at most its $L^1$ distance per coordinate by marginal domination. On $F=1$ the new bracket exceeds $\delta/2$.

Lean verifies (1) in unnormalized integer counts with an arbitrary palette, together with the bound on coincident entries used in (2). [Finite counting lemmas](../hall-reduction/MaskBoard.lean)

An exhaustive integer check covers every proper three-color $2\times3$ board up to color renaming. The 108 admissible boards satisfy 221,184 mask-and-rectangle inequalities and 7,776 partition comparisons. The diagonal test also identifies all 29 tested boards with a repeated color on a four-cycle. The short comparison proof supplies another 103,680 weighted inequalities in the same run. [Reproduce the finite checks](check_counts.py) · [Short proof](quarter-short.md)

## Finding three partitions

Fix $0<\delta<1/2$, let $\xi=\delta^4/10000$ and $\nu(K)=\delta^5/(10^6 K^2)$. There exist successively refining partitions $P,Q_1,R$ with $K=|P|$, $L=|Q_1|$, such that
$$
\|U_P-U_{Q_1}\|_1\le\xi,\qquad
\|U_{Q_1}-U_R\|_1\le\nu(K),\qquad
\|G-U_R\|_\square\le\nu(K)/L^4 .
$$
Their sizes are bounded in terms of $\delta$ alone. No equitability is needed.

Here is the energy argument. The squared $L^2$ norm of any block average is at most one. Refining $P$ to $P'$ increases this energy by exactly $\|U_P-U_{P'}\|_2^2$, by orthogonality of conditional averages. Given a starting partition and $\gamma>0$, refine along a cut witnessing error above $\gamma$. Adjoining the two cut sets to the partition increases its size by at most a factor four. The energy grows by more than $\gamma^2$ since the integral of the new increment on the cut exceeds $\gamma$. At most $\lceil1/\gamma^2\rceil$ such refinements give cut error at most $\gamma$.

For a fixed outer partition $P$, start the inner loop at $Q_1=P$. Refine it to $R$ with cut error at most $\nu(K)/|Q_1|^4$. If the middle inequality fails, replace $Q_1$ by $R$ and repeat; the energy grows by more than $\nu(K)^2$ each time. On success, check the first inequality. If that fails, replace the outer $P$ by $R$ and restart the inner loop. Each outer failure increases energy by more than $\xi^2$. Starting with one class, the bounded numbers of iterations and the cut-refinement size bound give a finite bound $K_*(\delta)$ on all three partition sizes, independent of $n$.

## A rectangle that contradicts both counts

Suppose the oriented edge density is at least $1/2+\delta$. Mark the coarse cells where $U_P>1/2+\delta/2$. Their total area exceeds or equals $\delta$, since each unmarked cell has density at most $1/2+\delta/2$. For each row class $P_i$ of measure $a_i$ let $B_i$ be its marked column set of measure $b_i$. The row classes with $b_i\ge\delta/2$ have total measure at least $\delta/2$. The area of all marked cells omitted by the finer mask $H$ is at most $4\xi/\delta$, as the two block averages there differ by at least $\delta/4$. Write $M_i=a_i^{-1}\int_{P_i\times B_i}(1-H)$ for nonempty classes. The total measure of classes with $M_i>\delta^2/100$ is at most $400\xi/\delta^3=\delta/25$. Classes with $a_i<\delta/(8K)$ have combined measure at most $\delta/8$. We can therefore choose a row class $A=P_i$ with
$$
a\ge\delta/(8K),\qquad b_i\ge\delta/2,\qquad M_i\le\delta^2/100 .
$$
Its actual edge mass into $B_i$ is at least $a\delta/4$, by definition of the coarse block averages. Applying (1) gives
$$
J\ge(1/16-1/50)a^2\delta^2 > \delta^4/(1600K^2).
$$
Choose $n$ so large that $1/n\le\nu(K_*(\delta))$. By (2), $J\le10\nu(K)/\delta=\delta^4/(100000K^2)$, a contradiction. Sparse deletion of $o(n^2)$ edges proves the same asymptotic bound for improper colorings. [Properification proof](../hall-reduction/Properification.lean)
