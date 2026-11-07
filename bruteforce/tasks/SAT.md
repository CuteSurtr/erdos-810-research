# Task SAT: independent SAT line for M(10), M(11), M(12), both directions

Results folder: `bruteforce/results/SAT/`. Wrap up by **16:30 UTC**.

This task cross-checks the graph-enumeration task (M12) by a completely
different method. Do not use its code or `data/first-run/src`.

## 1. Encoding

- Variables: x_uv for each potential edge, and y_{uv,c} for each edge and colour.
- Each present edge gets exactly one colour, or at least one; argue soundness.
- For every 4-cycle (a, b, c, d) and every colour, if all four edges are present
  then no two of them share that colour.
- Cardinality: Σ x ≥ e, via a totalizer or sequential counter.

## 2. Symmetry breaking

It must be sound, and you must argue why in `REPORT.md`. Do not combine vertex
and colour breaking unsoundly. Options:

- colour first-occurrence ordering;
- vertex ordering by degree;
- lex-leader constraints for transpositions;
- SAT Modulo Symmetries (pysms), if installable.

## 3. Validation

Before any claim:

- n = 9: e = 23 is SAT and e = 24 is UNSAT;
- n = 10: e = 30 is SAT;
- n = 11: e = 34 is SAT.

## 4. Upper bounds

Prove UNSAT for n = 10, e = 31, then n = 11, e = 35, then n = 12, e = 41.

- Produce DRAT or LRAT proofs and check them with drat-trim or cake_lpr.
- For hard instances, use cube-and-conquer: march_cu or your own cubes on the
  degree sequence or a max-degree neighbourhood. Prove that the cubes cover the
  whole space, and check a proof per cube.
- Record per-cube times. For anything unfinished, write a sharding plan with the
  cube files committed.

## 5. Lower-bound search

In parallel, look for satisfying instances: n = 12, e = 41 and n = 13, e = 47,
with several solvers and seeds. Verify any certificate with a separate, simple
checker.
