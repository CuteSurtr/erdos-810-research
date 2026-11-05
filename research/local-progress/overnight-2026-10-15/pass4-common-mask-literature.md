# Pass 4: common-domain quadratic palettes — source and novelty audit

Date checked: 2026-10-15. This note distinguishes an applicable classical input from nearby theorems whose hypotheses do not match. It is not a priority certification.

## Exact target

Let p be an odd prime, A⊂Fp* and X⊂Fp. For each a∈A include every edge

    x → ax+a²,  x∈X,

with color a. Write d=|A|, k=|X| and m=dk. Properness is exactly the condition that X avoids −(a+b) for distinct a,b∈A. A non-rainbow C4 is equivalent to a nondegenerate solution

    b²+bx = a²+az,
    c²+cz = a²+ax,
    a,b,c∈A, x,z∈X, x≠z.

Away from Δ=bc−a²=0, the two rows are determined by

    x=(a³+ca²−cb²−ac²)/Δ,
    z=(a³+ba²−ab²−bc²)/Δ.

Thus the common-domain case has five one-variable indicator factors on a rational three-parameter variety. It is substantially narrower than the four arbitrary two-variable supports in Pass 3. Pass 3's negative results for arbitrary supports do not disprove this narrower target.

## Sources on nonlinear recurrence: exact scope

