# Task CONSTR: structured constructions for n = 26..128 and the M(n)/n² trend

## 1. Placement

```
$ uname -a; nproc; free -g
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

All computation ran in this cloud container, from 16:05 to 20:15 UTC on 2026-10-24. The
deadline was moved to 21:00 UTC by the routine prompt.

## 2. Results

### Headline

1. **Cyclic orbit colourings are the strongest structured family we found.**
   - **Construction.** Vertices are Z_n. For each d ∈ D, add all n edges {i, i+d}, coloured
     i + g(d) mod n.
   - **Best values.** It reaches 0.25–0.29 n² at n ≤ 40, for example n = 21 → 126 = 0.286 n²,
     n = 27 → 189 and n = 40 → 400. It beats unstructured local search started from random
     graphs.
   - **Exact optimum within the family.**
     - It is computed by SAT: `cycsat.py`, validated against brute force for n = 8..13.
     - It is **proved optimal within the family** for n = 13..34 and n = 36.
     - For example, there is no cyclic orbit colouring with 7 orbits on 26 vertices.
     - These are family optima only, not values of M(n).
2. **Lower bounds for every n = 26..64 and for the primes and prime powers 67..128.**
   - All are *certificate-verified* by the simple checker `check.py`.
   - LB/n² falls from 0.259 (n = 27) to about 0.20 (n = 64) and 0.173 (n = 128).
   - The decline is partly an artefact: search effort per n was much smaller at large n (see
     the trend fits in section 4).
3. **By-product: better lower bounds for n = 16..25.**
   - These come from cyclic seeds plus local search.
   - They beat both the README table and the LB task's certificates at commit d6dc4e1.
   - The largest gain is n = 21: 126, against the previous 110 / 114.

No upper bound and no exact value of M(n) is claimed anywhere in this report.

### 2a. Best lower bounds for n = 26..128

Machine-readable versions:
- `trend.tsv`: columns n, best_LB, LB/n², family, detail, sha256.
- `certs.json`: n ≤ 64.
- `certs_large.json`: n > 64.

| n | best LB | LB/n² | best family | status |
|---|---|---|---|---|
| 26 | 169 | 0.2500 | cyclic/other seed + local search | certificate-verified |
| 27 | 189 | 0.2593 | cyclic orbit | certificate-verified |
| 28 | 196 | 0.2500 | cyclic orbit | certificate-verified |
| 29 | 206 | 0.2449 | local search (random start) | certificate-verified |
| 30 | 219 | 0.2433 | local search (random start) | certificate-verified |
| 31 | 248 | 0.2581 | cyclic orbit | certificate-verified |
| 32 | 256 | 0.2500 | cyclic orbit | certificate-verified |
| 33 | 264 | 0.2424 | cyclic orbit | certificate-verified |
| 34 | 274 | 0.2370 | cyclic/other seed + local search | certificate-verified |
| 35 | 288 | 0.2351 | local search (random start) | certificate-verified |
| 36 | 324 | 0.2500 | cyclic orbit | certificate-verified |
| 37 | 333 | 0.2432 | cyclic orbit | certificate-verified |
| 38 | 342 | 0.2368 | cyclic orbit | certificate-verified |
| 39 | 351 | 0.2308 | cyclic orbit | certificate-verified |
| 40 | 400 | 0.2500 | cyclic orbit | certificate-verified |
| 41 | 410 | 0.2439 | cyclic orbit | certificate-verified |
| 42 | 420 | 0.2381 | cyclic orbit | certificate-verified |
| 43 | 430 | 0.2326 | cyclic orbit | certificate-verified |
| 44 | 440 | 0.2273 | cyclic orbit | certificate-verified |
| 45 | 450 | 0.2222 | cyclic orbit | certificate-verified |
| 46 | 506 | 0.2391 | cyclic orbit | certificate-verified |
| 47 | 518 | 0.2345 | cyclic/other seed + local search | certificate-verified |
| 48 | 528 | 0.2292 | cyclic orbit | certificate-verified |
| 49 | 539 | 0.2245 | cyclic orbit | certificate-verified |
| 50 | 550 | 0.2200 | cyclic orbit | certificate-verified |
| 51 | 561 | 0.2157 | cyclic orbit | certificate-verified |
| 52 | 624 | 0.2308 | cyclic orbit | certificate-verified |
| 53 | 636 | 0.2264 | cyclic orbit | certificate-verified |
| 54 | 648 | 0.2222 | cyclic orbit | certificate-verified |
| 55 | 660 | 0.2182 | cyclic orbit | certificate-verified |
| 56 | 672 | 0.2143 | cyclic orbit | certificate-verified |
| 57 | 684 | 0.2105 | cyclic orbit | certificate-verified |
| 58 | 702 | 0.2087 | cyclic/other seed + local search | certificate-verified |
| 59 | 767 | 0.2203 | cyclic orbit | certificate-verified |
| 60 | 780 | 0.2167 | cyclic orbit | certificate-verified |
| 61 | 793 | 0.2131 | cyclic orbit | certificate-verified |
| 62 | 806 | 0.2097 | cyclic orbit | certificate-verified |
| 63 | 812 | 0.2046 | cyclic/other seed + local search | certificate-verified |
| 64 | 835 | 0.2039 | cyclic/other seed + local search | certificate-verified |
| 67 | 909 | 0.2025 | cyclic/other seed + local search | certificate-verified |
| 71 | 1005 | 0.1994 | cyclic/other seed + local search | certificate-verified |
| 73 | 1057 | 0.1983 | cyclic/other seed + local search | certificate-verified |
| 79 | 1214 | 0.1945 | cyclic/other seed + local search | certificate-verified |
| 81 | 1273 | 0.1940 | cyclic/other seed + local search | certificate-verified |
| 83 | 1325 | 0.1923 | cyclic/other seed + local search | certificate-verified |
| 89 | 1519 | 0.1918 | cyclic/other seed + local search | certificate-verified |
| 97 | 1740 | 0.1849 | cyclic/other seed + local search | certificate-verified |
| 101 | 1867 | 0.1830 | cyclic/other seed + local search | certificate-verified |
| 103 | 1938 | 0.1827 | cyclic/other seed + local search | certificate-verified |
| 107 | 2065 | 0.1804 | cyclic/other seed + local search | certificate-verified |
| 109 | 2136 | 0.1798 | cyclic/other seed + local search | certificate-verified |
| 113 | 2277 | 0.1783 | cyclic/other seed + local search | certificate-verified |
| 121 | 2568 | 0.1754 | cyclic/other seed + local search | certificate-verified |
| 125 | 2716 | 0.1738 | cyclic/other seed + local search | certificate-verified |
| 127 | 2798 | 0.1735 | cyclic/other seed + local search | certificate-verified |
| 128 | 2831 | 0.1728 | cyclic/other seed + local search | certificate-verified |


Family attribution: "cyclic/other seed + local search" means the general local search (F6) was
started from the best structured example of the same n. In most cases that seed was the cyclic
orbit example.

### 2b. Per-family results (each entry certificate-verified)

Family status labels:
- **F1 "(opt)":** *proved* optimum of the sum-set family (exact MaxSAT).
- **F1 "(heur)":** heuristic (randomised greedy), used where the exact solver timed out.
- **F3 "optimal":** *proved* family optimum by SAT. The exact certificate is the
  `runs/cycsat/n<n>.jsonl` UNSAT record at k + 1, with the solver validated by brute force.
- **F2, F4, F5, F6:** heuristic.

The BEGS column (F5) is the larger of the pure triple-system graph and that graph augmented by
local search.

Per| n | sum-set Z_n (F1) | sum colouring, free edges (F2) | cyclic orbit (F3) | cyclic family status | affine (F4) | BEGS (F5) | local search (F6/general) |
|---|---|---|---|---|---|---|---|
| 26 | 88 (opt) | 148 | 156 | k=6 **optimal** (k=7 UNSAT) | 78 | 117 | 169 |
| 27 | 104 (opt) | 157 | 189 | k=7 **optimal** (k=8 UNSAT) | – | 123 | 189 |
| 28 | 108 (opt) | 172 | 196 | k=7 **optimal** (k=8 UNSAT) | – | 132 | 196 |
| 29 | 112 (opt) | 177 | 203 | k=7 **optimal** (k=8 UNSAT) | – | 141 | 206 |
| 30 | 116 (opt) | 192 | 210 | k=7 **optimal** (k=8 UNSAT) | – | 150 | 219 |
| 31 | 120 (opt) | 199 | 248 | k=8 **optimal** (k=9 UNSAT) | – | 156 | 248 |
| 32 | 124 (opt) | 244 | 256 | k=8 **optimal** (k=9 UNSAT) | – | 162 | 256 |
| 33 | 128 (opt) | 225 | 264 | k=8 **optimal** (k=9 UNSAT) | – | 171 | 264 |
| 34 | 132 (opt) | 241 | 272 | k=8 **optimal** (k=9 UNSAT) | 133 | 180 | 274 |
| 35 | 153 (opt) | 248 | 280 | annealing only | – | 192 | 288 |
| 36 | 141 (opt) | 270 | 324 | k=9 **optimal** (k=10 UNSAT) | – | 201 | 324 |
| 37 | 180 (opt) | 272 | 333 | k=9 (k+1 not decided) | – | 210 | 333 |
| 38 | 149 (opt) | 294 | 342 | annealing only | 160 | 219 | 342 |
| 39 | 190 (opt) | 297 | 351 | annealing only | – | 231 | 351 |
| 40 | 176 (opt) | 323 | 400 | k=10 (k+1 not decided) | – | 240 | 400 |
| 41 | 180 (opt) | 324 | 410 | k=10 (k+1 not decided) | – | 246 | 410 |
| 42 | 185 (opt) | 345 | 420 | k=10 (k+1 not decided) | – | 258 | 420 |
| 43 | 189 (opt) | 349 | 430 | annealing only | – | 273 | 430 |
| 44 | 195 (opt) | 382 | 440 | annealing only | – | 279 | 440 |
| 45 | 220 (opt) | 379 | 450 | annealing only | – | 294 | 450 |
| 46 | 225 (opt) | 399 | 506 | k=11 (k+1 not decided) | 227 | 306 | 506 |
| 47 | 230 (opt) | 406 | 517 | k=11 (k+1 not decided) | – | 315 | 518 |
| 48 | 236 (opt) | 446 | 528 | k=11 (k+1 not decided) | – | 321 | 528 |
| 49 | 240 (opt) | 439 | 539 | k=11; k=12 unknown (timeout) | – | 339 | 520 |
| 50 | 246 (opt) | 471 | 550 | k=11; k=12 unknown (timeout) | – | 351 | 539 |
| 51 | 275 (opt) | 469 | 561 | k=11; k=12 unknown (timeout) | – | 357 | 561 |
| 52 | 306 (opt) | 515 | 624 | k=12; k=13 unknown (timeout) | – | 369 | 624 |
| 53 | 286 (opt) | 500 | 636 | k=12; k=13 unknown (timeout) | – | 378 | 636 |
| 54 | 292 (opt) | 519 | 648 | k=12; k=13 unknown (timeout) | – | 399 | 648 |
| 55 | 297 (opt) | 532 | 660 | k=12; k=13 unknown (timeout) | – | 408 | 660 |
| 56 | 304 (opt) | 584 | 672 | k=12; k=13 unknown (timeout) | – | 423 | 672 |
| 57 | 336 (opt) | 565 | 684 | k=12; k=13 unknown (timeout) | – | 429 | 684 |
| 58 | 314 (heur) | 587 | 696 | annealing only | 347 | 444 | 702 |
| 59 | 348 (opt) | 600 | 767 | k=13; k=14 unknown (timeout) | – | 459 | 724 |
| 60 | 354 (opt) | 663 | 780 | k=13; k=14 unknown (timeout) | – | 465 | 747 |
| 61 | 390 (opt) | 635 | 793 | k=13; k=14 unknown (timeout) | – | 480 | 768 |
| 62 | 366 (heur) | 654 | 806 | k=13; k=14 unknown (timeout) | 391 | 498 | 792 |
| 63 | 403 (opt) | 674 | 756 | annealing only | – | 510 | 812 |
| 64 | 409 (heur) | 793 | 832 | annealing only | – | 534 | 835 |
| 67 | 429 (opt) | 748 | 871 | annealing only | – | 567 | 909 |
| 71 | 490 (opt) | 823 | 994 | annealing only | – | 627 | 1005 |
| 73 | 504 (opt) | 861 | 1022 | annealing only | – | 657 | 1057 |
| 79 | 585 (heur) | 987 | 1185 | annealing only | – | 756 | 1214 |
| 81 | 640 (heur) | 1027 | 1215 | annealing only | – | 801 | 1273 |
| 83 | 656 (heur) | 1077 | 1245 | annealing only | – | 828 | 1325 |
| 89 | 704 (heur) | 1207 | 1513 | annealing only | – | 936 | 1519 |
| 97 | 816 (heur) | 1395 | 1552 | annealing only | – | 1086 | 1740 |
| 101 | 850 (heur) | 1496 | 1717 | annealing only | – | 1164 | 1867 |
| 103 | 918 (heur) | 1547 | 1751 | annealing only | – | 1191 | 1938 |
| 107 | 954 (heur) | 1651 | 1926 | annealing only | – | 1284 | 2065 |
| 109 | 972 (heur) | 1697 | 1962 | annealing only | – | 1311 | 2136 |
| 113 | 1064 (heur) | 1809 | 2034 | annealing only | – | 1386 | 2277 |
| 121 | 1200 (heur) | 2036 | 2420 | annealing only | – | 1584 | 2568 |
| 125 | 1302 (heur) | 2154 | 2375 | annealing only | – | 1668 | 2716 |
| 127 | 1323 (heur) | 2199 | 2540 | annealing only | – | 1707 | 2798 |
| 128 | 1271 (heur) | 2626 | 2560 | annealing only | – | 1761 | 2831 |

### 2c. Exact optimum of the cyclic orbit family

Max |D| = k_max(n), with |E| = n·k_max. Each value is *proved* by SAT at k_max and UNSAT at
k_max + 1. Brute-force cross-check for n = 8..13: k_max = 2, 2, 3, 3, 3, 3.

| n | 13 | 14 | 15 | 16 | 17 | 18 | 19 | 20 | 21 | 22 | 23 | 24 | 25 | 26 | 27 | 28 | 29 | 30 | 31 | 32 | 33 | 34 | 36 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| k_max | 3 | 3 | 4 | 4 | 4 | 5 | 5 | 5 | 6 | 5 | 6 | 6 | 6 | 6 | 7 | 7 | 7 | 7 | 8 | 8 | 8 | 8 | 9 |
| k_max/n | 0.231 | 0.214 | 0.267 | 0.250 | 0.235 | 0.278 | 0.263 | 0.250 | 0.286 | 0.227 | 0.261 | 0.250 | 0.240 | 0.231 | 0.259 | 0.250 | 0.241 | 0.233 | 0.258 | 0.250 | 0.242 | 0.235 | 0.250 |

For n ≥ 37, the cyclic values in table 2b come from annealing (`cyc`) or from SAT runs
(240–600 s per k). The next k was never decided, so those values are lower bounds on the
family optimum only.

Example parameters, n = 21: D,g = {1:4, 3:16, 4:5, 5:14, 6:12, 9:20}. That is 126 edges with
21 colours; certificate in `small_improvements.json`.

### 2d. Small-n by-product (n = 13..25, outside the CONSTR range)

All values are *certificate-verified*. Certificates are in `small_improvements.json`, which
holds only the n where this task beats the LB task.

| n | README LB | LB task @d6dc4e1 | this task | method |
|---|---|---|---|---|
| 13 | 46 | 47 | 47 | equal to LB task |
| 14 | 53 | 55 | 55 | equal to LB task |
| 15 | 60 | 62 | 62 | equal to LB task |
| 16 | 68 | 69 | **70** | local search seeded from best of {cyclic, LB-task cert} |
| 17 | 76 | 77 | **78** | local search seeded from best of {cyclic, LB-task cert} |
| 18 | 85 | 86 | **90** | cyclic orbit (exact family optimum) |
| 19 | 93 | 94 | **95** | cyclic orbit (exact family optimum) |
| 20 | 102 | 103 | **106** | local search seeded from best of {cyclic, LB-task cert} |
| 21 | 110 | 114 | **126** | cyclic orbit (exact family optimum) |
| 22 | 121 | 123 | **125** | local search seeded from best of {cyclic, LB-task cert} |
| 23 | 132 | 134 | **138** | cyclic orbit (exact family optimum) |
| 24 | 141 | 144 | **145** | local search seeded from best of {cyclic, LB-task cert} |
| 25 | 152 | 155 | **156** | local search seeded from best of {cyclic, LB-task cert} |

n = 20 was first improved to 105 by unseeded local search with T = 0.3, then to 106 by the seeded
run.

## 3. Certificates

**Explicit edge lists.** Each is a list `[u, v, colour]` with 0 ≤ u, v, colour < n:
- `certs.json`: n = 26..64.
- `certs_large.json`: n = 67..128. These bests come from seeded local search, so they have no
  short parameter description. The explicit list is stored, and `trend.tsv` gives the sha256 of
  the sorted edge list: lines `"u v c\n"` with u < v, sorted, ASCII.
- `small_improvements.json`: n = 16..25.

**Algebraic parameters that regenerate the structured examples:**
- **F1 (sum-set):** `sumset_params.json`, a set S for each n. The edges are {i, j} with
  (i + j) mod n ∈ S, coloured (i + j) mod n.
- **F3 (cyclic):**
  - SAT models are in `runs/cycsat/n<n>.jsonl` (field `Dg`).
  - Annealing results are in `runs/cyc/c<n>_s<seed>.txt` (lines `d g`).
  - Edges {i, (i+d) mod n} are coloured (i + g) mod n.
- **F4 (affine):** `runs/fam/aff_<2q>_<beta>.txt`, explicit edges.
- **F5 (BEGS):** `runs/begs/b<n>.txt` (triples a b c means edge ab, colour c), with augmented
  versions in `runs/fam/begs_<n>.txt`.

**Verification.** `final_check.txt` is the output of
`check.py certs.json; check.py certs_large.json; check.py small_improvements.json`: 66/66 VALID.
`families.tsv` records the check verdict for every per-family best.

## 4. Method, parameters, counts, timings and validation

All runs were in this 4-core cloud container from 16:05 to about 20:15 UTC. Families and their
validity conditions are derived in `derivations.md`; this section summarises them.

### F1 · Sum-set colouring on Z_n (optimised exactly)

- **Construction.** Vertices are Z_n. {i, j} is an edge iff i + j ∈ S, and its colour is i + j.
- **Validity (n ≥ 8).** S contains no s − D, s, s + D with D ≢ 0, where wrap-around progressions
  count. For even n, D = n/2 also forbids having both s and s + n/2 in S.
- **Edge count.** Σ_{s∈S} w(s), with w = (n−1)/2 for odd n. For even n, w = n/2 when s is odd
  and n/2 − 1 when s is even.
- **Exact optimisation.** Weighted MaxSAT (RC2, Glucose4), one hard clause per 3-AP, with
  translation symmetry breaking (`sumset.py`). This gave proved family optima for n = 26..57,
  59–61, 63, 67, 71 and 73, each in seconds to ~160 s.
- **Timeouts.** n = 58, 62 and 64 timed out at 600 s, as did every n ≥ 79. For those n a
  randomised greedy (`sumset_heur.py`, labelled *heuristic*) was used instead. It matched the
  exact optimum at n = 26 and n = 40.
- **Quality.** F1 is weak: about 0.10–0.13 n². That is expected, since |E| ≈ r₃(Z_n)·n/2 = o(n²)
  by Roth.

### F2 · Sum colouring with a free edge set (groups Z_n, Z_p^k, Z_4³, Z_8², Z_6², …)

- **Problem.** The colour is fixed to i + j; the solver chooses the edge set.
- **Why not exact.** Exact MaxSAT was hopeless: RC2 did not finish n = 12 in 600 s. Local search
  (`ls` with a single allowed colour per pair) was used instead, 30 s per n for n ≤ 64 and 60 s
  above.
- **Result.** About 0.17–0.21 n² (*heuristic* as a family optimum; every certificate is
  verified). Elementary abelian 2-groups do best at n = 32, 64 and 128.

### F3 · Cyclic orbit colourings (Cayley graphs on Z_n, rotation-equivariant colours)

This is the best family found.

- **Construction.** Edges are {i, i+d} for d ∈ D ⊆ {1..⌈n/2⌉−1}, with colour i + g(d). So
  |E| = n·|D|.
- **Exact SAT (`cycsat.py`).**
  - Variables are x[d][g].
  - For every 4-cycle through vertex 0 and every pair of its edges, a clause forbids the colour
    coincidence g(d_a) − g(d_b) = δ when all orbits of the cycle are present.
  - Colour rotation symmetry is broken by g(first present orbit) = 0.
  - The solver is CaDiCaL 1.9.5 via python-sat.
- **Validation.**
  - `cycbrute.py` enumerates all (D, g) with g(min D) = 0 for n = 8..13 and checks each graph
    with `check.py`. Its max |D| agrees with SAT/UNSAT from `cycsat.py` for every one of these n
    (`logs/cycbrute.txt`).
  - Every SAT model is re-checked as an explicit graph by `check.py`.
- **Driver.** The target k starts at (annealer's best k) + 1 and increases while the result is
  SAT. An UNSAT answer at k + 1 proves that k is the family optimum.
- **Annealing (`cyc`).** Simulated annealing over (D, g): 60–120 s per n for n ≤ 64 and 200 s
  per n for the large n.
- **Multipliers.** The variant with colour m·i + g(d) is equivalent for units m. Non-units
  (m = 2 on n = 32, m = 3 on n = 27) were worse in a quick test, so m = 1 throughout.

### F4 · Bipartite affine colourings over F_q (q = 13, 17, 19, 23, 29, 31, so n = 2q)

- **Search.** β ∈ {0, a², a³, a⁻¹, random} was fixed, and supports were chosen by local search
  (`ls` with the allowed colour set {a : ax + β(a) = y} per pair), 30 s each.
- **Result.** About 0.10 n². The best runs reached about 78 edges at q = 13 and 391 at q = 31.
- **Padding.** Padding these to M(2q + k) cannot compete with F3 or F6, which are already above
  0.2 n², so the padding runs were skipped. `padjob.sh` is provided.

### F5 · BEGS construction from (7,4)-free linear triple systems

- **Result.** M(n) ≥ |T| (proof in `derivations.md`). Greedy (7,4)-free linear triple systems
  give |T| ≈ n²/24 (e.g. 178 at n = 64).
- **Augmentation.** Local search on the pairs of T, with the third point as colour, raises this
  to about 0.17 n² at n = 26..64.
- **Interpretation.** The construction is a valid lower-bound mechanism, but at these sizes it
  is far from competitive. f(n; 7, 4) is small for small n, and its growth is exactly the open
  Brown–Erdős–Sós (7,4) question.

### F6 · Local search (`ls.c`)

- **State and moves.** The state is an edge set plus a colouring with colours 0..n−1.
  - The engine minimises the number of non-rainbow 4-cycles at a fixed edge target, and raises
    the target whenever a valid state is reached.
  - Moves are "recolour a bad edge to its best colour" or "move a bad edge to the best of 12
    sampled non-edges".
  - Acceptance is Metropolis at T = 0.3, with short tabu lists and a perturbation after 2·10⁵
    non-improving steps.
  - Each move is evaluated incrementally, in O(deg²) per pair, by enumerating the 4-cycles
    through it.
- **Tuning.** T = 0.3 beat T = 0.15, 0.2, 0.4, 0.6 and 1.2 on n = 20.
- **Starts.** Random start ("g", 480 s, n = 26..37). Best structured example of the same n ("b",
  150 s for n ≤ 64, 240 s above). Vertex addition and deletion helpers are `seed.py` and
  `seedjob.sh`.

### Verification

- **Checker.** `check.py` is deliberately simple and independent of all generators. It checks
  vertex range, distinct pairs and colours in 0..n−1. It then enumerates every 4-cycle directly
  (each diagonal {a, c} with each pair {b, d} of common neighbours) and requires 4 distinct
  colours.
- **Coverage.** `collect.py` runs the checker on every candidate. It only accepts a best bound
  that passes, and it re-checks the per-family bests (`families.tsv`, column `check`).
- **Re-check.** The final `certs.json`, `certs_large.json` and `small_improvements.json` were
  re-checked with a separate invocation of `check.py` (section 2).

### Trend fits

`fit.py` does least squares in log space. The data are the best verified bounds:
- n = 13..25: the best of the README, the LB task and this task;
- n = 26..128: `trend.tsv`.

Models:
- A: c·n²
- B: c·n²/log n
- C: c·n^(2−δ)
- D: c·n²·exp(−a·√log n)
- E: c·n² + d·n^1.5 (fitted on LB/n²)

**All points, n = 13..128:**
```
points: 69 (n=13..128)
A: c n^2                         k=1 RSS=1.29078 AIC=-272.54 params=c=0.2248
    extrapolated LB/n^2 -> n=100: 0.2248 n^2, n=1000: 0.2248 n^2, n=1000000: 0.2248 n^2
