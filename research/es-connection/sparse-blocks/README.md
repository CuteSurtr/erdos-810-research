# Larger graphs from the 17 ES coordinates

Omitting two aligned matchings from each 28-by-28 block gives **940,576 edges on 4,256 vertices** in 4,254 colors. The graph has **12,012,770,672 rainbow four-cycles**. For the 17-point base, the largest copy count with two common omitted matchings per block is either **28 or 29**. Each row of the table uses the same graph on 152 base vertices, reconstructed from the original integer points. With additional omissions the construction gives **26,542,848 edges on 29,184 vertices**. [Original coordinates](../octagon-anchor.json) · [Complete table](counts.tsv) · [Local color classes](blocks.json) · [One omitted matching](../crown-lifts.md)

| Copies per vertex | Omissions per block row | Vertices | Edges | Colors |
| ---: | ---: | ---: | ---: | ---: |
| 28 | 2 | 4,256 | 940,576 | 4,254 |
| 40 | 6 | 6,080 | 1,757,120 | 5,890 |
| 64 | 13 | 9,728 | 4,217,088 | 9,424 |
| 128 | 42 | 19,456 | 14,222,336 | 18,848 |
| 192 | 85 | 29,184 | 26,542,848 | 28,272 |

## Why 30 copies cannot use two aligned matchings

Assume $t\ge6$. Each block omits the same 2-regular bipartite graph of holes on its copy indices. Two edges of one color in the star of a base row must have distinct lifted row and column endpoints, since each wedge extends to a four-cycle. Choose one missing cross cell to orient each pair $i,j$ of matching edges $i\to j$. A lifted column misses at most two rows in the base-row cluster, so every index has indegree at most two. The tournament has at most five vertices.

Call an edge near if its local copy pair is joined by a three-step path of holes. If a transitive triple has middle index $i$, the three missing cross cells give such a path at $i$. The alignment of the omitted matchings lets us project all three steps to the same local hole graph. With four edges in the class, at least two are near by the marked-triple argument. With five edges, all indegrees and outdegrees equal two. Every index $i$ is the middle of a transitive triple. Otherwise each of its two outneighbors beats both of its two inneighbors, leaving neither outneighbor room to beat the other. Hence all five edges are near. In every class of size $k$, its excess above three is at most half its count of near edges. [General three-step lemma](../sparse-holes/README.md) · [Marked-triple Lean proof](../../hall-reduction/SparseHoleColors.lean)

In the local hole graph each row begins at most two nonbacktracking walks of length three, so at most $2t$ occupied cells per block are near. If the base row has degree $d$ and the entire base has $n$ vertices, sum over at most $nt$ color classes to obtain
$$
d\,t(t-2)\le3nt+\tfrac12(2dt).
$$
For $d=17,n=152$, this gives $t\le3+456/17<30$. The argument allows any common omitted 2-regular graph and arbitrary colorings of the full lift.

## Certificates and larger blocks

For 28 copies, rows and columns are indexed by $\mathbb Z_{28}$ and the omitted column-minus-row differences are 0 and 1. The local certificate partitions the 728 occupied cells into 238 classes. It consists of 17 seeds, each translated by all 14 even shifts of the row and column indices. One seed has four edges and the other 16 each have three. A 238-fold coloring of the base conflict graph uses 4,254 labels. Applying each base cell's assigned labels to its local classes yields the stated graph. [28-copy base multicoloring](outer-28.txt) · [General multicoloring argument](../crown-lifts.md#coloring-the-local-blocks)

The other recorded copy counts are multiples of eight. The local classes use eight seeds, now translated by all $t$ shifts, for $8t$ local labels. A copy count of $t$ uses $t/8$ repetitions of the previously certified 64-fold base coloring. This supplies at least $8t$ labels at each base cell, using at most $1,178(t/8)<152t$ overall. The outer and local coloring verifiers check every assigned class. For $h$ omissions the graph has $1,292t(t-h)$ edges. The generator counts four-cycles by summing the number of pairs of common neighbors over every pair of rows, using the exact intersections among local rows and among base rows. [64-fold base certificate](../balanced-orbits.txt) · [C++ verifier](../crown_lift.cpp) · [Recipe loader](recipe.py)

## Reproduction

From this directory, choose a copy count in the table. The C++ program emits the graph in sorted vertex order. The C verifier reads only that edge stream. It stores one adjacency bit per possible bipartite edge and groups the edges of each color in temporary files. It checks endpoint collisions and opposite-color collisions and computes the cycle count directly from row intersections. At 28 copies a second C implementation using two-edge paths gave the same result. The expanded graph SHA-256 is `7dd03e7687fa9438f7a0240a95d45765d7da735a255c38203c6535deccff956e`. [Streaming bipartite verifier](audit_bipartite.c) · [Two-edge-path verifier](../../../bruteforce/results/2026-11-21-0600/large/audit.c)

```sh
c++ -O3 -std=c++17 ../crown_lift.cpp -o /tmp/810-es-block
cc -O3 -std=c11 audit_bipartite.c -o /tmp/810-es-verify
python3 -c 'import json; print(*(f"{x} {y}" for x,y in json.load(open("../octagon-anchor.json"))["points"]), sep="\n")' > /tmp/810-es-points
python3 recipe.py 28 block > /tmp/810-es-local
python3 recipe.py 28 base > /tmp/810-es-base
/tmp/810-es-block 28 /tmp/810-es-base --block /tmp/810-es-local < /tmp/810-es-points
/tmp/810-es-block 28 /tmp/810-es-base --block /tmp/810-es-local --emit < /tmp/810-es-points | /tmp/810-es-verify
```
