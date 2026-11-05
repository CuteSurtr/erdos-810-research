# A rational expander arising from the equal-cross-potential configuration

## Status and scope

This geometric argument has passed independent review. Together with [the counting extension](partial-rational-expansion-independent-audit.md), it now handles the extra cube condition. The [bounded-index palette extension](quadratic-coset-palette-extension.md) also handles a specified class of restricted palettes. This file presents the geometric input in stages; its rational-image theorem alone does not supply those additional conclusions. It is not a solution of Erdős problem #810, and no originality claim is made.

The primary input is Terence Tao, [*Expanding polynomials over finite fields of large characteristic, and a regularity lemma for definable sets*](https://arxiv.org/pdf/1211.2894), Theorem 40, printed pp.37–38 (PDF pages 36–37, numbered from zero). That theorem gives strong expansion for a regular map of geometrically irreducible quasiprojective varieties unless its four-output grid map is not dominant or a pullback through three separate dominant covers is reducible.

## Finite-field conclusion

Put

```math
K(x,y)=\frac{xy(x+y)}{x^2+y^2}.
\tag{1}
```

As a map to the projective line, this is defined on $\mathbb G_m^2$ in characteristic different from two: its numerator and denominator have no common zero there. The following consequence of Tao's theorem follows from the checks below:

There are absolute constants $C,p_0$ such that, for primes $p>p_0$ and nonempty $A,B\subseteq\mathbb F_p^*$,

```math
\left|\mathbb P^1(\mathbb F_p)\setminus K(A,B)\right|
\le C p^{-1/16}\frac{p-1}{\sqrt{|A||B|}}(p+1).
\tag{2}
```

In particular, if $A,B,C_0\subseteq\mathbb F_p^*$ each have density at least a fixed $\delta>0$, then $K(A,B)\cap C_0\ne\varnothing$ for sufficiently large $p$. Pole values are interpreted as $\infty$ in (2), and cannot be the value lying in $C_0$.

Taking two disjoint subsets of a dense set $H$ as $A,B$, and $C_0=H$, would give $x,y,k\in H$ with $x\ne y$ and $k=K(x,y)$. Here $k=x$ or $k=y$ forces $x=y$, so this gives three distinct values.

The constants in (2) are not numerically explicit. Their uniform existence follows from the fixed-map ultraproduct formulation, as detailed below.

## Grid dominance

The two partial derivatives are

```math
K_x(x,y)=\frac{y^2(-x^2+2xy+y^2)}{(x^2+y^2)^2},
\qquad
K_y(x,y)=K_x(y,x).
\tag{3}
```

For the map

```math
(a,b,c,d)\longmapsto
\bigl(K(a,c),K(a,d),K(b,c),K(b,d)\bigr),
\tag{4}
```

the Jacobian determinant, up to the sign fixed by coordinate order, is

```math
K_x(a,c)K_y(a,d)K_y(b,c)K_x(b,d)
-K_y(a,c)K_x(a,d)K_x(b,c)K_y(b,d).
\tag{5}
```

At $(a,b,c,d)=(1,2,3,4)$ this is

```math
-\frac{28944}{6105125}\ne0.
\tag{6}
```

Thus (4) is dominant in characteristic zero. The displayed rational calculation also verifies dominance in every characteristic outside a finite set. This excludes the first obstruction in Tao's theorem.

## Generic fibre and all special target values

Let $k$ be an algebraically closed field of characteristic zero, let $z=K(x,y)$, and put $F=k(x,y)$. The generic fibre is geometrically integral. Indeed, after reciprocating coordinates $u=1/x$, $v=1/y$, $w=1/z$, its equation is

```math
u^2+v^2=w(u+v).
\tag{7}
```

Over $\overline{k(w)}$ this is a smooth projective conic: its homogeneous quadratic form has nonzero determinant when $w\ne0$. Consequently $F/k(z)$ is a regular extension; in particular it is linearly disjoint from every finite algebraic extension of $k(z)$.

For each $b\in\mathbb P^1(k)$ there is a prime divisor $D_b$ of $\mathbb G_m^2$ such that:

1. $K$ is constantly $b$ on $D_b$;
2. its local parameter at $b$ has valuation exactly one along $D_b$;
3. neither $x$ nor $y$ is constant on $D_b$.

For finite $b\ne0$, take the fibre itself: (7) is a smooth conic after setting $w=1/b$, and both coordinates vary. For $b=0$, take $x+y=0$. For $b=\infty$, take either line $x=iy$ or $x=-iy$, where $i^2=-1$ in $k$. Each occurs with multiplicity one, and the numerator is generically nonzero on the latter two lines. These statements take place on $\mathbb G_m^2$, so the exceptional coordinate axes are irrelevant.

## Excluding arbitrary separate covers

Consider arbitrary finite separable covers of the $x$-, $y$-, and $z$-lines. Passing to smooth projective models and then to Galois closures can only strengthen the desired linear-disjointness statement. Write their Galois function fields as

```math
L_x/k(x),\qquad L_y/k(y),\qquad L_z/k(z).
\tag{8}
```

Inside a common algebraic closure of $F$, set

```math
E=F L_xL_y,\qquad L=F L_z,\qquad J=E\cap L.
\tag{9}
```

Both $E/F$ and $L/F$ are finite Galois extensions. Regularity of $F/k(z)$ identifies

```math
\operatorname{Gal}(L/F)\cong\operatorname{Gal}(L_z/k(z))=:G.
\tag{10}
```

The intersection $J/F$ is Galois, because it is the intersection of two Galois extensions. Hence $N=\operatorname{Gal}(L/J)$ is a normal subgroup of $G$.

The extension $E/F$ is unramified at every divisor $D_b$ chosen above. To see this, a branch point of $L_x/k(x)$ gives a vertical divisor; a branch point of $L_y/k(y)$ gives a horizontal divisor. Neither kind is the generic point of $D_b$, because both $x$ and $y$ vary on $D_b$. Equivalently, both pulled-back covers are finite étale near that generic point, and their compositum remains unramified there. Therefore $J/F$ is unramified there as well.

The inertia in $L/F$ along $D_b$ is the same as the inertia of $L_z/k(z)$ at $b$, up to conjugacy. This is the multiplicity-one assertion: the target local parameter remains a parameter along $D_b$, rather than becoming a higher power. More explicitly, in characteristic zero a completed target extension with inertia order $e$ is tamely generated by an $e$th root of a local parameter. After this base change that parameter still has valuation one, so its ramification index remains $e$. Consequently each target inertia subgroup is contained in $N$.

The target inertia subgroups normally generate $G$. Indeed, the quotient by their normal closure would give a finite everywhere-unramified cover of $\mathbb P^1_k$. Such a cover has degree one by Riemann–Hurwitz: an unramified degree-$d$ cover would satisfy $2g-2=-2d$, impossible for $d>1$. Thus $N=G$, and

```math
E\cap L=F.
\tag{11}
```

Because these are Galois extensions, (11) implies linear disjointness. Their subextensions are therefore linearly disjoint as well. In particular, pulling back the original target cover through arbitrary separate covers of $x$ and $y$ gives an integral function field.

This excludes the second obstruction in Tao's theorem. Covers originally given only on quasiprojective curves are handled by their smooth projective models and a restriction to dense open subsets. Dominance between curves in characteristic zero gives a finite separable extension of function fields. There are no additional vertical components in the relevant fibre product: a nonconstant map of smooth curves is flat on a suitable dense open, and the relation has the expected pure dimension there.

## Characteristic zero and the finite-field conclusion

The preceding cover argument is used over the algebraic closure of a nonstandard finite field of characteristic zero, as allowed when the primes tend to infinity. It does not assert a uniform classification of wild covers in each positive characteristic. If (2) had no constants $C,p_0$, choose a sequence of primes tending to infinity, together with sets $A,B$, for which the ratio between its two sides tends to infinity. Their ultraproduct is a characteristic-zero nonstandard finite field with nonstandard subsets $A,B$. Tao's theorem, with both obstructions excluded by the fixed rational geometry above, contradicts this sequence. This yields uniform constants for sufficiently large primes without an independent claim about wild ramification in bounded characteristic.

## What remains for the original affine graph

The equal-cross-potential subfamily requires, in addition to $x,y,k\in H$ and $k=K(x,y)$,

```math
a^3=-\frac{(x^2+xy+y^2)(x^2+y^2)}{xy(x+y)}
=-\frac{x^2+xy+y^2}{k},
\tag{12}
```

and the three colors $a,ak/y,ak/x$ must belong to the original palette. The image-expansion statement alone supplies neither the cube condition in (12) nor the palette conditions. The counting extension linked at the start supplies the cube restriction; it must be used in addition to the present image statement.

## The cube cover also survives separate coordinate covers

There is a stronger geometric fact relevant to a possible extension of Tao's argument to the cube-restricted graph. This is a geometric input only; the extension of the counting argument is a separate obligation.

Write

```math
G(x,y)=-\frac{(x^2+xy+y^2)(x^2+y^2)}{xy(x+y)}.
\tag{13}
```

On the graph $z=K(x,y)$, consider the additional equation $a^3=G(x,y)$. After arbitrary separate covers of the three coordinates $x,y,z$, the resulting variety is still geometrically integral, on its natural dense open subset.

To prove this, again work over an algebraically closed field $k$ of characteristic zero. The preceding argument shows that the combined coordinate-cover function field $T=E L$ is a field. Let $\omega\in k$ be a primitive cube root of unity, and consider

```math
D:\ y=\omega x.
\tag{14}
```

Along this divisor,

```math
K(x,\omega x)=\omega^2x.
\tag{15}
```

Thus all three coordinate functions $x,y,z$ are nonconstant on $D$. Each separate coordinate cover is therefore unramified at the generic point of $D$, as is their compositum $T/F$.

Moreover,

```math
x^2+xy+y^2=(y-\omega x)(y-\omega^2x),
\tag{16}
```

and all the other factors in (13) are nonzero at the generic point of $D$. Consequently $\operatorname{ord}_D G=1$. For any valuation of $T$ over $D$, the ramification index is one, so its value on $G$ is still exactly one. A cube in $T$ would have valuation divisible by three. Hence $G$ is not a cube in $T$, and $X^3-G$ is irreducible over $T$.

It follows that the complete pullback with equations $z=K(x,y)$ and $a^3=G(x,y)$ is integral after arbitrary separate covers of $x,y,z$. This argument also proves geometric integrality because it was conducted after extending constants to an algebraically closed field. The same characteristic-zero ultraproduct qualification applies as before; no positive-characteristic inseparability claim is needed.

This is precisely the additional irreducibility statement a cube-restricted analogue of the strong-expansion argument would require. Tao's Theorem 40 itself concerns a regular map on a product, so this extra geometry must not be presented as a direct plug-in application of that theorem. The field-point condition “$G(x,y)$ is a cube” restricts the input pairs and is not a Cartesian product restriction.