B: c n^2/log n                   k=1 RSS=0.17276 AIC=-411.31 params=c=0.8457
    extrapolated LB/n^2 -> n=100: 0.1836 n^2, n=1000: 0.1224 n^2, n=1000000: 0.06121 n^2
C: c n^(2-delta)                 k=2 RSS=0.06861 AIC=-473.02 params=c=0.5312 delta=0.2258
    extrapolated LB/n^2 -> n=100: 0.1878 n^2, n=1000: 0.1117 n^2, n=1000000: 0.02348 n^2
D: c n^2 exp(-a sqrt(log n))     k=2 RSS=0.08821 AIC=-455.69 params=c=1.2039 a=0.8625
    extrapolated LB/n^2 -> n=100: 0.1891 n^2, n=1000: 0.1248 n^2, n=1000000: 0.04879 n^2
E: c n^2 + d n^1.5               (fit on LB/n^2) c=0.1311 d=0.6160 RSS(ratio)=0.006219
```
**Well-searched range only, n = 13..64:**
```
points: 52 (n=13..64)
A: c n^2                         k=1 RSS=0.41274 AIC=-249.48 params=c=0.2394
    extrapolated LB/n^2 -> n=100: 0.2394 n^2, n=1000: 0.2394 n^2, n=1000000: 0.2394 n^2
