# Eight copies of the 17-point graph

The 17 coordinates from the Erdős–Szekeres project give a graph with **1,216 vertices, 82,688 edges and 1,178 colors** in which all **103,896,256** four-cycles are rainbow. Eight copies per vertex is the exact maximum for a balanced full blow-up of this particular 152-vertex graph when the number of colors is at most the number of vertices. The underlying base graph still has a separate 22-color certificate. [Coordinates](octagon-anchor.json) · [Base graph](sum-colors.md) · [New certificate](balanced-orbits.txt) · [C checker](check_orbits.c)

| Row copies | Column copies | Vertices | Edges | Colors used | Rainbow four-cycles |
| ---: | ---: | ---: | ---: | ---: | ---: |
| 7 | 7 | 1,064 | 63,308 | 947 | 60,434,934 |
| 7 | 8 | 1,140 | 72,352 | 1,058 | 79,240,336 |
| 8 | 8 | 1,216 | 82,688 | 1,178 | 103,896,256 |

At 1,064 vertices the earlier $6$-by-$8$ construction has 62,016 edges and 1,056 colors. The new graph adds 1,292 edges at that same order. These comparisons use the fixed ES support. The asymptotic question asks for a positive density at all sufficiently large orders. [Earlier construction](sum-colors.md#fewer-colors-on-the-same-es-graph) · [Erdős problem 810](https://www.erdosproblems.com/810)

## The exact multicoloring problem

Let $H$ be any simple bipartite graph. Form a graph $Q$ on its edges by joining two distinct edges if they share a vertex or are opposite in a four-cycle of $H$. Replace each row vertex of $H$ by $a$ copies and each column vertex by $b$ copies, retaining all $ab$ edges for every base edge. When $a,b\ge2$, the least number of colors making all four-cycles rainbow in this full blow-up is exactly the $ab$-fold chromatic number of $Q$. An $ab$-fold coloring assigns each vertex a set of $ab$ colors, with disjoint sets at adjacent vertices. This is the usual multicoloring operation associated with a lexicographic product. [Geller and Stahl](https://doi.org/10.1016/0095-8956(75)90076-3)

Indeed, two distinct edges over the same base cell belong to a common rectangle in its complete $a$-by-$b$ block. Any two lifted edges over incident base edges also belong to a rectangle. For example, when the base row is shared and the lifted rows coincide, choose another copy of that row. When their lifted rows differ, both crossed cells already exist. Lifted edges over opposite corners of a base rectangle share the corresponding lifted rectangle. These observations force the stated disjoint sets. Conversely any lifted rectangle projects to a base rectangle, to two incident base cells, or to one cell. Assigning the available colors bijectively within each cell makes all four colors distinct in each case.

The 17 base edges at any row form a clique in $Q$. Their lifted cells require at least $17ab$ colors under every eligible coloring. With $a=b=t$ the vertex budget gives $17t^2\le152t$, hence $t\le8$. The certificate attains $t=8$.

## Translating independent color classes

Use $G=\mathbb Z_2\times\mathbb Z_{38}$ and the 17 distinct support values $S$ obtained from the pinned points. With transformed column $t=f(y)$, the base cell $(x,t)$ exists exactly when $s=x+t\in S$. Each pair $(s,r)$ in the certificate specifies the two edges of support $s$ whose row has second coordinate $r$. Their first coordinates are the two elements of $\mathbb Z_2$. A seed is a list of these pairs whose base edges form an independent set in $Q$. The checker verifies this condition by examining every actual pair of base edges.

Translate rows by $(0,j)$ and transformed columns by $(0,-j)$ for each $j\in\mathbb Z_{38}$. These 38 translates preserve $s$ and give 38 color classes per seed. If support $s$ occurs $k$ times in one seed, every cell of support $s$ sees exactly $k$ available labels from that seed. For a row with second coordinate $u$, the labels correspond to $j=u-r$ for the seed's representatives of $s$. Different seeds have disjoint palettes, even when two seeds are identical as sets.

A C++ search replaced representatives to eliminate conflicting pairs, then selected seeds to cover every support value often enough. The certificate gives an explicit ordered list of 31 seeds. Using the first 25, 28 and 31 yields minimum coverage 50, 57 and 64, respectively. The checker assigns the first $ab$ available labels to the $ab$ lifted edges in row-major order. It constructs the original group table from the pinned coordinates, checks properness at every vertex and verifies all six color comparisons on every four-cycle. It also checks the rectangle count against the independent base-projection formula. [Direct enumeration](lift_audit.h) · [Count formula](sum-colors.md#fewer-colors-on-the-same-es-graph)

## Two exact parameters of the base conflict graph

The largest independent set of $Q$ has exactly 76 edges of the base graph. An independent set is a matching, so its size is at most 76. A seed with 38 representatives expands to 76 mutually compatible edges and attains the bound. [Perfect matching certificate](perfect-class.txt)

The largest clique of $Q$ has exactly 17 vertices. The endpoints of any clique of edges span a complete bipartite subgraph of $H$. Indeed, to test a row and a column taken from two different edges of the clique, either they form an original edge or compatibility in the clique requires their crossed cell to be occupied. Conversely all edges of any complete bipartite subgraph form a clique. Translate a row of that subgraph to row zero. For each nonempty subset $T$ of its 17 neighboring columns, the checker counts the rows adjacent to all columns of $T$. The largest product of that count with $|T|$ over all 131,071 subsets is 17. [Exhaustive enumeration](check_orbits.c)

These two parameters each give the lower bound 17 on the fractional chromatic number of $Q$. A weighted certificate also gives an upper bound strictly below 18. Repeat each of its 17 seeds with the indicated positive integer multiplicity and give each repetition its 38 translated labels. Every base cell obtains at least 5,100 available labels, from 91,352 labels in total. Choosing 5,100 at each cell therefore proves $17\le\chi_f(Q)\le91352/5100<17.913$. The checker verifies every seed and sums the coverage of all 17 support values using integers. The ordinary chromatic number still lies between 17 and 22. [Weighted certificate](fractional-orbits.txt)

## Reproducing the checks

From this directory, run the following commands. The first number in the certificate counts the seeds. Each seed gives its size followed by pairs of a support value $38i+j$ and a row residue. The weighted file includes a multiplicity before each seed size.

```sh
cc -O3 -std=c11 check_orbits.c -o /tmp/check_es_orbits
python3 -c 'import json; print(*(f"{x} {y}" for x,y in json.load(open("octagon-anchor.json"))["points"]), sep="\n")' > /tmp/es-points.txt
/tmp/check_es_orbits perfect-class.txt --classes < /tmp/es-points.txt
/tmp/check_es_orbits fractional-orbits.txt --fractional < /tmp/es-points.txt
/tmp/check_es_orbits balanced-orbits.txt 7 7 25 < /tmp/es-points.txt
/tmp/check_es_orbits balanced-orbits.txt 7 8 28 < /tmp/es-points.txt
/tmp/check_es_orbits balanced-orbits.txt 8 8 31 < /tmp/es-points.txt
```
