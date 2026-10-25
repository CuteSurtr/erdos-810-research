# CYC/C3: cyclic orbit family, n = 41, 51, 52, 62, 73, 83, 84, 94

## 1. Placement

```
$ uname -a; nproc; free -g
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

All computation ran in this cloud container, 05:12–10:05 UTC on 2026-10-25.

## 2. Results

Status labels follow the README: *proved* means SAT at k plus a drat-trim-verified UNSAT at
k + 1. *Certificate-verified* means an explicit solution re-checked by two independent
checkers, with k + 1 undecided (*unfinished*).

| n | k_lo (best found) | k_unsat | status | k_lo/n | edges n·k_lo | notes |
|---|---|---|---|---|---|---|
| 41 | 10 | 11 | **k_max = 10, proved** (k = 11 UNSAT, DRAT verified) | 0.2439 | 410 |  |
| 51 | 12 | – | k ≥ 12 certificate-verified; k + 1 unfinished | 0.2353 | 612 | UNKNOWN at k=13 |
| 52 | 12 | – | k ≥ 12 certificate-verified; k + 1 unfinished | 0.2308 | 624 | UNKNOWN at k=13; k=n/4=13 undecided: 25 min first pass + 73 min wall second pass (4 solvers; seconds column sums two concurrent runs) |
| 62 | 13 | – | k ≥ 13 certificate-verified; k + 1 unfinished | 0.2097 | 806 | UNKNOWN at k=14 |
| 73 | 15 | – | k ≥ 15 certificate-verified; k + 1 unfinished | 0.2055 | 1095 | UNKNOWN at k=16 |
| 83 | 17 | – | k ≥ 17 certificate-verified; k + 1 unfinished | 0.2048 | 1411 | UNKNOWN at k=18 |
| 84 | 17 | – | k ≥ 17 certificate-verified; k + 1 unfinished | 0.2024 | 1428 | UNKNOWN at k=18,21; k=n/4=21 undecided (10 min) |
| 94 | 18 | – | k ≥ 18 certificate-verified; k + 1 unfinished | 0.1915 | 1692 | UNKNOWN at k=19; first pass tried k=19 directly (UNKNOWN 25 min); k=18 SAT in 25 s in pass 2 |

**n ≡ 0 (mod 4).**
- n = 52: k = n/4 = 13 is **undecided**. It got 25 min in the first pass and 73 min wall in the
  second, with 4 solvers (full-breaking CNF with kissat DRAT and kissat; translation-only CNF
  with 2 kissat runs). k = 12 is SAT.
- n = 84: k = n/4 = 21 is **undecided** after 10 min. k = 17 is SAT, k = 18 undecided.
- So no n/4 value is SAT among my n, and none is proved UNSAT.

**New compared with CONSTR.**
- n = 41: k_max = 10 is now proved (k = 11 UNSAT, DRAT verified). CONSTR had k = 11 undecided.
- n = 51: k = 12 SAT (CONSTR had k = 11).
- n = 73: k = 15 SAT (CONSTR's annealer gave 14).
- n = 83: k = 17 SAT (CONSTR's annealer gave 15).
- n = 84 (k = 17) and n = 94 (k = 18) were not covered by CONSTR.

**Observed k/n.**
- 0.244 at n = 41 (exact);
- best found 0.235 / 0.231 at n = 51 / 52;
- 0.210 at n = 62;
- 0.205 at n = 73 and 83, 0.202 at n = 84;
- 0.191 at n = 94.

## 3. Certificates

Each orbit d with offset g gives the edges {i, i+d mod n} with colour (i + g) mod n.
- `solutions.json` stores {n: [[d, g], …]}.
- `certs.json` stores the explicit edges {n: [[u, v, c], …]}, all colours in 0..n−1.
- Both files were re-checked by `src/check4.py`, and `certs.json` also by `CONSTR/check.py`.
  All 8 are VALID, with matching 4-cycle counts (`logs/check4.txt`, `logs/constr_check.txt`).

- n = 41, |D| = 10: `[[1, 0], [2, 32], [3, 11], [4, 23], [5, 29], [9, 10], [12, 7], [14, 18], [17, 34], [20, 26]]`
- n = 51, |D| = 12: `[[1, 0], [2, 7], [3, 49], [6, 48], [10, 19], [11, 23], [12, 41], [13, 28], [15, 36], [16, 40], [18, 32], [20, 37]]`
- n = 52, |D| = 12: `[[1, 0], [2, 41], [3, 33], [4, 19], [6, 26], [8, 11], [10, 50], [15, 46], [18, 24], [21, 29], [23, 45], [24, 38]]`
- n = 62, |D| = 13: `[[1, 0], [2, 43], [3, 24], [5, 14], [9, 26], [11, 7], [12, 3], [16, 44], [20, 51], [21, 39], [23, 6], [24, 16], [29, 13]]`
- n = 73, |D| = 15: `[[1, 0], [3, 32], [4, 55], [5, 62], [7, 49], [12, 46], [16, 13], [17, 65], [18, 40], [20, 8], [26, 38], [27, 50], [29, 36], [30, 71], [31, 21]]`
- n = 83, |D| = 17: `[[1, 0], [2, 17], [3, 62], [4, 26], [5, 80], [6, 70], [9, 56], [14, 45], [18, 69], [20, 23], [26, 66], [28, 16], [32, 44], [33, 57], [34, 38], [37, 28], [41, 76]]`
- n = 84, |D| = 17: `[[2, 0], [3, 46], [6, 3], [8, 27], [11, 72], [15, 68], [17, 64], [18, 23], [19, 51], [22, 26], [23, 60], [27, 39], [30, 48], [31, 14], [35, 44], [39, 77], [41, 13]]`
- n = 94, |D| = 18: `[[1, 0], [2, 79], [3, 70], [5, 34], [8, 61], [9, 91], [17, 58], [19, 45], [21, 12], [22, 65], [25, 39], [26, 35], [28, 3], [31, 81], [33, 27], [34, 64], [37, 47], [45, 68]]`

## 4. Method

### Encoder (`src/cycenc.c`, C, emits DIMACS)

- Vertices Z_n, orbits d = 1..H with H = ⌈n/2⌉ − 1. Variables:
  - x[d][g] (orbit d present with offset g ∈ Z_n), var id (d−1)·n + g + 1;
  - p[d] ⇔ OR_g x[d][g]; at most one g per d (sequential counter, n−1 auxiliaries per d).
- **Cycles.** Enumerate all (2H)³ step triples 0 → v1 → v2 → v3, with a step ±d, and close
  with v3 → 0 when −v3 ≡ ±d′ for some d′ ∈ 1..H; keep only walks on 4 distinct vertices.
  - A step v → v+d uses edge {v, v+d}, colour v + g(d): offset o = v.
  - A step v → v−d uses edge {v−d, v}, colour v − d + g(d): offset o = v − d.
  - So edge colours are o + g(d). Two edges (d_a, o_a), (d_b, o_b) with d_a ≠ d_b collide iff
    g(d_a) − g(d_b) ≡ o_b − o_a. Two distinct edges of one orbit have distinct offsets, so they
    never collide (the encoder asserts that no same-orbit pair has equal offsets).
  - Rotation i ↦ i + t adds t to every offset and maps the family to itself, so the 4-cycles
    through 0 cover all 4-cycles up to rotation.
- **Keys.** Each pair of edges in different orbits of a cycle gives a key
  (d_a < d_b, δ = o_b − o_a, others = the remaining orbits of the cycle minus {d_a, d_b}),
  with duplicates removed after sorting.
- **Auxiliaries.** y[d_a][d_b][δ] ⇐ x[d_a][g] ∧ x[d_b][g − δ], one 3-clause per g, created only
  for δ values that occur. Each key is then a single clause ¬y ∨ ¬p[o] (o ∈ others).
  - Only the implication is needed. In a valid assignment, set y true exactly when the
    coincidence happens. In any model, a coincidence forces y, and then the key forbids all
    the other orbits being present (d_a and d_b are present because x implies p).
- **Cardinality.** Σ p_d ≥ k is encoded as "at most H − k of ¬p_d" with Sinz's sequential
  counter.
- **Size.** n = 94, k = 23: 108k variables, 9.5M clauses, 369k keys, written in about 1 s.
  The y-clauses dominate (Σ over (d_a, d_b, δ) of n).

### Symmetry breaking and its soundness

Let S be the set of valid (D, g) with |D| ≥ k. Two group actions preserve S:

1. **Colour translation.** g ↦ g + t (all d). Every colour shifts by t, a bijection of Z_n, so
   rainbow 4-cycles stay rainbow, and D (hence p) is unchanged.
2. **Multipliers.** For a unit u ∈ Z_n^×, the vertex map i ↦ ui is a graph automorphism of Z_n
   onto itself, and c ↦ uc is a bijection of colours. Edge {i, i+d} with colour i + g(d) goes
   to {ui, ui + ud} with colour ui + u·g(d). Let e = rep(ud) ∈ 1..H with ud ≡ σe.
   - If σ = +1: with j = ui this is edge {j, j+e} with colour j + u·g(d), so g′(e) = u·g(d).
   - If σ = −1: with j = ui − e this is edge {j, j+e} with colour j + e + u·g(d), so
     g′(e) = e + u·g(d).
   - rep(ud) ≠ n/2 for even n: ud ≡ n/2 would give d ≡ u⁻¹·n/2 ≡ n/2 (u⁻¹ is odd), but
     d ≤ H < n/2.
   - The image is the explicit graph relabelled with recoloured edges. 4-cycles map to
     4-cycles and distinct colours stay distinct, so the image is valid, lies in the family,
     and has |D′| = |D|. Its presence vector is p′_e = p_{rep(u⁻¹e)}.
   - u and −u induce the same permutation π_u of orbits, so the encoder uses u ∈ 2..H with
     gcd(u, n) = 1 (π_1 = id).

**Constraints added (default "full").**
- (a) Lex-leader: p ≥_lex p∘π_u for every unit u, over positions 1..H with p_1 most
  significant. The standard chain encoding uses prefix-equality auxiliaries a_i:
  a_{i−1} → (p_i ∨ ¬q_i), and a_{i−1} ∧ (p_i ↔ q_i) → a_i, where q_i = p_{π(i)}; fixed
  points of π are skipped. The a_i are only forced true when the prefix really is equal.
- (b) Translation fix: g(min present orbit) = 0, i.e. for each d,
  p_d ∧ ¬p_1 ∧ … ∧ ¬p_{d−1} → x[d][0].

**Soundness.** Take any (D, g) ∈ S.
- Among its images under all units (a group action on S), pick one whose p is lex-maximal.
  Every unit u gives an image with presence p∘π_u, and the set of images is closed under the
  group, so this representative satisfies (a) for every u.
- Translate its g so that g(min D) = 0. This does not change p, so (a) still holds, and (b)
  now holds.
- So S ≠ ∅ implies the constrained formula is satisfiable. The converse is trivial, since we
  only added constraints. Hence SAT/UNSAT at each k is unchanged.
- Empirically, k_max agrees with and without breaking for n = 13..30 (validation table), and
  solution counts shrink (see the counts below).

### Solving (`src/run.py`, `src/drive.py`)

- **Portfolio.** Four processes per instance run in parallel:
  - kissat 4.x `--unsat --seed=2`, writing a binary DRAT proof;
  - kissat `--seed=1`;
  - CaDiCaL 2.x `--seed=7`;
  - kissat `--sat --seed=3`.
  Solvers were built from the GitHub sources (arminbiere/kissat, arminbiere/cadical).
  The first definite answer wins.
- **UNSAT proofs.** On UNSAT the driver waits for the proof-writing member and runs
  drat-trim (marijnheule/drat-trim, built from source) on the proof when it is under 5 GB.
- **SAT models.** These are decoded to (D, g) and re-checked by `src/check4.py`, an
  independent, deliberately simple explicit checker. It builds all n·|D| edges and
  enumerates every walk a-b-c-d-a on 4 distinct vertices.
- **Per-n first pass (`drive.py`).** SAT at k_lo + 1, k_lo + 2, … until UNSAT or UNKNOWN,
  with a 25 min wall cap. For n ≡ 0 (mod 4), 40% of the cap is held back for an explicit
  attempt at k = n/4.

### Validation (before my n)

- **Cross-check against CONSTR.** k_max was reproduced for n = 13..30, 32, 36: SAT at k_max
  with the model re-checked by `check4.py`, and UNSAT at k_max + 1 with a DRAT proof checked
  by drat-trim.
- **Without symmetry breaking.** k_max + 1 was re-run for 13..30 with translation-only and with
  no symmetry breaking. k_max agrees everywhere it was decided. Without breaking, n = 29 and 30
  at k_max + 1 hit the 600 s cap (UNKNOWN).
- **Independent brute force.** `src/brute.py` does backtracking over (D, g) with the explicit
  checker as its only oracle and no SAT. It gives the same k_max for n = 8..19
  (`logs/brute.txt`).
- **The n = 14 discrepancy.** The task's summary table says k_max(14) = 4. CONSTR's own data
  and all my methods say 3 (see §6). For every other n there is full agreement with CONSTR.

| n | CONSTR k_max | brute force | full: SAT at k_max (check4) | full: k_max+1 | DRAT | trans only: k_max / k_max+1 (s) | no breaking: k_max / k_max+1 (s) |
|---|---|---|---|---|---|---|---|
| 13 | 3 | 3 | VALID | UNSAT (0.5 s) | VERIFIED | SAT / UNSAT (0.5 s) | SAT / UNSAT (0.5 s) |
| 14 | 3 | 3 | VALID | UNSAT (0.5 s) | VERIFIED (logs/drat_n14_k4_full_13811.txt) | SAT (k=3, from full) / UNSAT (0.5 s) | SAT (k=3, from full) / UNSAT (0.5 s) |
| 15 | 4 | 4 | VALID | UNSAT (0.5 s) | VERIFIED | SAT / UNSAT (0.5 s) | SAT / UNSAT (0.5 s) |
| 16 | 4 | 4 | VALID | UNSAT (0.5 s) | VERIFIED | SAT / UNSAT (0.5 s) | SAT / UNSAT (0.5 s) |
| 17 | 4 | 4 | VALID | UNSAT (0.5 s) | VERIFIED | SAT / UNSAT (0.5 s) | SAT / UNSAT (0.5 s) |
| 18 | 5 | 5 | VALID | UNSAT (0.5 s) | VERIFIED | SAT / UNSAT (0.5 s) | SAT / UNSAT (0.5 s) |
| 19 | 5 | 5 | VALID | UNSAT (0.5 s) | VERIFIED | SAT / UNSAT (0.5 s) | SAT / UNSAT (1.0 s) |
| 20 | 5 | – | VALID | UNSAT (0.5 s) | VERIFIED | SAT / UNSAT (0.5 s) | SAT / UNSAT (1.0 s) |
| 21 | 6 | – | VALID | UNSAT (0.5 s) | VERIFIED | SAT / UNSAT (0.5 s) | SAT / UNSAT (1.0 s) |
| 22 | 5 | – | VALID | UNSAT (0.5 s) | VERIFIED | SAT / UNSAT (0.5 s) | SAT / UNSAT (4.5 s) |
| 23 | 6 | – | VALID | UNSAT (0.5 s) | VERIFIED | SAT / UNSAT (0.5 s) | SAT / UNSAT (6.6 s) |
| 24 | 6 | – | VALID | UNSAT (0.5 s) | VERIFIED | SAT / UNSAT (0.5 s) | SAT / UNSAT (8.0 s) |
| 25 | 6 | – | VALID | UNSAT (0.5 s) | VERIFIED | SAT / UNSAT (2.0 s) | SAT / UNSAT (70.6 s) |
| 26 | 6 | – | VALID | UNSAT (0.5 s) | VERIFIED | SAT / UNSAT (2.6 s) | SAT / UNSAT (152.2 s) |
| 27 | 7 | – | VALID | UNSAT (0.5 s) | VERIFIED | SAT / UNSAT (2.6 s) | SAT / UNSAT (158.2 s) |
| 28 | 7 | – | VALID | UNSAT (0.5 s) | VERIFIED | SAT / UNSAT (2.6 s) | SAT / UNSAT (172.7 s) |
| 29 | 7 | – | VALID | UNSAT (1.1 s) | VERIFIED | SAT / UNSAT (12.6 s) | SAT / UNKNOWN (600.5 s) |
| 30 | 7 | – | VALID | UNSAT (4.1 s) | VERIFIED | SAT / UNSAT (20.6 s) | SAT / UNKNOWN (600.4 s) |
| 32 | 8 | – | VALID | UNSAT (2.6 s) | VERIFIED | – | – |
| 36 | 9 | – | VALID | UNSAT (24.1 s) | VERIFIED | – | – |

**Solution counts at k_max** (`src/count.py`, models projected on x[d][g], capped at 200000).
Translation divides the count by exactly n, and the lex-leader cuts it further:

| n, k | no breaking | translation only | full |
|---|---|---|---|
| 13, 3 | 4420 | 340 | 82 |
| 14, 3 | 8596 | 614 | 206 |
| 15, 4 | 1380 | 92 | 30 |
| 16, 4 | 7424 | 464 | 116 |
| 17, 4 | 51952 | 3056 | 526 |
| 18, 5 | 108 | 6 | 2 |
| 19, 5 | 4788 | 252 | 28 |
| 20, 5 | 26400 | 1320 | 410 |
| 21, 6 | 84 | 4 | 2 |
| 22, 5 | 200000 (cap) | 43330 | 8666 |

### Timings for my n

- Pass 1 (`pass1.sh`, `pass1b.sh`), 05:20–08:48 UTC, 25 min wall cap per n:
  - n = 41: k = 11 UNSAT after about 11 min (kissat). The proof member finished at 16 min and
    wrote a 474 MB proof, which drat-trim verified in 2632 s.
  - n = 51: k = 12 SAT in 148 s.
  - n = 73: k = 15 SAT in 20 s.
  - n = 83: k = 16 SAT in 14 s, k = 17 in 509 s.
  - n = 84: k = 17 SAT in 286 s (translation-only CNF won).
  - Every other attempted k hit the cap: see `logs/n<n>.jsonl` for the per-call seconds.
- Pass 1 correction: for n = 84 and 94 the first launch started at the task's ⌊n/4⌋ − 2 + 1,
  which has no certificate. It was restarted for n = 84 from k = 17. For n = 94 the k = 19
  attempt had already run.
- Pass 2 (`pass2.sh`), 08:48–10:01 UTC:
  - n = 94: k = 18 SAT in 25 s;
  - n = 52: k = 13 on all 4 cores until 10:01, UNKNOWN.
- Re-derived SAT models at the previously known k for n = 41, 52, 62: 15 s, 49 s, 9 s.

## 5. Where things are

- `src/cycenc.c`: DIMACS encoder (the binary `src/cycenc` is git-ignored; build with
  `gcc -O2 -o src/cycenc src/cycenc.c`).
- `src/check4.py`: deliberately simple explicit checker (walk enumeration of 4-cycles).
  `../../CONSTR/check.py`, which uses diagonal enumeration, was also run on `certs.json`:
  see `logs/constr_check.txt` and `logs/check4.txt`. Both give identical 4-cycle counts.
- `src/run.py`: portfolio driver with DRAT checking. `src/drive.py`: per-n first pass.
  `src/pass1.sh`, `src/pass1b.sh`, `src/pass2.sh`: the exact schedules that were run.
- `src/validate.sh`, `src/brute.py`, `src/count.py`: validation, the independent brute force,
  and solution counts.
- `src/cycls.c`: a simple annealer over (D, g). It was too weak to help (it failed to find
  k = 10 at n = 41 in 60 CPU-s), so it was not used for any result.
- `logs/n<n>.jsonl`: every solver call for my n (result, winner, seconds, model, DRAT verdict).
  `logs/validate.jsonl`: every validation call. `logs/drat_*.txt`: drat-trim output.
- `table.tsv`, `solutions.json` ({n: [[d, g], …]}) and `certs.json` ({n: [[u, v, c], …]}).
- Tools: kissat and CaDiCaL (latest master of arminbiere/kissat and arminbiere/cadical, cloned
  2026-10-25) and drat-trim (marijnheule/drat-trim), all built from source in the scratchpad.

## 6. Surprises and next steps

- **Task table typo at n = 14.** The CYC task table says k_max(14) = 4. CONSTR's own record
  (`runs/cycsat/n14.jsonl`: k = 4 UNSAT; `cyclic_family_status.json`: unsat = 4) and my runs
  (DRAT-verified UNSAT at k = 4, plus brute force) all give **k_max(14) = 3**. Every other
  validated n agrees with the table.
- **The ratio k_max/n declines.** Its proved values are exactly 1/4 at n = 28, 32, 36, 40
  (C0), but only 0.244 at n = 41 (proved). The best found values are 0.235 at n = 51–52,
  0.21 at n = 62–84 and 0.19 at n = 94. Beyond about n = 60 these are only lower bounds, so the
  decline could partly reflect SAT difficulty rather than the true optimum.
- **New general lower bounds for M(n).** The cyclic certificates here give M(73) ≥ 1095 and
  M(83) ≥ 1411. These beat CONSTR's previous best (1057 and 1325, from seeded local search),
  and both certificates are re-checked by two independent checkers. Also M(51) ≥ 612
  (CONSTR: 561), M(84) ≥ 1428 and M(94) ≥ 1692.
- **Symmetry breaking.** It is essential for UNSAT: at n = 29, 30, k_max + 1 is UNSAT in
  1–4 s with full breaking, 13–21 s with translation only, and > 600 s with none. For SAT at
  large n the picture is mixed:
  - full breaking found 83/k = 17 and 94/k = 18;
  - the translation-only CNF found 84/k = 17;
  - this agrees with C0's observation that lex constraints can slow SAT finding.
- **Odd behaviour at n = 94.** k = 19 was UNKNOWN after 25 min, yet k = 18 was SAT in 25 s.
  So k = 19 at n = 94 (and k = 18 at n = 83, 84) are good targets for longer runs.
- **Next steps.**
  - Cube-and-conquer on the presence vector for the UNSAT side, e.g. n = 51 k = 13 and
    n = 52 k = 13. With prime n, the lex-leader already forces orbit 1, so cubes could split
    on p_2..p_6.
  - Longer SAT runs at k = k_lo + 1 for n ≥ 62, with more seeds and translation-only CNFs.
  - **Exact sharding plan.** For each open (n, k) run `python3 src/run.py n k --proof --jobs 4
    --timeout T` (one instance per 4-core machine). The open instances are:
    - n = 51, 52 at k = 13;
    - n = 62 at k = 14;
    - n = 73 at k = 16;
    - n = 83, 84 at k = 18;
    - n = 94 at k = 19;
    - n = 84 at k = 21.
    Measured so far:
    - 25 min with 4 solvers on each of these gave no answer;
    - n = 52 k = 13 had a further 70 min (see the table);
    - n = 41 k = 11 needed 11 min to UNSAT, plus 44 min for drat-trim on a 474 MB proof.
