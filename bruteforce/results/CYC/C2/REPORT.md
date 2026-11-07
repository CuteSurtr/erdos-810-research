# CYC/C2: cyclic orbit family, n = 39, 48, 50, 61, 71, 80, 82, 93

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

All computation ran in this cloud container. The solvers were built from source:
- kissat and CaDiCaL from `github.com/arminbiere/{kissat,cadical}` master (Oct 2026);
- drat-trim from `github.com/marijnheule/drat-trim`.

pip `python-sat` was not available, so nothing here uses pysat.

## 2. Results

k = |D| orbits, so |E| = n·k, coloured with n colours. Statuses: *proved* means SAT at k plus UNSAT at
k+1 with a checked DRAT proof. Otherwise the line says what is missing.

| n | k_lo | k_unsat | status | k_lo/n | seconds | notes |
|---|---|---|---|---|---|---|
| 39 | 9 | 10 | proved: k_max=9 (UNSAT DRAT-verified) | 0.2308 | 517.8 | k=10 UNSAT: kissat 518 s; CaDiCaL 465 s, DRAT 1.52 GB verified by drat-trim in 1987 s |
| 48 | 11 |  | lower bound (certificate-verified); k=[12] UNKNOWN (timeout) | 0.2292 | 1499.0 | n=4*12; k=12=n/4 UNKNOWN: portfolio 1500 s + kissat --sat 4671 s |
| 50 | 11 |  | lower bound (certificate-verified); k=[12] UNKNOWN (timeout) | 0.2200 | 1499.0 | k=12 UNKNOWN: portfolio 1500 s + kissat --sat 2142 s |
| 61 | 15 |  | lower bound (certificate-verified); k=[16] UNKNOWN (timeout) | 0.2459 | 1495.8 | k=15 found by CaDiCaL at k>=14 (1381 s); k=16 UNKNOWN: kissat --sat 4671 s; CONSTR had 13 |
| 71 | 15 |  | lower bound (certificate-verified); k=[16] UNKNOWN (timeout) | 0.2113 | 1496.9 | k=15 (CONSTR 14); k=16 UNKNOWN after 1460 s portfolio |
| 80 | 16 |  | lower bound (certificate-verified); k=[17, 18, 20] UNKNOWN (timeout) | 0.2000 | 1556.6 | n=4*20; k=16 in 16 s; k=17 UNKNOWN: portfolio 1480 s + kissat --sat 4671 s; k=18 UNKNOWN 900 s; k=20=n/4 UNKNOWN (60 s only) |
| 82 | 16 |  | lower bound (certificate-verified); k=[17] UNKNOWN (timeout) | 0.1951 | 1495.7 | k=16 in 3 s; k=17 UNKNOWN after 1493 s portfolio |
| 93 | 18 |  | lower bound (certificate-verified); k=[19] UNKNOWN (timeout) | 0.1935 | 1495.3 | k=18 in 44 s; k=19 UNKNOWN after 1451 s portfolio |

Additional result: k_max(14) = 3. This corrects the task-file table; see Validation.

**Observed k/n.** 0.231 (39), 0.229 (48), 0.220 (50), 0.246 (61), 0.211 (71), 0.200 (80), 0.195 (82), 0.194 (93).
- **k = n/4.** It is impossible for n = 39 (proved: k_max = 9 < 9.75). It is unresolved for n = 48 (k = 12)
  and n = 80 (k = 20): no solution was found, but there is no UNSAT proof either.
- Best found for those multiples of 4: n = 48 has k = 11 = n/4 − 1, and n = 80 has k = 16 = n/4 − 4.
- **No UNSAT was obtained for any n ≥ 48.** So these are lower bounds only. The decline from about 0.25 to
  about 0.19 reflects solver reach, not proven behaviour.

## 3. Certificates

- `solutions.json`: {n: [[d, g], ...]}. Orbit d is present, and edge {i, i+d} has colour i + g mod n.
- `certs.json`: {n: [[u, v, c], ...]}, the explicit edge lists, |E| = n·k.

Both are re-verified:
- `src/check.py` on every model;
- `src/check_certs.py` on `certs.json` from the explicit edges only. Output in `check_certs.txt`:
  all 8 OK, 0 bad 4-cycles.

Best (D, g) per n:

