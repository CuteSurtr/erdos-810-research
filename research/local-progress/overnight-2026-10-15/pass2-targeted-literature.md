# Pass 2: quadratic affine palettes with arbitrary marked support

Date: 2026-10-15. This is an applicability audit, not a claim of a new theorem or a complete literature review.

## Exact target

Let F have odd order Q. For colors a in F*, the completed map is sigma_a(x)=ax+a^2. Mark a retained edge by (a,b), where x=-(a+b); its column is y=-ab. Thus the retained coloring is a set R of oriented root pairs, with at most one of (a,b),(b,a) when a and b are distinct eligible colors. A non-rainbow rectangle with opposite color a amounts to retained pairs

    (a,b), (a,c), (d,e), (f,g)

such that

    a+b=d+e,   ac=de,
    a+c=f+g,   ab=fg,

with distinct rows and columns and nonzero participating color slopes. The two crossed cells must be retained, not merely algebraically available.

Generically this is a dimension-three correspondence in four two-dimensional slots. Counting all ordinary rectangles in the dense projected edge set, or counting all solutions of the polynomial equations without the R restrictions, does not establish the desired statement. The relevant scale is Q^3.

## Distinct primary-source leads inspected

### Rational Roth: a real theorem, but the wrong test-function geometry

Guo-Dong Hong and Zi Li Lim, *Three term rational function progressions in finite fields*, [arXiv:2401.01137](https://arxiv.org/pdf/2401.01137), Theorems 1.1 and 1.4 (PDF pp. 2–3); published in [IMRN 2025, rnaf118](https://doi.org/10.1093/imrn/rnaf118).

For fixed rational functions F,G over Q with 1,F,G linearly independent, the paper gives a power-saving asymptotic for x,x+F(t),x+G(t) in prime fields. Its test functions occupy three one-dimensional translated slots. Our four pair-correlated membership tests do not have that form. Even the common-domain subcase leads to two coupled rational outputs depending on three colors, rather than this three-term pattern. Applying the theorem requires an additional parametrization or counting argument, which has not been obtained.

### Algebraic regularity: useful framework, no automatic recurrence statement

Terence Tao, *Expanding polynomials over finite fields of large characteristic, and a regularity lemma for definable sets*, [arXiv:1211.2894](https://arxiv.org/pdf/1211.2894), Lemma 5/23, Theorem 35, Theorem 38 and Remark 39. The expansion dichotomy concerns a regular map V x W -> U; its obstruction is an algebraic constraint on the four values on a Cartesian rectangle. The regularity estimates can test arbitrary subsets after decomposing a bounded-complexity definable relation, so “R is arbitrary” alone is not a sufficient reason to dismiss this method. However, the statement does not directly count our sparse four-slot correspondence. The necessary nondegeneracy and positive-density component analysis are still missing. The original paper also assumes large characteristic; its author's [later spectral proof](https://terrytao.wordpress.com/2013/10/29/a-spectral-theory-proof-of-the-algebraic-regularity-lemma/) removes that assumption for the regularity lemma itself.

Alexis Chevalier and Elad Levi, *An Algebraic Hypergraph Regularity Lemma*, [arXiv:2204.01158](https://arxiv.org/pdf/2204.01158), Theorems 5.2.5 and 5.3.3 (PDF pp. 47, 50–51), extends the algebraic regularity framework to definable hypergraphs through systems of varieties and refinements. It does not state that every dense arbitrary subset contains every fixed polynomial configuration. A representation of this particular sparse correspondence, plus a nondegenerate counting step, is still required.

### Removal: a precise missing hypothesis can be isolated

Lluís Vena, *On the removal lemma for linear configurations in finite abelian groups*, [arXiv:1505.02280](https://arxiv.org/pdf/1505.02280), Theorem 1 (PDF pp. 3–4) transfers hypergraph removal to a family of configuration systems that satisfies Definition 10's representability conditions (PDF pp. 9–10). These include uniform control of how copies of a fixed colored hypergraph encode solutions and individual coordinate values. The paper establishes this for homomorphism systems, among other examples. The quadratic system above is not such a homomorphism system, and no suitable representation was found.

A useful exact target would be a uniform removal lemma with four coordinate sets in F^2 for the displayed relation, measured against its Q^3 solution scale and permitting deletion of o(Q^2) pairs from each coordinate set. This would be enough: the diagonal solutions obtained by setting b=c, d=f=a, e=g=b give one solution per retained pair. Eliminating those requires deleting the union of the retained pairs across the four slots. A removal lemma would turn that obstruction into many solutions; an additional degeneracy analysis would then be needed to ensure genuine rectangles. This is an unproved route, not a consequence already licensed by Vena's theorem.

### Sum-product graph spectra do not retain the four supports

The primary paper *Sum and shifted-product subsets*, [EJC 19(2) (2012), P33](https://www.combinatorics.org/ojs/index.php/eljc/article/viewFile/v19i2p33/pdf/), Section 2.1 and Theorem 2.3, studies the incidence graph with adjacency a+c=bd over prime-power residue rings, tracing its finite-field predecessor to Solymosi's *Incidences and the Spectra of Graphs* (2008). Spectral mixing controls edges between vertex subsets in that graph. It is not a theorem for the simultaneous four marked-pair restrictions above. The incidence graph and the coefficient graph of unordered roots are also different objects; calling both a “sum-product graph” must not conceal that distinction.

## Two algebraic checks against premature reductions

1. Translating every root by h preserves each sum equality but changes a product equality ac=de by h(a+c-d-e). For the displayed configuration this introduces h(c-b), so a nondegenerate rectangle is not preserved by arbitrary common root translation. Ordinary translated polynomial-pattern theorems cannot simply be applied to R.

2. There is a special linear subconfiguration: choose a=-(b+c)/2 and take (a,b),(a,c),(-c,-a),(-b,-a). It satisfies the equations. However it requires both a pair and its reflected pair T(r,s)=(-s,-r) to lie in R. An arbitrary positive-density R may avoid T(R), so this does not solve the arbitrary-support case.

## Verdict and next exact question

No inspected primary theorem proves vanishing density for arbitrary retained supports in the quadratic palette. The rational Roth and algebraic regularity sources are genuinely relevant techniques, but citing their titles is not a proof of applicability. The most precise outstanding task is a marked-support counting/removal theorem for the displayed dimension-three correspondence, or a valid reduction of it to an existing theorem with all degeneracies and finite-field hypotheses checked.

The 2026 perfect-B paper remains an uninspected full-text gap. No repeated publisher-access attempts or author contacts were made in this pass. Novelty of a future quadratic-palette result remains unverified.
