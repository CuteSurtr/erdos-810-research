# Fixed palettes and extremal four-cycle colorings

Write $F(n,k)$ for the maximum number of edges on $n$ vertices using at most $k$ colors when every four-cycle has four different colors. The quantity in Erdős #810 is $M(n)=F(n,n)$. The fixed-palette results below allow one to use vertex deletion without changing the color budget. [Problem statement](https://www.erdosproblems.com/810)

| Vertices | Palette | Exact maximum | Four-cycles in the witness |
| ---: | ---: | ---: | ---: |
| 12 | 15 | 44 | 243 |
| 12 | 16 | 45 | 269 |
| 13 | 14 | 49 | 265 |
| 13 | 15 | 50 | 302 |
| 13 | 16 | 51 | 329 |
| 13 | 17 | 52 | 355 |
| 13 | 18 | 54 | 420 |
| 14 | 12 | 52 | 238 |
| 14 | 13 | 54 | 284 |
| 14 | 15 | 56 | 337 |
| 14 | 16 | 57 | 379 |
| 15 | 12 | 58 | 295 |
| 15 | 16 | 65 | 490 |

For both 12-vertex entries and for palettes 15 through 18 on 13 vertices, three programs each completed an unrestricted enumeration at one edge above the claimed maximum. Every search returned zero supports. Their pruning counts agree on each input. Deleting edges preserves the four-cycle condition, so each exclusion is an upper bound for every larger edge count as well. The archive supplies a coloring attaining every entry. [Counts from both C checkers and the C++ checker](data/fixed-palette-upper.tsv) · [Edge triples](palette-witnesses.json)

To reproduce a row, set `PRUNE_K` to its palette and use its number of missing pairs for the generator's fixed edge count. For example, 53 edges on 13 vertices leaves 25 missing pairs.

```sh
for solver in rainbow-a rainbow-b rainbow-cover
do
    PRUNE_K=17 "$SCRATCH/$solver" -u 13 25:25
done
```

