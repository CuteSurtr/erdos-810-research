# Larger graphs from the 17 ES coordinates

The 17 Erdős–Szekeres coordinates give a graph with **27,287,040 edges on 29,184 vertices**, using 27,572 colors. All **3,909,936,643,584 four-cycles** are rainbow. The construction replaces each vertex of the same 152-vertex base with 192 copies. With just three cyclic omissions per block row it gives **31 copies** and **1,121,456 edges**. Across the twenty constructions below, an independent C program checked every expanded edge list and computed its four-cycle count. [Original coordinates](../octagon-anchor.json) · [Complete counts and expanded SHA-256 digests](counts.tsv) · [Local color classes](blocks.json) · [One omitted matching](../crown-lifts.md)

| Copies per vertex | Omissions per block row | Vertices | Edges | Colors |
| ---: | ---: | ---: | ---: | ---: |
| 28 | 2 | 4,256 | 940,576 | 4,254 |
| 30 | 3 | 4,560 | 1,046,520 | 4,473 |
| 31 | 3 | 4,712 | 1,121,456 | 4,597 |
| 38 | 4 | 5,776 | 1,669,264 | 5,651 |
| 64 | 11 | 9,728 | 4,382,464 | 9,270 |
| 128 | 39 | 19,456 | 14,718,464 | 18,500 |
| 192 | 82 | 29,184 | 27,287,040 | 27,572 |

## Why 30 copies cannot use two aligned matchings

Assume $t\ge6$. Each block omits the same 2-regular bipartite graph of holes on its copy indices. Two edges of one color in the star of a base row must have distinct lifted row and column endpoints, since each wedge extends to a four-cycle. Choose one missing cross cell to orient each pair $i,j$ of matching edges $i\to j$. A lifted column misses at most two rows in the base-row cluster, so every index has indegree at most two. The tournament has at most five vertices.

Call an edge near if its local copy pair is joined by a three-step path of holes. If a transitive triple has middle index $i$, the three missing cross cells give such a path at $i$. The alignment of the omitted matchings lets us project all three steps to the same local hole graph. With four edges in the class, at least two are near by the marked-triple argument. With five edges, all indegrees and outdegrees equal two. Every index $i$ is the middle of a transitive triple. Otherwise each of its two outneighbors beats both of its two inneighbors, leaving neither outneighbor room to beat the other. Hence all five edges are near. In every class of size $k$, its excess above three is at most half its count of near edges. [General three-step lemma](../sparse-holes/README.md) · [Marked-triple Lean proof](../../hall-reduction/SparseHoleColors.lean)

In the local hole graph each row begins at most two nonbacktracking walks of length three, so at most $2t$ occupied cells per block are near. If the base row has degree $d$ and the entire base has $n$ vertices, sum over at most $nt$ color classes to obtain
$$
d\,t(t-2)\le3nt+\tfrac12(2dt).
$$
For $d=17,n=152$, this gives $t\le3+456/17<30$. The argument allows any common omitted 2-regular graph and arbitrary colorings of the full lift.

## The cost of three or more common omissions

Let every block omit the same $h$-regular board $D$, and take the star of a base row of degree $d$. For $t\ge2h+2$ every incident pair extends to a rectangle within the star. Each color therefore has distinct projected row indices. Its projected column indices are also distinct. If two edges in different blocks used the same local column, both crossed cells would be occupied by alignment and would complete a repeated-color rectangle (or the two original edges already share a row).

The local conflict graph has one vertex per occupied cell, with conflicts for shared endpoints or opposite corners of an occupied rectangle. The conflict graph in the aligned star replaces each local vertex by a $d$-clique and each local conflict by all edges between the two cliques. This follows from the projected-column observation and the fact that a crossed cell is occupied in every block or absent in every block. Thus a coloring of the star is exactly a $d$-fold coloring of this local conflict graph. The full lift supplies a palette of at most $nt$ when its base has $n$ vertices.

