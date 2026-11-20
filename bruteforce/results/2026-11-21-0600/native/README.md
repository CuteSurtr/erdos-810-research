# Testing a four-cycle coloring

Construct a conflict graph with one vertex for each edge of the original graph. Two such vertices are adjacent exactly when a four-cycle contains both edges. A valid coloring with at most $k$ labels is equivalent to a proper vertex coloring of this conflict graph.

For every pair of original vertices with $t\ge2$ common neighbors, the $2t$ edges to those common neighbors form a conflict clique. Every pair in the clique lies on a four-cycle, and every four-cycle is covered by the clique for either pair of opposite vertices. Taking the union therefore constructs the exact conflict graph. A conflict vertex of degree below $k$ can be removed and colored in reverse order. A chosen conflict clique can be assigned consecutive distinct labels by permuting colors. [Construction and list coloring](coloring.cpp)

The first search branches on an edge with the fewest available colors. After 1,600 search nodes it tries covering the remaining conflict core by at most $k$ independent sets. Every color class extends to a maximal independent set. Conversely, a cover gives a coloring by choosing one covering set for each edge. The checker enumerates maximal independent sets by Bron–Kerbosch on the complement of the conflict core.

If $r$ colors remain, each of their sets must meet every uncovered clique of size $r$. Among the sets that meet those cliques, let $s_v$ be the maximum number of uncovered vertices in a set containing $v$. Each eligible set has total vertex weight at most one for the weights $1/s_v$. Thus a total weight greater than $r$ rules out a cover. The implementation rounds weights down in integer arithmetic. It branches on a vertex contained in few eligible sets and discards sets contained in another candidate. Exceeding either the maximal-set or cover-search budget triggers unrestricted list coloring. [Cover solver](maximal_cover.inc)

The C hook complements each graph from nauty's vertex-by-vertex generation. A rejected partial graph stays infeasible in every descendant because it is induced on the vertices already present. The generator uses a fixed final palette throughout. [C hook](anchor_hook.c) · [Earlier independent C implementations](../../2026-11-21/README.md#the-upper-bound)

The cover solver agreed with the independent four-subset checker on every one of the 12,346 unlabeled eight-vertex graphs at each palette size from one through nine. Counts at those palettes were 351, 351, 351, 1,966, 2,000, 5,611, 5,955, 7,007 and 9,010. It also agreed on 54 test supports at each order from 12 through 16, at palette sizes $n-1,n,n+1$. The standalone checker verifies every returned coloring directly against the four-cycles. [Witness checker](check_graphs.cpp) · [Independent C checker](../../M12/src/prune810b.c)

Build with a GCC or Clang compiler supporting 128-bit integers. The source handles orders 1 through 16 and up to 31 colors. The third build argument is optional and enables the independent SAT audit of the proper-coloring census.

The colored extension checker takes the final order, edge count, palette and minimum degree. It reads parent graph6 records and tries every possible neighborhood of the restored minimum-degree vertex. For each parent it enumerates all old color partitions up to color relabeling. Once two proposed neighbors are chosen, their old two-edge paths determine which colors the two new spokes must avoid. An old path with repeated colors excludes the neighborhood. Distinct representatives for the spoke lists always suffice. Where two spokes can share a label, an exact list-coloring search also tries that possibility. This handles graphs such as a one-color five-cycle, in which a matching for the two restored spokes is impossible. Parents may have up to 64 edges. [Spoke checker](extend_colored.cpp) · [Parent coloring enumeration](count_colorings.cpp)

The colored extension checker and the direct child solver returned identical labeled extensions in 510 small parameter batches, covering 1,303 accepted extensions. The batches used every unlabeled graph on three through five vertices, a fixed sample of 30 six-vertex graphs, palettes from one through five, and every possible minimum degree consistent with the edge total.

```sh
sh native/build.sh "$NAUTY" "$SCRATCH" "$CADICAL"
"$SCRATCH/check-cover" 13 --colors < data/optimal-13.g6
"$SCRATCH/extend-colored" 15 62 14 7 < data/optimal-14.g6
python3 native/check_extensions.py "$NAUTY/geng" "$SCRATCH"
```
