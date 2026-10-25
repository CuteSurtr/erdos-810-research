# Brute-force round, October 2026: results

Erdős #810 asks whether M(n) ≥ εn², where M(n) is the largest number of edges of an n-vertex
graph whose edges can be coloured with n colours so that every 4-cycle gets 4 distinct colours.
All computation for this round ran in Claude Code cloud containers on 2026-10-24.
Each task's `results/<TASK>/REPORT.md` has the full method, logs and code.

## Exact values

| n | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9 | 10 | 11 | 12 |
|---|---|---|---|---|---|---|---|---|---|---|----|----|----|
| M(n) | 0 | 0 | 1 | 3 | 5 | 7 | 11 | 14 | 17 | 23 | **30** | **34** | **40** |

- **M(10) = 30 and M(11) = 34.** Two methods agree. The first is SAT (`results/SAT`):
  the max-degree cubes Δ = 0..n−1 are all UNSAT, each with a drat-trim–checked proof, and the
  symmetry breaking is argued sound and tested. The second is an exhaustive geng enumeration
  (`results/M12`), pruned and unpruned, with identical outputs: 2 good graphs at (10, 30) and
  131 at (11, 34).
- **M(12) = 40.** No 12-vertex graph with 41 edges is good. This rests on three lines of
  evidence:
  - *Pruned enumeration* (`results/M12`): 512/512 shards with 0 output graphs. A second,
    separately written checker covered Δ ≤ 9 (512/512 shards), and SAT's checked cubes cover
    Δ = 10, 11.
  - *Unpruned enumeration* (`results/V12/V0..V3`): four separately written checkers, each
    validated on n = 7..11 against the known counts. Together they processed
    605,033,974 + 603,779,517 + 601,165,216 + 601,982,809 = **2,411,961,516** graphs, which is
    exactly the Pólya count of isomorphism classes, and found 0 good graphs.
  - *SAT* (`results/SAT`): 9 of the 12 Δ-cubes UNSAT with checked proofs.
- n ≤ 6 are kernel-checked in Lean (branch `lean-formalization`). For n = 7..9 there are now
  three independent recomputations: the earlier search, M12 and V12.
- The lower-bound certificates for n = 10, 11 and 12 in `results/*/certs.json` pass a simple
  4-cycle checker.

## Lower bounds, n ≥ 13

Every entry has a certificate in `results/{SAT,LB,CONSTR}/certs*.json`. Each certificate
passes its task's own checkers and an extra independent 4-cycle check run while this summary
was assembled. "previous" is the 2026-10-14 table (`data/results-2026-10-14.json`).

