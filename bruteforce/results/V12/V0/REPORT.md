# V12/V0 — unpruned confirmation of M(12) = 40, shards r ≡ 0 (mod 4)

## 1. Placement

```
$ uname -a; nproc; free -g
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

All computation ran in this cloud container (2026-10-24, 17:49–19:25 UTC).

## 2. Results

| Result | Value | Status |
|---|---|---|
| Validation n=7..11 (10 rows) | all match | proved (exhaustive, matches known table) |
| Shards r ≡ 0 mod 4 of `geng -q 12 41:41 r/512` (128 shards) | 605,033,974 graphs, **0 good** | exhaustive over this shard set (my 1/4 share) |
| Clique+DSATUR breakdown | bad_by_clique 605,033,789; bad_by_search 185; good 0 | — |
| DSATUR-only second pass (`-noclique`), same 128 shards | 605,033,974 graphs, all bad_by_search, **0 good**; per-shard graph and good counts identical to the main run | exhaustive over this shard set |

M(12) = 40 follows only once all four V12 agents report 0 good and their graph totals sum
to 2,411,961,516. **My total: 605,033,974 graphs, 0 good.**

## 3. Certificates

No good 12-vertex 41-edge graph was found, so there is no certificate. `certs.json` is `{}`.

## 4. Method

### 4.1 geng
nauty **2.8.8**, from PyPI `pynauty-2.8.8.1` sdist (`pip download --no-binary :all: --no-deps pynauty`),
built with `./configure && make geng` in `src/nauty2_8_8`. gcc 13.3.0.
Shard command exactly: `geng -q 12 41:41 r/512` for r = 0, 4, …, 508.

### 4.2 Checker (`src/checker.c`, written from scratch; no other repo code read)
- Parses graph6 (n ≤ 16), lists edges, builds Q(G) as 64-bit adjacency masks per the README:
  adjacent edges p–s, s–q conflict iff p, q have a common neighbour w ∉ {s}; disjoint uv, xy
  conflict iff (ux, vy ∈ E) or (uy, vx ∈ E).
- **Fast path:** branch-and-bound clique search (greedy-colouring bound, Tomita style) for a clique
  of size K+1 = 13 in Q; found ⇒ `bad_by_clique`.
- **Otherwise:** exact DSATUR backtracking with K colours (max saturation, tie-break by uncoloured
  degree; new colour only as the next unused index). Fails ⇒ `bad_by_search`.
- Good ⇒ colouring re-verified inside C by brute 4-tuple enumeration of 4-cycles on G (not on Q),
  then printed as `GOOD <g6> u-v:c ...`.
- `-noclique` skips the fast path (DSATUR decides everything) — used for cross-checks.
- `src/verify_good.py`: separate, deliberately simple Python re-checker of GOOD lines
  (own graph6 decoder, edge set equality, colour range, all ordered 4-tuples).

### 4.3 Validation (unpruned geng + checker)

| n | e | graphs | bad_by_clique | bad_by_search | good | expected | `-noclique` good | Python re-check |
|---|---|---|---|---|---|---|---|---|
| 7 | 14 | 65 | 60 | 0 | 5 | 5 | 5 | 5/5 ok |
| 7 | 15 | 41 | 40 | 1 | 0 | 0 | 0 | — |
| 8 | 17 | 980 | 935 | 0 | 45 | 45 | 45 | 45/45 ok |
| 8 | 18 | 663 | 662 | 1 | 0 | 0 | 0 | — |
| 9 | 23 | 10,120 | 10,110 | 7 | 3 | 3 | 3 | 3/3 ok |
| 9 | 24 | 5,995 | 5,995 | 0 | 0 | 0 | 0 | — |
| 10 | 30 | 136,433 | 136,431 | 0 | 2 | 2 | 2 | 2/2 ok |
| 10 | 31 | 71,318 | 71,318 | 0 | 0 | 0 | 0 | — |
| 11 | 34 | 24,630,887 | 24,629,964 | 792 | 131 | 131 | not run | 131/131 ok |
| 11 | 35 | 15,108,047 | 15,108,045 | 2 | 0 | 0 | not run | — |

n = 11 was run as `geng -q 11 e:e r/16`, 16 shards, 4 parallel (`src/val11.sh`), 78 s wall.
Every row matches. Verifier sanity: corrupting 20 good colourings (two edges forced equal)
made `verify_good.py` reject all 20.

### 4.4 Main run
`src/run_shard.sh r` (4 parallel via `xargs -P4`) → `shards.tsv`.
Sum over 128 shards: graphs **605,033,974**, bad_by_clique **605,033,789**, bad_by_search **185**,
good **0**. Per-shard wall 38.5–54.6 s (4 jobs concurrently), total 5,870 core-s, ~25 min wall
(17:55–18:19 UTC). Every shard satisfies graphs = bad_by_clique + bad_by_search + good;
all 128 residues present.

### 4.5 Second method: DSATUR alone
I ran the same 128 shards again with `checker 12 -noclique`, so exact DSATUR decides every graph
and the clique search is never used (`shards_noclique.tsv`). Result: 605,033,974 graphs,
605,033,974 bad_by_search, 0 good. Graph and good counts match `shards.tsv` shard by shard
(128/128). Wall per shard 98–146 s (4 concurrent), 15,322 core-s, 18:20–19:24 UTC.
This pass checks the clique fast path independently. It does not check Q-construction or geng,
which both passes share; for those the evidence is the n ≤ 11 validation above (and, for n ≤ 10,
`-noclique` also matches).

## 5. Code and files
- `src/checker.c`: checker (`gcc -O3 -march=native -o checker checker.c`; binary is gitignored).
- `src/run_shard.sh`: one shard → one TSV row (env `GENG`, `CHECKFLAGS`, `OUTDIR`, `TSV`).
- `src/val11.sh`: n = 11 validation, 16 shards.
- `src/verify_good.py`: independent re-checker for GOOD lines.
- `shards.tsv`: main run (clique + DSATUR). `shards_noclique.tsv`: DSATUR-only run.
- `certs.json`: `{}` (no good graph).

Reproduce one shard:
`geng -q 12 41:41 r/512 | src/checker 12` (≈45 s on one core) or with `-noclique` (≈120 s).

## 6. Surprises and next steps
- The fast path settles nearly everything. Only 185 of 605M graphs lack a 13-clique in Q, and
  DSATUR proves each of those 185 non-12-colourable.
- DSATUR alone is also cheap (about 25 µs per graph). An unpruned exhaustive run of all
  2.41e9 graphs takes about 4.3 core-hours with either method.
- Operational note: my first launch wrote shard outputs inside the repo. A `git pull --rebase`
  then replaced files that running jobs held open, so the first 4 shards produced empty outputs
  and the shard script reported them as failed. No rows were recorded. I killed that run, moved
  outputs to /tmp, and restarted from scratch. All numbers above come from the clean restart.
- Next step: add the four V12 totals and check they sum to 2,411,961,516. If they do and all
  report 0 good, M(12) = 40 has an unpruned confirmation (lower bound already Lean-certified).