- n = 39, k = 9: `[[1, 0], [2, 12], [3, 19], [6, 17], [9, 4], [13, 33], [14, 2], [15, 37], [19, 6]]`
- n = 48, k = 11: `[[1, 0], [2, 27], [3, 9], [4, 39], [5, 24], [9, 21], [10, 2], [13, 31], [14, 8], [20, 43], [22, 10]]`
- n = 50, k = 11: `[[1, 0], [2, 36], [3, 24], [10, 19], [11, 4], [12, 38], [14, 44], [16, 33], [18, 13], [20, 11], [21, 28]]`
- n = 61, k = 15: `[[1, 0], [3, 38], [4, 2], [5, 27], [9, 52], [12, 41], [13, 17], [14, 8], [15, 30], [16, 6], [19, 11], [20, 32], [22, 45], [25, 34], [27, 28]]`
- n = 71, k = 15: `[[1, 0], [2, 53], [3, 30], [4, 47], [5, 63], [7, 10], [8, 41], [9, 26], [16, 13], [19, 24], [20, 64], [22, 40], [30, 34], [32, 16], [33, 7]]`
- n = 80, k = 16: `[[1, 0], [3, 30], [4, 29], [7, 75], [8, 73], [9, 53], [10, 49], [11, 35], [13, 17], [15, 5], [16, 23], [17, 58], [21, 67], [30, 78], [35, 36], [36, 12]]`
- n = 82, k = 16: `[[1, 0], [5, 41], [6, 1], [8, 10], [12, 55], [16, 7], [18, 75], [21, 69], [22, 56], [23, 72], [24, 53], [26, 42], [30, 74], [31, 58], [32, 38], [38, 46]]`
- n = 93, k = 18: `[[1, 0], [2, 18], [6, 80], [8, 13], [11, 30], [12, 85], [18, 42], [21, 71], [27, 88], [28, 43], [29, 2], [30, 39], [34, 90], [36, 69], [39, 76], [42, 1], [44, 4], [45, 35]]`


## 4. Method

### Encoder (`src/cycenc.c`)

Usage `cycenc n k sym [extra-clauses]`, DIMACS on stdout. H = ⌈n/2⌉ − 1.

- x(d,g), d ∈ 1..H, g ∈ Z_n: orbit d present with offset g. p(d) ↔ ∨_g x(d,g); at most one g per d
  (sequential counter, n − 1 aux per orbit).
- 4-cycles: all closed walks 0 → v1 → v2 → v3 → 0 with v1, v2, v3 distinct and nonzero and each step
  ±d, d ∈ 1..H (O(n³) walks). Step v → v+d uses edge {v, v+d}, offset v. Step v → v−d uses edge {v−d, v},
  offset v − d. So the colour is offset + g(d). For each pair of cycle edges in different orbits a < b
  with offsets o_a, o_b, the colours coincide iff g(a) − g(b) ≡ o_b − o_a =: δ. Key = (a, b, δ, set of the
  other orbits on the cycle, at most 2). Two edges in the same orbit with the same offset would be the same
  edge, so they cannot both lie on a 4-cycle. The encoder asserts this never happens.
- Keys are sorted and deduplicated. For each distinct (a, b, δ), one auxiliary y(a,b,δ) is defined by
  the n clauses ¬x(a,g) ∨ ¬x(b,g−δ) ∨ y (only the implication y ⇐ x∧x is needed). Each key then gives
  the single clause ¬y ∨ ¬p(o1) ∨ ¬p(o2). Presence of a and b is implied by y.
- Rotation i ↦ i+1 maps orbit edges to orbit edges and shifts every colour by 1, so every 4-cycle is
  a rotation of one through vertex 0 with the same colour coincidences. Cycles through 0 suffice.
- Σ p(d) ≥ k: sequential counter r(i,j) ("at least j of p1..pi"), with r(i,j) → r(i−1,j) ∨ p_i,
  r(i,j) → r(i−1,j) ∨ r(i−1,j−1), r(i,j) false for j > i, and the unit r(H,k).
- Size at n = 93, k = 5: 4.45M raw keys, 374k distinct keys, 96k y variables, 106k vars, 9.35M clauses.

### Symmetry breaking and its soundness

