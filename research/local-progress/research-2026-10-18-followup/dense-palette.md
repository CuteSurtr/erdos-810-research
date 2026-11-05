# Polynomial-residue palettes: a wider common-potential theorem

18 October 2026. This note records a written extension of the quadratic coset theorem. The argument and its private-root extension passed [independent audit](polynomial-residue-independent-audit.md). It uses the previously established root-restricted definable counting argument. It does not handle an arbitrary dense palette, and historical novelty is not asserted.

## Statement

Fix positive integers $D,L$. Let $p$ be sufficiently large, let $C\le\mathbb F_p^\times$ have index $\ell\le L$, and let $\tau\ne0$. Let $P\in\mathbb F_p[T]$ have degree at most $D$ and possess at least one nonzero simple root over $\overline{\mathbb F}_p$. Put

```math
A_0=\{a\in\mathbb F_p^\times:P(a)\in\tau C\}.
```

The condition excludes $P(a)=0$. The root required in the hypothesis need not belong to $\mathbb F_p$.

Let $A\subseteq\mathbb F_p^\times$ and $H\subseteq\mathbb F_p$ be arbitrary. Retain any subset of the eligible quadratic incidences

```math
(a,h)\longmapsto (h/a^2-a,h/a),\qquad(a,h)\in A\times H,
```

forming a simple proper edge-coloring whose every four-cycle is rainbow. Let $m$ be its total edge count, let $d=|A_0\setminus A|$, and let $R$ count omitted incidences only in $(A\cap A_0)\times H$. The claimed conclusion is

```math
m\ll_{D,L}p^{63/32}+p^{4/3}(R+pd)^{1/3}.                 \tag{1}
```

In particular, $A\supseteq A_0$ and $R=0$ imply $m=O_{D,L}(p^{63/32})$ for arbitrary $H$. The same proof allows $d=o(p)$ and $R=o(p^2)$ and then gives $m=o(p^2)$.

The especially transparent additional family is

```math
A_0=(\tau C-s)\setminus\{0\},\qquad s\ne0,
```

obtained from $P(T)=T+s$. This is a translated multiplicative coset, not the multiplicative coset in the earlier theorem. The theorem also treats, for example, colors $a$ for which a fixed squarefree polynomial $P(a)$ lies in a prescribed multiplicative coset. A polynomial having only the root zero does not satisfy this argument's hypothesis; the earlier coset theorem treats that separate case.

## 1. The exact configuration surface

Use the earlier rational functions

```math
K(u,v)=\frac{uv(u+v)}{u^2+v^2},\qquad
G(u,v)=-\frac{(u^2+uv+v^2)(u^2+v^2)}{uv(u+v)}.
```

On the surface $a^3=G(u,v)$, put $q=v/u$ and

```math
Q=q^2+1,\quad B=q^2+q+1,\quad
r=\frac{q+1}{Q},\quad F=-\frac{BQ}{q(q+1)}.
```

The surface is rationally parametrized by $(a,q)$:

```math
u=\frac{a^3}{F},\quad v=\frac{qa^3}{F},\quad
k=K(u,v)=\frac{qr a^3}{F},\qquad
b=ar,\quad c=aqr.                                      \tag{2}
```

Remove all zeros and poles in these formulas, together with $q=1$. The four incidences

```math
(a,u),\quad(a,v),\quad(b,k),\quad(c,k)                  \tag{3}
```

then form the nondegenerate repeated-color rectangle proved in the preceding research. The three colors are distinct. Requiring all three colors in $A_0$ is equivalent to requiring nonzero witnesses

```math
z_1^\ell=P(a)/\tau,\qquad
z_2^\ell=P(b)/\tau,\qquad
z_3^\ell=P(c)/\tau.                                   \tag{4}
```

Here $C=(\mathbb F_p^\times)^\ell$. Counting actual roots $a$ is sufficient; there is no need to count the $z_i$ as different graph configurations.

## 2. Three divisors separate the additional root equations

All geometry in this paragraph is over an algebraically closed field of characteristic zero, as in the existing ultraproduct argument. Choose a nonzero simple root $\zeta$ of $P$. On the rational surface (2), consider

```math
D_a:\ a=\zeta,\qquad D_b:\ b=\zeta,\qquad D_c:\ c=\zeta.
```

These are distinct rational prime divisors. On each divisor the other two color coordinates are nonconstant:

| Divisor | Other colors |
|---|---|
| $D_a$ | $b=\zeta r$, $c=\zeta qr$ |
| $D_b$ | $a=\zeta/r$, $c=\zeta q$ |
| $D_c$ | $a=\zeta/(qr)$, $b=\zeta/q$ |

Consequently, at the generic point of $D_a$, the function $P(a)$ has valuation one and $P(b),P(c)$ have valuation zero; the analogous assertions hold at $D_b,D_c$.

Crucially, all three potential coordinates are also nonconstant on every divisor. Their restrictions, divided by $\zeta^3$, are

