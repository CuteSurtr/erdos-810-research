# Scope and write-up assessment

18 October 2026. This is a final scope check of the follow-up report and its main geometric extension. It does not certify historical priority.

## Report audit

The report's quadratic statement is warranted: if either the palette or the nonzero support is an instance of one fixed field-language formula, the other set may be arbitrary, and a completed valid common-potential family has $O_\varphi(p^{63/32})$ edges. Parameters may vary; formula length, degree, quantifier structure, and parameter count remain fixed. The exact-set assertion does not need an externally supplied density constant because finite witness extraction and the finite/infinite definable dichotomy are part of its proof.

The robust statement also has the correct quantifiers. A palette core controls the size of the actual support, so all extra actual colors can be counted using $m\le p|H|$. A support core controls the size of the actual palette, so all extra actual support values can be counted using $m\le p|A|$. Its omission sets must remain respectively $(A\cap A_0)\times H$ and $A\times(H\cap H_0)$, and the dense-core parameter $\delta$ must remain in the constant. Neither statement allows both sets arbitrary without a further hypothesis.

The novelty wording is appropriately limited: the full 2026 perfect-colorings paper does not directly supply the missing completion/closure assumptions; the inspected expansion theorems do not literally state the coupled finite-cover lower count. Neither comparison proves the result is historically new.

## What would make a useful short note

A separate note centered on **fixed-formula palettes and supports in quadratic common-potential colorings** is worthwhile. Its substantive content is the compatibility of the specific coordinate maps with descended finite covers after resolving their power-map quotients. The explicit nonconstant-fiber computations, the designated root functions, and the residual-inertia argument are the material to preserve.

It should not claim a theorem about arbitrary six independent covers without qualifications. The multiplicative relations among the six coordinates impose genuine power-map compatibility conditions, handled by the chosen coset slices and designated roots. That is the point of the proof, not an expendable preliminary.

The analytic input should be stated as an explicit restricted lower-count lemma and proved or reproduced from the current written argument. Citing Tao's strong-expansion Theorem 40 alone would leave a source gap: that theorem concerns its stated product-map hypotheses, whereas the new predicate includes a coupled root condition and additional coordinate-cover conditions. The existing proof adapts the regularity/grid argument and establishes positivity separately. This is a presentation obligation, not a newly discovered flaw in the completed proof.

No additional exact-primary-source gap was identified beyond that need to state the adapted analytic lemma accurately. Finite witnesses, regularity, field crossing, inertia of covers of the punctured line, and Lang–Weil are inherited tools. The broad historical-priority question remains open and should be said plainly. A focused note need not absorb the probabilistic, growing-complexity, and cubic-perturbation results merely because they were obtained in the same research session.

## Remaining arbitrary-set questions

For the quadratic construction, the obstruction to an argument using only small linear Fourier coefficients is proved in the separate six-slot obstruction note. It applies even after imposing the elementary simplicity-compatible residue restriction. It does not give a counterexample on the actual rational parameter curve. The open target is a weighted lower count on that particular curve, accounting for its quadratic logarithmic correlations; ordinary character-sum cancellation is insufficient by itself.

For the cubic perturbation, the exact multiplicative Fourier decomposition is recorded in [cubic-wiener-supports.md](cubic-wiener-supports.md). It yields the one-sided bound

```math
m\ll\min\{p^{7/4}M_H,\ p^{3/2}M_H^2/\beta\}+p\sqrt R,
\qquad \beta=|H|/(p-1).
```

The general case is not settled: $M_H$ can be of order $\sqrt p$, and summing the individually optimal shifted-character operator estimates by absolute values loses too much. Improving cancellation across character pairs is a concrete remaining analytic question. The loss in this proof is not a demonstrated counterexample or a theorem that the arbitrary-set assertion is false. Likewise, full quartic monodromy without control of arbitrary color weights does not fill the gap.

Even resolving either construction for both sets arbitrary would still leave a separate reduction problem before it could establish an unrestricted Erdős #810 result.
