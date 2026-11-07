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
