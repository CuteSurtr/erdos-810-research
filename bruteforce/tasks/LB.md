# Task LB: lower bounds for n = 13..30

Results folder: `bruteforce/results/LB/`. Wrap up by **16:30 UTC**.

Improve the bounds in the README table for n = 13..25, and establish the first
bounds for n = 26..30. Task CONSTR covers structured families for n ≥ 26; you
focus on strong general search.

## Methods

- **Seeds.** Start from the certificates in `data/results-2026-10-14.json`.
- **SAT with cardinality Σ edges ≥ LB + 1.** Use kissat or CaDiCaL with several
  seeds, plus colour first-occurrence symmetry breaking.
- **Symmetry-imposed SAT.** Require invariance under an automorphism σ:
  - cyclic of order n on Z_n;
  - order n − 1 on Z_{n−1} ∪ {∞};
  - semiregular with 2 or 3 orbits;
  - small groups such as Z_a × Z_b.

  Colours are either permuted by σ (c(σe) = c(e) + 1 mod k) or fixed. Encode
  orbit representatives only.
- **Local search.** Tabu search or annealing on (edge set, colouring), seeded
  from symmetric solutions and from neighbouring n by vertex deletion or
  addition. Note that M(n+1) ≥ M(n) + 1 holds trivially.

## Verification and output

- Re-verify every certificate with a separate, deliberately simple 4-cycle
  checker.
- In `REPORT.md`, give a table of n against the old bound, the new bound and the
  method.
- Put certificates for every n you improve or newly establish in `certs.json`.
- Record structure seen in the best examples: degree sequences, automorphisms,
  bipartiteness.
