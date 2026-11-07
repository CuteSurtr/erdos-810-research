# CYC/C1: cyclic orbit family, n = 38, 44, 49, 59, 70, 76, 81, 91

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

All computation ran in this cloud container. Session: 2026-10-25, 05:12 to 10:15 UTC.

## 2. Results

**Labels.**

- *proved*: SAT certificate re-verified, plus UNSAT at k+1 with an LRAT proof checked by `src/lratcheck`.
- *certificate-verified*: lower bound only.
- *unfinished*: the next k was neither found SAT nor proved UNSAT.

These are optima of the cyclic family only, not values of M(n). Each lower bound gives M(n) ≥ n·k.

**Headline.**

- **k_max(38) = 9 is proved.** k = 10 is UNSAT, with a 1.19 GB LRAT proof checked by my checker. So CONSTR's 342-edge cyclic example is optimal within the family.
- **n = 44: k = n/4 = 11 is still undecided.** It is the first multiple of 4 above 36 where k = n/4 is in doubt. 25 min of portfolio solving left it open. A cube split then closed 8 of the 9 cubes as UNSAT, 6 of them with checked LRAT (see below). The one open cube has orbits 1, 2, 3 and 4 all present.
- **Observed k/n:** 0.237 (38), 0.227 (44), 0.224 (49), 0.220 (59), 0.214 (70), 0.211 (76), 0.198 (81), 0.198 (91). These are lower bounds, and the decline beyond n = 44 partly reflects the 25-min cap.
- **Multiples of 4:** k = n/4 is SAT at n = 28, 32, 36 (validation) and at n = 40 (CONSTR). It is undecided at n = 44 (11) and n = 76 (19). At n = 76 even k = 17 was unresolved after 25 min.
- **Task-file table:** k_max(14) = 3, not the 4 printed in `tasks/CYC.md`. See the validation section.

**Data-loss note.** The k = 12 result at n = 49 and the k = 14 result at n = 59 were lost. A `git pull --rebase` during a checkpoint replaced the log files that the running driver held open. This was fixed afterwards: the driver now reopens its log for every write.

- The CNF for k + 1 was never generated in either case, so neither k was found SAT.
- At n = 59 the proof job's LRAT file kept growing until the 25-min cap (last write 06:48), so that job did not finish.
- Both are therefore marked *unfinished*.
- The same mechanism hit two cube logs. One result was recovered through `/proc/<pid>/fd`, and the other cube was re-run (`logs/n44_cubes_b.jsonl`, `n44_cubes_c.jsonl`).

**Summary.** The final per-n table (`table.tsv`) follows.

| n | k_lo | k_unsat | status | k_lo/n | seconds | notes |
|---|---|---|---|---|---|---|
| 38 | 9 | 10 | proved k_max=9 | 0.2368 | 171 | LRAT VERIFIED (2199574 added clauses) (11s, proof 1.19 GB) |
| 44 | 10 |  | lower bound 10 certificate-verified; k=11 unfinished (8 of 9 cubes UNSAT) | 0.2273 | 1868 | n/4=11: undecided; cube split on p1..p4: 8 of 9 cubes UNSAT (6 with checked LRAT, 2 solver-only); cube {1,2,3,4 present} UNKNOWN after 33 min (+ 14 min on its two p5 sub-cubes) |
| 49 | 11 |  | lower bound 11 certificate-verified; k=12 unfinished | 0.2245 | 1500 | outcome log of the k+1 portfolio lost (see REPORT); k+1 was not found SAT |
| 59 | 13 |  | lower bound 13 certificate-verified; k=14 unfinished | 0.2203 | 1500 | outcome log of the k+1 portfolio lost (see REPORT); k+1 was not found SAT |
| 70 | 15 |  | lower bound 15 certificate-verified; k=16 unfinished | 0.2143 | 1522 |  |
| 76 | 16 |  | lower bound 16 certificate-verified; k=17 unfinished | 0.2105 | 1522 | k=16 SAT from a separate run; n/4=19: undecided |
| 81 | 16 |  | lower bound 16 certificate-verified; k=17 unfinished | 0.1975 | 1522 |  |
| 91 | 18 |  | lower bound 18 certificate-verified; k=19..20 undecided | 0.1978 | 1523 | k=18 SAT from a separate run; k=19 not tried; k=20 unknown after 25 min portfolio |