| n | previous | new lower bound | /n² | source |
|---|---|---|---|---|
| 13 | 46 | 47 | 0.278 | SAT |
| 14 | 53 | 55 | 0.281 | LB |
| 15 | 60 | 63 | 0.280 | LB |
| 16 | 68 | 70 | 0.273 | LB |
| 17 | 76 | 78 | 0.270 | LB |
| 18 | 85 | 90 | 0.278 | LB |
| 19 | 93 | 96 | 0.266 | LB |
| 20 | 102 | 109 | 0.273 | LB |
| 21 | 110 | 126 | 0.286 | LB |
| 22 | 121 | 133 | 0.275 | LB |
| 23 | 132 | 141 | 0.267 | LB |
| 24 | 141 | 150 | 0.260 | LB |
| 25 | 152 | 160 | 0.256 | LB |
| 26 | — | 169 | 0.250 | LB |
| 27 | — | 189 | 0.259 | CONSTR |
| 28 | — | 196 | 0.250 | LB |
| 29 | — | 210 | 0.250 | LB |
| 30 | — | 225 | 0.250 | LB |
| 31 | — | 248 | 0.258 | CONSTR |
| 32 | — | 256 | 0.250 | CONSTR |
| 33 | — | 264 | 0.242 | CONSTR |
| 34 | — | 274 | 0.237 | CONSTR |
| 35 | — | 288 | 0.235 | CONSTR |
| 36 | — | 324 | 0.250 | CONSTR |
| 37 | — | 333 | 0.243 | CONSTR |
| 38 | — | 342 | 0.237 | CONSTR |
| 39 | — | 351 | 0.231 | CONSTR |
| 40 | — | 400 | 0.250 | CONSTR |
| 41 | — | 410 | 0.244 | CONSTR |
| 42 | — | 420 | 0.238 | CONSTR |
| 43 | — | 430 | 0.233 | CONSTR |
| 44 | — | 440 | 0.227 | CONSTR |
| 45 | — | 450 | 0.222 | CONSTR |
| 46 | — | 506 | 0.239 | CONSTR |
| 47 | — | 518 | 0.234 | CONSTR |
| 48 | — | 528 | 0.229 | CONSTR |
| 49 | — | 539 | 0.224 | CONSTR |
| 50 | — | 550 | 0.220 | CONSTR |
| 51 | — | 561 | 0.216 | CONSTR |
| 52 | — | 624 | 0.231 | CONSTR |
| 53 | — | 636 | 0.226 | CONSTR |
| 54 | — | 648 | 0.222 | CONSTR |
| 55 | — | 660 | 0.218 | CONSTR |
| 56 | — | 672 | 0.214 | CONSTR |
| 57 | — | 684 | 0.211 | CONSTR |
| 58 | — | 702 | 0.209 | CONSTR |
| 59 | — | 767 | 0.220 | CONSTR |
| 60 | — | 780 | 0.217 | CONSTR |
| 61 | — | 793 | 0.213 | CONSTR |
| 62 | — | 806 | 0.210 | CONSTR |
| 63 | — | 812 | 0.205 | CONSTR |
| 64 | — | 835 | 0.204 | CONSTR |
| 67 | — | 909 | 0.202 | CONSTR |
| 71 | — | 1005 | 0.199 | CONSTR |
| 73 | — | 1057 | 0.198 | CONSTR |
| 79 | — | 1214 | 0.195 | CONSTR |
| 81 | — | 1273 | 0.194 | CONSTR |
| 83 | — | 1325 | 0.192 | CONSTR |
| 89 | — | 1519 | 0.192 | CONSTR |
| 97 | — | 1740 | 0.185 | CONSTR |
| 101 | — | 1867 | 0.183 | CONSTR |
| 103 | — | 1938 | 0.183 | CONSTR |
| 107 | — | 2065 | 0.180 | CONSTR |
| 109 | — | 2136 | 0.180 | CONSTR |
| 113 | — | 2277 | 0.178 | CONSTR |
| 121 | — | 2568 | 0.175 | CONSTR |
| 125 | — | 2716 | 0.174 | CONSTR |
| 127 | — | 2798 | 0.173 | CONSTR |
| 128 | — | 2831 | 0.173 | CONSTR |

**Best family.** The best family is *cyclic orbit colourings* (`results/CONSTR`, F3).
- **Construction.** Vertices are Z_n. Each d ∈ D contributes the edges {i, i+d}, and each
  such edge gets colour i + g(d).
- **Values.** The family reaches exactly n²/4 at n = 26, 28, 32, 36 and 40, and 126 = 0.286 n²
  at n = 21.
- **Optimality.** SAT proves the family optimum for n = 13..34 and 36.
- **Related finds.** LB's two-orbit symmetric SAT searches give ⌊n²/4⌋ for n = 26..30.

**Trend.** LB/n² drifts from about 0.28 (n ≈ 13–21) to 0.20 (n = 64) and 0.17 (n = 128).
- **Fits.** Decaying fits (n^(2−δ) with δ ≈ 0.19–0.26, n²/log n, n²·exp(−a√log n)) beat a
  constant on every window. Their extrapolations disagree wildly.
