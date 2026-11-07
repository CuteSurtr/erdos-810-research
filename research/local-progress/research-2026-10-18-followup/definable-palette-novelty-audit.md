# Novelty audit for the finite-cover palette extension

18 October 2026. This is a targeted primary-source comparison, not a priority certificate. The mathematical statement and proof are in [finite-cover-palette-descent.md](finite-cover-palette-descent.md); the independent proof audit is [here](definable-palette-independent-audit.md).

## Exact claim being compared

For the quadratic common-potential incidence system

```math
(a,h)\longmapsto (h/a^2-a,\ h/a),
```

the palette may be any set defined by one fixed ring-language formula, with boundedly many parameters whose values can vary with the prime. The support $H$ is arbitrary. If the retained incidences form a simple proper edge coloring with every four-cycle rainbow, then a full fixed-formula palette gives $m=O(p^{63/32})$. The robust statement permits missing palette colors and missing incidences, with the deletion term recorded in the proof. This is a restricted construction theorem, not a bound for arbitrary graphs in Erdős #810.

The additional geometric step is simultaneous compatibility of three copies of a finite color cover with three unrelated potential covers. The proof descends a geometrically Galois witness cover, separates its maximal Kummer quotient, explicitly resolves the three Kummer coordinates, and uses the nonconstant restrictions on every nonzero color fibre to preserve all remaining inertia groups. That step extends the earlier coset argument to all fixed-formula palettes.

## Tao's expansion and regularity theorems

[Tao, *Expanding polynomials over finite fields of large characteristic, and a regularity lemma for definable sets*](https://arxiv.org/html/1211.2894) supplies the main machinery. Theorem 25 supplies finite witnesses; Theorem 38 uses the four-output grid map; Theorem 40 gives strong expansion under a separate-cover irreducibility condition. Both expansion theorems are stated for a regular map from a product. Remark 39 explicitly extends an **upper** incidence bound to finite-fibre ternary relations.

Our inference from the statements and proofs is that they do not literally give the required lower count with a coupled root condition and three additional color-cover conditions. The restricted-grid proof adapts their argument, and the six-cover geometry verifies the extra positivity. The regularity method, the $1/16$ discrepancy exponent, and the finite-witness technique are inherited. No novelty should be claimed for them. It remains possible that this application is known without being separately stated in the sources inspected.

## The 2026 arithmetic regularity result

[Pillay and Atticus Pascale Stonestrom, *An arithmetic algebraic regularity lemma*, arXiv:2412.11206v2, 5 February 2026](https://arxiv.org/html/2412.11206v2) is particularly relevant. Theorems 1.1/5.2 make a bounded-definable subset of a finite definable group quasirandom on cosets of a bounded-index normal subgroup. Corollaries 1.2/5.3 give the corresponding Fourier estimate. For the multiplicative group, this controls a definable palette on bounded-index multiplicative cosets.

Their stated relation is $xy^{-1}\in D$. Our configuration instead couples $a,ar,aqr$ with $u,qu,qru$, where $r=(q+1)/(q^2+1)$ and $u=a^3/F(q)$. Pairwise Cayley quasirandomness alone does not supply the needed lower count under the arbitrary three support tests. Thus the published statements do not directly subsume the theorem proved here. A different deduction from their stronger structural analysis has not been ruled out. Their result should be cited as related established machinery, not treated as absent from the literature.

## Descent and earlier coloring comparisons

The field-crossing step is standard. [Dèbes and Legrand, *Twisted covers and specializations*, §3.1, Lemma 3.1 and the regular twisted cover following it](https://arxiv.org/pdf/1106.6154), provides a primary reference. The explicit fixed-field calculation in the present proof records the needed domination of the original witness curve and does not claim a new descent principle.

The earlier full-paper comparison with the 2026 perfect-colorings paper remains applicable: replacing a coset palette by a definable palette does not create the perfect-matching, completion, or closure hypotheses missing from the quadratic partial-matching model. This audit does not repeat that comparison or expand its conclusion into a general priority claim.

Targeted searches for the actual combination of quadratic affine colors, definable or finite-cover palettes, and rainbow four-cycle restrictions did not locate an earlier statement of this consequence. Search absence is weak evidence, and naming differences or an uninspected general theorem may conceal an equivalent result.

## Appropriate assessment

The extension has a complete written proof and an independent mathematical audit, and it materially broadens the coset hypothesis. The defensible description is **an apparently new specialized application and geometric verification using established regularity and covering methods**. The inspected primary theorems do not directly state it. Broader novelty remains unverified; neither a first-ever claim, a new general expansion principle, nor an advance for unrestricted #810 is justified.

For a technical note, the most useful content is the explicit six-cover disjointness argument and the fixed-formula scope, with all inherited analytic input credited. Any further novelty investigation should target general algebraic correspondence expansion theorems and uniform counting for finite-cover predicates, rather than repeat searches for the numerical exponent or the exact phrase “common potential.”
