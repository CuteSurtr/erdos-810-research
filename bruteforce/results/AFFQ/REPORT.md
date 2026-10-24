# AFFQ: affine model with fixed intercept formulas and arbitrary supports

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          14           0           1          15
Swap:              0           0           0
```

Everything ran in this cloud container. Solvers: OR-Tools CP-SAT 9.15 and
python-sat 1.9.dev17 (RC2 with Glucose 4), both from pip. nauty `dreadnaut` came
from apt. The local search `ls.c` was written for this task.

## 2. Results

Model, as in the task file: rows X = F_p, columns Y = F_p. Colour a ∈ F_p^× is
the set of edges {(x, ax + β(a)) : x ∈ D_a}. The graph must be simple and every
4-cycle rainbow. We maximise m = Σ|D_a|. The graph has 2p vertices and p − 1
colours, so m is a lower bound for M(2p).

Status labels:

- **proved**: two independent exact methods agree, each validated on
  smaller cases.
- **exact by one method**: only one exact method finished.
- **H**: heuristic lower bound with a certificate-verified configuration. Its
  upper bound is the stated one. "distinct points" means the trivial bound: each
  point (x, y) carries at most one colour.

| β | p | m best | upper bound | status | m/p² | n = 2p | README M(n) |
|---|---|---|---|---|---|---|---|
| a2 | 5 | 12 | 12 | proved (CP-SAT + RC2 + brute force) | 0.48 | 10 | 30* |
| a2 | 7 | 23 | 23 | proved (CP-SAT + RC2) | 0.4694 | 14 | ≥ 53 |
| a2 | 11 | 55 | 55 | proved (CP-SAT + RC2) | 0.4545 | 22 | ≥ 121 |
| a2 | 13 | 77 | 77 | proved (CP-SAT + RC2) | 0.4556 | 26 | — |
| a2 | 17 | 126 | 152 | H (UB: distinct points) | 0.436 | 34 | — |
| a2 | 19 | 156 | 189 | H (UB: distinct points) | 0.4321 | 38 | — |
| a2 | 23 | 223 | 275 | H (UB: distinct points) | 0.4216 | 46 | — |
| a2 | 29 | 334 | 434 | H (UB: distinct points) | 0.3971 | 58 | — |
| a2 | 31 | 377 | 495 | H (UB: distinct points) | 0.3923 | 62 | — |
| a2 | 37 | 520 | 702 | H (UB: distinct points) | 0.3798 | 74 | — |
| a2 | 41 | 618 | 860 | H (UB: distinct points) | 0.3676 | 82 | — |
| a2 | 43 | 684 | 945 | H (UB: distinct points) | 0.3699 | 86 | — |
| a2 | 47 | 789 | 1127 | H (UB: distinct points) | 0.3572 | 94 | — |
| a2 | 53 | 982 | 1430 | H (UB: distinct points) | 0.3496 | 106 | — |
| a2 | 59 | 1188 | 1769 | H (UB: distinct points) | 0.3413 | 118 | — |
| a2 | 61 | 1263 | 1890 | H (UB: distinct points) | 0.3394 | 122 | — |
| a2 | 67 | 1478 | 2277 | H (UB: distinct points) | 0.3292 | 134 | — |
| a2 | 71 | 1649 | 2555 | H (UB: distinct points) | 0.3271 | 142 | — |
| a2 | 73 | 1728 | 2700 | H (UB: distinct points) | 0.3243 | 146 | — |
| a2 | 79 | 1989 | 3159 | H (UB: distinct points) | 0.3187 | 158 | — |
| a2 | 83 | 2163 | 3485 | H (UB: distinct points) | 0.314 | 166 | — |
| a2 | 89 | 2459 | 4004 | H (UB: distinct points) | 0.3104 | 178 | — |
| a2 | 97 | 2844 | 4752 | H (UB: distinct points) | 0.3023 | 194 | — |
| a2 | 101 | 3047 | 5150 | H (UB: distinct points) | 0.2987 | 202 | — |
| a3 | 5 | 12 | 12 | proved (CP-SAT + RC2 + brute force) | 0.48 | 10 | 30* |
| a3 | 7 | 22 | 22 | proved (CP-SAT + RC2) | 0.449 | 14 | ≥ 53 |
| a3 | 11 | 59 | 59 | proved (CP-SAT + RC2) | 0.4876 | 22 | ≥ 121 |
| a3 | 13 | 77 | 78 | H (UB: CP-SAT FEASIBLE) | 0.4556 | 26 | — |
| a3 | 17 | 133 | 184 | H (UB: distinct points) | 0.4602 | 34 | — |
| a3 | 19 | 156 | 231 | H (UB: distinct points) | 0.4321 | 38 | — |
| a3 | 23 | 226 | 341 | H (UB: distinct points) | 0.4272 | 46 | — |
| a3 | 29 | 343 | 546 | H (UB: distinct points) | 0.4078 | 58 | — |
| a3 | 31 | 387 | 625 | H (UB: distinct points) | 0.4027 | 62 | — |
| a3 | 37 | 527 | 894 | H (UB: distinct points) | 0.385 | 74 | — |
| a3 | 41 | 636 | 1100 | H (UB: distinct points) | 0.3783 | 82 | — |
| a3 | 43 | 680 | 1211 | H (UB: distinct points) | 0.3678 | 86 | — |
| a3 | 47 | 816 | 1449 | H (UB: distinct points) | 0.3694 | 94 | — |
| a3 | 53 | 990 | 1846 | H (UB: distinct points) | 0.3524 | 106 | — |
| a3 | 59 | 1202 | 2291 | H (UB: distinct points) | 0.3453 | 118 | — |
| a3 | 61 | 1278 | 2450 | H (UB: distinct points) | 0.3435 | 122 | — |
| a3 | 67 | 1485 | 2959 | H (UB: distinct points) | 0.3308 | 134 | — |
| a3 | 71 | 1662 | 3325 | H (UB: distinct points) | 0.3297 | 142 | — |
| a3 | 73 | 1737 | 3516 | H (UB: distinct points) | 0.326 | 146 | — |
| a3 | 79 | 1996 | 4121 | H (UB: distinct points) | 0.3198 | 158 | — |
| a3 | 83 | 2185 | 4551 | H (UB: distinct points) | 0.3172 | 166 | — |
| a3 | 89 | 2469 | 5236 | H (UB: distinct points) | 0.3117 | 178 | — |
| a3 | 97 | 2858 | 6224 | H (UB: distinct points) | 0.3038 | 194 | — |
| a3 | 101 | 3073 | 6750 | H (UB: distinct points) | 0.3012 | 202 | — |
| inv | 5 | 12 | 12 | proved (CP-SAT + RC2 + brute force) | 0.48 | 10 | 30* |
| inv | 7 | 23 | 23 | proved (CP-SAT + RC2) | 0.4694 | 14 | ≥ 53 |
| inv | 11 | 55 | 55 | proved (CP-SAT + RC2) | 0.4545 | 22 | ≥ 121 |
| inv | 13 | 77 | 77 | proved (CP-SAT + RC2) | 0.4556 | 26 | — |
| inv | 17 | 126 | 152 | H (UB: distinct points) | 0.436 | 34 | — |
| inv | 19 | 156 | 189 | H (UB: distinct points) | 0.4321 | 38 | — |
| inv | 23 | 223 | 275 | H (UB: distinct points) | 0.4216 | 46 | — |
| inv | 29 | 334 | 434 | H (UB: distinct points) | 0.3971 | 58 | — |
| inv | 31 | 377 | 495 | H (UB: distinct points) | 0.3923 | 62 | — |
| inv | 37 | 520 | 702 | H (UB: distinct points) | 0.3798 | 74 | — |
| inv | 41 | 618 | 860 | H (UB: distinct points) | 0.3676 | 82 | — |
| inv | 43 | 684 | 945 | H (UB: distinct points) | 0.3699 | 86 | — |
| inv | 47 | 789 | 1127 | H (UB: distinct points) | 0.3572 | 94 | — |
| inv | 53 | 982 | 1430 | H (UB: distinct points) | 0.3496 | 106 | — |
| inv | 59 | 1188 | 1769 | H (UB: distinct points) | 0.3413 | 118 | — |
| inv | 61 | 1263 | 1890 | H (UB: distinct points) | 0.3394 | 122 | — |
| inv | 67 | 1478 | 2277 | H (UB: distinct points) | 0.3292 | 134 | — |
| inv | 71 | 1649 | 2555 | H (UB: distinct points) | 0.3271 | 142 | — |
| inv | 73 | 1728 | 2700 | H (UB: distinct points) | 0.3243 | 146 | — |
| inv | 79 | 1989 | 3159 | H (UB: distinct points) | 0.3187 | 158 | — |
| inv | 83 | 2163 | 3485 | H (UB: distinct points) | 0.314 | 166 | — |
| inv | 89 | 2459 | 4004 | H (UB: distinct points) | 0.3104 | 178 | — |
| inv | 97 | 2844 | 4752 | H (UB: distinct points) | 0.3023 | 194 | — |
| inv | 101 | 3047 | 5150 | H (UB: distinct points) | 0.2987 | 202 | — |
| zero | 5 | 11 | 11 | proved (CP-SAT + RC2 + brute force) | 0.44 | 10 | 30* |
| zero | 7 | 22 | 22 | proved (CP-SAT + RC2) | 0.449 | 14 | ≥ 53 |
| zero | 11 | 59 | 65 | H (UB: CP-SAT FEASIBLE lex) | 0.4876 | 22 | ≥ 121 |
| zero | 13 | 78 | 102 | H (UB: CP-SAT FEASIBLE) | 0.4615 | 26 | — |
| zero | 17 | 131 | 257 | H (UB: distinct points) | 0.4533 | 34 | — |
| zero | 19 | 157 | 325 | H (UB: distinct points) | 0.4349 | 38 | — |
| zero | 23 | 225 | 485 | H (UB: distinct points) | 0.4253 | 46 | — |
| zero | 29 | 347 | 785 | H (UB: distinct points) | 0.4126 | 58 | — |
| zero | 31 | 385 | 901 | H (UB: distinct points) | 0.4006 | 62 | — |
| zero | 37 | 547 | 1297 | H (UB: distinct points) | 0.3996 | 74 | — |
| zero | 41 | 666 | 1601 | H (UB: distinct points) | 0.3962 | 82 | — |
| zero | 43 | 682 | 1765 | H (UB: distinct points) | 0.3688 | 86 | — |
| zero | 47 | 803 | 2117 | H (UB: distinct points) | 0.3635 | 94 | — |
| zero | 53 | 1008 | 2705 | H (UB: distinct points) | 0.3588 | 106 | — |
| zero | 59 | 1192 | 3365 | H (UB: distinct points) | 0.3424 | 118 | — |
| zero | 61 | 1267 | 3601 | H (UB: distinct points) | 0.3405 | 122 | — |
| zero | 67 | 1486 | 4357 | H (UB: distinct points) | 0.331 | 134 | — |
| zero | 71 | 1653 | 4901 | H (UB: distinct points) | 0.3279 | 142 | — |
| zero | 73 | 1732 | 5185 | H (UB: distinct points) | 0.325 | 146 | — |
| zero | 79 | 1982 | 6085 | H (UB: distinct points) | 0.3176 | 158 | — |
| zero | 83 | 2171 | 6725 | H (UB: distinct points) | 0.3151 | 166 | — |
| zero | 89 | 2449 | 7745 | H (UB: distinct points) | 0.3092 | 178 | — |
| zero | 97 | 2840 | 9217 | H (UB: distinct points) | 0.3018 | 194 | — |
| zero | 101 | 3052 | 10001 | H (UB: distinct points) | 0.2992 | 202 | — |

The full table, with status strings, is in `table.tsv`.

### Headline findings

- **Exact values, proved by CP-SAT and RC2, plus brute force at p = 5:**
  - β = a² and β = 1/a: 12, 23, 55, 77 for p = 5, 7, 11, 13.
  - β = a³: 12, 22, 59 for p = 5, 7, 11.
  - β = 0: 11, 22 for p = 5, 7.
- **Open small cases:**
  - β = a³, p = 13: 77 ≤ m ≤ 78.
  - β = 0, p = 11: 59 ≤ m ≤ 65.
  - β = 0, p = 13: 78 ≤ m ≤ 102.

  The upper bounds come from CP-SAT only.
- **p = 17..101:** heuristic, certificate-verified lower bounds. m/p² falls
  from about 0.45 at p = 17 to about 0.30 at p = 101, roughly like p^(−0.2)
  (fit below). The only upper bounds there are trivial (about p²/2), so the
  decay is in the *lower* bounds and may partly reflect search quality.
- β = 0 is exactly equivalent to square-free subsets of the torus Z_{p−1}², so
  it is o(p²) by multidimensional Szemerédi (Section 6).
- 1/a and a² are isomorphic.
- No improvement on any README bound for M(n).

## 3. Certificates

`certs.json` maps `beta -> {"2p": [[u, v, c], ...]}`. Vertices 0..p−1 are rows
x and p..2p−1 are columns y. Colour c = a − 1 lies in 0..p−2, inside the
0..2p−1 range allowed for n = 2p. Every configuration in it was rebuilt as an
explicit 2p-vertex graph. `check_simple.py` then checked it independently: it
tests simplicity and the colour range, and enumerates every 4-cycle directly. For
each pair of vertices u < w, every two common neighbours v1, v2 give the cycle
u–v1–w–v2. That checker has no knowledge of the affine structure.
`configs.json` lists the explicit supports D_a for p ≤ 13, as `supports[a]`.
For larger p it gives the support-size profile.

## 4. Method, parameters, validation

**Constraints (`model.py`).**
- Simplicity pairs: two colours whose lines pass through the same point (x, y)
  cannot both use row x.
- Bad 4-cycles: rows x1 < x2, colour a at both rows, a colour b through
  (x2, a·x1 + β(a)) and a colour c through (x1, a·x2 + β(a)). The four
  incidences (a,x1), (a,x2), (b,x2), (c,x1) must not all be present.

The colouring is automatically proper, because each colour is a partial
bijection. Counts are 1–2 × p³ clauses on p(p−1) variables.

**Cross-check (`crosscheck.py`).** For p = 5, 7, 11, 13 and every β, we drew
150–400 random supports of density 0.05–0.5. The clause test agreed with direct
4-cycle enumeration (`check_simple.py`) every time, on both valid and invalid
cases. The number of simplicity pairs matched the number of multi-edges in the
full candidate graph.

**Symmetries (`symmetry.py`, `autgroup.py`).** We brute-forced every map
(x,y) ↦ (sx+t, uy+v), and every transposed map, that preserves the family. The
results:
- a²: (x,y) ↦ (rx, r²y), with a ↦ ra.
- a³: (x,y) ↦ (r²x, r³y), with a ↦ ra.
- 1/a: (x,y) ↦ (r²x, ry), with a ↦ a/r.

Each group has order p − 1 and acts regularly on colours.
For β = 0 the group (x,y) ↦ (sx, uy) and its transposes has order 2(p−1)².
We also computed the full automorphism group of the clause hypergraph with
nauty. For a², a³ and 1/a it has order exactly p − 1 when p = 11 and 13, so
the affine maps are all the symmetries. (At p = 7 it is larger, 288 or 24.)
For β = 0 it is huge: 5.8·10⁹ at p = 11 and 1.1·10¹² at p = 13. The reason is
given in Section 6.

Symmetry breaking for the exact solvers:
- "size": the group is transitive on colours, so we may assume |D_1| ≥ |D_a|.
  For β = 0 we also assume row 1 has the largest count among nonzero rows; the
  group is transitive on (colour, nonzero row) pairs.
- "lex": lex-leader constraints for all group elements, from the closure of the
  nauty generators, capped at 300 elements.

**Exact methods.**
1. CP-SAT (`solve_cpsat.py`, size or lex breaking) maximises m.
   `decide.py` is the decision version, m ≥ target.
2. RC2 MaxSAT (`exact_rc2.py`) has no symmetry breaking. It is independent of
   method 1 except for the clause generator, which was validated separately.
3. At p = 5, `brute_p5.py` enumerates all 2²⁰ supports.

All three agree on every case they all finished (p = 5, 7, 11, 13; table).
The families 1/a and a² are isomorphic, by rows ↔ columns
(x,y) ↦ (y, −x) and a ↦ −1/a (`transfer.py`, verified by the checker), so their
optimal values are equal. Their proofs are shared, and the same values were also
obtained on each side separately.

**Heuristics.**
- `ls.c` is simulated annealing on incidence sets with conflict-repair moves:
  add v, then drop one other incidence from each clause v would complete, at most
  3 drops. Temperature falls linearly from 0.6 to 0.02, with a short tabu.
  - Round 1: 2·10⁴·p² iterations × 2 seeds.
  - Round 2: 6·10⁴·p² iterations, restarted from the best so far.
- `sym_solve.py` restricts to supports invariant under a cyclic subgroup of the
  symmetry group. At p = 13 it was strictly worse than unrestricted solving
  (best 75 vs 77 for a²), so we did not use it at larger p.
- `improve.sh` / `decide.py` runs CP-SAT on "best + 1" for p = 17–23.

**Timings.**
- p ≤ 11 is solved in under 1 s, except β = 0, p = 11 (Section 6).
- a²/1/a at p = 13: CP-SAT 5 s, RC2 1–13 s.
- a³ at p = 13: the optimiser was stuck at 76 for 900 s. The decision run
  "m ≥ 77" found a solution in 22–29 s.
- One LS run at p = 101 takes 2–5 min.

**Random-deletion baseline.** For orientation only, not a result. Keep each
incidence independently with probability δ, then delete one incidence from
each completed clause. There are about Cp³ bad 4-sets and p²/2 simplicity pairs.
Optimising δ ≍ p^(−1/3) gives m ≥ c·p^(5/3), so m_max/p² ≥ c·p^(−1/3) for every
β. The best values found here decay more slowly than that over p ≤ 101 (see the
fit below).

**Decay fit** (`fit.py`, best found values, p = 11..101; `fit.txt`):

```
a2: m/p^2 ~ 0.774 p^-0.202 (max resid 0.0225);  ~ 0.649 - 0.0755 ln p (max resid 0.0138); p range 11..101
a3: m/p^2 ~ 0.831 p^-0.217 (max resid 0.0212);  ~ 0.683 - 0.0828 ln p (max resid 0.0151); p range 11..101
inv: m/p^2 ~ 0.774 p^-0.202 (max resid 0.0225);  ~ 0.649 - 0.0755 ln p (max resid 0.0138); p range 11..101
zero: m/p^2 ~ 0.849 p^-0.222 (max resid 0.0238);  ~ 0.691 - 0.0846 ln p (max resid 0.0197); p range 11..101
```

## 5. Code

All code is in this folder:
- `model.py`: constraints.
- `check_simple.py`: independent checker.
- `crosscheck.py`, `brute_p5.py`.
- `symmetry.py`, `autgroup.py`: symmetry groups.
- `solve_cpsat.py`, `decide.py`, `exact_rc2.py`.
- `ls.c` with `run_ls.py`, `sweep_ls.sh`, `sweep_ls2.sh`, `improve.sh`.
- `sym_solve.py`, `transfer.py`.
- `torus_squares.py`: the β = 0 reformulation.
- `analyze.py`, `make_table.py`, `fit.py`.
- `runs/`: every solution as incidence lists. Variable index (a−1)·p + x.
- `logs/`.

To rebuild: `gcc -O2 -o ls ls.c -lm`, then `python3 make_table.py` and
`python3 fit.py`.

## 6. Surprises and next steps

**1. β = 0 is exactly the square-free problem on a torus.** Row 0 and column 0
can carry only one edge, (0,0), and it lies on no 4-cycle. On the nonzero rows,
write x = g^i and y = g^j. Then colour a = g^(j−i), and a bad 4-cycle is exactly
an axis-parallel square {i, i+d} × {j, j+d} with d ≠ 0 in Z_n², where n = p − 1.
Hence

  m_max(β=0, p) = 1 + sq(p − 1),  sq(n) = max size of a square-free subset of Z_n².

Checks:
- The clause counts equal the torus square counts: 20, 81, 425, 756 for
  p = 5, 7, 11, 13.
- `torus_squares.py` gives sq(4) = 10 and sq(6) = 21, matching m = 11 and 22.

A square-free set in Z_n² lifts to a square-free set in [0,n)². By the
Furstenberg–Katznelson multidimensional Szemerédi theorem, sq(n) = o(n²).
So the β = 0 family has m = o(p²), with arbitrary supports. This is a
short-proof observation relying on a standard theorem. It is not a
machine-checked result, and its rate is very weak. It also explains the huge
nauty group for β = 0: it contains the torus translations and dihedral maps
together with the unit multipliers.

**2. 1/a and a² are the same problem.** The map (x,y) ↦ (y, −x) with
a ↦ −1/a carries one family onto the other. The values agree for every p, as
they must.

**3. The best values hardly depend on β once p ≥ 17.**
- At p = 19 the four families give 156, 156, 156 and 157.
- At p = 101 they lie within 1%.

The local optimum seems to be governed by clause counts rather than by the
algebra of β. This is heuristic, since only lower bounds are known there.

**4. The local search is not optimal even at p = 13.** For β = a³, two methods
stopped at 76: the LS, and the CP-SAT optimiser with a 900 s limit. The decision
run "m ≥ 77" found 77 in about 25 s. Round 2 of the LS, with three times the
iterations and a restart from the best, gained 0.5–2% at p ≥ 29. Treat every
p ≥ 17 entry as a lower bound with an unknown gap.

The only upper bounds there are trivial: the distinct-points count, which is
(p−1)(p+2)/2 for a² and about 0.5p². CP-SAT bounds after 500 s of decision search
were no better. "Best + 1" decision runs for p = 17, 19, 23 all returned UNKNOWN
after 500 s each.

**5. Optimal and best supports look random.**
- Sizes cluster around the mean, about ±20%. Mean |D_a|/p is 0.49 at p = 13,
  0.41 at p = 31, 0.35 at p = 61 and 0.30 at p = 101.
- At most 2 supports per configuration at p ≤ 13, and none at p ≥ 31, are
  nontrivial arithmetic progressions (dilated intervals).
- No support is a multiplicative coset, even with 0 added.
- The number of 3-term APs inside each D_a is 0.98–1.09 times the random
  expectation, so the supports are neither AP-free nor AP-rich.
- For a² and a³, 30–47% of the colours use row 0. For β = 0 only one
  colour can.

There is one non-random feature. The occupancy of the symmetry orbits
{(ra, r^k x)} is very uneven: for a² at p = 31, between 1 and 22 of 30 possible.
Even so, fully orbit-invariant configurations are clearly worse; the best
symmetric configuration at p = 13 has 75 edges, against 77 overall.

**6. Comparison with the notes.**
- The common-support bound p²·exp(−c(log p)^(1/12)) and the quadratic
  common-potential bound O(p^(2−1/32)) are almost flat for p ≤ 101. For example,
  p^(−1/32) only falls from 0.95 to 0.87.
- The data cannot distinguish those rates.
- The best values here fall like p^(−0.2), between the random-deletion floor
  p^(−1/3) and the flat theoretical ceilings.
- Nothing seen contradicts m = o(p²) for arbitrary supports. Nothing proves it
  either, except in the β = 0 case of item 1.

**7. No new bounds for M(n).**
- m/(2p)² is at most 0.122, reached at p = 11 for β = a³ and β = 0.
- The general constructions in the README reach about 0.24–0.30 n².
- At n = 14, 22 and 26 the affine values 23, 59 and 78 sit far below the README
  bounds: M(14) ≥ 53, M(22) ≥ 121, and M(25) ≥ 152 at n = 25.
- The certificates are valid but weak lower bounds for M(2p), up to
  M(202) ≥ 3073 (β = a³).

**Next steps and sharding plans.**

(a) **β = a³, p = 13: is 77 optimal? The known bound is 77 ≤ m ≤ 78.** Run
`python3 decide.py a3 13 78 <secs> <workers> <s>` for each shard
s = |D_1| ∈ {7, …, 12}. |D_1| is a largest support, so these shards cover the
whole search; s = 13 is INFEASIBLE in 0.01 s.

Measured with 1 worker on a loaded 4-core VM:
- s = 12 and s = 11: UNKNOWN after 1500 s each.
- s = 10, 9, 8, 7: also UNKNOWN after 1500 s each.
- Unsharded, 2 workers: UNKNOWN after 3600 s.
- RC2, unsharded: no answer in 30 min.

A finer split is the next step. Fix D_1 up to the stabiliser, which is trivial
here, so there are C(13, s) shards per s, each much smaller. Alternatively, use
the sizes of the two largest supports.

(b) **β = 0, p = 11: m ∈ [59, 65], so sq(10) ∈ [58, 64].** Solve the torus
problem directly, with breaking for translations, the dihedral group and
multipliers. The torus group has order about n²·8·φ(n). Shard on the size of
the largest row.

(c) Exact p = 17 for a²/1/a needs a better method. RC2 gave no answer in 40
min, and CP-SAT "≥ 127" was UNKNOWN after 500 s.

(d) A real upper-bound method for mid-range p would let the trend be tested.
Candidates are a Lovász-theta or SDP bound on the conflict hypergraph, or a
flag-algebra-style local counting argument.
