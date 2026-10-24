# M(13) scoping plan (task M12, section 3)

Status of n = 13: the lower bound is M(13) ≥ 47, certificate-verified by task SAT (`../SAT/certs.json`).
Deciding M(13) = 47 needs a proof that **no 13-vertex graph with 48 edges is 13-good**.
This file says what that costs with the pruned geng pipeline from this folder.
The answer is that it is too expensive to run blindly. The figures follow.

## Command

Build as described in `REPORT.md` §5 (`src/build.sh`). Then, for shard `r` of `MOD`:

```sh
./src/shard.sh 13 48 r MOD
# equivalently: ./src/geng_prune 13 48:48 r/MOD > out/n13_e48/r.g6 2> logs/n13_e48/r.log
```

The PRUNE hook uses K = maxn = 13 colours. It is sound for the same reason as at n = 12:
K-goodness is hereditary and geng's intermediate graphs are induced subgraphs of its outputs.
Every output graph is 13-good. Re-check outputs with `./src/filt 13` and `src/satcheck.py`.

## Measurements (MOD = 16384, 4-core container shared with other jobs)

| res | graphs out | CPU s | status |
|---|---|---|---|
| 5000 | 0 | 585 | finished |
| 10000 | 0 | 420 | finished |
| 6000 | 0 | 619 | finished |
| 2500 | — | > 4 750 (still running at 20:25 UTC) | unfinished |
| 0 | — | > 750 when the process died | unfinished, died without output (cause unknown) |
| 3000 | — | process died after under 8 min | unfinished, died without output |

The final list of finished shards is in `shards_n13_e48.tsv`. Shards are very uneven:
three took 7–10 CPU-minutes and one took more than 80 CPU-minutes.

## Cost estimate

Taking the sample mean as a lower bound (the slow shard counted at its elapsed time) gives
about 1 600 CPU-s per shard. Then

- 16 384 shards × ~1 600 s ≈ **7 300 CPU-hours**. This is a lower bound, because the sample is
  tiny and the distribution has a heavy tail.
- With N cloud agents of 4 cores and about 4.5 usable hours each (~18 CPU-h per agent),
  this needs **about 400 agent-sessions**: N = 50 agents would take about 8 rounds.
- Before committing to that, run about 64 random shards to pin down the mean. That costs about
  30 CPU-h, so 2 agents for one session.

Recommended split if it is run: `MOD = 65536` (smaller, more even shards). Agent i of N takes
`res ≡ i (mod N)` and appends to `shards_n13_e48.tsv` with columns `res, graphs_out, good, cpu_s`.
Any shard whose log lacks a `>Z` line must be re-run.

## Cheaper routes worth trying first

1. **Task SAT's cube approach.** n = 12, e = 41 was within reach there except for the
   Δ = 7..9 cubes. For n = 13 at 48 edges, the observed degree structure at n = 12 suggests where
   to cube. Every good 12-vertex 40-edge graph has Δ ∈ {7, 8, 9} (see `REPORT.md` §2.3).
2. **Degree pruning from a fixed-K hereditary bound.** Let M_K(n) be the maximum edge count of an
   n-vertex graph whose Q is K-colourable. If G is a 13-good graph with 48 edges, then G − v is
   a 12-vertex 13-good graph, so deg v ≥ 48 − M_13(12). Computing M_13(12) (geng 12 vertices,
   `PRUNE_K=13`) and passing the resulting minimum degree to geng with `-d` cuts the final level.
   That cut is weak, because geng applies `-d` mainly at the last level. A PREPRUNE-level
   degree-feasibility check would be stronger.
3. **Restricting maximum degree, as done here for checker B.** At n = 12, `-D9` cut the cost
   5.6× (shard 300: 12.6 s against 70.4 s). For n = 13, separate runs per Δ range let SAT and geng
   split the work, with SAT taking high Δ, where its cubes were easy at n = 12.
