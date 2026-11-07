# Task AFFQ: affine model with fixed intercept formulas and arbitrary supports

Results folder: `bruteforce/results/AFFQ/`. Wrap up by **16:30 UTC**.

## Model

Read `README.md`, `common-affine-supports.md` and `quadratic-coset-palettes.md`
on `main` for the conventions. For an odd prime p:

- Rows X = F_p and columns Y = F_p.
- Each slope a ∈ F_p^× gives one colour, the edges {(x, ax + β(a)) : x ∈ D_a}.
- The graph must be simple: no edge is produced by two colours.
- Every 4-cycle must be rainbow. Properness is automatic.
- Maximise m = Σ |D_a|.

The graph has 2p vertices and p − 1 < 2p colours, so the maximum m is a lower
bound for M(2p).

Intercepts to cover: β(a) = a² (the main case in the notes), a³, 1/a, and 0.
The supports D_a are arbitrary.

## Steps

1. **Constraints.** For given p and β, enumerate:
   - the simplicity pairs;
   - every set of 4 incidences that forms a 4-cycle x1–y1–x2–y2 with two
     opposite edges of the same colour, which must not all be present.

   Cross-check by brute force on small p: compare against a direct 4-cycle
   enumeration of the full candidate graph, and against random partial supports.
2. **Exact optimum.** Solve with CP-SAT (ortools) or MaxSAT (RC2, open-wbo) for
   p = 5, 7, 11, 13, 17, 19, 23, 29, 31, …, as far as proven optimality allows.
   Use the multiplicative and affine symmetries that preserve each β family.
3. **Larger p.** Give the best found value up to p ≈ 101, with the solver's
   upper bound or gap.
4. **Trend.**
   - Tabulate m_max/p² against p for each β and fit the decay.
   - Compare with the notes. Common support allows at most about
     p²·exp(−c(log p)^(1/12)). The quadratic common-potential case is
     O(p^(2−1/32)).
   - Describe the optimal supports: sizes, and whether they look like cosets,
     intervals, random sets or AP-free sets.
5. **Verification.** Rebuild each optimal or best configuration as an explicit
   2p-vertex graph and check all its 4-cycles with a separate, simple checker.
   Report the induced bound on M(2p), compared with the README table.

## Output

- `table.tsv` with columns `beta, p, m (best), upper bound, status, m/p²`.
- `configs.json`, with explicit optimal supports for p ≤ 13 and the support-size
  profile for larger p.
