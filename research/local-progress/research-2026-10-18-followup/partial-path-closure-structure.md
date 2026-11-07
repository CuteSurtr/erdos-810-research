# Partial paths force quadratic agreement unless continuation or closure fails

18 October 2026. The theorem and constants below passed an independent written audit. It strengthens [the completed-family structural theorem](path-closure-structure.md) by making the missing incidences explicit in an actual simple colored graph. Historical novelty is unverified. No reduction from unrestricted Erdős #810 to this quadratic family is claimed.

## 1. Actual graph and deficiency counts

Let $p$ be odd and let $h:\mathbb F_p\to\mathbb F_p$ be a permutation. Consider a simple bipartite edge-colored graph on two copies of $\mathbb F_p$. It contains the complete matching

```math
r\longmapsto h(r)
```

in a designated base color. Every other available color is indexed by some $b\in\mathbb F_p^\times$, and its retained edges form a subset of

```math
f_b(r)=br+b^2.
```

There is at most one color on each ordered endpoint pair. Each color is automatically a matching. The complete base matching is an explicit hypothesis.

At a center $x$, choose any set $B_x$ of colors whose edges from $x$ are retained, and put $k_x=|B_x|$. For $b\in B_x$ set

```math
r_b=h^{-1}(bx+b^2).
```

Simplicity and the retained base matching imply that the $r_b$ are distinct and none equals $x$.

Define $D_x$ to be the number of ordered pairs $(b,c)\in B_x^2$ for which the continuation edge of color $b$ from $r_c$ is absent. If it is present and $b\ne c$, the five-edge path

```math
(r_b,\ f_b(x),\ x,\ f_c(x),\ r_c,\ f_b(r_c))       \tag{1}
```

is simple. Define $Q_x$ to be the number of these retained simple paths for which there is no edge between the two endpoints in the actual graph. Thus $D_x$ counts missing continuations and $Q_x$ counts failures of actual closing-edge existence. In particular, an actual path-closure hypothesis sets $Q_x=0$ but does not set $D_x=0$.

Let

```math
z=\#\{r\in\mathbb F_p:h(r)=-r^2/4\}.               \tag{2}
```

## 2. Quantitative structural theorem

Fix $0<\delta\le1$ and $0<\eta<1/2$, with $\delta p\ge3/\eta$. If more than

```math
4\eta^{-2}\delta^{-3}
```

centers have sets $B_x$ satisfying

```math
k_x\ge\delta p,\qquad
D_x+Q_x\le(1/2-\eta)k_x^2,                          \tag{3}
```

then

```math
z>\frac{\eta\delta^{3/2}}2p.                         \tag{4}
```

Consequently, if the base has smaller agreement with the fixed quadratic, then at all but a bounded number of centers with linearly many retained central colors, at least approximately half the potential continuations either are missing or fail to close in the actual graph. The bound on exceptional centers is independent of $p$.

There is also a direct closed-path version: the same conclusion holds if more than the indicated number of centers have $k_x\ge\delta p$ and at least $(1/2+\eta)k_x^2$ ordered pairs giving retained, actually closed simple paths. The weaker size requirement $\delta p\ge1/\eta$ suffices for that version.

## 3. Proof and checked constants

Use the energy from the completed-family theorem:

```math
R(r)=r^2+4h(r),\qquad
F_x(b)=r_b^2/(4b)+b,
```

and let $E_x$ be the sum of squared fiber sizes of $F_x$ over all nonzero colors with $R(r_b)\ne0$. The previously proved injective point-line encoding gives

```math
\sum_{x\in\mathbb F_p}E_x\le3p(p-1).               \tag{5}
```

For completeness, that encoding is $r\mapsto(U,V)=(R(r),h(r)/R(r))$ on $R(r)\ne0$. It is injective because $h$ is a permutation. Setting $t=F_x(b)+x\ne0$ gives

```math
b=U/(4t),\qquad V=U/(16t^2)+x/(4t).
```

Diagonal point pairs contribute at most $p(p-1)$ to the energy sum. Distinct point pairs determine at most one nonvertical line, whose slope determines at most two values of $t$. They contribute at most $2p(p-1)$, proving (5).

Write $k=k_x$. The closing equation for (1) is

```math
d^2+r_bd-b(r_c+b)=0,
```

with discriminant $\Delta_x(b,c)=4b(F_x(b)+r_c)$. A base-colored closing edge is impossible: it would require $f_b(r_c)=h(r_b)=f_b(x)$ and hence $r_c=x$. Therefore every actually closed path supplies a nonzero quadratic-family color and has square or zero discriminant.

Let $C_x$ count retained, actually closed simple paths and set