B: c n^2/log n                   k=1 RSS=0.17198 AIC=-295.00 params=c=0.8454
    extrapolated LB/n^2 -> n=100: 0.1836 n^2, n=1000: 0.1224 n^2, n=1000000: 0.06119 n^2
C: c n^(2-delta)                 k=2 RSS=0.04487 AIC=-362.88 params=c=0.4701 delta=0.1895
    extrapolated LB/n^2 -> n=100: 0.1964 n^2, n=1000: 0.127 n^2, n=1000000: 0.03428 n^2
D: c n^2 exp(-a sqrt(log n))     k=2 RSS=0.04872 AIC=-358.59 params=c=0.8872 a=0.6956
    extrapolated LB/n^2 -> n=100: 0.1994 n^2, n=1000: 0.1426 n^2, n=1000000: 0.06685 n^2
E: c n^2 + d n^1.5               (fit on LB/n^2) c=0.1551 d=0.4927 RSS(ratio)=0.003157
```
**n = 26..128:**
```
points: 56 (n=26..128)
A: c n^2                         k=1 RSS=0.76954 AIC=-238.09 params=c=0.2158
    extrapolated LB/n^2 -> n=100: 0.2158 n^2, n=1000: 0.2158 n^2, n=1000000: 0.2158 n^2
