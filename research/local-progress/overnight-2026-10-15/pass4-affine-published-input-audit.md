# Arbitrary affine intercepts: published inputs and the power-saving obstruction

Checked 2026-10-15. This note audits the external inputs for the common/near-common-domain result and records a classical obstruction to a uniform power-saving exponent. The crossed-operator calculation itself is in the companion analytic proof and independent-audit files.

## 1. Exact affine-energy input

Giorgis Petridis, Oliver Roche-Newton, Misha Rudnev and Audie Warren, **An Energy Bound in the Affine Group**, *International Mathematics Research Notices* 2022(2), 1154–1172, Theorem 2.1. [Published primary text](https://academic.oup.com/imrn/article/2022/2/1154/5850679); [arXiv:1911.03401 PDF](https://arxiv.org/pdf/1911.03401), PDF page 3.

The theorem identifies an affine map with its coefficient point (slope,intercept). For a finite set S, let M bound occupancy on every affine line, and let μ bound occupancy on vertical lines. In characteristic p it assumes μ|S|≤p². It proves

    max(E(S), E*(S)) ≪ μ^(1/2)|S|^(5/2) + M|S|².

Its definitions are

    E(S)  = #{(g,h,u,v)∈S⁴ : g⁻¹h=u⁻¹v},
    E*(S) = #{(g,h,u,v)∈S⁴ : gh=uv}.

The implicit constant is absolute. This is a published theorem over general fields subject to the stated characteristic condition, not a conjectural energy estimate. The source also discusses stronger conjectural estimates; those are not being used.

### Application and orientation check

Here S={σ_a:x↦ax+β(a), a∈A⊂Fp*}, with d=|A|. There is one point per nonzero slope, so μ=1 and d≤p−1. Let L be the maximum occupancy of the coefficient points on any affine line. Every hypothesis is satisfied, and

    E(S) ≪ d^(5/2)+L d².                                      (1)

If our operator calculation uses right quotients instead, there is no loss or unproved invariance assertion: the identity

    gh⁻¹=uv⁻¹  ⇔  u⁻¹g=v⁻¹h

and the bijection (g,h,u,v)↦(u,g,v,h) show that the count of right-quotient coincidences equals the source's E(S). This also makes clear that E* is a different quantity and is not needed for (1).

In particular, if d=Θ(p) and L=o(p), then (1) gives E(S)=o(p³). This replaces the earlier local heavy-color-energy theorem in the shortest proof. No noncommutative BSG or approximate-group theorem is needed for this step.

## 2. Exact group-table input

József Solymosi, **The (7,4)-conjecture in finite groups**, arXiv:1309.0133, Theorem 5, PDF page 4; later *Combinatorics, Probability and Computing* 24 (2015), 680–686. [Primary PDF](https://arxiv.org/pdf/1309.0133).

For every fixed κ>0, sufficiently large finite groups G have the property that any H⊂G×G with |H|≥κ|G|² contains a rectangle (α,β),(α,γ),(δ,γ),(δ,β) with αβ=δγ. The four elements are distinct. Consequently a partial group table whose every C4 has four distinct product labels contains o(|G|²) entries, uniformly over G. For quotient labels s/r in Fp*, use the bijection (r,s)↦(s,r⁻¹); the product label becomes s/r. This is an exact prior theorem, not a novel group-table assertion of this project.

### Why it forces L=o(p) in the affine application

Suppose every color has a domain D_a⊂X, and let

    R=Σ_a |X\D_a|,
    m=Σ_a |D_a|,

where the selected graph is simple, proper, and all its C4s are rainbow. Assume R=o(p²). To obtain a contradiction, suppose m≥δp² along a sequence, with fixed δ>0. Then d≥δp and |X|≥δp because m≤d|X| and both factors are at most p.

If L≥εp for fixed ε>0 on a subsequence, the occupied coefficient line cannot be vertical. Write it as β(a)=ua+v, and let B be its palette, q=|B|≥εp. Its selected subgraph has at least

    q|X|−R ≥ εδp²−o(p²)

edges. For these colors, σ_a(x)=a(x+u)+v. The exceptional row x=−u sends every color to y=v. Simplicity and properness permit at most one actual edge in this row, so deleting it costs at most one edge. Relabel the remaining endpoints by

    r=x+u ∈ Fp*,   s=y−v ∈ Fp*.

The inherited color is exactly a=s/r. We now have a positive-density partial group table on Fp*, contradicting Solymosi. Therefore L=o(p).

This proof uses the original partial supports and their total deficit R. It does not assume that the completed coloring is proper. It also does not require pruning low-density color classes first.

## 3. Short dependency chain for the new local conclusion

The separately audited crossed-involution calculation defines

    τ_a(x,y)=((y−β(a))/a, ax+β(a))

and obtains the following bound for the nonconstant norm λ of S=Σ_a U_(τ_a):

    λ⁴ ≤ max((p−1)E(S_palette),
              p(L+2)d²+2√p d³).                            (2)

Here E(S_palette) is the affine-group energy, not the operator S itself. The nonzero-frequency bound uses Weil's classical Kloosterman estimate, with degenerate phases counted separately. The proof of (2) is local work and is not a statement quoted from PRRW or Solymosi.

Under the hypothetical m≥δp², Section 2 gives L=o(p), and Section 1 gives E=o(p³). Since d≤p, equation (2) yields λ=o(p).

For the actual edge-point set F⊂Fp², the audited support-count argument gives

    d m²/p² − λ(m−m²/p²)
       ≤ ⟨1_F,S1_F⟩ ≤ m+2dR.                             (3)

The main term in the left side is Ω(p³), whereas its error and the entire right side are o(p³). This contradiction proves m=o(p²), uniformly for arbitrary β and near-common domains with R=o(p²).

Thus the shortest external dependency list is Solymosi's group-table theorem, PRRW's affine-energy theorem, and Weil's Kloosterman bound, together with the project's analytic crossed-operator and support-count arguments. The previously proved general heavy-energy and small-difference results remain alternative routes, but are not necessary here.

The scoped novelty verdict is unchanged: the inspected primary sources supply these ingredients, but do not explicitly state the arbitrary-intercept common-domain conclusion. The combination has been derived and independently audited locally; an exact prior match was not located, and originality is unestablished. General unrelated color-dependent supports remain outside this conclusion.

## 4. A classical pencil construction forbids any uniform power-saving exponent

**Primary source:** Felix A. Behrend, **On Sets of Integers Which Contain No Three Terms in Arithmetical Progression**, *PNAS* 32(12) (1946), 331–332. [DOI](https://doi.org/10.1073/pnas.32.12.331); [primary archived PDF](https://pmc.ncbi.nlm.nih.gov/articles/instance/1078964/pdf/pnas01693-0039.pdf). Its displayed first-page lower bound implies the existence of T⊂{0,…,N−1} with |T|≥N exp(−C√log N) and no nonconstant three-term arithmetic progression. The primary PDF's indexed text supplied the bound and construction; a direct full-PDF open returned an access challenge in this run. No modern improvement is needed here.

Set h=p−1, N=⌊h/4⌋ and choose such a T. Fix a generator g of the cyclic group Fp*, and define A={g^t:t∈T}. It is **strongly multiplicative-progression-free**:

    ab=c² with a,b,c∈A  implies a=b=c.                      (4)

Indeed, writing a=g^u,b=g^v,c=g^t, the equality gives u+v−2t≡0 modulo h. Its integer absolute value is less than h because u,v,t∈[0,N). Hence u+v=2t as integers. Behrend's property forces all equal when the terms are distinct; if two coincide, the integer equality itself forces the third to coincide. The short interval therefore also excludes the order-two degeneracy possible in an even cyclic group.

Take β(a)=0 and X=Fp*. Include every edge x→ax of color a∈A. This graph is simple and proper: at a fixed nonzero x, distinct a give distinct outputs, and multiplication by each a is a permutation. If a C4 had repeated opposite color a, write its rows as x≠z and its other colors as b,c. The closing equations are

    bx=az,   cz=ax,

so bc=a². By (4), a=b=c, which forces x=z, a contradiction. Since properness already forbids adjacent color repetition, every C4 is rainbow.

The graph has

    m=(p−1)|A| ≥ c p² exp(−C√log p)=p^(2−o(1))             (5)

edges, with one nonzero slope per color and exactly one common domain. For every fixed ε>0, this exceeds p^(2−ε) by an unbounded factor as p→∞. It is still o(p²), so it is consistent with Section 3.

The same example works with any affine intercept β(a)=ua+v after translating rows and columns and using X=Fp\{−u}. Consequently **no theorem uniform over arbitrary β can assert m=O(p^(2−ε)) for any fixed ε>0**. This obstruction is an elementary application of Behrend's classical construction, not a claimed new extremal construction.

The polynomial quantitative statement must therefore require a genuinely nonlinear polynomial: fixed degree 2≤D<p. For such a polynomial, every affine line contains at most D coefficient points, because β(a)−ua−v is a nonzero polynomial of degree D. Degree 0 or 1 does not have this property and must not be included in an O_D(p^(19/10)) statement.
