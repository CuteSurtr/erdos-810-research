# Task LB: lower bounds for n = 13..30

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

All computation ran in this cloud container (4 cores, 15 GB) on 2026-10-24, 16:05 to 20:33 UTC.
The routine started late, so the deadline was moved from 16:30 to 21:00 UTC.

## 2. Results

"Old LB" is the README table, with n = 13, 14 replaced by the Task SAT certificates (47, 54).
Every new bound is **certificate-verified**: `check.py` (all 4-sets × 3 cyclic orders, colours in
0..n−1) passes on each entry of `certs.json`, and so do `../SAT/check.py` (ordered 4-tuples) and
`../SAT/check_q.py` (proper colouring of Q(G)). Output is in `logs/final_check.log`.

| n | old LB | new LB | e/n² | status | method (source file) |
|---|---|---|---|---|---|
| 13 | 47 | **47** (=) | 0.278 | certificate-verified | tabu search (ls810) (`out/r1_n13_e47.txt`) |
| 14 | 54 | **55** | 0.281 | certificate-verified | tabu search (ls810) (`out/r1_n14_e55.txt`) |
| 15 | 60 | **63** | 0.280 | certificate-verified | symmetric SAT: σ = 5×C3, τ = 5×C3 (`out/sym_m3j5s0_n15_e63.txt`) |
| 16 | 68 | **70** | 0.273 | certificate-verified | symmetric SAT: σ = 4×C4, τ = 4×C4 (`out/sym_m4j4s0_n16_e70.txt`) |
| 17 | 76 | **78** | 0.270 | certificate-verified | symmetric SAT: σ = 4×C4 + 1 fixed, τ = 4×C4 (`out/sym_m4j4s0_n17_e78.txt`) |
| 18 | 85 | **90** | 0.278 | certificate-verified | symmetric SAT: σ = 3×C6, τ = 3×C6 (`out/sym_m6j3s0_n18_e88.txt`) |
| 19 | 93 | **96** | 0.266 | certificate-verified | symmetric SAT: σ = 3×C6 + 1 fixed, τ = 3×C6 (`out/sym_m6j3s0_n19_e95.txt`) |
| 20 | 102 | **109** | 0.273 | certificate-verified | deletion of a vertex and a colour from the n=21 certificate (`out/del_n20_e109.txt`) |
| 21 | 110 | **126** | 0.286 | certificate-verified | symmetric SAT: σ = 3×C7, τ = 3×C7 (`out/sym_m7j3s0_n21_e120.txt`) |
| 22 | 121 | **133** | 0.275 | certificate-verified | tabu search seeded from the n=21 certificate plus one vertex (`out/r5_n22_e133.txt`) |
| 23 | 132 | **141** | 0.267 | certificate-verified | tabu search seeded from the n=22 certificate plus one vertex (`out/r6_n23_e141.txt`) |
| 24 | 141 | **150** | 0.260 | certificate-verified | symmetric SAT: σ = 2×C12, τ = 2×C12 (`out/sym_m12j2s0_n24_e150.txt`) |
| 25 | 152 | **160** | 0.256 | certificate-verified | symmetric SAT: σ = 3×C8 + 1 fixed, τ = 3×C8 (`out/sym_m8j3s0_n25_e157.txt`) |
| 26 | — | **169** | 0.250 | certificate-verified | symmetric SAT: σ = 2×C13, τ = 2×C13 (`out/sym_m13j2s0_n26_e169.txt`) |
| 27 | — | **182** | 0.250 | certificate-verified | symmetric SAT: σ = 2×C13 + 1 fixed, τ = 2×C13 (`out/sym_m13j2s0_n27_e181.txt`) |
| 28 | — | **196** | 0.250 | certificate-verified | symmetric SAT: σ = 2×C14, τ = 2×C14 (`out/sym_m14j2s0_n28_e196.txt`) |
| 29 | — | **210** | 0.250 | certificate-verified | symmetric SAT: σ = 2×C14 + 1 fixed, τ = 2×C14 (`out/sym_m14j2s0_n29_e204.txt`) |
| 30 | — | **225** | 0.250 | certificate-verified | symmetric SAT: σ = 2×C15, τ = 2×C15 (`out/sym_m15j2s0_n30_e225.txt`) |

Nothing here is an upper bound. No exact values are claimed.

