# How many edges can a point–line incidence construction supply?

Fix a bipartite incidence graph on distinct points and lines. Replace each point and each line by any positive number of copies, putting in all edges above each chosen incidence. Allow at most $q$ colors and require every four-cycle to be rainbow, including those that use two copies of the same object. Write $n$ for the total number of vertices, counting copies. One may omit whole base incidences. The following bounds hold uniformly for $1\le q\le n^2$ and sufficiently large $n$.

| Underlying incidence relation | Maximum number of edges, up to absolute factors | With $q=n$ |
| --- | --- | --- |
| Real points in general position and real lines | $n\sqrt q$, capped at order $n^2$ | $n^{3/2}/\sqrt2+O(n)$ |
| Arbitrary real points and real lines | $n^{4/3}+n^{6/5}q^{2/5}$, capped at order $n^2$ | $\Theta(n^{8/5})$ |
| Any bipartite base graph containing no four-cycle | $n^{3/2}+n^{4/3}q^{1/3}$, capped at order $n^2$ | $\Theta(n^{5/3})$ |

The first row also holds if the distinct points are required to be in convex position. This describes a direct way of using Erdős–Szekeres configurations as vertices and lines as witnesses for #810. More edges are attainable when collinear triples are allowed. The distinction depends on which incidences the construction retains. The separate progression-free projection of an ES example uses a different graph. [ES projection](geometric-lower.md)

## The sharp constant for general-position points

Let point $i$ have $a_i$ copies and let $d_i$ be the number of neighboring line vertices, including their copies. Write $P$ and $L$ for the total numbers of point and line vertices. Then $\sum_i a_i=P$, $\sum_i d_i\le2L$ and the number of edges is $m=\sum_i a_i d_i$. For $a_i,d_i\ge2$ the $a_i d_i$ edges form a complete bipartite graph. Any two of these edges occur on a common four-cycle, so $a_i d_i\le q$, regardless of whether the original coloring was proper. [Rectangle palette bound in Lean](../hall-reduction/IntervalWindows.lean)

On these terms Cauchy–Schwarz gives
$$
\sum_i a_i d_i\le\sqrt q\sum_i\sqrt{a_i d_i}\le\sqrt{2qPL}\le n\sqrt{q/2}.
$$
The terms with $a_i=1$ or $d_i\le1$ add at most $2L+P\le2n$. Thus $m\le n\sqrt{q/2}+2n$.

More generally, if each line contains at most $j$ distinct points, replace $2L$ by $jL$. The same argument gives $m\le (\sqrt{jq}/2)(P+L)+P+jL$. Lean verifies this finite upper bound directly for the complete rectangles of an arbitrary rainbow-four-cycle graph under the stated incidence sum bound. The asymptotic lower construction and the other two rows of the table have written proofs. [Finite graph theorem in Lean](../hall-reduction/IncidenceClones.lean)

For the matching lower bound, take $k\ge3$ points in convex position and the $k$ lines of consecutive polygon sides, including the closing side. The incidence graph is a cycle of length $2k$. Give its edges two alternating colors, replace each vertex by $h$ copies, and give each new edge the triple of its old color, point-copy index and line-copy index. This has $2kh$ vertices, $2kh^2$ edges and $2h^2$ colors. Use $h=\lfloor\sqrt{q/2}\rfloor$, $k=\lfloor n/(2h)\rfloor$, and add isolated points when $k\ge3$ and $h\ge1$. All the base points, including padding, may be chosen on one parabola. For $q=n$ the result is $n^{3/2}/\sqrt2+O(n)$. For $q\to\infty$ with $q=o(n^2)$ it is $(1+o(1))n\sqrt{q/2}$. For the uniform order bound one may cap $h$ at $\lfloor n/6\rfloor$. At $q=1$ a matching supplies order $n$ edges.

The same cycle works on the ES repository's 17-point octagon witness. Its consecutive connecting lines each contain exactly the two indicated points, even though some polygon sides may cross. With $h=17$ this gives **578 vertices, 9,826 edges and 578 colors**. All **1,965,200 four-cycles** were checked directly. The cycle count is also $k\binom h2(\binom{2h}{2}+h^2)$, by separating two point copies of one base point from two copies of consecutive points. [Original coordinates](../es-connection/octagon-anchor.json) · [Reproducible graph checks](check_incidence.py)

## Handling arbitrary multiplicities

