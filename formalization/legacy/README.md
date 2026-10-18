# Legacy files

These files are kept for reference and are not part of the Lake build.

- `BruteForce.lean` redeclares its own copies of the basic definitions
  (edge labelings, `cycleGraph`, rainbow copies) and proves finite values
  of its own $M(n)$ by `decide`. Its results transfer to the main library
  only after its definitions are shown to agree with those used there.
- `HypergraphReduction.lean` uses only Lean core and an ad hoc graph
  structure with colorings `V → V → K`, not Mathlib's `SimpleGraph`.

Both were written against Lean `v4.24.0`. Claims in their header comments,
including claims of novelty and of earlier kernel checks, have not been
re-established here; an earlier review found the hypotheses of the
`HypergraphReduction.lean` theorems narrower than its comments suggest.
