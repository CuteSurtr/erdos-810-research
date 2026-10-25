## Per-n procedure as run, and timings

- **First pass** (`src/drive.py`, `src/queue.sh`, `src/queue2.sh`): about 25 min wall per n. At each k a
  three-way portfolio runs in parallel:
  - kissat with sym 2, seed 0;
  - kissat with sym 1, seed 1;
  - CaDiCaL with sym 2, writing DRAT.

  The first decisive answer wins and the others are killed. The driver climbs while SAT. Because the
  constraint is Σp ≥ k, a model may exceed k, and the driver then jumps past it. (This fix arrived after
  n = 61, which lost about 2 min on an already-satisfied k = 15.)
- **k_lo seeds**: CONSTR values (39: 9, 48: 11, 50: 11, 61: 13, 71: 14). For n = 80, the rule ⌊n/4⌋ − 2 = 18
  gave UNKNOWN after 900 s. So 80, 82 and 93 started from 15, 15 and 17 and climbed. CONSTR's annealer `cyc`
  reached only k = 15 at n = 80 in 400 s.
- **n ≡ 0 (mod 4), k = n/4**:
  - n = 48, k = 12: the first-pass portfolio hit its 1500 s cap, and a second-pass kissat `--sat` run ran until 09:55.
  - n = 80, k = 20: only 60 s per configuration in the first pass, because k = 17 was already UNKNOWN.
    The second pass went to n = 80, k = 17 instead.
- **Second pass** (`src/phase2.sh`, 08:36–09:55): single kissat `--sat` runs on n = 48 k = 12, n = 61 k = 16,
  n = 80 k = 17, and n = 50 k = 12 (n = 50 only after the n = 39 DRAT job finished).
- Every SAT model is decoded and re-checked by `src/check.py` inside `run.py`. Then
  `src/check_certs.py` re-checks `certs.json` from the explicit edge lists only, by brute-force
  4-cycle enumeration (output in `check_certs.txt`).
- Raw per-run records, one JSON line per solver process: `runs.jsonl` and `validation.jsonl`.
  Seconds in `table.tsv` are portfolio wall time summed over the k values tried.

## Code (`src/`)

| file | role |
|---|---|
| `cycenc.c` | DIMACS encoder (build: `gcc -O2 -o cycenc cycenc.c`) |
| `run.py` | encode, run kissat / CaDiCaL (+ drat-trim), decode, verify; one JSON line |
| `check.py` | simple explicit-graph 4-cycle checker used on every model |
| `check_certs.py` | independent checker on `certs.json` (explicit edges only) |
| `brute_small.py` | SAT-free exhaustive search for small n (second method) |
| `count_p.py`, `orbits.py` | solution counts with and without symmetry breaking, and the orbit comparison |
| `drive.py`, `queue.sh`, `queue2.sh`, `phase2.sh` | drivers as actually run |
| `make_table.py` | builds `table.tsv`, `solutions.json`, `certs.json` from `runs.jsonl` |
| `commit.sh` | checkpoint commits from a scratch worktree (see the surprises section) |

Solver binaries and CNF/DRAT files are not committed (`.gitignore`).

## Surprises and suggested next steps

1. **The task table is wrong for n = 14.** k_max(14) = 3, not 4. CONSTR's own JSON agrees with 3.
   Evidence: DRAT-verified UNSAT plus a SAT-free exhaustive search.
2. **k = n/4 stops being reachable quickly in practice.** For n = 39, k = 10 is UNSAT, so k_max(39) = 9 < 39/4.
   For n = 48 and 50, k = 12 was not found in 25 min of portfolio time (plus the second pass for n = 48).
   For n = 80 and 82 the best found is 16 = 0.20n, and for n = 93 it is 18 = 0.194n.
   **SAT difficulty, not proved upper bounds, limits all n ≥ 48.** Every k_lo there is only a lower bound.
3. **n = 61 is an outlier on the high side.** k = 15 gives k/n = 0.2459, beating CONSTR's 13 and every other n
   in this row. For the 71 / 80 / 82 / 93 range, prime n look friendlier than composite n. A targeted search
   over prime n (multiplier-invariant D, e.g. unions of cosets of a subgroup of Z_n^×) is the natural follow-up.
   The CYCPAT task does exactly that.
4. **New M(n) lower bounds** (certificate-verified): M(61) ≥ 915 (CONSTR had 793) and M(71) ≥ 1065
   (CONSTR had 1005). For n = 80, 82 and 93 we have 1280, 1312 and 1674.
5. **Engineering note.** Running `git pull --rebase` while background jobs appended to tracked files
   (`runs.jsonl`, `validation.jsonl`) silently lost their output. The rebase replaces the file, and the jobs
   kept writing to the unlinked inode. Lost and re-run: the n = 39 k = 10 DRAT run and the sym-0 UNSAT runs
   for n = 30, 32 and 36. Only n = 30 could be redone in time. Later checkpoints used `src/commit.sh`,
   which commits from a detached scratch worktree.
6. **Next steps.**
   - Longer kissat `--sat` runs, or cube-and-conquer on the sym-2 encoding, for n = 48, 50 at k = 12 and
     n = 80 at k = 17..20.
   - A stronger encoding to speed up UNSAT proofs (CYC/C1 proved n = 38 in 171 s): e.g. replace the
     n clauses per y(a,b,δ) by a difference-indexed AMO.
   - Seeding SAT phases from the k − 1 solution.
