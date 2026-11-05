# Independent audit of polynomial-residue palettes

18 October 2026. Audited statement: [Polynomial-residue palettes](dense-palette.md), Sections 1–4, including the robustness estimate. The proof passes this written mathematical audit. This is neither a Lean certificate nor a determination of historical novelty.

## Exact scope checked

Fix bounds $D,L$. For $P$ of degree at most $D$ having a nonzero simple geometric root, a nonzero parameter $\tau$, and a subgroup $C$ of index at most $L$, put

```math
A_0=\{a\ne0:P(a)\in\tau C\}.
```

In the quadratic affine common-potential model, the theorem gives

```math
m\ll_{D,L}p^{63/32}+p^{4/3}(R+pd)^{1/3},
```

where $d=|A_0\setminus A|$ and $R$ counts omitted eligible incidences in $(A\cap A_0)\times H$. The support $H$ is arbitrary, and $m$ counts every retained color. Neither arbitrary dense palettes nor growing $D,L$ are covered.

## Geometry checked independently

Write

```math
Q=q^2+1,\quad B=q^2+q+1,\quad r=(q+1)/Q,
\quad F=-BQ/[q(q+1)].
```

The cube-root configuration surface is rational with coordinates $(a,q)$, potentials

```math
(u,v,k)=(a^3/F,qa^3/F,qra^3/F),
```

and colors $(a,ar,aqr)$. The already established separate-cover theorem says that this surface remains geometrically integral after arbitrary separate curve covers of the three potential coordinates. This prior theorem is essential; the new proof does not derive that fact again from the palette divisors.

Let $\rho\ne0$ be a simple root of $P$ over an algebraic closure of characteristic zero. The divisors $a=\rho$, $ar=\rho$, and $aqr=\rho$ are distinct rational prime divisors. The potential restrictions in the draft were independently recalculated. In particular,

```math
u\big|_{ar=\rho}=-\frac{\rho^3qQ^2}{B(q+1)^2},
\qquad
u\big|_{aqr=\rho}=-\frac{\rho^3Q^2}{q^2B(q+1)^2},
```

and multiplication by $q$ or $qr$ gives the stated $v,k$ entries. All nine entries are nonconstant. For the first two rows in the draft table they vanish at $q=0$ without vanishing identically; for the last row they have poles there. These checks concern rational functions on the closure and do not reintroduce excluded configurations.

At each divisor, the selected color coordinate minus $\rho$ is a local uniformizer up to a unit. The selected radicand therefore has valuation one. The other two colors vary nontrivially along the divisor, so their polynomial radicands have valuation zero. They cannot vanish identically there because $P$ is a nonzero polynomial and those colors are nonconstant rational functions.

All separate potential covers are étale at these generic divisors: a finite curve cover has only finitely many branch values, and each potential is nonconstant there. Their pullbacks, and their normalization/compositum on the field level, remain unramified. The argument may use valuations at boundary divisors removed from the final admissible open; this is valid for proving irreducibility of the function field.

Now adjoin the three roots of $P(a)/\tau$, $P(ar)/\tau$, and $P(aqr)/\tau$ successively. The first polynomial is Eisenstein at the first divisor. At the second divisor, the first radicand is a unit. In characteristic zero the algebra obtained by adjoining an $\ell$th root of a unit is finite étale over the relevant discrete valuation ring: its root is a unit and its derivative is invertible. Every field factor is consequently unramified. Thus the second radicand still has valuation one, and Eisenstein applies again. The third divisor gives the same argument after both preceding extensions.

This verifies sequential irreducibility for every fixed composite as well as prime $\ell$. It also verifies geometric integrality, since the entire argument was conducted after algebraic closure of constants. The case $\ell=1$ is immediate.

## Counting argument checked

The new predicate on $(u,v)$ asserts existence of a cube root $a$ together with the three palette-root witnesses. Its complexity is bounded in $D,L$, uniformly in the coefficients and $\tau$. The original four-output map built from $K(u,v)$ is unchanged. Thus its exceptional locus, finite generic fibers, and the two Cauchy–Schwarz steps remain applicable.

Every restricted four-grid multiplicity is a bounded definable function. No claim of irreducibility of a four-grid palette cover is needed: product regularity handles these bounded level sets. The additional geometry is used only in the positivity step, where finite witness covers of three potential cells are pulled back through the new geometrically integral surface. Lang–Weil supplies a positive quadratic number of rational points, and bounded projection fibers give a positive quadratic number of input pairs. This is exactly the role required by the earlier counting proof.

Uniformity in polynomial coefficients is valid. In a hypothetical sequence violating all proposed uniform constants, bounded degrees and fixed subgroup index have a subsequence of fixed integer complexity. The nonzero simple-root hypothesis persists over the algebraic closure of the characteristic-zero ultraproduct: chosen roots remain nonzero and their derivative values remain nonzero. All the divisor calculations are valid for that limiting polynomial and parameter. This yields the same contradiction giving uniform positive main-term and finite error constants. No fixed-small-characteristic wild ramification claim is made.

## Graph transfer checked

Split $H\setminus\{0\}$ into disjoint input sets and use it as the output set. A counted input pair provides at least one actual color root $a$. Count actual configurations, not auxiliary palette-root witnesses. Each missing color destroys at most $3p$ configurations and each missing colored incidence at most sixteen, by the previously verified combinatorial parameterization. These upper bounds only decrease when restricting to $A_0$.

Hence

```math
c_{D,L}h^3/p-C_{D,L}p^{15/16}h\le3pd+16R,
\qquad h=|H\setminus\{0\}|.
```

The same error-versus-main-term dichotomy gives the asserted exponent and deficit term. The zero potential contributes at most $p-1$ incidences. This establishes the statement with the advertised definitions of $d,R,m$.

## Assessment

The translated-coset specialization $P(T)=T+s$, $s\ne0$, is a substantive widening of the prior multiplicative-coset hypothesis: it directly treats three coupled palette memberships that the prior proof handled only through ratios of potentials. The proof supplies those memberships through separate ramification divisors, not by treating them as probabilistically independent. It remains a restricted-family theorem based on the existing algebraic counting machinery. Historical novelty requires a separate literature assessment.

## Private-root intersections

The subsequently added extension to a fixed number of simultaneous polynomial-residue conditions also passes. If each $P_j$ has a private nonzero simple root $\rho_j$ that is not a root of any other $P_i$, use the $3s$ divisors obtained by setting one of the three colors equal to $\rho_j$. The selected radicand has valuation one. Every other radicand has valuation zero: same-color other polynomials are nonzero at $\rho_j$ by the private-root hypothesis, and other-color polynomials are nonzero generically because those color functions are nonconstant. All earlier root extensions are therefore unramified, and sequential Eisenstein applies in any order. Bounded complexity and the unchanged graph multiplicities give the stated uniform constants depending additionally on the number of conditions. In particular, fixed intersections of distinct nonzero translated multiplicative cosets are covered.
