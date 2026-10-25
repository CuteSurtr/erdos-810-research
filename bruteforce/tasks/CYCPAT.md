# Task CYCPAT: structure of the n/4 cyclic solutions, and explicit constructions

Results folder: `bruteforce/results/CYCPAT/`. Wrap up by the deadline in your prompt.

## Background

Read `tasks/CYC.md` for the cyclic orbit family:
- vertices are Z_n, and each orbit d ∈ D contributes the edges {i, i+d};
- edge {i, i+d} has colour i + g(d), so |E| = n|D|.

CONSTR proved the family optimum k_max(n) = n/4 for n = 28, 32 and 36, and found k = 10 = n/4 at n = 40. If some explicit rule gives |D| = n/4 (or any εn) for infinitely many n, then M(n) ≥ εn² on those n. That would be strong evidence toward, or a construction for, a positive answer to Erdős #810.

The known (D, g) are in `results/CONSTR/trend.tsv` (the `detail` column) and `results/CONSTR/certs*.json`:

| n | (d, g) pairs |
|---|---|
| 28 | (3,5) (4,24) (5,18) (6,10) (9,21) (11,14) (12,23) |
| 32 | (2,28) (3,18) (5,4) (9,20) (12,22) (13,0) (14,21) (15,12) |
| 36 | (2,31) (3,7) (6,5) (7,21) (8,11) (11,20) (13,2) (14,8) (15,34) |
| 40 | (2,0) (3,2) (6,11) (7,26) (8,18) (10,7) (13,14) (15,21) (16,25) (18,30) |

## Steps

1. **Checker.** Write a fast, simple checker for a single (n, D, g). It enumerates the 4-cycles through 0 as in `CYC.md` and checks every colour pair. Also build the explicit graph and check it with an independent 4-cycle enumeration for n ≤ 60.

2. **Enumerate optimal solutions.** For n ∈ {12, 16, 20, 24, 28, 32, 36} (and nearby n), use SAT with blocking clauses to list all optimal (D, g), up to the symmetry group:
   - multipliers d ↦ ±ud with g transformed as in `CYC.md`;
   - colour translation.

   Report the number of orbits of solutions.

3. **Look for structure.** Questions to check include:
   - D as a union of cosets of a multiplicative subgroup.
   - D determined mod 4 or mod small numbers.
   - g as an affine or quadratic polynomial in d, or g(d) ≡ c·d^{-1}, or something similar.
   - The set {(d, g(d))} as a Sidon-type set or an arc in Z_n².
   - CRT structure for composite n, for example n = 4m with Z_4 × Z_m.

   Normalise the solutions by the symmetry group first.

4. **Test candidate rules.** Turn each structural guess into an explicit rule (n ↦ D, g) and test it for every n up to at least 400, or as far as the checker allows. The checker is cheap: about n³ cycle checks, in C.
   - Report the |D|/n each rule achieves.
   - **If a rule gives |D| ≥ εn for an infinite arithmetic family of n, re-verify it** at many n with the explicit-graph checker, and write the rule down precisely.
   - Also try to prove it on paper. A rule verified up to large n but not proved is **evidence, not a theorem**.

5. **Literature check.** Do a quick web search for "rainbow C4" or "strong chromatic" with cyclic or Cayley constructions, and record any prior construction.

## Output

`REPORT.md` contains:
- placement;
- solution counts and normal forms per n;
- the structural observations;
- every candidate rule with its success range and |D|/n;
- conclusions, with honest labels.

Also commit `solutions/` as JSON and the code in `src/`.