Choose $H\ge1$. A vertex in a class with more than $H$ copies has degree at most $\max(1,q/H)$, by the same complete-rectangle observation. At most $n\max(1,q/H)$ edges touch such vertices. Retain the other classes, and sample each independently with probability equal to its multiplicity divided by $H$. If the number of incidences in the sample is $I$, its expectation is the number of remaining edges divided by $H^2$. The expected numbers of sampled points and lines are both at most $n/H$, and the point and line samples are independent.

For real points and lines, the Szemerédi–Trotter bound for $u$ points and $v$ lines is $O((uv)^{2/3}+u+v)$. Concavity on each side and independence now bound the light edges by
$$
O(n^{4/3}H^{2/3}+nH).
$$
Take $H=\max(1,q^{3/5}n^{-1/5})$. For $q\le n^2$ the $nH$ term is absorbed. This gives the second upper bound. [Szemerédi and Trotter, *Extremal Problems in Discrete Geometry*](https://trotter.math.gatech.edu/papers/38.pdf)

For a four-cycle-free base, the elementary incidence bound is $I\le u\sqrt v+v$. Indeed, writing the $v$ degrees as $e_j$, each pair of the $u$ vertices has at most one common neighbor. Thus $\sum_j e_j(e_j-1)\le u(u-1)$, and Cauchy–Schwarz gives $I^2\le v(I+u^2)$. Sampling now bounds the light edges by $O(n^{3/2}H^{1/2}+nH)$. Taking $H=\max(1,q^{2/3}n^{-1/3})$ gives the third upper bound.

## Constructions for all palette sizes

The real-plane integer construction uses the points $(y,u-y^2)$ and the lines $Y=t+x^2-2xX$, with $1\le x,y\le s$ and $1\le t,u\le4s^2$. An incidence is equivalent to $u-t=(y-x)^2$. The two parts have $8s^3$ vertices altogether and at least $3s^4$ incidences. There are at most $2s-1$ shifts $y-x$; using them as edge colors makes the base proper. The base is four-cycle-free because two distinct real lines share at most one point. After replacing every vertex by $h$ copies and using the copy indices in the color, the parameters are
$$
n_0=8hs^3,\qquad m_0\ge3h^2s^4,\qquad q_0\le2h^2s.
$$
For $q\lesssim n^{1/3}$ use the base with $s$ of order $n^{1/3}$ and a single color. For the other regime put $s_0=(n^2/q)^{1/5}$ and $h_0=q^{3/5}n^{-1/5}$. Taking integer $s,h$ of these orders with $8hs^3\le n$ and $2h^2s\le q$ gives $\Omega(n^{6/5}q^{2/5})$ edges. For explicit rounding, take $s=\max(1,\lfloor s_0/4\rfloor)$ and $h=\lfloor h_0/16\rfloor$ when $h_0\ge32$. Then $s\le s_0$, $s\ge s_0/8$, and $h\ge h_0/32$. When $h_0<32$ the one-color construction already supplies a constant multiple of the target. [Integer coloring and the copy-index argument](geometric-lower.md)

For the four-cycle-free class use the points $(y,u-y^2)$ and the lines $Y=t+x^2-2xX$ over an odd prime field of order $s$, with all four coordinates unrestricted. The base has $2s^2$ vertices and $s^3$ incidences. The shift coloring uses $s$ colors, and two distinct lines again have at most one point in common. Blowing up by $h$ gives $2hs^2$ vertices, $h^2s^3$ edges and $h^2s$ colors. With $q\lesssim\sqrt n$, the unreplicated single-color example gives order $n^{3/2}$. Otherwise take $s$ of order $(n^2/q)^{1/3}$ and $h$ of order $q^{2/3}n^{-1/3}$. Bertrand's postulate allows $s$ to be an odd prime within a constant factor. More explicitly, for $s_0=(n^2/q)^{1/3}\ge6$ choose a prime between $s_0/2$ and $2s_0$; for $s_0<6$ use $s=3$. In both cases $s_0/2\le s\le3s_0$. Set $h=\lfloor q^{2/3}n^{-1/3}/64\rfloor$ when this floor is at least two. Then the budgets hold and the edge count is $\Omega(n^{4/3}q^{1/3})$. For smaller $h$ the one-color construction suffices. Isolated vertices give every intervening order.

These are sharp bounds within the indicated classes. The unrestricted quadratic-density question in #810 remains open.
