# Larger graphs from the 17 ES coordinates

The 17 Erdős–Szekeres coordinates give a graph with **27,287,040 edges on 29,184 vertices**, using 27,572 colors. All **3,909,936,643,584 four-cycles** are rainbow. The construction replaces each vertex of the same 152-vertex base with 192 copies. With just three cyclic omissions per block row it gives **33 copies** and **1,279,080 edges**. Across the twenty-one constructions in the archive, an independent C program checked every expanded edge list and computed its four-cycle count. [Original coordinates](../octagon-anchor.json) · [Complete counts and expanded SHA-256 digests](counts.tsv) · [Local color classes](blocks.json) · [One omitted matching](../crown-lifts.md)

| Copies per vertex | Omissions per block row | Vertices | Edges | Colors |
| ---: | ---: | ---: | ---: | ---: |
| 28 | 2 | 4,256 | 940,576 | 4,254 |
| 30 | 3 | 4,560 | 1,046,520 | 4,473 |
| 31 | 3 | 4,712 | 1,121,456 | 4,597 |
| 32 | 3 | 4,864 | 1,198,976 | 4,712 |
| 33 | 3 | 5,016 | 1,279,080 | 5,016 |
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

More generally the full conflict graph of the lift is the **strong product** $Q\boxtimes C_B$, where $Q$ is the conflict graph of the base edges and $C_B$ is that of the occupied local cells. In both factors, sharing an endpoint is a conflict. A pair of distinct positions is equal or conflicting in a factor exactly when both crossed cells are present, with coinciding rows and columns allowed in this test. In the aligned lift the two crosses are both present exactly when this holds in both factors. Distinct lifted edges sharing an endpoint also lie in a four-cycle by the density assumption. This proves the product identity, including pairs that share one or both projected coordinates. Arbitrary colorings of this strong product give the full set of available colorings of the lift.

