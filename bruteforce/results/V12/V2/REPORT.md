# V12/V2: unpruned confirmation of M(12) = 40, shards r ≡ 2 (mod 4)

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
nproc: 4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

## 2. Results

| result | value | status |
|---|---|---|
| validation n=7..11 (10 rows) | all match | exhaustive (unpruned geng + own checker) |
| shards r ≡ 2 mod 4 of `geng -q 12 41:41 r/512` | 128/128 done | exhaustive |
| graphs (isomorphism classes) in my shards | **601,165,216** | |
| bad_by_clique | 601,165,025 | |
| bad_by_search | 191 | |
| good | **0** | |

No 12-vertex, 41-edge graph in my 128 shards is good. Combined with the other three
V12 agents (whose graph totals together with mine must sum to 2,411,961,516), this
gives M(12) ≤ 40; with the Lean-checked lower bound, M(12) = 40.

## 3. Certificates

No good graphs at n = 12, e = 41, so `certs.json` is `{}`.
The 186 good certificates found in validation (n=7..11) are in `val/*.good`
(format `GOOD <graph6> u-v:colour ...`) and were all re-verified (below).

## 4. Method

- **geng**: nauty 2.8.8, from the PyPI sdist `pynauty-2.8.8.1`
  (`pip download --no-binary :all: --no-deps pynauty`, `src/nauty2_8_8`, `./configure && make geng`).
  No pruning hook.
- **Checker** (`src/checker.c`, written from scratch; no other agent's code was read):
  - parses graph6; edges indexed in (i<j) order; Q(G) built as 64-bit adjacency masks
    directly from the README's two pair definitions (adjacent edges sharing v conflict iff
    the other endpoints have a common neighbour ≠ v; disjoint uv, xy conflict iff
    ux,vy ∈ E or uy,vx ∈ E);
  - fast path: branch-and-bound clique search (greedy-colouring bound, Tomita style) for a
    clique of size K+1 = n+1 in Q → `bad_by_clique`;
  - otherwise exact DSATUR backtracking K-colouring (saturation, tie-break on uncoloured
    degree, symmetry breaking: a new colour may only be the next unused one; forward
    check that no uncoloured vertex loses all K colours) → `bad_by_search` or `good`;
  - every good colouring is re-verified in C by a 4-nested-loop enumeration of all
    4-cycles (colours in 0..K−1, 4 distinct per C4) before printing.
- **Extra checks**
  - `src/qtest.c`: Q from the pair definitions vs Q built from explicit C4 enumeration,
    on all 12,346 graphs on 8 vertices: 0 mismatches.
  - `src/verify_good.py`: independent Python graph6 decoder + 4-cycle check of all
    186 validation certificates: 186 verified, 0 failures.

### Validation (unpruned geng | checker; counts are isomorphism classes)

| n | e | graphs | bad_by_clique | bad_by_search | good | expected |
|---|---|---|---|---|---|---|
| 7 | 14 | 65 | 60 | 0 | 5 | 5 |
| 7 | 15 | 41 | 40 | 1 | 0 | 0 |
| 8 | 17 | 980 | 935 | 0 | 45 | 45 |
| 8 | 18 | 663 | 662 | 1 | 0 | 0 |
| 9 | 23 | 10,120 | 10,110 | 7 | 3 | 3 |
| 9 | 24 | 5,995 | 5,995 | 0 | 0 | 0 |
| 10 | 30 | 136,433 | 136,431 | 0 | 2 | 2 |
| 10 | 31 | 71,318 | 71,318 | 0 | 0 | 0 |
| 11 | 34 | 24,630,887 | 24,629,964 | 792 | 131 | 131 |
| 11 | 35 | 15,108,047 | 15,108,045 | 2 | 0 | 0 |

n = 11 was run as 16 res/mod shards per edge count, 4 in parallel (53 s total; script
`run_val11.sh`). Every row matches.

### Main run

`run_main.sh`: `geng -q 12 41:41 r/512 | src/checker 12` for r = 2, 6, …, 510, 4 shards in
parallel, one line per shard appended to `shards.tsv` (`r graphs bad_by_clique
bad_by_search good wall_s`). Pipe exit codes and the COUNTS line were checked for every
shard; no errors, no verify failures. Total DSATUR nodes over all shards: 83,498.

Timings: per shard 21.6–36.9 s wall (≈ 2.2 s of it geng), sum 3,705 s of shard time;
the whole 128-shard run took 15 min wall on 4 cores (17:54–18:09 UTC).

## 5. Code

- `src/checker.c` — checker (`gcc -O3 -march=native -o src/checker src/checker.c`)
- `src/qtest.c` — Q-construction cross-check
- `src/verify_good.py` — independent certificate verifier
- `run_val11.sh`, `run_main.sh` — drivers (geng path is the local build in /tmp)
- `val/` — validation good-graph certificates and count files
- `shards.tsv` — per-shard results

## 6. Notes

- Almost everything (99.99997%) is killed by a 13-clique in Q; only 191 graphs needed the
  colouring search, each tiny (83k DSATUR nodes in total).
- The checker at ~5 µs/graph is fast enough that the full 512-shard unpruned run would take
  about an hour on one 4-core container.
- Possible strengthening: emit the 13-clique (or the bad_by_search graphs) per graph for an
  independent re-check by a second program/SAT solver.