sym = 0: none. sym = 1: colour translation only. sym = 2: translation plus lex-leader under Z_n^×.

**Colour translation.** If (D, g) is valid, so is (D, g + t), because every colour is shifted by t.
This is a bijection on colours, so distinct colours stay distinct. The encoder adds, for each d, the clause
p(d) ∧ ¬p(1) ∧ … ∧ ¬p(d−1) → x(d, 0). In words: the smallest present orbit has g = 0. Every solution can
be translated to satisfy this without changing p.

**Multipliers.** Let u ∈ Z_n^×. Map vertices i ↦ ui and colours c ↦ uc. Both maps are bijections of Z_n,
so a 4-cycle maps to a 4-cycle and a rainbow cycle stays rainbow. Edge {i, i+d} of colour i + g(d) maps to
{ui, ui+ud} of colour ui + u·g(d). Write ud ≡ σe with e = rep(ud) ∈ 1..H. (ud ≢ 0 and ud ≢ n/2 because
u is a unit and d ≠ n/2.)
- σ = +1: the image edge is {j, j+e} with j = ui, colour j + u·g(d). So g′(e) = u·g(d).
- σ = −1: the image edge is {ui−e, ui} = {j, j+e} with j = ui − e, colour ui + u·g(d) = j + e + u·g(d).
  So g′(e) = e + u·g(d).

Every image edge has the orbit form, so the image is again a family member, with D′ = rep(uD). Hence
p′_e = p_{rep(u⁻¹e)}. The map d ↦ rep(ud) is a permutation of 1..H, and u and −u give the same permutation.

**Lex-leader.** For every unit u ∈ 2..⌊n/2⌋ the encoder adds p ≥_lex p∘π_u, where
(p∘π_u)_e = p_{rep(u⁻¹e)} and positions are ordered 1..H. It uses the standard chain e_i with
e_{i−1} → (a_i ∨ ¬b_i) and e_i ⇐ e_{i−1} ∧ (¬a_i ∨ b_i), where e_i means "prefix equal". Fixed positions are skipped.

**Soundness.** Take any valid (D, g). Among its images under Z_n^×, pick u* whose presence vector is
lex-maximal. Because the action is a group action, that vector is ≥_lex all its images, so it satisfies
every lex clause. Then translate colours so the smallest present orbit has g = 0. Translation does not
change p, so the lex clauses stay satisfied. So if any valid configuration with |D| ≥ k exists, the
symmetry-broken formula is SAT. The converse is trivial because breaking only adds clauses. k_max is unchanged.

**Empirical check** (`src/count_p.py`, `src/orbits.py`, `symcheck.txt`). We enumerated all optimal D at
k_max by SAT with blocking clauses, without breaking (sym 0) and with it (sym 2). We then computed the
Z_n^× orbits of the sym-0 sets. In every case the sym-2 count equals the number of orbits exactly, and
every sym-2 set is the lex-max of its orbit:

| n | k | #D (no breaking) | #orbits | #D (sym 2) |
|---|---|---|---|---|
| 13 | 3 | 20 | 4 | 4 |
| 15 | 4 | 14 | 4 | 4 |
| 20 | 5 | 42 | 12 | 12 |
| 24 | 6 | 144 | 43 | 43 |
| 27 | 7 | 63 | 7 | 7 |

### Validation (n = 13..30, 32, 36)

Expected values come from CONSTR's `cyclic_family_status.json`, where k_max = (first UNSAT k) − 1.
For each n we ran SAT at k_max and UNSAT at k_max + 1, with symmetry breaking (sym 2) and without it (sym 0).
Every SAT model was decoded and re-checked by `src/check.py`. That checker builds the explicit graph on Z_n
and enumerates every 4-cycle a-b-c-d through common neighbours of each vertex pair. It also checks colours
in 0..n−1 and n·|D| distinct edges. sym-2 UNSAT runs used CaDiCaL with a DRAT proof checked by drat-trim.
Raw lines are in `validation.jsonl`.

**Discrepancy with the task file, not with CONSTR.** The task file's summary table says k_max = 4 for n = 14.
CONSTR's own status JSON says k = 4 is UNSAT at n = 14, so k_max(14) = 3. We get k_max(14) = 3:
- k = 4 is UNSAT with and without breaking;
- an independent exhaustive search without SAT (`src/brute_small.py`) also finds no configuration.

