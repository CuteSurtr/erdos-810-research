# What rainbow four-cycles say about the Erdős–Szekeres project

20 November 2026. The ES inputs come from the November 18 GitHub snapshot.
[Pinned ES revision](https://github.com/CuteSurtr/erdos-szekeres-lean/commit/0ad8f6ee17a7003671e1e79e9b2a120597179934)
The November 18 record gives $ES(8)\le307$ by a computer-assisted proof. The
repository lists $310$ as its Lean-checked octagon bound. The results below
concern polygon transversals, cup extensions and rainbow colorings.
[Octagon record](https://github.com/CuteSurtr/erdos-szekeres-lean/blob/0ad8f6ee17a7003671e1e79e9b2a120597179934/archive/es7-2026-10-19/results/ES307N20261118/README.md)

The 17-point integer octagon example also gives an explicit #810 coloring through a progression-free cyclic projection. Its graph has 598 vertices, 17 colors and 14,950 rainbow four-cycles. [Projection and graph construction](../neighborhood-packing/geometric-lower.md)

Exhausting all finite abelian quotients of these coordinates gives a smaller shift graph. The unique minimum kernel has index 285, giving 570 vertices, 4,845 edges, 17 colors and 11,400 rainbow four-cycles. Two separate enumerations agreed on every kernel through index 299. [Minimum quotient proof and checks](quotients.md)

Using the points and their consecutive connecting lines gives a second construction on the same coordinates. With 17 copies of each point and line there are 578 vertices, 9,826 edges and 1,965,200 rainbow four-cycles. For all incidence constructions on general-position points, with arbitrary multiplicities and a budget of $n$ colors, the maximum is $n^{3/2}/\sqrt2+O(n)$. [Sharp incidence bound and ES example](../neighborhood-packing/incidence.md)

## A sharp ten-point obstruction

**Theorem (computer-assisted).** Suppose a finite planar set in general
position requires at least three deletions to put its remaining points in convex
position. It contains a subset of at most **ten** points with the same property.
Ten is best possible. The upper-bound argument also applies to rank-three ES
signotopes, with the definitions of convexity and the five-point rule in the
repository. The lower bound is an integer-coordinate planar example.

Equivalently, for a set of at least ten points, **every ten points contain
a convex octagon if and only if deleting at most two points makes the entire
set convex**. To see the forward implication, extend any smaller obstruction
to ten points. Deleting two vertices from the larger set would also repair
the obstruction. The converse follows by restricting a convex subset.

This gives a positive answer to the transversal question recorded after
Theorem A in the November 18 notes, and a stronger conclusion when one allows
two extra points. Throughout, a gon denotes a convex $(n-1)$-subset of an
$n$-gon-free set. All polygons may contain other points of the ambient set.
[ES definitions, Lemma I, Theorem A and the transversal question](https://github.com/CuteSurtr/erdos-szekeres-lean/blob/0ad8f6ee17a7003671e1e79e9b2a120597179934/archive/es7-2026-10-19/results/DELTA3N20261113/attack20261115/THEORY_1118.md)

| Assumptions on $W$ | Conclusion |
|---|---|
| $n\ge6,\quad N=|W|\ge n+1$ | $N-n$ points suffice to meet every gon. |
| $n\ge9,\quad N=n+2$ | At least $N-10=n-8$ points belong to **every** gon. |
| $n\ge9,\quad N\ge n+2$ | $N-n-1$ points suffice to meet every gon. |
| $n=8,\quad N=10$ | Two points can be necessary, even with no five-cap. |

For the first row, choose any $n+1$ points. The repository's Lemma I supplies
one point common to their gons. Take it together with the $N-n-1$ points
outside. This also extends any preselected $N-n-1$ points by one. For the
second row, choose an inclusion-minimal subset $C$ of $W$ requiring three
deletions. Such a subset exists because $W$ has no convex $n$-set. The
theorem gives $|C|\le10$. Each gon omits three points, and all three must
come from $C$, since its intersection with the gon is convex. The third row
follows by first retaining any $n+2$ points. If there is no gon, the
intersection assertion is read vacuously.

### How the graph bound works

The input from the ES repository is Lemma I. Iterating it shows that any set
of $s\ge6$ points with no convex $(s-1)$-subset contains a six-point
set $A$ with no convex pentagon. In fact, for $s\ge7$, Lemma I with
$n=s-1$ lets us delete a point while preserving the property of requiring
at least two deletions. Iterate down to six. We also use two elementary
geometric facts. Every nonconvex set contains a nonconvex quadruple. Among
five points there are 0, 2 or 4 nonconvex quadruples (Fact F5 in the same
record).

1. Suppose $W$ is an inclusion-minimal obstruction to making a set convex
   by deleting at most two points, and $N=|W|\ge11$. Call a triple $T$
   an **omission** when $W\setminus T$ is convex. Every vertex occurs in
   at least one omission by minimality. Every nonconvex quadruple meets every
   omission. Every pair of vertices is disjoint from some nonconvex quadruple,
   since deleting that pair leaves a nonconvex set.
2. Let $A\subset W$ be a six-point set with no convex pentagon. An omission
   contains at least two of its vertices. For any $v\in W$, $W-v$ also
   requires at least two deletions and therefore has a six-point obstruction
   of its own. If an omission contains $v$, its other two vertices must
   belong to this latter obstruction. In the graph joining points that occur
   together in an omission, **every vertex has degree at most six**.
3. A fixed pair $a,b$ belongs to at most three omissions. Choose a
   nonconvex quadruple $Q$ in $W-\{a,b\}$. Every possible third member
   belongs to $Q$. Adjoin any other point of $W-\{a,b\}$ to $Q$.
   Fact F5 requires a second nonconvex quadruple there. The two quadruples
   have just three common vertices.
4. For every $x\notin A$, choose one omission containing $x$, necessarily
   $\{a,b,x\}$ with $a,b\in A$. Draw the edge $ab$ on six vertices
   and give it weight $w_{ab}$, the number of points assigned to it.
   Each weight is at most three. At each vertex, the number $d$ of incident
   positive-weight edges plus the sum $s$ of their weights is at most six.
   This counts distinct neighbors in step 2. If $d=1$, $s\le3$, and if
   $d\ge2$, $s\le4$. Hence at most $6\cdot4/2=12$ exterior vertices
   occur. It suffices to check $11\le N\le18$.

The transfer from the #810 work is the use of the graph of pairs occurring in
triples, followed by a count of its incidences. Here its degree bound comes
from the ES deletion lemma. This supplies a finite list of weighted graphs
on six vertices. Each graph leaves a small, checkable geometric question.

### Finite proof

For each graph give its exterior vertices consecutive labels within each
edge's weight. Exterior labels within a group are interchangeable. Initially
a potentially nonconvex quadruple must meet every assigned omission. Apply
the following necessary conditions.

- Every pair must be disjoint from some nonconvex quadruple. Every five
  vertices of the core must contain one.
- If only one quadruple in a five-set is still potentially nonconvex, mark
  it convex by F5. Repeat to stability.
- If some vertex is still in no chosen omission, try every triple through it
  containing at least two core vertices. In that branch discard any quadruple
  disjoint from the new omission and repeat. Each branch covers another
  vertex. Every realization would survive along at least one branch.

The exhaustive checker enumerated **123,079 labelled weight assignments**.
Permutations of the six core vertices leave the following 389 cases, all
excluded.

| $N$ | 11 | 12 | 13 | 14 | 15 | 16 | 17 | 18 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| Graphs up to relabeling | 37 | 66 | 86 | 89 | 66 | 32 | 10 | 3 |

A second calculation used direct Boolean clauses for quadruple status and
optional omitted triples. It reused the graph representatives and generated
its own clauses from the point labels. Of the 389 formulas, 264 have an
explicit empty clause and Kissat 4.0.4 returned UNSAT on the remaining 125.
Both methods accept the real ten-point control. The elementary branching
checker is a replay of the finite proof using only Python's standard library.
[Reproduce the finite proof](check_ten.py)

### Consequences for cups and weak $\Delta$

A weak $\Delta$ is a four-cap-free subset meeting every gon. A cup is an
increasing-$x$ chain whose triples all turn positively.

* For $n\ge9$, **any cup with at most $n+2$ points outside it extends to
  a weak $\Delta$ by adding at most one point**. Theorem A in the
  repository covers up to $n+1$. At $n+2$, choose a point common to
  every gon in the complement. Adding one point to a cup preserves
  four-cap-freeness because any four chosen points still contain three from
  the cup. Gons already meeting the cup stay hit.
* Consequently **weak $D(5,n)$ holds through $2n$ points for $n\ge9$**.
  In a set with no five-cap and no convex $n$-gon, an $(n-2)$-cup leaves
  at most $n+2$ outside. If there is no such cup, the project's Corollary SD
  already supplies a weak $\Delta$. The previous written A4 guarantee in
  the November 18 record was $2n-1$.
  [Corollary SD](https://github.com/CuteSurtr/erdos-szekeres-lean/blob/0ad8f6ee17a7003671e1e79e9b2a120597179934/archive/es7-2026-10-19/results/DELTA3N20261113/attack20261115/VERIFY_P1_CUPEXT.md)

**The octagon exception is real.** The 17 points in the linked file have
integer coordinates in $[0,80]^2$, no collinear triple, no five-cap and
no convex octagon. With vertices numbered from zero in increasing $x$,
the only seven-cup ending at the rightmost point is
$K=(0,1,2,3,8,15,16)$. The rightmost point also ends a four-cap.
The ten points outside $K$ contain ten convex heptagons with empty common
intersection. Every one-point extension therefore misses a heptagon. Of
the 45 exterior pairs, 25 meet every exterior heptagon and **17** also
preserve four-cap-freeness. For example $K\cup\{13,14\}$ works. The full
set has 55 convex heptagons. Exhausting all 1,024 extensions gives 17 of
size two, 34 of size three, 16 of size four, and 3 of size five, where size
counts the added points.
[Integer coordinates](octagon-anchor.json) · [Exact replay](check_obstructions.py)

The ten-point complement proves sharpness of the obstruction theorem. It
has no convex octagon. Removing any given point leaves a convex heptagon,
since one of its ten heptagons avoids that point. Thus every nine-point
deletion, and by heredity every proper subset, can be made convex with
at most two deletions. The check compares a monotone-chain convex hull
against point-in-triangle tests on all candidate 5-, 7- and 8-subsets of the
17-point example.

## A direct rainbow-coloring test on ES orientations

Erdős #810 asks whether a graph with $v$ vertices and at least
$\varepsilon v^2$ edges can use $v$ colors while giving four different colors
to every four-cycle, for a fixed $\varepsilon>0$ and all sufficiently large
$v$. [Problem statement](https://github.com/google-deepmind/formal-conjectures/issues/955)

Fix a middle point $p$. Put the points to its left in the rows and the
points to its right in the columns. Join $a$ to $b$ when $(a,p,b)$
is a cup. Its determinant has sign equal to that of
$\operatorname{slope}(p,b)-\operatorname{slope}(a,p)$. Thus the row
neighborhoods are nested. The cap relation is a second nested matrix.
These are Ferrers graphs.

For one such matrix, sort rows by decreasing length $r_1,\ldots,r_a$.
The exact minimum palette for making every four-cycle rainbow is
$$
 \max_{i\ge2,\ r_i\ge2} i r_i .
$$
If that index set is empty, one color suffices for any nonempty graph and an
empty graph uses zero. The formula also allows nonproper edge colorings.
For the lower bound, the first $i$ rows and $r_i$ columns form
a complete rectangle. Any two of its edges lie together on a four-cycle.
For the upper bound, omit edges outside all four-cycles. On a board with a
two-by-two rectangle, the remaining rows and columns are precisely those
of length or height at least two, restricted to each other. Assign cell
$(i,j)$ the integer interval $[i,h_j]$, where $h_j$ is its column
height in this restricted board. Cells on a four-cycle have intersecting
intervals. The number of intervals through row $k$ is $k$ times its
row length. Greedy interval coloring uses exactly the maximum of these
counts. Edges outside all four-cycles can reuse any color.

With $m\ge3$ points on each side, **at least one turn relation needs
$\lfloor(m+1)^2/4\rfloor$ colors**, and the guarantee is sharp. For
$m=2k+1$, examine the middle row. One sign contains a
$(k+1)\times(k+1)$ rectangle. For $m=2k$, row $k$ gives either a
$k\times(k+1)$ rectangle or a $(k+1)\times k$ rectangle of the opposite
sign. Alternating the left and right slopes gives the two staircase boards
and attains equality. Such an interleaving is realizable by placing points
on distinct lines through $p$, on the specified sides, avoiding the
finitely many earlier lines when choosing each point.

| GitHub point set | Points on each side of chosen pivot | Cup colors | Cap colors |
|---|---:|---:|---:|
| Real 17-point ROOT(7) example | 8 / 8 | **56** | 1 |
| 15-point cup-side counterexample | 7 / 7 | 10 | 28 |
| 12-point hexagon-saturated set | 5 / 6 | 15 | 12 |
| 16-point heptagon-saturated set | 7 / 8 | 12 | 32 |
| 27-point octagon-saturated set | 13 / 13 | 55 | 49 |

The 56 colors come from a complete $8\times7$ rectangle. At pivot 8, all
eight rows (points 0 through 7) see columns 9 through 15 in the cup graph.
Rows 2, 5 and 7 also see column 16. Keeping the full
cup relation therefore exceeds the #810 budget even when the pivot is
included in a 17-vertex budget. A smaller selection of turns would need its
own justification. The checker verified explicit colorings at every internal
pivot of these five sets and enumerated 17,576 Ferrers diagrams through
$8+8$. Each data record carries its immutable GitHub link.
[Inputs](examples.json) · [Coloring checker](check_pivots.py)

## Checks on the repository's existing instances

If a four-cap-free red set leaves exactly $n$ blue points, a six-point
blue subset with no convex pentagon certifies that red meets every gon.
Indeed, a convex $(n-1)$-subset would contain at least five of those six.
Conversely the iterated deletion lemma supplies such a six-point subset
whenever the $n$ blue points have no gon. On the real 17-point ROOT(7)
example this certifies all **72** five-cups starting at the leftmost point
and avoiding the rightmost point. It certifies all **855** eligible
(deletion, five-cup) pairs over the 17 single-point deletions of that set.
On the 15-point counterexample it covers 11 of 12 eligible four-cups.
Every weak extension of the remaining cup $(0,1,2,3)$ has size eight
and leaves seven blue points. This gives a limit on the fixed-size
certificate. [Exhaustive checker](check_delta.py) · [Original ROOT(7) coordinates](https://github.com/CuteSurtr/erdos-szekeres-lean/blob/0ad8f6ee17a7003671e1e79e9b2a120597179934/archive/es7-2026-10-19/results/DELTA3N20261113/attack20261115/ROOT7_M17_REALIZE.md)

The six exceptional vertices of the one-deletion lemma are also attainable
at every size $N\ge7$. Take $p_i=(i,2i^2+3\,\mathbf 1_{i\in\{1,4\}})$
for $0\le i<N$. The only negative triples are $(0,1,2)$ and
$(3,4,5)$. Indeed for $i<j<k$ with vertical offsets $u,v,w$ the
determinant is
$(k-i)(2(j-i)(k-j)-v)+(k-j)u+(j-i)w$.
Only a lifted middle point with both gaps one can make this negative. A
subset of at least four points containing either exceptional triple is
nonconvex because the middle of the triple lies in the triangle formed by
its endpoints and any fourth point. Avoiding both triples gives a cup. The maximum
convex subsets thus omit one point from each triple, and share exactly
$N-6$ vertices. Related disjoint-group constructions appear in the
property-testing literature. [Testing Geometric Properties](https://www.dcs.warwick.ac.uk/~czumaj/PUBLICATIONS/DRAFTS/ESA-2000-Convex-positions.pdf)

## Verification and relation to prior work

These commands reproduce the checks from this directory.

```sh
python3 check_ten.py --sat
python3 check_obstructions.py
python3 check_delta.py
python3 check_pivots.py
(cd ../hall-reduction && lake env lean -j1 -M1000 -DwarningAsError=true ../es-connection/PolygonTransversals.lean)
```

Omit `--sat` to run the finite proof using only Python. Lean checks the
general transversal deduction from the stated local deletion hypothesis,
the six-point certificate and its soundness, the incidence double count and
the determinant identity. The ten-point theorem uses the written reduction
and the finite checker. The cup consequence also uses Corollary SD. Historical
priority and refereeing remain open. The sharp ten-point statement is a
specialized tolerance bound for planar convex position. General tolerance
complexes and the Erdős–Gallai numbers supply relevant prior context.
[Lean file](PolygonTransversals.lean) · [Kim and Lew on tolerance complexes](https://link.springer.com/article/10.1007/s00493-023-00044-5)