### n = 44, k = 11 (= n/4): cube-and-conquer

**Soundness of the split.** The split is on the presence p(1) of orbit 1, then p(2), p(3), p(4). The 9 cubes {p1 = 0} ∪ {p1 = 1} × {±p2} × {±p3} × {±p4} cover every assignment. So the instance is UNSAT iff every cube is UNSAT.

**The p1 = 0 cube.** Under the lex-leader constraint, p1 = 0 means no present orbit is a unit mod 44: if a unit u were present, mapping it to 1 would give a lex-larger vector. The non-unit orbits in 1..21 are the 10 even ones plus 11, exactly 11 orbits. So this cube is a single D, and it is UNSAT in 0.3 s.

**Results.** Wall times are from CaDiCaL 1.7.3 runs without a proof. "LRAT" means a separate run of the same cube wrote a proof, checked by `src/lratcheck` (`logs/proofs.txt`, `logs/proofs_cubes.txt`).

| cube (orbit presence) | result | time | proof |
|---|---|---|---|
| ¬1 | UNSAT | 0.3 s | LRAT checked (5193 lemmas) |
| 1, ¬2, 3, 4 | UNSAT | 120 s | LRAT checked (1.1 GB) |
| 1, ¬2, 3, ¬4 | UNSAT | 5.7 s | LRAT checked |
| 1, ¬2, ¬3, 4 | UNSAT | 4.4 s | LRAT checked |
| 1, ¬2, ¬3, ¬4 | UNSAT | 0.3 s | LRAT checked |
| 1, 2, ¬3, ¬4 | UNSAT | 128 s | LRAT checked (1.5 GB) |
| 1, 2, ¬3, 4 | UNSAT | 775 s | solver only (proof unchecked) |
| 1, 2, 3, ¬4 | UNSAT | 1899 s | solver only (proof unchecked) |
| 1, 2, 3, 4 | **UNKNOWN** | 1980 s cap; its sub-cubes ±5 also UNKNOWN at 840 s each | – |

**Status.** k = 11 at n = 44 is **unfinished**. Assuming the two solver-only cubes, any valid (D, g) with |D| ≥ 11 must, in its lex-leader form under the multipliers, contain orbits 1, 2, 3 and 4. This is the only open region. The first-wave runs of the three hard cubes (08:30) died without output around 09:05 and were relaunched at 09:19. **Suggested next step:** split cube {1, 2, 3, 4} on p5..p8 (16 sub-cubes) with ≥ 1 h each and LRAT, and re-prove the two solver-only cubes with LRAT (about 13 min and 32 min).

## 3. Certificates

`solutions.json` stores (d, g) per n. `certs.json` stores the expanded edge lists `{n: [[u, v, c], ...]}`, checked by `src/certcheck.py` (output in `logs/certcheck.txt`).

