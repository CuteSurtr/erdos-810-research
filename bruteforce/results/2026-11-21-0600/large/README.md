# Nested constructions with large palettes

The 5,120-vertex graph contains **1,682,268 edges** and uses 5,120 colors. All 23,916,646,744 four-cycles have four different colors. Its induced subgraphs give explicit lower bounds at every order from 512 through 5,120. The question of positive limiting density in Erdős #810 remains open. [All checked orders and edge-list fingerprints](counts.tsv)

| Vertices | Edges | Rainbow four-cycles |
| ---: | ---: | ---: |
| 512 | 31,696 | 29,522,545 |
| 1,024 | 104,907 | 222,945,890 |
| 1,536 | 211,879 | 735,498,392 |
| 2,048 | 348,698 | 1,708,966,877 |
| 2,560 | 512,602 | 3,275,815,060 |
| 3,072 | 702,073 | 5,564,033,433 |
| 3,584 | 915,954 | 8,709,200,475 |
| 4,096 | 1,152,423 | 12,799,451,456 |
| 4,608 | 1,405,884 | 17,756,774,534 |
| 5,120 | 1,682,268 | 23,916,646,744 |

The archive stores the new spokes at each vertex, beginning with the project’s colored graph on 512 vertices. To reconstruct any prefix, run these commands in this directory. The shell glob puts the numbered segments in order. The fingerprint is SHA-256 of the header and sorted `u v color` triples, each followed by a single newline. [Seed graph, key 512](../../2026-11-21/certs.json) · [Edge-list reconstruction](witness.py)

```sh
python3 witness.py ../../2026-11-21/certs.json 512 5120 spokes-*.rows.xz > "$SCRATCH/graph.txt"
cc -O3 audit.c -o "$SCRATCH/audit"
"$SCRATCH/audit" < "$SCRATCH/graph.txt"
"$SCRATCH/audit" --cycles < "$SCRATCH/graph.txt"
shasum -a 256 "$SCRATCH/graph.txt"
```

The first audit counts two-edge paths between each opposite pair. When there are at least two such paths, all their labels must be distinct. Each undirected four-cycle has two opposite pairs. The second audit explicitly checks all six color inequalities on each cycle, visiting the cycle once at its least vertex. Both counts and all individual checks agree at every tabulated order. [C verifier](audit.c)

For the construction, add one vertex at a time. When two proposed neighbors are connected by an old two-edge path, neither new spoke can use either color on that path. A path carrying the same color twice rules out that neighbor pair. For every trial neighborhood the generator looks for a matching from the new spokes to distinct admissible colors. Such a matching makes every new four-cycle rainbow. It tries several orders for the neighbors and keeps the largest successful neighborhood. The integer random generator and the order of all tie breaks are fixed. [C++ generator](grow.cpp)

To reproduce the search, the first phase uses seed 8102116 and five passes per vertex. The second uses seed 8102120 and four passes. The third uses seed 8102124 and one pass. A run may stop at a shorter target to reproduce its prefix.

```sh
c++ -std=c++17 -O3 grow.cpp -o "$SCRATCH/grow"
python3 witness.py ../../2026-11-21/certs.json 512 512 > "$SCRATCH/seed.txt"
"$SCRATCH/grow" 2048 8102116 5 < "$SCRATCH/seed.txt" > "$SCRATCH/phase1.rows"
python3 witness.py "$SCRATCH/seed.txt" 512 2048 "$SCRATCH/phase1.rows" > "$SCRATCH/2048.txt"
"$SCRATCH/grow" 4096 8102120 4 < "$SCRATCH/2048.txt" > "$SCRATCH/phase2.rows"
python3 witness.py "$SCRATCH/2048.txt" 2048 4096 "$SCRATCH/phase2.rows" > "$SCRATCH/4096.txt"
"$SCRATCH/grow" 8192 8102124 1 < "$SCRATCH/4096.txt" > "$SCRATCH/phase3.rows"
```
