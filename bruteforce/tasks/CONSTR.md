# Task CONSTR: structured constructions for n = 26..128, and the M(n)/n² trend

Results folder: `bruteforce/results/CONSTR/`. Wrap up by **16:30 UTC**.

Cover every n from 26 to 64, plus primes and prime powers up to about 128.
Optimise each family exactly where possible: SAT, ILP or exhaustive search over
its parameters.

## Families to try

- **Sum colourings on Z_n or F_q.** The edge {i, j} is present iff i + j ∈ S, or
  a variant such as Cayley graphs with i − j ∈ ±S. The colour is a function of
  i + j.
  - Derive the exact validity condition, including the degenerate 2i = s cases.
  - Then optimise S exactly for each n.
- **Bipartite affine colourings over F_q.** These have 2q vertices and q − 1
  colours, each colour a map x ↦ ax + β(a) on a support D_a. Use them for M(2q),
  and for M(2q + k) after padding.
- **Circulant and Cayley graphs with orbit colourings.**
- **The Burr–Erdős–Graham–Sós (7,4) triple-system construction.** Derive it from
  first principles and test it.
- **Blow-ups, products and gluings** of small extremal examples, and vertex
  additions to the best example for nearby n.

Finish every family with local search (tabu or annealing on edges and colours,
keeping at most n colours).

## Verification

Every certificate must pass a separate, deliberately simple 4-cycle checker.

## Output

- **Results table:** `trend.tsv` with columns `n, best_LB, LB/n², family`.
- **Certificates:**
  - for algebraic constructions, the parameters (S, or β and D) in a form that
    regenerates them;
  - for n ≤ 64, the explicit edge lists in `certs.json`;
  - for larger n, the parameters plus the sha256 of the sorted edge list.
- **Trend analysis:**
  - Fit c·n², n²/log n, n^(2−δ) and n²·exp(−c√log n), and compare the fits.
  - Say honestly what small-n data can and cannot say about the asymptotic
    question.
