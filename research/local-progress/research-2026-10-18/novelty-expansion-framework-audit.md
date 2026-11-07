# Novelty audit: the expansion framework behind the quadratic coset result

18 October 2026. This is an adversarial assessment of the mathematical contribution, not a certification of historical priority. The search used the primary sources below and their stated hypotheses. No author was contacted, and no claim of an exhaustive literature search is made.

## Assessment

The higher-root counting lemma should be presented as a **technical corollary of established algebraic regularity and expansion methods**, with its proof supplied because its exact restricted formulation is not the literal statement of the cited functional theorem. It is not a new general expansion method, and its exponent is inherited rather than improved.

The potentially new material is narrower: the particular rational configuration, the verification that its root cover survives every separate coordinate cover, and its conversion into a forbidden colored four-cycle for a fixed-index quadratic palette. I did not locate a primary source already stating that exact graph application. That negative search result does not establish novelty or publishability.

On the present evidence, describing this as a possible new application or a candidate short technical note is defensible. Describing the analytic lemma as a major new theorem, or the application as a general advance on the unrestricted Erdős problem, is not. Its value would need to come from the relevance of the structured family or from a broader useful criterion, not from the established regularity argument itself.

## The exact result being compared

For

```math
K(x,y)=\frac{xy(x+y)}{x^2+y^2},\qquad
G(x,y)=-\frac{(x^2+xy+y^2)(x^2+y^2)}{xy(x+y)},
```

the audited lemma supplies, for fixed $m$ and nonzero $t$, a lower count of pairs in arbitrary $X\times Y$ with $K(x,y)\in Z$ and $G(x,y)/t^3$ an $m$th power:

```math
T(X,Y,Z)\ge c_m\frac{|X||Y||Z|}{p}
-C_m p^{15/16}\sqrt{|X||Y|}.
```

The intended palette application takes $m=3\ell$, where $\ell$ is fixed, and restricts the three potentials to one coset of $(\mathbb F_p^*)^\ell$. This forces the repeated color and both cross-colors into the specified palette coset. It yields

```math
m_{\mathrm{graph}}\ll_\ell
p^{63/32}+p^{4/3}(R+pD)^{1/3}.
```

The supersaturation constant is a positive lower constant, not an asserted exact product-density asymptotic. The constants are not made numerically explicit in these notes and depend on fixed $\ell$; no uniform result for a growing index has been proved.

## Closest primary sources and what they actually imply

### Tao: the direct framework