```math
\begin{array}{c|ccc}
&u/\zeta^3&v/\zeta^3&k/\zeta^3\\ \hline
D_a&-q(q+1)/(BQ)&-q^2(q+1)/(BQ)&-q^2(q+1)^2/(BQ^2)\\
D_b&-qQ^2/(B(q+1)^2)&-q^2Q^2/(B(q+1)^2)&-q^2Q/(B(q+1))\\
D_c&-Q^2/(q^2B(q+1)^2)&-Q^2/(qB(q+1)^2)&-Q/(qB(q+1)).
\end{array}                                             \tag{5}
```

For the first two rows all entries vanish at $q=0$ without vanishing identically; for the last row they have poles at $q=0$. Thus none is constant. The use of $q=0$ here checks a rational function on the projective closure; it does not add an inadmissible configuration.

Now pull the surface back along any three separate dominant maps from geometrically irreducible curves to the $u,v,k$ lines. The preceding coset proof establishes that this base pullback is geometrically integral. Normalize the curves and restrict to dense opens so the maps are finite. Each curve cover has a finite branch locus. By (5), the generic points of $D_a,D_b,D_c$ map to none of those branch values. Hence the pullback is unramified above each generic divisor; each has a nonempty inverse image, and every valuation above it has ramification index one.

Adjoin the three roots in (4) successively. The first polynomial is Eisenstein at a valuation above $D_a$, because $P(a)/\tau$ has valuation one. The second is Eisenstein at a valuation above $D_b$: the first radicand is a unit there, so adjoining its root is unramified in characteristic zero, whereas $P(b)/\tau$ still has valuation one. The third uses $D_c$ in the same way; both earlier radicands are units there. This proves irreducibility at every stage, also for composite $\ell$. It also proves geometric integrality of the final cover after every triple of separate potential covers. If $\ell=1$, the additional roots are identities and the same conclusion is immediate.

This is the key difference from imposing three arbitrary palette memberships. These polynomial-residue memberships have fixed algebraic complexity, and their three covers have separately accessible ramification divisors. No assertion about arbitrary dense $A$ follows from this argument.

## 3. The counting argument with the extra palette conditions

Define $E_P(u,v)$ to hold when there exists a nonzero $a$ such that $a^3=G(u,v)$ and all three corresponding colors in (2) belong to $A_0$. Work on the same admissible open set as above. For fixed $D,L$, this is a definable predicate of bounded complexity, uniformly in the coefficients of $P$ and the nonzero parameter $\tau$.

The existing root-restricted counting proof applies with this predicate:

```math
\sum_{u\in X,v\in Y}E_P(u,v)1_Z(K(u,v))
\ge c_{D,L}\frac{|X||Y||Z|}{p}
 -C_{D,L}p^{15/16}\sqrt{|X||Y|}.                       \tag{6}
```

For completeness, the required inputs are exactly the following. The four-output map of a $2\times2$ grid of $K$-values is unchanged and remains dominant and generically finite. Its finite fibre counts weighted by the four bounded predicates $E_P$ are bounded definable functions. Tao's product regularity and the same two Cauchy–Schwarz inequalities give the $p^{15/16}\sqrt{|X||Y|}$ within-cell error. For positivity, finite witness covers of each of the three potential cells pull the surface and the equations (4) back to a geometrically integral variety, by Section 2. Lang–Weil then supplies a positive quadratic count. Every input-cell/output-cell coefficient is therefore positive. The existing finite-minimum and small-set arguments give (6).

The uniformity in coefficients is justified by the same contradiction/ultraproduct argument used in the preceding theorem. Degree is bounded by $D$, index by $L$, $\tau$ is nonzero, and the condition that $P$ has a nonzero simple geometric root persists in the characteristic-zero ultraproduct. One may express the latter by the existence of $\zeta\ne0$ satisfying $P(\zeta)=0$, $P'(\zeta)\ne0$ in an algebraic closure, or equivalently by the corresponding bounded-degree polynomial conditions. All divisor calculations then hold over that algebraic closure. Constants are not numerically effective.

This is an extension of the prior proved counting argument, not a literal new assertion attributed to Tao's published theorem.

## 4. Transfer to the graph and omissions

Put $h=|H\setminus\{0\}|$. Split the nonzero support into two disjoint comparable subsets $X,Y$ and set $Z=H\setminus\{0\}$. Bounded cases are absorbed into the error term. Every pair counted in (6) gives at least one actual ordered configuration (3) with all three colors in $A_0$. Counting every eligible cube root $a$ gives a configuration count $N$ satisfying

```math
N\ge c_{D,L}h^3/p-C_{D,L}p^{15/16}h.                  \tag{7}
```

The earlier exact combinatorial multiplicity bounds do not depend on palette shape: a fixed color belongs to at most $3p$ of these ordered configurations, and a fixed color/potential incidence to at most sixteen. If every color of a configuration lies in $A$, at least one of its four incidences must be absent from the actual graph. Thus

```math
c_{D,L}h^3/p-C_{D,L}p^{15/16}h\le N\le3pd+16R.        \tag{8}
```

Separating according to whether the error or deletion term dominates yields

```math
h\ll_{D,L}p^{31/32}+p^{1/3}(R+pd)^{1/3}.
```

