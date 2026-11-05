# Literature and dependency audit, 18 October 2026

This note concerns the quadratic affine common-potential model. It records exact applicability, not a claim of priority. Research is bounded by the authorized stopping time of 10:55 UTC on 18 October 2026.

## Status check

The direct [Erdős problem 810 page](https://www.erdosproblems.com/810) returned HTTP 403 in this session. The search-indexed primary page still labels the problem **open**, with a displayed last edit of 1 April 2026; its crawl was three months old. This does not independently certify the October status. The indexed [primary discussion](https://www.erdosproblems.com/forum/thread/810) contains the known connection to finite-field squares and related four-triple configurations, without an indexed resolution.

A fresh title search did not reveal a straightforward new primary full-text route for Gyárfás–Sárközy–Wagner, *Perfect proper edge colorings of regular bipartite graphs with rainbow C4-s*, DOI [10.1016/j.disc.2026.115005](https://doi.org/10.1016/j.disc.2026.115005). The full-text gap from the earlier audit remains. Previously unsuccessful publisher routes were not retried. No conclusion here depends on guessing that paper's contents.

## Exact configuration to be forced

Let $A\subseteq\mathbb F_p^\times$ and $H\subseteq\mathbb F_p$. Color $a$ consists of the edges

```math
y=ax+a^2,\qquad ay\in H.
```

In coordinates $(a,h)$, these are $(x,y)=(h/a^2-a,h/a)$. Properness is equivalent to the absence of distinct $a,b\in A$ for which both $-a^2b$ and $-ab^2$ lie in $H$.

For a repeated-color rectangle with opposite color $a$, let the other two colors be $ar,at$, and let the diagonal potentials be $a^3F,a^3G$. Outside $rt=1$,

```math
F(r,t)=\frac{t(r^2-r+t-1)}{1-rt},\qquad
G(r,t)=\frac{r(t^2-t+r-1)}{1-rt}.
```

The seven tests are

```math
a,ar,at\in A,\qquad
a^3F,a^3G,ra^3G,ta^3F\in H.
```

Degenerate choices must separately be removed. A theorem for three shared-base polynomial slots does not automatically count this system.

The additive-progression subfamily $a,a\pm t$ asks for $a^3\pm a^2t$ and $a(a\pm t)^2$ in $H$. Its zero-parameter base point pins $a^3\in H$, which need not hold. Holding the first diagonal potential at $ca^3$ instead gives

```math
c(1-rt)=rt(r-1)+t(t-1).
```

This is an additional algebraic relation, not a free polynomial difference parameter.

## Kousek: an applicable framework with an explicit missing hypothesis

Ioannis Kousek, *Revisiting sums and products in countable and finite fields*, [published version](https://doi.org/10.1017/etds.2025.10244), *Ergodic Theory and Dynamical Systems* **46** (2026), 543–574; online 13 October 2025. [Published full text](https://www.cambridge.org/core/journals/ergodic-theory-and-dynamical-systems/article/revisiting-sums-and-products-in-countable-and-finite-fields/73D0FF86C278C9D38A3ACCEACF634124). The [arXiv v1](https://arxiv.org/pdf/2407.03304) has different theorem numbering.

- Published Theorem 1.15: for a finite field $F$, a nonconstant polynomial $P$ of degree $q<\operatorname{char}F$, and $B_1,B_2\subset F$ with $|B_1||B_2|>2(q+2)|F|^{2-2^{-(q-1)}}$, there are nonzero $u,v$ with $uv\in B_1$ and $P(u)+v\in B_2$.
- Published Theorem 1.20: $|B_1||B_2||B_3|\ge8|F|^{5/2}$ forces $u+v\in B_1$, $uv\in B_2$, $u\in B_3$.
- The countable-field triple-recurrence theorem assumes ergodicity of the additive subgroup action. Section 8, Conjectures 8.1 and 8.3, explicitly leaves the general diagonal affine action on $F^m$, including product sets, unproved.

These statements do not preserve all seven tests above. Passing to a product space to encode them loses precisely a hypothesis needed by the established recurrence theorem. Its partition-regularity conclusions also cannot be substituted for a statement about two prescribed dense sets $A,H$.

## Two genuine multiplicative actions, but no closed recurrence reduction

Write $u=a^3$ and $h=ay$. Changing $a$ to $ra$ while preserving the original graph row gives

```math
T_r(u,h)=(r^3u,\ r^2h+r^2(r-1)u).
```

Preserving the original graph column instead gives

```math
U_r(u,h)=(r^3u,\ rh).
```

Direct calculation gives $T_rT_s=T_{rs}$ and $U_rU_s=U_{rs}$. However,

```math
U_{1/r}T_r(u,h)=(u,\ rh+ur(r-1))
```

is not a multiplicative group action as a family in $r$. Thus the existence of two triangular actions is not itself a group-table or commuting-action encoding of the required rectangle. No recurrence theorem has been verified for this exact closure constraint.

## Tao's algebraic expansion theorem: what it would and would not give

Terence Tao, [*Expanding polynomials over finite fields of large characteristic, and a regularity lemma for definable sets*](https://arxiv.org/pdf/1211.2894), Theorems 38 and 40, PDF pp.34–38, treats regular maps $P:V\times W\to U$ of geometrically irreducible quasiprojective varieties. If the four-output map from a $2\times2$ input grid is dominant, Theorem 38 gives almost-complete coverage of **one** cell in a bounded definable partition of $U$. Theorem 40 gives almost-full coverage of $U$ only after a further obstruction involving reducibility under dominant covers is excluded.

For the three-potential subfamily supplied in this pass, the rational function

```math
K(x,y)=\frac{xy(x+y)}{x^2+y^2}
```

is a regular map $\mathbb G_m^2\to\mathbb P^1$ in odd characteristic: numerator and denominator have no simultaneous zero there. Therefore its rationality alone does not prevent use of this framework. But moderate expansion need not hit the prescribed set $H$, and merely excluding an additive or multiplicative form does not exclude the extra cover obstruction. Moreover the required cube condition and the three palette memberships remain additional constraints. No unconditional application to the common-potential model has been established.

## Verified classical exponential-sum input

Nicholas Katz, [*Estimates for “Singular” Exponential Sums*](https://web.math.princeton.edu/~nmk/ESES.pdf), *IMRN* 1999 no.16, 875–899, opening statement on printed p.875: for a finite field $k$, a nontrivial additive character, and a polynomial of degree $d$ with $\operatorname{char}(k)\nmid d$, the smooth-top-form hypothesis gives the bound $(d-1)^n|k|^{n/2}$. The text explicitly notes that this smoothness condition is automatic in one variable. Consequently, for $1\le d<p$,

```math
\left|\sum_{x\in\mathbb F_p}e_p(P(x))\right|
\le(d-1)\sqrt p.
```

The degree-one sum is zero. This supplies the precise classical input for the fixed-degree extension of the already audited oscillatory affine estimate. It is not a new exponential-sum result.

## Verified matrix-concentration input

Joel Tropp, [*User-Friendly Tail Bounds for Sums of Random Matrices*](https://arxiv.org/pdf/1004.4389), Theorem 1.6, printed p.5: for independent mean-zero $d_1\times d_2$ matrices $Z_k$ with $\|Z_k\|\le R$, set

```math
\sigma^2=\max\!\left\{
\left\|\sum_k\mathbb E Z_kZ_k^*\right\|,
\left\|\sum_k\mathbb E Z_k^*Z_k\right\|
\right\}.
```

Then

```math
\Pr\!\left(\left\|\sum_k Z_k\right\|\ge t\right)
\le(d_1+d_2)\exp\!\left(-\frac{t^2}{2(\sigma^2+Rt/3)}\right).
```

This is suitable for the independent random-potential support construction after checking its matrix decomposition, centering, uniform norm, and both variance sums. Those checks belong to the construction's separate audit.

## Current verdict

The retrieved primary statements do not by themselves resolve arbitrary common-potential supports. The closest affine-action source explicitly marks a needed higher-dimensional recurrence extension as conjectural. A later investigation in this pass verifies the geometric hypotheses for a specific rational subfamily; see the update below. Neither absence of an exact search hit nor similarity of proof techniques certifies novelty of the local oscillatory estimate or its support consequences.

## Further comparison: density-regular quadratic equations

Donoso, Le, Moreira and Sun, [*Additive averages of multiplicative correlation sequences and applications*](https://wrap.warwick.ac.uk/id/eprint/172508/1/WRAP-additive-averages-multiplicative-correlation-sequences-applications-Moreira-2023.pdf), accepted manuscript, Section 6, printed pp.35–37, studies finite-field quadratic density questions. Proposition 6.2 supplies $x,y$ in a dense set with $x^2+y^2$ a square; the square root is unrestricted. Proposition 6.4 characterizes the diagonal equations $ax^2+by^2+cz^2=0$ that have solutions in every dense set by the condition $a+b+c=0$. Its positive argument passes to the set of squares and applies finite-group Szemerédi. Neither statement includes the cross-term equation below. Diagonalizing that equation mixes coordinates and does not preserve the three independent set memberships. The paper's multiplicative-action recurrence theorems likewise concern different families of shifts, so no direct application has been established.

Arala and Chow, [*Expansion properties of polynomials over finite fields*](https://arxiv.org/pdf/2403.03732), published as [*Finite Fields and Their Applications* 108 (2025), 102687](https://doi.org/10.1016/j.ffa.2025.102687), Corollary 1.4 and Lemma 1.5, gives almost-full image coverage for appropriate ternary quadratics on dense Cartesian products. In particular it applies to

```math
Q(u,v,w)=u^2+v^2-w(u+v).
```

The form depends on every variable, is non-diagonal, and is not a square. The conclusion is that $Q(B_1,B_2,B_3)$ misses only $O_\delta(1)$ field elements when each $B_i$ has density at least $\delta$. This does not force a specified target such as zero, nor does it guarantee a non-diagonal zero. It therefore does not alone prove the required rational recurrence.

## The equal-cross subfamily and the new geometric verification

The subfamily with the two crossed potentials equal reduces the four $H$ tests to

```math
x,\ y,\ k=\frac{xy(x+y)}{x^2+y^2}\ \in H.
```

With $u=1/x$, $v=1/y$, $w=1/k$, its equation becomes $u^2+v^2=w(u+v)$. The remaining color condition is

```math
a^3=-\frac{(x^2+xy+y^2)(x^2+y^2)}{xy(x+y)},
\qquad a,\frac{ak}{y},\frac{ak}{x}\in A.
```

The companion [geometric proof](rational-expander-cover-proof.md) now checks the four-output Jacobian and excludes every separate-cover obstruction for $K$ in characteristic zero. The latter uses simple nonvertical and nonhorizontal fibre components and inertia groups. It also checks that the added cube cover remains integral after arbitrary separate covers of $x,y,k$, using its simple zero along $y=\omega x$ and the identity $K(x,\omega x)=\omega^2x$. Both geometric calculations passed an independent audit during this pass.

The direct consequence of Tao's existing theorem is strong expansion of $K$ itself. Including the cube condition requires extending the theorem's proof to a finite cover of the graph, because the allowed input pairs no longer form a Cartesian product. That extension is being audited separately. The arbitrary restricted palette $A$ is an additional requirement even after the cube condition is handled. No inspected source states this exact affine/common-potential application, but originality remains unestablished.