[Terence Tao, *Expanding polynomials over finite fields of large characteristic, and a regularity lemma for definable sets*](https://arxiv.org/html/1211.2894), published in *Contributions to Discrete Mathematics* 10(1) (2015), 22–98, DOI [10.55016/ojs/cdm.v10i1.62182](https://doi.org/10.55016/ojs/cdm.v10i1.62182).

The [published PDF](https://cdm.ucalgary.ca/article/download/62182/46756/177899) places Theorem 38 and its proof on printed pages 61–64, Remark 39 on pages 64–65, and Theorem 40 and its proof on pages 65–67. These page numbers differ from some preprint versions. Theorem 40 gives a strong-expansion alternative for a regular map from a product of varieties, with obstructions involving four-output dominance and separate coordinate covers. Remark 39 explicitly describes a bounded finite-correspondence **upper** counting bound; it does not state our restricted lower bound. Lemma 23 and Corollary 37 already apply to bounded-complexity definable predicates.

Our root restriction is such a predicate. The finite-fibre expansion and two Cauchy--Schwarz steps therefore follow an existing route. The additional positivity check uses the same cover-and-Lang--Weil mechanism as the proof of Theorem 40. Retaining the constants gives the displayed lower count, but produces no better exponent. This is strong evidence against treating the analytic extension as an independent methodological contribution.

It is nevertheless not a literal substitution into Theorem 40: restricting the admissible preimages changes the source from a Cartesian product, so the written adaptation is necessary.

### Pillay--Starchenko: the regularity theorem is already more general in characteristic

[Anand Pillay and Sergei Starchenko, *Remarks on Tao's algebraic regularity lemma*](https://arxiv.org/pdf/1310.7538), Corollary 1.3.

This gives definable partitions for finite fields of sufficiently large cardinality, without Tao's original large-characteristic restriction. Its discrepancy remains of order $q^{-1/4}$ times the product-cell size. Consequently it does not improve the numerical loss in our proof. It also does not remove our separate geometric obstruction: the characteristic-zero cover argument is still needed for positivity. Citing the all-characteristic regularity theorem would not by itself extend our graph statement to arbitrary finite fields.

### Chevalier--Levi: finite-cover predicates are established machinery

[Alexis Chevalier and Elad Levi, *An Algebraic Hypergraph Regularity Lemma*](https://arxiv.org/pdf/2204.01158), Sections 2.2, 3.3 and Theorems 5.2.5 and 5.3.3.

The paper treats finite-cover images through Galois formulas and relates regularity to algebraic properties of systems of varieties. It is therefore further evidence that a fixed Kummer existence predicate is not a new kind of analytic object. Its higher-arity statements do not automatically give our three-coordinate sparse lower count: one must still verify the required geometric structure and positivity. The remark after Theorem 5.2.5 explicitly notes that its graph-case edge-uniformity bound is weaker than Tao's original one. I found no direct stronger exponent for the present application in these statements.

### Pillay--Stonestrom: a group predicate, not the present coupled configuration

[Anand Pillay and Atticus Pascale Stonestrom, *An arithmetic algebraic regularity lemma*](https://arxiv.org/html/2412.11206v2), Theorem 1.1 and Corollary 1.2, version of 5 February 2026.

The theorem regularizes graphs whose edge predicate is $xy^{-1}\in D$ in a definable group, with $D$ of bounded definable complexity. Its stated $q^{-1/2}$ quasirandomness concerns a fourth-moment notion; the displayed Fourier consequence has exponent $1/8$. Our configuration simultaneously tests an arbitrary potential set at three coupled rational outputs and imposes the root condition. No reduction to one Cayley predicate preserving those arbitrary tests has been supplied. Thus its numerical exponent cannot simply replace the one in our proof.

### Hong--Lim: stronger asymptotics for a different pattern

[Guo-Dong Hong and Zi Li Lim, *Three Term Rational Function Progressions in Finite Fields*](https://academic.oup.com/imrn/article/2025/10/rnaf118/8129181), *IMRN* 2025, rnaf118, Theorem 1.1; [primary preprint](https://arxiv.org/abs/2401.01137).

The theorem concerns additive patterns $x,x+F(y),x+G(y)$ with $1,F,G$ linearly independent, and gives an error with exponent $1/10$ and three $L^2$ norms. Our homogeneous reciprocal-conic configuration is not of this stated form. Taking discrete logarithms converts dilations to translations but does not turn the relevant rational maps into bounded-degree rational functions over $\mathbb F_p$. No valid separate change of variables preserving arbitrary input sets and the root predicate has been established. The theorem therefore does not currently subsume our result.

### Arala--Chow: image expansion does not guarantee the prescribed fibre

[Nuno Arala and Sam Chow, *Expansion properties of polynomials over finite fields*](https://wrap.warwick.ac.uk/id/eprint/193514/1/1-s2.0-S1071579725001170-main.pdf), *Finite Fields and Their Applications* 108 (2025), 102687, Theorems 1.2 and 1.7.

These theorems give strong image-size estimates for specified polynomial families, including suitable ternary quadratics. The reciprocal equation for our map is

```math
u^2+v^2=w(u+v).
```

An assertion that the polynomial $u^2+v^2-w(u+v)$ misses only a bounded number of values does not ensure that zero is attained on the required Cartesian product. It also supplies no simultaneous Kummer constraint. Consequently this attractive newer estimate is not a verified replacement for the present counting argument.

### Weighted polynomial averages: an additional scope check

[Guo-Dong Hong, *On weighted multilinear polynomial averages in finite fields*](https://arxiv.org/html/2507.14414v1), Theorem 1.2.

This controls additive polynomial-shift averages with a one-variable weight satisfying a specified strong uniformity condition. The rational applications remain of additive-shift type. Our arbitrary potential set is not assumed to satisfy that uniformity condition, and the root restriction is coupled to the two input coordinates. The theorem is relevant background, but its hypotheses do not give an immediate shortcut here.

### Arala--Chow 2026: a new incidence bound does not supply this restricted fibre

[Nuno Arala and Sam Chow, *Incidence geometry and polynomial expansion over finite fields*](https://doi.org/10.1017/prm.2026.10130), published online 23 February 2026, Theorems 1.3 and 1.4.

Theorem 1.3 counts incidences with curves $F(a,x)+b+y=0$ for non-diagonal symmetric $F$, with error $O(q^{5/6}\sqrt{|\mathcal P||\mathcal Q|})$. Theorem 1.4 gives an image-complement estimate $O(q^{11/3}/(|X||Y||Z|))$ for its stated polynomial-composition class. The reciprocal polynomial does fit that class: use $F(x,t)=-xt$, $G(y,z)=z$, $H(y,z)=y^2-yz$, and $J(x)=x^2$. However, even for linear-sized sets, the image theorem permits the prescribed value zero to be missing. The direct point/curve encoding has sizes of order $p$ and $p^2$, for which the incidence error $p^{7/3}$ exceeds the main term $p^2$. Neither statement imposes the additional Kummer predicate. Thus this newly checked source is not a verified subsumption or improvement of our result.

## What the written extension actually contributes

The extension does contain necessary verification. In particular, a root restriction can remove most preimages of an output cell, so a pigeonhole argument from the unrestricted case would be invalid. The proof instead excludes zero-density cells by the geometric cover hypothesis. It also handles existence indicators separately from root multiplicities and checks constants uniform in the palette-coset representative.

These are correctness obligations in applying the existing method. I would classify them as technical implementation rather than a new analytic idea. Likewise, replacing the cube by a fixed $3\ell$th root uses the same valuation-one Eisenstein argument. The extension to every fixed index is useful scope, but not an independent irreducibility principle.

The application-specific geometric work has three separate parts:

1. The four-output grid map must be dominant. Here this is checked by an explicit nonzero Jacobian, not by nonlinearity alone.
2. The base equation $z=K(x,y)$ must remain integral after arbitrary separate covers of $x,y,z$. Generic conic-fibre integrality is only the start. The recorded proof finds, at every target value including zero and infinity, a multiplicity-one fibre component on which both input coordinates vary. Separate input covers are unramified there; an inertia-generation argument then excludes a common subextension with a target cover. This verifies the base-cover obstruction in Tao's theorem.
3. Over the resulting combined field, the divisor $y=\omega x$, where $\omega$ is a primitive cube root of unity, has valuation one for $G$. All three coordinate maps vary along it, so the separate covers remain unramified there. Eisenstein therefore proves irreducibility of the additional fixed-degree equation $b^m=G/t^3$.

Thus valuation one is **not the only technical ingredient beyond citing Tao**. It is the only additional Kummer step once the grid and base-cover checks have already been established. These checks use standard algebraic tools, but they are essential, specific computations; neither generic-fibre integrality alone nor a claim of nonlinearity supplies them. They are the part of the argument to foreground if this is written as an application.

## Publication and priority assessment

| Proposed claim | Assessment supported by this audit |
|---|---|
| A new algebraic regularity or expansion framework | Not supported; the framework and loss are inherited. |
| A useful explicit corollary with a root-restricted source | Supported mathematically, assuming the recorded geometric audit. |
| A new structured rainbow-four-cycle application | Plausible candidate; no exact prior statement located in this search. |
| A publishable standalone result | Not established by a source search or by correctness alone. |
| Progress settling unrestricted Erdős #810 | Not supported; the palette and support hypotheses are substantial. |

A proportionate description is: an application of algebraic expansion to a structured quadratic palette, with a written root-restricted counting corollary and explicit geometric verification. The manuscript should identify the inherited argument at the start, rather than frame the proof adaptation as a new general theorem. The cubic correspondence should not be used to inflate the contribution, because its intended extremal application is dominated by the properness-only bound already recorded.

## Proof status versus publication readiness

The counting and graph arguments now have complete written proofs, and this audit has not identified an outstanding mathematical gap. The appropriate internal status is **proved in the accompanying hand-checked argument**, rather than merely conditional on an unproved lemma. The proof is an adaptation of published methods, so it must be included; citing Theorem 40 alone would leave a genuine justification gap.

This status does not mean formal verification, independent external expert validation, or established historical priority. In particular, multiple internal checks do not replace review by a specialist in algebraic expansion and covering-space arguments. Before a public claim of a new publishable result, that review should concentrate on the all-separate-covers field argument, the restricted-cell positivity argument, and uniformity in the fixed-index coset parameter. External review is a validation step, not an additional hypothesis of the theorem. On the present evidence, correctness is substantially better supported than novelty or publication significance.

## Search limitations

I checked the exact statements above, searched the reciprocal equation and rational map in several algebraic forms, and examined later regularity and rational-progression results. No exact source for the graph application or a strictly stronger applicable root-restricted estimate was found. This does not rule out an unindexed paper, an unpublished observation, a differently parametrized result, or a simpler deduction not located during this audit. An originality claim would need a broader specialist comparison; the present evidence supports only the narrower assessment above.
