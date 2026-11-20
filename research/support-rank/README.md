# Matrix rank required by a dense rainbow-four-cycle graph

Let a simple graph $G$ have $n$ vertices, $m$ edges and $q$ colors, with every four-cycle rainbow. A matrix $A$ over a field fits the graph if $A_{uv}\ne0$ exactly when $uv$ is an edge. In particular the diagonal is zero, and the two entries at an edge can be different. Put $r=\operatorname{rank}A$. Every positive-density sequence with $q=O(n)$ requires $r=\Omega(\sqrt n)$ over **every field**, even when the fitting matrix and the field change with $n$.

## Matching bounds

Let $t$ be the number of edges in any matching of a single color. We have

$$
t\le\binom r2\quad\text{over every field},\qquad
2t\le\binom{r+1}{2}\quad\text{in characteristic zero}.
$$

For the first inequality, form the matrix of all two-by-two minors of $A$, with an arbitrary common vertex order for the row and column pairs. It has rank at most $\binom r2$ by taking the second exterior power of a rank factorization. Restrict its rows and columns to the $t$ matching edges. A diagonal minor is $-A_{uv}A_{vu}\ne0$. For distinct matched edges $uv,xy$, each of $A_{ux}A_{vy}$ and $A_{uy}A_{vx}$ is zero. Nonvanishing of either product would give a four-cycle containing the two same-color edges. The restricted minor matrix is diagonal and nonsingular. Lean proves the rank bound directly in alternating coordinates over an arbitrary field. [Support-rank proof](../hall-reduction/SupportRank.lean)

For the characteristic-zero improvement, list both orientations of every matched edge. Write $u_i,v_i$ for the start and end of dart $i$. Both lists are injective. The $2t$-square matrix $B_{ij}=A_{u_i v_j}$ has rank at most $r$ and nonzero diagonal. If $i\ne j$, the crossed entries cannot both be nonzero, as they would complete a four-cycle containing both same-color edges. For reverse orientations of one edge both crossed entries are diagonal zeros. Therefore $B$ is a fooling-set matrix and its size is at most $\binom{r+1}{2}$. The same proof works for any list of equally colored darts with distinct starts and distinct ends. [Sharp fooling-set theorem](fooling-sets.md) · [Application to graph matchings in Lean](../hall-reduction/MatchingDartsRank.lean)

If $A$ is real symmetric with $p$ positive and $s$ negative eigenvalues, one further has $t\le ps\le\lfloor r^2/4\rfloor$. The diagonal matching minors are now strictly negative. The eigenvalues of the symmetric second compound are the pairwise products of distinct indexed eigenvalues of $A$, by orthogonal diagonalization. Exactly $ps$ products are negative, bounding the size of a negative-definite restriction.

## Allowing adjacent edges to repeat a color

Write $T$ for any of the preceding upper bounds on a one-color matching, and let $U$ count unordered vertex pairs with exactly one common neighbor in $G$. Then

$$
m^2\le qT(m+2U)\le qT\big(m+n(n-1)\big). \tag{1}
$$

For a color $c$, put $m_c=|E_c|$ and let $P_c$ count unordered incident pairs of distinct edges of that color. The other endpoints of such a pair have exactly one common neighbor, since a second would complete a four-cycle with a repeated color. The endpoints determine the middle vertex and the color. Hence $\sum_c P_c\le U$. On the $m_c$ vertices of the line graph of the color class, select those that occur before every neighbor in a uniform random ordering. They form a matching and their expected number is $\sum_e 1/(1+d_e)\ge m_c^2/(m_c+2P_c)$ by Cauchy–Schwarz. Thus $m_c^2\le T(m_c+2P_c)$, also for empty classes. Sum and use $m^2\le q\sum_c m_c^2$ to obtain (1). For a proper coloring the stronger direct count $m\le qT$ holds.

For example, $m\ge\delta n^2$ and $q\le Cn$ imply $r\ge 2\delta\sqrt{n/(3C)}$ over every field, by $T\le r^2/2$ and $m+n(n-1)\le3n^2/2$. A candidate construction with rank $o(\sqrt n)$ in even one field therefore cannot give positive density in #810. The matrix-rank bounds on matchings above are machine-checked. Inequality (1) and the real-symmetric inertia refinement have the written proofs given here.
