# Research report: 18 October 2026

## Current conclusion

A restricted asymptotic advance has survived independent mathematical audits. In the quadratic affine model, the common potential support can now be **arbitrary**, provided the palette contains almost all of one multiplicative coset of bounded index. The proof gives a power saving and tolerates a vanishing fraction of omitted incidences. No Fourier-complexity, definability, or symmetry assumption on the support is needed.

This does not solve Erdős problem #810, improve the unrestricted constant-density bound, or establish historical priority. The argument uses Tao's published algebraic regularity theorem, with a written adaptation of its expansion argument to a root-restricted relation. It has not been checked in Lean.

The subsequent [serious novelty audit](NOVELTY-AUDIT.md) found no directly subsuming result in the inspected primary sources, but identified the analytic machinery and quantitative loss as established. The defensible assessment is a **possible new specialized application, worth a short technical note**, with historical priority and publication significance unestablished. The closely related 2026 perfect-coloring paper's body remains an explicit access gap.

## Main theorem

Fix $L\ge1$. Let $p$ be a sufficiently large prime, let $A\subseteq\mathbb F_p^\times$, and let $H\subseteq\mathbb F_p$. The available incidence of color $a\in A$ and potential $h\in H$ is

```math
(x,y)=\left(\frac{h}{a^2}-a,\frac{h}{a}\right).
```

Thus its edge lies on $y=ax+a^2$, with $ay=h$. Retain any subset of these incidences that forms a simple properly edge-colored bipartite graph in which every four-cycle has four distinct colors. Let $m$ be its edge count. Choose a multiplicative subgroup $C$ of index at most $L$ and a coset $tC$. Let $D=|tC\setminus A|$ count colors missing from this coset, and let $R$ count omitted incidences in $(A\cap tC)\times H$.

There is a constant $K_L$, depending only on $L$, such that

```math
m\le K_L p^{63/32}
   +K_L p^{4/3}(R+pD)^{1/3}.
```

In particular:

- One full coset of bounded index, with all its $H$-incidences retained, suffices for $m=O_L(p^{63/32})=O_L(p^{2-1/32})$.
- If $D=o(p)$ and $R=o(p^2)$, then $m=o(p^2)$. Other colors can be arbitrary.
- The full or nearly full palette follows by taking $C=\mathbb F_p^\times$.

The constants are not numerically explicit. The exponent is a consequence of the available algebraic regularity input, not an optimized exponent.

The [complete coset extension](quadratic-coset-palette-extension.md) and [independent audit](fixed-index-palette-coset-independent-audit.md) give the exact statement. Here the graph has $N=2p$ vertices, so the exponent also gives $O_L(N^{2-1/32})$ in this restricted family. This is not an upper bound for the unrestricted extremal function in #810.

## What this adds to the earlier work

The earlier common-potential support argument required a small Fourier envelope. That restriction is removed for the palettes above. The new theorem also covers examples outside the earlier small-product theorem: for $S=\{x\mapsto ax+a^2:a\in tC\}$ and $s=|C|$,

```math
|SS^{-1}|=1+\frac{s(s-1)}{\gcd(2,s)}=\Theta_L(p^2).
```

Thus the old hypothesis $|SS^{-1}|=O(p)$ fails. The quotient energy is still only $s^2+\gcd(2,s)s(s-1)=O(p^2)$, so the previously proved low-energy obstruction alone does not exclude this family.

The result is nonvacuous at the level of properness. For example, with the cube subgroup as palette and $H$ in a noncube coset, the eligible graph can be simple and proper with a positive quadratic number of edges. The new argument forces a non-rainbow four-cycle; it uses more than the collision condition.

## Extension to a palette with a fixed fraction missing

A separate extension handles palettes that need not contain a large full coset, when the support respects multiplicative dilations. Let $U$ be a subgroup of the nonzero field elements. Suppose $t^3H=H$ for every $t\in U$, and every coset of $U$ has more than two thirds of its colors in $A$. With no incidence omissions, one still has $m=O(p^{63/32})$.

For example, for primes $p\equiv1\pmod{21}$ take $U$ of order seven, and retain exactly five colors from each seven-element coset. The support $H$ may be an arbitrary union of $U$-orbits. It may even lie in a nontrivial cubic coset and satisfy $H\cap(-H)=\varnothing$: the resulting completed graph is proper and has no bichromatic four-cycle, but if $H$ has fixed positive density the argument forces three-color four-cycles. This uses the three-color configuration essentially.

