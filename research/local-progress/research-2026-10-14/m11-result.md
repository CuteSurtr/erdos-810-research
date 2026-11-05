# Computational refinement: M(11) = 34

The original repository contains a checked 34-edge lower-bound certificate on eleven
vertices. This investigation supplies an exhaustive computational upper bound at
35 edges. It does not yet supply a Lean proof, and literature novelty is unverified.

The extremal function here permits general edge colorings, exactly as in Erdős
#810. The supplied order-11 lower witness is not proper: edges (0,2) and (2,7)
share color 10. No claim about the exact *proper-coloring* extremum at order eleven
is made; deleting either of those edges gives a proper 33-edge lower witness.

`exhaustive_pruned.cpp` exhausts all representatives from the canonical labeling
scheme justified in `../audit-2026-10-14/finite-results.md`. It adds one sound prune:
if the current partial graph already has a conflict K12, every completion has one,
because adding graph edges can only add four-cycles and conflicts.

The order-11 run completes in about 118 seconds on the audit host. It visits
41,196,311 row states and excludes 20,408,270 partial subtrees by conflict K12.
It reaches 4,318 complete graphs: 4,282 contain a conflict K12, while the remaining
36 have conflict independence number exactly three. A coloring with eleven colors
could cover at most 33 edges in those residual graphs, fewer than their 35 edges.
Restricting any larger graph to 35 edges proves the full upper bound.

The first run also checked the 36 residuals by exact coloring search. A second run
in `exhaustive_residuals.cpp` saves every residual graph mask; the independent Python
checker `verify_n11_residuals.py` constructs conflicts by enumerating the three
cycles on each four-vertex set and checks all 52,360 four-edge subsets of each
residual. Thus the upper-bound conclusion does not need to trust the coloring
backtracker. Logs are `exhaustive_pruned_n11_m35.log` and `n11_residuals.log`.

## A more precise finite classification

Up to isomorphism, exactly two 35-edge graphs on eleven vertices have no conflict
K12. Both have degree sequence (7,7,7,7,7,6,6,6,6,6,5), and 35 triangles. They have
128 and 130 four-cycles respectively, so are not isomorphic. Explicit isomorphisms
from the 36 representatives to these two graphs are in
`n11_residual_isomorphisms.json`, and independently checked by the Python verifier.

Both graphs belong to this small family. Take disjoint sets
A={a0,...,a4}, B={b0,...,b4}, and one vertex z. Put all edges ai—bj except when i=j,
place a five-cycle on A and a five-cycle on B, and join z to every vertex of A.
The two exceptional graphs differ only in the relative placement of the two
five-cycles: after matching ai with bi, their two cyclic edge sets either coincide
or share exactly three edges. These give the 130-cycle and 128-cycle types,
respectively. Labeled representatives are stored in the JSON. The 130-cycle type
is obtained from the complement of the pentagonal prism by adding a vertex joined
to one of the two five-vertex layers.

For clarity, fix the A-cycle as (0,1,2,3,4). The 130-cycle type takes the same
B-cycle; the 128-cycle type can take (0,1,2,4,3). Enumeration of all twelve
undirected B-cycles confirms that the other possible overlap sizes, zero and two,
already give a conflict K12; see `n11_family_alignment.json`.

The following direct argument proves that *every* graph in this family, regardless
of the relative placement of the two five-cycles, has conflict independence number
at most three. This provides a human-checkable explanation of the residual
obstruction.

## Uniform proof of the residual obstruction

Every two distinct vertices of this graph have at least two common neighbors:
two A vertices share at least three B neighbors; two B vertices share at least
three A neighbors; z shares two neighbors with each A vertex and four with each
B vertex; and ai,bj share at least one neighbor in each layer. Therefore two
incident graph edges always lie on a four-cycle. An independent set in the
conflict graph must consequently be a matching in the original graph.

Call an edge within A or B internal and an edge ai—bj crossing. Any internal
A edge and internal B edge conflict, since the cross graph between their two pairs
of endpoints always has a perfect matching. Thus an independent set cannot contain
internal edges from both layers.

For a matching of crossing edges, write ai—bj as the directed pair i→j.
Compatibility of i→j and k→l requires i=l or k=j: otherwise the four crossing
edges form a four-cycle. Since both the sources and targets are distinct, any
compatible triple of crossing edges forms a directed three-cycle, and no fourth
crossing edge is compatible with it.

First suppose an independent set does not use z. If it contains two internal
edges from one layer, those cover four vertices of that layer, leaving room for
at most one crossing edge. If it contains one internal edge and three crossing
edges, the latter form a directed three-cycle on a three-element index set T.
Both endpoints of the internal edge have indices outside T. Compatibility would
then require all three corresponding vertices of its own layer to be adjacent
to neither endpoint of that internal edge. In a five-cycle, only one vertex is
adjacent to neither endpoint of a given edge. This is impossible. The case with
no internal edges was already settled by the crossing-edge argument.

Now suppose the independent set contains z—ax. Compatibility forces every crossing
edge to end at bx, so there is at most one crossing edge. Among internal A edges,
only the unique edge between the two nonneighbors of ax in its five-cycle is
compatible with z—ax. Hence a four-edge independent set would have to consist of
z—ax, a crossing edge ai—bx, and two disjoint internal B edges. Those two B edges
must perfectly match the four vertices of the B-cycle other than bx. Deleting bx
leaves a four-vertex path, whose unique perfect matching pairs each neighbor of bx
with a different nonneighbor. Compatibility with ai—bx would require both of
those different nonneighbors to be bi, an impossibility.

Thus every independent set has at most three edges. Since 35 > 11 times 3, eleven
colors cannot make all four-cycles rainbow.

## Reproduction

```sh
c++ -O3 -std=c++17 exhaustive_residuals.cpp -o exhaustive_residuals
./exhaustive_residuals 11 35 > n11_residuals.log
python3 verify_n11_residuals.py
```

The original non-pruned order-10 calculation was also recovered by the new prune
in under one second, supplying a regression check against the separately verified
M(10)=30 result. On this host, compilation uses the explicitly selected macOS26.5
SDK because the default SDK and linker do not match.