- **Search effort.** Large n got far less search than small n.
- **Interpretation.** Nothing here settles the asymptotic question. For the cyclic family it
  becomes arithmetic: is the largest admissible |D| at least εn? A positive answer would give
  M(n) ≥ εn².

## Affine model over F_p (2p vertices, p − 1 colours, colour a = partial map x ↦ ax + β(a))

- **Fixed formulas, AFFQ.** For β(a) = a², a³, 1/a and 0 there are exact optima for small p,
  proved by CP-SAT and RC2 agreeing. For example, β = a² gives 12, 23, 55, 77 at p = 5, 7, 11, 13.
  Local-search lower bounds run up to p = 101, where m/p² ≈ 0.30. The fit is
  m/p² ≈ 0.77·p^(−0.20) for β = a².
- **Optimised β, AFFARB.** Exact values with p = 3, 5, 7 proved optimal give 4, 12, 25
  (the p = 7 optimum is DRAT-verified). Lower bounds run up to p = 61 (m = 1267, 0.34 p²). The
  fit is m ≈ 0.88·p^1.77.
- **β is nearly irrelevant.** A random fixed β comes within 0–3 % of the jointly optimised
  value, and optimal β and supports look random. The difficulty is entirely in the supports.
  This matches the notes' remaining obstacle.

## Cyclic orbit family: CYC wave, 2026-10-25

Tasks `results/CYC/C0..C7` and `results/CYCPAT`.

**Exact k_max(n).** At n = 12..42 (n ≠ 35) and n = 47 the values are 3, 3, 3, 4, 4, 4, 5,
5, 5, 6, 5, 6, 6, 6, 6, 7, 7, 7, 7, 8, 8, 8, 8, (35 not computed), 9, 9, 9, 9, 10, 10, 10,
and k_max(47) = 11.
- **Proof checks:**
  - n = 13..41, except 35 and 38: the UNSAT at k_max + 1 is checked by drat-trim.
  - n = 38: LRAT, checked by a checker the task wrote.
  - n = 42: both CaDiCaL and Kissat report UNSAT; the proof is unchecked.
  - n = 47: cube-and-conquer, proofs unchecked.
- **Pattern:** k_max(4m) = m for m = 3..10.

**n/4 solutions.**
- Up to symmetry, the number of solutions at k = n/4 is 24, 58, 165, 362, 285, 128, 59, 4
  for n = 12, 16, …, 40.
- At n = 44, k = 11 is undecided. Two exhaustive splits leave 1 of 9 and 2 of 21 cases
  open, and no solution was found.
- No n/4 solution was found for 44 ≤ n ≤ 100.
- Best k/n is about 0.19 at n = 100.

**Theory, paper proofs:**
- Linear and boundedly piecewise-affine rules give |D| = o(n), via Szemerédi.
- A multiplier-symmetry lemma.
- Coset rules die out, with best k ≈ p^{3/4} (experimental).

**Lower bounds.** The table is regenerated in `paper/` from all certificates (220, all
re-verified).

## Paper draft

`paper/` contains `main.tex`, `OUTLINE.md` (with the claim ledger and TODOs),
`LITERATURE.md`, and `make_tables.py`. The note answers T. Tao's request on the #810 forum
(11 Dec 2025) for exact values: AlphaEvolve's lower bounds are optimal for n ≤ 12, and our
certificates beat them for 14 ≤ n ≤ 25.

## Open

- **M(13).** We know M(13) ≥ 47; deciding it means ruling out 48 edges.
  - **Plain pruned enumeration.** This is estimated at 9,800 CPU-h or more
    (`results/M12/M13_PLAN.md`).
  - **Cheaper routes.** Splitting by max degree, SAT cubes for high Δ, and a 64-shard calibration
    run first.
- **Exact cyclic-family optima for n ≥ 37.** This needs a C encoder plus multiplier symmetry;
  see `results/CONSTR/REPORT.md` §6.
- **Lean.** The new lower-bound certificates (n = 13..30) can be added to the Lean
  formalization with `decide`.
