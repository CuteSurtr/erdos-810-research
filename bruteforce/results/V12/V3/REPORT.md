# V12/V3: unpruned confirmation of M(12) = 40, shards r ≡ 3 (mod 4)

## 1. Placement

```
$ uname -a; nproc; free -g
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```
CPU: Intel Xeon @ 2.10GHz (4 vCPU). gcc 13.3.0. All computation stayed in this cloud container.

## 2. Results

| Result | Value | Status |
|---|---|---|
| Validation n=7..11 (10 rows) | all 10 rows match | proved (exhaustive, validated) |
| My 128 shards (r = 3, 7, …, 511 of `geng -q 12 41:41 r/512`) | 601,982,809 graphs, **0 good** | proved for these shards (exhaustive, unpruned) |
| bad_by_clique | 601,982,625 | |
| bad_by_search | 184 | |
| good | 0 | |
| geng count of all 512 shards (`geng -u`) | 2,411,961,516 = Pólya count | count check |
| M(12) = 40 | follows once V0–V2 also report 0 good on their shards | *unfinished* here (needs the other three agents) |

Per-shard counts for my shards agree exactly with an independent `geng -u` count
(`geng_counts_all512.txt`, 0 mismatches). That file also gives the counts of every
other agent's shards, so their graph totals can be checked line by line:
V0 (r≡0) + V1 + V2 + V3 must add up to 2,411,961,516. My total is **601,982,809**.

## 3. Certificates

No good 12-vertex, 41-edge graph was found, so there is no certificate. `certs.json` is `{}`.
The 131 good graphs for n=11, e=34 found during validation are in
`validation_good_n11_e34.txt` (graph6 then `u-v:colour` per edge). Each colouring was
re-verified by the simple 4-cycle checker.

## 4. Method

**geng.** nauty 2.8.8, taken from the PyPI sdist `pynauty-2.8.8.1.tar.gz`
(`pip download --no-binary :all: --no-deps pynauty`), built with `./configure && make geng`
in `src/nauty2_8_8`. No PRUNE hook.

**Checker** (`src/chk.c`). I wrote it from the README definitions only. I did not read the
M12, SAT or first-run code. For each graph6 line with K = n:
1. Build Q(G) from the two README rules. Adjacent edges sp, sq conflict iff p and q have a
   common neighbour w ≠ s. Disjoint edges uv, xy conflict iff ux, vy ∈ E or uy, vx ∈ E.
   Q is stored as 64-bit adjacency bitsets.
2. **Peel.** Repeatedly delete Q-vertices with degree < K in the remaining graph. This is
   sound for both tests: such a vertex cannot lie in a (K+1)-clique, and it can always be
   coloured last.
3. **Clique fast path.** Exact branch and bound for a (K+1)-clique in the core, using
   greedy-colouring bounds (Tomita style) with no node limit. Finding one gives
   `bad_by_clique`.
4. **Exact search.** DSATUR backtracking with K colours: pick the most saturated vertex
   (ties broken by uncoloured degree), allow only colours ≤ max used + 1 (symmetry
   breaking), and fail when a vertex has all K colours forbidden. Failure gives
   `bad_by_search`. On success the peeled vertices are coloured greedily in reverse peel
   order.
5. **Re-verify** every good colouring with a deliberately simple checker. It loops over all
   ordered 4-tuples (a, b, c, d) of distinct vertices with ab, bc, cd, da ∈ E, checks that
   the 4 edge colours are distinct, and checks that every colour is in 0..K−1. A failure is
   counted and reported, and none occurred.

Counts go to stderr as `graphs bad_by_clique bad_by_search good`.

**Validation** (unpruned `geng -q n e:e | chk n`; n=11 split into 16 shards per edge count):

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

The n=11 per-shard rows are in `validation_n11_shards.tsv`. n=11 took 73 s wall on 4 cores.

**Main run.** `src/run_shard.sh 12 41 r 512 <dir>` runs `geng -q 12 41:41 r/512 | chk 12`.
128 shards ran via `xargs -P4` from 17:54:27 to about 18:27 UTC, which is about 33 min wall.
The sum of per-shard wall times is 5,534 s, or 34.5–52.6 s per shard with 4 running at once.
Every pipeline exited with status 0. Totals across all shards were 7.83·10⁹ clique-search
nodes and 71,189 DSATUR nodes, with 0 verify failures. `shards.tsv` columns:
`r graphs bad_by_clique bad_by_search good wall_s`.

## 5. Code

- `src/chk.c`: checker. Build with `gcc -O3 -march=native -o chk chk.c`; the binary is gitignored.
- `src/run_shard.sh`: one shard. `src/collect.sh` assembles `shards.tsv`.

## 6. Notes and next steps

- Only 184 of 601,982,809 graphs needed the colouring search. Everything else had a
  13-clique in Q. The search is tiny: 71k DSATUR nodes in total.
- Once V0–V2 finish, add up the four `good` columns. If all are 0, the unpruned run
  independently confirms M(12) = 40. The upper bound comes from these runs, and the lower
  bound is the existing Lean-checked certificate.
- The whole 512-shard job takes about 2.2 h on 4 cores with this checker, so one agent
  could also do a full re-run.