The [dilation proof](palette-dilation-extension.md) also treats approximate invariance and omitted incidences. It distinguishes the even-order symmetry case, where a simpler Gauss-sum argument gives a stronger $O(p^{3/2})$ bound. That elementary special case is not presented as a new contribution.

## Why the proof works

First consider the full-palette case. The argument forces a specific non-rainbow rectangle. For nonzero $u,v$, define

```math
K(u,v)=\frac{uv(u+v)}{u^2+v^2},\qquad
G(u,v)=-\frac{(u^2+uv+v^2)(u^2+v^2)}{uv(u+v)}.
```

For $X,Y,Z\subseteq\mathbb F_p^\times$, the counting consequence proved here gives absolute positive constants $c_0,C$ such that

```math
\#\{(u,v)\in X\times Y:K(u,v)\in Z,
                  \ G(u,v)\text{ is a nonzero cube}\}
\ge c_0\frac{|X||Y||Z|}{p}
       -Cp^{15/16}\sqrt{|X||Y|}.
```

Rational poles and zero values are excluded. To ensure $u\ne v$, take disjoint halves of $H\setminus\{0\}$ for $X,Y$ and take $Z=H\setminus\{0\}$. Set $k=K(u,v)$, choose $a\ne0$ with $a^3=G(u,v)$, and put

```math
b=ak/v,\qquad c=ak/u.
```

The four incidences with colors and potentials

```math
(a,u),\ (a,v),\ (b,k),\ (c,k)
```

form a nondegenerate four-cycle whose opposite edges have color $a$. Each omitted incidence can destroy at most 16 of these ordered configurations, and each omitted color at most $3p$. Thus

```math
c_0|H\setminus\{0\}|^3/p
 -Cp^{15/16}|H\setminus\{0\}|
\le 16R+3pD.
```

Solving this cubic inequality and using $m\le p|H|$ proves the theorem. The incidences with potential zero add at most $p-1$ edges and are absorbed by the displayed bound.

For a coset $tC$ of index $\ell$, first restrict $H$ to one coset of $C$. Replace the cube predicate by the condition that $G(u,v)/t^3$ is a nonzero $(3\ell)$th power. This ensures a cube root $a\in tC$. Since the three potentials $u,v,k$ lie in one $C$-coset, the two cross-colors $ak/v,ak/u$ also lie in $tC$. The same multiplicity bounds then apply. The valuation-one geometric argument below works for every fixed root degree, which is the substantive justification for this replacement.

The nontrivial step is the cube-restricted counting lemma. Its proof has two separately audited parts:

1. A geometric calculation shows that the surface $z=K(u,v),\ a^3=G(u,v)$ stays geometrically integral, on its natural dense open set, after arbitrary separate covers of $u,v,z$ by geometrically irreducible curves. Multiplicity-one divisors handle the rational-map cover obstruction; a simple zero on $v=\omega u$, for a primitive cube root ω, handles the additional cube cover.
2. Tao's two Cauchy–Schwarz steps still work when the four-grid count includes the cube-existence predicate. Definable regularity gives output cells; the geometric calculation and Lang–Weil force positive density in every relevant cell. A characteristic-zero ultraproduct argument supplies uniform finite-prime constants.

The cube condition was checked explicitly. An unrestricted image-expansion theorem for $K$, by itself, would not prove the graph result.

## Proof and audit files

- [Geometry and all separate-cover checks](rational-expander-cover-proof.md).
- [Complete counting extension and quantitative audit](partial-rational-expansion-independent-audit.md).
- [Exact configurations, degeneracies, and robust graph transfer](common-potential-combinatorics.md), especially Sections 6–8.
- [Independent review of the complete chain](common-potential-independent-counting-audit.md).
- [Final source and technical audit](final-literature-adversarial-audit.md).
- [Extension to palettes respecting a dilation symmetry](palette-dilation-extension.md).
- [Extension to a full or nearly full coset, with arbitrary support](quadratic-coset-palette-extension.md).
- [Independent geometric audit of that extension](coset-palette-independent-audit.md).
- [Other support and operator results](common-potential-analysis.md).
- [Primary-source applicability and novelty audit](literature.md).

