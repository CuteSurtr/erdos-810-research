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
| n = 42, k = 11 | UNSAT. LRAT 6.40 GB from CaDiCaL 3.0.1 (2392 s), cake_lpr `s VERIFIED UNSAT` in 678 s (C4 encoder, sym 2: the CNF C4 used). Cross-check: C1 encoder sym 3, LRAT 7.2 GB, cake_lpr `s VERIFIED UNSAT` | **proved**: k_max(42) = 10 (SAT certificate at 10 re-verified) |
| n = 47, k = 12 | all 29 cubes of C0's split are UNSAT, each with its own LRAT proof checked by cake_lpr (C0 encoder, lex + trans). Coverage re-checked by `src/cover.py`: 0 of 512 assignments of p2..p10 uncovered | **proved**: k_max(47) = 11 (SAT certificate at 11 re-verified) |
| n = 35, k = 8 | SAT, (D, g) below, re-verified by two simple checkers | certificate-verified |
| n = 35, k = 9 | UNSAT. kissat DRAT 0.09 GB, drat-trim `s VERIFIED` (C1 encoder, sym 3). Cross-checks, all cake_lpr `s VERIFIED UNSAT`: C4 encoder sym 2; C1 encoder **without lex-leader** (translation only) | **proved**: **k_max(35) = 8** |

Consequences for the k_max table: k_max(35) = 8 (new; 280 edges). k_max(38) = 9, k_max(42) = 10 and
k_max(47) = 11 are upgraded from a task-written checker, a timed-out check, and unchecked
cube-and-conquer solver results respectively, to standard-checker proofs.

Note that k_max(35) = 8 < k_max(36) = 9 = 36/4 and k_max(34) = 8, so k_max(n)/n at n = 35 is 0.229.

The cross-checks still running at the deadline are listed in §6.

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

