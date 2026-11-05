# The two extremal graphs at order ten

Exhaustive computation gives this sharper statement than M(10)=30:

> If a graph G has ten vertices and thirty edges, and its four-cycle conflict
> graph Q(G) has no K11, then G is isomorphic either to the complement of the
> pentagonal prism or to the complement of the ten-vertex Möbius ladder.

Both graphs have rainbow-four-cycle colorings with ten colors. Therefore these are
exactly the two underlying graph isomorphism types attaining M(10)=30. The claim
classifies underlying graphs, not all possible colorings.

This is an external computational classification, not a Lean theorem; publication
novelty has not been established.

`classify_n10_extremal.cpp` uses the audited canonical labeling and partial-conflict
clique prune. In 1.637 seconds it visits 608,498 row states and excludes 316,853
partial subtrees by conflict K11. Only 288 complete graphs remain, all with maximum
degree six, hence all six-regular. Every remaining graph has a valid ten-coloring;
there are no complete-graph clique or coloring exclusions. There are 144 surviving
representatives of each of the two isomorphism types.

The positive colorings, explicit isomorphism maps, and recognizable descriptions of
both complements are saved in `n10_extremal_isomorphisms.json`. Every positive
coloring and every isomorphism is independently verified by
`verify_n10_classification.py`, using direct enumeration of all three cycles on
each four-vertex set. Both graphs have 95 four-cycles and color classes of size three.
The two types are nonisomorphic: the pentagonal prism contains a five-cycle, whereas
the ten-vertex Möbius ladder is bipartite.

Here the ten-vertex Möbius ladder is the graph on cyclically ordered vertices
v0,...,v9 with the ten cycle edges and the five additional edges vi—v(i+5),
for 0 <= i < 5. Its complement is the second extremal graph.

The output log is `n10_extremal_classification.log`. Its final `VERIFIED` marker
means that the enumeration completed; the preceding 288 `COLORABLE` records
are positive certificates, not an unsatisfiability claim.

```sh
c++ -O3 -std=c++17 classify_n10_extremal.cpp -o classify_n10_extremal
./classify_n10_extremal 10 30 > n10_extremal_classification.log
python3 verify_n10_classification.py
```
