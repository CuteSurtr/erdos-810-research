# Exact maxima with twelve colors on fourteen and fifteen vertices

The maxima are **52 edges on 14 vertices** and **58 on 15 vertices** when every four-cycle must have four different colors. The first maximum has exactly three underlying graphs up to isomorphism. The second has exactly one such graph with a vertex of degree six. There can also be optimal 15-vertex graphs of minimum degree seven. [Explicit colorings](palette-witnesses.json) · [Three extremal 14-vertex supports](data/optimal-14-k12.g6)

On 14 vertices, the unrestricted 53-edge complement search returned zero after 2,616,367 pruning calls. A 52-edge graph has minimum degree at least six, since the largest 13-vertex graph with twelve colors has 46 edges. For minimum degree six, deleting such a vertex gives one of the 97 optimal 13-vertex supports. Restoring degree six produced 166,452 neighborhoods. A C solver using clique bounds and exact graph coloring rejected all of them. We matched the 97 parents against the earlier 64-shard enumeration by canonical labeling. [53-edge search](data/fixed-palette-upper.tsv) · [13-vertex census and bound](../2026-11-21/README.md) · [97 parents](data/optimal-13-k12.g6)

Minimum degree at least seven corresponds to maximum degree six in the complement. All 256 shards of the 14-vertex, 52-edge search finished and gave exactly three supports. Both decision programs accepted all three, and canonical labeling distinguishes them. Two have eight degree-seven vertices and six degree-eight vertices. The third has nine degree-seven vertices, four of degree eight and one of degree nine. Their witness colorings have 238, 240 and 246 rainbow four-cycles, respectively in the archived graph6 order. [Full search counts](data/14-52-k12-D6-cover.tsv) · [Extension counts](data/twelve-color-extensions.tsv)

For a hypothetical 59-edge graph on 15 vertices, deleting a vertex leaves at most 52 edges, so the minimum degree is at least seven. The average degree is $118/15<8$, forcing equality. Its degree-seven vertex can have any seven of the fourteen parent vertices as neighbors. The three parents therefore give $3\binom{14}{7}=10,296$ tests. The independent C and C++ programs both rejected every restoration. Deleting edges preserves admissibility, so this also excludes every larger edge count. For a second check, a 60-edge example would be 8-regular. Only the first two parents have the required degrees, and the new vertex's neighbors are forced. A clique bound rejects both.

At 58 edges, deleting a degree-six vertex also leaves a 52-edge parent. The two solvers agreed on exactly one accepted restoration among $3\binom{14}{6}=9,009$. Its explicit coloring has 295 rainbow four-cycles. Thus the degree-six optimum is unique up to isomorphism. [Lower-bound witness](palette-witnesses.json) · [Verifier](check_palette.py)

## Reproduction

Build the native programs as described in the archive. The graph6 parent files describe the actual supports. The 256 complementary searches use 39 missing edges. [Build instructions](native/README.md)

```sh
cc -std=c11 -O3 ../V12/V2/src/checker.c -o "$SCRATCH/check-v2"
PRUNE_K=12 "$SCRATCH/rainbow-cover" -u 14 38:38
for s in $(seq 0 255)
do
    PRUNE_K=12 "$SCRATCH/rainbow-cover" -D6 14 39:39 "$s/256"
done
"$SCRATCH/extend-catalog" 14 52 12 6 all < data/optimal-13-k12.g6 | "$SCRATCH/check-v2" 12
"$SCRATCH/extend-catalog" 15 59 12 7 all < data/optimal-14-k12.g6 | "$SCRATCH/check-v2" 12
"$SCRATCH/extend-catalog" 15 58 12 6 cover < data/optimal-14-k12.g6
python3 check_palette.py palette-witnesses.json
```
