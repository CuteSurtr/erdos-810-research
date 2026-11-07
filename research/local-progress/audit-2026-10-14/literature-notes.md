# Literature and mathematical follow-through for the #810 audit

Checked 2026-10-14. These notes distinguish results established in the cited literature from elementary deductions made during this audit. Originality of the latter has **not** been established.

## What the existing file establishes

`HypergraphReduction.lean` proves correct elementary local implications, but its description as three new structural theorems is not supported by the mathematics or the literature check.

* Its cycle-span hypothesis only concerns quadruples already forming graph 4-cycles. Since a genuine 4-cycle has four distinct vertices, requiring that span to exceed seven is exactly requiring four distinct colors. No general hypergraph, its edges, its linearity, a projection, or an edge-count lower bound is constructed by this theorem.
* The operation-coloring theorem applies cancellation to exclude equal colors on adjacent edges, and assumes the required inequalities on opposite edges. This is a useful formal lemma, not a construction satisfying the difficult hypothesis.
* The list-fiber theorem is the inequality that a sum of `r` terms bounded by `alpha` is at most `alpha*r`. It has no formal graph, color partition, independence number, or exhaustive assertion about 37,569 graphs in its assumptions or conclusion.

The full hypergraph `(7,4)`-free property is strictly stronger than the file's local cycle hypothesis. For example a monochromatic four-edge star has no graph 4-cycle, so its local hypothesis is vacuous, while its four lifted triples span only six vertices. Even proper coloring does not fix this mismatch: a four-edge path colored alternately with two colors lifts to four triples on seven points, with no graph 4-cycle.

## Primary-source findings

### Burr–Erdős–Graham–Sós, 1989