```math
S_x=\sum_{b,c\in B_x}\chi(\Delta_x(b,c)),
```

where $\chi(0)=0$. Each fixed $b$ gives at most one zero discriminant, since the $r_c$ are distinct. Thus

```math
S_x\ge2C_x-k^2-k.                                  \tag{6}
```

If a continuation is retained and $b\ne c$, the three rows in (1) are distinct. Its last column cannot equal $f_b(x)$ by injectivity of $f_b$ and $r_c\ne x$. It cannot equal $f_c(x)=h(r_c)$ because that would assign both the base color and color $b$ to the same edge. Hence all such paths are simple. Only the $k$ diagonal pairs need to be excluded, so

```math
C_x\ge k^2-k-D_x-Q_x.
```

Combining with (6) gives the exact useful lower bound

```math
S_x\ge k^2-2(D_x+Q_x)-3k.                           \tag{7}
```

For the upper bound, push $b$ forward through $F_x$ with sign $\chi(b)$, and push $c$ forward through $r_c$. The second counting function has squared norm $k$, since these $r_c$ are distinct. The colors with $R(r_b)=0$ all have $F_x(b)=-x$, and there are at most $z$ of them. No other colors have this value. The signed first function therefore has squared norm at most $E_x+z^2$. Since the quadratic-character convolution matrix has norm $\sqrt p$,

```math
|S_x|^2\le pk(E_x+z^2).                            \tag{8}
```

Under (3) and $k\ge3/\eta$, (7) gives $S_x\ge\eta k^2$. Thus

```math
E_x+z^2\ge\eta^2 k^3/p\ge\eta^2\delta^3p^2.       \tag{9}
```

If (4) fails, then $z^2\le\eta^2\delta^3p^2/4$, and every such center has $E_x\ge3\eta^2\delta^3p^2/4$. Summing and applying (5) allows at most $4\eta^{-2}\delta^{-3}$ centers. This proves the theorem. For the direct closed-path version, (6) gives $S_x\ge2\eta k^2-k\ge\eta k^2$ when $k\ge1/\eta$, and the same proof applies.

## 4. Exact incidence deficits in a common-potential model

Suppose the quadratic part uses an actual palette $A$ and a common potential set $H$, with an incidence of color $b$ at row $r$ eligible precisely when

```math
b^2(r+b)\in H.
```

The central incidences are retained by the choice of $B_x\subseteq A$. The continuation potential is

```math
T_x(b,c)=b^2(r_c+b).
```

Define $U_x$ to count pairs with $T_x(b,c)\notin H$, and $V_x$ to count pairs with $T_x(b,c)\in H$ whose eligible continuation incidence was omitted. Then exactly

```math
D_x=U_x+V_x.                                        \tag{10}
```

This distinguishes support failure from deletion of an eligible incidence. The theorem therefore applies when $U_x+V_x+Q_x\le(1/2-\eta)k_x^2$ on many centers. It does not silently replace this condition by central membership in $H$.

If $R_{\rm omit}$ is the total number of omitted eligible incidences, then

```math
\sum_xV_x\le(p-1)R_{\rm omit}.                      \tag{11}
```

Indeed, a specified omitted incidence fixes its color $b$ and row $r$. To contribute at a center $x$, some $c\in B_x$ must satisfy $r_c=r$, or $cx+c^2=h(r)$. Each nonzero $c$ determines a unique $x$. There are at most $p-1$ such colors; the central-neighbor injectivity prevents duplicate choices at a fixed $x$.

## 5. Aggregate alternative

For any set $X$ of centers, put $s=|X|$, $L=\sum_{x\in X}k_x$, and $T=\sum_{x\in X}k_x^2$. Summing (7), applying (8), and using Cauchy–Schwarz and (5) yields

```math
\sum_{x\in X}(D_x+Q_x)
\ge\frac12\left[
T-3L-\sqrt{pL\bigl(3p(p-1)+s z^2\bigr)}
\right].                                           \tag{12}
```

For example, along a sequence with $T\gg p^3$ and $z=o(p)$, the square-root term is $o(p^3)$, because $L\le p^2$ and $s\le p$. Hence missing continuations or failed closings account for at least $(1/2-o(1))T$ pairs. If all retained simple paths close, $Q_x=0$. If in addition $R_{\rm omit}=o(p^2)$, equations (10)–(11) show that support failures alone satisfy

```math
\sum_{x\in X}U_x\ge(1/2-o(1))T.
```

Thus a base far from quadratic agreement cannot combine dense central incidence, substantially more than half of the potential continuations retained, and actual path closure. The remaining task is to prove or disprove such continuation density from the relevant graph hypotheses; it is not established here.
