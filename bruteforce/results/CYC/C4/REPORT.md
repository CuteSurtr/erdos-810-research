# Task CYC/C4: exact optima of the cyclic orbit family, n = 42, 53, 56, 63, 74, 85, 88, 95

## 1. Placement

```
$ uname -a; nproc; free -g
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

All computation ran in this 4-core cloud container, 05:12 to about 10:05 UTC on 2026-10-25.

## 2. Results

k = |D|, the number of orbits, so |E| = n·k. k_unsat is the first k proved UNSAT.

| n | k_lo (best found) | |E| = n·k_lo | k_unsat | status | k_lo/n | solver seconds | notes |
|---|---|---|---|---|---|---|---|
| 42 | 10 | 420 | – | certificate-verified lower bound; k=11 unknown (timeout) | 0.2381 | 1500 | first pass (k=11,12; 25 min, 4 jobs) gave no answer; its records were lost (git rebase replaced the open log files); k_lo is CONSTR's model, re-verified |
| 53 | 13 | 689 | – | certificate-verified lower bound; k=14 unknown (timeout) | 0.2453 | 1500 |  |
| 56 | 13 | 728 | – | certificate-verified lower bound; k=14 unknown (timeout) | 0.2321 | 1500 | k=n/4=14 undecided |
| 63 | 13 | 819 | – | certificate-verified lower bound; k=14 unknown (timeout) | 0.2063 | 1500 | first pass: k=14,15 ran 25 min with no answer; timeout records lost (git rebase), SAT records kept |
| 74 | 15 | 1110 | – | certificate-verified lower bound; k=16 unknown (timeout) | 0.2027 | 1548 | k=15 from a side run (47 s); first pass k=16,17 no answer in 25 min |
| 85 | 17 | 1445 | – | certificate-verified lower bound; k=18 unknown (timeout) | 0.2000 | 1564 | first pass: k=16,17 SAT, k=18,19 no answer; model regenerated with the same solver/seed |
| 88 | 17 | 1496 | – | certificate-verified lower bound; k=18 unknown (timeout) | 0.1932 | 1516 | k=n/4=22 undecided; first pass: k=17 SAT, k=18 and k=n/4=22 no answer; model regenerated |
| 95 | 18 | 1710 | – | certificate-verified lower bound; k=19 unknown (timeout) | 0.1895 | 1511 | first pass: k=17,18 SAT in 8 s, k=19,20 no answer; model regenerated |

### Validation (before my own n)

CONSTR's `cyclic_family_status.json` gives k_max(14) = 3 (k = 4 UNSAT). The table in `tasks/CYC.md` says 4
for n = 14–17, which looks like a summary typo. My encoder and an independent brute force
(`src/brute_small.py`, which finds no valid (D, g) with |D| = 4 on Z_14) both give 3. Every other
entry agrees with CONSTR.

| n | k_max (CONSTR) | sym2 @k_max | sym2 @k_max+1 | sym1 @k_max+1 | sym0 @k_max | sym0 @k_max+1 | DRAT @k_max+1 (CaDiCaL → drat-trim) |
|---|---|---|---|---|---|---|---|
| 13 | 3 | SAT ✓ 0.0s | UNSAT 0.0s | – | SAT ✓ 0.0s | UNSAT 0.1s | VERIFIED (0 MB, 0+0 s) |
| 14 | 3 | SAT ✓ 0.0s | UNSAT 0.0s | – | SAT ✓ 0.0s | UNSAT 0.0s | VERIFIED (0 MB, 0+0 s) |
| 15 | 4 | SAT ✓ 0.0s | UNSAT 0.0s | – | SAT ✓ 0.0s | UNSAT 0.0s | VERIFIED (0 MB, 0+0 s) |
| 16 | 4 | SAT ✓ 0.0s | UNSAT 0.0s | – | SAT ✓ 0.0s | UNSAT 0.1s | VERIFIED (0 MB, 0+0 s) |
| 17 | 4 | SAT ✓ 0.0s | UNSAT 0.0s | – | SAT ✓ 0.0s | UNSAT 0.3s | VERIFIED (0 MB, 0+0 s) |
| 18 | 5 | SAT ✓ 0.0s | UNSAT 0.0s | – | SAT ✓ 0.0s | UNSAT 0.1s | VERIFIED (0 MB, 0+0 s) |
| 19 | 5 | SAT ✓ 0.0s | UNSAT 0.0s | – | SAT ✓ 0.1s | UNSAT 0.5s | VERIFIED (0 MB, 0+0 s) |
| 20 | 5 | SAT ✓ 0.0s | UNSAT 0.0s | – | SAT ✓ 0.1s | UNSAT 0.9s | VERIFIED (0 MB, 0+0 s) |
| 21 | 6 | SAT ✓ 0.0s | UNSAT 0.1s | – | SAT ✓ 0.1s | UNSAT 0.7s | VERIFIED (0 MB, 0+1 s) |
| 22 | 5 | SAT ✓ 0.1s | UNSAT 0.1s | – | SAT ✓ 0.0s | UNSAT 4.3s | VERIFIED (0 MB, 0+0 s) |
| 23 | 6 | SAT ✓ 0.1s | UNSAT 0.1s | – | SAT ✓ 0.1s | UNSAT 5.3s | VERIFIED (0 MB, 0+0 s) |
| 24 | 6 | SAT ✓ 0.1s | UNSAT 0.1s | – | SAT ✓ 0.1s | UNSAT 5.9s | VERIFIED (0 MB, 0+0 s) |
| 25 | 6 | SAT ✓ 0.1s | UNSAT 0.2s | UNSAT 1.5s | SAT ✓ 0.0s | UNSAT 39.9s | VERIFIED (0 MB, 0+1 s) |
| 26 | 6 | SAT ✓ 0.0s | UNSAT 0.4s | UNSAT 2.1s | SAT ✓ 0.0s | – | VERIFIED (1 MB, 0+0 s) |
| 27 | 7 | SAT ✓ 0.1s | UNSAT 0.4s | UNSAT 1.8s | SAT ✓ 0.2s | – | VERIFIED (0 MB, 1+0 s) |
| 28 | 7 | SAT ✓ 0.2s | UNSAT 0.6s | UNSAT 2.2s | SAT ✓ 0.2s | – | VERIFIED (1 MB, 1+0 s) |
| 29 | 7 | SAT ✓ 0.2s | UNSAT 1.2s | UNSAT 10.3s | SAT ✓ 0.0s | stopped | VERIFIED (1 MB, 1+1 s) |
| 30 | 7 | SAT ✓ 0.3s | UNSAT 3.5s | UNSAT 15.5s | SAT ✓ 0.0s | – | VERIFIED (9 MB, 4+7 s) |
| 31 | 8 | SAT ✓ 2.2s | UNSAT 1.4s | – | – | – | VERIFIED (2 MB, 1+1 s) |
| 32 | 8 | SAT ✓ 0.3s | UNSAT 2.4s | – | – | – | VERIFIED (5 MB, 2+4 s) |
| 33 | 8 | SAT ✓ 0.5s | UNSAT 8.4s | – | – | – | VERIFIED (17 MB, 7+17 s) |
| 34 | 8 | SAT ✓ 0.7s | UNSAT 14.0s | – | – | – | VERIFIED (31 MB, 11+33 s) |
| 36 | 9 | SAT ✓ 1.4s | UNSAT 31.5s | – | – | – | VERIFIED (59 MB, 25+65 s) |

✓ means the model was decoded and passed the explicit 4-cycle checker. "stopped" (n = 29, sym 0)
is a run I killed to free cores. It was replaced by the sym-1 run.

## 3. Certificates

- `solutions.json`: {n: [[d, g], …]}. Orbit d contributes the edges {i, i+d} with colour (i+g) mod n.
- `certs.json`: {n: [[u, v, c], …]}, the explicit edges, all n·k of them.
- Both were re-checked by `src/check.py` when written, and again by a fresh run at the end (section 4).

- n = 42, k = 10: `[[3, 0], [4, 15], [8, 38], [10, 13], [11, 33], [12, 36], [13, 29], [14, 32], [17, 6], [20, 12]]`
- n = 53, k = 13: `[[1, 0], [4, 11], [6, 37], [7, 50], [9, 23], [10, 51], [11, 49], [13, 15], [15, 44], [16, 32], [17, 21], [24, 42], [25, 19]]`
- n = 56, k = 13: `[[1, 0], [2, 48], [3, 40], [5, 33], [6, 20], [7, 16], [8, 29], [13, 10], [16, 4], [17, 43], [21, 39], [23, 25], [24, 30]]`
- n = 63, k = 13: `[[1, 0], [2, 45], [4, 59], [5, 37], [8, 30], [9, 12], [13, 29], [14, 56], [19, 25], [20, 8], [27, 41], [28, 18], [30, 21]]`
- n = 74, k = 15: `[[8, 0], [12, 18], [14, 25], [15, 34], [17, 41], [20, 30], [21, 23], [25, 16], [26, 69], [27, 5], [28, 14], [29, 1], [30, 37], [31, 59], [35, 56]]`
- n = 85, k = 17: `[[1, 0], [2, 19], [3, 49], [4, 36], [5, 74], [6, 63], [7, 30], [8, 45], [10, 16], [19, 58], [20, 10], [25, 53], [32, 40], [36, 2], [39, 34], [40, 22], [42, 11]]`
- n = 88, k = 17: `[[1, 0], [2, 12], [4, 63], [7, 15], [9, 52], [10, 68], [14, 20], [16, 54], [18, 74], [19, 72], [22, 1], [23, 16], [24, 47], [25, 39], [26, 44], [35, 66], [39, 50]]`
- n = 95, k = 18: `[[1, 0], [2, 42], [3, 10], [6, 88], [8, 66], [9, 32], [11, 79], [17, 3], [22, 28], [25, 62], [27, 18], [28, 61], [32, 56], [35, 14], [36, 55], [41, 76], [43, 72], [45, 93]]`

## 4. Method

### Encoder (`src/cycenc.c`)

Re-derived from the task statement; nothing was copied from CONSTR's `cycsat.py` except the conventions.

- **Variables.** `x[d][g]` (orbit d present with offset g), var `1+(d-1)n+g`, for d = 1..H, g ∈ Z_n;
  `p[d] = Hn + d`; then auxiliaries.
- **Channelling.** `p_d → OR_g x[d][g]`, `x[d][g] → p_d`, pairwise at-most-one over g.
- **4-cycles through 0.** All closed walks 0 → v1 → v2 → v3 → 0 with 3 free steps (d, ±1) and the
  closing step forced (it is skipped when the closing difference is the excluded diameter n/2). The
  4 vertices must be distinct. A step v → v+d uses edge (d, offset v), colour v + g(d); a step v → v−d
  uses edge (d, offset v−d), colour v−d+g(d). For each pair of edges in different orbits d_a < d_b
  with offsets o_a, o_b, the colours coincide iff g(d_a) − g(d_b) ≡ o_b − o_a =: δ. The key
  (d_a, d_b, δ, others) is stored, where "others" is the set of orbits of the cycle other than d_a, d_b
  (at most 2). Same-orbit pairs never collide: two edges of a 4-cycle in the same orbit with equal
  offset would be the same edge, and the encoder asserts this never happens.
  Every 4-cycle is a rotation of one through 0, and rotation by t maps the colour coincidence
  condition to itself (both colours shift by t), so cycles through 0 suffice.
- **Auxiliaries.** For every (d_a, d_b, δ) that occurs: `y[d_a][d_b][δ] ← x[d_a][g] ∧ x[d_b][g−δ]` for all g
  (n ternary clauses). Only this direction is needed: y is only used negatively. Each key then becomes
  one clause `¬y ∨ ¬p_o1 ∨ ¬p_o2`. Every (d_a, d_b, δ) turns out to occur, so there are C(H,2)·n
  y-variables. For n = 95: about 0.4M distinct keys, 103k y-variables and 10.4M clauses, a 6 s encode.
- **Cardinality.** Σ p_d ≥ k uses a sequential counter s[i][j] ("at least j of p_1..p_i"), with clauses
  `s[i][j] → s[i−1][j] ∨ p_i` and `s[i][j] → s[i−1][j] ∨ s[i−1][j−1]`, plus the unit s[H][k].
- **Symmetry levels.** `sym=0` adds nothing. `sym=1` adds the colour-translation fix. `sym=2` adds the
  translation fix and the lex-leader over all units.

### Symmetry-breaking soundness

*Colour translation.* Replacing g by g + t (all orbits) recolours every edge c ↦ c + t, a bijection
of Z_n. So rainbow 4-cycles stay rainbow. Given any solution, take d0 = min D and t = −g(d0): the new
solution has g(d0) = 0. Clause: `¬p_d ∨ p_1 ∨ … ∨ p_{d−1} ∨ x[d][0]`.

*Multipliers.* Let u ∈ Z_n^×, with vertex map φ(i) = ui and colour map ψ(c) = uc. Both are bijections,
so (φ, ψ) maps a valid coloured graph to a valid coloured graph (4-cycles map to 4-cycles, and distinct
colours stay distinct). The image of edge {i, i+d} with colour i + g(d) is {ui, ui + ud} with colour
ui + u·g(d). Write ud ≡ σe with e = rep(ud) ∈ 1..H. The diameter is excluded and u is odd for even n,
so ud ≢ n/2 and d ↦ e is a permutation of 1..H.
- σ = +1: the edge is {j, j+e} with j = ui and colour j + u·g(d), so g′(e) = u·g(d).
- σ = −1: the edge is {j, j+e} with j = ui − e and colour ui + u·g(d) = j + e + u·g(d),
  so g′(e) = e + u·g(d).

So (D, g) ↦ (D′, g′) is again a member of the family, with p′_e = p_{rep(u⁻¹e)}.
`src/test_action.py` checks this formula against the explicit image graph for every unit on every
SAT model of the validation run (466 checks, all pass).

*Lex-leader.* The maps p ↦ p∘u form a group action on presence vectors. In the orbit of p under this
action pick the lex-maximal p* (realised by some solution, by the above), then translate colours so
that g(min D) = 0. Translation does not change p. The result satisfies p* ≥_lex p*∘u for all units u
and the translation fix, so adding both is sound. The encoding uses prefix-equality auxiliaries
a_i: `a_{i−1} ∧ q_i → p_i`, `a_{i−1} ∧ p_i ∧ q_i → a_i`, `a_{i−1} ∧ ¬p_i ∧ ¬q_i → a_i`, skipping
fixed points. Setting a_i true spuriously only adds constraints, so every lex-leader extends to a
model. Units u and −u induce the same permutation of orbits, so only u = 2..n/2 are used, and identity
permutations are skipped.

*Empirical check.* For all n = 13..30, k_max agrees between sym 2 and sym 0 (sym 1 for the UNSAT
side at n ≥ 25; sym 0 there was slower and I stopped it). Projected model counts at k = k_max:

| n, k | brute force (g(min D)=0) | sym 0 | sym 1 | sym 2 |
|---|---|---|---|---|
| 13, 3 | 340 | 4420 = 13·340 | 340 | 82 |
| 14, 3 | 614 | 8596 = 14·614 | 614 | 206 |
| 15, 4 | 92 | 1380 = 15·92 | 92 | 30 |
| 16, 4 | 464 | 7424 = 16·464 | 464 | 116 |

The brute force (`src/brute_small.py`) enumerates all (D, g) with g(min D) = 0 and tests each with the
simple checker. It also confirms k = 4 is impossible for n = 13 and n = 14.

### Checker (`src/check.py`)

It builds the explicit edge set {i, i+d} with colours (i+g) mod n and asserts there are no duplicate
edges and that colours lie in 0..n−1. For every vertex pair {a, c} and every pair {b, d} of common
neighbours, it checks that the 4 colours of a-b-c-d are distinct. This covers every 4-cycle, each one
twice. It shares no code with the encoder. Every SAT model is decoded and re-checked inside
`src/run.py`, and `src/collect.py` re-checks again before writing `solutions.json` and `certs.json`.

### Per-n driver (`src/drive.py`)

Four kissat 4.0.4 jobs run in parallel:
- A: default config, sym 2, at k = best+1;
- B: `--sat` with seed 1, sym 1, at best+1;
- C: `--unsat`, sym 2, at best+1;
- D: `--sat` with seed 2, sym 1, at n/4 when n ≡ 0 (mod 4) and n/4 > best+1, otherwise at best+2.

A verified SAT at k raises best and restarts the lower jobs, and an UNSAT at best+1 ends the search.
Up to 06:12 UTC (n = 53 and an aborted n = 56 start) B and D also used sym 2. Other agents reported
that the lex-leader slows SAT-finding at large n, so I switched B and D to sym 1.

### UNSAT proofs (`src/prove.sh`)

CaDiCaL (master, built from GitHub) writes a binary DRAT proof of the sym-2 CNF, and drat-trim
(GitHub master) checks it. Note that the proof certifies the symmetry-broken CNF, whose soundness is
argued above.

Tools: kissat 4.0.4, CaDiCaL and drat-trim, all built from source (`git clone` from github.com/arminbiere
and github.com/marijnheule). pysat was used only for model counting (`src/count.py`).

### Timings

- **Encoding.** About 0.4M keys and 10.4M clauses at n = 95, encoded in about 6 s. CNFs range from
  6 MB (n = 42) to about 200 MB (n = 95).
- **Validation.** sym-2 UNSAT at k_max+1 takes 0.0–3.5 s for n ≤ 32 and 31.5 s at n = 36. sym 0
  is 5–40 s by n = 22–25. The DRAT proofs for all 23 validation UNSATs check in at most 65 s each.
- **First pass.** 25 min wall per n with 4 parallel kissat jobs, 05:19–08:40 UTC. New SAT answers
  came either in seconds to about a minute (53: k = 13 in 36 s; 63: k = 13 in 8 s; 85: k = 17 in
  61 s; 95: k = 18 in 8 s) or late (56: k = 13 after 1092 s). No k above the table's k_lo was
  decided either way within the cap at any n.
- **Second pass.** 08:40–09:58 UTC: PASS2_SUMMARY

## 5. Where the code lives (`bruteforce/results/CYC/C4/`)

| file | purpose |
|---|---|
| `src/cycenc.c` | DIMACS encoder (`gcc -O2 -o src/cycenc src/cycenc.c`; binary git-ignored) |
| `src/check.py` | deliberately simple explicit 4-cycle checker |
| `src/run.py` | encode (cached), solve with kissat/CaDiCaL, decode and check; one JSON line out |
| `src/drive.py` | per-n 4-job driver (section 4) |
| `src/prove.sh` | CaDiCaL + DRAT, then drat-trim |
| `src/brute_small.py`, `src/count.py`, `src/test_action.py` | brute force, projected model counts, multiplier-action test |
| `src/validate.sh`, `src/validate2.sh` | validation runs, producing `validation.jsonl` |
| `src/master*.sh`, `src/pass2.sh` | first- and second-pass schedules |
| `src/collect.py`, `src/make_report.py` | `table.tsv`, `solutions.json`, `certs.json` and `REPORT.md` |
| `runs/`, `runs_drive<n>.log` | raw per-job records (JSON lines) and driver logs |
| `validation.jsonl`, `drat_validation.jsonl`, `drat.jsonl` | validation solver runs and proof checks |

Solver binaries were built from source in the scratchpad: kissat 4.0.4, CaDiCaL and drat-trim, all
GitHub master. To rebuild, clone them and point `SATBIN` (used by `run.py`) at the folder that
contains them.

## 6. Surprises and next steps

1. **n = 14 in the task table.** k_max(14) = 3, not 4 (see the validation section). This agrees with
   CONSTR's raw data, so it is not a discrepancy with CONSTR.
2. **New lower bounds for M(n).** The family alone now gives M(53) ≥ 689, M(56) ≥ 728 and
   M(63) ≥ 819. CONSTR's best for these n was 636, 672 and 812. For n = 74, 85, 88 and 95 CONSTR had
   no value; here M(74) ≥ 1110, M(85) ≥ 1445, M(88) ≥ 1496 and M(95) ≥ 1710.
3. **k = n/4 for multiples of 4.** At n = 56 the best is 13 = n/4 − 1. At n = 88 it is 17 = n/4 − 5;
   k = 22 got 25 min of `--sat` with no answer. Neither case is decided. The proved pattern
   k_max = n/4 (n = 28, 32, 36, and n = 40 from CYC/C0) is therefore unconfirmed beyond 40 in my
   rows.
4. **k/n is drifting down.** The best k/n falls from 0.245 (53) to 0.19 (95), but these are lower
   bounds from 25-min runs, so the drift is at least partly an effort artefact. Note how quickly
   k = 17 at 85 and k = 18 at 95 were found, against how hard k = 14 at 56 has been.
5. **Lost logs, and a lesson for other agents.** `git pull --rebase` replaces every tracked file in
   the results folder with a new inode. A driver that already has a results file open for append
   keeps writing to the deleted inode, and the data vanish. This happened to the first-pass records
   for n = 42, 63, 74, 85, 88 and 95 (the SAT models for 85, 88 and 95 were regenerated
   deterministically). The pass-2 jobs were rescued with `tail -f /proc/<pid>/fd/1`. Fix: keep live
   logs outside the repository, or untracked, and copy them in before committing.
6. **Lex-leader hurts SAT-finding.** At larger n the lex-leader hurts finding SAT models more
   than it helps (as other agents also found). Use sym 1 for SAT jobs and sym 2 for UNSAT jobs.

**Next steps (sharding plan).**
- **UNSAT at n ≥ 42.** This is out of reach for plain CDCL in 25 min: the sym-2 UNSAT time roughly
  doubles every 1–2 steps of n (2.4 s at n = 32, 31.5 s at 36, about 444 s at 40 per CYC/C0, and
  more than 75 min at 42). A cube-and-conquer split on the presence vector (p_1, …, p_m) with
  m ≈ 6–8 would parallelise it, and the lex-leader already kills most cubes with p_1 = 0. Command
  per cube: `cycenc 42 11 2 > base.cnf`, append the cube's unit clauses, then
  `cadical --binary=true -t T cube.cnf cube.drat && drat-trim cube.cnf cube.drat`. The 2^m sign
  patterns cover all cases, so the cubes' UNSATs together prove the whole.
- **SAT at k_lo+1.** Run sym-1 `kissat --sat` with many seeds (each run is cheap), or seed an
  annealer from the current best (D, g) by adding one orbit.

