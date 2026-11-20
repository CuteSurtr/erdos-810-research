# How many support errors does a low-rank matrix need?

Let $G$ be a graph with $n$ vertices, $q$ colors and every four-cycle rainbow. Take **any** matrix $A$ indexed by its vertices, over a field of any characteristic. It may be nonsymmetric and may have nonzero diagonal. Write $K$ for the number of **ordered edge positions** $uv$ of $G$ where $A_{uv}\ne0$, and $D$ for the number of **ordered nonedge positions**, including loops, where $A_{uv}\ne0$. Put $r=\operatorname{rank}A$, and take $S=r^2$ over any field or $S=\binom{r+1}2$ in characteristic zero.

Let $U$ be the number of unordered vertex pairs having exactly one common neighbor in $G$. Set $L=K$ for a proper coloring, and $L=K^2/(K+4U)$ in general, with $L=0$ if $K=0$. Then
$$
L^2\le qS(L+2qD).
$$
In particular, suppose $q\le Cn$ and $A$ is nonzero on at least $\delta n^2$ ordered edges. If $r=o(\sqrt n)$, it must also be nonzero on $\Omega_{\delta,C}(n^2/r^2)$ ordered nonedges. The estimate allows arbitrary entries on the retained edges, arbitrary zeros on other edges, and one-sided retention of an undirected edge. It gives a quantitative obstruction to approximating a dense #810 support by a low-rank zero pattern.

## Getting lists with distinct starts and ends

For each color retain its oriented edges on which $A$ is nonzero. Two retained darts of that color conflict at this stage if their starts agree or their ends agree. A pair of monochromatic incident undirected edges gives at most two of these conflicts. Its other endpoints have exactly one common neighbor since another would form a bad four-cycle. The endpoints determine their common neighbor and its two monochromatic edges, so there are at most $2U$ conflicts in total.

From a set of $k$ darts with $e$ conflicts one can take an independent set of size at least $k^2/(k+2e)$, by choosing darts first among their neighbors in a random order. Summing over colors and applying Cauchy–Schwarz gives at least $K^2/(K+4U)$ selected darts in total. Each color's list now has distinct starts and distinct ends. For a proper coloring take all $K$ retained darts.

## Charging defective pairs to false positives

In a chosen list $(u_i,v_i)$ form the matrix $B_{ij}=A_{u_i v_j}$. Its diagonal is nonzero and its rank is at most $r$. For distinct $i,j$ at least one crossed cell is a nonedge of $G$. If either is a loop this holds immediately. Otherwise two crossed graph edges would make a four-cycle containing two original edges of the same color. Thus every unordered pair with $B_{ij}B_{ji}\ne0$ uses at least one of the $D$ false positive cells. Within the list a given ordered cell is indexed by only one pair $(i,j)$, so it pays for at most one defect.

Over a characteristic-zero field an independent set in this defect graph has size at most $\binom{r+1}2$ by the sharp fooling-set theorem. Over any field the usual bound is $r^2$: for a defect-free principal submatrix $F$, its entrywise product with $F^{\mathsf T}$ is a nonsingular diagonal matrix, and the rank of such a product is at most the product of the two ranks. The latter follows by taking pairwise entrywise products of the columns in two rank factorizations. Therefore a list of size $\ell_c$ with $b_c$ defects satisfies $\ell_c^2\le S(\ell_c+2b_c)$. [Exact characteristic-zero defect bound](defects.md) · [Field-independent fooling-set bound and literature](https://arxiv.org/abs/1208.2920)

Summing, with $M=\sum_c\ell_c\ge L$, gives $M^2\le qS(M+2\sum_c b_c)$. Here $\sum_c b_c\le qD$. If the vertex degrees are available, the sharper bound is $\sum_{(u,v)}\min(q,\deg u,\deg v)$, summed over the $D$ false positive cells: each charged color must appear at both endpoints. Since $x^2/(x+2qD)$ is increasing for $x\ge0$, this gives the claimed inequality at $L$. Finally $U\le\binom n2$, so $K\ge\delta n^2$ implies $L\ge c_\delta n^2$. Rearranging proves the asymptotic lower bound on false positives.

## A weighted version over the complex numbers

There is also a magnitude-sensitive statement for proper colorings. Suppose $|A_{uv}|\le1$. Set $P=\sum_{uv\ {\rm edge}}|A_{uv}|^2$ and $E=\sum_{uv\ {\rm nonedge}}|A_{uv}|^2$, again summing ordered cells. Then
$$
P^2\le q\binom{r+1}{2}\,(P+2qE).
$$
To see this, for any complex matrix $B$ of rank at most $r$ the Hermitian matrix $J_{ij}=B_{ij}\overline{B_{ji}}$ has at most $S=\binom{r+1}{2}$ positive eigenvalues. Its trace is nonnegative, so Cauchy–Schwarz on the positive eigenvalues gives $(\operatorname{tr}J)^2\le S\operatorname{tr}(J^2)$. For a color list its diagonal contribution to $\operatorname{tr}(J^2)$ is at most $\sum_i|B_{ii}|^2$. For an unordered off-diagonal pair the product $|B_{ij}|^2|B_{ji}|^2$ is bounded by the sum of the squared magnitudes of its crossed nonedge entries. Charge those entries once per unordered pair and double for the two orders. The sums of all color-list traces and of their nonedge charges are at most $P$ (in fact equal to $P$ for the traces) and $qE$, respectively. Cauchy–Schwarz over the colors gives the display. The matrix inequality is sharp on a triangular-size fooling set with diagonal one. [Inertia calculation](fooling-sets.md)

The global edit and weighted bounds have written proofs. Lean verifies the characteristic-zero matrix input, the field-independent reciprocal-product rank bound, and the injection that charges distinct defective pairs of a color to distinct false positive cells. [Field-independent rank and charging proofs](../hall-reduction/ReciprocalRank.lean)
