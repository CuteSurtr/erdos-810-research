# Diamond recoloring: independent audit and a simpler transfer

6 November 2026. Written mathematical proof and finite stress checks; not
a Lean certificate. This verifies the 21 October diamond recoloring argument
and removes its dependence on extremal hypergraph replacement lemmas.
Historical novelty is unestablished; this does not settle Erdős #810.

Let H be a simple triple system on n vertices in which any four distinct
triples have union of size at least eight. Let M(n) be the maximum number
of edges in an n-vertex graph with at most n edge colors and every C4 rainbow.
For n≥7 this triple-system convention agrees with forbidding four triples
inside any seven-element vertex set.

**Result.** The bound

\[
M(n)\ge 3g(n;7,4)-\lfloor n/4\rfloor\qquad(n\ge7)
\]

passes the audit. More explicitly, let a be the number of isolated
three-triple/five-point blocks and b the number of remaining ordinary
two-triple diamonds. Except when H consists of only three triples on four
points, the following direct constructions use the same n vertices/colors:

* If at least one triple lies outside the isolated blocks: **3|H|−b edges**.
* If H consists only of a≥1 isolated blocks: **3|H|−2 edges**.
* Before attaching blocks, the local construction has **3|H|−b−2a edges**.

The attachment step is the new simplification relative to the archived
argument. No assertion about the structure of an extremizer is needed.

## Decomposition, including a subtle implementation point

Three triples spanning five points form an isolated block: any fourth
triple meeting their support would make four triples span at most seven.
Three triples spanning four points must be the entire family. Distinct
five-point blocks have disjoint supports.

Remove all five-point blocks. A pair of triples abc, abd sharing two
vertices has support S={a,b,c,d}. Every other triple meets S in at most
one point, since otherwise it would form a removed three-on-five block
(or the exceptional three-on-four family). Two different such diamonds
have disjoint supports: otherwise their four triples span at most seven.
All other triples have pairwise intersections of size at most one.

A five-point block need not be a single component under pair-overlap:
abc, abd, cde is an example. The proof and checker detect all three-triple
families spanning five points, not merely overlap components.

For an ordinary diamond S, the two outside vertices of each external
triple meeting S are disjoint from the outside pair of every other such
triple. Otherwise those two external triples together with the diamond
span at most seven points. Hence **each vertex outside S has at most one
neighbor in S in the entire two-shadow**.

## Recolor the diamond safely

Initially retain the full two-shadow and color each pair by the omitted
vertex of any selected containing triple. On every ordinary diamond
abc, abd replace its five colors by

\[
ab:a,\quad ac:a,\quad ad:b,\quad bc:c,\quad bd:d.
\]

The unique C4 inside the diamond uses colors a,c,d,b, all different.
Only labels belonging to S are used.

Any C4 with an internal S edge is either wholly in S or has the form
u-v-x-y-u with u,v∈S and x,y outside S. This follows from the unique
neighbor property above. In the mixed case, the omitted colors on vx
and yu lie outside S. If an unchanged edge xy had omitted color s∈S,
its supporting triple sxy would force the unique S-neighbor of both x
and y to equal s. Those neighbors are v and u respectively, impossible.
Thus the changed internal color cannot collide with an unchanged color.
Changed colors from different diamonds belong to disjoint supports.

It remains to exclude a collision between two unchanged edges. The
following elementary localization lemma supplies this check. If an
original omitted-point-colored C4 is not rainbow, its four selected
supporting triples cannot all be distinct, since their union would lie
inside the four cycle vertices and at most three colors. Two repeated
triples must support adjacent edges, say ab and bc select abc. If the
other triples are cdx and day, the only possible color equalities are
x=a, y=c, or x=y. Either the cycle lies inside one diamond, or its
distinct supporting triples number three and span at most five points.
The first case is repaired above and the second is an isolated block
(or the explicitly separated exceptional family).

## Replace isolated blocks and recover their loss

Replace each isolated five-point block, on labels 0,1,2,3,4, by the graph

\[
01:4,\quad02:3,\quad03:2,\quad04:0,\quad12:1,\quad14:4,\quad23:0.
\]

Its only C4s have vertex orders 0-1-2-3 and 0-2-1-4, and both are
rainbow. The pair 1,3 is absent. Blocks are isolated from the remainder,
so at this point the count is 3|H|−b−2a.

**Attachment lemma.** Let K and L be vertex-disjoint rainbow-C4 colored
graphs. Suppose u,v are distinct vertices of K, and x,y are nonadjacent
vertices of L. Add the matching edges ux,vy, assigning either any
available color. No new C4 is created. Indeed a cycle crossing the cut
must use both new edges; a C4 would then require both uv and xy, and xy
is absent. The preexisting C4s and their colors are unchanged.

If there is a triple outside the isolated blocks, its shadow supplies
at least two vertices. Attach each block by the lemma, using its pair
1,3, recovering two edges per block. The resulting count is 3|H|−b.
If the family consists solely of blocks, start with one block and attach
the others, giving 7+9(a−1)=3|H|−2. Repeated attachment is valid by
induction; the lemma applies to the whole graph already constructed.

## Uniform consequence and small exceptions

Ordinary diamond supports are disjoint, so b≤floor(n/4). If an input H
has at least four triples and only isolated blocks, then it has at least
two blocks and n≥10, so the loss two is at most floor(n/4). All other
inputs with at least four triples use the first bound above.

For |H|≤3 and n≥7, three triangles sharing exactly one common vertex
give nine graph edges on seven vertices and no C4. Pad with isolated
vertices and use one color. This gives at least 3|H| edges and handles
the exceptional three-on-four family as well. Taking an extremal H
proves the stated inequality without invoking either archived extremal
replacement lemma.

## Verification and limitations

The independent script `check_diamond_recoloring.py` checks decomposition,
the exact edge count, palette size, and every C4 after recoloring and
attachment. It exhausts all families of one to three triples on three
through seven vertices, excludes and counts the exceptional three-on-four
case, tests 120 seeded greedy families on 8,9,10,12,15,18 vertices, and
checks 18 explicit mixtures of isolated blocks, diamonds, and singleton triples.
Results are in `diamond-recoloring-checks.json`. These finite checks
support but do not replace the proof.

The local loss one per isolated diamond cannot be removed by recoloring
its five-edge shadow alone: that shadow has only five edges. This does
not prove a necessary global loss. No O(1)-error comparison, reverse
hypergraph reduction, or unrestricted density bound is established here.

Sources audited: the repository's `research/local-progress/research-2026-10-21/
repo-and-reduction-audit.md` and `research/local-progress/research-2026-10-14/
shadow-extraction-proof.txt`. The older overlap decomposition is credited
there to Füredi (2012); no historical-priority claim is made here.