Use $m\le p(h+1)$ to obtain (1). This upper bound counts all retained colors, not only those in $A_0$. The possible zero potential contributes at most $p-1$ edges and is absorbed.

## 5. Why the translated family goes beyond the earlier hypothesis

For fixed $\ell>1$, $s\ne0$ and any multiplicative coset $vD$ of bounded index $j$, the classical multiplicative-character bound gives

```math
|vD\cap(\tau C-s)|=\frac{p}{j\ell}+O_{j,\ell}(\sqrt p).
```

Indeed, expand the two coset indicators in characters. Except for the trivial pair, the rational functions have separate divisor supports at $a=0$ and $a=-s$, so their product cannot be a constant character function. The standard Weil/Jacobi-sum bound is $O(\sqrt p)$; the finitely many excluded values only contribute $O(1)$. Consequently the translated palette omits

```math
\left(1-\frac1\ell\right)\frac pj+O_{j,\ell}(\sqrt p)
```

colors from every such $vD$. It does not contain almost all of any multiplicative coset of fixed index. Its density is $1/\ell+O(p^{-1})$.

This is not vacuous because of properness: when $p\equiv1\pmod3$, choosing any nonzero potential set $H$ inside one nontrivial cubic coset already makes the full-palette eligible incidence system simple and proper, by the earlier collision classification. Every subpalette, including a translated coset, remains proper. Such $H$ can have positive density. Equation (1) therefore uses the rainbow-four-cycle condition to rule these examples out.

## 6. Simultaneous residue conditions with private roots

The same proof gives a further explicit extension. Fix $s,D,L$. For $1\le j\le s$, let $P_j$ have degree at most $D$, let $C_j$ have index $\ell_j\le L$, and let $\tau_j\ne0$. Assume that $P_j$ has a nonzero simple geometric root $\zeta_j$ which is not a root of any $P_i$ with $i\ne j$. Define

```math
A_0=\{a\ne0:P_j(a)\in\tau_j C_j\text{ for every }j\}.
```

Then (1) holds with constants depending on $s,D,L$.

To prove this, adjoin the $3s$ root equations

```math
z_{ij}^{\ell_j}=P_j(a_i)/\tau_j,
\qquad (a_1,a_2,a_3)=(a,b,c).
```

For the equation indexed by $(i,j)$, use the divisor $a_i=\zeta_j$. Its own radicand has valuation one. Every radicand from another color is a unit, because that color is nonconstant on the divisor. Every other radicand from the same color is a unit by the private-root hypothesis. The three potential coordinates remain nonconstant by (5), with $\zeta$ replaced by $\zeta_j$. Thus the separate potential covers and every previously adjoined root are unramified there, and Eisenstein applies in any order. The complete cover is geometrically integral. The definable counting and deletion transfer are unchanged.

In particular, take $P_j(T)=T+s_j$ for distinct nonzero shifts $s_j$. Every prescribed intersection of finitely many shifted multiplicative cosets is covered. Such a palette has density

```math
\prod_{j=1}^s\ell_j^{-1}+O_{s,L}(p^{-1/2}),
```

by the classical character estimate: the distinct shifts supply disjoint nonzero divisor supports for every nontrivial character mode. Its intersection with any fixed-index multiplicative coset has the same relative density up to $O_{s,L,J}(p^{-1/2})$. Thus these examples still lie beyond the previous near-full-coset hypothesis whenever at least one $\ell_j>1$.

This includes every nonempty atom of a fixed finite partition by shifted quadratic-residue signs. Any union of such atoms contains one qualifying atom and inherits the bound, with the omission count measured only in that atom. Shared roots for general $P_j$ require a separate dependence calculation; the private-root hypothesis is sufficient, not claimed necessary.

One may additionally intersect $A_0$ with an ordinary multiplicative coset $t_0C_0$ of bounded index $\ell_0$. First restrict $H$ to a largest coset of $C_0$, exactly as in the preceding coset theorem, and use the initial cover $w^{3\ell_0}=G/t_0^3$, with $a=t_0w^{\ell_0}$. This ensures all three colors lie in $t_0C_0$. It is geometrically integral after separate potential covers by the earlier valuation-one argument for $G$. The further map from this cover to the $(a,q)$ surface is unramified at every divisor $a_i=\zeta_j\ne0$; therefore the private-root argument for the additional residue conditions goes through unchanged. Losing a bounded factor when restricting $H$ changes only the constants. This covers atoms of shifted-residue sign partitions even when the shift zero is among the prescribed tests.

## Limits and next step

The argument broadens a bounded-index multiplicative coset to polynomial-residue palettes of bounded degree with a nonzero simple root, and to the simultaneous private-root conditions in Section 6. It does not prove that every dense palette contains such a family, and it does not prove the six-slot recurrence for arbitrary sets. Shared roots can create dependencies and must not be dismissed.

Primary analytic input remains Tao, *Expanding polynomials over finite fields of large characteristic, and a regularity lemma for definable sets*, https://arxiv.org/pdf/1211.2894, through the previously recorded adaptation. The elementary comparison in Section 5 uses the classical multiplicative-character Weil bound. No new bibliographic priority claim is made here.
