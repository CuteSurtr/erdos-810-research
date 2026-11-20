# A Hall reduction for Erdős #810

Let $M(n)$ be the largest number of edges in a simple graph on $n$ vertices whose edges can be colored with at most $n$ colors so that every four-cycle uses four different colors. Cycles with chords count. Erdős asks whether some fixed $\varepsilon>0$ satisfies $M(n)\geq\varepsilon n^2$ for every sufficiently large $n$. This remains open. Sárközy and Selkow’s theorem for connected bipartite graphs excludes the complete bipartite graph $C_4=K_{2,2}$. [Problem statement](https://www.erdosproblems.com/810) · [Sárközy and Selkow, Theorem 4](https://ftp.cs.wpi.edu/pub/techreports/pdf/04-02.pdf)

Lean verifies the unrestricted upper coefficients **$1/4$ for graphs and $1/18$ for triples**. The graph proof constructs row averages, splits a class when a cut detects error, and proves an energy gain whenever too much area lies above one half. Clipping the resulting matrix and averaging it with its transpose gives a symmetric model bounded by one half. The two shadow triangle inequalities and the linear cleanup give the triple theorem. Both extremal-number theorems depend only on the standard Lean axioms of propositional extensionality, classical choice, and quotient soundness. [Graph theorem](QuarterDensity.lean) · [Triple theorem](HalfBoundedModel.lean) · [Finite argument and build](../graph-limits/finite-model.md) · [Short graph-limit proof](../graph-limits/quarter-short.md) · [Triangle argument](../shadow-density/eighteenth.md)

## A three-for-one transfer

Let $g(n;7,4)$ be the largest size of a family of triples on $n$ vertices such that every seven vertices contain at most three triples. For every $n\ge 7$, Lean checks

$$
M(n+1)\ge 3g(n;7,4).
$$

The construction uses at most **$n$ colors** on the $n+1$ vertices. This is a finite comparison between two extremal functions. The original density question still requires an asymptotic argument. [Transfer theorem](TripleTransfer.lean)

The proof strips out three-triple configurations on five points. Their five vertices are disjoint from every remaining triple. On each block, a complete five-vertex graph minus one edge gives nine edges with nine distinct labels. Two more edges join it to the common new vertex. Each four-cycle lies wholly within one block graph or within the graph of the remaining triples, since these graphs share only the new vertex. The same nine labels can therefore be reused on every block. For $n=7,8$, the proof uses the checked small graph certificates. [Isolation lemma](IsolatedBlocks.lean) · [Block coloring](BlockGadget.lean) · [Gluing lemma](GraphGluing.lean)

## Keeping the original number of vertices

For every $n\ge7$, the same construction and a deletion argument give the checked inequality

$$
M(n)\ge 3g(n;7,4)-\left\lfloor \frac{3g(n;7,4)}{n}\right\rfloor.
$$

For a family with $m$ triples, $a$ removed five-point blocks, and $b$ ordinary diamonds in the remainder, the $n$ old vertices span $3m-b$ edges. The graph with the hub has $3m+b+2a$ edges. Each edge survives $n-1$ of the $n+1$ possible single-vertex deletions, and every surviving graph already uses at most $n$ colors. Hence
$(n+1)M(n)\ge(n-1)(3m+b+2a)$. Add $(n-1)M(n)\ge(n-1)(3m-b)$ and divide by two to obtain $nM(n)\ge(n-1)(3m+a)$. The proof handles the small cases separately and takes an extremal triple family for the stated bound. [Deletion and rounding proof](VertexDeletion.lean)

There is also a bound independent of the size of $g$ in the error term,

$$
M(n)\ge 3g(n;7,4)-\left\lfloor\frac{n+8}{8}\right\rfloor.
$$

The four old vertices in a diamond contribute ten internal degree incidences and receive exactly two spokes. Each of the other $n-4$ old vertices has at most one neighbor there. Some diamond vertex therefore has degree at most $\lfloor(n+8)/4\rfloor$. Deleting that vertex or deleting the hub gives the bound above. The earlier repository estimate had error $\lfloor n/4\rfloor$. [Diamond degree proof](DiamondDegree.lean) · [Extremal inequality](VertexDeletion.lean) · [Earlier written bound](../../bruteforce/results/MAC_20261106/analytic/reduction-audit.md)

## The Hall bound on the original vertices

The Hall construction gives a second comparison on $n\ge 7$ vertices.

$$
g(n;7,4)\leq M(n).
$$

The Lean proof constructs a graph with **exactly one edge per triple** on the same vertex set. Two triples may share a pair. Burr, Erdős, Graham and Sós gave a constant-factor reduction on p. 273 using linear triple systems, where two triples share at most one vertex. The constant-one argument for the repository’s convention was already written in its October audit. [Original paper, p. 273](https://users.renyi.hu/~p_erdos/1989-10.pdf#page=11) · [Repository audit](../local-progress/research-2026-10-21/repo-and-reduction-audit.md) · [Lean proof](HallReduction.lean)

Each triple contains three pairs. A pair belongs to at most three triples, since four triples through one pair would fit on six vertices. For any $k$ triples, their $3k$ pair incidences therefore cover at least $k$ distinct pairs. Hall’s marriage theorem assigns a different pair to each triple. Use that pair as a graph edge and the omitted vertex as its color. A four-cycle with a repeated color would give four distinct triples on at most seven vertices, namely its four vertices and at most three colors. This contradicts the hypothesis.

The threshold matters under the repository’s exact-seven convention. On six vertices all $\binom{6}{3}=20$ triples are admissible, while $M(6)=11$. Lean checks both values.

## When the factor three is exact on the same vertices

If the triple family leaves an unused vertex, its extension can use that vertex as the hub and keep all $3m$ edges. If the family contains an isolated three-triple block on five vertices, Lean proves the stronger same-order bound $M(n)\ge 3m+1$. For $n\ge10$, remove the block, identify the hub of the remaining family with one block vertex, and put all ten differently colored edges of $K_5$ on the block. The two graphs share just the hub. Smaller orders use the finite bounds. [Exact same-order cases](BlockTransfer.lean)

There is also a finite test for when every pair of triples meets in at most one vertex. If
$$
m>\max\{3+g(n-5;7,4),\;2+\lfloor(n-4)/2\rfloor+g(n-4;7,4)\},
$$
then the family is linear and all $3m$ edges are available on the original $n$ vertices. Three triples on five vertices form an isolated block. In the other nonlinear case two triples form a diamond on four vertices. Each further triple touching the diamond has two outside points, and these outside pairs are pairwise disjoint. Removing the block or the diamond gives the two thresholds. With the census values at 16 and 17, any 32-triple example on 21 points would have to be linear. [Lean proof](DiamondPacking.lean) · [Finite census](../../bruteforce/results/2026-11-20/triple-census.md)

## Small triple systems

For the auxiliary hypergraph function, Lean proves the exact values below. The lower certificates through order 12 include the six rows and columns of a three-by-three grid and an explicit twelve-triple system. The kernel checks all 495 four-triple subfamilies of the latter. [Orders 7 through 12](SmallTripleNumbers.lean) · [Orders 13 through 15](TripleIncidence.lean)

| Vertices | 7 | 8 | 9 | 10 | 11 | 12 | 13 | 14 | 15 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| $g(n;7,4)$ | 3 | 4 | 6 | 7 | 9 | 12 | 13 | 15 | 18 |

Deleting one vertex gives $(n-2)g(n+1;7,4)\le(n+1)g(n;7,4)$. At ten vertices this alone allows eight triples. Every vertex would then have degree at least two, and the sum of degrees would be 24, so at least six vertices would have degree two. No triple can meet two of those vertices, since deleting both would leave at least five triples on eight vertices. The six vertices would therefore require at least twelve different triples, a contradiction. The other upper bounds follow from deletion and the seven-vertex definition.

### Counting at a single triple

For every $n\ge12$, the following inequality holds even when two triples share a pair.

$$
9g(n;7,4)\le n\bigl(1+\lfloor 2n/3\rfloor\bigr).
$$

At $n=13,14,15$ it gives upper bounds of 13, 15 and 18 triples. Explicit families attain all three. This gives proofs of the three maxima independent of the exhaustive census. The inequality also gives an asymptotic upper coefficient of $2/27$ for this auxiliary hypergraph problem. [Counting proof and exact values](TripleIncidence.lean) · [Constructions](CensusLower.lean)

Counting missing pairs across shadow cuts improves the asymptotic upper coefficient to $0.07354$ for arbitrary admissible triple systems. [Proof and exact checks](../shadow-density/verified.md) The stronger asymptotic coefficient is **0.073272**. [Width and degree-variance proof](../shadow-density/width.md) · [Lean theorem](ShadowWidthDensity.lean)


Fix a triple $e$. For each other triple $t$ meeting $e$, keep the one or two points of $t$ outside $e$. Any three resulting sets together contain at least five points, since adding $e$ would otherwise put four triples on at most seven points. Write $k$ for the number of sets. Their contribution to the sum of the degrees at $e$ is $\sum_t |t\cap e|$. If $k\le2$, this contribution is at most four.

Suppose $k\ge3$. The union of any two sets has size at least three. If all sets are pairs, two intersecting pairs form a path on three vertices and every other pair avoids all three vertices. The components are therefore single edges or two-edge paths. Each uses at least $3/2$ vertices per edge, so the degree contribution is at most $2(n-3)/3$. If one set is a singleton, the others are disjoint pairs avoiding it. Then $2k-1\le n-3$ and the contribution is $k+1\le n/2\le2(n-3)/3$.

Including $e$ itself gives $\sum_{x\in e}d(x)\le 1+\lfloor 2n/3\rfloor$. Summing over triples counts $\sum_x d(x)^2$. For $m$ triples, Cauchy–Schwarz gives $(3m)^2\le n\sum_x d(x)^2$, yielding the stated bound.

Gishboliner and Solymosi give the same leading coefficient $2/27$ for linear triple systems. Their proof also projects the neighbors of a triple onto its complement and sums vertex degrees. Their stated finite threshold is $2n^2/27+n/3$. Keeping the exact complement size $n-3$ in their linear proof gives the sharper counting step above. The argument here also handles triples sharing a pair, where a projected neighbor can be a singleton. Priority of that extension and of the exact small values remains unverified. Santos and Tyomkyn previously reported the larger normalized threshold $4/7$ for four triples. In their normalization $2/27$ corresponds to $4/9$. [Gishboliner and Solymosi, Theorem 1.1 and §3](https://arxiv.org/html/2606.25931v1) · [Santos and Tyomkyn, §4](https://arxiv.org/abs/2508.09841)

## What this gives for the open question

The formalization also proves that a family with at most two triples on every six vertices has at most three on every seven. Within a set of seven vertices, each triple misses four points. Four triples would give sixteen such omissions, while deleting each of the seven points leaves at most two triples, allowing only fourteen omissions.

The known near-quadratic lower bound is also checked end to end in Lean,
$$
M(n)=\Omega\!\left(n^2\exp(-4\sqrt{\log n})\right).
$$
Mathlib supplies Behrend’s construction and its Ruzsa–Szemerédi graph, in which each edge belongs to a unique triangle. Color each edge by the triangle’s third vertex. If two edges of a four-cycle received the same label, an edge incident to that label would belong to two different triangles. The finite transfer is $M(n)\ge 3R(n)$, where $R(n)$ counts triangles in Mathlib’s convention. The displayed lower bound allows the density to decay to zero. [Lean proof](NearQuadratic.lean) · [Mathlib construction](https://github.com/leanprover-community/mathlib4/blob/v4.24.0/Mathlib/Combinatorics/Extremal/RuzsaSzemeredi.lean)

Lean proves that a fixed positive lower bound for $g(n;7,4)/n^2$ for all sufficiently large $n$ would answer #810 affirmatively. [Hall reduction](HallReduction.lean) · [Conlon, Gishboliner, Levanzov and Shapira, introduction](https://par.nsf.gov/servlets/purl/10404339)

## Restricting to proper colorings

Lean proves that #810 has an affirmative answer if and only if it has one with a properly edge-colored graph, where incident edges have different colors. For any palette and any graph with all four-cycles rainbow, deleting at most $2R(3n)=o(n^2)$ edges makes the original coloring proper. [Equivalence and quantitative proof](Properification.lean) · [Repository argument from October](../local-progress/asymptotic-2026-10-15/properification-and-regularization.txt)

Choose a maximal collection of edge-disjoint, monochromatic paths of length two. Each endpoint pair has a unique common neighbor, since two such neighbors would give a four-cycle on which a color repeats. The selected paths therefore index edge-disjoint triangles in a tripartite graph on $3n$ vertices, and that graph has no additional triangles. The triangle removal lemma bounds the number of selected paths by $o(n^2)$. Deleting the two edges of each selected path eliminates every monochromatic pair of incident edges by maximality. [Mathlib triangle removal lemma](https://github.com/leanprover-community/mathlib4/blob/v4.24.0/Mathlib/Combinatorics/SimpleGraph/Triangle/Removal.lean)

## An upper bound from color classes

With $n$ vertices, $q$ available colors, and a proper rainbow-four-cycle coloring, Lean proves the finite inequality $(2q+n)m\le qn^2$. In particular, $3m\le n^2$ when $q=n$. Combining this with the deletion theorem gives $M(n)\le(1/3+o(1))n^2$ for the unrestricted problem. Retaining the difference between the two side sizes gives 0.297354. Propagating that gain through two further rectangle estimates gives 0.297331. Counting row degrees separately gives 0.295155. A contraction on the width of the shorter matching cut improves the unrestricted coefficient to **0.291632**. [Contraction theorem](ContractionDensity.lean) · [Width contraction proof](../rectangle-profile/contraction.md) · [Directional theorem](DirectionalDensity.lean) · [Earlier iterated theorem](IteratedDensity.lean) · [Earlier theorem](ShapeDensity.lean) · [Proof and exact certificates](../rectangle-profile/README.md) · [Endpoint count and upper bound](EndpointBound.lean) · [Repository upper-bound argument](../local-progress/asymptotic-2026-10-15/profile-density-bound.txt)

For an edge $uv$ of color $c$, let $s_c$ count all vertices incident to that color. Matching each such vertex to its partner gives $d(u)+d(v)+s_c\le 2n$. Indeed a repeated color on opposite edges excludes the two cross edges needed to close a four-cycle. Sum over oriented edges and apply Cauchy–Schwarz to the vertex degrees and the color-class support sizes. Each list sums to $2m$.

Optimizing the dimension of the equal-norm digit sphere gives an explicit bound with the classical Behrend exponent. For every $c>2\sqrt{2\log 2}=2.35482\ldots$ and all sufficiently large $n$, Lean proves
$$
M(n)\ge (n^2/14)\exp(-c\sqrt{\log n}).
$$
The proof also transfers any bound $r_3(L)\ge L\exp(-c\sqrt{\log L})$ for the maximum size of a three-term-progression-free subset of $[L]$. The published Theorem 1.1 of Elsholtz, Hunter, Proske and Sauermann supplies this input for every $c>2\sqrt{\log(24/7)}$ in natural logarithms. Lean checks the transfer and the classical sphere bound. The stronger input comes from the cited paper. [Transfer and sphere bounds](SphereBounds.lean) · [Optimized dimension](OptimizedSphere.lean) · [Elsholtz et al., Theorem 1.1](https://arxiv.org/pdf/2406.12290#page=2)

## Edges lost when making the given coloring proper

For every sufficiently large $n$, Lean constructs an $n$-vertex graph with at most $n$ colors, every four-cycle rainbow, in which every properly colored subgraph loses at least $(n^2/36)\exp(-8\sqrt{\log n})$ edges. Together with the uniform $o(n^2)$ deletion bound, this rules out a fixed power saving in that bound. The construction uses a Behrend sphere that avoids both midpoints and weighted thirds. [Construction and proof](../properification-lower/README.md) · [Lean theorem](ProperificationLower.lean)

A second construction groups the edges into monochromatic stars of size $k$. Every proper restriction retains at most one edge per star, and one fixed layer attains that bound. Choosing $k$ as a function of $n$ gives graphs with $n^{2-o(1)}$ edges for every sufficiently large $n$ whose maximum retainable fraction tends to zero. [Exact star construction](WeightedStars.lean) · [Quantitative tradeoff](StarTradeoff.lean)

There is also a finite guarantee valid with any palette. In a graph with $n$ vertices and $m$ edges, a proper restriction can always keep at least $m^2/[m+n(n-1)]$ edges when $m>0$. In affine-plane incidence examples with $2p^2$ vertices and $p^3$ edges, the exact maximum is $p^2$. [Finite wedge bound](ConflictPacking.lean) · [Affine-plane examples](AffinePlanePacking.lean)

## The golden-ratio upper bound

Lean also proves a stronger coefficient for the original graph problem,
$$
M(n)\le\left(\frac{\sqrt5-1}{4}+o(1)\right)n^2,\qquad
\frac{\sqrt5-1}{4}=0.309016994\ldots.
$$
For a properly colored graph the finite statement is $m\le((\sqrt5-1)/4)n^2+n$. The key finite estimate for a bipartite graph with part sizes $a,b$, at most $q$ colors and $e$ edges is $[q(a+b)+ab]e\le qab(a+b+1)$. Apply this to the cut between a color class's endpoints and the remaining vertices. The induced graph on the endpoints of a size-$k$ color class has at most $k^2$ edges. An explicit supporting line bounds the sum of these contributions over all colors. For $r=2m/n^2$ the resulting inequality is $r^2+r\le1+2/n$. [Rectangle and induced-edge counts](RectangleBound.lean) · [Finite and asymptotic upper bounds](GoldenRatio.lean) · [October argument](../local-progress/asymptotic-2026-10-15/golden-ratio-independent-audit.txt)

## Exactly when a bipartite coloring lifts to a sparse triple system

For a properly colored simple bipartite graph, lift each edge to the triple consisting of its left endpoint, right endpoint and color, in three disjoint classes. Lean proves that every four triples span at least eight points exactly when every four-cycle is rainbow and there is no four-edge path on five distinct vertices whose colors alternate between two labels. Either side of the bipartition can contain the endpoints of the path. This completes the converse left as a written proof in the October audit. [Full equivalence](LiftAlternation.lean) · [October classification](../local-progress/audit-2026-10-14/lift-classification.txt)

There is a symmetric way to test this. Use any two of the three classes as row and column coordinates and the remaining class as entries. All three resulting arrays must have four distinct entries in every filled two-by-two rectangle. Indeed, if four triples use $p,q,s$ distinct coordinates in the three classes, then $pq,ps,qs\ge4$ because each pair of coordinates identifies at most one triple. If $p+q+s\le7$, two of the counts must equal two and the third is at most three. The four cells fill the resulting rectangle. This also proves that the test applies to actual four-element subsets of the lifted triple family. [Three-projection theorem](LiftRectangles.lean)

## Recoloring a diamond

Suppose two triples share a pair, and every other triple meets their four vertices in at most one point. Their five distinct pairs form an ordinary diamond in the graph of all pairs from the triple system. Lean verifies that all five edges can be kept. Beginning with any omitted-point coloring, replace the five labels using the template in the proof. Every four-cycle that uses a diamond edge then has four distinct colors. [Lean proof](DiamondRecoloring.lean) · [Written reduction](../../bruteforce/results/MAC_20261106/analytic/reduction-audit.md)

An outside vertex has at most one neighbor in the diamond. A four-cycle using an internal edge is therefore either wholly inside, or has two consecutive vertices inside and two outside. In the latter case the three outside or crossing edges have distinct omitted colors, all outside the diamond. Any internal color from its four vertices works on that cycle. When every triple either shares at most one point with every other triple or lies in one of a family of disjoint ordinary diamonds, Lean proves that simultaneously recoloring the diamonds works on the **entire** graph. A cycle touching two diamonds uses internal colors from disjoint supports. For a cycle using only linear triples, equality of two adjacent colors would exhibit a shared pair. Equality of opposite colors would give four distinct triples on at most seven vertices. [Simultaneous coloring proof](ShadowReduction.lean)

## Two extra edges per diamond

For the triple families just described, write $b$ for the number of ordinary diamonds. Lean constructs an extension on $n+1$ vertices with **exactly $2b$ additional edges**, using the original $n$ colors. Label a diamond’s triples $012$ and $013$. Join the new vertex to 0 with color 3 and to 2 with color 1, simultaneously for every diamond. [Extension theorem](DiamondHub.lean) · [One-vertex graph construction and edge count](HubGraph.lean)

Lean also constructs the required diamonds directly from the input whenever every five or fewer points contain at most two triples. A pair of triples sharing two points must then be an ordinary diamond. Indexing by the four-point supports removes the choice of vertex ordering, and the seven-vertex restriction makes distinct supports disjoint. [Decomposition proof](DiamondDecomposition.lean)

The full shadow on the original $n$ vertices has exactly $3m-b$ edges when the family has $m$ triples. Each ordinary diamond accounts for exactly one double-counted pair. With the extra vertex the count becomes **$3m+b$**. For a linear triple family the original graph already has $3m$ edges. [Exact counts in Lean](ShadowCount.lean)

A four-cycle through the new vertex uses a two-edge path between two of its neighbors. If both come from the same diamond, the boundary lemma puts the middle vertex in that diamond. For different diamonds, a crossing edge’s omitted color lies outside its own diamond. If its label coincided with the far spoke label, its outside endpoint would see two vertices of the other diamond. A collision between the two old edge colors would force four distinct triples onto seven vertices. The Lean proof also handles a middle vertex inside either diamond. An independent enumeration checks all local configurations on up to eleven old vertices for this rule. [Exhaustive local check](check_hub.py)

## Reproduce the proof

From the repository root, with Elan installed, run

```sh
cd research/hall-reduction
lake build
```

The default Lake build imports the archived finite graph model and pins Lean and Mathlib to 4.24.0. The proof checks reject any dependency on `sorryAx` for the Hall construction, the extremal bound, the density implication, and the diamond recoloring theorem. The separate 4.33.1 standalone project has its own graph definitions and build. [Finite graph model](../local-progress/BruteForce.lean) · [Hall proof checks](HallReduction.lean) · [Diamond proof checks](DiamondRecoloring.lean)