- n = 38 (|D| = 9): `[[1, 0], [2, 31], [4, 15], [5, 24], [6, 28], [7, 9], [11, 18], [15, 3], [18, 12]]`
- n = 44 (|D| = 10): `[[1, 0], [2, 17], [3, 5], [4, 22], [8, 1], [11, 6], [13, 29], [16, 25], [18, 41], [19, 7]]`
- n = 49 (|D| = 11): `[[1, 0], [2, 3], [5, 7], [7, 4], [9, 24], [11, 34], [15, 32], [16, 5], [18, 29], [21, 40], [23, 44]]`
- n = 59 (|D| = 13): `[[1, 0], [2, 20], [3, 41], [4, 33], [5, 16], [6, 27], [11, 9], [14, 4], [15, 51], [21, 1], [23, 12], [25, 53], [26, 40]]`
- n = 70 (|D| = 15): `[[1, 0], [2, 11], [3, 29], [5, 56], [8, 50], [11, 7], [12, 33], [16, 62], [18, 37], [19, 43], [20, 14], [24, 52], [25, 15], [30, 68], [34, 47]]`
- n = 76 (|D| = 16): `[[1, 0], [2, 24], [3, 52], [5, 40], [7, 18], [9, 66], [11, 32], [13, 28], [14, 56], [15, 74], [20, 36], [22, 70], [27, 19], [31, 6], [34, 30], [37, 23]]`
- n = 81 (|D| = 16): `[[1, 0], [2, 59], [3, 15], [4, 50], [9, 20], [10, 73], [12, 18], [14, 7], [15, 54], [17, 34], [18, 5], [19, 71], [21, 79], [26, 40], [30, 60], [37, 47]]`
- n = 91 (|D| = 18): `[[1, 0], [2, 86], [3, 69], [4, 65], [9, 53], [10, 24], [12, 46], [13, 51], [14, 20], [16, 45], [18, 37], [20, 12], [21, 31], [26, 39], [30, 89], [33, 35], [34, 76], [41, 82]]`

## 4. Method

### Encoder (`src/cycenc.c`, C, writes DIMACS)

Vertices are Z_n, H = ⌈n/2⌉ − 1, and orbit d ∈ 1..H contributes the edges {i, i+d} coloured i + g(d).

Variables:

- x(d,g) for d ∈ 1..H and g ∈ Z_n means "orbit d is present with offset g". p(d) means "orbit d is present".
- p(d) → OR_g x(d,g) and x(d,g) → p(d). A Sinz sequential counter enforces at most one g per d.

**Re-derived 4-cycle constraint.** Every 4-cycle is a rotation of one through 0, because rotation by t maps the orbit structure to itself and shifts every colour by t. So it suffices to enumerate closed walks 0 → v1 → v2 → v3 → 0 with v1, v2, v3 distinct, nonzero vertices, where each step w − v ≡ ±d with d ∈ 1..H (the diameter n/2 is excluded).

- A step v → v + d uses edge {v, v+d}, which has colour v + g(d), so its offset is v.
- A step v → v − d uses edge {v−d, v}, which has colour v − d + g(d), so its offset is v − d.
- Two edges with orbits d_a ≠ d_b and offsets o_a, o_b get the same colour iff g(d_a) − g(d_b) ≡ o_b − o_a (mod n).
- Two distinct edges in the same orbit have distinct offsets, so they never collide.

For every walk and every pair of its edges in different orbits, the encoder forms the key (d_a < d_b, δ = o_b − o_a, O), where O is the set of the cycle's other orbits (|O| ≤ 2). The key forbids g(d_a) − g(d_b) ≡ δ whenever every orbit in O is present. Presence of d_a and d_b is implied by the x variables.

- Keys are deduplicated in a hash table.
- A key is dropped when the same (d_a, d_b, δ) already appears with a subset of O, since its clause is subsumed.

**Auxiliaries.** y(d_a,d_b,δ) ← x(d_a,g) ∧ x(d_b,g−δ), one ternary clause per g, and only the implication is encoded. Each key then becomes a single clause ¬y ∨ ∨_{o∈O} ¬p(o).

- This is sound: if a model has g(d_a) − g(d_b) = δ, then y is forced and the key clause applies.
- Extra true y values only add constraints, so they cannot create invalid models.

**Cardinality.** Σ p(d) ≥ k is encoded as "at most H − k orbits absent" with a Sinz sequential counter.

**Sizes.** n = 91 gives 101k variables and 8.4M clauses (160 MB), encoded in 7 s. n = 44 gives about 0.9M clauses.

### Symmetry breaking and its soundness

