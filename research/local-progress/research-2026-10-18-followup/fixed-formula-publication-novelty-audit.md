# Fixed-formula quadratic theorem: primary-source novelty audit

18 October 2026. This audit compares actual theorem hypotheses and proofs; it is not a historical-priority certificate. It supplements [the earlier palette audit](definable-palette-novelty-audit.md) and [the scope assessment](scope-and-writeup-assessment.md). No author was contacted, and nothing was published or built.

## Claim and verdict

The claim audited is the completed quadratic incidence family

```math
(a,h)\longmapsto(h/a^2-a,h/a),
```

with a simple proper coloring and all four-cycles rainbow. If either the palette or nonzero support is an instance of one fixed ring-language formula, the other may be arbitrary, and the written arguments give

```math
m=O_\varphi(p^{63/32}).
```

For a fixed positive-density definable core, the robust bound is

```math
m\ll_{\varphi,\delta}p^{63/32}+p^{4/3}(R+pd)^{1/3},
```

with the respective omission domains specified in [the palette proof](finite-cover-palette-descent.md) and [the support proof](definable-potential-supports.md). Parameter values vary; the formula and parameter count do not.

**Verdict:** the inspected general theorems provide the established machinery, but none supplies this conclusion without verifying the particular finite-cover compatibility and restricted-cell positivity. A focused technical-note extension is worthwhile. The appropriate contribution is an explicit specialized application with geometric verification, not a new regularity framework, a priority claim, or a result for unrestricted Erdős #810. This literature audit does not replace the accompanying proof audits.

## Tao: the exact inherited argument and remaining input

Primary source: [Tao, *Expanding polynomials over finite fields of large characteristic, and a regularity lemma for definable sets*](https://arxiv.org/html/1211.2894), Theorem 25, Corollary 37, Theorems 38/40, Remark 39, and their proofs. In particular, the proof of Theorem 40, equations (31)–(32) onward, turns a zero-density cell into finite witness covers and contradicts irreducibility through Lang–Weil. This already supplies the proof strategy used here.

Theorems 38/40 concern a regular map from a Cartesian product. Remark 39 explicitly extends an **upper** incidence estimate to finite-fibre correspondences. It does not state the restricted lower estimate needed here. Rationality alone is not the distinction: rational maps can be made regular on suitable opens, with exceptional loci accounted for. The distinction is the additional joint admissibility predicate, which removes preimages according to three further coordinate-cover conditions.

Thus an appropriate manuscript claim is “an application of Tao's regularity and expansion argument.” The missing input for direct application is positivity after those extra covers, not a new Cauchy–Schwarz inequality. The $1/16$ discrepancy loss is inherited. Retain the explicit restricted counting lemma and its proof rather than citing Theorem 40 alone.

## Chevalier–Levi: why general hypergraph machinery is not automatic subsumption

Primary source: [Chevalier–Levi, *An Algebraic Hypergraph Regularity Lemma*, v2](https://arxiv.org/pdf/2204.01158), Definition 3.2.1, Proposition 3.2.6 and proof, Theorem 4.1.2 and proof, Theorems 5.2.5/5.3.3; printed pp. 23, 26–27, 31–33, 46, 49–50.

These results already handle finite-cover predicates. Definition 3.2.1 requires dominance over the lower-face fibre product; Proposition 3.2.6 makes compatible base change a substantive hypothesis. Stochastic independence in Theorem 4.1.2 assumes a regular system and proves joint extension/linear disjointness. It does not make arbitrary covers independent.

For three independent line coordinates, $w=K(s,t)$ is a surface, not a dominant finite cover of the three-dimensional product. Treating it merely as a sparse definable hypergraph yields no required lower bound: its entire $O(p^2)$ size is at the small-cell scale allowed in Theorem 5.3.3. Using two independent parameters restores dimension, but the arbitrary-set restrictions become three coupled pullbacks rather than separate vertex tests.

Consequently one still needs the specific geometric verification or another argument achieving its purpose. Refinement can expose compatibility obstructions; it does not prove that every relevant cell has positive density. These statements strengthen the case for crediting established finite-cover machinery, without eliminating the application-specific work.

## Pillay–Pascale Stonestrom: structural scope and exponent normalization

Primary source: [Pillay–Pascale Stonestrom, *An arithmetic algebraic regularity lemma*, v2, 5 February 2026](https://arxiv.org/html/2412.11206v2), Definitions 2.1/2.2, Fact 2.3, Theorems 1.1/5.2 and proof, Corollary 5.3. The bounded-complexity convention expressly permits parameters.

The theorem makes the Cayley predicate $xy^{-1}\in D$ quasirandom on bounded-index subgroup cosets. Its proof upgrades the fourth-moment error to $O(p^{-1/2})$ using the finite set of possible definable densities. The paragraph before Theorem 5.2 says this upgrade also applies to Tao's general graph setting; overlooking that sentence would understate its scope.

Nevertheless, their $p^{-1/2}$ is a four-cycle discrepancy, not the cut discrepancy used in the present argument. Fact 2.3 gives $p^{-1/8}$ for cut discrepancy/Fourier control. It cannot simply replace Tao's $p^{-1/4}$ product error.

For the application one must count simultaneous tests at $a,ar,aqr$ and $u,qu,qru$, with $r=(q+1)/(q^2+1)$ and $u=a^3/F(q)$. No reduction to a single Cayley predicate preserving the arbitrary-set tests has been established. The missing input is a joint lower bound on this rational parameter surface, not merely pairwise mixing on multiplicative cosets.

## What to foreground in the note

The concrete geometric work is the passage from a fixed formula to a witness curve; selection of a regular geometrically Galois cover; isolation of its power-map quotient; construction of designated root coordinates on a suitable coset slice; and preservation of residual inertia after all other covers. The first two operations use standard tools. The particular coordinate identities and nonconstant-fibre checks are the application-specific verification. The support direction requires its own inverse-color coordinates and should not be presented as a formal symmetry.

The cover hypothesis should not be weakened in the prose to “six arbitrary covers are independent.” The six coordinates satisfy multiplicative relations, and resolving their power-map compatibility is essential. The finite-cover proof is also stronger information than an unqualified appeal to “nonlinearity.”

Suggested public wording:

> We apply algebraic regularity and finite-cover methods to quadratic common-potential colorings. An explicit compatibility argument yields a power-saving edge bound when either the palette or the support belongs to a fixed ring-language formula family, while the other set is arbitrary. The analytic framework and exponent are inherited; the contribution is the geometric verification and its colored-graph consequence.

This wording makes a positive mathematical claim without asserting historical priority. “Apparently new” is optional and less useful than stating precisely what is proved. The investigation found no exact subsuming theorem among the primary results above, but neither search failure nor nonliteral theorem wording proves novelty. A different reduction from these methods remains possible. Public inclusion as a carefully scoped technical extension is justified by the written proof and audits; independent publication significance remains a separate judgment.
