# Twenty-six copies from the 17 Erdős–Szekeres points

The additive graph of the 17 pinned integer points has 76 vertices on each side, 17 neighbors at every vertex and 1,292 edges. Replace each base vertex by 26 copies. At every base edge retain all copy pairs except the 26 pairs of equal indices. The result has **3,952 vertices, 839,800 edges and 3,952 colors**. All **10,264,998,900 four-cycles** are rainbow. For this base graph the largest feasible uniform copy count with one omitted perfect matching per block is either 26 or 27. The upper bound also allows the omitted matchings to differ from block to block. With every copy pair present the exact maximum was eight. [Coordinates](octagon-anchor.json) · [Full blocks](orbit-lifts.md) · [26-copy certificate](crown-26.txt)

| Copies | Vertices | Edges | Used colors | Rainbow four-cycles |
| ---: | ---: | ---: | ---: | ---: |
| 25 | 3,800 | 775,200 | 3,697 | 8,712,062,400 |
| 26 | 3,952 | 839,800 | 3,952 | 10,264,998,900 |

## One missing matching limits the gain

Consider any cluster of $t$ copies of a base row and all columns adjacent to that cluster. More generally suppose each block omits at most $h$ cells per row and per column and $t\ge 2h+2$. Any two edges in this star that share an endpoint belong to a four-cycle. If they share a lifted row, their two columns have at least $t-2h$ common rows in the cluster. If they share a lifted column, use the column's block and choose a second column adjacent to both rows. Thus the edges of one color in the star have distinct row and column endpoints.

List these $k$ edges as $(r_i,c_i)$. For $i\ne j$, at least one cross cell $(r_i,c_j),(r_j,c_i)$ is absent, since otherwise the opposite edges have the same color in a four-cycle. Each $c_j$ omits at most $h$ rows of the cluster. Counting missing cross cells gives $\binom{k}{2}\le hk$ and hence $k\le2h+1$. This yields the palette constraint $d\,t(t-h)\le n\,t(2h+1)$ for a base row of degree $d$ in an $n$-vertex base graph. For the ES graph $h=1$, $d=17$ and $n=152$, so $17(t-1)\le456$ and $t\le27$. Smaller $t$ already satisfy the conclusion. Lean verifies the finite cross-cell count and the numerical implication. [Lean proof](../hall-reduction/CrownColorBudget.lean)

## Coloring the local blocks

In the graph $K_{t,t}$ with its diagonal removed, view a lifted edge as a directed arc $i\to j$. The three arcs of any directed triangle can share a color. They have distinct row and column indices, and every pair has a missing diagonal cross cell. The same holds for an antiparallel pair. A decomposition into directed triangles and at most one such pair attains the lower bound of $\lceil t(t-1)/3\rceil$ colors from the star count.

At $t=25$, eight directed difference triples modulo 25 and their translates partition all 600 arcs into 200 triangles. At $t=26$, use 24 ordinary indices and two additional points $A,B$. Seven translated triples cover all differences except 1 and 11 on the ordinary indices. Add the cycles $(A,x,x+1)$ and $(B,x,x+11)$ for every $x$ modulo 24, then the pair $A\to B,B\to A$. Exactly 217 local colors suffice. At $t=27$, the two orientations of each affine line of $\mathbb F_3^3$ give 234 local colors. The code checks all occupied local rectangles. [Difference triples and block verifier](crown_lift.cpp)

The base conflict graph $Q$ joins two base edges when they meet or are opposite in a base four-cycle. Give each base cell a set of local-color labels and take disjoint sets at adjacent vertices of $Q$. Applying its assigned labels to the directed-arc coloring of each block produces a proper #810 graph. Two repeated opposite labels over distinct base edges would project to incident edges or to opposite edges of a base rectangle. If both repeated labels project to the same edge, the entire lifted rectangle lies in one locally verified block. [Base conflict graph](orbit-lifts.md) · [25-copy certificate](crown-25.txt)

The certificates give the label sets as translates of independent sets of $Q$. Each record lists a multiplicity, a subgroup $H$ of $G=\mathbb Z_2\times\mathbb Z_{38}$, and representatives $(s,r)$ for the rows of each support value $s$. Develop each listed representative over $r+H$, then assign a fresh label for each translate in $G/H$ and each repetition. The checker builds $Q$ directly from the 17 coordinates. It checks independence of the seeds and verifies the coverage of every individual base cell.

A separate certificate gives each cell at least 1,045,331 labels from a common palette of 18,559,366. It proves
$$
17\le\chi_f(Q)\le\frac{2,651,338}{149,333}<17.755.
$$
The earlier certified upper bound was $91,352/5,100$. A 234-fold cover with 4,104 labels would suffice for 27 copies with the local construction above. The fractional certificate alone does not establish such an integral cover. [Fractional certificate](crown-fractional.txt) · [Clique lower bound](orbit-lifts.md#two-exact-parameters-of-the-base-conflict-graph)

## Reproduction

Run these commands from this directory. The C++ checker reports the exact cycle total from common-neighbor counts on the base. For two rows over one base row those counts are $17(t-2)$. For two different base rows with $b$ common base columns the counts are $b(t-1)$ for equal copy indices and $b(t-2)$ otherwise. The independent C checker reads only the expanded graph and checks same-color edge pairs, properness and all codegrees. The checksums of the sorted 25- and 26-copy edge lists are respectively `bda11cc4b3d82f905481edba77676e3a50a98c71c972134a52392c44ad3f4a2e` and `4e65ccb72a792e91c5d37df324bdce42a2571fe6c0584607732d0d7f94fcb982`. [Expanded-graph C verifier](../../bruteforce/results/2026-11-21-0600/products/audit_proper.c)

```sh
c++ -O3 -std=c++17 crown_lift.cpp -o /tmp/810-crown
cc -O3 -std=c11 ../../bruteforce/results/2026-11-21-0600/products/audit_proper.c -o /tmp/810-crown-audit
python3 -c 'import json; print(*(f"{x} {y}" for x,y in json.load(open("octagon-anchor.json"))["points"]),sep="\n")' > /tmp/810-coordinates
/tmp/810-crown --fractional crown-fractional.txt < /tmp/810-coordinates
/tmp/810-crown 25 crown-25.txt < /tmp/810-coordinates
/tmp/810-crown 26 crown-26.txt --emit < /tmp/810-coordinates | /tmp/810-crown-audit
```
