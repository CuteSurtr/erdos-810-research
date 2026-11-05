# Source audit: the September–October 2026 incidence preprint

Checked 15 October 2026. This is a source and applicability audit, not a fresh
Lean compilation or a claim of peer review.

## Verdict and exact input

Mark Lewko's [*A Szemerédi–Trotter Theorem in Arbitrary Fields*,
arXiv:2609.27023v3](https://arxiv.org/html/2609.27023v3), revised 7 October 2026,
states in Theorem 1 that distinct points and affine lines over F_p satisfy

```
I(P,L) <= 3(|P||L|)^(2/3) + |P| + |L| + |P||L|/p.
```

There are no additional size or general-position hypotheses. The theorem also
states the same estimate without the last term when `|P||L| <= p^3` over any
field of characteristic p. The main proof and the public Lean statements agree
on these hypotheses. This is a substantially stronger input than the earlier
Stevens–de Zeeuw bound used in our affine-defect calculation.

I independently read the multiplicity and polynomial-construction argument in
Sections 3–4, checking the localization and exceptional-line steps; no gap was
identified. The root agent separately read these sections with the same outcome.
This is a bounded review of a recent preprint, not a certification of every
application in the paper.

## Public formalization and the checks actually performed

The paper links the author's
[szemeredi-trotter-lean repository](https://github.com/mrklwk/szemeredi-trotter-lean).
The exact fetched Git tree was
`844228bc6c042e59373888d1b69f4e215d1c00e4`.

The source files were obtained through the GitHub read connector. A local source
snapshot, including the checked logs, was initially saved at
`/private/tmp/erdos810-lewko-source-audit`.

The inspected files and logs are now preserved in this project's
[reference-source snapshot](reference-sources/lewko-2609.27023v3/PROVENANCE.md).
They are external reference material, separate from our own Lean modules.

The following are **our checks**:

1. Inspected [Solution.lean](https://github.com/mrklwk/szemeredi-trotter-lean/blob/844228bc6c042e59373888d1b69f4e215d1c00e4/Solution.lean).
   Its four public conclusions literally count incident pairs using a filtered
   Cartesian product of finite sets. Lines are Mathlib affine subspaces with
   one-dimensional direction. The exponent is real `((2 : ℝ) / 3)`.
   `prime_field` is over `ZMod p`, with only primality and the affine-line
   condition as geometric hypotheses. Thus this is not an incidence inequality
   hidden in an assumption or an accidental zero exponent.
2. Fetched all 43 Lean files and searched for proof holes, custom axioms, unsafe
   declarations, native evaluation, custom elaborators, and Challenge imports.
   The only proof holes found were four deliberately unproved specification
   statements in `Challenge.lean`. The proof does not import that file. No
   custom axioms or unsafe proof mechanisms were found in this search.
3. Inspected the final theorem wrappers, the prime-field/subcritical bridge,
   and the incidence-count equivalence rather than relying on README wording.
4. Independently computed SHA-256 hashes of all 43 fetched Lean files and
   compared them with `source_sha256` in the archived repeat-run `result.json`.
   **All 43 match.** The local text-transport initially added one final newline;
   that transport-only newline was removed before the comparison and the saved
   local files now have the matching bytes.

The following are **author-hosted verification evidence**, not fresh runs by us:

- [Repeat-run axiom log](https://github.com/mrklwk/szemeredi-trotter-lean/blob/844228bc6c042e59373888d1b69f4e215d1c00e4/verification/linux-eb95d6f/solution-axioms.log):
  all four final theorems list only `propext`, `choice`, and `Quot.sound`.
- [Repeat-run Comparator log](https://github.com/mrklwk/szemeredi-trotter-lean/blob/844228bc6c042e59373888d1b69f4e215d1c00e4/verification/linux-eb95d6f/official-comparator.log):
  it records the Lean/NanoDa/Comparator sequence and con-ron accepting 31,130
  declarations.
- [Repeat-run record](https://github.com/mrklwk/szemeredi-trotter-lean/blob/844228bc6c042e59373888d1b69f4e215d1c00e4/verification/linux-eb95d6f/result.json):
  source commit `eb95d6f0e79c65cf770a7b1e30e0eeaee0cd16f1`, Lean 4.35.0-rc2,
  Mathlib revision `065356127b1dc0016f66b7283ce0ce2c4055aa55`, and successful
  recorded build/axiom/comparator exit codes.

The repository distinguishes these mechanical records from human peer review.
We have not independently rerun its compiler, dependency build, or alternative
kernel checkers. Source scanning alone is not a substitute for those checks.
No external author or repository messages were sent.

## Consequence for the affine-defect route

The following argument is our applicability check, conditional on using the
displayed preprint theorem as an input. Let P be a dual palette of d points,
where `d <= C p` for a fixed C. Write L_k for the number of lines containing at
least k of these points. For k larger than a constant depending only on C,
the theorem and `k L_k <= I(P, lines counted by L_k)` give

```
L_k = O_C(d^2/k^3 + d/k).
```

To see the absorption explicitly, `(1+d/p)L_k <= (1+C)L_k` can be moved to the
left. The remaining inequality is
`(k/2)L_k <= 3(d L_k)^(2/3)+d`; one of its two right-hand terms is at least
half the left-hand side, giving the displayed alternatives.

Suppose the maximum line richness is `L_max=o(d)`. Split lines into dyadic
richness classes. Lines of richness at least a fixed K account for at most

```
O_C(d^2/K + d L_max)
```

pairs of palette points. First choose K sufficiently large, then let d tend to
infinity. A positive fraction of the `binom(d,2)` pairs must then lie on lines
of richness between 2 and K. Hence the sum I_* of incidences with all determined
dual lines is `Omega_C(d^2)`.

In the earlier affine-coloring argument, properness gives `I_* <= 2D+d`, where
D counts omitted colored incidences. The previously established group-table
argument rules out a macroscopic parallel or concurrent pencil under the
near-complete-support assumption. Thus if `d=Theta(p)` and `D=o(p^2)`, it gives
`L_max=o(d)`, contradicting the preceding lower bound.

This supplies the proposed upgrade from the earlier sublinear-power defect
threshold to **all sublinear average defects**, `D/d=o(p)`, subject to the
already audited group-table and dual-incidence reductions. The incidence
theorem is Lewko's recent input. The affine corollary is our deduction in this
project; its originality is not established, and it is not a solution of the
arbitrary-support affine problem or Erdős #810.
