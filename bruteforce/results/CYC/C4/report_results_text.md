**Summary.**
- **n = 42.** k_max(42) = 10: SAT at 10 (CONSTR's model, re-verified), and k = 11 UNSAT by two
  solvers, CaDiCaL and kissat, on the same symmetry-broken CNF. The DRAT proof check timed out,
  so the label is *UNSAT (solver, proof unchecked)*.
- **The other n.** Certificate-verified lower bounds. k_lo improved over CONSTR at 53, 56 and 63
  (12 → 13 each), and 74, 85, 88 and 95 are new. No k above k_lo was decided at these n.
- **k = n/4.** Undecided at both multiples of 4: n = 56 (best 13, k = 14 got 25 min + 2 × 78 min
  with no answer) and n = 88 (best 17, k = 22 got 25 min of `--sat`).
- **k/n.** Observed k/n: 0.238 (42, exact), 0.245, 0.232, 0.206, 0.203, 0.200, 0.193 and 0.189
  (lower bounds).