[Original paper](https://fanchung.ucsd.edu/ron/papers/89_04_maximal_antiramsey.pdf), pages 272–273, visually inspected.

Page 272 proves the path result via triples and a three-part partition. Starting with `2n` hypergraph vertices, it arranges `|A|+|B|=n`, `|C|=n`, retains at least a `3/16` fraction, and colors the edge `ab` by `c`. Page 273 explicitly states `chi_S(n,c*g(n;7,4),C4) <= n` for a positive constant, and defines `g` using **linear** triple systems: distinct triples share at most one point. It also gives `chi_S(n,c*r_4(n),C4) <= n`. Consequently the basic reduction is old. The two-part improvement below is a refinement of the extraction step, not a new discovery of the reduction.

Theorem 6.3 and page 273 also give `chi_S(n,n²/exp(c*sqrt(log n)),P4)<=n`. Here `P4` means four vertices and three edges. Any two edges of a `C4` belong to one of its three-edge paths. Thus this already gives `M(n)>=n²/exp(O(sqrt(log n)))=n^{2-o(1)}`. In particular, a proposed universal upper bound `M(n)=O(n^{2-delta})` with fixed positive `delta` would contradict a known construction.

### Sárközy–Selkow, 2006

[Publisher abstract and DOI](https://onlinelibrary.wiley.com/doi/abs/10.1002/jgt.20148).

Their theorem applies to connected bipartite target graphs that are not complete bipartite. Therefore it does not settle `C4=K2,2`.

### Existing public discussion, December 2025

[Tao's sum-coloring comment](https://www.erdosproblems.com/forum/thread/810#post-2072) already describes the construction in characteristic two and its connection with the finite-field Ajtai–Szemerédi square theorem. [The discussion](https://www.erdosproblems.com/forum/discuss/810) also contains Sawhney's explanation of linearization followed by random tripartition. The discussion was obtained directly because the web renderer returned HTTP 403.

Tao also lists the same lower-bound edge counts through 12 that appear in the repository, as part of a larger list through 25, while explicitly saying AlphaEvolve does not establish optimality. Thus those lower-bound numerical values should not be labeled new discoveries; formal checking or newly established upper bounds are separate contributions.

### A decisive limitation on the group-sum route

[József Solymosi, *The (7,4)-conjecture in finite groups*, 2013](https://arxiv.org/pdf/1309.0133), Theorem 5 (page 4 of the PDF).

For every positive density, every sufficiently large finite group has this property: a subset of `G × G` at that density contains a rectangle `(a,b),(a,c),(d,c),(d,b)` with `ab=dc`. This is exactly an opposite-edge color collision in product coloring. In particular, addition in finite fields or finite abelian groups of order comparable to the graph's vertex count cannot yield a positive-density family with every 4-cycle rainbow. The theorem covers nonabelian groups too when the two vertex parts determine the multiplication order. It does not by itself cover arbitrary quasigroups or embeddings in groups vastly larger than the graph.

The same paper's Claim 1 describes the familiar constant-factor reduction to linear systems. [Gishboliner–Shapira, *Constructing Dense Grid-Free Linear 3-Graphs*](https://people.math.ethz.ch/~lgishboli/grid_free.pdf), footnote 1, likewise gives a constant-factor greedy linearization. The specific sharp additive loss below was not located in targeted searches; that is insufficient evidence to claim publication novelty.

## Deduction A: exact two-part extraction for linear systems

Let `H` be a linear `(7,4)`-free 3-uniform hypergraph on `N` vertices, where `n <= N <= 2n`. Choose a uniformly random `n`-element graph-vertex set `S`; use its complement `T` as colors. Retain a triple precisely when it has two vertices in `S` and one in `T`, and project it to the pair in `S`, colored by the point in `T`.

Linearity makes this a simple well-defined colored graph. Every nonrainbow 4-cycle would lift to four distinct triples spanning at most seven points. Hence the projection is rainbow for `C4`. The palette has at most `n` colors. The retention probability is

`p(N,n) = C(n,2)*(N-n)/C(N,3)`.

Consequently

`M(n) >= ceil(p(N,n) * |H|)`.

In particular, for `N=2n`,

`M(n) >= ceil( [3n/(4(2n-1))] * g_linear(2n;7,4) )`.

The limiting retention factor is `3/8`, twice the `3/16` three-part factor displayed in the old path proof. This does not improve the asymptotic order or solve #810.

## Deduction B: sharp additive linearization

Use the convention that `(7,4)`-free means no four distinct triples have union of size at most seven. For `N>=7` this agrees with the usual formulation using seven-vertex subsets.

For `N>=5`, every such simple hypergraph contains a linear subhypergraph after deleting at most

`L(N) = 2*floor(N/5) + indicator(N mod 5 = 4)`

triples. This worst-case deletion bound is sharp. For `N=4` the sharp bound is two; for `N<=3` it is zero.

Proof:

1. Form the overlap graph whose vertices are triples, adjacent if they intersect in two points. A connected family of four triples has union of size at most six, so every component contains at most three triples.
2. Different nontrivial components have disjoint vertex supports. If two shared a point, choose a two-triple overlap inside each whose union contains that point. Their four distinct triples would have union of size at most seven.
3. A two-triple component spans four points. A three-triple component spans four or five points. If it spans four, no fourth triple can exist anywhere, because its union with that triple has size at most seven. This exceptional entire hypergraph needs at most two deletions.
4. Otherwise, let `a` count three-triple components and `b` count two-triple components. Retaining one triple per component deletes `2a+b`, while `5a+4b<=N`. For deletion count `D`, the cheapest possible cost in vertices is `5*floor(D/2)+4*(D mod 2)`; thus `D<=L(N)`. A path component on three triples can in fact retain two triples, but that optional improvement is unnecessary for the worst-case bound.
5. Sharpness: take disjoint three-edge common-pair sunflowers on five points (`abc,abd,abe`), with one two-edge diamond on four points when the remainder is four, and pad with isolated points. Each sunflower requires two deletions, each diamond one. These disjoint unions are `(7,4)`-free: distributions `3+1` and `2+2` of four selected triples span at least eight points, and other distributions span more.

Combining A and B gives the fully explicit bound

`M(n) >= ceil( [3n/(4(2n-1))] * (g_general(2n;7,4)-L(2n)) )`.

## Deduction C: project first, discard only duplicate projected edges

For general, possibly nonlinear `H` on `2n` vertices, `n>=3`, linearization before projection loses more than necessary. Choose a balanced split and project every retained triple. If a pair receives several colors, choose any one. The resulting simple graph is still rainbow for `C4`, since any four of its edges lift to four distinct original triples.

Write

`p = 3n/[4(2n-1)]`,

`q = n(n-1)/[4(2n-1)(2n-3)]`.

Here `q` is the probability that two fixed points land in `S` and two other fixed points in `T`. The probability for two fixed points in `S` and three others in `T` is `q/2`.

The overlap-component classification gives the expected collision losses:

| Component | Support size | Expected number of projected duplicates discarded |
| --- | ---: | ---: |
| Two triples sharing a pair | 4 | `q` |
| Three triples in an overlap path | 5 | `2q` |
| Three triples sharing one pair | 5 | `3q-q/2 = 5q/2` |
| Three triples on four points (exceptional whole hypergraph) | 4 | `3q` |

Nontrivial component supports are disjoint, so outside the exceptional case the total loss is at most `(2n)*q/2 = nq`. In the exceptional case the same bound holds because `n>=3`.

Therefore

`M(n) >= ceil( [3n/(4(2n-1))]*|H| - n²(n-1)/[4(2n-1)(2n-3)] )`.

This has additive correction asymptotic to `n/16`, as compared with `3n/10` from extraction after the coarse `2N/5` linearization estimate. The collision estimate is sharp as an averaging-loss estimate for unions of three-edge sunflowers when `2n` is divisible by five. It is not claimed to be sharp for `M(n)`.

Independent finite check performed in Python: enumeration of all connected three-triple configurations supported on five points found exactly the three profiles in the last three rows of the table. For two disjoint three-edge sunflowers on ten vertices, enumeration of all 252 balanced splits gave expected retained triples `5/2`, expected distinct projected edges `265/126`, and collision loss `25/63 = n*q`, exactly matching the estimate.

## Novelty and scope

The file's three stated ideas do not provide a new asymptotic result. Deductions A–C are concrete refinements derived and adversarially checked during this audit; their originality in the literature remains unestablished. They provide explicit constants and an exact deletion parameter, but no subquadratic upper bound, positive-density construction, or resolution of #810 or the `(7,4)` problem.
