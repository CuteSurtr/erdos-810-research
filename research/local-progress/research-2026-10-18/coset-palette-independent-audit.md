# Quadratic palettes containing a multiplicative coset

18 October 2026. Independent audit of the extension from the full palette to a fixed-index multiplicative coset. The proof passes. It is a further application of the separately audited cube-restricted counting argument; historical priority has not been established.

## Statement and conventions

Fix a positive integer $\ell$. For a sufficiently large prime $p$ with $\ell\mid p-1$, set $C=(\mathbb F_p^*)^\ell$, and fix $t\ne0$. Colors have completions $y=ax+a^2$, and eligible incidences have common potential $h=ay\in H$. The actual selected graph is assumed simple and properly colored, with every four-cycle rainbow.

Let $A\subseteq\mathbb F_p^*$ be its palette. Let

```math
D_0=|tC\setminus A|
```

count missing colors from the target coset, and let $R_0$ count omitted eligible incidences in $(tC\cap A)\times H$. Other colors of $A$ and their incidences are allowed. Then the written counting and multiplicity arguments imply

```math
m\ll_\ell p^{63/32}
 +p^{4/3}(R_0+pD_0)^{1/3}.
\tag{1}
```

In particular a full coset, $D_0=0$, needs no dilation invariance or Fourier-complexity assumption on $H$. For fixed $\ell$, $D_0=o(p)$ and $R_0=o(p^2)$ force $m=o(p^2)$. The implicit constants and the sufficiently-large-prime threshold may depend on $\ell$; no conclusion uniform in growing index is asserted.

## Exact replacement for the cube predicate

For the functions

```math
K(u,v)=\frac{uv(u+v)}{u^2+v^2},\qquad
G(u,v)=-\frac{(u^2+uv+v^2)(u^2+v^2)}{uv(u+v)},
```

replace the previous existence condition by

```math
E_{\ell,t}(u,v)
=1_{\{G(u,v)/t^3\in(\mathbb F_p^*)^{3\ell}\}}.
\tag{2}
```

There is an exact equivalence:

```math
E_{\ell,t}(u,v)=1
\quad\Longleftrightarrow\quad
\exists a\in tC\ \text{with}\ a^3=G(u,v).
\tag{3}
```

Indeed a witness $s^{3\ell}=G/t^3$ gives $a=ts^\ell$. Conversely $a\in tC$ has a representation $a=ts^\ell$, giving the witness. This equivalence uses the image definition of $C$ and does not assume that a particular cube-root choice has the desired class.

## Separate-cover integrality and uniformity

The underlying $K$ correspondence and its four-grid map are unchanged. After arbitrary separate covers of $u,v,z=K(u,v)$, the earlier geometric argument gives an integral function field and an unramified extension of the valuation along

```math
v=\omega u,\qquad K(u,\omega u)=\omega^2u,
```

where $\omega$ is a primitive cube root over the algebraic closure. The valuation of $G$ there is one. Multiplication by the nonzero constant $t^{-3}$ does not alter it. Consequently

```math
T^{3\ell}-G/t^3
```

is Eisenstein at that valuation after every such separate-cover extension. It is therefore irreducible. This proves exactly the stronger Kummer-cover hypothesis needed in the positivity step.

Apply the same fixed-formula regularity and Lang–Weil argument from [the counting audit](partial-rational-expansion-independent-audit.md), based on [Tao's primary paper](https://arxiv.org/pdf/1211.2894). The finite-witness cover degree is now bounded in terms of $\ell$; it remains fixed as $p$ grows. One obtains

```math
T_{\ell,t}(X,Y,Z)
\ge c_\ell\frac{|X||Y||Z|}{p}
-C_\ell p^{15/16}\sqrt{|X||Y|},
\tag{4}
```

where $T_{\ell,t}$ counts pairs satisfying (2) and $K(u,v)\in Z$. Constants are uniform in $t\ne0$: a violating sequence may include varying $t$ as a nonstandard parameter, and the valuation-one proof holds for every such value. All geometry is checked in characteristic zero in that ultraproduct; arbitrary positive-characteristic wild covers are not being treated uniformly.

## Why all three colors lie in the same coset

Choose a largest intersection $H_0=H\cap\lambda C$ after removing zero. Then $|H_0|\ge |H\setminus\{0\}|/\ell$. For $u,v,k\in H_0$, both $k/v$ and $k/u$ belong to $C$. Thus, when $a\in tC$ is supplied by (3), the other colors

```math
b=ak/v,\qquad c=ak/u
```

also lie in $tC$. This is the essential reason a single potential coset suffices. No invariance of $H_0$ under multiplication by $C$ is assumed: $H_0$ is an arbitrary subset of that coset.

Split $H_0$ into disjoint comparable $X,Y$ and set $Z=H_0$. This ensures the same nondegenerate repeated-color configuration as before. Formula (4) supplies at least

```math
c_\ell\frac{|H_0|^3}{p}-C_\ell p^{15/16}|H_0|
\tag{5}
```

such configurations when counted using distinct actual colors $a\in tC$. Each counted pair gives at least one such $a$.

## Root multiplicity and omissions

The count for graph transfer must use distinct $a$-roots, not the auxiliary $s$-witnesses in (3). There are at most three actual $a$-roots per pair. In contrast, multiple $s$ can encode the same $a$; blindly counting them would multiply the incidence upper bound. Formula (5) needs only one actual root per admitted pair, or equivalently is a lower bound for the count of all actual roots, so no witness multiplicity enters.

The earlier incidence calculation applies to this restricted configuration family without change. A fixed omitted color destroys at most $3p$ configurations, and a fixed missing eligible incidence destroys at most sixteen. Hence the count in (5) is at most

```math
3pD_0+16R_0.
\tag{6}
```

Comparison gives

```math
|H_0|\ll_\ell p^{31/32}
 +p^{1/3}(R_0+pD_0)^{1/3}.
```

There are at most $\ell$ potential cosets and $m\le p|H|$, proving (1). Zero potential contributes at most $p-1$ further incidences and is absorbed into its first term. Counting omissions outside the target coset as well is permissible but gives a weaker bound.

## Significance and limits

For example, a complete cube-coset palette is covered even when $H$ is an arbitrary subset of one nontrivial cubic coset, including random subsets with large Fourier norms. This improves the scope over requiring a structured mask or dilation invariance. The underlying input is the same audited finite-cover expansion argument with a higher Kummer exponent; no new exponential-sum theorem is asserted.

This does not apply to every positive-density palette: such a palette need not contain, or nearly contain, any coset of bounded index. No direct source match for this exact affine/common-potential formulation has been established, so originality remains unverified.
