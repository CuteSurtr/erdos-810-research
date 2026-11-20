# Dense constructions with bounded neighborhood VC dimension

There are properly colored #810 graphs of open-neighborhood VC dimension at most two with $\Omega(n^{5/3})$ edges, and of dimension at most three with $\Omega(n^{7/4})$ edges, for all sufficiently large orders. More generally, for each fixed $d\ge2$ there is an integer-coordinate construction of VC dimension at most $d$ with $\Omega_d(n^{2-2/(d+3)})$ edges. These are lower bounds for the same restricted extremal problem as the [neighborhood-tour upper bound](ordering.md).

## Finite-field paraboloids

Take $d=2$ or $3$ and let $p$ be a prime congruent to three modulo four. Start with two copies of $\mathbb F_p^d$. On $\mathbb F_p^{d-1}$ put $Q(x)=\sum_i x_i^2$. The only zero of $Q$ is the zero vector, since $-1$ is a quadratic nonresidue. Let $S=\{(x,Q(x)):x\in\mathbb F_p^{d-1}\}$. Join each left vertex $u$ to $u+s$ for all $s\in S$, giving the edge color $s$.

The set $S$ contains no nonconstant three-term progression. A progression with midpoint $(x,Q(x))$ and horizontal step $h$ satisfies $Q(x+h)+Q(x-h)=2Q(x)$, hence $2Q(h)=0$, then $h=0$. Edges with the same color form a matching. Two opposite edges of the same color $s$ would have crossed shifts $s-D$ and $s+D$ for a nonzero difference $D$ of row vertices. This would give a progression in $S$. Thus every rectangle is rainbow.

Write a row as $(x,t)$ and a column as $(y,u)$. The condition $u-t=Q(y-x)$ can be written as

$$
u-Q(y)=t+Q(x)-2x\cdot y.
$$

The change of column coordinates $(y,u)\mapsto(y,u-Q(y))$ turns every row neighborhood into an affine hyperplane. On the opposite side use $(x,t)\mapsto(x,t+Q(x))$. A family of affine hyperplanes in dimension $d$ cannot shatter $d+1$ points. If one hyperplane contains all those points, some one belongs to the affine span of the others, and cannot be omitted by a hyperplane containing the others. A shattered set in a bipartite graph lies in one part, because a single open neighborhood must contain the entire set. This proves the VC bound.

Replace every vertex by $h$ independent copies. Above every original edge put all $h^2$ edges and give an edge the triple consisting of its original color, left copy index, and right copy index. If a product rectangle has repeated colors, the two projected base cells of those colors must coincide: properness handles a repeated row or column in that projection, and the base rainbow property handles four distinct corners. Equal copy indices then force identical product cells. Copies of a vertex have identical neighborhoods, so this operation preserves the VC bound.

Taking $h=2p$ uses the entire palette. There are exactly $n=4p^{d+1}$ vertices and colors, and $4p^{2d+1}$ edges. At $d=3,p=3$ this gives 324 vertices, 8,748 edges and 2,364,147 rainbow four-cycles.

To cover every sufficiently large order, the same construction works at each odd prime. In two horizontal coordinates use $x_1^2-\lambda x_2^2$ with any quadratic nonresidue $\lambda$, using the associated bilinear form in the hyperplane equation. In one coordinate keep $x^2$. Bertrand's postulate gives a prime between half of $(n/4)^{1/(d+1)}$ and that quantity, up to rounding. Add isolated vertices to the resulting graph. The empty trace on either part was already realized by vertices on that same side, so the VC bound persists.

## An integer construction in arbitrary fixed dimension

In the plane, the integer example below reaches the sharp order for real point–line incidences with arbitrary multiplicities. The finite-field example reaches the sharp order for blowups of four-cycle-free bipartite graphs. [Matching upper bounds and dependence on the palette](incidence.md)

Let $s=d-1$, fix an integer $L\ge2$, and put $T=4sL^2$. On each side use the $N=L^s T$ points of $\{1,\ldots,L\}^s\times\{1,\ldots,T\}$. Join $(x,t)$ to $(y,u)$ if $u-t=\lVert y-x\rVert^2$, coloring by $y-x$. Strict positivity of the square norm gives the same progression obstruction over the integers. The affine-hyperplane calculation applies over the reals after restricting the common point set to the box.

There are at most $q_0=(2L-1)^s$ colors and at least $(3T/4)L^{2s}$ edges, because for each horizontal pair the time difference is at most $T/4$. Blow up by $h=\lfloor2N/q_0\rfloor=\Theta_d(L^2)$ as above. Then $q_0h^2\le n=2Nh$, $n=\Theta_d(L^{s+4})$, and the number of edges is $\Omega_d(L^{2s+6})$. This gives the stated exponent. The same order holds for all sufficiently large $n$ in this integer construction by taking the largest available size below $n$ and adding isolated vertices. Consecutive construction sizes have asymptotic ratio one.

## A concrete bridge to the Erdős–Szekeres coordinates

Any finite rational planar set in general position has no three-term arithmetic progression. After clearing denominators, choose an integer linear functional preserving all nonzero point differences and all nonzero differences $a+b-2c$ for distinct endpoints. Only finitely many slopes must be avoided. A sufficiently large odd modulus preserves these nonzero values. Its image is a set of distinct cyclic shifts giving a properly colored #810 board by the same argument as above.

For the 17-point octagon witness from the ES project, the explicit map $(x,y)\mapsto x+279y\bmod299$ gives 17 distinct progression-free shifts. The resulting graph has **598 vertices, 5,083 edges, 17 colors and 14,950 four-cycles**, all rainbow. With 35 copies per vertex it gives 20,930 vertices, 6,226,675 edges and 20,825 colors. The property used from these coordinates is the absence of midpoint triples. The same map was verified directly on the stored witness. [ES coordinates](../es-connection/octagon-anchor.json) · [ES transversal result](../es-connection/README.md) · [Verification code](check_geometric_lower.py)

Run the verification script from the repository root. It exhausts pairs of rows in the displayed finite-field examples and the 598-vertex cyclic graph, and computes the latter cycle count independently from the multiplicities of shift differences.

An exhaustive follow-up allows arbitrary finite abelian targets for the same coordinates. The smallest has 285 elements and gives a 570-vertex shift graph. [Exact quotient search](../es-connection/quotients.md)
