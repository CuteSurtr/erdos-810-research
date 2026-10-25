# CYC/C0: exact optima of the cyclic orbit family for n = 37, 40, 47, 58, 69, 72, 79, 90

## 1. Placement

```
$ uname -a; nproc; free -g
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

All computation ran in this cloud container (4 cores, 15 GB). Wall time was 05:13–10:05 UTC
on 2026-10-25.

## 2. Results

k_max(n) is the largest |D| for which some g makes every 4-cycle rainbow. The graph then has
n·|D| edges and uses n colours.

| n | n mod 4 | k_lo (found) | k_unsat (first UNSAT) | status | k_lo/n | edges n·k_lo |
|---|---|---|---|---|---|---|
| 37 | 1 | 9 | 10 | **k_max = 9, proved** (UNSAT at 10, DRAT verified) | 0.2432 | 333 |
| 40 | 0 | 10 | 11 | **k_max = 10 = n/4, proved** (UNSAT at 11, DRAT verified) | 0.2500 | 400 |
| 47 | 3 | 11 | 12 | **k_max = 11**, UNSAT at 12 (solver, cube-and-conquer over 29 cubes, coverage checked; proofs unchecked) | 0.2340 | 517 |
| 58 | 2 | 13 | – | k_max ≥ 13 certificate-verified; 14 open (3 runs × 21–25 min) | 0.2241 | 754 |
| 69 | 1 | 14 | – | k_max ≥ 14 certificate-verified; 15 open (6 runs, up to 25 min) | 0.2029 | 966 |
| 72 | 0 | 15 | – | k_max ≥ 15 certificate-verified; 16 open (5 runs, up to 30 min); **k = n/4 = 18 not found** (25 min, unfinished) | 0.2083 | 1080 |
| 79 | 3 | 16 | – | k_max ≥ 16 certificate-verified; 17 open (25 min) | 0.2025 | 1264 |
| 90 | 2 | 17 | – | k_max ≥ 17 certificate-verified; 18 open (2 runs × 20–25 min); 20 far off (annealer stuck at 12 violations) | 0.1889 | 1530 |

**Labels.**
- *Proved:* SAT certificate at k, plus UNSAT at k+1 by kissat with a drat-trim-verified DRAT
  proof of the symmetry-broken CNF.
- *Certificate-verified:* explicit (D, g), re-checked by two independent simple checkers.
- *Open / unfinished:* the solver timed out. No claim is made either way.

**Answers to the central question.**
- k = n/4 holds at n = 40 and is optimal there (proved). This extends the CONSTR pattern
  k_max(28, 32, 36) = 7, 8, 9.
- At n = 72 the best found is 15 = n/4 − 3. k = 16, 17 and 18 were not found. SAT attempts
  at 16 (5 runs, up to 30 min, kissat/CaDiCaL/annealer) and at 18 (25 min) all timed out.
  This is heuristic evidence that n/4 breaks down by n = 72. It is *not* a proof: no UNSAT is
  known for n = 72 at any k ≤ 18.
- k_lo/n falls from 0.243–0.250 at n = 37–40 to 0.189 at n = 90:

| n | 37 | 40 | 47 | 58 | 69 | 72 | 79 | 90 |
|---|---|---|---|---|---|---|---|---|
| k_lo/n | 0.243 | 0.250 | 0.234 | 0.224 | 0.203 | 0.208 | 0.203 | 0.189 |

  The values for n ≥ 58 are lower bounds only. The SAT search clearly gets harder at the
  frontier, so the true ratio could be somewhat higher. The trend is still consistent with
  k_max(n)/n → 0 slowly, and not with k_max ≥ εn for a fixed ε ≈ 1/4.

**Relevance to M(n).** These are also lower bounds M(n) ≥ n·k_lo. They improve CONSTR's best
overall constructions at two values:
- n = 58: 754 > 702;
- n = 79: 1264 > 1214.

CONSTR had no entries for n = 69, 72 or 90. At n = 47 the cyclic optimum candidate (517) is
one edge below CONSTR's cyclic + local-search graph (518).

### Discrepancy with the task file (not with CONSTR)

The task file's summary table lists k_max = 4 for n = 14–17. CONSTR's own
`cyclic_family_status.json` gives `"14": {"unsat": 4}`, i.e. k_max(14) = 3. My runs agree
with the json:
- k = 4 is UNSAT at n = 14 under all three symmetry settings;
- an independent brute force over all (D, g) with |D| = 4 and g(min D) = 0, using only the
  explicit 4-cycle checker, finds 0 solutions, against 614 at |D| = 3.

So the "14–17: 4" cell in `tasks/CYC.md` should read "14: 3, 15–17: 4". Every other entry
matched.

## 3. Certificates

- `solutions.json`: {n: [[d, g], …]}, the best (D, g) for each n. Orbit d means edges
  {i, i+d mod n} with colour (i + g) mod n.
- `certs.json`: {n: [[u, v, c], …]}, the explicit edge lists, as in README.
- Both are re-verified by `src/check.py` (from (D, g)) and by `src/verify_certs.py`, an
  independent edge-list checker over all ordered 4-tuples. Output is in
  `logs/verify_certs.txt`; all 8 are OK and |E| = n·k_lo.

```
"37": [[1, 0], [3, 19], [4, 24], [7, 13], [9, 5], [10, 1], [11, 22], [12, 30], [16, 14]]
"40": [[1, 0], [2, 15], [3, 32], [5, 28], [6, 11], [7, 24], [8, 4], [13, 8], [14, 33], [17, 20]]
"47": [[1, 0], [2, 36], [3, 8], [4, 18], [5, 32], [6, 44], [12, 10], [14, 33], [16, 41], [18, 6], [23, 40]]
"58": [[1, 0], [2, 31], [4, 5], [9, 28], [10, 50], [16, 33], [17, 51], [19, 10], [20, 45], [22, 44], [25, 37], [26, 4], [27, 7]]
"69": [[1, 0], [3, 53], [13, 65], [18, 66], [22, 12], [24, 9], [25, 2], [27, 62], [29, 15], [30, 63], [31, 20], [32, 43], [33, 25], [34, 39]]
"72": [[5, 0], [7, 34], [8, 33], [9, 57], [10, 4], [11, 10], [12, 53], [13, 30], [17, 15], [19, 58], [21, 22], [22, 43], [25, 63], [27, 69], [32, 56]]
"79": [[3, 0], [5, 69], [9, 26], [11, 36], [12, 46], [14, 20], [15, 27], [16, 23], [18, 4], [21, 54], [22, 10], [25, 19], [26, 66], [32, 16], [34, 11], [38, 30]]
"90": [[2, 0], [3, 81], [6, 83], [9, 50], [11, 84], [14, 33], [19, 57], [20, 56], [21, 65], [22, 62], [23, 48], [25, 89], [26, 75], [27, 32], [28, 31], [30, 37], [36, 79]]
```

### Validation (CONSTR table, n = 13..30, 32, 36)

SAT at k_max and UNSAT at k_max + 1 under three settings: lex + trans, trans only, and no
symmetry breaking at all. Every SAT model was re-checked explicitly.

| n | k_max (CONSTR json) | SAT at k_max: lex+trans / trans / none | k_max+1: lex+trans / trans / none | secs at k_max+1 |
|---|---|---|---|---|
| 13 | 3 | SAT / SAT / SAT | UNSAT / UNSAT / UNSAT | 0.1 / 0.0 / 0.0 |
| 14 | 3 | SAT / SAT / SAT | UNSAT / UNSAT / UNSAT | 0.0 / 0.0 / 0.1 |
| 15 | 4 | SAT / SAT / SAT | UNSAT / UNSAT / UNSAT | 0.0 / 0.0 / 0.1 |
| 16 | 4 | SAT / SAT / SAT | UNSAT / UNSAT / UNSAT | 0.0 / 0.0 / 0.1 |
| 17 | 4 | SAT / SAT / SAT | UNSAT / UNSAT / UNSAT | 0.0 / 0.0 / 0.4 |
| 18 | 5 | SAT / SAT / SAT | UNSAT / UNSAT / UNSAT | 0.0 / 0.1 / 0.1 |
| 19 | 5 | SAT / SAT / SAT | UNSAT / UNSAT / UNSAT | 0.0 / 0.1 / 0.6 |
| 20 | 5 | SAT / SAT / SAT | UNSAT / UNSAT / UNSAT | 0.0 / 0.1 / 1.2 |
| 21 | 6 | SAT / SAT / SAT | UNSAT / UNSAT / UNSAT | 0.1 / 0.1 / 1.0 |
| 22 | 5 | SAT / SAT / SAT | UNSAT / UNSAT / UNSAT | 0.1 / 0.3 / 4.5 |
| 23 | 6 | SAT / SAT / SAT | UNSAT / UNSAT / UNSAT | 0.1 / 0.3 / 6.3 |
| 24 | 6 | SAT / SAT / SAT | UNSAT / UNSAT / UNSAT | 0.1 / 0.3 / 6.8 |
| 25 | 6 | SAT / SAT / SAT | UNSAT / UNSAT / UNSAT | 0.2 / 1.5 / 48.1 |
| 26 | 6 | SAT / SAT / SAT | UNSAT / UNSAT / UNSAT | 0.4 / 2.3 / 66.5 |
| 27 | 7 | SAT / SAT / SAT | UNSAT / UNSAT / UNSAT | 0.3 / 1.9 / 71.0 |
| 28 | 7 | SAT / SAT / SAT | UNSAT / UNSAT / UNSAT | 0.5 / 2.3 / 58.5 |
| 29 | 7 | SAT / SAT / SAT | UNSAT / UNSAT / UNKNOWN | 1.2 / 12.0 / 235.7 |
| 30 | 7 | SAT / SAT / SAT | UNSAT / UNSAT / UNKNOWN | 4.2 / 19.9 / 224.1 |
| 32 | 8 | SAT / SAT / – | UNSAT / UNSAT / – | 3.2 / 21.8 / – |
| 36 | 9 | SAT / SAT / – | UNSAT / UNSAT / – | 33.3 / 218.9 / – |

"UNKNOWN" means the run was killed after about 230 s. Only the unbroken encoding was killed
(n = 29, 30 at k = 8) to free cores. The lex + trans and trans-only runs both prove UNSAT there.

The proved UNSAT results rely on the encoder. They are backed by the validation above, by
exact solution counts against brute force (§4.2), and by DRAT checks:
- n = 37, k = 10: 138 MB proof, `s VERIFIED` in 142 s;
- n = 40, k = 11: 568 MB proof, `s VERIFIED` in 709 s.

The drat-trim logs are `logs/drat_n37k10.txt` and `logs/drat_n40k11.txt`.

## 4. Method

### 4.1 Encoder (`src/cycenc.c`)

Vertices Z_n, H = ⌈n/2⌉ − 1, orbits d ∈ 1..H. Orbit d present means edges {i, i+d} with colour
i + g(d) mod n.

**Derivation, re-done.** A 4-cycle through 0 is a closed walk 0 → v1 → v2 → v3 → 0 on four
distinct vertices, where each step is ±d for an orbit d.
- A step v → v + d uses the edge {v, v+d}: orbit d, offset v, colour v + g(d).
- A step v → v − d uses the edge {v−d, v}: orbit d, offset v − d, colour v − d + g(d).

The closing step is forced: it is −v3, which must be a legal step (not 0, and not n/2 for even
n, since that orbit is excluded). Every pair of distinct vertices lies in exactly one orbit,
so each walk gives one subgraph. Two edges (d_a, o_a) and (d_b, o_b) with d_a ≠ d_b collide iff
g(d_a) − g(d_b) ≡ o_b − o_a. Two edges in the same orbit with different offsets have different
colours. The encoder asserts that a 4-cycle never has two equal (orbit, offset) pairs.

Rotation by t maps (d, o) to (d, o + t), which leaves every collision condition unchanged.
Every 4-cycle is a rotation of one through 0, so cycles through 0 are enough.

**Keys.** Each colliding pair gives a key (d_a < d_b, δ = o_b − o_a mod n, other orbits of the
cycle minus {d_a, d_b}). There are at most 2 other orbits. Keys are packed into 64-bit
integers, sorted and de-duplicated. For n = 90 that leaves 322,363 keys.

**Variables.**
- x[d][g] = (d−1)·n + g + 1, for "orbit d is present with offset g".
- p[d] = H·n + d, for "orbit d is present".

**Clauses.**
- p[d] ↔ ∨_g x[d][g].
- At most one g per orbit: a Sinz sequential counter (n − 1 auxiliaries per orbit).
- For each (d_a, d_b, δ) that occurs: one auxiliary y with y ← x[d_a][g] ∧ x[d_b][g−δ] for all g.
  That is n ternary clauses. Only this implication direction is needed: y is only ever
  required to be false.
- Each key then becomes the single clause ¬y ∨ ¬p[o1] ∨ ¬p[o2].
- Σ p[d] ≥ k: a Sinz sequential counter on "at most H − k of the ¬p[d]".
- Size for n = 90, k = 22: 94k variables and 8.0M clauses, versus 29M clauses for the direct
  CONSTR-style encoding (`noaux=1`).

`cycenc n k lex trans noaux dump`. `dump=1` prints the keys. They feed the annealer, the
fixed-g experiment and LNS.

### 4.2 Symmetry breaking and its soundness

**Colour translation (trans=1).** Replacing g by g + t adds t to every colour, a bijection of
Z_n, so a rainbow 4-cycle stays rainbow. The presence vector p does not change. So whenever a
solution exists, one exists with g(min D) = 0. Clause, for each d:
¬p[d] ∨ ∨_{e<d} p[e] ∨ x[d][0].

**Multipliers (lex=1).** Take u ∈ Z_n^×. Map vertex i ↦ ui, a graph isomorphism of the
circulant onto its image, and colour c ↦ uc, a bijection of colours.
- The edge {i, i+d} with colour i + g(d) goes to {ui, ui+ud} with colour ui + u·g(d).
- Let ud ≡ σe with e = rep(ud) ∈ 1..H. (Orbit n/2 never arises, because u is a unit and
  d ≠ n/2.)
- If σ = +1: the image is {j, j+e} with j = ui and colour j + u·g(d), so g′(e) = u·g(d).
- If σ = −1: the image is {j−e, j} = {j′, j′+e} with j′ = j − e and colour
  j′ + e + u·g(d), so g′(e) = e + u·g(d).

Isomorphisms map 4-cycles to 4-cycles, and a colour bijection keeps 4 distinct colours
distinct. So (D′, g′) is valid, with p′_e = p_{rep(u⁻¹e)}. Units u and −u induce the same
permutation of orbits, so one representative per {u, −u} is used, u ≠ ±1.

**Lex-leader.** The constraint is p ≥_lex p∘π_u, with p_1 the most significant position and
π_u(e) = rep(u⁻¹e), for every such u. It is encoded with prefix-equality auxiliaries:
- eq_{i−1} → p_i ≥ q_i;
- eq_i ← eq_{i−1} ∧ (p_i ↔ q_i);
- fixed points of π_u are skipped.

**Why it is sound.** Take any solution. Among its images under the full multiplier group,
pick one whose p is lex-maximal. Then p ≥_lex p∘π_u for every u, because p∘π_u is the presence
vector of another image. Next translate its colours to get g(min D) = 0. Translation does not
change p, so the lex constraints still hold. So every satisfiable (n, k) stays satisfiable.

**Empirical checks.**
- *Formula check.* Every SAT model in the validation and production logs was mapped by every
  unit u and by translations t = 1, 2, 3, then re-checked explicitly with `check.py`. All
  938 transformed models were valid (`src/symtest.py`). As a control, the wrong formula
  (dropping the "+e" for σ = −1) gave invalid colourings in 658 of 679 cases.
- *Counts.* Solutions at k_max were enumerated with blocking clauses on x (`src/count.py`)
  and compared with an independent brute force over all (D, g) with g(min D) = 0, which uses
  only `check.py` (`src/brute.py`).

| n | k | brute force (trans) | SAT count, trans only | SAT count, lex + trans |
|---|---|---|---|---|
| 13 | 3 | 340 | 340 | 82 |
| 14 | 3 | 614 | 614 | 206 |
| 15 | 4 | 92 | 92 | 30 |
| 16 | 4 | 464 | 464 | 116 |
| 17 | 4 | 3056 | 3056 | 526 |

The encoding with translation only matches brute force exactly. Lex-leader shrinks the counts
by 3–6× and never to 0.

### 4.3 Checker (`src/check.py`)

The checker is deliberately simple. It builds the explicit edge → colour map from (D, g) and
rejects duplicate edges and colours outside 0..n−1. It then enumerates every 4-cycle a-b-c-d:
for each pair {a, c} it takes every pair {b, d} of common neighbours, and requires 4 distinct
colours. It shares no code with the encoder. Every SAT model from every solver and annealer
run is re-checked with it before it is logged as SAT. `make_table.py` re-checks every best
solution again and asserts |E| = n·k.

### 4.4 Solvers and search

- kissat 4.0.4 and CaDiCaL 3.0.1 were built from the GitHub sources (arminbiere/kissat and
  arminbiere/cadical), along with drat-trim (marijnheule/drat-trim). PySAT (`python-sat`) is
  used for counting and LNS.
- *UNSAT side:* kissat with lex=1, trans=1 and default options. DRAT is written in text format
  and checked by drat-trim (backward mode).
- *SAT side:* kissat `--sat` with lex=0, trans=1 was far better than lex=1 for finding large
  solutions. For example, n=72 k=15 took 25 s with `--sat`/lex=0, while n=72 k=16 with lex=1
  timed out at 600 s. CaDiCaL `--sat` was also used, plus a dedicated annealer
  (`src/cycls.c`) on the same keys.
- *Negative experiments:*
  - Fixed quadratic offsets g(d) = a·d² + b·d (`src/fixg.py`) with an exact RC2 maximum
    independent set over D give at most 8 orbits for n = 40 and 7 for n = 36, below n/4.
  - Annealing plus SAT completion under assumptions (LNS, `src/lns.py`) did not beat plain
    kissat.

### 4.5 Cube-and-conquer for n = 47, k = 12

A single kissat run (lex + trans) reached its 6000 s limit without an answer. Its 12 GB DRAT
file was discarded. After that the problem was split on the presence variables p_2, p_3, p_4,
… The base CNF keeps all symmetry breaking (lex + trans). Each cube adds unit clauses on p_d.
Splitting on variables is complete by construction. `src/cover.py` checks that the UNSAT cubes
cover all 2^m assignments of the split variables.

- Cubes were run by `src/ccdispatch.sh` (at most 4 kissat processes, `--unsat`, per-cube time
  limit 1500–2400 s). Cubes that timed out were split on the next two orbits.
- Log: `logs/cube47.jsonl`, one line per cube with result and time.
- The cubes are solver results only: no DRAT was kept for them.

**Outcome.** 36 cube runs were made. 29 were UNSAT, totalling 9971 s, and 7 timed out and were split further, totalling 11700 s. `python3 src/cover.py logs/cube47.jsonl 47 12` reports `variables [2..10]; UNSAT cubes 29; uncovered assignments 0 of 512`. So n = 47, k = 12 is UNSAT (solver result, proofs unchecked) and **k_max(47) = 11**. The single DRAT-logged run without cubes did not finish in 6000 s. Re-running all 29 UNSAT cubes with DRAT would take about 10^4 s of solving plus several times that in drat-trim, which did not fit before the deadline. That is the obvious way to upgrade this result to *proved*.

| cube (present d / absent −d) | result | seconds |
|---|---|---|
| 2,3,4 | UNKNOWN | 2400.0 |
| 2,-3,4 | UNSAT | 56.5 |
| -2,3,4 | UNSAT | 1.6 |
| -2,-3,4 | UNSAT | 1.2 |
| 2,3,-4 | UNKNOWN | 1800.0 |
| 2,-3,-4 | UNSAT | 40.8 |
| -2,3,-4 | UNSAT | 1.5 |
| -2,-3,-4 | UNSAT | 1.2 |
| 2,3,-4,5,6 | UNSAT | 880.4 |
| 2,3,4,5,6 | UNKNOWN | 1500.0 |
| 2,3,4,5,-6 | UNKNOWN | 1500.0 |
| 2,3,-4,-5,6 | UNSAT | 369.1 |
| 2,3,-4,5,-6 | UNSAT | 705.0 |
| 2,3,4,5,6,7,8 | UNSAT | 4.7 |
| 2,3,4,5,6,7,-8 | UNSAT | 26.1 |
| 2,3,-4,-5,-6 | UNSAT | 231.7 |
| 2,3,4,5,6,-7,8 | UNSAT | 91.5 |
| 2,3,4,5,-6,7,8 | UNSAT | 136.9 |
| 2,3,4,5,-6,7,-8 | UNSAT | 953.0 |
| 2,3,4,-5,-6 | UNKNOWN | 1500.0 |
| 2,3,4,-5,6 | UNKNOWN | 1500.0 |
| 2,3,4,5,6,-7,-8 | UNSAT | 1203.8 |
| 2,3,4,-5,6,7,8 | UNSAT | 71.9 |
| 2,3,4,-5,6,-7,8 | UNSAT | 141.4 |
| 2,3,4,-5,6,7,-8 | UNSAT | 496.0 |
| 2,3,4,-5,6,-7,-8 | UNSAT | 547.3 |
| 2,3,4,5,-6,-7,8 | UNSAT | 936.7 |
| 2,3,4,-5,-6,7,8 | UNSAT | 405.2 |
| 2,3,4,-5,-6,7,-8 | UNSAT | 497.2 |
| 2,3,4,-5,-6,-7,8 | UNSAT | 576.5 |
| 2,3,4,-5,-6,-7,-8 | UNSAT | 499.1 |
| 2,3,4,5,-6,-7,-8 | UNKNOWN | 1500.0 |
| 2,3,4,5,-6,-7,-8,9,10 | UNSAT | 180.5 |
| 2,3,4,5,-6,-7,-8,9,-10 | UNSAT | 309.7 |
| 2,3,4,5,-6,-7,-8,-9,-10 | UNSAT | 262.1 |
| 2,3,4,5,-6,-7,-8,-9,10 | UNSAT | 342.3 |

### 4.6 Timings (single core each, kissat unless noted)

- UNSAT at k_max + 1, lex + trans:
  - n = 36, k = 10: 33 s
  - n = 37, k = 10: 38 s
  - n = 40, k = 11: 188 s, or 206 s while writing DRAT
- n = 47, k = 12: more than 6000 s on one core. Cube-and-conquer: see §4.5.
- SAT at the found k_lo (best single run):
  - n = 37, k = 9: 1.8 s
  - n = 40, k = 10: 51 s
  - n = 47, k = 11: 12 s
  - n = 58, k = 13: 94 s
  - n = 69, k = 14: 5.5 s
  - n = 72, k = 15: 25 s
  - n = 79, k = 16: 130 s
  - n = 90, k = 17: 31 s
- All timeouts are listed in `table.tsv` and `logs/prod.jsonl`.

## 5. Where the code lives (`bruteforce/results/CYC/C0/`)

| file | purpose |
|---|---|
| `src/cycenc.c` | DIMACS encoder (y-aux pair encoding, Sinz counters, lex-leader, translation fix; `dump` mode prints the keys) |
| `src/run.py` | encode → kissat/CaDiCaL (seed, time, `--sat`/`--unsat`, DRAT, `--cube`) → decode → `check.py` → JSON log |
| `src/check.py` | simple explicit 4-cycle checker from (n, D, g) |
| `src/verify_certs.py` | second, independent checker on the edge lists in `certs.json` |
| `src/brute.py`, `src/count.py` | brute-force enumeration and SAT model counting (validation of encoding and symmetry breaking) |
| `src/symtest.py` | empirical test of the multiplier/translation action on all models |
| `src/validate.sh` | validation driver for n = 13..36 |
| `src/cycls.c`, `src/anneal.py` | (D, g) annealer on the same conflict keys |
| `src/lns.py` | anneal + SAT completion under assumptions (did not help) |
| `src/fixg.py` | fixed quadratic offsets + exact max-|D| by RC2 (negative result) |
| `src/ccwork.sh`, `src/ccdispatch.sh`, `src/cover.py` | cube-and-conquer workers and the coverage check |
| `src/queue.sh` | sequential job queue |
| `src/make_table.py` | builds `table.tsv`, `solutions.json` and `certs.json` from the logs and re-checks every solution |
| `logs/` | `validate.jsonl`, `prod.jsonl`, `proof.jsonl`, `cube47.jsonl`, drat-trim outputs, counts, queue files |

Build: `gcc -O2 -o src/cycenc src/cycenc.c` and `gcc -O2 -o src/cycls src/cycls.c -lm`.
Solvers were built from github.com/arminbiere/kissat (4.0.4), github.com/arminbiere/cadical
(3.0.1) and github.com/marijnheule/drat-trim. Paths can be overridden with the `KISSAT`,
`CADICAL` and `SCR` (scratch directory for CNFs) environment variables. Binaries are
git-ignored.

## 6. Surprises and next steps

1. **Task-table typo.** k_max(14) = 3, not 4 (§2). CONSTR's json is right.
2. **Lex-leader cuts both ways.**
   - It speeds UNSAT 5–6× (n = 30: 4.2 s vs 19.9 s; n = 36: 33 s vs 219 s).
   - It strongly hurts SAT at large n: n = 69 k = 15, n = 72 k = 16 and n = 90 k = 20 all
     timed out with lex.
   - `kissat --sat` with only the translation fix found n = 72 k = 15 in 25 s and n = 90 k = 17
     in 31 s.
   - Use lex for UNSAT and no lex for SAT.
3. **Multiples of 4 are not special at n = 72.** n/4 is attained and optimal at 28, 32, 36
   and 40. At 72 even n/4 − 2 = 16 was not found. The divisor-rich n (72, 90) look harder than
   their neighbours (69, 79): compare k_lo(72) = 15 with k_lo(79) = 16.
4. **The cube difficulty is very uneven.**
   - For n = 47, cubes with orbit 2 or 3 absent close in 1–60 s.
   - The cubes with 2, 3, 4 and 5 all present carry nearly all the work.
   - A finer split there (on more small orbits up front) is the natural sharding for the
     next n.

**Sharding plan for what is unfinished.** All commands run from this folder after building
`src/cycenc` and `src/cycls`.

- *UNSAT side, n = 58 at k = 14.* Use the same cube scheme as n = 47, but split on p_2…p_6
  up front (32 cubes):
  `python3 src/run.py 58 14 --cube=<±2,±3,±4,±5,±6> --opt=--unsat --timeout 3600 --log logs/cube58.jsonl`
  - Re-split any cube that times out on the next two orbits.
  - Check coverage with `python3 src/cover.py logs/cube58.jsonl 58 14`.
  - Estimate: n = 47 needed about 6 core-hours of cube runs (21,671 s, see `logs/cube47.jsonl`). n = 58 is
    likely 10–100× harder.
- *SAT side, n = 58 k = 14, n = 69 k = 15, n = 72 k = 16, n = 79 k = 17, n = 90 k = 18.* Run
  many independent seeds:
  `python3 src/run.py N K --lex 0 --seed S --opt=--sat --timeout 3600 --log logs/prod.jsonl`
  - Use seeds S = 100.., one per core.
  - Alternate kissat with `--solver cadical`.
  - Each config has only been tried 1–3 times so far.
- *n = 72 at k = 18 (the n/4 question).* Proving UNSAT is far out of reach with this
  encoding, even at k = 16. A structural argument, or a much stronger symmetry reduction
  (for example the reflection g ↦ d − g(d) from u = −1, which is unused here), would be
  needed.
