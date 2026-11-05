# Fractional path closure for the quadratic affine family

18 October 2026. This is a research note on the path-closing condition in Theorem 2.7 of Gyárfás–Sárközy–Wagner, *Perfect proper edge colorings of regular bipartite graphs with rainbow C4-s*, Discrete Mathematics 349 (2026), 115005, [published article](https://doi.org/10.1016/j.disc.2026.115005). The complete publisher text, including its proof, was inspected.

## Status

The calculation below gives a quantitative obstruction: the completed quadratic affine family has no large set of good colors for the paper's path-closing condition relative to **any affine base bijection**. The bound is elementary and uses the quadratic-character matrix. It does not address arbitrary nonlinear base bijections, and it does not prove an extremal improvement on Erdős #810. Its historical novelty has not been established.

## 1. Uniform obstruction for every affine base

Let $p$ be odd. Consider the colored incidences

```math
f_a(x)=ax+a^2,
\qquad a\in\mathbb F_p^\times,
```

with every color defined at every row. This is an ambient colored multigraph: different affine lines can meet, so its full completion need not be a proper coloring. Add an external base matching $f_0(x)=\beta x+\gamma$, where $\beta\ne0$. Its new color is distinct from all original colors, even if its map coincides with one original map.

Fix a row $x$. A set $B$ of non-base colors has the closing property at $x$ if every six-vertex simple path with pattern base, $b$, $c$, base, $b$, with third vertex $x$ and distinct $b,c\in B$, has a closing edge belonging to the quadratic affine family. Allowing any nonzero color for the closing edge is the weakest possible restriction; restricting the closing palette only strengthens the conclusion.

**Proposition.** Every such set satisfies

```math
|B|\le \sqrt{8p}+12.
```

Consequently, no affine choice of base bijection can give a fixed positive fraction of good colors at even one vertex when the palette has positive density in the field.

### Proof

Changing coordinates $x=\beta X$, $y=\beta^2Y$, and writing the old color as $a=\beta b$, reduces to

```math
f_b(X)=bX+b^2,
\qquad f_0(X)=X+s,
\qquad s=\gamma/\beta^2.
```

Use the base matching to identify column labels with row labels, so that

```math
g_b(x)=f_0^{-1}f_b(x)=bx+b^2-s.
```

The path associated with $(b,c)$ is

```math
\bigl(g_b(x),\ f_b(x),\ x,\ f_c(x),\ g_c(x),\ f_b(g_c(x))\bigr).
```

Writing $r=g_b(x)$ and $y=f_b(g_c(x))$, a closing edge of color $d$ requires

```math
d^2+rd-y=0.
```

Its discriminant is

```math
\Delta_x(b,c)
=(bx+b^2-s)^2+4b(cx+c^2-s)+4b^2
=4b\bigl(P_x(c)+F_x(b)\bigr),
```

where

```math
P_x(c)=c^2+xc,
\qquad
F_x(b)=\frac{(bx+b^2-s)^2}{4b}+b-s.
```

Each fiber of $P_x$ has at most two elements. Each fiber of $F_x$ on $\mathbb F_p^\times$ has at most four elements, since clearing the denominator gives a monic quartic in $b$.

Let $\chi$ be the quadratic character, with $\chi(0)=0$. For any $B\subseteq\mathbb F_p^\times$ of size $k$, put

```math
S=\sum_{b,c\in B}\chi(\Delta_x(b,c)).
```

Define functions on the field by

```math
u(z)=\sum_{\substack{b\in B\\F_x(b)=z}}\chi(b),
\qquad
v(w)=\#\{c\in B:P_x(c)=w\}.
```

Then $\|u\|_2^2\le4k$ and $\|v\|_2^2\le2k$, and

```math
S=\sum_{z,w}u(z)v(w)\chi(z+w).
```

The matrix $T_{z,w}=\chi(z+w)$ satisfies

```math
TT^*=pI-J.
```

Indeed, the diagonal inner product is $p-1$, while for $z\ne z'$ the substitution $t=(w+z)/(w+z')$ gives the inner product $-1$. Hence $\|T\|_{2\to2}=\sqrt p$ and

```math
|S|\le\sqrt{8p}\,k. \tag{1}
```

At most two colors satisfy $g_b(x)=x$. Remove these colors from the original good set and denote the remaining set again by $B$, of size $k$. A pair $(b,c)\in B^2$ can fail to define a simple six-vertex path only in the following cases:

- $g_b(x)=g_c(x)$, equivalently $b=c$ or $b+c=-x$; at most $2k$ ordered pairs.
- $g_b(g_c(x))=g_c(x)$; for each $c$, this is a monic quadratic equation in $b$, hence contributes at most $2k$ ordered pairs.

The other possible equality between the last column and the first is $g_b(g_c(x))=g_b(x)$, which would imply $g_c(x)=x$ and has already been excluded. Equality of vertices in different bipartition classes is irrelevant. Thus at most $4k$ pairs are excluded, including all $b=c$ pairs.

For every remaining pair, the closing property forces $\chi(\Delta_x(b,c))\ge0$. At most $2k$ pairs have zero discriminant, because for each $b\ne0$ it is a quadratic polynomial in $c$ with nonzero leading coefficient. The excluded pairs contribute at worst $-1$ each. Consequently

```math
S\ge k^2-2(4k)-2k=k^2-10k.
```

Combining with (1) proves $k\le\sqrt{8p}+10$. Restoring the at most two removed colors proves the proposition.

## 2. Quantitative obstruction for partial matchings

The same calculation applies before completing the actual partial graph. Suppose all central incidences $f_b(x)$, $b\in B$, are retained, and let $Q$ count ordered pairs $(b,c)\in B^2$ that give a simple path of the displayed form in the partial graph. This additionally requires the incidence of color $b$ at $g_c(x)$ to be retained. If all these actual paths have closing edges, then

```math
Q\le \#\{(b,c)\in B^2:\chi(\Delta_x(b,c))\ge0\}
\le \frac{k^2}{2}+\sqrt{2p}\,k+k.
```

Here the final inequality follows from (1) and the at most $2k$ zero discriminants. Thus a good-color set of positive density must omit asymptotically at least half of its possible cross-color continuations. A merely positive density of continuations does not contradict the paper's hypothesis; it must exceed one half for this elementary argument to force a contradiction.

For the common-potential model, the continuation at $g_c(x)$ has potential

```math
b^2g_c(x)+b^3=b^2(cx+c^2-s)+b^3.
```

Membership of the central potentials $b^2x+b^3$ and $c^2x+c^3$ in $H$ provides no automatic membership of this value. This is an explicit location of the missing incidence-existence input.

## 3. Interpretation and limitations

The 2026 paper allows arbitrary base bijections, whereas the proposition treats all affine base bijections only. The full quadratic completion is not itself a proper graph, so this calculation should not be advertised as a new counterexample to that paper or as a stand-alone extremal theorem. It is a quantitative obstruction to a natural attempted reduction and a precise estimate for what partial-color continuation would have to supply.

The argument is uniform in $x,\beta,\gamma$ and does not rely on finite computations, Weil estimates, or unproved cancellation. The exact quadratic-character matrix identity is enough.
