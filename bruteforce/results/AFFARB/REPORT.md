# AFFARB: affine model with the intercept function optimised as well

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          14           0           0          15
Swap:              0           0           0
```

All computation ran in this cloud container. The wrap-up deadline was 21:00 UTC; the original
16:30 deadline was superseded, see the run prompt.

## 2. Results

Maximum of m = Σ_a |D_a| over all β: F_p^× → F_p and all supports D_a ⊆ F_p (empty allowed).

| p | best m | upper bound | status | m/p² | M(2p) ≥ | README value for n = 2p |
|---|---|---|---|---|---|---|
| 3 | 4 | 4 | **proved** | 0.4444 | M(6) ≥ 4 | M(6) = 11 |
| 5 | 12 | 12 | **proved** | 0.4800 | M(10) ≥ 12 | M(10) = 30* |
| 7 | 25 | 25 | **proved** | 0.5102 | M(14) ≥ 25 | M(14) ≥ 53 (LB table) |
| 11 | 60 | 81 | LB *certificate-verified* (heuristic search); UB *proved* (counting bound), gap open | 0.4959 | M(22) ≥ 60 | M(22) ≥ 121 (LB table) |
| 13 | 82 | 113 | LB *certificate-verified* (heuristic search); UB *proved* (counting bound), gap open | 0.4852 | M(26) ≥ 82 | — (no entry for n > 25) |
| 17 | 132 | 194 | LB *certificate-verified* (heuristic search); UB *proved* (counting bound), gap open | 0.4567 | M(34) ≥ 132 | — (no entry for n > 25) |
| 19 | 161 | 242 | LB *certificate-verified* (heuristic search); UB *proved* (counting bound), gap open | 0.4460 | M(38) ≥ 161 | — (no entry for n > 25) |
| 23 | 226 | 354 | LB *certificate-verified* (heuristic search); UB *proved* (counting bound), gap open | 0.4272 | M(46) ≥ 226 | — (no entry for n > 25) |
| 29 | 343 | 563 | LB *certificate-verified* (heuristic search); UB *proved* (counting bound), gap open | 0.4078 | M(58) ≥ 343 | — (no entry for n > 25) |
| 31 | 386 | 643 | LB *certificate-verified* (heuristic search); UB *proved* (counting bound), gap open | 0.4017 | M(62) ≥ 386 | — (no entry for n > 25) |
| 37 | 526 | 916 | LB *certificate-verified* (heuristic search); UB *proved* (counting bound), gap open | 0.3842 | M(74) ≥ 526 | — (no entry for n > 25) |
| 41 | 633 | 1124 | LB *certificate-verified* (heuristic search); UB *proved* (counting bound), gap open | 0.3766 | M(82) ≥ 633 | — (no entry for n > 25) |
| 43 | 685 | 1236 | LB *certificate-verified* (heuristic search); UB *proved* (counting bound), gap open | 0.3705 | M(86) ≥ 685 | — (no entry for n > 25) |
| 47 | 800 | 1477 | LB *certificate-verified* (heuristic search); UB *proved* (counting bound), gap open | 0.3622 | M(94) ≥ 800 | — (no entry for n > 25) |
| 53 | 992 | 1878 | LB *certificate-verified* (heuristic search); UB *proved* (counting bound), gap open | 0.3532 | M(106) ≥ 992 | — (no entry for n > 25) |
| 59 | 1195 | 2326 | LB *certificate-verified* (heuristic search); UB *proved* (counting bound), gap open | 0.3433 | M(118) ≥ 1195 | — (no entry for n > 25) |
| 61 | 1267 | 2486 | LB *certificate-verified* (heuristic search); UB *proved* (counting bound), gap open | 0.3405 | M(122) ≥ 1267 | — (no entry for n > 25) |

Status meanings:
- *proved* (p = 3, 5, 7): two or more independent exhaustive methods agree, see §4.3. For
  p = 7 this includes a DRAT proof checked by drat-trim.
- p ≥ 11: the best m is an explicit configuration, checked by two separate checkers (§4.6).
  It is a lower bound for the joint optimum and was found by heuristic search. The upper bound
  is the proved counting bound of §4.4, which is not tight. **Exact maxima for p = 11, 13, 17
  are *unfinished*.** See §6 for the gap and why sharding did not close it.

Bound on M(2p): each configuration is a 2p-vertex graph with p − 1 ≤ 2p colours, so
M(2p) ≥ m. These bounds are **far below** the README values: M(14) ≥ 25 against 53, and
M(22) ≥ 60 against 121. m/(2p)² falls from 0.128 (p = 7) to 0.085 (p = 61), while the README
LB/n² is about 0.24–0.27. Even with β optimised, the bipartite affine model is not
competitive for lower bounds on M(n).

## 3. Certificates

- `configs.json`: for each p, `beta` as a list (β(1), …, β(p−1)), and `D` as
  {a: sorted D_a}. It also has m, the checker message, and the search run that produced it.
- `certs.json`: the same configurations as explicit graphs in the README format
  {"n": [[u, v, c], …]}, with n = 2p. Rows are 0..p−1, columns are p..2p−1, the edge is
  (x, p + (a x + β(a)) mod p), and its colour is a − 1.
- `best/<p>.json`: the same data, one file per p.
- `table.tsv`: columns p, best m, upper bound, status, m/p².

## 4. Method

### 4.1 Joint model (step 1) — `model.py`, `cnf.py`

The variables are B[a,t] = [β(a) = t], one-hot over t ∈ F_p, and
z[a,x,t] = [x ∈ D_a and β(a) = t], with z → B. Cells use W[x,y] = Σ_a z[a, x, y − a x],
and requiring W ∈ {0,1} encodes simplicity exactly. Properness is automatic: colour a
is a partial injective function, and two colours can only meet at one cell.

**Rainbow condition for any β.** In a 4-cycle x₁ y₁ x₂ y₂ (bipartite, x₁ ≠ x₂, y₁ ≠ y₂),
adjacent edges already have distinct colours. Two opposite edges (x₁,y₁), (x₂,y₂) of the same
colour a force a = (y₂ − y₁)/(x₂ − x₁) and a common intercept t = y₁ − a x₁ = y₂ − a x₂. So
the only forbidden patterns are, for every a, t and x₁ < x₂:

    ¬( z[a,x₁,t] ∧ z[a,x₂,t] ∧ W[x₂, a x₁ + t] ∧ W[x₁, a x₂ + t] ).

There are (p − 1)·p·C(p,2) such clauses. The objective is Σ z. `cnf.py` is the same model in
pure CNF (pairwise at-most-one, sequential-counter cardinality for m ≥ target). `maxsat.py`
turns it into a weighted partial MaxSAT instance with soft units e[a,x] ↔ ∨_t z[a,x,t].

**Cross-checks** (`crosscheck.py`, log in `logs/crosscheck.txt`):
- `brute.c` is an independent brute force. For every β (all 9 for p = 3, all 625 for p = 5)
  it searches all supports by DFS, checking simplicity and every 4-cycle through each newly
  added edge directly on the coloured graph.
- The per-β CP-SAT optimum equals the brute-force optimum for 9/9 β at p = 3 and 625/625 β at
  p = 5. The p = 5 histogram of per-β maxima is {11: 25, 12: 600}.
- For random (β, D), feasibility of the model with z fixed equals the verdict of the direct
  4-cycle checker `check.py` in 300/300 (p = 3), 300/300 (p = 5) and 150/150 (p = 7) cases,
  with both valid and invalid instances present.

### 4.2 Symmetry (step 2)

Take row map x ↦ x' = ux + v and column map y ↦ y' = sy + t with u, s ∈ F_p^×, v, t ∈ F_p.
An edge (x, ax + β(a)) of colour a goes to

    y' = s(a x + β(a)) + t = (sa/u)·x' + (sβ(a) + t − (sa/u)·v).

So the colour class of slope a becomes the colour class of slope a' = λa with λ = s/u, and

    β'(λa) = s·β(a) + t − λ a v,      D'_{λa} = u·D_a + v.

The map is a bijection of the edge set that preserves 4-cycles and colour classes (it only
renames colours a ↦ λa, which is a permutation of F_p^×), so simplicity, the rainbow property
and m = Σ|D_a| are preserved. On the coefficient plane, (a, β) ↦ (λa, sβ + t − λ a v) is an
invertible affine map, so it sends non-vertical lines to non-vertical lines and preserves the
number of points (a, β(a)) on each line. (Transposing rows and columns gives a' = 1/a,
β'(a') = −β(a)/a; this is also a symmetry, but it is not used in the canonical form.)

**Canonical form used in the exact runs** (`model.py`, `sym=True, symL=True`):

1. the line β = 0 carries the maximum number L of points (a, β(a)), a ∈ F_p^×, over all
   lines β = ua + v;
2. β(1) = 0;
3. the first slope a ∈ {2, 3, …} with β(a) ≠ 0 (if any) has β(a) = 1.

*Soundness.* Start from any valid configuration and let β = μa + ν be a line with the maximum
number L ≥ 1 of points (vertical lines carry at most one point, and a non-vertical line through
any point exists). Apply the map with u = s = 1 (so λ = 1), row shift v = μ and column shift
t = −ν. Then β'(a) = β(a) − μa − ν, which vanishes exactly on that line. Occupancies are
preserved, so (1) holds. Pick a₀ with β'(a₀) = 0 and apply s = 1, u = a₀ (so λ = 1/a₀),
t = v = 0. Then β''(a/a₀) = β'(a), so β''(1) = 0 and the zero line keeps L points, giving
(1)–(2). Finally, the map u = s, t = v = 0 (so λ = 1) multiplies β by s and keeps every zero.
Choosing s makes the first non-zero value equal to 1, giving (3). m is unchanged throughout,
so the maximum over canonical configurations equals the unrestricted maximum. Empty D_a are allowed, and β
on an unused slope is arbitrary, so the normalisation never constrains the supports.

The model with only β(1) = β(2) = 0, β(3) ∈ {0, 1} (an earlier, weaker canonical form; sound by
the same argument with the line through (1, β(1)), (2, β(2))) and the model with no symmetry
breaking at all give the same optima for p = 3, 5, 7.

### 4.3 Exact maxima (step 3)

| p | value | evidence |
|---|---|---|
| 3 | 4 | brute force over all β and all supports; joint CP-SAT OPTIMAL with and without symmetry breaking |
| 5 | 12 | brute force (all 625 β); joint CP-SAT OPTIMAL with and without symmetry breaking; RC2 MaxSAT optimum 12 |
| 7 | 25 | joint CP-SAT OPTIMAL **without** symmetry breaking (39 s, 4 workers) and with both canonical forms (3–11 s); RC2 MaxSAT optimum 25 (661 s); CaDiCaL: m ≥ 25 SAT, m ≥ 26 UNSAT, **DRAT proof verified by drat-trim** (`logs/drat_p7_26.txt`, CNF sha256 4cdb04cc…, written by `write_cnf.py 7 26`) |

The p = 7 DRAT check certifies the CNF from `cnf.py`. Its correctness rests on the encoding,
which was validated by the brute-force and random cross-checks in §4.1. The canonical form in
that CNF is the weaker one, β(1) = β(2) = 0 and β(3) ∈ {0,1}.

Fixed-formula exact optima, for comparison (`fixed_exact.py`, CP-SAT with β fixed and no
symmetry breaking):

| p | β = 0 | β = a² | β = a³ | β = 1/a | joint |
|---|---|---|---|---|---|
| 5 | 11 | 12 | 12 | 12 | 12 |
| 7 | 22 | 23 | 22 | 23 | 25 |
| 11 | 59 ≤ · ≤ 101 | 55 ≤ · ≤ 65 | 59 ≤ · ≤ 75 | 55 ≤ · ≤ 65 | 60 ≤ · ≤ 81 |

The p = 11 bounds come from CP-SAT after 300 s on 1 worker (`logs/fixed_exact11.log`). The lower
bounds are the best of CP-SAT and the fixed-β SA (β = 0: SA 59, CP-SAT 56).

### 4.4 Proved upper bound used in the table (counting bound)

**Lemma.** Let G be a bipartite graph with sides X, Y (|X| = |Y| = p), properly edge-coloured
with at most p − 1 colours so that every 4-cycle is rainbow. For rows x₁ ≠ x₂ let d_i = deg x_i,
c = |N(x₁) ∩ N(x₂)| and k = number of colours present at both rows. Then k + 2c ≤ d₁ + d₂.

*Proof.* For a colour a at both rows let y₁(a), y₂(a) be its columns at x₁, x₂. If both lay
in C = N(x₁) ∩ N(x₂), then x₁ y₁(a) x₂ y₂(a) is a 4-cycle whose opposite edges
x₁y₁(a), x₂y₂(a) both have colour a, contradiction. Send a to y₁(a) ∈ N(x₁)∖C if
y₁(a) ∉ C and otherwise to y₂(a) ∈ N(x₂)∖C. The maps a ↦ y_i(a) are injective (a row has one
edge per column), so k ≤ |N(x₁)∖C| + |N(x₂)∖C| = d₁ + d₂ − 2c. ∎

Summing over the C(p,2) row pairs:
Σ_a C(|E_a|, 2) + 2 Σ_y C(deg y, 2) ≤ (p − 1)·m, where E_a is colour class a. With p − 1 colour
classes of size ≤ p and p columns of degree ≤ p − 1 summing to m, convexity gives the smallest
left side at balanced sizes. `finalize.py: counting_bound` returns the largest m for which the
balanced left side is still ≤ (p − 1)m. This is ≈ 0.669 p² (81 for p = 11, 113 for p = 13),
valid for every β and every support (in fact for every bipartite p × p graph of this kind).
It is far from the found values (≈ 0.34–0.50 p²). It is also not tight at p = 7, where it gives
32 against the exact value 25.

The joint CP-SAT runs never got an objective bound below this for p ≥ 11. On p = 11 the
best CP-SAT bound after 10–45 min on 3–4 workers was 109–112, versus the counting bound 81.
Adding the pair inequality (with auxiliary product variables, `add_pair_cuts`) and its summed
quadratic form (`add_global_cut`) as constraints did not help: the LP relaxation does not see
them, and on p = 7 they slow the core-guided search (16 s → 75–174 s on one worker).

### 4.5 Larger p (step 4): alternating optimisation and local search

- `ls.c` is simulated annealing over (β, D) jointly. Moves: toggle an incidence (a,x); if
  the cell is taken by another colour, evict that colour (swap); move a whole colour line
  β(a) → t′ while keeping D_a (3% of moves). The cost is m − 1.5·V, where V counts
  same-colour opposite pairs whose two cross cells are occupied. Each delta costs O(p). The
  temperature is geometric from 0.6 to 0.05. Only configurations with V = 0 are recorded, and
  every recorded one is re-checked by `check.py` before it is saved (`run_ls.py`).
- `lns.py` does alternating optimisation / LNS with CP-SAT: fix β on all but k = 3 random
  slopes, free those β values and all supports, and re-solve from the current configuration
  as a hint. k = 0 gives the pure fixed-β support optimisation. For p = 11, 13, 17, 19, 23,
  240 s each, it never improved the SA values. Those values were also reached from several
  seeds, so they look like stable local optima. That is not evidence of global optimality.
- β seeds: random; β ≡ 0; a²; a³; 1/a; exponential g^a; discrete log log_g a (graph of a
  Sidon-type map); and an AP-free seed, β = 0 on g^A for a greedy 3AP-free A ⊆ Z_(p−1) and
  a² elsewhere (`gen_seeds.py`). The seeds do not matter: every seed lands within about 1–2%
  of the best (`logs/seeded.log`, `fixed.jsonl`).
- Iteration budget: itf·p³ iterations, with itf = 15000 (p ≤ 13), 6000 (17–31) and
  1200 (37–61). Calibration at p = 31: itf 1200 gives 383 and 384 (43 s each), itf 6000
  gives 386, and itf 30000 gives 386 (1093 s). So the large-p values are not limited by run
  length at this scale. At larger p a second round with itf 4500 (one run per p, random
  seed) gave small gains: 37: 523 → 526, 41: 631 → 633, 43: 682 → 685, 47: 797 → 800,
  53: 986 → 992, 59: 1185 → 1195, 61: 1260 → 1267. These are +0.3–0.8%, so the large-p values
  are probably still slightly below the true maxima, by at most about 1% judging from this
  trend. The table uses the best value found.
- Lost logs: some run logs (first-round p = 59 and 61 lines of `logs/ls_big.log`, the
  second-round p = 47 and 61 runs, and the first attempt at the p = 11 shard) were lost. A
  `git pull --rebase` replaced tracked log files while the jobs were still writing to them. The
  configurations themselves were saved by the driver to `best/*.json` and re-verified;
  `logs/ls_long_round2.log` reconstructs the missing lines. The shard was re-run.

### 4.6 Verification (step 6)

- `check.py` builds the explicit 2p-vertex graph from (β, D). It rejects a cell coloured
  twice, checks that colours a − 1 lie in 0..2p−1 and that the colouring is proper, and
  enumerates every 4-cycle v₀v₁v₂v₃ of the general (not assumed bipartite) graph through pairs
  (v₀, v₂) and pairs of common neighbours, requiring 4 distinct colours. This runs on every
  saved configuration and again in `finalize.py`.
- `check_certs.py` reads only `certs.json` (format level, no affine structure). It checks no
  loops or repeated edges, colours in 0..n−1, properness and all 4-cycles rainbow. All 17
  certificates pass. The counts of 4-cycles, all rainbow, run from 0 (p = 3) to 39634
  (p = 61), see `logs/check_certs.txt`.

## 5. Comparison and structure (step 5)

SA with β **held fixed**, best of 2 runs (itf 3000 for p ≤ 23, 1500 for p ≥ 29), against
the joint best. "seed" columns are free-β SA started from that β:

| p | joint best | β=0 | β=a² | β=a³ | β=1/a | random β | exp seed | dlog seed | AP-free seed |
|---|---|---|---|---|---|---|---|---|---|
| 11 | 60 | 59 | 55 | 59 | 55 | 59 | – | – | – |
| 13 | 82 | 77 | 77 | 76 | 77 | 80 | 79 | 81 | 79 |
| 17 | 132 | 129 | 126 | 132 | 126 | 129 | 128 | 131 | 131 |
| 19 | 161 | 155 | 156 | 155 | 155 | 158 | 160 | 158 | 157 |
| 23 | 226 | 219 | 222 | 223 | 222 | 225 | 225 | 224 | 223 |
| 29 | 343 | 333 | 331 | 340 | 328 | 338 | 336 | 339 | 341 |
| 31 | 386 | 372 | 370 | 381 | 371 | 379 | 380 | 381 | 385 |
| 37 | 526 | 515 | 513 | 519 | 513 | 523 | – | – | – |
| 41 | 633 | 623 | 612 | 627 | 611 | 626 | – | – | – |

Observations (all *heuristic* for p ≥ 11):
- **The intercept function barely matters once supports are arbitrary.** A uniformly random
  fixed β gets within 0–2% of the joint best: 59/60, 225/226, 523/526 at p = 11, 23, 37.
  Optimising β gains about 1–3%. The exact values at p = 5, 7 show the same picture: joint
  25 against 22–23 for formulas at p = 7.
- Among formulas, β = a³ is consistently best and close to random β. β = a² and β = 1/a
  are worst, and they agree with each other: 55/55 at p = 11, 23/23 at p = 7. This is expected
  because transposition sends β = a² to β′(a′) = −1/a′, which the scaling s = −1 turns into
  1/a′.
- **Optimal β look unstructured** (`structure.json`). The interpolation degree of β on the
  used slopes is maximal or nearly so, at least (number of used slopes) − 2, for every
  p ≥ 5. All p − 1 slopes are used for every p ≥ 5. The maximum line occupancy L of {(a, β(a))} for the
  best configurations is 4–7, the same as for random functions (median 3–7). Earlier runs
  seeded with β ≡ 0 kept a huge pencil on the line β = 0 and still came within 1% of the
  best: p = 47, 797 with L = 31; p = 53, 986 with L = 34; p = 61, 1260 with L = 48 of 60
  slopes (these configurations are `best/{47,53,61}.json` at commit 89ddedf). Asymptotically
  such a pencil is a group-table configuration and gives density o(p²) by Solymosi's theorem, but at
  p ≤ 61 it costs nothing visible. Support sizes are fairly balanced: |D_a| from 17 to 26 and
  row degrees from 18 to 23 at p = 61.
- **Supports look random as well** (`supports.py`, `supports.json`). For the best
  configurations, the additive and multiplicative energies of the D_a (|D_a| > 2) are
  0.99–1.04 times those of random sets of the same size. That rules out intervals, APs and
  cosets, which would have much larger energy. Pairwise overlaps |D_a ∩ D_b| are slightly
  below the random expectation, by a factor of 0.94–0.97.
- **Decay fit.** Fitting best m/p² for p ≥ 11 (`fit.py`, `fit.json`): the power law
  m/p² ≈ 0.859·p^(−0.223), i.e. m ≈ 0.86·p^1.78, has rms 0.0024. a + b/√p gives a = 0.230,
  rms 0.0055; a + b/log p gives a = 0.125, rms 0.0070; a + b/p gives rms 0.0110. The power
  law fits best, which is consistent with m = o(p²) in this model. It is still a fit to
  heuristic lower bounds over p ≤ 61 and cannot separate p^(2−δ) from slowly decaying
  forms with a positive limit.

## 6. Unfinished: exact p = 11, 13 and a sharding plan

The gap at p = 11 is 60 ≤ max ≤ 81. Measurements:
- Joint CP-SAT (4 workers, canonical form): objective bound 112 after 70 s and 109 after
  10 min, stuck. Single-worker core-guided: 117 after 144 s, one core per ~60 s and slowing.
  Adding the pair or quadratic cuts did not lower the bound (110 after 25 s with gcut).
- CaDiCaL on the CNF for m ≥ 61 (71 530 variables, 153 689 clauses): no answer after 75 min (still running at the time of this commit; see the final update below).
- Decision shards, fixing β(2), β(3) under the canonical form, `shard.py p target T W b2 b3 [b4]`.
  At p = 7 and target 26, single worker: shard (0,0) took 122 s and shard (1,3) took 5.6 s,
  against 3–10 s for the whole 4-worker optimisation. Sharding the joint CP-SAT therefore does
  not pay. At p = 11 the level-3 shard (β(2), β(3), β(4)) = (1, 0, 0) with target 61
  was still UNKNOWN after 1200 s on one worker (`logs/shard11_100.log`; the 4 cores were shared with 4 other jobs).
- Fixed β at p = 11 (β = a²): bound 65 after 300 s. Fixed-β problems are much better
  conditioned, but there are about p^(p−1)/(2p²(p−1)²) ≈ 1.1·10⁶ β-orbits at p = 11.

**Plan.** Level-2 shards are (β(2), β(3)) ∈ {(0,0), (0,1)} ∪ {(1,t) : t ∈ F_11}, 13 shards.
Level 3 adds β(4) ∈ F_11, 143 shards. Run `python3 shard.py 11 61 <sec> <workers> b2 b3 b4`
per shard; m ≥ 61 is ruled out when all shards report INFEASIBLE. At the measured rates this
is not feasible without a much stronger relaxation. I recommend first a stronger per-β upper
bound, for example a Lovász-theta/SDP bound on the conflict structure, or the pair inequality
refined with the arc-path structure (arcs of a colour pair form vertex-disjoint paths), and
then branching on β with that bound. p = 13 and 17 are further out.

## 7. Files

| file | purpose |
|---|---|
| `model.py` | joint CP-SAT model, canonical forms, pair and global cuts |
| `cnf.py`, `write_cnf.py`, `sat_dec.py` | CNF encoding, DIMACS writer, SAT decision via pysat |
| `maxsat.py` | RC2 MaxSAT version (second exact method) |
| `brute.c` | independent brute force over all β and supports (p = 3, 5) |
| `crosscheck.py` | model vs brute force and random checks |
| `check.py`, `check_certs.py` | the two verifiers |
| `ls.c`, `run_ls.py`, `calib.sh` | simulated annealing and its verified driver |
| `lns.py` | CP-SAT LNS / alternating optimisation over β |
| `run_fixed.py`, `fixed_exact.py`, `fixed.jsonl` | fixed-formula and random-β comparisons |
| `gen_seeds.py`, `seeds/` | Sidon-type, exponential and AP-free β seeds |
| `run_exact.py`, `run_core.py`, `shard.py`, `exp_*.py` | exact attempts and timing experiments |
| `analyze.py`, `structure.py`, `fit.py` | structure statistics and fits |
| `finalize.py` | re-verify and write configs.json, certs.json, table.tsv |
| `logs/` | solver logs, DRAT check, calibration |

Tools: OR-tools 9.15 (CP-SAT) and python-sat 1.9 (RC2, CaDiCaL 1.9.5 via pysat), installed with
pip. The CaDiCaL binary (master) and drat-trim were built from source cloned from GitHub,
outside the results folder. The 190 MB DRAT proof was not committed; its sha256 is in
`logs/drat_p7_26.txt`, and it can be regenerated with the command given there.

## 8. Surprises and next steps

- The biggest surprise: with arbitrary supports, **β is nearly irrelevant**. Random β is as
  good as optimised β to within 1–2%, and all the difficulty sits in the supports. This
  suggests the notes' remaining obstacle (arbitrary supports) is the whole problem, and that
  restricting β (polynomial, Sidon-type, …) buys little on the construction side.
- The joint CP-SAT relaxation is extremely weak (bound ≈ 0.9p² at p = 11). The analytic
  counting bound (≈ 0.669p²) beats it, but it is still far from the truth (≈ 0.5p² at p = 11).
- Next steps: (i) a stronger certified upper bound for fixed β (SDP), to make β-branching
  viable at p = 11; (ii) longer or parallel-tempering SA at p ≥ 61 to firm up the decay
  exponent; (iii) the supports and β both look random-like, so a random-model heuristic (each
  incidence kept independently, then repaired) could predict the decay exponent and be
  compared with the fit m ≈ 0.86·p^1.78.
