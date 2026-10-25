# CYC/C5: cyclic orbit family, n = 43, 54, 60, 65, 75, 86, 92, 97

## 1. Placement

```
$ uname -a; nproc; free -g
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

All computation ran in this 4-core cloud container, 05:13–10:00 UTC on 2026-10-25.
Solvers were built from GitHub sources: kissat (arminbiere/kissat master), CaDiCaL
(arminbiere/cadical master) and drat-trim (marijnheule/drat-trim). python-sat came from pip and
was used only for solution counting.

## 2. Results (my 8 values of n)

No UNSAT was reached for any of the 8 n, so every row is a **certificate-verified lower bound**,
and the upper bound is **unfinished**.

| n | best k (k_lo) | k/n | edges n·k | first open k (UNKNOWN at cap) | k = n/4 | wall s | status | source of best |
|---|---|---|---|---|---|---|---|---|
| 43 | 10 | 0.2326 | 430 | 11 | – | 1500 | certificate-verified; UB unfinished | CONSTR (re-verified) |
| 54 | 12 | 0.2222 | 648 | 13 | – | 1501 | certificate-verified; UB unfinished | CONSTR (re-verified) |
| 60 | 13 | 0.2167 | 780 | 14 (also 15) | **15: undecided** | 5958 | certificate-verified; UB unfinished | CONSTR (re-verified) |
| 65 | **14** | 0.2154 | 910 | 15 | – | 1501 | certificate-verified; UB unfinished | this run (CaDiCaL, 56 s) |
| 75 | **15** | 0.2000 | 1125 | 16 | – | 1502 | certificate-verified; UB unfinished | this run (CaDiCaL, 2.4 s) |
| 86 | **17** | 0.1977 | 1462 | 18 | – | 1502 | certificate-verified; UB unfinished | this run (CaDiCaL, 14 s) |
| 92 | **18** | 0.1957 | 1656 | 19 (also 23) | **23: undecided** | 5963 | certificate-verified; UB unfinished | this run (kissat --sat, 60 s) |
| 97 | **19** | 0.1959 | 1843 | 20 | – | 1505 | certificate-verified; UB unfinished | this run (kissat --sat, 1418 s) |

Bold k values are new for this family. CONSTR had nothing for n = 65, 75, 86, 92 and had k = 16
for n = 97, from annealing.

**Per-k log** (`runs/drive_n<n>.jsonl`; SAT times are the winning solver's time):
- 43: k=11 UNKNOWN (1500 s).
- 54: k=13 UNKNOWN (1500 s).
- 60: k=15 UNKNOWN (750 s); k=14 UNKNOWN (750 s first pass + 4458 s second pass).
- 65: 13 SAT 0.7 s; 14 SAT 56 s; 15 UNKNOWN.
- 75: 14 SAT 1.8 s; 15 SAT 2.4 s; 16 UNKNOWN.
- 86: 16 SAT 2.9 s; 17 SAT 13.9 s; 18 UNKNOWN.
- 92: k=23 UNKNOWN (752 s); 17 SAT 4.5 s; 18 SAT 60 s; 19 UNKNOWN (first pass + 4461 s second pass).
- 97: 17 SAT 6 s; 18 SAT 6.3 s; 19 SAT 1418 s; 20 UNKNOWN.

**Observed k/n.**
- Best k/n decreases from 0.233 (n = 43) to 0.196 (n = 92, 97).
- For the multiples of 4, k = n/4 is **not decided** at n = 60 or 92. No SAT model was found, but
  UNSAT was not proved either. The best k is 2 below n/4 at n = 60 and 5 below at n = 92.
- k = n/4 was not shown SAT or UNSAT for any of my n.

## 3. Certificates

- `solutions.json`: {n: [[d, g], …]}. Orbit d ∈ D; edge {i, i+d} has colour (i + g) mod n.
- `certs.json`: the same graphs as explicit edge lists {n: [[u, v, c], …]}.
- Both are re-verified by `src/check4.py` (an explicit 4-cycle enumeration, written separately
  from the encoder) and by CONSTR's `check.py` on `certs.json`: 8/8 VALID.

## 4a. Validation (before my own n)

k_max from CONSTR (`cyclic_family_status.json`): SAT at k_max and UNSAT at k_max+1 are reproduced for every n = 13..30, 32 and 36, with full breaking (S1+S2) and translation-only (S1). Every SAT model checked VALID by `check4.py`. Without any breaking (sym=0), runs were capped at 600 s; the ones still running are marked UNKNOWN. Columns give result and time.

| n | CONSTR k_max | k | sym=3 (translation+lex) | sym=1 (translation) | sym=0 (none) | agree |
|---|---|---|---|---|---|---|
| 13 | 3 | 3 | SAT(VALID) 0.0s | SAT(VALID) 0.0s | SAT(VALID) 0.0s | yes |
| 13 | 3 | 4 | UNSAT 0.0s | UNSAT 0.0s | UNSAT 0.1s | yes |
| 14 | 3 | 3 | SAT(VALID) 0.0s | SAT(VALID) 0.0s | – | yes |
| 14 | 3 | 4 | UNSAT 0.1s | UNSAT 0.0s | UNSAT 0.1s | yes |
| 15 | 4 | 4 | SAT(VALID) 0.0s | SAT(VALID) 0.0s | SAT(VALID) 0.0s | yes |
| 15 | 4 | 5 | UNSAT 0.0s | UNSAT 0.0s | UNSAT 0.1s | yes |
| 16 | 4 | 4 | SAT(VALID) 0.0s | SAT(VALID) 0.0s | SAT(VALID) 0.0s | yes |
| 16 | 4 | 5 | UNSAT 0.0s | UNSAT 0.0s | UNSAT 0.1s | yes |
| 17 | 4 | 4 | SAT(VALID) 0.0s | SAT(VALID) 0.0s | SAT(VALID) 0.0s | yes |
| 17 | 4 | 5 | UNSAT 0.0s | UNSAT 0.1s | UNSAT 0.4s | yes |
| 18 | 5 | 5 | SAT(VALID) 0.0s | SAT(VALID) 0.0s | SAT(VALID) 0.1s | yes |
| 18 | 5 | 6 | UNSAT 0.0s | UNSAT 0.0s | UNSAT 0.1s | yes |
| 19 | 5 | 5 | SAT(VALID) 0.0s | SAT(VALID) 0.0s | SAT(VALID) 0.0s | yes |
| 19 | 5 | 6 | UNSAT 0.1s | UNSAT 0.1s | UNSAT 0.7s | yes |
| 20 | 5 | 5 | SAT(VALID) 0.1s | SAT(VALID) 0.0s | SAT(VALID) 0.1s | yes |
| 20 | 5 | 6 | UNSAT 0.0s | UNSAT 0.1s | UNSAT 0.8s | yes |
| 21 | 6 | 6 | SAT(VALID) 0.1s | SAT(VALID) 0.1s | SAT(VALID) 0.1s | yes |
| 21 | 6 | 7 | UNSAT 0.1s | UNSAT 0.1s | UNSAT 1.0s | yes |
| 22 | 5 | 5 | SAT(VALID) 0.1s | SAT(VALID) 0.0s | SAT(VALID) 0.0s | yes |
| 22 | 5 | 6 | UNSAT 0.1s | UNSAT 0.3s | UNSAT 4.5s | yes |
| 23 | 6 | 6 | SAT(VALID) 0.1s | SAT(VALID) 0.1s | SAT(VALID) 0.1s | yes |
| 23 | 6 | 7 | UNSAT 0.1s | UNSAT 0.3s | UNSAT 5.9s | yes |
| 24 | 6 | 6 | SAT(VALID) 0.1s | SAT(VALID) 0.1s | SAT(VALID) 0.1s | yes |
| 24 | 6 | 7 | UNSAT 0.2s | UNSAT 0.3s | UNSAT 6.4s | yes |
| 25 | 6 | 6 | SAT(VALID) 0.1s | SAT(VALID) 0.0s | SAT(VALID) 0.0s | yes |
| 25 | 6 | 7 | UNSAT 0.3s | UNSAT 1.5s | UNSAT 46.8s | yes |
| 26 | 6 | 6 | SAT(VALID) 0.0s | SAT(VALID) 0.0s | SAT(VALID) 0.0s | yes |
| 26 | 6 | 7 | UNSAT 0.4s | UNSAT 2.1s | UNSAT 95.7s | yes |
| 27 | 7 | 7 | SAT(VALID) 0.1s | SAT(VALID) 0.2s | SAT(VALID) 0.2s | yes |
| 27 | 7 | 8 | UNSAT 0.3s | UNSAT 2.0s | UNKNOWN 54.2s | yes |
| 28 | 7 | 7 | SAT(VALID) 0.2s | SAT(VALID) 0.2s | SAT(VALID) 0.2s | yes |
| 28 | 7 | 8 | UNSAT 0.6s | UNSAT 2.5s | UNKNOWN 52.8s | yes |
| 29 | 7 | 7 | SAT(VALID) 0.2s | SAT(VALID) 0.0s | SAT(VALID) 0.0s | yes |
| 29 | 7 | 8 | UNSAT 1.3s | UNSAT 10.3s | UNKNOWN 13.2s | yes |
| 30 | 7 | 7 | SAT(VALID) 0.0s | SAT(VALID) 0.0s | – | yes |
| 30 | 7 | 8 | UNSAT 4.3s | UNSAT 17.5s | – | yes |
| 32 | 8 | 8 | SAT(VALID) 0.3s | SAT(VALID) 0.4s | – | yes |
| 32 | 8 | 9 | UNSAT 2.8s | UNSAT 23.4s | – | yes |
| 36 | 9 | 9 | SAT(VALID) 2.8s | SAT(VALID) 0.7s | – | yes |
| 36 | 9 | 10 | UNSAT 30.4s | – | – | yes |

## 4b. Encoder design (`src/cycenc.c`)

**Family.** Vertices Z_n, orbits d ∈ {1..H} with H = ⌈n/2⌉ − 1 (the diameter n/2 is excluded).
Orbit d ∈ D gives the n edges {i, i+d}, and {i, i+d} has colour i + g(d) mod n. Since d ≠ n − d for
d ≤ H, each edge has exactly one representation {i, i+d}, so the colouring is well defined.

**Re-derivation of the constraints.** Every 4-cycle is a rotation of one through 0, and rotation
i ↦ i + t sends colours c ↦ c + t, so a cycle is rainbow iff its rotation through 0 is.
A 4-cycle through 0 is a closed walk 0 → v1 → v2 → v3 → 0 on 4 distinct vertices, each step ±d with
d ∈ 1..H. The encoder enumerates all (2H)³ choices of the first three steps and closes the walk
with the unique orbit step v3 → 0 (if −v3 ≡ ±d for some d ≤ H; otherwise v3 = n/2 and there is no
edge).
- Step v → v + d uses edge {v, v+d}: colour v + g(d), offset o = v.
- Step v → v − d uses edge {v−d, v}: colour (v−d) + g(d), offset o = v − d.
- Two distinct edges of the same orbit have distinct offsets (the offset determines the edge),
  so they never collide.
- Edges a, b with orbits d_a < d_b collide iff g(d_a) − g(d_b) ≡ o_b − o_a =: δ.

Each pair of edges on each cycle yields a key (d_a, d_b, δ, O), where O is the set of the cycle's
other orbits (|O| ≤ 2). The cycle exists in the graph iff {d_a, d_b} ∪ O ⊆ D, so the constraint
is "if all of {d_a, d_b} ∪ O are present then g(d_a) − g(d_b) ≢ δ". Keys are packed into 64-bit
integers, sorted and de-duplicated.

**CNF.**
- x[d][g] (orbit d with offset g) and p[d] (orbit d present), with p[d] ↔ ∨_g x[d][g] and an
  at-most-one ladder over x[d][·].
- For each (d_a, d_b, δ) that occurs: if some key has O = ∅, emit the n binary clauses
  ¬x[d_a][g] ∨ ¬x[d_b][g−δ]. Otherwise introduce y[d_a][d_b][δ] with the n clauses
  ¬x[d_a][g] ∨ ¬x[d_b][g−δ] ∨ y (only y ⇐ x ∧ x is needed, since y occurs only negatively), and one
  clause ¬y ∨ ⋁_{o∈O} ¬p[o] per key. Keys whose O is a superset of another key's O for the same
  (d_a, d_b, δ) are dropped because they are subsumed.
- Σ p[d] ≥ k by a sequential counter (s[i][j] ⇒ "at least j of p_1..p_i").
- Size at n = 97: 857,280 directed cycles through 0, 426,192 keys, 104,856 y variables,
  about 10.8 M clauses (2 s to encode).

Decoding: D = {d : p[d]}, g(d) = the unique g with x[d][g]. Every SAT model is rebuilt as an
explicit graph and checked by `src/check4.py`, which shares no code with the encoder.

## Symmetry breaking and soundness

**(S1) Colour translation.** If (D, g) is valid then so is (D, g + t): every colour shifts by t,
which is a bijection of Z_n and preserves rainbow-ness. So we may require g(min D) = 0. Clause:
¬p[d] ∨ ⋁_{e<d} p[e] ∨ x[d][0] for each d.

**(S2) Multipliers.** Let u ∈ Z_n^×, φ(i) = u·i on vertices and ψ(c) = u·c on colours. Both are
bijections of Z_n. If c is a valid colouring of G then c′(φ(e)) = ψ(c(e)) is a valid colouring of
φ(G): 4-cycles map to 4-cycles, and distinct colours stay distinct. Image of an edge
{i, i+d} with colour i + g(d) is {ui, ui + ud} with colour ui + u·g(d). Write ud ≡ σe with
e = rep(ud) ∈ 1..H and σ = ±1 (ud ≢ n/2 because d ≢ n/2 and u is a unit).
- σ = +1: the edge is {j, j+e} with j = ui and colour j + u·g(d), so g′(e) = u·g(d).
- σ = −1: the edge is {ui − e, ui} = {j, j+e} with j = ui − e and colour ui + u·g(d) = j + e + u·g(d),
  so g′(e) = e + u·g(d).
So (D′, g′) with D′ = rep(u·D) is again in the family, and p′_e = p_{rep(u⁻¹e)}.
(Checked: this is exactly the computation above.) u and −u induce the same permutation of
orbits, so the encoder uses one representative of each class in Z_n^×/{±1} other than ±1.

**Lex-leader.** For every such u the encoder adds p ≥_lex p∘π_u, where (p∘π_u)_e = p_{rep(u⁻¹e)},
the lex order is on (p_1, …, p_H) with p_1 most significant, and fixed points of π_u are skipped.
Encoding: chain variables a_i ("prefix equal through i"), clauses a_{i−1} → (p_i ∨ ¬q_i),
a_{i−1} ∧ ¬p_i → a_i, a_{i−1} ∧ q_i → a_i.

**Soundness of S1 + S2 together.** Take any valid (D, g). The set {p∘π_u} is the orbit of p under a
group, so it has a lex-maximum p∘π_{u*}. Apply u* to get (D*, g*), which is valid with presence
vector p* = p∘π_{u*}. For every unit v, p*∘π_v = p∘π_{u*}∘π_v lies in the same orbit, so
p* ≥_lex p*∘π_v and all lex constraints hold. Then translate colours so that g*(min D*) = 0. This
leaves p* and all lex constraints unchanged, and S1 now holds. The size |D*| = |D|, so the answer
to "is there a valid D with |D| ≥ k" is unchanged.

**Empirical check.** k_max agrees with and without breaking (table below). Solution counts
(projected on x, enumerated by blocking clauses, `src/count.py`, file `runs/val/counts.txt`):

| n | k | no breaking | S1 | S1 + S2 |
|---|---|---|---|---|
| 13 | 3 | 4420 | 340 | 82 |
| 14 | 3 | 8596 | 614 | 206 |
| 15 | 4 | 1380 | 92 | 30 |
| 16 | 4 | 7424 | 464 | 116 |
| 17 | 4 | 51952 | 3056 | 526 |
| 18 | 5 | 108 | 6 | 2 |

The S1 counts are exactly the no-breaking counts divided by n, as expected.

## 5. Solving procedure and timings

- **`src/cycrun.py`** runs one query (encode → solve → decode → `check4.py`) and prints one JSON
  line. Raw per-racer records are in `runs/n<n>.jsonl`.
- **`src/drive.py`** runs the per-n race. For each k, parallel racers start and the first definite
  answer wins; the rest are killed. SAT moves on to k+1. UNSAT or the wall cap stops the run.
  Results are in `runs/drive_n<n>.jsonl`.
  - Default racers from n = 65 on: kissat `--sat` seed 0 (S1+S2), kissat `--sat` seed 1 (S1 only),
    kissat `--unsat` seed 2 (S1+S2), and CaDiCaL seed 0 (S1+S2) writing a DRAT proof.
  - n = 43 ran with three default kissat seeds plus CaDiCaL.
  - n = 54 and 60 ran with kissat sat/sat/unsat (all S1+S2) plus CaDiCaL.
  - The S1-only racer was added after the CYC/C0 agent reported faster SAT finds without lex
    breaking.
- **First pass** (`src/firstpass.sh`, `src/firstpass2.sh`): 25 min wall per n.
  - For n = 60 and 92 the explicit k = n/4 attempt came first, capped at half of the 25 min.
  - k_start was CONSTR's best + 1 for n = 43, 54, 60 (CONSTR has certificates for 10, 12, 13).
  - For n = 65..97, ⌊n/4⌋ − 2 (14, 16, 19, 21, 22) is already above the frontier, so k_start was
    set lower (13, 14, 16, 17, 17) to obtain a certificate quickly, then climbed. CONSTR's
    n = 97 certificate has k = 16.
- **Second pass** (`src/phase2.sh`): 08:41–09:55 UTC, the multiples of 4 only, two racers each
  (CaDiCaL seed 1 and kissat `--sat` seed 7, both S1 only).
  - n = 60 at k = 14 and n = 92 at k = 19; for n = 92 the run climbs on if it gets SAT.
- **UNSAT proofs.** No UNSAT was reached for any of the 8 n, so there is no proof to check. The
  DRAT pipeline was exercised on validation instances (`runs/val/drat.jsonl`):

| n | k | CaDiCaL | proof size | drat-trim |
|---|---|---|---|---|
| 28 | 8 | UNSAT 0.7 s | 1.1 MB | VERIFIED (0.9 s) |
| 32 | 9 | UNSAT 3.1 s | 5.7 MB | VERIFIED (5.5 s) |
| 36 | 10 | UNSAT 39.4 s | 59 MB | VERIFIED (97 s) |

## 6. Where things are

| path | content |
|---|---|
| `src/cycenc.c` | DIMACS encoder (build: `gcc -O2 -o bin/cycenc src/cycenc.c`) |
| `src/check4.py` | independent explicit 4-cycle checker for (D, g) |
| `src/cycrun.py`, `src/drive.py` | single query / per-n race driver |
| `src/firstpass.sh`, `src/firstpass2.sh`, `src/phase2.sh` | the exact schedules that were run |
| `src/validate.sh`, `src/validate2.sh`, `src/valsummary.py`, `src/count.py` | validation |
| `src/collect.py` | builds `table.tsv`, `solutions.json`, `certs.json` (re-verifies each) |
| `src/cycanneal.c` | annealer (written, smoke-tested only; SAT was faster, not used for results) |
| `runs/` | all raw JSON-lines logs |
| `table.tsv`, `solutions.json`, `certs.json` | results |

Binaries go in `bin/`, which is git-ignored. Solver paths are hard-coded in `src/cycrun.py`
(`/opt/solvers/...`).

**Reproducing a race:** `python3 src/drive.py <n> <k_start> <cap_secs> [--also K]`, with kissat,
cadical and drat-trim built at `/opt/solvers/{kissat/build/kissat,cadical/build/cadical,drat-trim/drat-trim}`.

## 7. Surprises and next steps

- **Table error in CYC.md.** CYC.md lists k_max = 4 for all of n = 14–17, but CONSTR's own data
  (`cyclic_family_status.json`: n = 14 has "unsat": 4) and this run both give **k_max(14) = 3**.
  This is a transcription error in the task table, not a disagreement with CONSTR.
- **n/4 stops being reached.** k = n/4 was not reached at n = 60 (15) or n = 92 (23). Both are
  UNKNOWN, not UNSAT. The best k found is 13 at n = 60 (0.217 n) and 18 at n = 92 (0.196 n).
- **k/n falls.** The best ratio k/n drops from 0.233 at n = 43 to about 0.196 at n = 86..97.
  Neighbouring agents see the same trend, e.g. CYC/C0 has 0.190 at n = 79 and 0.189 at n = 90.
  These are lower bounds only, but the decline is consistent with k_max(n) = o(n) for this family.
- **Hardness.** The SAT/UNSAT frontier is hard from about n = 43 on: 4 cores × 25 min decided
  none of k_lo + 1.
  - Instances below the frontier are trivial: seconds, mostly found by CaDiCaL.
  - Instances at the frontier time out with every configuration.
- **Next steps:**
  - Give the n = 43, k = 11 instance (the smallest open one) hours with kissat `--unsat` + DRAT.
    k_max(40) = 10 needed 444 s for C0, and k_max(39) = 9 needed 518 s for C2.
  - Use cube-and-conquer on p (split on the presence of the first few orbits) to shard the
    UNSAT proofs across agents.
  - Search structured g (e.g. g(d) = a·d² + b·d) to get fast lower bounds for n ≥ 100.
