# Quadratic common-potential colorings: follow-up research

18 October 2026. This report records the follow-up to the quadratic-coset technical note. The new results below concern restricted finite-field constructions. They do not solve Erdős problem #810, establish a new unrestricted extremal bound, or settle historical novelty. The proofs are written mathematical arguments with independent audits, not Lean certificates.

## Public note and full-paper comparison

The full-paper comparison was added to the [standalone technical note](https://github.com/CuteSurtr/erdos-810-research/blob/main/quadratic-coset-palettes.md#comparison-with-perfect-colorings) and pushed to `main` in [commit faea2d0](https://github.com/CuteSurtr/erdos-810-research/commit/faea2d0a7e3666821d09a3c0210324645707286d). The exact committed page was checked on GitHub: all 247 mathematical expressions rendered, with no detected rendering errors or horizontal overflow. The separate formalization branch was left unchanged.

The comparison uses the full text of Gyárfás–Sárközy–Wagner, [*Perfect proper edge colorings of regular bipartite graphs with rainbow C4-s*, Discrete Mathematics 349 (2026), 115005](https://doi.org/10.1016/j.disc.2026.115005). Its Theorems 2.3 and 2.7 impose perfect-coloring and path-closing hypotheses that the common-potential partial matchings do not automatically satisfy. In particular, the required continuation need not belong to the actual support. The paper therefore does not directly subsume the coset theorem. This does not establish priority against the wider literature. The regularity and expansion machinery in the coset proof remains inherited from Tao.

The new follow-up proofs linked below remain local research notes. They have not been silently added to the public technical note.

## Strongest broadening of the quadratic theorem

Let $p$ be a large prime. A palette $A\subseteq\mathbb F_p^\times$ and a common potential support $H\subseteq\mathbb F_p$ prescribe the colored incidences

```math
(a,h)\longmapsto (h/a^2-a,\ h/a),\qquad (a,h)\in A\times H.
```

The retained incidences must define a simple proper edge coloring in which every four-cycle is rainbow. The graph has $2p$ vertices. A completed family means that every prescribed incidence is retained; it does not mean completing each color to a perfect matching on all vertices.

The previous bounded-index coset hypothesis can be replaced as follows:

> If **either** the palette **or** the nonzero potential support is specified by one fixed formula in the language of fields, then a completed family has $m=O_\varphi(p^{63/32})$. The other set is completely arbitrary.

“Fixed formula” allows its bounded tuple of field parameters to vary with $p$. It allows fixed-degree polynomial images, fixed-exponent residue conditions, and fixed finite Boolean combinations and quantifiers. It excludes a formula, interpolation degree, or parameter list growing with $p$. This qualification is essential.

There are robust versions. A dense fixed-formula core may lose $d$ colors or potential values, and $R$ eligible incidences may be omitted. In the respective one-sided settings,

```math
m\ll_{\varphi,\delta}p^{63/32}
   +p^{4/3}(R+pd)^{1/3}.
```

Here the core has size at least $\delta p$, with fixed $\delta>0$. The palette-core theorem counts omissions in $(A\cap A_0)\times H$; the support-core theorem counts omissions in $A\times(H\cap H_0)$. Each permits arbitrary extra elements on the controlled side. Thus $d=o(p)$ and $R=o(p^2)$ imply $m=o(p^2)$ in these models.

The new work is the finite-cover compatibility argument: descend a geometrically Galois cover inside a definable set, separate its power-map quotient, choose the necessary roots explicitly, and preserve the remaining inertia under the other five coordinate covers. The symmetric argument uses inverse colors and the same rational map. Neither argument treats both sets as arbitrary.

- [Complete palette proof](finite-cover-palette-descent.md), with [independent audit](definable-palette-independent-audit.md).
- [Complete support proof](definable-potential-supports.md), with [independent audit](definable-potential-supports-independent-audit.md).
- [Scoped primary-literature comparison](definable-palette-novelty-audit.md).

## A complementary extension allowing growing complexity

An elementary Fourier argument gives a different class of results, constraining both sets but allowing their multiplicative complexity to grow with $p$.

If $A$ and $H$ are arbitrary unions of cosets of a common subgroup of index $\ell\mid p-1$, and $R$ incidences are omitted, then

```math
m\ll \ell p^{5/3}+p^{4/3}R^{1/3}.
```

Thus $\ell=o(p^{1/3})$ and $R=o(p^2)$ imply vanishing edge density. If instead both sets are intersections of multiplicative-character arc conditions, with a fixed total of $d$ conditions, then

```math
m\ll_d p^{11/6}(\log p)^d+p^{4/3}R^{1/3}.
```

The characters may have arbitrarily growing orders. These are complementary to the fixed-formula theorem: their hypotheses constrain both sets, and they are not obtained by pretending a growing character order has fixed algebraic complexity. The proof uses the classical character-sum Weil bound and an exact six-coordinate Fourier reduction. No new character-sum theorem is claimed.

See [the complete quantitative argument](growing-index-wiener-palettes.md) and [independent audit](growing-index-wiener-independent-audit.md). Its general criterion is that the six-slot kernel have Fourier $\ell^1$ norm $o(\sqrt p)$; positive-density examples with few omissions would require the opposite inequality.

## Random sets and the role of the four-cycle hypothesis

For a Bernoulli palette of any fixed density, with probability tending to one, the quadratic power saving $m=O(p^{63/32})$ holds **simultaneously for every support**. Fixed positive palette-density constants are allowed in the bound. A robust version permits $o(p)$ missing core colors and $o(p^2)$ omitted incidences. This uses a six-uniform container argument and the existing rational expansion theorem. See [proof](coset-quantitative.md) and [independent audit](random-palette-independent-audit.md).

For a random support, a stronger $O(p^{15/8}\log p)$ bound holds uniformly over palettes, but already follows from the prohibition on assigning two colors to the same edge. It is not an additional rainbow-four-cycle advance. See [proof](random-support-simplicity.md) and [independent audit](random-support-independent-audit.md).

The container method is standard. These statements supply probabilistic consequences of the explicit configuration hypergraphs; historical novelty is not asserted.

## What the path-closure investigation actually established

A nonlinear base permutation can make many ambient closing equations solvable. For $p\equiv3\pmod4$,

```math
h(r)=-\chi(r)r^2/4,
```

with $h(0)=0$, is a permutation and admits linearly many good colors at each nonzero center in the completed incidence system. This rules out an attempted universal obstruction based only on changing the base to a nonlinear permutation. The ambient quadratic system is improper, and the closing edges may be absent from a partial graph: this is not a dense B-coloring construction. See [construction](nonlinear-base-closure.md) and [audit](nonlinear-base-independent-audit.md).

There is also a converse with actual missing edges. Suppose a simple graph contains a complete base matching $h$ and partial quadratic color matchings. Let $k_x$ count chosen retained central colors, $D_x$ missing continuations, and $Q_x$ retained simple paths lacking an actual closing edge. If, at more than $4\eta^{-2}\delta^{-3}$ centers,

```math
k_x\ge\delta p,\qquad
D_x+Q_x\le(1/2-\eta)k_x^2,
```

where $\delta p\ge3/\eta$, then the base agrees with $-r^2/4$ on more than $\eta\delta^{3/2}p/2$ values. The proof converts pointwise closure into a global bound using an injective point-line encoding and a quadratic-character matrix estimate.

An aggregate form shows the support obstruction explicitly: if there are a positive multiple of $p^3$ central color pairs, the base has only $o(p)$ quadratic agreements, all retained paths close, and only $o(p^2)$ eligible incidences were omitted, then at least $(1/2-o(1))$ of those pairs have their continuation potential **outside** the common support. This does not prove that such support loss is impossible.

See [actual partial-graph theorem](partial-path-closure-structure.md), [independent audit](partial-closure-independent-audit.md), and the [underlying energy theorem](path-closure-structure.md). The complete base matching and the numerical continuation/closure hypotheses must remain explicit. The [next-step obstruction](quadratic-agreement-support-limits.md) explains why quadratic agreement itself gives no density contradiction: tangent overlaps cost only $O(p)$ incidences, and for $p\equiv3\pmod4$ the agreement set automatically avoids the repeated-base four-cycle internally.

## A decisive limitation of ordinary Fourier cancellation

The six logarithmic coordinates have two universal relations. On the uniform torus, their repeated-set count is positive by Jensen's inequality. However, an explicit nonnegative bounded parameter weight has all nonconstant Fourier coefficients $n^{-1+o(1)}$ and still makes that repeated-set count exactly zero for two sets of density $1/8+o(1)$.

The example can also be restricted to cube and noncube classes, giving positive-density repeated sets compatible with a simple proper quadratic incidence graph. Thus simplicity does not repair a proof based only on small linear Fourier coefficients. The weight is **not** the measure on our actual rational curve; it is a counterexample to a proposed inference, not to the graph theorem or #810.

The necessary additional information concerns the actual shared parameter curve, potentially including quadratic products of discrete logarithms. The inspected recurrence and character-sum papers do not supply the required uniform six-slot positivity. See [complete obstruction and literature check](six-slot-quadratic-obstruction.md) and [independent audit](six-slot-obstruction-independent-audit.md).

For the explicit quadratic-log arc candidate, a further [audited reduction](quadratic-log-correlation-target.md) identifies a concrete necessary failure of cancellation: some fixed nonzero integer combination of the two quadratic obstruction phases must have macroscopic correlation along the actual curve, possibly twisted by order-three characters. All other fixed Fourier modes can be eliminated by a Gauss sum or a bounded-degree rational equation. No cancellation estimate for the remaining phases was proved, and no reduction of arbitrary dense sets to this candidate is claimed.

## A separate structural comparison: cubic perturbations

For the perturbed lines $y=ax+a^2+ta^3$, $t\ne0$, keeping the same common potential $h=ay$, a bounded-index palette-coset core satisfies

```math
m\ll_L p^{7/4}+p\sqrt{R+pd}.
```

This needs only single-valued colors on graph edges. The collision quartic has explicit $S_4$ monodromy; adding the coset roots gives the corresponding wreath group. Pairwise independence of its row covers and classical Chebotarev give the bound. An either-side fixed-formula version, with the other set arbitrary, has exponent $15/8$.

There is a simpler complementary bound with an arbitrary palette: if the **support** is any union of cosets of index $\ell$, then

```math
m\ll \ell p^{3/2}+p\sqrt R.
```

Thus support index $\ell=o(\sqrt p)$ and $R=o(p^2)$ suffice. The proof uses a nonnegative multiplicative Fourier main term and the $\sqrt p$ operator norm of a shifted character convolution. A low Fourier $\ell^1$ norm of the support also suffices. These results explain a difference between the quadratic construction and its cubic perturbations. They are not improvements to the general rainbow-four-cycle extremal problem.

See [coset spectral proof](cubic-coset-spectral.md) and [audit](cubic-coset-spectral-independent-audit.md); [fixed-formula extension](cubic-definable-palettes.md) and [audit](cubic-perturbation-independent-audit.md); and [Fourier support proof](cubic-wiener-supports.md) and [audit](cubic-wiener-supports-independent-audit.md). The exponent comparisons concern different assumptions and should not be presented as successive unrestricted records.

The attempt to remove both restrictions also exposed an [audited four-slot obstruction](cubic-four-slot-fourier-obstruction.md): a bounded nonnegative artificial parameter weight can have optimal-size $O(n^{-3/2})$ nonconstant Fourier coefficients and still annihilate the repeated-set count. The actual cubic surface has $O(p^{-1})$ linear Fourier coefficients by Jacobi sums. Consequently, even this stronger linear cancellation by itself cannot prove the desired arbitrary-set positivity. The artificial weight is not the actual surface measure and is not a graph counterexample; its [independent audit](cubic-four-slot-fourier-independent-audit.md) keeps that distinction explicit.

## Novelty, verification, and the remaining target

The full 2026 perfect-colorings paper does not directly imply the coset result under its stated hypotheses. The newer extensions also survive the mathematical audits linked above. That is evidence for a useful specialized technical note, not a proof that no equivalent result has appeared elsewhere.

The main established inputs are Tao's algebraic regularity and expansion framework, finite-field witness and covering arguments, classical Weil and Chebotarev bounds, and Saxton–Thomason containers. The [novelty comparison](definable-palette-novelty-audit.md) also accounts for Pillay–Pascale Stonestrom's 2026 arithmetic regularity result. None of these general methods is new here. No new computation or formalization is being used as a substitute for an asymptotic proof.

A final [adversarial dependency audit](foundational-chain-adversarial-audit.md) rechecked the separate-cover argument, arithmetic descent, all-cell positivity, and parameter uniformity against their primary sources. It found and corrected one incorrect phrase: the finite witness field is regular over the constant field, not over the base rational-function field. The subsequent proof already used the correct property. No fatal gap was found in the tested chain. The [write-up assessment](scope-and-writeup-assessment.md) recommends a focused note on the fixed-formula extension, with the adapted lower-count lemma included explicitly and the same novelty caveat.

The next concrete target is a lower count for the **actual** six-slot rational curve with both $A$ and $H$ arbitrary dense sets, while respecting its two multiplicative relations and its nondegenerate parameters. The fixed-formula theorem, growing-complexity theorem, and random-set results cover different classes of sets, but do not exhaust arbitrary sets. Alternatively, a support-preserving bridge from the partial graph to the path-closure hypotheses would be needed. The present deficiency theorem quantifies that bridge; it does not supply it.

Even a solution for arbitrary $A,H$ in this common-potential construction would still require a separate reduction to unrestricted Erdős #810. No such reduction was obtained. The earlier 0.298444 constant remains a hand-audited bound with unverified novelty, not an established new record.

The authorized follow-up began at 12:48:53 UTC on 18 October 2026. Research and independent audits concluded at 2026-10-18 13:54:19 UTC, before the 14:48:53 UTC deadline. The public comparison is pushed; the new follow-up proofs remain local. No Lean builds, package installations, finite graph enumerations, author contacts, or additional public research claims were made in this pass.

## Publication follow-up: fixed-formula theorem

At the user's subsequent request, the fixed-formula quadratic theorem received a fresh [proof audit](fixed-formula-publication-proof-audit.md) and [primary-source novelty audit](fixed-formula-publication-novelty-audit.md). No fatal proof gap was found. The public exposition now specifies the dense-core condition for lower counts, the characteristic-zero ultraproduct uniformity argument, dense opens, and the root-recovery formulas completing the unramified towers.

The novelty review additionally examined Chevalier–Levi's algebraic hypergraph regularity framework and the exact discrepancy convention in Pillay–Stonestrom. The inspected theorems do not dispense with the specific finite-cover compatibility verification. This supports a scoped technical note, not a historical-priority claim.

The either-side theorem, both robust omission bounds, full proofs, and literature comparison were added to the [public technical note](https://github.com/CuteSurtr/erdos-810-research/blob/bb67788f1f1fd0d2cbdea6a7ef5282a5de6ca472/quadratic-coset-palettes.md#6-fixed-formula-palettes-and-supports) and pushed to the standalone repository in commit `bb67788f1f1fd0d2cbdea6a7ef5282a5de6ca472`. Only that note and the README were published in this follow-up; the other research extensions remain local. GitHub's exact-commit rendering was checked: 450 formulas in the note and 28 in the README, with no renderer errors; the note had no formula overflow. No assistant attribution, research logs, or audit files were included in the commit. The formalization checkout was left on its existing branch, and no Lean builds or package installs were run.
