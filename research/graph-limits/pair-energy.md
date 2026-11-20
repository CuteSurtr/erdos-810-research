# The graph on unordered vertex pairs

Every hypothetical positive-density family for Erdős #810 with a linear palette has a proper dense restriction whose pair graph has a negative adjacency eigenvalue of order \(n\). At the upper coefficient \(1/4\), the original edges and nonedges give a bipartition of this pair graph after \(o(n^3)\) edge deletions. The statements apply to arbitrary matching sizes. They extend the repository's corresponding spectral obstruction for perfect bipartite colorings. The general auxiliary-graph and spectral methods come from the color energy graph and the independent-set ratio bound. [Perfect-matching case](../local-progress/multicolor-2026-10-15/crossed-pair-operator.txt) · [Fish–Pohoata–Sheffer](https://arxiv.org/abs/1810.09019) · [Haemers on the ratio bound](https://arxiv.org/abs/2102.05529)

## Finite construction and counts

Let \(G\) be a properly edge-colored simple graph on \(n\) vertices, with every four-cycle rainbow. Color \(c\) is a matching of size \(k_c\), with endpoint set \(S_c\). Write \(\pi_c\) for the permutation of \(S_c\) swapping the ends of each matching edge.

Make a graph \(J\) with vertex set \(\binom{V(G)}2\). For \(P\subset S_c\) of size two, join \(P\) to \(\pi_c P\) when they differ. Both pairs in such a link are disjoint. For two fixed pairs there are only two possible bijections between their endpoints. Two colors realizing different bijections would occupy an entire four-cycle with a repeated opposite color. The same bijection cannot carry two colors. Thus \(J\) is simple with maximum degree at most the palette size \(q\).

The \(s=|E(G)|\) original edges form an independent set \(I\) of \(J\). Occupying both ends of a link creates a four-cycle with its other two edges colored \(c\). Write \(v\) for total degree of \(J\), \(w\) for the degree sum on \(I\), and \(b\) for the number of links entirely outside \(I\). Then
\[
 v=2\sum_c k_c(k_c-1),\qquad
 w=\sum_c (e_G(S_c)-k_c),\qquad
 b=v/2-w=\sum_c(k_c^2-e_G(S_c)).
\]
For each color the moving pairs number \(\binom{2k_c}{2}-k_c\); among these, exactly \(e_G(S_c)-k_c\) are original edges. Independence accounts for the formula for \(b\).

There is also a local edit interpretation. For a single \(c\), the two-element orbits of \(P\mapsto\pi_cP\) each contain zero or one original edge. Inserting one edge in each empty orbit makes \(\pi_c\) interchange edges and nonedges away from its fixed pairs. The exact minimum number of local insertions is \(k_c^2-e_G(S_c)\). These completions take place separately on the different endpoint sets.

## Negative spectrum at every positive density

Let \(\mathcal A\) be the normalized adjacency of \(J\) on its positive-degree vertices. For \(w>0\),
\[
 \lambda_{\min}(\mathcal A)\le-\frac{w}{v-w}.
\]
In the degree-weighted inner product test the random-walk operator with \(1_I-w/v\). Its edge-energy numerator is \(-w^2/v\); its squared norm is \(w(1-w/v)\). The ordinary adjacency bounds follow by compressing to the normalized indicators of \(I\) and its complement. With \(t=\binom n2-s\), the resulting symmetric matrix is
\[
 \begin{pmatrix}0&w/\sqrt{st}\\w/\sqrt{st}&(v-2w)/t\end{pmatrix}.
\]
Its smaller eigenvalue is an upper bound on the least adjacency eigenvalue of \(J\). Lean checks the finite centered-indicator identities used here. [Algebra in Lean](../hall-reduction/PairEnergyBounds.lean)