The geometric calculation, the extension of the counting proof, and the graph transfer were each reviewed independently. This describes mathematical review of written arguments, not a formal proof certificate.

## Other useful findings in this session

A multiplicative Fourier-envelope criterion extends the earlier weighted-operator method to color-dependent multiplicative intervals and related supports. It is useful but weaker in conceptual scope than the main theorem for arbitrary $H$ and nearly full palettes above.

A second, simpler theorem explains why the quadratic case deserves attention. For every fixed degree $d\ge3$, colors $y=ax+a^d$ with a common support in the potential $a^{d-1}y$ have only $O_d(p^{3/2})$ edges when the full palette and all eligible incidences form a simple proper graph. This follows from a classical Weil bound and does not require a four-cycle assumption. A robust deletion version is proved in [the monomial note](monomial-common-potential-propriety.md), with [an independent proof audit](monomial-propriety-independent-audit.md) and [the precise primary-source input](monomial-properness-source-audit.md). The attempted cubic correspondence argument was therefore set aside as a weaker route, rather than counted as another extremal advance. The quadratic family genuinely escapes this elementary collision argument.

Two concrete obstructions prevent reuse of tempting incomplete arguments:

- A proper common-potential example has an aggregate oscillatory remainder of order $p$ with a positive Rayleigh witness. Thus a uniformly small absolute operator norm is false; a lower spectral bound remains a different question.
- Positive density and properness alone do not force nearly complete large rectangles in either the color–row or color–column support matrix. A probabilistic construction proves this without relying on finite graph enumeration. The rainbow-four-cycle condition is essential to any such extraction argument.

A conditional reduction shows that a uniform lower spectral bound $\lambda_{\min}(T)\ge-o(p)$ for the actual masked operator would suffice for the general common-potential model, using triangle removal. That lower bound is **not proved**.

The [negative-spectrum note](common-potential-negative-spectrum.md) proves that changing one potential value changes the operator norm by at most four. Matrix concentration then shows that independent random thinning preserves a lower bound of $-o(p)$. Its [independent audit](negative-spectrum-thinning-independent-audit.md) confirms the constants. This is a probabilistic stability result, not control of adversarial supports.

## Limits and novelty

The unresolved step is a palette $A$ of arbitrary positive density, with no near-full coset or applicable dilation hypothesis. The counting lemma handles the cube root but does not ensure that all three colors $a,b,c$ lie in an arbitrary $A$. Treating these coupled memberships as independent would be an error.

The [six-slot source audit](six-slot-literature-gap.md) identifies the exact missing estimate. The two multiplicative relations among the six coordinates have a positive density model, but no uniform transfer from that model to the actual rational surface has been proved here. The inspected multilinear and algebraic hypergraph theorems fail explicit hypotheses for this surface.

The primary input is Terence Tao, [*Expanding polynomials over finite fields of large characteristic, and a regularity lemma for definable sets*](https://arxiv.org/pdf/1211.2894), especially Lemma 23, Theorem 25, Corollary 37, and the proofs of Theorems 38 and 40. The cube-restricted argument is written out as an extension, rather than attributed to the literal statement of Theorem 40.

The expanded [novelty audit](NOVELTY-AUDIT.md) compares the exact statement with group-table results, B-coloring theorems, algebraic regularity, rational-progression estimates, and polynomial expansion papers through 2026. No directly subsuming theorem was found in the inspected sources. This is not a proof of novelty. The full-text gap for the 2026 paper on perfect proper colorings remains after fresh public author and repository checks. No new record or publishable-priority claim is made.

## Session scope

Research began at 09:05:58 UTC on 18 October 2026, with an original stopping deadline of 11:05:58 UTC. The user subsequently allowed at most 30 additional minutes solely if needed to finish the novelty audit. This directory contains only lightweight research notes. No local Lean build, dependency installation, graph enumeration, external message, publication, or Git push was used for this session.

The initial research pass stopped at 10:05:22 UTC. At the user's request, work resumed at approximately 10:07 UTC for the scoped novelty audit. The added audit compares the closest theorems and documents failed reductions and the remaining full-text gap. No follow-up research was scheduled.

The novelty audit concluded at 10:19:50 UTC, 1 hour 13 minutes 52 seconds after the original start and within the original two-hour limit. All three audit workers had completed. The 26 Markdown notes total approximately 244 KB; their local links and code fences were checked. The optional extra time was not needed.
