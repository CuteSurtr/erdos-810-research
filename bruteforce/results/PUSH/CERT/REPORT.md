# PUSH/CERT: standard-checker proofs for n = 38, 42, 47, and k_max(35)

All computation ran in this cloud container, 2026-10-25 10:35–16:00 UTC.

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          14           0           0          15
Swap:              0           0           0
```

The processes ran in a memory cgroup with a 14.3 GB limit.

## 2. Results

All statements are about the cyclic orbit family of `tasks/CYC.md` (vertices Z_n, |E| = n·|D|,
n colours). "UNSAT" means UNSAT of the CNF named in §4, whose equivalence to the family question
rests on the encoder's correctness and on the symmetry-breaking soundness argument of CYC/C0, C1 and
C4 (summarised in §4.2). Every UNSAT proof below was checked by a **standard checker**: drat-trim
(DRAT), or cake_lpr (LRAT; a CakeML-verified checker).

| item | result | status |
|---|---|---|
| n = 38, k = 10 | UNSAT. DRAT 0.20 GB, drat-trim `s VERIFIED` (C1 encoder, sym 3). Cross-checks, all cake_lpr `s VERIFIED UNSAT`: C4 encoder sym 2 (LRAT 0.52 GB); C1 encoder **without lex-leader** (translation only, LRAT 6.4 GB) | **proved**: k_max(38) = 9 (SAT certificate at 9 re-verified) |
| n = 42, k = 11 | UNSAT. LRAT 6.40 GB from CaDiCaL 3.0.1 (2392 s), cake_lpr `s VERIFIED UNSAT` in 678 s (C4 encoder, sym 2: same encoder and options as C4's solver runs; C4 recorded no CNF hash). Cross-check: C1 encoder sym 3, LRAT 7.2 GB, cake_lpr `s VERIFIED UNSAT` | **proved**: k_max(42) = 10 (SAT certificate at 10 re-verified) |
| n = 47, k = 12 | all 29 cubes of C0's split are UNSAT, each with its own LRAT proof checked by cake_lpr (C0 encoder, lex + trans). Coverage re-checked by `src/cover.py`: 0 of 512 assignments of p2..p10 uncovered. Cross-check: the same 29 cubes on C1's encoder (sym 3), all cake_lpr `s VERIFIED UNSAT`, coverage again 0 of 512 uncovered | **proved**: k_max(47) = 11 (SAT certificate at 11 re-verified) |
| n = 35, k = 8 | SAT, (D, g) below, re-verified by two simple checkers | certificate-verified |
| n = 35, k = 9 | UNSAT. kissat DRAT 0.09 GB, drat-trim `s VERIFIED` (C1 encoder, sym 3). Cross-checks, all cake_lpr `s VERIFIED UNSAT`: C4 encoder sym 2; C1 encoder **without lex-leader** (translation only) | **proved**: **k_max(35) = 8** |

Consequences for the k_max table: k_max(35) = 8 (new; 280 edges). k_max(38) = 9, k_max(42) = 10 and
k_max(47) = 11 are upgraded from a task-written checker, a timed-out check, and unchecked
cube-and-conquer solver results respectively, to standard-checker proofs.

Note that k_max(35) = 8 < k_max(36) = 9 = 36/4 and k_max(34) = 8, so k_max(n)/n at n = 35 is 0.229.

All planned cross-checks finished before the deadline (§6).

## 3. Certificates

`certs.json` holds the explicit edge lists `{"n": [[u, v, colour], ...]}` for the SAT side at
k_max. `solutions.json` holds the same as (D, g) pairs:

- n = 35, k = 8: `[[2, 0], [3, 2], [4, 7], [6, 1], [10, 16], [14, 28], [15, 23], [16, 25]]` (new, found by kissat `--sat` in 1 s)
- n = 38, k = 9: `[[1, 0], [2, 31], [4, 15], [5, 24], [6, 28], [7, 9], [11, 18], [15, 3], [18, 12]]` (from C1)
- n = 42, k = 10: `[[3, 0], [4, 15], [8, 38], [10, 13], [11, 33], [12, 36], [13, 29], [14, 32], [17, 6], [20, 12]]` (from C4)
- n = 47, k = 11: `[[1, 0], [2, 36], [3, 8], [4, 18], [5, 32], [6, 44], [12, 10], [14, 33], [16, 41], [18, 6], [23, 40]]` (from C0)

All four were re-checked by `src/check4.py` (builds the graph from (D, g); for each vertex pair
{a, c}, every pair of common neighbours gives a 4-cycle) and by `src/check_certs.py` (reads only the
explicit edge list, checks simple graph and colours in 0..n−1, enumerates 4-cycles over vertex
4-tuples). Output in `logs/check_certs.txt`: 280, 342, 420 and 517 edges; 6825, 11020, 16947 and
25850 4-cycles; all rainbow.

## 4. Method

### 4.1 Tools

| tool | source | version |
|---|---|---|
| CaDiCaL | Ubuntu apt package `cadical` | 1.7.3 (DRAT, n = 38) |
| CaDiCaL | github.com/arminbiere/cadical, commit c607304 (2026-07-19) | 3.0.1 (binary LRAT, `--lrat --binary=true`) |
| kissat | github.com/arminbiere/kissat, commit 8af8e56 | 4.0.4 (binary DRAT) |
| drat-trim | github.com/marijnheule/drat-trim, commit 2e3b2dc, `gcc -O2` | backward mode, `-t` limit |
| cake_lpr | github.com/tanyongkiam/cake_lpr, commit a36874a, `gcc -O2 basis_ffi.c cake_lpr.S` | CakeML-verified LRAT/LPR checker (binary LRAT input) |

A first attempt to build everything in one command was refused by the session's auto-mode
classifier. Installing CaDiCaL 1.7.3 from apt and building each tool separately worked. One
discrepancy: `cake_lpr.sha256` in that repo lists a hash for `basis_ffi.c` that does not match the
file at commit a36874a (the other three entries match). The last commit changed `basis_ffi.c` and
apparently did not refresh the hash list. `basis_ffi.c` is the unverified FFI shim (file I/O,
command line); the checking logic is in the verified `cake_lpr.S`, whose hash matches. cake_lpr
accepted its own `example.lpr` and every proof here. It also refused CaDiCaL 1.7.3's binary LRAT
("failed to parse line"); text LRAT from 1.7.3 and binary LRAT from 3.0.1 both work.

### 4.2 Encoders and symmetry breaking

I used three encoders from earlier tasks unchanged (copies in `src/cycenc_C0.c`, `cycenc_C1.c`,
`cycenc_C4.c`, sha256 in §5). All three:
- use x(d, g) = 1 + (d−1)n + g and p(d) = Hn + d;
- use one auxiliary y per (d_a, d_b, δ) colour coincidence;
- use a sequential counter for Σ p ≥ k;
- were validated by their authors against brute force and CONSTR's k_max for n = 13..30, 32, 36.

The symmetry breaking is the same in all three:
- **Translation:** g(min D) = 0.
- **Lex-leader:** p ≥_lex p∘π_u for every unit u mod ±1, where π_u(e) = rep(u⁻¹e).

The soundness argument is in C0 REPORT §4.2, C1 REPORT §4 and C4 REPORT §4:
- (D, g) ↦ (uD, g′), with g′(e) = u·g(d) or e + u·g(d), is a graph isomorphism combined with a
  colour bijection.
- Picking the lex-maximal p in the Z_n^× orbit and then translating colours gives a representative
  that satisfies both constraint families.

So "UNSAT with breaking" ⇒ "UNSAT without breaking". The proofs certify the symmetry-broken CNF.

| run | encoder | CNF |
|---|---|---|
| n38k10_C1s3, n35k9_C1s3 | C1 `cycenc n k 3 out.cnf` | translation + lex |
| n38k10_C4s2, n35k9_C4s2, n42k11_C4s2_lrat | C4 `cycenc n k 2 > out.cnf` | translation + lex |
| n47k12_cube_* | C0 `cycenc 47 12 1 1 > base.cnf` (base sha256 `5cc11b0c…0faf5`) plus the cube's unit clauses on p_d, appended by `src/mkcube.py` | lex + translation |

### 4.3 Proof pipeline (`src/prove.sh`, `src/worker.sh`)

`prove.sh TAG CNF SOLVER T_solve T_check`:
1. hashes the CNF;
2. runs the solver with a proof (`kissat … CNF proof` or `cadical --binary=true …` for binary DRAT,
   `cadical-3.0.1 --lrat --binary=true` for binary LRAT);
3. on UNSAT, runs drat-trim (`drat-trim CNF proof -t T`) or cake_lpr (`cake_lpr CNF proof`);
4. appends one JSON line (CNF sha256, header, solver and version, result, solve time, proof bytes,
   checker, check time, the checker's verdict line) to `logs/proofs.jsonl`;
5. deletes the proof.

The tail of each checker's output is kept in `logs/dt_<tag>.txt`. `worker.sh` pops jobs from a
shared queue under flock. `src/tables.py` generates the tables in §4.5 and `n47_tree.json`.

### 4.4 n = 47 cube split and coverage

The split is C0's (`results/CYC/C0/logs/cube47.jsonl`, the 29 cubes logged UNSAT):
- n = 47 is prime, so every orbit is a unit. Under the lex-leader, p1 holds whenever D ≠ ∅, so p1
  is not split.
- The cubes fix literals on p2..p10.
- `src/cover.py` (written here, independent of C0's `cover.py`) takes the cubes from my proof log.
- It enumerates all 2^9 = 512 assignments of p2..p10 and counts those that extend no cube with a
  verified proof.

Result (`logs/cover47.txt`):
`split variables [2..10]; cubes 29 (29 with verified proof); assignments not covered: by any cube 0, by verified cubes 0 (of 512)`.
A cube is a conjunction of unit clauses added to the base CNF, so "every assignment of p2..p10
extends an UNSAT cube" gives UNSAT of the base CNF. The tree is in `n47_tree.json`: one entry per
proof run, including the two OOM-killed checks, which were redone.

Totals over the 29 verified cubes: 8806 s of CaDiCaL 3.0.1 solving and 2857 s of cake_lpr checking
(the check times include waiting for the checker lock). The LRAT proofs total 27.7 GB, the largest
3.85 GB (cube 2,3,4,5,6,¬7,¬8). For comparison, C0's kissat runs on the same cubes took 9971 s.

### 4.5 All proof runs

### Single instances

| tag | CNF sha256 (prefix) | vars clauses | solver | result | solve s | proof | checker | check s | verdict |
|---|---|---|---|---|---|---|---|---|---|
| n38k10_C1s3 | `dc4b226fd61f0580…` | 7462 234670 | cadical 1.7.3 | UNSATISFIABLE | 150 | 0.20 GB | drat-trim 2e3b2dc | 551 | s VERIFIED |
| n35k9_C1s3 | `cc5d07c3ef4f1f2a…` | 6243 178607 | kissat 4.0.4 | UNSATISFIABLE | 70 | 0.09 GB | drat-trim 2e3b2dc | 279 | s VERIFIED |
| n42k11_C4s2_lrat | `60a35d25900c6496…` | 9089 382029 | cadical 3.0.1 lrat | UNSATISFIABLE | 2392 | 6.40 GB | cake_lpr a36874a | 678 | s VERIFIED UNSAT |
| n35k9_C4s2 | `4fd4c852011832a4…` | 5657 195675 | cadical 3.0.1 lrat | UNSATISFIABLE | 54 | 0.23 GB | cake_lpr a36874a | 20 | s VERIFIED UNSAT |
| n38k10_C4s2 | `03ee1d4e2c6309ab…` | 6795 255277 | cadical 3.0.1 lrat | UNSATISFIABLE | 139 | 0.52 GB | cake_lpr a36874a | 41 | s VERIFIED UNSAT |
| n35k9_C1s1 | `9cae6d2968cdae01…` | 6086 178125 | cadical 3.0.1 lrat | UNSATISFIABLE | 1002 | 3.72 GB | cake_lpr a36874a | 348 | s VERIFIED UNSAT |
| n38k10_C1s1 | `9db49ee91ebe29f2…` | 7326 234254 | cadical 3.0.1 lrat | UNSATISFIABLE | 2065 | 6.42 GB | cake_lpr a36874a | 813 | s VERIFIED UNSAT |
| n42k11_C1s3 | `f8a748528b6af86a…` | 9919 353460 | cadical 3.0.1 lrat | UNSATISFIABLE | 2537 | 7.16 GB | cake_lpr a36874a | 756 | s VERIFIED UNSAT |

### n = 47, k = 12 cubes

| tag | CNF sha256 (prefix) | vars clauses | solver | result | solve s | proof | checker | check s | verdict |
|---|---|---|---|---|---|---|---|---|---|
| n47k12_cube_2_3_4_5_6_7_8 | `083e7d8c7c7880a7…` | 14812 610129 | cadical 3.0.1 lrat | UNSATISFIABLE | 2 | 0.01 GB | cake_lpr a36874a | 2 | s VERIFIED UNSAT |
| n47k12_cube_2_3_4_5_6_7_m8 | `d14c1b43725a3c16…` | 14812 610129 | cadical 3.0.1 lrat | UNSATISFIABLE | 20 | 0.06 GB | cake_lpr a36874a | 70 | s VERIFIED UNSAT |
| n47k12_cube_2_3_4_5_6_m7_8 | `85ab95e713749f7a…` | 14812 610129 | cadical 3.0.1 lrat | UNSATISFIABLE | 91 | 0.31 GB | cake_lpr a36874a | 30 | s VERIFIED UNSAT |
| n47k12_cube_2_3_4_5_6_m7_m8 | `ec0dc210c71d3c34…` | 14812 610129 | cadical 3.0.1 lrat | UNSATISFIABLE | 1399 | 3.85 GB | cake_lpr a36874a | 266 | NO VERDICT:  |
| n47k12_cube_2_3_4_5_6_m7_m8 | `ec0dc210c71d3c34…` | 14812 610129 | cadical 3.0.1 lrat | UNSATISFIABLE | 1160 | 3.85 GB | cake_lpr a36874a | 345 | s VERIFIED UNSAT |
| n47k12_cube_2_3_4_5_m6_7_8 | `eb8d6d41b1c2e9c2…` | 14812 610129 | cadical 3.0.1 lrat | UNSATISFIABLE | 128 | 0.50 GB | cake_lpr a36874a | 36 | s VERIFIED UNSAT |
| n47k12_cube_2_3_4_5_m6_7_m8 | `a5c6be7a97bdbe10…` | 14812 610129 | cadical 3.0.1 lrat | UNSATISFIABLE | 972 | 2.57 GB | cake_lpr a36874a | 235 | s VERIFIED UNSAT |
| n47k12_cube_2_3_4_5_m6_m7_8 | `628d42bbe8347eec…` | 14812 610129 | cadical 3.0.1 lrat | UNSATISFIABLE | 958 | 2.56 GB | cake_lpr a36874a | 230 | s VERIFIED UNSAT |
| n47k12_cube_2_3_4_5_m6_m7_m8_9_10 | `d350bc0d31bb9e05…` | 14812 610131 | cadical 3.0.1 lrat | UNSATISFIABLE | 139 | 0.60 GB | cake_lpr a36874a | 60 | s VERIFIED UNSAT |
| n47k12_cube_2_3_4_5_m6_m7_m8_9_m10 | `ef72beae7347d0ff…` | 14812 610131 | cadical 3.0.1 lrat | UNSATISFIABLE | 236 | 0.89 GB | cake_lpr a36874a | 84 | s VERIFIED UNSAT |
| n47k12_cube_2_3_4_5_m6_m7_m8_m9_10 | `f6a782a5c26ab5a4…` | 14812 610131 | cadical 3.0.1 lrat | UNSATISFIABLE | 238 | 0.89 GB | cake_lpr a36874a | 95 | s VERIFIED UNSAT |
| n47k12_cube_2_3_4_5_m6_m7_m8_m9_m10 | `ffa35cf3b47d836b…` | 14812 610131 | cadical 3.0.1 lrat | UNSATISFIABLE | 202 | 0.77 GB | cake_lpr a36874a | 82 | s VERIFIED UNSAT |
| n47k12_cube_2_3_4_m5_6_7_8 | `adf7b254ebd8550f…` | 14812 610129 | cadical 3.0.1 lrat | UNSATISFIABLE | 66 | 0.24 GB | cake_lpr a36874a | 22 | s VERIFIED UNSAT |
| n47k12_cube_2_3_4_m5_6_7_m8 | `67b89bbf4224e6a5…` | 14812 610129 | cadical 3.0.1 lrat | UNSATISFIABLE | 412 | 1.46 GB | cake_lpr a36874a | 130 | s VERIFIED UNSAT |
| n47k12_cube_2_3_4_m5_6_m7_8 | `d93ff71275ac6b31…` | 14812 610129 | cadical 3.0.1 lrat | UNSATISFIABLE | 109 | 0.44 GB | cake_lpr a36874a | 38 | s VERIFIED UNSAT |
| n47k12_cube_2_3_4_m5_6_m7_m8 | `f0eefc67e598b194…` | 14812 610129 | cadical 3.0.1 lrat | UNSATISFIABLE | 701 | 1.70 GB | cake_lpr a36874a | 161 | s VERIFIED UNSAT |
| n47k12_cube_2_3_4_m5_m6_7_8 | `0344ef2a3faf0925…` | 14812 610129 | cadical 3.0.1 lrat | UNSATISFIABLE | 338 | 1.21 GB | cake_lpr a36874a | 109 | s VERIFIED UNSAT |
| n47k12_cube_2_3_4_m5_m6_7_m8 | `b8b10305d8c16682…` | 14812 610129 | cadical 3.0.1 lrat | UNSATISFIABLE | 388 | 1.36 GB | cake_lpr a36874a | 145 | s VERIFIED UNSAT |
| n47k12_cube_2_3_4_m5_m6_m7_8 | `3f515bbbdeefa85a…` | 14812 610129 | cadical 3.0.1 lrat | UNSATISFIABLE | 602 | 1.46 GB | cake_lpr a36874a | 199 | s VERIFIED UNSAT |
| n47k12_cube_2_3_4_m5_m6_m7_m8 | `4c014ef5483b5c0c…` | 14812 610129 | cadical 3.0.1 lrat | UNSATISFIABLE | 328 | 1.22 GB | cake_lpr a36874a | 124 | s VERIFIED UNSAT |
| n47k12_cube_2_3_m4_5_6 | `407becead54e9986…` | 14812 610127 | cadical 3.0.1 lrat | UNSATISFIABLE | 681 | 2.29 GB | cake_lpr a36874a | 214 | s VERIFIED UNSAT |
| n47k12_cube_2_3_m4_5_m6 | `01b68dc3ff0c73d5…` | 14812 610127 | cadical 3.0.1 lrat | UNSATISFIABLE | 636 | 1.76 GB | cake_lpr a36874a | 296 | s VERIFIED UNSAT |
| n47k12_cube_2_3_m4_m5_6 | `a44a87e142a067e4…` | 14812 610127 | cadical 3.0.1 lrat | UNSATISFIABLE | 247 | 0.84 GB | cake_lpr a36874a | 76 | NO VERDICT:  |
| n47k12_cube_2_3_m4_m5_6 | `a44a87e142a067e4…` | 14812 610127 | cadical 3.0.1 lrat | UNSATISFIABLE | 234 | 0.84 GB | cake_lpr a36874a | 80 | s VERIFIED UNSAT |
| n47k12_cube_2_3_m4_m5_m6 | `79745bc81d336941…` | 14812 610127 | cadical 3.0.1 lrat | UNSATISFIABLE | 122 | 0.48 GB | cake_lpr a36874a | 44 | s VERIFIED UNSAT |
| n47k12_cube_2_m3_4 | `5aef8c79e3269be9…` | 14812 610125 | cadical 3.0.1 lrat | UNSATISFIABLE | 26 | 0.11 GB | cake_lpr a36874a | 10 | s VERIFIED UNSAT |
| n47k12_cube_2_m3_m4 | `ccaa93aeec5f9667…` | 14812 610125 | cadical 3.0.1 lrat | UNSATISFIABLE | 18 | 0.08 GB | cake_lpr a36874a | 9 | s VERIFIED UNSAT |
| n47k12_cube_m2_3_4 | `1a5dc658a164dc2c…` | 14812 610125 | cadical 3.0.1 lrat | UNSATISFIABLE | 0 | 0.00 GB | cake_lpr a36874a | 2 | s VERIFIED UNSAT |
| n47k12_cube_m2_3_m4 | `8e2e02b3df0be3e3…` | 14812 610125 | cadical 3.0.1 lrat | UNSATISFIABLE | 0 | 0.00 GB | cake_lpr a36874a | 2 | s VERIFIED UNSAT |
| n47k12_cube_m2_m3_4 | `bccd07f168316fe2…` | 14812 610125 | cadical 3.0.1 lrat | UNSATISFIABLE | 0 | 0.00 GB | cake_lpr a36874a | 2 | s VERIFIED UNSAT |
| n47k12_cube_m2_m3_m4 | `370f4d0601133d13…` | 14812 610125 | cadical 3.0.1 lrat | UNSATISFIABLE | 0 | 0.00 GB | cake_lpr a36874a | 2 | s VERIFIED UNSAT |

### n = 47, k = 12 cubes, cross-check with C1's encoder

| tag | CNF sha256 (prefix) | vars clauses | solver | result | solve s | proof | checker | check s | verdict |
|---|---|---|---|---|---|---|---|---|---|
| n47C1_cube_2_3_4_5_6_7_8 | `68ab369f473ad890…` | 14790 587798 | cadical 3.0.1 lrat | UNSATISFIABLE | 2 | 0.01 GB | cake_lpr a36874a | 2 | s VERIFIED UNSAT |
| n47C1_cube_2_3_4_5_6_7_m8 | `2b94c3f73792b48e…` | 14790 587798 | cadical 3.0.1 lrat | UNSATISFIABLE | 22 | 0.08 GB | cake_lpr a36874a | 39 | s VERIFIED UNSAT |
| n47C1_cube_2_3_4_5_6_m7_8 | `096209ff7e91636d…` | 14790 587798 | cadical 3.0.1 lrat | UNSATISFIABLE | 102 | 0.32 GB | cake_lpr a36874a | 25 | s VERIFIED UNSAT |
| n47C1_cube_2_3_4_5_6_m7_m8 | `026fb85b3afe3fe4…` | 14790 587798 | cadical 3.0.1 lrat | UNSATISFIABLE | 1154 | 3.65 GB | cake_lpr a36874a | 346 | s VERIFIED UNSAT |
| n47C1_cube_2_3_4_5_m6_7_8 | `5457208794a44a1e…` | 14790 587798 | cadical 3.0.1 lrat | UNSATISFIABLE | 152 | 0.48 GB | cake_lpr a36874a | 37 | s VERIFIED UNSAT |
| n47C1_cube_2_3_4_5_m6_7_m8 | `e0c32321b068c948…` | 14790 587798 | cadical 3.0.1 lrat | UNSATISFIABLE | 784 | 2.71 GB | cake_lpr a36874a | 254 | s VERIFIED UNSAT |
| n47C1_cube_2_3_4_5_m6_m7_8 | `3f2c808e1c7b8665…` | 14790 587798 | cadical 3.0.1 lrat | UNSATISFIABLE | 780 | 2.54 GB | cake_lpr a36874a | 476 | s VERIFIED UNSAT |
| n47C1_cube_2_3_4_5_m6_m7_m8_9_10 | `82ccd808341580db…` | 14790 587800 | cadical 3.0.1 lrat | UNSATISFIABLE | 165 | 0.67 GB | cake_lpr a36874a | 51 | s VERIFIED UNSAT |
| n47C1_cube_2_3_4_5_m6_m7_m8_9_m10 | `995f7bba1ace0a85…` | 14790 587800 | cadical 3.0.1 lrat | UNSATISFIABLE | 233 | 0.87 GB | cake_lpr a36874a | 78 | s VERIFIED UNSAT |
| n47C1_cube_2_3_4_5_m6_m7_m8_m9_10 | `5a186c8fd153e805…` | 14790 587800 | cadical 3.0.1 lrat | UNSATISFIABLE | 250 | 0.95 GB | cake_lpr a36874a | 92 | s VERIFIED UNSAT |
| n47C1_cube_2_3_4_5_m6_m7_m8_m9_m10 | `538fb6df9f27dcc3…` | 14790 587800 | cadical 3.0.1 lrat | UNSATISFIABLE | 185 | 0.74 GB | cake_lpr a36874a | 67 | s VERIFIED UNSAT |
| n47C1_cube_2_3_4_m5_6_7_8 | `322614070e656d08…` | 14790 587798 | cadical 3.0.1 lrat | UNSATISFIABLE | 65 | 0.25 GB | cake_lpr a36874a | 22 | s VERIFIED UNSAT |
| n47C1_cube_2_3_4_m5_6_7_m8 | `df49f27d1c9631f1…` | 14790 587798 | cadical 3.0.1 lrat | UNSATISFIABLE | 403 | 1.39 GB | cake_lpr a36874a | 121 | s VERIFIED UNSAT |
| n47C1_cube_2_3_4_m5_6_m7_8 | `82df7f448264a566…` | 14790 587798 | cadical 3.0.1 lrat | UNSATISFIABLE | 102 | 0.41 GB | cake_lpr a36874a | 35 | s VERIFIED UNSAT |
| n47C1_cube_2_3_4_m5_6_m7_m8 | `0c8a1fbfcf8465bb…` | 14790 587798 | cadical 3.0.1 lrat | UNSATISFIABLE | 479 | 1.66 GB | cake_lpr a36874a | 163 | s VERIFIED UNSAT |
| n47C1_cube_2_3_4_m5_m6_7_8 | `4dcc2b67da1cfa95…` | 14790 587798 | cadical 3.0.1 lrat | UNSATISFIABLE | 337 | 1.18 GB | cake_lpr a36874a | 166 | s VERIFIED UNSAT |
| n47C1_cube_2_3_4_m5_m6_7_m8 | `be03a5ced2bd8a03…` | 14790 587798 | cadical 3.0.1 lrat | UNSATISFIABLE | 358 | 1.30 GB | cake_lpr a36874a | 131 | s VERIFIED UNSAT |
| n47C1_cube_2_3_4_m5_m6_m7_8 | `852bc7706d1a450b…` | 14790 587798 | cadical 3.0.1 lrat | UNSATISFIABLE | 424 | 1.44 GB | cake_lpr a36874a | 145 | s VERIFIED UNSAT |
| n47C1_cube_2_3_4_m5_m6_m7_m8 | `061128e668876a57…` | 14790 587798 | cadical 3.0.1 lrat | UNSATISFIABLE | 339 | 1.23 GB | cake_lpr a36874a | 129 | s VERIFIED UNSAT |
| n47C1_cube_2_3_m4_5_6 | `0265657eceada211…` | 14790 587796 | cadical 3.0.1 lrat | UNSATISFIABLE | 708 | 2.32 GB | cake_lpr a36874a | 228 | s VERIFIED UNSAT |
| n47C1_cube_2_3_m4_5_m6 | `5179e29896e3fd4f…` | 14790 587796 | cadical 3.0.1 lrat | UNSATISFIABLE | 484 | 1.69 GB | cake_lpr a36874a | 186 | s VERIFIED UNSAT |
| n47C1_cube_2_3_m4_m5_6 | `9c33a8ad9259c16e…` | 14790 587796 | cadical 3.0.1 lrat | UNSATISFIABLE | 232 | 0.82 GB | cake_lpr a36874a | 88 | s VERIFIED UNSAT |
| n47C1_cube_2_3_m4_m5_m6 | `585015c7ab43cd38…` | 14790 587796 | cadical 3.0.1 lrat | UNSATISFIABLE | 130 | 0.51 GB | cake_lpr a36874a | 94 | s VERIFIED UNSAT |
| n47C1_cube_2_m3_4 | `d980dd59ff5a531f…` | 14790 587794 | cadical 3.0.1 lrat | UNSATISFIABLE | 27 | 0.11 GB | cake_lpr a36874a | 12 | s VERIFIED UNSAT |
| n47C1_cube_2_m3_m4 | `5aa8b9fc26d8d301…` | 14790 587794 | cadical 3.0.1 lrat | UNSATISFIABLE | 20 | 0.09 GB | cake_lpr a36874a | 38 | s VERIFIED UNSAT |
| n47C1_cube_m2_3_4 | `c6a2b11a95835e71…` | 14790 587794 | cadical 3.0.1 lrat | UNSATISFIABLE | 0 | 0.00 GB | cake_lpr a36874a | 2 | s VERIFIED UNSAT |
| n47C1_cube_m2_3_m4 | `56f0d98005fe77b5…` | 14790 587794 | cadical 3.0.1 lrat | UNSATISFIABLE | 0 | 0.00 GB | cake_lpr a36874a | 2 | s VERIFIED UNSAT |
| n47C1_cube_m2_m3_4 | `289e86b8ad700cf0…` | 14790 587794 | cadical 3.0.1 lrat | UNSATISFIABLE | 0 | 0.00 GB | cake_lpr a36874a | 2 | s VERIFIED UNSAT |
| n47C1_cube_m2_m3_m4 | `2cf61902eff37853…` | 14790 587794 | cadical 3.0.1 lrat | UNSATISFIABLE | 0 | 0.00 GB | cake_lpr a36874a | 2 | s VERIFIED UNSAT |

"NO VERDICT" rows are two cake_lpr runs killed by the memory cgroup (OOM). Four checks of about 4.2 GB
each ran at once. Both cubes were re-solved and re-checked (the `s VERIFIED UNSAT` row under each).
After that, `prove.sh` allows at most two cake_lpr runs at a time. Tags `n47C1_cube_*` are the
second sweep with C1's encoder (§6).

### 4.6 Timeline and abandoned attempts

- **drat-trim on large proofs is too slow here.**
  - n = 38: 199 MB DRAT, 551 s check. n = 35: 92 MB, 279 s.
  - Three n = 47 cubes solved by kissat (0.9–1.1 GB DRAT each) were still not checked after 60–105
    min of drat-trim. I killed them and redid those cubes with LRAT.
  - The n = 42 DRAT (2.51 GB, CaDiCaL 1.7.3, 35 min solve, sha256 of the CNF as in the
    n42k11_C4s2_lrat row) ran 81 min in drat-trim. I killed it once the LRAT proof of the same CNF
    had been verified.
  - None of these runs gave a verdict; they are not counted anywhere.
- **LRAT + cake_lpr is the right pipeline.** CaDiCaL 3.0.1 solves these instances about as fast as
  kissat 4.0.4. Its binary LRAT is 2–3× larger than DRAT. cake_lpr checks it in about 20–35 % of
  the solve time (for example 6.4 GB in 678 s).
- **Worker incident.** The first two queue workers were started with relative paths. A
  `git pull --rebase` recreated the results directory under them, so they drained the n = 47 queue
  without running anything. No results were affected. I rebuilt the queue, and `worker.sh` now
  uses absolute paths.

## 5. Code and files (`bruteforce/results/PUSH/CERT/`)

| file | purpose |
|---|---|
| `src/cycenc_C0.c`, `src/cycenc_C1.c`, `src/cycenc_C4.c` | verbatim copies of the encoders of CYC/C0, C1 and C4 (sha256 `82d0019f…`, `866a463c…`, `e0ee15fa…`) |
| `src/prove.sh` | solver with proof, then checker, then one JSON line to `logs/proofs.jsonl` |
| `src/worker.sh` | flock queue worker running `prove.sh` |
| `src/mkcube.py` | base CNF + cube unit clauses on p_d = Hn + d |
| `src/cover.py` | coverage check of a presence-bit cube split against verified proofs |
| `src/satrun.py` | SAT search with decoding and re-check (used for n = 35, k = 8, 9) |
| `src/check4.py`, `src/check_certs.py` | simple 4-cycle checkers, from (D, g) and from the explicit edge list |
| `src/tables.py`, `src/sweep_status.py`, `src/make_report.sh` | tables of §4.5, `n47_tree.json`, and the assembly of this REPORT from `report_head.md` and `report_tail.md` |
| `logs/proofs.jsonl` | one line per proof run: CNF sha256, header, solver and version, result, times, proof bytes, checker, verdict line |
| `logs/dt_<tag>.txt` | tail of each checker's output |
| `logs/n35.jsonl` | n = 35 SAT runs (k = 8 SAT in 1 s; k = 9 `--sat` 600 s UNKNOWN) |
| `logs/cover47.txt`, `logs/cover47_C1.txt`, `logs/check_certs.txt`, `logs/cubes47_queue.txt` | coverage output, certificate checks, and the C0 cube list (with C0's kissat times) |
| `certs.json`, `solutions.json`, `n47_tree.json` | certificates and the n = 47 cube tree |

Reproduce one result, for example n = 42:
```
gcc -O2 -o cycenc_C4 src/cycenc_C4.c && ./cycenc_C4 42 11 2 > n42.cnf      # sha256 60a35d25…
cadical-3.0.1 --lrat --binary=true n42.cnf n42.lrat                         # 2392 s, 6.4 GB
cake_lpr n42.cnf n42.lrat                                                   # s VERIFIED UNSAT, 678 s
```
n = 47: `./cycenc_C0 47 12 1 1 > base.cnf`. For each cube in `logs/cubes47_queue.txt`, run
`python3 src/mkcube.py base.cnf 47 <cube> c.cnf`, then the same two commands. Then run
`python3 src/cover.py logs/proofs.jsonl n47k12_cube_`.

## 6. Surprises and next steps

- **k_max(35) = 8.** n = 35 sits between k_max(34) = 8 and k_max(36) = 9 = n/4. So the step to 9
  happens exactly at the multiple of 4.
- **Independence from the multiplier argument.** For n = 35 (k = 9) and n = 38 (k = 10), the UNSAT
  proof also goes through with translation-only breaking (C1 sym 1, no lex-leader), checked by
  cake_lpr. Translation is a trivially sound symmetry. So these two results do not depend on the
  lex-leader soundness argument at all. For n = 42 and n = 47 the proofs use the lex-leader.
- **Independence from one encoder.** n = 35 and n = 38 are UNSAT under both the C1 and C4 encoders.
  n = 42 is UNSAT under both C4 (the main proof) and C1, and n = 47 under both C0 (main) and C1. All
  these cross-check runs used LRAT checked by cake_lpr.
- **n = 47 under a second encoder.** 29 of the 29 cubes of C0's split have verified UNSAT proofs under the C1 encoder (`cycenc 47 12 3`, base sha256 9aca8a76…); coverage: `split variables [2, 3, 4, 5, 6, 7, 8, 9, 10]; cubes 29 (29 with verified proof); assignments not covered: by any cube 0, by verified cubes 0 (of 512)`. Totals: 7937 s solving, 3031 s checking, 27.4 GB of LRAT. So n = 47 also holds under two encoders. Both use the lex-leader.
- **Suggestion.** Future PUSH and CYC agents should use CaDiCaL ≥ 2 with binary LRAT and cake_lpr
  instead of DRAT and drat-trim. In this container, drat-trim did not finish 1 GB proofs in 100 min,
  while cake_lpr checked 6–7 GB in 11–13 min. Limit concurrent cake_lpr runs to (memory limit)/4.3 GB.