1. **Colour translation (bit 1).** If (D, g) is valid then so is (D, g + t): every colour shifts by t, a bijection of Z_n, so rainbow cycles stay rainbow. The clause ¬p(d) ∨ ∨_{e<d} p(e) ∨ x(d,0) forces g = 0 on the smallest present orbit. Every solution class contains exactly one such representative.
2. **Multipliers (bit 2).** For u ∈ Z_n^×, take φ(i) = ui on vertices and c ↦ uc on colours. Both are bijections of Z_n.
   - Edge {i, i+d} with colour i + g(d) maps to edge {ui, ui + ud} with colour ui + u·g(d).
   - If ud ≡ +e with e ∈ 1..H, this is {j, j+e} with j = ui and colour j + u·g(d), so g′(e) = u·g(d).
   - If ud ≡ −e, this is {j′, j′+e} with j′ = ui − e and colour ui + u·g(d) = j′ + e + u·g(d), so g′(e) = e + u·g(d).
   - The map is a graph isomorphism combined with a colour bijection, so 4-cycles map to 4-cycles and rainbowness is preserved. This gives a group action of Z_n^× on solutions, with p′_e = p_{rep(u⁻¹e)}. The units ±1 act trivially on p.
   - The encoder adds p ≥_lex p∘u for every unit u modulo ±1, comparing positions e = 1..H in order and skipping fixed points.
   - The lex chain uses one auxiliary a_e per position. a_{e−1} → (p_e ≥ q_e), and a_e is forced true when a_{e−1} holds and p_e = q_e. A spuriously true a_e only adds constraints, and the exact assignment satisfies everything.
3. **Combined soundness.** Take any solution (p, g). Its orbit under Z_n^× contains a p* that is lex-maximal, and that p* satisfies p* ≥_lex p*∘v for every v because the action is a group action. Then translate colours so that g(min D) = 0. Translation does not change p, so the result satisfies both families of constraints. Hence SAT with breaking ⇔ SAT without breaking.

**Empirical check.** With and without breaking, k_max agrees on n = 13..28 (n = 29 and 30 without breaking: see the validation notes). Solution counts with |D| ≥ k_max, enumerated with blocking clauses (`logs/symcount.txt`):

- The count without breaking is exactly n × the count with translation only. Examples: 13: 4420 = 13·340, and 14: 8596 = 14·614.
- Adding lex-leader shrinks it further, for example 340 → 82 (n = 13) and 3056 → 526 (n = 17).
- Independently, a brute force over every (D, g) with g(min D) = 0 for n = 14 (`src/brute14.py`) finds 614 valid 3-orbit colourings. This matches the SAT count with translation only exactly. It finds no valid 4-orbit colouring among all 41160 candidates.

### Solving

- **Solvers.** CaDiCaL 1.7.3 (Debian package; building kissat or CaDiCaL from GitHub source was blocked in this container), plus kissat 4.0.4 and CaDiCaL 1.9.5 through `python-sat` 1.9.dev17 (pip).
- **Portfolio per (n, k)** (`src/drive.py`): CaDiCaL seed 0 writing LRAT, CaDiCaL `--sat` seed 1, CaDiCaL `--unsat` seed 2, and kissat. The first verified SAT moves on to k + 1. On UNSAT the driver waits for the proof job.
- **Monotonicity.** Deleting an orbit keeps a colouring valid, so UNSAT at k implies UNSAT for every k′ > k. In particular, k = n/4 is settled whenever a smaller k is UNSAT.
- **Proofs.** LRAT proofs are checked by `src/lratcheck.c`, a small independent RUP checker written for this task (drat-trim could not be built here). It re-propagates every hint chain in order and must reach the empty clause. Tests: it accepts CaDiCaL proofs, and it rejects proofs with one hint removed or with one literal dropped from a lemma. Proofs above 8 GB are abandoned.
- **Checking SAT models.** Every SAT model is decoded to (D, g) and rebuilt as an explicit graph. `src/check.py` then enumerates every 4-cycle by walking a–b–c–d–a. `certs.json` is checked again by `src/certcheck.py`, which works on the raw [u, v, c] edge lists.

## Validation (n = 13..30, 32, 36)

All runs use CaDiCaL 1.7.3 with a 900 s cap (`logs/validation.jsonl`). sym = 3 means translation fix plus lex-leader; sym = 0 means no symmetry breaking. Every SAT model was re-checked by `src/check.py`.

