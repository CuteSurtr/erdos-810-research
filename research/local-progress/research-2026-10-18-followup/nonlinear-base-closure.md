# Positive-density path closure from a nonlinear base

18 October 2026. This construction shows that the affine-base obstruction does not extend to arbitrary base bijections. It concerns the completed quadratic incidence family, which is improper. The exact statement and all degeneracies were checked in the [independent audit](nonlinear-base-independent-audit.md). It is not a construction of a dense B-coloring or a solution of Erdős #810.

## 1. A base permutation with many closing paths

Let $p\equiv3\pmod4$, and let $\chi$ denote the quadratic character. Define

```math
h(0)=0,\qquad h(r)=-\chi(r)r^2/4\quad(r\ne0).
```

This is a permutation. On the quadratic residues it is $r\mapsto-r^2/4$, a bijection onto the nonresidues. On the nonresidues it is $r\mapsto r^2/4$, a bijection onto the residues. These bijectivities use $\chi(-1)=-1$: the two roots of a nonzero square belong to opposite quadratic classes.

Consider the full colored incidence family

```math
f_b(x)=bx+b^2,\qquad b\in\mathbb F_p^\times,
```

and add $h$ as an external base matching. For every $x\ne0$, set $\epsilon=\chi(x)$ and

```math
B_x=\{b:\chi(b)=\epsilon,\ \chi(b+x)=-\epsilon\}.
```

The cardinality is exactly

```math
|B_x|=(p+1)/4.                                      \tag{1}
```

Indeed, setting $b=xt$ changes the conditions to $\chi(t)=1$, $\chi(t+1)=-1$. Expand $(1+\chi(t))(1-\chi(t+1))/4$ and use $\sum_t\chi(t(t+1))=-1$. The terms at $t=0,-1$ both vanish, so no endpoint correction is needed.

For $b\in B_x$, write

```math
r_b=h^{-1}(f_b(x)).
```

Because $f_b(x)=b(x+b)$ is a nonresidue, $r_b$ is the unique quadratic-residue root of

```math
r_b^2=-4b(x+b).                                    \tag{2}
```

The conic in (2) is parametrized by

```math
b=-\frac{xv^2}{1+v^2},\qquad
r_b=\frac{2xv}{1+v^2}.
```

There are no zero denominators over the field. For $b(b+x)\ne0$, all conic points arise from nonzero finite $v$. Direct subtraction gives

```math
\frac{r_b-x}{b}=\frac{(v-1)^2}{v^2}.                 \tag{3}
```

Consequently $r_b-x$ has character $\chi(b)=\epsilon$, unless it is zero.

For $b,c\in B_x$, the path with color pattern base, $b$, $c$, base, $b$ and third vertex $x$ is

```math
(r_b,\ f_b(x),\ x,\ f_c(x),\ r_c,\ f_b(r_c)).
```

A closing color $d$ solves

```math
d^2+r_bd-b(r_c+b)=0.
```

Its discriminant, using (2), is

```math
\Delta=r_b^2+4b(r_c+b)=4b(r_c-x).
```

By (3), this is a square or zero. There is always a nonzero root $d$. If one root is zero the other is $-r_b\ne0$; a repeated root is $-r_b/2\ne0$. Thus every simple six-vertex path of the stated form has a closing edge in the full quadratic family, at every center $x\ne0$.

The central colors can share a neighbor only through $b\mapsto-x-b$. This involution preserves $B_x$. Choosing one representative from each orbit leaves at least $(p+1)/8$ colors with distinct central neighbors. The possible fixed point $b=-x/2$ belongs to $B_x$ only when $\chi(2)=-1$.

## 2. What the construction does and does not imply

The earlier affine-base theorem bounds the number of good colors by $O(\sqrt p)$ for every affine base. The present single nonlinear permutation gives a positive fraction of good colors simultaneously at every nonzero center. This establishes that any obstruction restricted to affine bases cannot by itself exclude the 2026 paper's broader arbitrary-base definition.

The completed family is not a proper graph: distinct color lines meet. Choosing distinct central neighbors at one center does not repair the global coloring. Also, a closing edge in the completed family may be absent from the actual partial graph, either because its color is unavailable or because its potential is outside the common support. Those distinctions prevent an application of the paper's theorem without additional arguments.

## 3. Exact common-potential gaps

For the common-potential model, the two central incidences have potentials

```math
U=b^2(x+b),\qquad V=c^2(x+c).
```

The continuation of color $b$ at row $r_c$ has column and potential

```math
y=b(r_c+b),\qquad T=by=b^2(r_c+b).                   \tag{4}
```

This continuation exists in the actual graph only if $T\in H$ and the incidence is retained. If $d$ is a closing color, its potential is

```math
W=dy=(d/b)T.                                        \tag{5}
```

Thus the algebraic closing condition still requires both $d\in A$ and $W\in H$, followed by retention of that incidence. The memberships $U,V\in H$ do not supply these requirements.

There are exact reasons why these gaps do not collapse to the existing potentials. Work on genuine simple paths and exclude the additional bounded-degree locus $y=0$ for the following identities.

1. The continuation cannot reuse $U$: $T=U$ forces $r_c=x$, repeating the third row at the fifth vertex.
2. A closing potential cannot reuse $T$: $W=T$ forces $d=b$, and substitution in the closing equation gives $r_b=r_c$, again a repeated row.
3. For fixed $x,b$, equality of a closing potential with $U$ occurs for at most six values of $c$. Indeed, substituting $d=U/y$ gives

```math
U^2+r_bUy-y^3=0.
```

This is a nonzero cubic equation in $y$, so has at most three solutions. Each fixes $r_c=y/b-b$, and $c(x+c)=h(r_c)$ then has at most two solutions for $c$.
4. For fixed $x,b$, equality of a closing potential with $V$ occurs for at most twelve values of $c$. On the irreducible conic $r_c^2+4c(x+c)=0$, the equality requires

```math
[c^2(x+c)]^2+r_b[c^2(x+c)]\,b(r_c+b)-b^3(r_c+b)^3=0.
```

The polynomial has total degree at most six. It does not contain the conic as a component, since at $(c,r_c)=(0,0)$ its value is $-b^6\ne0$. Bézout therefore bounds the intersection by twelve geometric points, and hence by twelve possible field values of $c$.

These are algebraic bounds, not finite enumeration. They show that, except on a bounded set for each fixed $(x,b)$, the continuation and closing edge introduce new support memberships. The favorable quadratic-character discriminant alone does not give the three-potential configuration used in the existing asymptotic proof.

The two closing roots also satisfy a useful identity. If their potentials are $W_1,W_2$, then

```math
W_1W_2=-y^3.                                        \tag{6}
```

For example, if $p\equiv1\pmod3$ and $H$ lies in a single nontrivial cubic coset, (6) permits at most one of the two nonzero closing potentials to lie in $H$, because the product of two elements of that coset is not a cube. It does not guarantee that either lies in $H$. This is compatible with the proper common-potential examples that motivated the previous theorem.

## 4. Remaining concrete question

The nonlinear base supplies many ambient closing edges uniformly over centers. To turn this into a partial-matching advance, one would need a lower bound for the simultaneous conditions

```math
U,V,T,W\in H,\qquad b,c,d\in A,
```

on the displayed conic correspondence, with actual incidence retention taken into account. No such bound for arbitrary $A,H$ is proved here. The exact identities identify the continuation and closing-support constraints that a successful argument would have to control.
