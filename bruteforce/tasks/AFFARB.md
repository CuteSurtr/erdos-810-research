# Task AFFARB: affine model, optimising the intercept function too

Results folder: `bruteforce/results/AFFARB/`. Wrap up by **16:30 UTC**.

The model is the same as in task AFFQ; read `README.md` and
`common-affine-supports.md` on `main`. This task maximises
m = Σ |D_a| jointly over all intercept functions β: F_p^× → F_p and all
supports. Empty D_a are allowed, so subsets of slopes are covered.

## Steps

1. **Joint model.** Build a SAT or CP-SAT model with β(a) one-hot over F_p and
   incidence variables (a, x). Encode simplicity, and rainbow 4-cycles correctly
   for any β. Cross-check by brute force for p = 3, 5: enumerate all β and
   compare with direct 4-cycle enumeration.
2. **Symmetry.** Affine changes x ↦ ux + v and y ↦ sy + t map affine colour
   classes to affine colour classes.
   - Work out exactly how (a, β(a)) transforms.
   - Fix a canonical form, such as β(1) = 0 plus one more normalisation.
   - Argue soundness in `REPORT.md`.
3. **Exact maxima.** Prove optimality for p = 3, 5, 7, 11, 13, and for 17 or
   beyond if feasible. If a p needs longer, write the solver gap and a sharding
   plan, for example splitting on the β values of the first few slopes.
4. **Larger p.** Report the best found values up to p ≈ 61 by alternating
   optimisation. For fixed β, solve the supports by CP-SAT; then make local
   moves on β. Seed β from low-degree polynomials, random functions and
   Sidon-type or AP-free structures.
5. **Comparison.** Compare optimal β with fixed formulas. Is it structured?
   Fit max m/p² against p. Report the resulting bound on M(2p), compared with the
   README table.
6. **Verification.** Check every claimed configuration as an explicit
   2p-vertex graph with a separate, simple 4-cycle checker.

## Output

- `table.tsv` with columns `p, best m, upper bound, status, m/p²`.
- `configs.json` with β as a list and supports as {a: sorted D_a}.