**Discrepancy note.** The compressed table in `tasks/CYC.md` lists "14–17: 4". CONSTR's own data says k_max(14) = 3: both `cyclic_family_status.json` (first UNSAT at k = 4) and the full table in `CONSTR/REPORT.md` (§ k_max). My results agree with CONSTR's data for every n:

- k = 4 is UNSAT for n = 14 with and without symmetry breaking, and with CONSTR's own `cycsat.py`.
- An exhaustive brute force (`src/brute14.py`) finds 0 valid colourings among all 41160 four-orbit candidates with g(min D) = 0.

So this is a transcription slip in the task file, not a disagreement with CONSTR.

| n | k_max (CONSTR) | SAT at k_max (sym 3) | UNSAT at k_max+1 (sym 3) | sym 0 agrees |
|---|---|---|---|---|
| 13 | 3 | ✓ 0.0 s | ✓ 0.0 s | ✓ |
| 14 | 3 | ✓ 0.0 s | ✓ 0.0 s | ✓ (+ brute force) |
| 15 | 4 | ✓ | ✓ 0.0 s | ✓ |
| 16 | 4 | ✓ | ✓ 0.0 s | ✓ |
| 17 | 4 | ✓ | ✓ 0.0 s | ✓ (UNSAT 0.2 s) |
| 18 | 5 | ✓ | ✓ 0.0 s | ✓ |
| 19 | 5 | ✓ | ✓ 0.0 s | ✓ (0.3 s) |
| 20 | 5 | ✓ | ✓ 0.0 s | ✓ (0.5 s) |
| 21 | 6 | ✓ | ✓ 0.0 s | ✓ (0.4 s) |
| 22 | 5 | ✓ | ✓ 0.0 s | ✓ (3.4 s) |
| 23 | 6 | ✓ | ✓ 0.0 s | ✓ (4.7 s) |
| 24 | 6 | ✓ | ✓ 0.1 s | ✓ (5.2 s) |
| 25 | 6 | ✓ | ✓ 0.1 s | ✓ (39.4 s) |
| 26 | 6 | ✓ | ✓ 0.4 s | ✓ (54.5 s) |
| 27 | 7 | ✓ | ✓ 0.2 s | ✓ (67.8 s) |
| 28 | 7 | ✓ | ✓ 0.4 s | ✓ (53.2 s) |
| 29 | 7 | ✓ | ✓ 0.7 s | SAT ✓; sym-0 UNSAT run (900 s cap) left no result line in the log (cause unclear; probably killed with a shell I terminated); not re-run for lack of cores |
| 30 | 7 | ✓ | ✓ 3.1 s | SAT ✓; same as n = 29 |
| 32 | 8 | ✓ 0.1 s | ✓ 1.9 s | – |
| 36 | 9 | ✓ 3.1 s | ✓ 24.9 s | – |

Symmetry breaking speeds up the UNSAT side by 100× or more at n = 25..30.

## Timings (wall clock, 4 cores)