That search enumerates every 4-subset D and every g with g(min D) = 0, pruning by the simple checker.
Pruning is sound because removing an orbit removes edges, and validity is closed under removing edges.
Every other value agrees with both CONSTR and the task table. The task table's "14–17: 4" should read
"14: 3, 15–17: 4".

`brute_small.py` also confirms UNSAT at k_max + 1 for n = 13..21 by direct enumeration (`brute_small.txt`).

| n | k_max (ours) | SAT at k_max: sym0 / sym2 (s, model re-checked) | UNSAT at k_max+1, sym0 (s) | UNSAT at k_max+1, sym2 (s, DRAT) | CONSTR k_max |
|---|---|---|---|---|---|
| 13 | 3 | ✓ 0.0 / ✓ 0.0 | UNSAT 0.1 | UNSAT 0.0 VERIFIED | 3 |
| 14 | 3 | ✓ 0.0 / ✓ 0.0 | UNSAT 0.1 | UNSAT 0.0 VERIFIED | 3 |
| 15 | 4 | ✓ 0.0 / ✓ 0.0 | UNSAT 0.1 | UNSAT 0.0 VERIFIED | 4 |
| 16 | 4 | ✓ 0.0 / ✓ 0.0 | UNSAT 0.1 | UNSAT 0.0 VERIFIED | 4 |
| 17 | 4 | ✓ 0.0 / ✓ 0.0 | UNSAT 0.4 | UNSAT 0.0 VERIFIED | 4 |
| 18 | 5 | ✓ 0.1 / ✓ 0.0 | UNSAT 0.1 | UNSAT 0.0 VERIFIED | 5 |
| 19 | 5 | ✓ 0.1 / ✓ 0.0 | UNSAT 0.6 | UNSAT 0.0 VERIFIED | 5 |
| 20 | 5 | ✓ 0.1 / ✓ 0.0 | UNSAT 1.1 | UNSAT 0.0 VERIFIED | 5 |
| 21 | 6 | ✓ 0.1 / ✓ 0.1 | UNSAT 0.8 | UNSAT 0.0 VERIFIED | 6 |
| 22 | 5 | ✓ 0.0 / ✓ 0.1 | UNSAT 4.9 | UNSAT 0.0 VERIFIED | 5 |
| 23 | 6 | ✓ 0.1 / ✓ 0.1 | UNSAT 6.3 | UNSAT 0.0 VERIFIED | 6 |
| 24 | 6 | ✓ 0.1 / ✓ 0.1 | UNSAT 6.4 | UNSAT 0.1 VERIFIED | 6 |
| 25 | 6 | ✓ 0.0 / ✓ 0.1 | UNSAT 43.3 | UNSAT 0.1 VERIFIED | 6 |
| 26 | 6 | ✓ 0.0 / ✓ 0.0 | UNSAT 70.1 | UNSAT 0.3 VERIFIED | 6 |
| 27 | 7 | ✓ 0.2 / ✓ 0.1 | UNSAT 119.5 | UNSAT 0.2 VERIFIED | 7 |
| 28 | 7 | ✓ 0.2 / ✓ 0.2 | UNSAT 95.3 | UNSAT 0.4 VERIFIED | 7 |
| 29 | 7 | ✓ 0.0 / ✓ 0.4 | UNSAT 691.4 | UNSAT 3.2 VERIFIED | 7 |
| 30 | 7 | ✓ 0.1 / ✓ 0.1 | UNSAT 799.0 | UNSAT 18.1 VERIFIED | 7 |
| 32 | 8 | ✓ 3.5 / ✓ 2.5 | not run | UNSAT 11.4 VERIFIED | 8 |
| 36 | 9 | ✓ 5.6 / ✓ 2.5 | not run | UNSAT 36.2 VERIFIED | 9 |

sym-0 UNSAT runs for n = 32 and 36 were lost (see the surprises section) and not re-run. sym 0 and sym 2 agree for every n = 13..30.


### Per-n procedure as run, and timings

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
  Seconds in `table.tsv` are first-pass portfolio wall time summed over the k values tried. The second pass is in the notes column.

## 5. Code (`src/`)

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

## 6. Surprises and suggested next steps

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