**Targets from the task notes:**
- n = 13, e = 48: not found (*unfinished*). The tabu search reaches cost 1 (a single
  monochromatic pair on one 4-cycle) but never 0. That took 4 runs: 2 × 45 min seeded from the
  47-edge certificate and 1 × 30 min from empty, after a 10 min sweep. The best for n = 14 at
  e = 56 was cost 2. Runs that imposed symmetry reported UNSAT for
  σ = C12+fix, 3×C4+fix and 2×C6+fix. Runs with 4×C3+fix (2400 s) and 6×C2+fix (2400 s) stopped
  with no answer.
- n = 14, e = 55: **found** (tabu search, 10 min). e = 56 was not found. With σ = 2×C7 it is
  UNSAT for τ = 2×C7 and for τ = id, and the runs with 13+fix are UNSAT at e = 55. Runs with
  4×C3+2, 7×C2 and 3×C4+2 stopped with no answer.

The UNSAT verdicts above hold only for the encoding with that symmetry imposed (σ, τ fixed).
They are not DRAT-checked and say nothing about M(n). Full list: `logs/sat_runs.txt`.

## 3. Certificates

`certs.json`: `{"n": [[u, v, colour], ...]}` for n = 9..30. Entries for n ≤ 12 only reproduce
known values. `sources.json` maps each entry to the run that produced it.

## 4. Methods

### 4.1 Tabu search (`ls810.c`)

- **State:** a graph with exactly e edges, each edge coloured 0..n−1.
- **Cost:** the number of pairs (4-cycle C of G, two edges of C with equal colour).
  For every vertex pair q (edge or not), the code keeps A[q][c] and B[q]. A[q][c] counts the
  edges of 4-cycles through q (other three edges present) that have colour c. B[q] counts the
  equal-colour pairs among those other three edges. Changing one pair updates O(Δ²) entries.
  So every move is scored exactly in O(1), and a brute-force recount every 2^20 iterations
  checks for drift.
- **Moves:** recolour an edge (only edges in a conflict), or remove an edge and then add the
  best (pair, colour). The removed pair, the added pair and the old colour are tabu for 10 to 20
  iterations (aspiration on a new best). After 200 000 iterations without improvement,
  3 random edges are recoloured.
- **Target:** when cost reaches 0, the certificate is written and the best (pair, colour) is
  added, so the target grows by one.
- **Speed:** about 85 000 iterations/s at n = 30 and 240 000/s at n = 15.
- **Validation:** from an empty start it reaches M(9) = 23, M(10) = 30 and M(11) = 34 in
  seconds, n = 12 → 40 and n = 13 → 47 within 2 minutes.
- **Tuning (n = 21, 300 s, 2 seeds each):** tenure 10 gave 113, 113; tenure 25 gave 112, 112.
  Tenure 10 was used from then on.

### 4.2 Symmetry-imposed SAT (`symenc.py`, `symrun.py`, `escalate.sh`)

- **Base encoding:** the same shape as Task SAT's `enc.py`. Variables x_p, y_{p,c} and z_{e,f}
  (z: e, f lie on a common 4-cycle, implying direction only), at-least-one colour per edge, and
  Σx ≥ e by totalizer. No other symmetry breaking.
- **Imposed symmetry:** choose a vertex permutation σ and a colour permutation τ. Variables are
  identified along orbits by union-find: x_p = x_{σp}, y_{p,c} = y_{σp,τc}, z_{e,f} = z_{σe,σf}.
  Clauses are rewritten and deduplicated, so effectively only orbit representatives are
  encoded. The cardinality constraint counts each orbit with its size.
- **Soundness:** any model of the identified formula is a model of the base formula. So it
  decodes (first true colour) to a valid colouring. Each decoded model is then checked.
- **Groups used:** σ = r disjoint m-cycles plus n − rm fixed points. τ = j disjoint m-cycles on
  colours 0..jm−1, rest fixed (`symrun.py n e m j T`).
- **Escalation:** `escalate.sh` starts at e₀. After each SAT result it restarts at
  (edges found) + 1, and it stops on UNSAT or on a timeout (Kissat 4.0.4 `--time`, 900 s).
- **Validation:** n = 9, e = 23 with no symmetry gives SAT (and the check passes). n = 10,
  e = 30 with σ = τ = 2×C5 gives SAT.