Orient each pair of edges of a color toward a missing cross. Each transitive triple gives a three-step path of local holes. Record the base block of the middle edge as well. These data recover its actual middle edge and color. The other two edges are uniquely identified in that color by their local row and column. Consequently all $dt(t-h)$ edges of the star have at most $dth(h-1)^2$ such triples combined. Applying the two tournament estimates gives
$$
\frac{d(t-h)}{n}\le 2+\sqrt{1+\frac{8h(h-1)^2}{t-h}},
\qquad t\le h+\frac{3n}{d}+\frac{h(h-1)^2}{2}.
$$
For the ES base $d=17,n=152$, three arbitrary common omitted matchings give $t\le35$. The 33-copy construction supplies the lower bound. More generally, for any unbounded sequence of these aligned ES lifts the limiting lower density of omissions is at least $17^{2/3}/(2\cdot152^{2/3}+17^{2/3})\approx0.1040$. To see this, apply the first bound along a subsequence with $h/t\to\alpha<1/2$, divide by $t$ and take the limit. Limits of at least one half already satisfy the conclusion. [General path inequalities](../sparse-holes/README.md#counting-transitive-triples-across-all-colors) · [Lean check of aligned path recovery](../../hall-reduction/SparseHoleColors.lean)

For any finite abelian group of copy indices with three common omitted differences, the maximum lies between **33 and 34 copies**. The 33-copy witness uses cyclic indices. With the further requirement of at most $8t$ local colors, the exact largest copy count is **31**. To prove the upper bounds, price each occupied difference $j$ by a nonnegative integer $w_j$. If every compatible local matching costs at most $L$, a local coloring needs at least $t\sum_jw_j/L$ colors. In the star, each local cell occurs $d$ times, so $d\sum_jw_j\le nL$ is necessary.

The abelian difference-price theorem assigns $w_s=\max(0,2-m_s)$, where $m_s$ counts representations $s=a-b+c$ in omitted differences up to exchanging the outer entries. Each color costs at most six and $\sum w_s\ge2t-15$. The aligned ES star consequently requires $17(2t-15)\le6\cdot152$, which gives $t\le34$. The local $8t$ requirement gives $2t-15\le48$ and $t\le31$. Explicit cyclic boards attain the general palette lower bound at infinitely many orders. [Proof for all finite abelian groups](../sparse-holes/README.md#a-price-bound-for-holes-given-by-group-differences) · [Sharp infinite family](../sparse-holes/README.md#exactly-three-cyclic-holes-on-infinitely-many-orders)

As an independent finite check, we enumerate three-hole sets up to addition of a common offset and multiplication by a unit modulo $t$. At $t=35$ the twelve inequivalent hole sets all have certificates with $\sum_jw_j/L\ge55/6>152/17$. At $t=32$ and $33$ the corresponding minima across the supplied certificates are $49/6$ and $17/2$, both strictly above eight. For $t\ge34$, the local inequality $t(t-3)\le3(8t)+6t$ already excludes $8t$ local colors. The 31-copy witness uses exactly 248 local colors and the omitted differences $0,1,5$. Across orders $31\le t\le35$, the certificates prove the uniform price bound $\sum_jw_j/L\ge(2t-15)/6$. The least possible local palette over *all* choices of three cyclic omissions is therefore at least $\lceil t(2t-15)/6\rceil$ in this range. At $t=32$ the exact answer is **262**. The witness uses 131 seeds translated by 0 and 16 and omits differences $0,1,5$. At $t=33$, 94 seeds translated by the three multiples of 11 give **282** local colors, one above the lower bound of 281. The 262- and 282-fold outer certificates give the expanded graphs in the table. The independent C++ checker translates one edge of each possible class into row zero, then tries all other rows in increasing order and every column compatible with the earlier choices. It verifies the price ceiling and the coverage of all 60 hole shapes for orders 31 through 35. A separate run tested the explicit general weight formula on all 804 cyclic three-hole shapes of orders eight through sixty, visiting 100,028,641 matching nodes. [Integer price certificates](three-hole-prices.tsv) · [Exhaustive matching check](cyclic_prices.cpp)

The same finite price audit gives two smaller local results. On a 12-by-12 cyclic board the least palette over all choices of three missing differences is **23**. All nine difference shapes require at least 23 colors, and a 23-color partition omits the differences $0,1,5$. For 18 copies the exact minimum is **65**. The lower bound covers all eleven shapes and a 65-color partition attains it. These statements count local colors. Run the block verifier with `12 --local local-12.txt` or `18 --local local-18.txt` to check the witnesses. [12-copy coloring](local-12.txt) · [18-copy coloring](local-18.txt)

## Certificates and larger blocks

For 28 copies, rows and columns are indexed by $\mathbb Z_{28}$ and the omitted column-minus-row differences are 0 and 1. The local certificate partitions the 728 occupied cells into 238 classes. It consists of 17 seeds, each translated by all 14 even shifts of the row and column indices. One seed has four edges and the other 16 each have three. A 238-fold coloring of the base conflict graph uses 4,254 labels. Applying each base cell's assigned labels to its local classes yields the stated graph. [28-copy base multicoloring](outer-28.txt) · [General multicoloring argument](../crown-lifts.md#coloring-the-local-blocks)

Eighteen further constructions use eight seeds, each translated by all $t$ shifts, for $8t$ local labels. For each of these copy counts we assemble its outer cover from certified 50-, 57-, 64-, 200-, 217- and 238-fold base covers. The first three are prefixes of the balanced cover. The recipe lists the chosen components. Taking disjoint palettes adds their guaranteed cover multiplicities, and assigning just the required labels at each cell may leave some labels unused. The outer and local verifiers check every assignment. For $h$ omissions the graph has $1,292t(t-h)$ edges. The generator counts four-cycles from exact intersections among local rows and among base rows. [Base cover seeds](../balanced-orbits.txt) · [C++ verifier](../crown_lift.cpp) · [Recipe loader](recipe.py)

The 32- and 33-copy constructions use separate integer covers of the original base graph. Their local partitions use shorter translation orbits to reduce the local palette. The checker expands the subgroup records, checks independence on the original coordinates and verifies the required fold at every base edge. [32-copy cover](outer-32.txt) · [33-copy cover](outer-33.txt)

## Reproduction

From this directory, choose a copy count in the table. The C++ program emits the graph in sorted vertex order. The C verifier reads only that edge stream. It stores one adjacency bit per possible bipartite edge and groups the edges of each color in temporary files. It checks endpoint collisions and opposite-color collisions and computes the cycle count directly from row intersections. At 28 copies a second C implementation using two-edge paths gave the same result. The expanded graph SHA-256 is `7dd03e7687fa9438f7a0240a95d45765d7da735a255c38203c6535deccff956e`. [Streaming bipartite verifier](audit_bipartite.c) · [Two-edge-path verifier](../../../bruteforce/results/2026-11-21-0600/large/audit.c)

```sh
c++ -O3 -std=c++17 ../crown_lift.cpp -o /tmp/810-es-block
cc -O3 -std=c11 audit_bipartite.c -o /tmp/810-es-verify
c++ -O3 -std=c++17 cyclic_prices.cpp -o /tmp/810-es-prices
/tmp/810-es-prices < three-hole-prices.tsv
/tmp/810-es-prices --formula 8 60
python3 -c 'import json; print(*(f"{x} {y}" for x,y in json.load(open("../octagon-anchor.json"))["points"]), sep="\n")' > /tmp/810-es-points
python3 recipe.py 28 block > /tmp/810-es-local
python3 recipe.py 28 base > /tmp/810-es-base
/tmp/810-es-block 28 /tmp/810-es-base --block /tmp/810-es-local < /tmp/810-es-points
/tmp/810-es-block 28 /tmp/810-es-base --block /tmp/810-es-local --emit < /tmp/810-es-points | /tmp/810-es-verify
```