On 13 vertices with 14 colors, the two C checkers and the C++ checker each found six supports at 49 edges and zero at 50 edges in full, unsharded runs. All three use the same nauty generator. There are 78 pairs, so the generator searches graphs of 28 missing pairs. A graph with more than 50 edges would yield a valid 50-edge graph by deleting edges. The 49-edge witness uses all 14 colors. [All six runs](data/13-k14-three-checkers.tsv) · [Witnesses](palette-witnesses.json) · [Complement generation and checker builds](../2026-11-21/README.md#the-upper-bound)

With 12 colors the exact maxima at 14 and 15 vertices are **52 and 58 edges**. At 14 vertices an unrestricted search excluded 53 edges. Exactly three supports attain 52 up to isomorphism. On 15 vertices a 59-edge graph would have a degree-seven vertex, whose deletion leaves one of those three supports. Two independent coloring solvers rejected every one of the 10,296 possible restorations. A degree-six extension attains 58 and has 295 rainbow four-cycles. [Proof, counts and reproduction](twelve-color-extrema.md) · [Colorings](palette-witnesses.json)

On 14 vertices with 15 colors, the 56-edge witness attains the maximum. All 256 unrestricted shards with 57 edges and 15 colors returned zero graphs. [All shard counts](data/14-57-k15-cover.tsv) · [Witness](palette-witnesses.json)

On 14 vertices with 16 colors, a 57-edge graph attains the maximum. All 256 unrestricted shards with 58 edges and 16 colors were empty. The 57-edge witness comes from adding an edge to a 56-edge graph and recoloring the enlarged graph. [All shard counts](data/14-58-k16-cover.tsv) · [Witness with 379 four-cycles](palette-witnesses.json)

On 14 vertices with 13 colors, deleting any vertex leaves at most $F(13,13)=47$ edges. Each edge survives 12 of the 14 vertex deletions, so $12m\le14\cdot47$. It follows that $m\le54$. The 54-edge witness attains the bound with 13 colors. [The 13-vertex optimum](../2026-11-21/README.md) · [Witnesses](palette-witnesses.json)

The independent Python check enumerates the three possible cycles on every four-vertex set. It verifies the endpoint range, color budget, edge uniqueness, every color constraint and the reported cycle count. [Checker](check_palette.py)

## Exact maximum on 15 vertices

**$M(15)=63$.** The lower witness uses 15 colors and has 417 rainbow four-cycles. For the upper bound, a 64-edge graph on 15 vertices has 41 missing pairs. All 1,024 complement classes were exhausted with the full degree range, allowing disconnected graphs and incident edges of equal color. The C++ solver found zero admissible supports in 253,953,834 pruning calls, of which 197,476,906 rejected a partial graph. Each shard has a successful completion record and an empty output file. Any graph with more edges would give a 64-edge example by edge deletion. The lower bound is checked by Lean. The upper bound is a computational enumeration using nauty and the exact coloring solver. [All shard counts](data/15-64-k15-cover.tsv) · [Lower witness, key 15](../LB/certs.json) · [Lean lower-bound theorem](../../../research/hall-reduction/SmallGraphCertificates.lean) · [Solver and completeness argument](native/README.md)

```sh
sh native/build.sh "$NAUTY" "$SCRATCH"
for residue in $(seq 0 1023)
do
    PRUNE_K=15 "$SCRATCH/rainbow-cover" 15 41:41 "$residue/1024"
done
```

The 63-edge witness is locally isolated. Up to vertex relabeling, replacing any one or two of its edges yields no other admissible 63-edge graph. Its automorphism group has order three, and it has exactly one color partition even with the vertices fixed. That partition is proper and uses all 15 colors. Both coloring counters agree. All 21 distinct single-edge deletions still need 15 colors under unrestricted recoloring, as checked separately by the C and C++ decision programs. This describes one extremal support. A complete census of extremal 15-vertex supports remains open. [Graph6 representative](data/optimal-15-example.g6) · [Color-count methods](coloring-census.md)

For the one-exchange calculation the 21 deletion types gave 903 possible additions and 883 distinct supports. Both decision programs accepted only the starting support. For two exchanges, removing a second edge yielded 651 distinct 61-edge graphs. The first restoration yielded 27,363 distinct 62-edge candidates, of which 166 were admissible. The second restoration yielded 6,788 distinct 63-edge candidates, of which only the starting support was admissible. At every depth, the intermediate graphs of an admissible output are admissible by edge deletion. Canonical labeling after each operation therefore preserves the full neighborhood up to isomorphism. [Enumeration program](native/exchange_neighbours.py)

```sh
python3 native/exchange_neighbours.py data/optimal-15-example.g6 15 2 \
    --labelg "$NAUTY/labelg" --cover "$SCRATCH/check-cover"
```

At the 09:00 KST stop on 21 November, the native enumeration queues had 6,720 completed runs across 47 searches. These cover 6,691 distinct pairs of search name and shard index. Repeated runs returned byte-identical complement graph lists. Each record gives the generator, parameters, pruning counts, number of survivors and SHA-256 of the graph output. The local copy with the graph6 strings, `native-shards-at-stop.jsonl.xz`, has SHA-256 `1575149ed00140ccccd526c3a2449a1b6a1f1aaae9821c0b5033ce3be6f1ea7d`. [Compressed tab-separated run index](data/native-shards-at-stop.tsv.xz)

## Bounds on 15 and 16 vertices

**$F(15,16)=65$, with one extremal support up to vertex relabeling.** Its 65 edges use all 16 colors, and each of its 490 four-cycles is rainbow. A graph with $m$ edges on 15 vertices satisfies $13m\le15F(14,16)=855$ by vertex deletion. Thus $m\le65$. At 65 edges, deleting any vertex leaves at most 57 edges, so every degree is at least eight. The complement has 40 edges and maximum degree six. In all 512 nauty shards the exact C++ checker found a single support, in shard 301, after 712,280,761 pruning calls. [512 shard records](data/15-65-k16-D6-cover.tsv) · [Unique support in graph6](data/15-65-k16-unique.g6) · [Edge coloring](data/15-65-k16-coloring.json) · [Native generator and completeness](native/README.md)

**$71\le M(16)\le73$.** The fixed-palette deletion bound first gives $14M(16)\le16\cdot65$, hence $M(16)\le74$. If a 74-edge graph existed, every vertex would have degree at least nine. The average degree is $148/16<10$, so deleting a degree-nine vertex would leave the unique 65-edge support. That support has five vertices of degree eight and ten of degree nine. Restoring the deleted vertex must join all five degree-eight vertices and four of the other ten. All $\binom{10}{4}=210$ neighborhoods failed exact coloring with 16 colors. The previously certified 71-edge graph supplies the lower endpoint. [65-edge parent](data/15-65-k16-unique.g6) · [16-vertex witness](diagonal-witnesses.json) · [Lean lower bound](../../../research/hall-reduction/OvernightWitnesses.lean)

A potential 73-edge graph must also have minimum degree nine. A degree at most seven would leave at least 66 edges after deletion. For degree eight the parent would again be the unique 65-edge support. All $\binom{15}{8}=6{,}435$ ways to restore a degree-eight vertex failed. Hence the degree sequence at 73 edges has either two tens and fourteen nines, or one eleven and fifteen nines. Any two vertices then have at least two common neighbors, so every pair of incident edges lies on a four-cycle and a valid coloring must be proper.

To replay from this directory, use the native build and run the following with each shard index from 0 through 511. The `all` mode generates candidate supports without testing their colorings. The standalone checker then tests each candidate. [Native build](native/README.md) · [Earlier 320-shard checkpoint](data/15-65-k16-D6-partial.tsv)

```sh
PRUNE_K=16 TARGET_EDGES=65 FINAL_MIN_DEGREE=8 "$SCRATCH/rainbow-cover" -D6 15 40:40 "$i/512"
python3 check_palette.py data/15-65-k16-coloring.json
"$SCRATCH/extend-catalog" 16 74 16 9 all < data/15-65-k16-unique.g6 | "$SCRATCH/check-cover" 16
"$SCRATCH/extend-catalog" 16 73 16 8 all < data/15-65-k16-unique.g6 | "$SCRATCH/check-cover" 16
```

With 14 colors on 15 vertices the maximum is 61 or 62. The lower witness has 356 four-cycles. A 63-edge graph would have minimum degree at least eight because $F(14,14)=55$. The complement search at maximum degree six returned zero across all 512 shards. [Coloring](palette-witnesses.json) · [All shard counts](data/15-63-k14-D6-cover.tsv)

There is a second proof of the 63-edge exclusion with 14 colors. A minimum-degree vertex would have degree eight, so deleting it would leave a 55-edge parent. One of the 52 parents has degree six and cannot recover minimum degree eight with one added neighbor. The other 51 give 27,384 labeled neighborhoods when every degree-seven vertex is included. The independent C checker excluded 27,370 candidates by conflict cliques and 14 by exact coloring. The parent file and both commands are below. [Parents](data/optimal-14.g6) · [C checker](../V12/V2/src/checker.c)

```sh
"$SCRATCH/extend-catalog" 15 63 14 8 all < data/optimal-14.g6 | "$SCRATCH/check-independent" 14
```

A 62-edge witness, if one exists, must have **minimum degree eight**. A degree-seven vertex would leave one of the 52 optimal 14-vertex supports at 55 edges. Together those parents admit 2,109 color partitions when their vertex labels are fixed. Exhausting these partitions and all 176,748 candidate neighborhoods gives zero extensions. An independent C program checked the 176,748 underlying candidate graphs directly. It rejected 173,873 by conflict cliques and the remaining 2,875 by exact coloring. [Parent catalog](data/optimal-14.g6) · [Colored extension algorithm](native/extend_colored.cpp) · [Independent checker](../V12/V2/src/checker.c)

## A 97-edge witness on 19 vertices

The project’s lower bound at 19 vertices rises from 96 to **97 edges**. The graph has 996 four-cycles, and all are rainbow with 19 colors. Its 18-vertex parent is the existing 90-edge graph. Recoloring that support allows seven new spokes from a nineteenth vertex. Lean verifies the lower bound directly from the packed edge labels. [Edge triples](diagonal-witnesses.json) · [Lean certificate](../../../research/hall-reduction/OvernightWitnesses.lean) · [Previous 96-edge certificate](../../../research/hall-reduction/SmallGraphCertificates.lean)

The search changes an individual edge color or interchanges two colors on a connected component of their conflict graph. Both moves preserve rainbow four-cycles. For each new parent coloring it tests possible neighborhoods of the new vertex and uses a matching to assign distinct spoke colors. With seed 8102181, 256 trials reproduce the archived support and every edge label. [C++ search](native/spoke_walk.cpp)

```sh
python3 large/witness.py ../LB/certs.json 18 18 > "$SCRATCH/18.txt"
"$SCRATCH/spoke-walk" 19 8102181 256 < "$SCRATCH/18.txt"
python3 check_palette.py diagonal-witnesses.json
```

```sh
python3 check_palette.py palette-witnesses.json
PRUNE_K=14 "$SCRATCH/rainbow-a" -u 13 28:28
PRUNE_K=14 "$SCRATCH/rainbow-b" -u 13 28:28
```

## Exact maximum on 14 vertices

**$M(14)=55$.** The 55-edge witness has 308 four-cycles. The complement search excluded every 56-edge graph using 14 colors. Both checker A and the C++ cover solver completed all 256 shards with 35 missing pairs, allowing every degree and connectedness pattern. Their counts of accepted and rejected partial graphs also agree in every shard. [Checker A counts](data/14-56-k14-A.tsv) Edge deletion then excludes all higher edge counts. [All shard counts](data/14-56-k14-cover.tsv) · [Lean lower-bound theorem](../../../research/hall-reduction/SmallGraphCertificates.lean#L50) · [Explicit coloring, key 14](../LB/certs.json) · [Search algorithm](native/README.md)

```sh
sh native/build.sh "$NAUTY" "$SCRATCH"
PRUNE_K=14 "$SCRATCH/rainbow-cover" -u 14 35:35
```

There are exactly **52 optimal 14-vertex supports**. All 1,151 optimal coloring classes are proper. Five potential incident equalities survive the elementary four-cycle test across these supports, and SAT excludes all five. The census uses complementary maximum degree seven because deleting any vertex from a 55-edge candidate leaves at most $F(13,14)=49$ edges. [Optimal graphs](data/optimal-14.g6) · [Census counts](data/14-55-k14-cover.tsv) · [Both independent coloring counters](coloring-census.md) · [Exchange and cycle statistics](data/geometry-14.json)

A second upper-bound argument deletes a minimum-degree vertex. In a putative 56-edge graph its degree is seven or eight, since deleting it leaves at most 49 edges and the average degree is eight. At degree seven the parent is one of six 49-edge graphs. Restoring minimum degree seven gives 10,296 candidates. At degree eight the graph is regular and its parent has 48 edges and minimum degree seven. nauty finds 37,014 admissible parents under that cap. Exactly 31,356 have eight vertices of degree seven and five of degree eight, and each gives a unique candidate. Two independent C checkers reject all **41,652** candidates across the two cases. The V2 checker finds a conflict clique exceeding the palette in 41,517 cases and rules out the remaining 135 by coloring search. [Parent search counts](data/13-48-k14-D5-cover.tsv) · [Extension program](native/extend_catalog.cpp) · [Six dense parents](data/order13-k14-e49.g6) · [Independent C checker](../M12/src/prune810b.c)

Exhausting the old colorings gives an independent extension test. The six degree-seven parents have 57 color partitions. The 31,356 eligible parents in the regular case have 4,637,631 partitions. Across both cases no partition permits a valid coloring of the restored spokes. [Exact spoke-list test](native/extend_colored.cpp) · [Counts by case](data/colored-extensions.tsv)

The following commands reproduce the regular-parent calculation using a nauty installation that includes `complg`. The extension program reads original supports and generates every neighborhood of the specified new minimum degree.

```sh
PRUNE_K=14 "$SCRATCH/rainbow-cover" -D5 13 30:30 | "$NAUTY/complg" -q > "$SCRATCH/parent48.g6"
"$SCRATCH/extend-catalog" 14 56 14 8 cover < "$SCRATCH/parent48.g6"
"$SCRATCH/extend-catalog" 14 56 14 7 cover < data/order13-k14-e49.g6
cc -O3 ../V12/V2/src/checker.c -o "$SCRATCH/check-independent"
"$SCRATCH/extend-catalog" 14 56 14 8 all < "$SCRATCH/parent48.g6" | "$SCRATCH/check-independent" 14
"$SCRATCH/extend-catalog" 14 56 14 7 all < data/order13-k14-e49.g6 | "$SCRATCH/check-independent" 14
```

## The 11,461 extremal graphs on 13 vertices

These graphs admit **173,139** optimal colorings up to vertex and color relabeling. Two independent counting algorithms give the same answer on every graph. [Colored census and Burnside calculation](coloring-census.md)

Checker A and the C++ cover solver independently found **11,461** nonisomorphic 47-edge graphs with 13 colors. Their complement graph6 records agree byte for byte in all 64 shards. Traces canonicalization found 11,461 distinct isomorphism classes. A third C program produced a coloring for every graph and verified every four-cycle. The archive contains the original graphs, one per line. Its SHA-256 is `965474347e8cc9efdd316d2b21e273823eb3ba1a488a17a9c8d33811dd32be69`. [Complete catalog](data/optimal-13.g6) · [Checker A counts](data/13-47-k13-A.tsv) · [C++ counts](data/13-47-k13-cover.tsv) · [Third checker](../V12/V2/src/checker.c)

| Colorings admitted by an optimal graph | Graphs |
| --- | ---: |
| Every valid coloring is proper | 10,809 |
| Both proper and improper colorings exist | 340 |
| Every valid coloring is improper | 312 |

Here a proper coloring gives distinct labels to all edges incident with the same vertex. For a proper-coloring test we add every such conflict. An improper coloring must equate a pair of incident edges whose outer endpoints have exactly one common neighbor. Contracting the corresponding two nonadjacent vertices of the conflict graph enforces that equality. The independent SAT audit lists four-cycles directly, validates every positive witness, and checks 6,000 negative queries. For 6,307 graphs every incident pair already lies on a four-cycle. [Classification program](native/classify_proper.cpp) · [Independent CaDiCaL audit](native/audit_proper_sat.cpp) · [Per-graph decisions and colorings](data/colorings-13.txt.gz)

Of the 312 supports that require an improper coloring, 307 admit a coloring with exactly one equal-colored incident pair. The other five require exactly two. For each of those five there are only two geometrically possible pairs, with disjoint edge sets. Ten additional UNSAT queries show that both equalities are forced. Consequently every valid coloring of each of these five graphs loses at least two edges when made proper by deletion with its colors fixed. [Colorings](data/colorings-13.txt.gz) · [SAT verification](native/audit_proper_sat.cpp)

One small certificate explains a forced repeat without a coloring search. Among 14 specified edges, 90 of the 91 pairs occur together on some four-cycle. With 13 colors the only remaining pair must receive the same label. The two edges in that pair meet at a vertex. [Certificate](data/forced-repeat.json) · [Short verifier](check_forced_repeat.py)

Two distinct optimal graphs are adjacent in the edge-exchange calculation if deleting one edge from each gives isomorphic graphs. The resulting graph of optimal supports has 903 components. Its largest contains 10,390 supports, while 782 are isolated. Allowing replacement of an entire vertex neighborhood gives 375 components, with 11,046 supports in the largest. Four-cycle counts among the optima range from 210 through 235. The calculation canonicalizes every deletion with nauty's Traces implementation. [Counts and distributions](data/geometry-13.json) · [Reproduction script, Python 3.10+](support_geometry.py)

```sh
PRUNE_K=13 "$SCRATCH/rainbow-cover" -u 13 31:31
cc -O3 ../V12/V2/src/checker.c -o "$SCRATCH/check-independent"
"$SCRATCH/check-independent" 13 < data/optimal-13.g6 > /dev/null
"$SCRATCH/classify-proper" 13 --witnesses < data/optimal-13.g6 > "$SCRATCH/proper.txt"
"$SCRATCH/audit-proper-sat" 13 < "$SCRATCH/proper.txt"
python3 check_forced_repeat.py
make -C "$NAUTY" labelg
python3 support_geometry.py data/optimal-13.g6 "$NAUTY/labelg"
```

At the two fixed-palette optima above, there are **six** supports with 13 vertices, 14 colors and 49 edges, and **three** with 14 vertices, 13 colors and 54 edges. For the latter, every vertex has degree at least seven since deleting it leaves at most 47 edges. This justifies the complement degree cap of six used for that census. [Six supports](data/order13-k14-e49.g6) · [Their search counts](data/13-49-k14-cover.tsv) · [Three supports](data/order14-k13-e54.g6) · [Their search counts](data/14-54-k13-cover.tsv)

The proper-recoloring census covers all 12,005,168 ten-vertex graphs. Exactly 398 admissible supports require two edge deletions before a new proper coloring becomes possible. All smaller admissible graphs need at most one. [Deletion costs and certificates](deletion-census.md)