### 4.3 Moving between neighbouring n

- `derive.py`: from the n+1 certificate, delete the vertex v and colour c that keep the most
  edges. Then greedily re-insert the dropped colour-c edges with any colour that stays valid,
  and relabel. This gave n = 20 (109, from n = 21's 126) and n = 19 (95, later 96 by SAT).
- `chain.sh`: seed `ls810` at n with the best n−1 certificate plus an isolated vertex. The
  greedy fill and the tabu search then grow it. This gave n = 22 (133, from 126 at n = 21)
  and n = 23 (141).
- **Rigidity:** the symmetric solutions are locally rigid. Tabu from the n = 30, e = 225
  certificate at target 226 stayed at cost ≥ 19 for 600 s. Tabu from the deletion seed at
  n = 20 (target 110) stayed at cost ≥ 18.

### 4.4 Run log

| phase (UTC) | what |
|---|---|
| 16:11–16:57 | tabu from empty, n = 13..30, 600 s each, 4 parallel (`sweep.sh 1`): improved every n = 14..25 |
| 16:20–17:50 | symmetric SAT for n = 13, 14, 15 (`symbatch*.txt`) |
| 16:58–17:05 | symmetric SAT, 2 orbits, n = 24..30 (`symbig1.txt`): 24→144/150, 25→156, 26→169, 27→180, 28→196, 29→203, 30→225, each within seconds to minutes |
| 17:05–19:40 | escalation batches `esc1..esc4.txt` (3 parallel) |
| 19:00–19:40 | deletion/extension seeds plus tabu (`derive.py`, `chain.sh`) |
| 19:40–20:33 | long tabu runs for n = 13 (e = 48) and n = 14 (e = 56); escalation `esc5.txt` (n = 17 → 78 with 4×C4+1) |

## 5. Code and files (this folder)

- `ls810.c`: tabu search. Build with `gcc -O3 -march=native -o ls810 ls810.c`; usage is in the header.
- `symenc.py`, `decode.py`, `symrun.py`, `escalate.sh`: symmetry-imposed SAT
  (needs `python-sat` and a `kissat` binary symlinked here; Kissat built from GitHub master).
- `sweep.sh`, `sweep2.sh`, `chain.sh`, `derive.py`: drivers.
- `check.py`: the simple checker. `collect.py` gathers the best checked file per n into
  `certs.json`. `sources.py` writes `sources.json`. `table.py` makes the table above.
  `analyze.py` gives the structure table.
- `out/`: the certificate files behind `certs.json` and every symmetric-SAT model.
  `logs/`: run logs, `sat_runs.txt` (status of every SAT instance) and `structure.md`.

## 6. Structure, surprises and next steps

Structure of every certificate (`analyze.py`; |Aut| is for the uncoloured graph, from a VF2 count):

| n | e | e/n^2 | degree sequence | bipartite | triangles | |Aut(G)| | colour class sizes |
|---|---|---|---|---|---|---|---|
| 9 | 23 | 0.284 | 6^1 5^8 | False | 18 | 4 | 3 3 3 3 3 2 2 2 2 |
| 10 | 30 | 0.300 | 6^10 | False | 30 | 20 | 3 3 3 3 3 3 3 3 3 3 |
| 11 | 34 | 0.281 | 7^4 6^6 4^1 | False | 34 | 2 | 4 4 4 3 3 3 3 3 3 2 2 |
| 12 | 40 | 0.278 | 8^1 7^7 6^3 5^1 | False | 42 | 1 | 4 4 4 4 3 3 3 3 3 3 3 3 |
| 13 | 47 | 0.278 | 8^3 7^10 | False | 53 | 1 | 4 4 4 4 4 4 4 4 3 3 3 3 3 |
| 14 | 55 | 0.281 | 8^12 7^2 | False | 70 | 2 | 5 5 5 4 4 4 4 4 4 4 3 3 3 3 |
| 15 | 63 | 0.280 | 9^6 8^9 | False | 87 | 3 | 5 5 5 5 5 5 4 4 4 4 4 4 3 3 3 |
| 16 | 70 | 0.273 | 10^4 9^4 8^8 | False | 100 | 8 | 5 5 5 5 5 5 4 4 4 4 4 4 4 4 4 4 |
| 17 | 78 | 0.270 | 10^4 9^12 8^1 | False | 114 | 4 | 5 5 5 5 5 5 5 5 5 5 5 5 4 4 4 3 3 |
| 18 | 90 | 0.278 | 10^18 | False | 150 | 36 | 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 5 |
| 19 | 96 | 0.266 | 12^1 10^18 | False | 156 | 6 | 6 6 6 6 6 6 5 5 5 5 5 5 5 5 5 5 5 5 0 |
| 20 | 109 | 0.273 | 12^4 11^10 10^6 | False | 203 | 1 | 6 6 6 6 6 6 6 6 6 5 5 5 5 5 5 5 5 5 5 5 |
| 21 | 126 | 0.286 | 12^21 | False | 273 | 126 | 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 |
| 22 | 133 | 0.275 | 13^7 12^14 7^1 | False | 282 | 1 | 7 7 7 7 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 5 4 |
| 23 | 141 | 0.267 | 14^2 13^9 12^10 9^1 8^1 | False | 291 | 1 | 7 7 7 7 7 7 7 7 7 6 6 6 6 6 6 6 6 6 6 6 5 4 3 |
| 24 | 150 | 0.260 | 13^12 12^12 | False | 296 | 24 | 7 7 7 7 7 7 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 |
| 25 | 160 | 0.256 | 16^1 14^8 13^8 11^8 | False | 312 | 8 | 8 7 7 7 7 7 7 7 7 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 6 |
| 26 | 169 | 0.250 | 13^26 | False | 364 | 13 | 7 7 7 7 7 7 7 7 7 7 7 7 7 6 6 6 6 6 6 6 6 6 6 6 6 6 |
| 27 | 182 | 0.250 | 14^13 13^14 | False | 390 | 26 | 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 0 |
| 28 | 196 | 0.250 | 15^14 13^14 | False | 406 | 14 | 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 |
| 29 | 210 | 0.250 | 15^14 14^15 | False | 462 | 14 | 8 8 8 8 8 8 8 8 8 8 8 8 8 8 7 7 7 7 7 7 7 7 7 7 7 7 7 7 0 |
| 30 | 225 | 0.250 | 15^30 | False | 540 | 15 | 8 8 8 8 8 8 8 8 8 8 8 8 8 8 8 7 7 7 7 7 7 7 7 7 7 7 7 7 7 7 |

- **Imposed symmetry is the strongest method above n ≈ 15.** Unstructured tabu search fell
  behind fast. For n = 21 it gave 114, while σ = τ = 3×C7 gave 126 (0.286 n², the highest
  density in the table above n = 10). Extending that one graph by a vertex lifted n = 20, 22
  and 23 too.
- **The best graphs are very symmetric, and none is bipartite.** They are triangle-rich, and
  triangles are free because they create no 4-cycles.
  - n = 21: 12-regular with |Aut(G)| = 126 = 6·21 (more than the order-7 symmetry imposed),
    and every colour class is a matching of size 6. Probably vertex-transitive, perhaps a Cayley
    graph of the Frobenius group of order 21 or of Z21. Not checked.
  - n = 18: 10-regular with |Aut| = 36. The known M(10) graph is 6-regular with |Aut| = 20.
- **n = 26..30 come out at exactly ⌊n²/4⌋.** These are 169, 182, 196, 210 and 225. All came from
  σ = 2×C_m (+1 fixed point), and they appeared within seconds. One more orbit (m more edges)
  timed out every time. Smaller groups (3×C8+2, 3×C9+1, 3×C10, 5×C6, 4×C7, 7×C4) also timed out
  at e = ⌊n²/4⌋ + 1. Treat ⌊n²/4⌋ as the point where these encodings get hard, not as evidence
  about M(n). The density falls from 0.286 at n = 21 to 0.250, and the bounds for n ≥ 24 are
  probably far from tight.
- **Next steps:**
  1. Impose a 2-generator group, for example the Frobenius group of order 21 or Z_a ⋊ Z_b,
     using a second σ in `symenc.py`. The union-find already supports this; it needs a loop
     over generators.
  2. Use σ = 3×C_m and 4×C_m for n = 24..30 with longer Kissat runs (> 900 s) and several seeds.
  3. For n = 13 at e = 48, run the 4×C3+fix and 6×C2+fix instances longer, ideally sharded by
     cubes, or impose order-2 symmetries with more fixed points.