1. **Zi Li Lim, Uniform nonlinear Szemerédi theorem for corners in finite fields, arXiv:2501.04887v1, Theorem 1.1.** [Primary full text](https://arxiv.org/html/2501.04887v1). For rational P,Q with 1,P,Q linearly independent, the theorem counts the three slots (u,v), (u+P(t),v), (u,v+Q(t)), with a directional-average main term and a power-saving error. This is a theorem for three translated two-dimensional slots, not a theorem for every rational variety with three parameters. No support-preserving reduction of the displayed five-factor target to these slots has been established here. Its algebraic-geometric correlation method is relevant methodology, but citing the theorem alone does not close the target.

2. **Guo-Dong Hong, On weighted multilinear polynomial averages in finite fields, arXiv:2507.14414v1, Theorems 1.2–1.3 and Proposition 1.4.** [Primary full text](https://arxiv.org/html/2507.14414v1). The weighted results use a common translated base, fixed directions, linearly independent zero-constant polynomials, and a strongly uniform parameter weight. Proposition 1.4 covers common rational reparametrizations P_i(φ(t)) of that same translated pattern. An arbitrary dense palette indicator is not automatically strongly uniform. The rational functions x(a,b,c),z(a,b,c) above do not arrive in the required translated form. Section 1.3 itself carefully distinguishes this special composed family from general rational patterns. These are useful scope checks, not black-box proofs of our target.

3. **Ji Li, Chun-Yen Shen, Tuyen Trung Truong and Liangchuan Wu, Polynomial corners in finite fields beyond the distinct-degree case, arXiv:2609.13891.** [Primary abstract and links](https://arxiv.org/abs/2609.13891). The September 2026 preprint treats linearly independent polynomial corners, including the equal-degree case. The announced configuration still consists of (u,v), (u+φ₁(t),v), (u,v+φ₂(t)). This is a new nearby source, but the slot mismatch remains. The abstract was checked for scope; this audit does not certify its full proof or use it as an input.

There is no legitimate inference here from “rational functions,” “three parameters,” or “positive density” alone to an applicable recurrence theorem. Conversely, these mismatches do not establish that no suitable theorem exists elsewhere.

## The one-sided star-coloring reformulation

Transpose the incidence table: take the complete bipartite graph on X and A, and give edge (x,a) the symbol ax+a² as its new color. It is properly colored. An original repeated-color C4 with rows x,z, repeated color a and other colors b,c becomes the alternating two-color walk

    b — x — a — z — c.

If b=c this is a two-color C4; otherwise it is a four-edge path with both endpoints in A. The converse follows by reversing this construction. Thus the condition forbids two-color C4s and two-color four-edge paths with endpoints in A. It does not forbid the opposite orientation of four-edge paths in general.

**Casselgren–Granholm–Raspaud, On star edge colorings of bipartite and subcubic graphs, arXiv:1912.02467v2, introduction and §2.** [Primary PDF](https://arxiv.org/pdf/1912.02467). A star edge coloring forbids both orientations. The introduction, printed pp.1–2, identifies linear versus superlinear star chromatic index for complete bipartite graphs as a fundamental unresolved question at that time. Their complete-bipartite bounds do not give the superlinear lower bound that a generic density-vanishing argument would need. This is a historical statement about the inspected source, not an assertion that an exhaustive 2026 literature review settles its current status. In particular, the stronger full-star definition must not be silently substituted for our one-sided condition.

**Josef Cibulka, Maximum size of reverse-free sets of permutations, arXiv:1208.2847v3, Theorem 1.1.** [Primary PDF](https://arxiv.org/pdf/1208.2847). Reverse-free words avoid two distinct letters in two positions in reversed order. This detects the two-word/two-color C4 condition, not the additional three-column four-edge path. The theorem allows exponentially large families when word length and alphabet size are comparable. It supplies no contradiction for a merely linear-sized family here. No exact one-sided-star theorem applicable to the quadratic table was identified in this targeted pass.

## A useful elementary slice, and why it is insufficient

The substitution b=a+t, c=a−t, x=−t, z=t satisfies both equations for every a,t. Therefore a three-term progression in A whose nonzero difference lies in X∩(−X) gives the desired violation.

Roth's theorem alone does not force that difference restriction. For example, for large p, take A in the residue interval [p/20,p/10] and X in [2p/5,3p/5]. Both sets have fixed positive density, X is symmetric up to endpoints, and X avoids both ±(A−A) and −(A restricted-sum A). Thus this particular progression slice is unavailable even under properness. This example is not a counterexample to the full five-variable target.

## The new crossed-reflection argument: verified external input

During Pass 4 the team derived a different route, using

    τ_a(x,y) = (y/a−a, ax+a²),
    S_A f = Σ_{a∈A} f∘τ_a.

Each τ_a is an involution. Its linear part preserves the split quadratic form Q(x,y)=xy, and its fixed line is y=ax+a². Thus it is the Q-reflection across that line; the lines are tangent to y=−x²/4. This interpretation is an elementary calculation, not a claim that the reflection method is new.

The team's Fourier fourth-moment computation reduces nondegenerate terms to

    K(α,β;p) = Σ_{r∈Fp*} e_p(αr+β/r).

The applicable bound is the classical Weil bound:

    |K(α,β;p)| ≤ 2√p if αβ≠0.

For exactly one zero coefficient the sum is −1, by additive-character orthogonality (and the bijection r↦r⁻¹). For α=β=0 the sum is p−1. This last case must be counted separately, rather than included in a square-root estimate.

**Verified statement and proof source:** Henryk Iwaniec and Emmanuel Kowalski, *Analytic Number Theory*, Theorem 11.11 and equation (11.15), printed p.280; the proof is in §§11.6–11.7, including the explicit rational phase on p.287. [Author-hosted chapter](https://people.math.ethz.ch/~kowalski/ik-ant-exp-sums.pdf). Their sign convention for S is immaterial to the absolute-value bound. The stated hypotheses are nontrivial additive characters and odd characteristic, exactly matching the nonzero α,β case here.

**Original attribution:** André Weil, “On Some Exponential Sums,” *PNAS* 34(5) (1948), 204–207, [DOI](https://doi.org/10.1073/pnas.34.5.204), [archival record](https://pmc.ncbi.nlm.nih.gov/articles/PMC1079093/?page=0). The original bibliographic record was located; its full-text page returned an access challenge in this run. The exact estimate above was verified in the author-hosted Iwaniec–Kowalski statement, not inferred from the archival title alone.

The team reports an independently checked block bound

    λ ≪ p^(1/4)d^(1/2) + p^(1/8)d^(3/4),

and, using the common-domain independent-set identity, m=O(p^(19/10)). The analytic proof and independent audits belong to the companion Pass 4 proof/audit files, not to a cited external theorem. The classical Kloosterman estimate supplies an input; it does not by itself establish those local operator identities or their graph interpretation.

## Closest inspected reflection literature and the remaining priority question

**Hanson–Lund–Roche-Newton, On distinct perpendicular bisectors and pinned distances in finite fields, arXiv:1412.1611v2, §§2.1 and 3, Theorem 3.** [Primary PDF](https://arxiv.org/pdf/1412.1611). This paper explicitly uses finite-plane reflections and a spectral graph to bound bisector energy. Its bound is of the form |P|⁴/q²+q|P|², summing over bisectors; it does not state the arbitrary-subset-of-parabola-tangents operator estimate above. Its reflection framework is relevant prior methodology. The standard x₁²+x₂² metric becomes the split form over fields where −1 is a square; one should not assert that coordinate equivalence over every prime field without checking it.

**Murphy–Rudnev–Stevens, Bisector energy and pinned distances in positive characteristic, arXiv:1908.04618v3, §1.2 and §§2.2–2.4.** [Primary PDF](https://arxiv.org/pdf/1908.04618). It uses axial symmetries and the Blaschke–Grünwald map to turn bisector-energy questions into point-plane incidences. Its principal quantitative theorem concerns point sets of size at most p^(4/3). The inspected statements do not specialize directly to a uniform spectral estimate for an arbitrary tangent-line palette, and the present common-domain edge set may be much larger. Again, this is substantive related methodology, not a discovered identical theorem.

Targeted searches included quadratic affine palettes, crossed involutions, tangent-parabola reflections, finite-field bisector spectral graphs, Kloosterman graph spectra, and one-sided star/reverse-free tables. They did not reveal an exact prior statement of the restricted-palette bound or the O(p^(19/10)) common-domain consequence. That establishes only a scoped search outcome. The safe verdict is: **a locally derived, independently audited special-case result using classical ingredients; an exact published match was not located in the inspected sources, and originality is unestablished.** No claim to a new Weil bound, a new general reflection method, or a solution of Erdős #810 is warranted.

The conclusion still depends on a common row domain for all colors. A general partial affine coloring has color-dependent supports; the independent-set identity used here no longer follows automatically. No universal #810 density bound follows merely by deleting or relabeling those supports.