B: c n^2/log n                   k=1 RSS=0.04490 AIC=-397.21 params=c=0.8611
    extrapolated LB/n^2 -> n=100: 0.187 n^2, n=1000: 0.1247 n^2, n=1000000: 0.06233 n^2
C: c n^(2-delta)                 k=2 RSS=0.03457 AIC=-409.84 params=c=0.6120 delta=0.2597
    extrapolated LB/n^2 -> n=100: 0.1851 n^2, n=1000: 0.1018 n^2, n=1000000: 0.01693 n^2
D: c n^2 exp(-a sqrt(log n))     k=2 RSS=0.03850 AIC=-403.82 params=c=1.7359 a=1.0422
    extrapolated LB/n^2 -> n=100: 0.1855 n^2, n=1000: 0.1122 n^2, n=1000000: 0.03607 n^2
E: c n^2 + d n^1.5               (fit on LB/n^2) c=0.1049 d=0.8162 RSS(ratio)=0.002333
```

**Reading the fits.**
- The constant model A is clearly worst. LB/n² is not flat on 13..128: it drifts from about 0.28
  down to about 0.17.
- The three decaying models B, C and D fit about equally well. C (n^(2−δ) with δ ≈ 0.19–0.26)
  has the lowest AIC on every window, but its margin over D is small, and over B on n ≥ 26 it
  is moderate.
- Their extrapolations disagree wildly: at n = 10⁶, LB/n² ranges from about 0.02 to about 0.06.
- Model E, with a positive constant c ≈ 0.10–0.16 plus a decaying n^(−1/2) correction, also fits
  the ratio well. It shows that the same data are compatible with a *positive* limit.

**What small-n data cannot say.**
1. **Short range.** The range spans only log n ∈ [2.6, 4.9]. On such a short interval, n^(−δ),
   1/log n, exp(−a√log n) and c + d/√n are all nearly linear in log n and cannot be told apart.
   The choice of model is not identified by the data.
2. **Biased large-n bounds.** Above n ≈ 64 the bounds are much weaker relative to their size:
   - search time per n was 200–240 s of annealing on graphs with 2000+ edges;
   - exact family optimisation timed out.
   So the downward drift at large n is at least partly an artefact of effort. At n = 64 the
   ratio fell to about 0.20, while at n = 40 a cyclic example reaches exactly 0.25.
3. **Lower bounds only.** The fits describe the lower bounds we found, not M(n). Without upper
   bounds beyond n = 11 they say nothing about whether M(n)/n² → 0.
4. **Known theory.** M(n) ≥ n^(2−o(1)) (BEGS via g(n; 7, 4)) is all that is known. The
   structured families we can optimise exactly (F1, and F3 up to n = 36) give no sign of a
   linear-in-n orbit count collapsing in this range: the proved k_max(n)/n stays between 0.214
   and 0.286 for n = 13..36. That is consistent with both answers to the problem.

**Honest summary.** The data mildly favour slow decay over a constant, but only in the sense of
in-range fit quality, and that is confounded by effort bias. They do not discriminate between
c·n² with lower-order corrections and n^(2−o(1)).

## 5. Where the code lives (`bruteforce/results/CONSTR/`)

**Shared tools**

| file | purpose |
|---|---|
| `check.py` | deliberately simple certificate checker |
| `ls.c` | local search engine (general / restricted allowed colours); `gcc -O3 -march=native -o ls ls.c -lm` |
| `gen.py` | allowed-colour files for F2 (any abelian group given as cyclic factors), F4 (affine, β types) and bipartite |
| `collect.py` | gathers all runs, verifies and writes `trend.tsv`, `families.tsv`, `certs*.json`, `sumset_params.json`, `cyclic_family_status.json` |
| `make_tables.py`, `fit.py` | report tables; trend fits (`fits_*.txt`) |

**Family solvers**

| file | purpose |
|---|---|
| `sumset.py`, `sumset_heur.py` | F1 exact (RC2 MaxSAT) and heuristic |
| `maxsat_fixed.py` | exact MaxSAT for a fixed colouring with free edges (F2); too slow beyond n ≈ 11, kept for reference |
| `cyc.c` | F3 annealing over (D, g); colour m·i + g(d) |
| `cycsat.py` | F3 exact SAT for a given k |
| `cycbrute.py` | brute-force validation of `cycsat.py` (output in `logs/cycbrute.txt`) |
| `begs.py` | F5 (7,4)-free triple systems |
| `seed.py`, `pad.py` | vertex addition/deletion/best seeds; pendant-edge monotonicity padding |

**Drivers:** `job.sh`, `famjob.sh`, `cycjob.sh`, `cycdrive.sh`, `seedjob.sh`, `smalljob.sh`,
`padjob.sh`, `fam1.sh`, `phase2.sh`, `phase3.sh` and the `queue_*.txt` files (each line is the
argument list of one job).

**Raw outputs:** `runs/` and `logs/`.

## 6. Surprises and next steps

### Surprises

1. **The rotation-equivariant cyclic family is very strong at small n.** It gives the best known
   bound at many n:
   - 30 of the 56 values of n in 26..128: 27, 28, 31–33, 36–46, 48–57 and 59–62;
   - 18, 19, 21 and 23 among n ≤ 25.

   At n = 21 it beats general tabu or annealing search by 12 edges. This suggests that the
   extremal graphs may be (nearly) vertex-transitive.
2. **k_max(n) is not monotone in n.** For example k_max(21) = 6 but k_max(22) = 5, and n = 31
   has 8 orbits (248 edges, 0.258 n²). Values of n with good arithmetic structure stand out.
3. **The algebraic families are far weaker.** Sum-set (F1), sum colouring (F2), affine (F4) and
   BEGS triple systems (F5) all stay below the cyclic family at every n tested. F1 and F5 are
   provably o(n²) or tied to open problems, so this is expected. F4 matches the repo's o(p²)
   results for restricted affine supports.
4. **Unseeded local search with T = 0.3** already improved n = 20 from 102 to 105 within 40 s.

### Next steps

1. **Exact cyclic family for n ≥ 37.**
   - `cycsat.py` spends most of its time building clauses in Python (n·|keys| clauses). A C
     encoder plus symmetry breaking by multipliers u ∈ Z_n^× (d ↦ ud) and reflection would
     extend the proofs.
   - Command: `python3 cycsat.py n k T`, from k = (value in table 2b) + 1.
   - Measured times: n = 33/34/36 UNSAT took 330/410/490 s. n ≥ 37 at k + 1 did not finish in
     240–600 s (n = 58 failed with a python-sat error and was not rerun).
2. **Generalise the symmetry.**
   - Cayley graphs on other groups of order n, with colour i + g(d) (non-abelian too).
   - Semiregular (2- or 3-orbit) versions, as in the LB task.
   - These could fill the n where the cyclic family is weak, such as n = 29, 30, 34 and 35.
3. **More search at n > 64.** Large-n bounds had 200–240 s of annealing each. Seeding cyclic SAT
   solutions for k ≈ n/4 there, or blowing up good cyclic examples, should raise LB/n²
   substantially and reduce the effort bias in the trend.
4. **Theory.** In the cyclic family the question becomes arithmetic: are there D ⊆ Z_n with
   |D| ≥ εn and offsets g making every "4-term closed walk" rainbow? A proof that
   k_max(n) = o(n) would not settle Erdős #810. A construction with k_max(n) ≥ εn would settle it
   positively.