Suppose \(s\ge\delta n^2\) and \(q\le Cn\), for fixed positive \(\delta,C\). To see why \(w=\Omega_{\delta,C}(n^3)\), build a tripartite graph on two disjoint copies of \(V(G)\) and one copy of the colors. Join \(x_L\) to \(y_R\) for every original edge \(xy\), in both orientations. Join each color to both copies of its endpoints. For each oriented edge \(x_Ly_R\), its own color gives a canonical triangle. The \(2s\) such triangles are edge-disjoint because colors are matchings. Removing all triangles requires \(\Omega(n^2)\) edges. The triangle removal lemma therefore supplies \(\Omega_{\delta,C}(n^3)\) triangles. Their exact count is \(2\sum_c e_G(S_c)=2(w+s)\). [Fox's graph removal lemma](https://arxiv.org/abs/1006.1300)

Now \(v=O_C(n^3)\), and \(w\le v/2\). This gives a negative normalized eigenvalue bounded away from zero. For the ordinary adjacency, the same centered indicator has numerator \(-w^2/v\) and ordinary squared norm at most \(\binom n2\), giving \(\lambda_{\min}(A_J)\le-\Omega_{\delta,C}(n)\). When the original coloring allows equal incident labels, the sparse-deletion theorem first supplies a proper restriction with the same limiting density. In this case form \(J\) from the restriction. [Proper restriction](../hall-reduction/Properification.lean)

## Structure near one quarter

Suppose \(s/n^2\to1/4\) along such a sequence. The uniform half-density rectangle bound implies \(G\to1/2\) in cut norm. Indeed every rectangle has positive excess \(o(n^2)\), and partitioning its complement into rectangles gives the same bound for its deficit since the whole matrix has excess \(o(n^2)\). In particular \(e_G(S_c)=|S_c|^2/4+o(n^2)=k_c^2+o(n^2)\) uniformly. Summing over the linear palette gives \(b=o(n^3)\). Since \(v=\Omega_{\delta,C}(n^3)\), deleting \(b\) links makes \(J\) bipartite, and \(\lambda_{\min}(\mathcal A)\to-1\). For \(q\le Cn\), Cauchy–Schwarz gives \(v\ge 2s^2/(Cn)-2s\). The two-by-two compression then yields \(\lambda_{\min}(A_J)\le-(1/(4C)-o(1))n\). [Uniform rectangle bound and sparse deletion](quarter-short.md)

The same deficit measures a constraint on the original adjacency matrix \(A\). For each \(c\), let \(B_c\) have one column \(e_u-e_v\) for each \(c\)-edge \(uv\), oriented arbitrarily. Its compression \(B_c^\top(A+\mathrm{Id})B_c\) has zero diagonal. In an off-diagonal entry the sums of the two possible cross matchings are each zero or one. Their difference has square one exactly when a single cross edge is present. If \(N_j\) counts unordered pairs of same-color edges with \(j\) cross edges, then
\[
 b=2N_0+N_1,\qquad
 \sum_c\|B_c^\top(A+\mathrm{Id})B_c\|_F^2=2N_1\le 2b.
\]
Thus this sum of squared compressions is \(o(n^3)\) at the upper coefficient. Equivalently, on almost all matching pairs counted with multiplicity, the two crossing edges meet at a common endpoint. Both the independence and matching-compression tests are necessary conditions on a candidate. They currently give no smaller unrestricted coefficient.

## A finite witness

For the 4:30 p.m. certificate on 128 vertices with 2,944 edges, \(v=130716\), \(w=40239\), and \((N_0,N_1,N_2)=(5211,14697,12771)\). Thus the least normalized eigenvalue is at most \(-4471/10053\), and the two-dimensional ordinary test gives approximately \(-6.538\). The checker can construct all pair-graph links explicitly and compare the volume, independent set and cut with the matching counts. Run it with the catalog path, vertex count and optional flag shown below. [Fixed certificate](https://github.com/CuteSurtr/erdos-810-research/blob/0f4c37d59834ab764fc530b3b503e995570d8af3/bruteforce/results/2026-11-20-evening/certs.json) · [Finite checker](check_pair_energy.py)

```sh
python3 research/graph-limits/check_pair_energy.py catalog.json 128 --explicit
```
