# A finite matrix bounded by one half

For each $0<\eta<1$ there is an explicit $N(\eta)$ such that the adjacency matrix of every properly colored $n$-vertex rainbow-four-cycle graph with at most $n$ colors and $n\ge N(\eta)$ is within $\eta$ in normalized cut norm of a symmetric matrix with entries in $[0,1/2]$. The graph and triple-system density bounds both follow by finite counting. The bound on $N(\eta)$ grows as a tower. [Matched-rectangle inequality](quarter-short.md) · [Graphon argument](quarter.md)

## Lean verification

The Lean kernel checks both unrestricted limiting coefficients end to end. Given any positive $\varepsilon$, the named theorems prove the respective edge and triple bounds with leading coefficients $1/4+\varepsilon$ and $1/18+\varepsilon$ for all sufficiently large orders. The formal construction averages on row classes, retaining all columns; symmetrization takes place after clipping. Splitting a row class along the row side of a discrepant rectangle doubles the bound on the number of classes. This gives the energy increment below without requiring equally sized classes.

| Step | Lean proof |
|---|---|
| One comparison inequality per matching | [WeightedMatchingCut.lean](../hall-reduction/WeightedMatchingCut.lean) |
| Conditional row averages and the energy identity | [RowAveraging.lean](../hall-reduction/RowAveraging.lean) |
| Weak cut approximation and the gain from high blocks | [RowWeakRegularity.lean](../hall-reduction/RowWeakRegularity.lean) · [RowGainProof.lean](../hall-reduction/RowGainProof.lean) |
| The one-quarter graph coefficient, including improper colorings | [QuarterDensity.lean](../hall-reduction/QuarterDensity.lean) |
| Cut estimates for wedges and triangles, and the shadow moment inequality | [KernelCutTransfer.lean](../hall-reduction/KernelCutTransfer.lean) · [KernelShadowModel.lean](../hall-reduction/KernelShadowModel.lean) |
| Symmetric half-bounded approximation and the unrestricted one-eighteenth coefficient | [HalfBoundedModel.lean](../hall-reduction/HalfBoundedModel.lean) |

With the pinned Lean 4.24.0 and mathlib from the package manifest, the named build target checks both theorems and their dependencies.

```sh
cd research/hall-reduction
lake build HalfBoundedModel
```

The axiom reports for both theorems list only propositional extensionality, classical choice, and quotient soundness. Each theorem carries a no-placeholder check. A clean rebuild of the complete local import chain for the graph, triple, and linear-palette theorems used 43 project modules, the pinned mathlib, and one Lean worker. The explicit tower for the cutoff and the growing-palette rate below are written refinements. The named density theorems quantify over all sufficiently large orders for a palette of at most $n$ colors. A further theorem checks the uniform rectangle bound for at most $cn$ colors for every fixed positive integer $c$. [Linear-palette theorem](../hall-reduction/LinearPalette.lean)

## The energy increment

Use uniform probability measure on rows and columns. For a partition $P$ write $U_P$ for the average adjacency on its rectangles. For any refinement $R$,
$$
 \|U_R\|_2^2-\|U_P\|_2^2=\|U_R-U_P\|_2^2.
$$
Starting from any partition with $K$ cells and any accuracy $\gamma>0$, one can achieve $\|G-U_R\|_\square\le\gamma$ with at most $K 4^{\lceil\gamma^{-2}\rceil}$ cells. Indeed, adjoin both sides of a cut witnessing discrepancy greater than $\gamma$. The gain in energy exceeds $\gamma^2$ by Cauchy–Schwarz on that cut, while energy is at most one. Refinements preserve symmetry because the same partition is used on both axes.

Put $\delta=\eta/4$. Begin with a partition of cut error at most $\delta$. Every refinement $P$ of this first partition still satisfies $\|G-U_P\|_\square\le2\delta$. To see this, let $H$ be the initial residual. Block averaging $H$ cannot increase its cut norm. Each cut integral against its block average is an integral of $H$ against the product of the blockwise proportions of the two test sets, both in $[0,1]$. Express these factors by their level sets.

Given a current partition $P$ of size $K$, mark all cells on which $U_P>t=1/2+\delta$. Stop when the marked area is at most $\delta$. Otherwise let $A_i$ be row class $i$, let $B_i$ be the union of its marked column classes, and write $a_i,b_i$ for their respective measures. Let $e_i=\int_{A_i\times B_i}G$. The block averages give $e_i\ge a_i b_i/2$ and $\sum_i a_i b_i>\delta$.

Refine $P$ to $R$ with cut error $\gamma=\delta^4/(128K^2)$. The normalized finite matching inequality, applied to $U_R$ with a palette padded to $n$ labels, gives
$$
 \delta e_i^2\le e_i/(2n)+\gamma
       +a_i\int_{A_i\times B_i}(t-U_R)_+.
$$
On $A_i\times B_i$ the shortfall is bounded by $|U_P-U_R|$. Keep the classes with $a_i\ge\delta/(2K)$. Their marked area is at least $\delta/2$, so weighted Cauchy–Schwarz gives $\sum_{\rm kept}a_i b_i^2\ge\delta^2/4$. Also $\sum_{\rm kept}1/a_i\le2K^2/\delta$. If $1/(2n)\le\gamma$, summing the inequalities divided by $a_i$ gives
$$
 \|U_P-U_R\|_1\ge (\delta/4)(\delta^2/4)
       -2\gamma(2K^2/\delta)=\delta^3/32.
