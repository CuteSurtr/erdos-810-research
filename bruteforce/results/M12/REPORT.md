# Task M12: M(12), re-verification of M(10) and M(11), scoping of M(13)

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

All computation ran in this cloud container (4 cores, 15 GB) on 2026-10-24, 16:05–21:00 UTC.
The schedule changes of 16:05 UTC applied:

- the deadline was 21:00;
- section 1 was cut to n = 7..9 plus the n = 11 pruned-versus-unpruned check;
- section 3 targets n = 13 at 48 edges.

## 2. Results

| Claim | Status | Evidence |
|---|---|---|
| M(7)=14, M(8)=17, M(9)=23 reproduced (good graph at M, none at M+1) | **proved** (exhaustive, two methods) | §4.2 |
| M(10)=30: 2 good 30-edge graphs, 0 good among 71 318 graphs with 31 edges | **proved** (pruned A, pruned B, unpruned A all agree; SAT agrees) | §4.2 |
| M(11)=34: 131 good 34-edge graphs, 0 good among 15 108 047 graphs with 35 edges | **proved** (pruned A = unpruned A = pruned B, identical 131-graph sets; all 131 re-checked by SAT) | §4.2 |
| **No 12-vertex graph with 41 edges is 12-good** | **proved** (exhaustive checker A, all 512 shards; independent checker B on Δ ≤ 9, 512/512 shards; Δ = 10, 11 by SAT's DRAT-checked cubes) | §4.3 |
| M(12) ≥ 40 | **certificate-verified** (`certs.json["12"]`) | §3 |
| **M(12) = 40** | **proved** | the two rows above |
| Good 12-vertex 40-edge graphs: max degree ∈ {7, 8, 9}; Δ ≤ 9 counts exact, see §2.3 | Δ ≤ 9: *unfinished* at the time of writing (see §2.3 for the final shard count); Δ ≥ 10: *partial* (181/512 full-range shards, none found) | §2.3 |
| n = 13, e = 48 | **unfinished**: 3 shards of 16 384 done (0 graphs), plan in `M13_PLAN.md` | §2.4 |

A good 41-edge graph would have been an output of the pruned run, and there were none, so the
task's request for "a second checker on every graph output at 41 edges" is vacuous.

### 2.1 Pólya count of isomorphism classes (independent of geng)

`src/polya.py` gives these counts, with geng's own totals alongside (`logs/polya.txt`):

| n, e | Pólya | geng |
|---|---|---|
| 10, 31 | 71 318 | 71 318 |
| 11, 34 | 24 630 887 | 24 630 887 |
| 11, 35 | 15 108 047 | 15 108 047 (also the sum of the 3 unpruned shards) |
| 12, 41 | 2 411 961 516 | 2 411 961 516 (`geng -u`, 856 s) |
| 12, 40 | 3 765 262 970 | — |
| 13, 48 | 584 089 835 857 | — |

The task file's figure of "2.19e9 graphs" for (12, 41) is wrong. The true count is 2.41e9.

### 2.2 Comparison with `data/first-run/` (done only after my own runs)

- **n = 11, 34 edges.** My 131 good graphs are byte-identical, after `sort`, to the graph6
  column of `n11_e34_good.certs`. Exactly one of them is 10-colourable, as the first run said
  (`filt 10`: 1 of 131; `filt 9`: 0).
- **n = 10.** 2 good 30-edge graphs, as the first run said.
- **n = 12, 41 edges.** The first run measured 6–9 CPU-s per shard. Mine took 12–38 CPU-s,
  measured on a contended 4-core box.

I did not reuse any first-run code. `prune810m.c`, `qcol.h`, `prune810b.c`, `filt.c` and
`satcheck.py` were all written from scratch.

### 2.3 Maximum-degree distribution of good 12-vertex 40-edge graphs (for SAT's cube plan)

At 41 edges SAT's open cubes are Δ = 7, 8, 9. The good 40-edge graphs found here:

- **Run `-D9` (Δ ≤ 9, pruned checker A).** This is the exact Δ ≤ 9 census once all 512 shards
  are done. The final numbers are in `shards_n12_e40-D9.tsv` and the summary in
  `logs/degdist_n12_e40_D9.txt`.
- **Full-range run.** 181 of 512 shards finished (`shards_n12_e40.tsv`; the run was stopped to
  free cores). It found 1 126 good graphs: Δ = 7: 410, Δ = 8: 715, Δ = 9: 1, **Δ ≥ 10: 0**.

Note that res/mod shard numbers are not comparable between the `-D9` and full-range runs,
because `-D` changes geng's tree. Only totals can be compared.

Takeaways for SAT:

- Good 40-edge graphs are almost all Δ ∈ {7, 8}.
- Δ = 9 is extremely rare (2 graphs in 438 `-D9` shards).
- No Δ ≥ 10 graph appeared in 35 % of the full space.
- The most common degree sequences are 8 7⁶ 6⁵ and 7⁸ 6⁴.

This fits SAT's findings: Δ = 7 and 8 are the dense, hard cubes, and Δ = 9 is nearly empty but
hard to refute.

### 2.4 n = 13, e = 48 (scoping)

Pruned checker A with `geng 13 48:48 r/16384`:

- shards 5000, 10000 and 6000 finished in 585, 420 and 619 CPU-s, with 0 graphs;
- shard 2500 passed 80 CPU-min without finishing;
- shards 0 and 3000 died without output (cause unknown) and are **not counted**.

The estimate is at least about 7 300 CPU-h for the whole space. See `M13_PLAN.md` for exact
commands, the split and cheaper routes.

## 3. Certificates

`certs.json` uses the format `{"n": [[u, v, colour], ...]}` with vertices and colours in 0..n−1.
It holds one good graph each for n = 10 (30 edges), 11 (34) and 12 (40). The colourings come
from `satcheck.py --cert`. They are re-verified by `src/check_cert.py`, a deliberately simple
checker that enumerates all ordered 4-tuples of distinct vertices and checks that every 4-cycle
has 4 distinct colours, that colours lie in range and that no edge repeats:

```
n=10: 30 edges, 760 ordered 4-cycle tuples, OK
n=11: 34 edges, 904 ordered 4-cycle tuples, OK
n=12: 40 edges, 1240 ordered 4-cycle tuples, OK
```

All 131 good n = 11 graphs with SAT colourings are in `out/n11_e34_satcheck.txt`, and both
n = 10 graphs are in `out/n10_e30_satcheck.txt`. Every good 12-vertex 40-edge graph found is in
`out/n12_e40*/<res>.g6`, as graph6.

## 4. Method

### 4.1 Checkers

- **A (`src/qcol.h`).** Builds Q as 64-bit adjacency masks from the pairwise rules in the
  README:
  - adjacent uv, vw conflict iff A[u] ∧ A[w] has a vertex other than v;
  - disjoint ab, cd conflict iff (b~c ∧ a~d) or (b~d ∧ a~c).

  It then strips the K-core (vertices of Q-degree < K are always colourable last) and applies
  a greedy clique lower bound from every vertex. Last comes exact DSATUR with incremental
  per-colour counters and the new-colour-only-as-next-index rule. A is used both as the geng
  PRUNE hook (`src/prune810m.c`) and in the stdin filter `src/filt.c`.
- **B (`src/prune810b.c`).** Separately written and shares no code with A. It finds conflicts
  by enumerating every 4-subset and its 3 possible 4-cycles (explicit C4 enumeration). It peels
  edges with fewer than K live conflicts and applies its own greedy clique bound (array-based,
  edges in index order). Then it backtracks, always branching on the uncoloured edge with the
  fewest available colours. Forbidden sets are recomputed from scratch at every node, with a
  forward check (fail if any edge has 0 colours left), and a new colour is only ever the next
  index. My first two versions of B (static order, then max-connectivity order, with no peeling
  or clique bound) were correct on n ≤ 10 but 7–8× slower, so I replaced them.
- **SAT (`src/satcheck.py`, CaDiCaL 1.9.5 via python-sat).** Enumerates all ordered 4-tuples
  (a, b, c, d), with one at-least-one-colour clause per edge and pairwise exclusion per 4-cycle
  per colour. Edge i (0-based) is restricted to colours ≤ i, which is sound by renumbering
  colours in order of first occurrence.
- **Prune soundness.** For a fixed K, K-goodness is closed under vertex deletion. geng's
  intermediate graphs are induced subgraphs of its outputs, and geng calls PRUNE on the final
  graphs too, so every output is K-good. K = maxn (= n).

### 4.2 Validation

Validation on n = 6..11 (`logs/`):

| n, e | geng classes | unpruned A (`filt`) good | pruned A | pruned B | SAT good |
|---|---|---|---|---|---|
| 6, 11 / 12 | 9 / 5 | 1 / 0 | 1 / 0 | 1 / 0 | — |
| 7, 14 / 15 | 65 / 41 | 5 / 0 | 5 / 0 | 5 / 0 | 5 / 0 |
| 8, 17 / 18 | 980 / 663 | 45 / 0 | 45 / 0 | 45 / 0 | 45 / 0 |
| 9, 23 / 24 | 10 120 / 5 995 | 3 / 0 | 3 / 0 | 3 / 0 | 3 / 0 |
| 10, 30 / 31 | 136 433 / 71 318 | 2 / 0 | 2 / 0 | 2 / 0 | 2 / 2 checked |
| 11, 34 | 24 630 887 | 131 | 131 (112.5 s) | 131 (102.7 s) | 131 / 131 |
| 11, 35 | 15 108 047 | 0 | 0 (48.7 s) | 0 (49.1 s) | — |

At n = 11, 34 edges, the unpruned, pruned-A and pruned-B sets of 131 graphs are identical, and
also identical to the first run's set. The SAT column checks every graph for n ≤ 9. For
n = 10, 11 it checks the good outputs.

### 4.3 n = 12, e = 41

- **Checker A, the main run.** `geng_prune 12 41:41 r/512` for r = 0..511, all 512 shards.
  The logs `logs/n12_e41/<r>.log` each end in `>Z 0 graphs generated`. Per-shard figures are in
  `shards.tsv` (res, graphs_out, good, cpu_s):
  - total 9 165 CPU-s;
  - per shard, min 12.2 s and max 37.8 s;
  - about 4.62e8 PRUNE calls, 4.14e8 of them rejected.

  Shards 22–25 were killed once by accident and re-run from scratch. Their rows are the re-runs.
- **Checker B.** `geng_pruneb -D9 12 41:41 r/512` for r = 0..511, all 512 shards, 0 graphs,
  7 328 CPU-s (`shardsB_n12_e41-D9.tsv`). This covers every 41-edge graph with Δ ≤ 9.
  Δ ≥ 7 holds automatically, since 12·6/2 = 36 < 41. Graphs with Δ = 10, 11 are covered by
  task SAT's DRAT-checked UNSAT cubes. So A covers everything once, and B with SAT covers
  everything a second time with independent code.

  An earlier B run without `-D9` did shards 0–19 (0 graphs, 994 s, `shardsB_n12_e41.tsv`).
  It is kept for the record but is **not** part of the coverage argument, because shard
  numbering differs between `-D9` and full-range runs.
- **Unpruned cross-check (partial).** `geng_plain -q 12 41:41 r/512 | filt 12` covered shards
  r = 0..31: 156 266 375 graphs, 0 good (`unpruned_n12_e41.tsv`). Each shard took about 116 s
  wall time. It was stopped there because the full run would take about 16 core-hours.
  Shard 32 was interrupted and is not counted.

### 4.4 Software

- **nauty 2.8.8.** The nauty sites were blocked (HTTP 403), so I took the source bundled in
  the PyPI sdist `pynauty-2.8.8.1` (`src/nauty2_8_8`), then ran `./configure && make geng`.
  `geng_plain` is that geng binary.
- **python-sat 1.9.dev17** (CaDiCaL 1.9.5), run with python3.13. gcc 13.3 with `-O3 -march=native`.

## 5. Files

- `src/`:
  - `qcol.h`, `prune810m.c`: checker A and its PRUNE hook.
  - `prune810b.c`: checker B.
  - `filt.c`: graph6 filter.
  - `satcheck.py`: SAT checker.
  - `check_cert.py`: simple certificate checker.
  - `polya.py`: Pólya count.
  - `degdist.py`: degree statistics.
  - `build.sh`: builds `filt`, `geng_prune` and `geng_pruneb`. Set `NAUTY` to the configured
    nauty dir.
  - `shard.sh`, `shardb.sh`: one shard each. `GENG_EXTRA=-D9` passes extra geng flags.
  - `run_unpruned11.sh`, `unpruned12.sh`.
- `shards.tsv` (A, 12/41), `shards_n12_e41.tsv` (same rows, unsorted, no header),
  `shardsB_n12_e41-D9.tsv`, `shardsB_n12_e41.tsv`, `shards_n12_e40.tsv`,
  `shards_n12_e40-D9.tsv`, `shards_n13_e48.tsv`, `unpruned_n12_e41.tsv`.
- `logs/`: geng logs per shard, plus n ≤ 11 logs, `polya.txt` and `satcheck_n7_9.txt`.
- `out/`: graph6 outputs. Only non-empty files are kept.
- `certs.json`, `M13_PLAN.md`.

## 6. Surprises and next steps

- **The task's graph count for (12, 41) was wrong.** It said 2.19e9; the true count is
  2 411 961 516. geng and the Pólya count agree.
- **`-D9` speeds up the pruned enumeration about 5.6×.** Running geng split by Δ, with SAT
  handling the high-Δ cubes, is a good recipe for n = 13. Note that res/mod shard numbering
  depends on every geng option, so a shard set only counts as complete when one option set
  covers all of its residues.
- **Process deaths.** Three geng processes died silently: n = 13 probes 0 and 3000, and
  n = 12/40 shards killed by my own `pkill -f` patterns, which also matched the parent shell.
  Every shard counted above has a `>Z` line in its log. Use PIDs, not `pkill -f`.
- **Next for SAT's n = 12, e = 41 cubes.** They are now redundant for the M(12) result: A alone
  is exhaustive, and B plus SAT's finished cubes form a second complete method. Finishing
  Δ = 7, 8, 9 with DRAT would add a third, proof-checked method.
- **M(13).** Do not brute-force e = 48 blindly (about 7 300+ CPU-h). Follow `M13_PLAN.md`:
  sample about 64 shards at MOD = 65536 first, then split by Δ.
