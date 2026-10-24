# V12/V1: unpruned confirmation of M(12) = 40, shards r ≡ 1 (mod 4)

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
nproc: 4
Mem: 15 GiB total, 0 swap
```

## 2. Results

| Result | Status |
|---|---|
| Validation, n = 7..11 (10 rows): every good count matches | **proved** for these rows (exhaustive, unpruned) |
| Shards r ≡ 1 (mod 4) of `geng -q 12 41:41 r/512` (128 shards): **0 good graphs** | **proved** for this quarter (exhaustive, unpruned) |
| M(12) = 40 | **unfinished** here: this quarter is consistent with it, and the claim needs V0, V2 and V3 too |

**V1 shard sums (128 shards):**

| graphs | bad_by_clique | bad_by_search | good |
|---|---|---|---|
| **603,779,517** | 603,779,324 | 193 | **0** |

Cross-check: running `geng -u 12 41:41 r/512` separately on each of my 128 shards gives the
same graph count per shard as the checker read, and the total is 603,779,517. The four
agents' totals should add up to 2,411,961,516.

## 3. Certificates

No good graph, so there are no certificates. `certs.json` is `{}`.
The 131 good colourings from the n = 11, e = 34 validation are in `validation_n11_e34_good.txt`.

## 4. Method

**geng:** nauty 2.8.8, unpacked from the PyPI sdist `pynauty-2.8.8.1` (`src/nauty2_8_8`,
`./configure && make geng`). No pruning hook.

**Checker (`src/chk.c`):** written from scratch from the README definitions.
I did not read the M12, SAT or first-run code.
- It parses graph6 and lists the edges. Q(G) is built as 64-bit adjacency bitsets from the README's
  pairwise rules:
  - adjacent edges uv, vw conflict iff N(u) ∩ N(w) contains a vertex other than v;
  - disjoint edges uv, xy conflict iff (ux, vy ∈ E) or (uy, vx ∈ E).
- Fast path: it looks for a clique of size K+1 = n+1 in Q. The search is branch and bound
  (MCQ style), pruned by a greedy-colouring bound. If such a clique exists, the graph counts
  as `bad_by_clique`.
- Otherwise it runs an exact DSATUR backtracking search with K colours. The next vertex is
  the one with maximum saturation, ties broken by uncoloured degree. Colour symmetry is
  broken by opening at most one new colour per step. If no colouring exists, the graph
  counts as `bad_by_search`; if one is found, it counts as `good`.
- Every good colouring is re-checked by `verify_simple()`. It loops over all ordered 4-tuples
  of distinct vertices (a,b,c,d) that form a cycle, requires 4 distinct colours, and checks
  that every colour is in 0..K−1. Good graphs are printed as `g6 u-v:c ...`.
- `src/verify_good.py` re-checks that output independently in Python. It has its own graph6
  decoder, checks that the edge set matches, and enumerates 4-cycles with permutations. It
  verified all 131 n = 11 colourings and both n = 10 colourings.

**Validation (unpruned geng + checker; n = 11 run as 8 shards per edge count on 4 cores):**

| n | e | graphs | bad_by_clique | bad_by_search | good | expected |
|---|---|---|---|---|---|---|
| 7 | 14 | 65 | 60 | 0 | 5 | 5 ✓ |
| 7 | 15 | 41 | 40 | 1 | 0 | 0 ✓ |
| 8 | 17 | 980 | 935 | 0 | 45 | 45 ✓ |
| 8 | 18 | 663 | 662 | 1 | 0 | 0 ✓ |
| 9 | 23 | 10,120 | 10,110 | 7 | 3 | 3 ✓ |
| 9 | 24 | 5,995 | 5,995 | 0 | 0 | 0 ✓ |
| 10 | 30 | 136,433 | 136,431 | 0 | 2 | 2 ✓ |
| 10 | 31 | 71,318 | 71,318 | 0 | 0 | 0 ✓ |
| 11 | 34 | 24,630,887 | 24,629,964 | 792 | 131 | 131 ✓ |
| 11 | 35 | 15,108,047 | 15,108,045 | 2 | 0 | 0 ✓ |

**Main run:** 128 shards (r = 1, 5, …, 509),
run 4 at a time with `xargs -P4`.
- Per-shard wall time was 30–43 s; the sum is 4,279 s of shard wall time.
- The whole run took about 18 minutes, from 17:53 to 18:11 UTC.
- geng alone takes about 1.5 s per shard.

## 5. Code

- `src/chk.c`: checker. Build with `gcc -O3 -march=native -o chk chk.c` and run as `chk K`.
- `src/run_shard.sh`: runs one shard and appends a row to the TSV. Needs env `GENG`, `CHK`, `OUT`.
- `src/verify_good.py`: independent re-verifier of good colourings.
- `shards.tsv`: `r, graphs, bad_by_clique, bad_by_search, good, wall_s`.

## 6. Notes

- Almost every graph is decided by the clique fast path. Only 193 of 603.8 M needed the exact
  search, and none of them was colourable.
- The run is cheap, about 18 minutes on 4 cores, so the whole 512-shard unpruned run would take
  about 72 minutes on one 4-core container.
- Next step: sum the graph totals of V0..V3 against 2,411,961,516 and confirm good = 0 in all four.