| step | wall |
|---|---|
| validation n = 13..36 (76 runs, 4 parallel) | about 12 min; slowest single run 68 s with sym 0 |
| n = 38: SAT k = 9 in 0.2 s; UNSAT k = 10 in 121 / 148 / 170 s (cadical --sat, kissat, cadical + LRAT); LRAT check 11 s | 3 min |
| n = 44: SAT k = 10 in 0.5 s; k = 11 unknown after a 25 min portfolio, then the cube phase (below) | 25 min + cubes |
| n = 49: SAT k = 11 in 0.4 s; k = 12 portfolio ran its full 25 min (outcome log lost, not SAT) | 25 min |
| n = 59: SAT k = 13 in about 18 s; k = 14 ran its full 25 min (outcome log lost, not SAT) | 25 min |
| n = 70: SAT k = 15 in about 4.5 min; k = 16 unknown after the remaining 20.6 min | 25 min |
| n = 76: k = 17 unknown after 25 min; k = 16 SAT in 117 s (separate nice'd run) | 25 min |
| n = 81: SAT k = 15, 16 within minutes; k = 17 unknown at the cap | 25 min |
| n = 91: k = 20 unknown after 25 min; k = 17 SAT in 3.5 s and k = 16 SAT in 3.2 s (separate runs); k = 18 run, see table | 25 min + extra |

Encoding time: under 1 s for n ≤ 44, 7 s for n = 91.

## 5. Code (`src/`)

| file | purpose |
|---|---|
| `cycenc.c` | DIMACS encoder: `cycenc n k sym out.cnf` (sym bit 1 = translation fix, bit 2 = lex-leader over units) |
| `run.py` | one solver run on one (n, k): `run.py n k sym timeout {cadical,kissat,cd195} seed [lrat_path]`. It decodes the model and re-checks it with `check.py` |
| `drive.py` | per-n portfolio driver: `drive.py n k_lo cap_s`. It logs to `logs/n<n>.jsonl` |
| `chain.sh` | first pass over the 8 values of n, at 25 min each |
| `watchdog.sh` | hard-kills pysat-kissat jobs past their time limit, because pysat's kissat ignores `interrupt()` |
| `check.py` | deliberately simple 4-cycle checker on (D, g) |
| `certcheck.py` | independent checker on raw `[u, v, c]` edge lists (`certs.json`) |
| `lratcheck.c` | small LRAT (RUP-hint) proof checker |
| `count.py` | solution counting with blocking clauses (symmetry-breaking check) |
| `brute14.py` | exhaustive (D, g) search, used for n = 14 |
| `collect.py` | builds `table.tsv`, `solutions.json` and `certs.json` from the logs |

Build: `gcc -O2 -o src/cycenc src/cycenc.c && gcc -O2 -o src/lratcheck src/lratcheck.c`.
Solvers: `apt-get install cadical` (1.7.3) and `pip install python-sat` (provides kissat404 and cadical195; use `/usr/bin/python3`).

To resume an unfinished (n, k), for example on another machine:

```
CYCWORK=/tmp/w python3 src/run.py <n> <k> 3 <seconds> cadical 0 /tmp/w/p.lrat   # UNSAT side, with proof
CYCWORK=/tmp/w python3 src/run.py <n> <k> 3 <seconds> cadical 1                 # --sat config
src/lratcheck /tmp/w/c_<n>_<k>_3.cnf /tmp/w/p.lrat
```

## 6. Surprises and next steps

1. **Task-table slip.** `tasks/CYC.md` gives k_max(14) = 4, but CONSTR's data (and mine, with brute-force confirmation) give k_max(14) = 3. Other CYC agents validating against the compressed table will see this "mismatch" at n = 14 only.
2. **n = 38 is cheap, n = 44 is not.** k = 10 at n = 38 is UNSAT in 2–3 min (LRAT 1.2 GB, checked in 11 s). k = 11 = n/4 at n = 44 survived 25 min on all four portfolio members. The CaDiCaL LRAT stream grew at about 6 MB/s and passed the 8 GB cap at 21 min. So hardness jumps sharply between n ≈ 38 and 44 near k ≈ n/4.
3. **Proof size, not checking time, is the bottleneck.** My LRAT checker handles about 100 MB/s. For long UNSAT runs, a DRAT proof with an external drat-trim, or a binary LRAT stream, would be about 3–5× smaller. Building drat-trim from source was blocked here. A future agent with drat-trim could switch run.py to `--binary=true` DRAT.
4. **Symmetry breaking matters.** On the UNSAT side, the lex-leader over Z_n^×/±1 plus the translation fix gives a speedup of 100× or more already at n = 25..30. Stronger breaking that also uses the g-values is possible: given a fixed p, the stabiliser of p in Z_n^× still acts on g. Adding it would help most at n with many units.
5. **Suggested next step for n/4.** At n = 44, k = 11, spend ≥ 2 h on 4 cores with cube-and-conquer. Split on which unit-class orbits are present. Under lex-leader, orbit 1 is present iff some present orbit is a unit, and both branches are natural cubes. Then run each cube as a separate CaDiCaL job writing its own proof.