$$
The energy therefore gains at least $\delta^6/1024$. There can be at most $\lfloor1024/\delta^6\rfloor$ such gains.

At termination put $V=\min(U_P,1/2)$. Its $L^1$ distance from $U_P$ is at most $\delta+\delta/2$. Together with the bound $2\delta$ for the residual in cut norm this gives $\|G-V\|_\square\le7\delta/2<\eta$.

For an explicit cutoff, set $K_0=4^{\lceil\delta^{-2}\rceil}$, $\gamma(k)=\delta^4/(128k^2)$, $K_{j+1}=K_j4^{\lceil\gamma(K_j)^{-2}\rceil}$, and $s=\lceil1024/\delta^6\rceil+1$. The integer $N(\eta)=\lceil64 K_s^2/\delta^4\rceil$ ensures the required finite-size inequality through every refinement.

## Edge and triple counts

A proper graph satisfying the hypotheses has at most $(1/4+\eta/2)n^2$ edges for $n\ge N(\eta)$. For the original coloring condition, a proper restriction after $o(n^2)$ deletions gives the same limiting coefficient. [Properification](../hall-reduction/Properification.lean)

For a linear $(7,4)$-free triple system let $G$ be its shadow, and take the model $V$ just constructed. For a matrix $A$ write $p_A,D_A,T_A$ for the ordered edge, two-edge path, and triangle densities. When $0\le A,B\le1$, the differences of these densities are bounded by one, two, or three times $\|A-B\|_\square$, respectively. Expand the difference of the products one edge at a time. Once the third vertex is fixed, the other factors are a product of two functions bounded by one.

We have $T_G\le D_G/4+p_G/(2n)$ from the count at one root, and $T_V\ge D_V-p_V/4$ from the bound $V\le1/2$. These give $3p_V^2\le3D_V\le p_V+14\eta+2/n$. Hence $p_V\le1/3+14\eta+2/n$ by factoring $3p_V^2-p_V$ whenever $p_V\ge1/3$. Since $6m/n^2=p_G\le p_V+\eta$, every linear system has
$$
 m\le (1/18+5\eta/2)n^2+n/3
 \qquad(n\ge\max\{7,N(\eta)\}).
$$
For an arbitrary admissible system add $n/2$ to the upper bound. The resulting explicit cutoff is large. The separate coefficient $0.07354$ and cutoff $10^6$ give a usable finite bound much earlier. [Triangle counts](../hall-reduction/ShadowTriangleCap.lean) · [Linear cleanup](../hall-reduction/LinearCleanup.lean) · [Practical finite theorem](../shadow-density/verified.md)

## How many colors are needed above one quarter

For each fixed $0<\alpha<1/4$, a graph on $n$ vertices with at least $(1/4+\alpha)n^2$ edges and every four-cycle rainbow needs
$$
 q=\Omega_\alpha\!\left(n\sqrt{\log^* n}\right)
$$
colors. Here $\log^*$ counts base-two logarithms until the argument drops to at most one. The growth furnished by this proof is slow.

For the proper case set $C=\max(1,q/n)$. The normalized comparison inequality permits the following bound on each marked rectangle:
$$
 \delta e_i^2\le C e_i/(2n)+C^2\gamma
       +C a_i\int_{A_i\times B_i}(t-U_R)_+ .
$$
Use $\gamma_C(k)=\delta^4/(128C^2 k^2)$ and require $1/(2n)\le C\gamma_C(K)$. Dividing by $Ca_i$ and summing over retained classes gives $\|U_R-U_P\|_1\ge\delta^3/(32C)$ by the same calculation. At most $1024C^2/\delta^6$ gains are possible. Thus the finite model of accuracy $\eta=4\delta$ exists once
$$
 n\ge N_C=\left\lceil 64 C K_s^2/\delta^4\right\rceil,\quad
 s=\left\lceil 1024C^2/\delta^6\right\rceil+1,\quad
 K_{j+1}=K_j4^{\lceil\gamma_C(K_j)^{-2}\rceil}.
$$
Here $K_0=4^{\lceil\delta^{-2}\rceil}$ as above. Padding to $n$ colors when $q<n$ is permitted.

To compare this recurrence with $n$, start an upper sequence at $L_0=\lceil(10^7C/\delta)^{16}\rceil+K_0$ and put $L_{j+1}=2^{2^{L_j}}$. For $k\ge L_0$, the base-two logarithm of $k4^{\lceil\gamma_C(k)^{-2}\rceil}$ is at most $k^6\le2^k$. The same upper bound handles the terminal factor $64C k^2/\delta^4$ and its rounding. By monotonicity $N_C\le L_{s+1}$. It follows that $\log^* N_C\le2(s+1)+\log^* L_0=O_\delta(C^2)$ for $C\ge1$.

In the unrestricted case properification first costs at most $(\alpha/2)n^2$ edges for sufficiently large $n$, uniformly over the palette. The surviving oriented edge density is at least $1/2+\alpha$. Take $\eta=\alpha/2$ and $\delta=\eta/4$. A half-bounded cut model of accuracy $\eta$ would force oriented density at most $1/2+\alpha/2$. Thus $n<N_C$, so $\log^* n=O_\alpha(C^2)$. In particular $C>1$ eventually and the stated palette bound follows. [Uniform sparse deletion](../hall-reduction/Properification.lean)