Orient each pair of edges of a color toward a missing cross. Each transitive triple gives a three-step path of local holes. Record the base block of the middle edge as well. These data recover its actual middle edge and color. The other two edges are uniquely identified in that color by their local row and column. Consequently all $dt(t-h)$ edges of the star have at most $dth(h-1)^2$ such triples combined. Applying the two tournament estimates gives
$$
\frac{d(t-h)}{n}\le 2+\sqrt{1+\frac{8h(h-1)^2}{t-h}},
\qquad t\le h+\frac{3n}{d}+\frac{h(h-1)^2}{2}.
$$
For the ES base $d=17,n=152$, three arbitrary common omitted matchings give $t\le35$. The 31-copy construction supplies the lower bound. More generally, for any unbounded sequence of these aligned ES lifts the limiting lower density of omissions is at least $17^{2/3}/(2\cdot152^{2/3}+17^{2/3})\approx0.1040$. To see this, apply the first bound along a subsequence with $h/t\to\alpha<1/2$, divide by $t$ and take the limit. Limits of at least one half already satisfy the conclusion. [General path inequalities](../sparse-holes/README.md#counting-transitive-triples-across-all-colors) · [Lean check of aligned path recovery](../../hall-reduction/SparseHoleColors.lean)

When the three omitted differences are cyclic, the maximum lies between **31 and 34 copies**. With the further requirement of at most $8t$ local colors, the exact largest copy count is **31**. To prove the upper bounds, price each occupied difference $j$ by a nonnegative integer $w_j$. If every compatible local matching costs at most $L$, a local coloring needs at least $t\sum_jw_j/L$ colors. In the star, each local cell occurs $d$ times, so $d\sum_jw_j\le nL$ is necessary.

We enumerate three-hole sets up to addition of a common offset and multiplication by a unit modulo $t$. At $t=35$ the twelve inequivalent hole sets all have certificates with $\sum_jw_j/L\ge55/6>152/17$. At $t=32$ and $33$ the corresponding minima across the supplied certificates are $49/6$ and $17/2$, both strictly above eight. For $t\ge34$, the local inequality $t(t-3)\le3(8t)+6t$ already excludes $8t$ local colors. The 31-copy witness uses exactly 248 local colors and the omitted differences $0,1,5$. The independent C++ checker translates one edge of each possible class into row zero, then tries all other rows in increasing order and every column compatible with the earlier choices. It verifies the price ceiling and the coverage of all 42 hole shapes for the three stated orders. [Integer price certificates](three-hole-prices.tsv) · [Exhaustive matching check](cyclic_prices.cpp)

## Certificates and larger blocks

For 28 copies, rows and columns are indexed by $\mathbb Z_{28}$ and the omitted column-minus-row differences are 0 and 1. The local certificate partitions the 728 occupied cells into 238 classes. It consists of 17 seeds, each translated by all 14 even shifts of the row and column indices. One seed has four edges and the other 16 each have three. A 238-fold coloring of the base conflict graph uses 4,254 labels. Applying each base cell's assigned labels to its local classes yields the stated graph. [28-copy base multicoloring](outer-28.txt) · [General multicoloring argument](../crown-lifts.md#coloring-the-local-blocks)

The other nineteen constructions use eight seeds, each translated by all $t$ shifts, for $8t$ local labels. For each copy count we assemble its outer cover from certified 50-, 57-, 64-, 200-, 217- and 238-fold base covers. The first three are prefixes of the balanced cover. The recipe lists the chosen components. Taking disjoint palettes adds their guaranteed cover multiplicities, and assigning just the required labels at each cell may leave some labels unused. The outer and local verifiers check every assignment. For $h$ omissions the graph has $1,292t(t-h)$ edges. The generator counts four-cycles from exact intersections among local rows and among base rows. [Base cover seeds](../balanced-orbits.txt) · [C++ verifier](../crown_lift.cpp) · [Recipe loader](recipe.py)

## Reproduction

From this directory, choose a copy count in the table. The C++ program emits the graph in sorted vertex order. The C verifier reads only that edge stream. It stores one adjacency bit per possible bipartite edge and groups the edges of each color in temporary files. It checks endpoint collisions and opposite-color collisions and computes the cycle count directly from row intersections. At 28 copies a second C implementation using two-edge paths gave the same result. The expanded graph SHA-256 is `7dd03e7687fa9438f7a0240a95d45765d7da735a255c38203c6535deccff956e`. [Streaming bipartite verifier](audit_bipartite.c) · [Two-edge-path verifier](../../../bruteforce/results/2026-11-21-0600/large/audit.c)

```sh
c++ -O3 -std=c++17 ../crown_lift.cpp -o /tmp/810-es-block
cc -O3 -std=c11 audit_bipartite.c -o /tmp/810-es-verify
c++ -O3 -std=c++17 cyclic_prices.cpp -o /tmp/810-es-prices
/tmp/810-es-prices < three-hole-prices.tsv
python3 -c 'import json; print(*(f"{x} {y}" for x,y in json.load(open("../octagon-anchor.json"))["points"]), sep="\n")' > /tmp/810-es-points
python3 recipe.py 28 block > /tmp/810-es-local
python3 recipe.py 28 base > /tmp/810-es-base
/tmp/810-es-block 28 /tmp/810-es-base --block /tmp/810-es-local < /tmp/810-es-points
/tmp/810-es-block 28 /tmp/810-es-base --block /tmp/810-es-local --emit < /tmp/810-es-points | /tmp/810-es-verify
```
