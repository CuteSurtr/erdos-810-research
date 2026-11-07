# Many closing paths force a quadratic part of the base permutation

18 October 2026. This is a structural result for the completed quadratic incidence family. It converts positive-density pointwise path closure at many centers into positive-density agreement of the base permutation with a fixed quadratic map. The complete written proof has passed an independent audit, including its second-moment count, character norms, path degeneracies, and constants. Historical novelty is unverified. The completed incidence family is improper, so the theorem is not a B-coloring extremal bound or a solution of Erdős #810.

## Statement

Let $p$ be odd, let $h:\mathbb F_p\to\mathbb F_p$ be any permutation, and add $h$ as an external base matching to the completed family

```math
f_b(x)=bx+b^2,\qquad b\in\mathbb F_p^\times.
```

A color set $B_x\subseteq\mathbb F_p^\times$ is good at $x$ if every six-vertex simple path of color pattern base, $b$, $c$, base, $b$, with third vertex $x$ and distinct $b,c\in B_x$, has a closing edge of some nonzero color in the completed quadratic family.

Fix $0<\delta\le1$ and suppose $\delta p\ge20$. If more than $48\delta^{-3}$ centers possess good sets of size at least $\delta p+2$, then

```math
\#\{r\in\mathbb F_p:h(r)=-r^2/4\}
>\frac{\delta^{3/2}}8p.                              \tag{1}
```

Equivalently, unless the base agrees with this quadratic on the indicated positive fraction of the field, at most $48\delta^{-3}$ centers can have such good sets. The bound is uniform over all permutations, including nonlinear ones.

## 1. A global second-moment estimate

Put

```math
R(r)=r^2+4h(r),\qquad
Z_0=\{r:R(r)=0\},\qquad z=|Z_0|.
```

For a row $x$ and a color $b\ne0$, define

```math
r_b=h^{-1}(bx+b^2),\qquad
F_x(b)=\frac{r_b^2}{4b}+b.
```

For each field value $\zeta$, let $n_x(\zeta)$ count those $b\ne0$ with $R(r_b)\ne0$ and $F_x(b)=\zeta$. Define

```math
E_x=\sum_\zeta n_x(\zeta)^2.
```

Then

```math
\sum_xE_x\le3p(p-1).                                \tag{2}
```

To prove this, put $t=\zeta+x$. Since $h(r_b)=bx+b^2$,

```math
R(r_b)=4b(F_x(b)+x)=4bt.
```

For the nonexceptional colors counted in $n_x$, $t\ne0$ and

```math
b=R(r)/(4t).
```

Associate to each $r\notin Z_0$ the point

```math
P(r)=(U,V)=\bigl(R(r),h(r)/R(r)\bigr).
```

The map is injective, because $U,V$ determine $h(r)=UV$ and $h$ is a permutation. Substitution gives the line equation

```math
V=\frac{U}{16t^2}+\frac{x}{4t}.                      \tag{3}
```

Each pair $(r,t)$ with $r\notin Z_0$, $t\ne0$ determines one counted triple $(x,\zeta,b)$, since (3) determines $x$ and then $\zeta=t-x$. Conversely each counted triple recovers $(r,t)$.

The diagonal pairs in $\sum_x\sum_\zeta n_x(\zeta)^2$ number at most $p(p-1)$. For two distinct points $P(r),P(r')$, equality of the corresponding fibers requires the same $t$, because $t=x+\zeta$. If their $U$ coordinates coincide there is no common line of the form (3). Otherwise their common line has a uniquely determined slope; a nonzero slope determines at most two values of $t$ through $1/(16t^2)$. Each $t$ determines $x,\zeta$. Thus the off-diagonal contribution is at most $2p(p-1)$, proving (2).

## 2. Character-sum bound for a good set

Let $B$ be a good set at $x$, and first delete the at most two colors satisfying $r_b=x$. Write $k$ for the remaining size. Let

```math
k_0=\#\{b\in B:r_b\in Z_0\}.
```

For each fixed $r$, the equation $bx+b^2=h(r)$ has at most two roots, so $k_0\le2z$.

The path determined by $(b,c)$ starts at $r_b$ and ends at $b(r_c+b)$. A closing color solves

```math
d^2+r_bd-b(r_c+b)=0,
```

with discriminant

```math
\Delta_x(b,c)=r_b^2+4b(r_c+b)
=4b\bigl(F_x(b)+r_c\bigr).
```

Let $\chi$ be the quadratic character, with $\chi(0)=0$, and set

```math
S=\sum_{b,c\in B}\chi(\Delta_x(b,c)).
```

Push the first color variable forward under $F_x$, with sign $\chi(b)$, and the second under $c\mapsto r_c$. The latter map has fibers of size at most two, so its counting function has squared $\ell^2$ norm at most $2k$. The exceptional first-variable colors all satisfy $F_x(b)=-x$, while nonexceptional colors never have that value. Hence the signed first-variable function has squared norm at most

```math
k_0^2+E_x.
```

The quadratic-character matrix $T_{s,t}=\chi(s+t)$ has $TT^*=pI-J$ and operator norm $\sqrt p$. Consequently

```math
|S|\le\sqrt{2pk(k_0^2+E_x)}.                        \tag{4}
```

## 3. Simple-path degeneracies

After removing the colors with $r_b=x$, at most $4k$ ordered pairs fail to give a simple path:

- $r_b=r_c$ is equivalent to $b=c$ or $b+c=-x$, giving at most $2k$ pairs.
- The last column equals the fourth when $b r_c+b^2=h(r_c)$, a quadratic equation in $b$ for each $c$, giving at most $2k$ pairs.

The last column cannot equal the first, since $f_b(r_c)=f_b(x)$ would imply $r_c=x$. These exhaust equalities within the two bipartition classes.

For every remaining pair, the closing property forces $\chi(\Delta_x(b,c))\ge0$. For each fixed $b$, zero discriminant fixes the value of $r_c$ and hence permits at most two colors $c$. There are at most $2k$ zero terms. Giving the excluded pairs their worst possible value $-1$ yields

```math
S\ge k^2-10k.
```

If $k\ge20$, this is at least $k^2/2$. Combining with (4) gives

```math
E_x+4z^2\ge E_x+k_0^2\ge\frac{k^3}{8p}.             \tag{5}
```

## 4. Conclusion

An original good set of size at least $\delta p+2$ leaves $k\ge\delta p\ge20$ after the two deletions. If

```math
z\le\delta^{3/2}p/8,
```

then (5) implies $E_x\ge\delta^3p^2/16$ at each such center. By (2), there are at most $48\delta^{-3}$ such centers. The contrapositive is (1).

The [explicit nonlinear base](nonlinear-base-closure.md) has $z=(p+1)/2$ for primes $p\equiv3\pmod4$, consistent with the theorem. This is the largest possible agreement size for any permutation: among each pair $r,-r$ with $r\ne0$, at most one can satisfy $h(r)=-r^2/4$, and zero adds at most one point.

## Limits

The hypothesis concerns every genuine path using the selected colors in the completed family. In an actual partial graph many continuations may be absent, making path closure much weaker or vacuous. The theorem does not automatically transfer to those partial matchings. The exact missing continuation and closing-support conditions are recorded in [the nonlinear-base note](nonlinear-base-closure.md), Section 3.

The algebraic agreement is with the base permutation $h$, not with the original arbitrary color permutations in Erdős #810. No reduction from the unrestricted problem to this quadratic family has been proved. The result is a concrete pointwise-to-algebraic structural implication within this family, with historical novelty still unverified.
