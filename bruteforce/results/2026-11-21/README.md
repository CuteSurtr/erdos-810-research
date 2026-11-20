# The exact maximum on 13 vertices

**$M(13)=47$.** A 13-vertex graph with 47 edges uses 13 colors and has 222 four-cycles, each with four different colors. Two exhaustive computations found zero 13-vertex graphs with 48 edges that admit such a coloring. Deleting edges preserves the coloring condition, so the same upper bound covers every larger edge count. This settles the finite case that the October search left open. [Lower-bound witness, key `13`](../SAT/certs.json) · [Previous search](../M12/M13_PLAN.md) · [Counts by shard](search-counts.txt)

## The upper bound

There are 78 pairs of vertices. A graph with 48 edges is specified by its 30 missing pairs. We generated all possible graphs of missing pairs up to isomorphism with nauty 2.8.9, using both connected and disconnected graphs and the full degree range.

At each step, the generator adds one vertex. If $H$ is its current graph of missing pairs, the coloring checker examines the edges of $\overline H$. Every descendant on a larger vertex set induces the same $\overline H$ on the vertices already present. An obstruction to a 13-coloring of this induced subgraph therefore rules out every descendant. Both runs use this generation rule. [Complement code](complement_prune.c) · [McKay and Piperno’s nauty guide](https://pallini.di.uniroma1.it/nug28.pdf)

The two coloring checkers use different implementations. Checker A determines whether two edges share a four-cycle from their endpoints and performs a saturation-degree coloring search. Checker B lists the four-cycles explicitly and backtracks over available colors. Each checker finished all 64 shards. On smaller orders each recovered the two extremal 10-vertex graphs, the 131 extremal 11-vertex graphs, and zero graphs one edge above either maximum. [Checker A](../M12/src/qcol.h) · [Checker B](../M12/src/prune810b.c)

| 13 vertices, 48 edges, 13 colors | Completed shards | Admissible graphs | CPU seconds |
| --- | ---: | ---: | ---: |
| Checker A | 64 / 64 | 0 | 122.81 |
| Checker B | 64 / 64 | 0 | 717.30 |

To reproduce the unrestricted runs, use a configured nauty 2.8.9 source tree and run the following from this directory. Each command below covers all shards in a single process. To reproduce an individual shard, append its index and modulus, for example `15/64`.

```sh
sh build_checkers.sh "$NAUTY" "$SCRATCH"
PRUNE_K=13 "$SCRATCH/rainbow-a" -u 13 30:30
PRUNE_K=13 "$SCRATCH/rainbow-b" -u 13 30:30
```

## Twelve colors on the same 13 vertices

With a budget of 12 colors the exact maximum is **46 edges**. A witness has 203 rainbow four-cycles. At 46 edges the search found 97 admissible underlying graphs up to isomorphism. Here the known value $M(12)=40$ gives a degree restriction. Deleting any vertex leaves at most 40 edges, so a 46-edge candidate has minimum degree at least six, and a 47-edge candidate has minimum degree at least seven. The corresponding maximum degrees in the complement are six and five. [46-edge coloring](twelve-colors.json) · [12-vertex bound](../M12/REPORT.md) · [Enumeration counts](search-counts.txt)

```sh
PRUNE_K=12 "$SCRATCH/rainbow-a" -u -D6 13 32:32
PRUNE_K=12 "$SCRATCH/rainbow-a" -u -D5 13 31:31
```

A separate check also excludes 47 edges with 12 colors. Such a graph would have minimum degree seven and degree sum 94, just three above $13\cdot7$. If its maximum degree is at most nine, delete any degree-seven vertex. Otherwise it has a unique degree-ten vertex whose neighbors all have degree seven. Delete one of those neighbors. The result has 12 vertices, 40 edges and maximum degree at most nine. We tried every seven-neighbor extension of the 3,330 archived graphs of this kind that could restore minimum degree seven. Two checkers rejected all 84,380 extensions. The second found 13 pairwise conflicting edges in 84,144 cases and ruled out the remaining 236 by coloring search. [Extension code](extend_12.cpp) · [Base catalog](../M12/out/n12_e40-D9) · [Second checker](../V12/V2/src/checker.c)

```sh
c++ -O3 -std=c++17 extend_12.cpp -o "$SCRATCH/extend12"
cat ../M12/out/n12_e40-D9/*.g6 | "$SCRATCH/extend12"
cc -O3 ../V12/V2/src/checker.c -o "$SCRATCH/check12"
cat ../M12/out/n12_e40-D9/*.g6 | "$SCRATCH/extend12" --emit | "$SCRATCH/check12" 12
```

## Constructions through 512 vertices

The largest witness has **31,696 edges on 512 vertices**. All 29,522,545 four-cycles use four distinct colors. Five of the six existing bounds targeted by the local search improved. The 128-vertex bound stayed at 2,952 edges. [Colored edges](certs.json) · [Previous bounds](../2026-11-20-evening/README.md)

| Vertices | Previous checkpoint | Edges | Colors used | Rainbow four-cycles |
| ---: | ---: | ---: | ---: | ---: |
| 144 | 3,628 | 3,629 | 144 | 781,093 |
| 160 | 4,360 | 4,362 | 160 | 1,071,071 |
| 192 | 5,966 | 5,969 | 192 | 1,818,823 |
| 224 | 7,811 | 7,818 | 224 | 2,895,809 |
| 256 | 9,838 | 9,848 | 256 | 4,302,542 |
| 320 | — | 14,120 | 320 | 7,557,969 |
| 384 | — | 19,327 | 384 | 12,829,387 |
| 448 | — | 25,180 | 448 | 20,027,287 |
| 512 | — | 31,696 | 512 | 29,522,545 |

The 512-vertex construction starts with the previous 9,838-edge graph on 256 vertices. Each following step adds a vertex and assigns colors to its incident edges by bipartite matching. The search used an empty initial neighborhood, seed $810000+n$ at order $n$, and 90 milliseconds per extension. To recover the rows for 320, 384 and 448 vertices, take the triples from key `512` whose two endpoints are both below the requested order. [Matching code](../2026-11-20-evening/hall_extension.cpp) · [Starting graph](../2026-11-20-evening/larger/certs.json)

A C program enumerated four-vertex sets, and a Python program counted cycles through pairs of opposite vertices. They agreed on all nine rows. The Lean 4.24 runtime checker also accepted all six graphs stored as full entries in the certificate file. [C checker](../LINUX_20261108/constructions/src/fourset_check.c) · [Python checker](../2026-11-20-evening/check_common.py) · [Lean checker and soundness theorem](../../../research/hall-reduction/MatrixCertificate.lean)

```sh
python3 ../2026-11-20-evening/check_common.py certs.json
python3 ../2026-11-20/emit_matrix.py certs.json all "$SCRATCH/GraphAudit.lean" --runtime
```

Run `lake env lean -j1 "$SCRATCH/GraphAudit.lean"` from `research/hall-reduction` after building `MatrixCertificate`.
