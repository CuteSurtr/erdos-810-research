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
