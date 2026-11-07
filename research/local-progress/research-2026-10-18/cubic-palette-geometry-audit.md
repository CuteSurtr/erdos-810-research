# Cubic affine palette: correspondence and fifth-root geometry

18 October 2026. This note checks the geometric and counting inputs for the palette $y=ax+a^3$ with common potential $h=a^2y$. It extends the written counting argument for the quadratic palette; it is not a literal application of a published correspondence theorem. Historical priority is not asserted.

## Verdict and exact correspondence

The geometry and the bounded-correspondence counting extension pass the audit below. **Scope warning:** a subsequent elementary character-sum argument appears to give the stronger bound $|H|=O(\sqrt p)$ from properness alone for this cubic palette. The present application is therefore not being presented as an improvement; the correspondence geometry is recorded separately from its extremal significance. Work first over an algebraically closed field $k$ of characteristic zero. Set

```math
A(q)=q^4+q^3+q^2+q+1,\quad B(q)=q^2+q+1,\quad D(q)=q(q+1),
\tag{1}
```

and let $C$ be the smooth projective model of

```math
A(q)r^2-D(q)r-B(q)=0.
\tag{2}
```

The surface $S$ has function field

```math
F=k(C)(u),\qquad v=qu,\qquad w=qru.
\tag{3}
```

All rational maps are restricted to appropriate dense opens when used for counting. For each fixed $\lambda\ne0$, impose the additional cover

```math
a^5=G_5(u,v,w):=
-\lambda\frac{u^4+u^3v+u^2v^2+uv^3+v^4}{w(u+v)}.
\tag{4}
```

The required two statements are: the four-grid correspondence is geometrically integral and dominant over its four outputs; and the fifth-root surface remains geometrically integral after arbitrary separate geometrically irreducible curve covers of $u,v,w$.

## Algebraic consistency with the coloring

For repeated color $a$, put $h_1=\lambda u^2$, $h_2=\lambda v^2$, and take cross-colors $b=ar$, $c=aqr$ with $q=v/u$. The edge equations are

```math
h_2=rh_1+a^5(r^3-r),\qquad
h_1=qrh_2+a^5(q^3r^3-qr).
\tag{5}
```

Equality of the cross potentials gives $k=r^2h_2=(qr)^2h_1=\lambda w^2$. Eliminating $a^5/h_1$ from (5) gives $(q-1)$ times (2). Conversely, on (2),

```math
\frac{a^5}{h_1}=-\frac{A(q)}{q r(q+1)},
\tag{6}
```

which is exactly (4), and (5) follows without division by $r^2-1$. Thus no configurations with $r=-1$ are accidentally lost by that division.

For counting a nondegenerate subfamily it is enough to take $u,v,w,a\ne0$, $q\ne\pm1$, and the rational domains in (2)–(4). Then $h_1\ne h_2$. The equations $r=1$ and $qr=1$ on $C$ force $q\in\{0,1,-1\}$, so all three colors are distinct in this domain. The two rows and two columns of the repeated-color rectangle are consequently distinct.

## The discriminant and irreducibility of all grid sheets

The discriminant of (2) as a quadratic in $r$ is

```math
\Delta(q)=4q^6+8q^5+13q^4+14q^3+13q^2+8q+4.
\tag{7}
```

With $z=q+q^{-1}$,

```math
q^{-3}\Delta(q)=4z^3+8z^2+z-2.
\tag{8}
```

The cubic on the right has discriminant $1264\ne0$, and values $64,-4$ at $z=2,-2$. The double map $q\mapsto q+q^{-1}$ ramifies only at those two values. Thus $\Delta$ has six distinct nonzero roots. In particular $C$ is geometrically irreducible and $S$ is a geometrically integral quadratic cover of the $(u,v)$-plane on its natural open.

Now take algebraically independent $u_1,u_2,v_1,v_2$. The full four-grid correspondence adjoins to their rational function field the four square roots

```math
\sqrt{\Delta(v_j/u_i)}\qquad(i,j\in\{1,2\}).
\tag{9}
```

For any root $\zeta$ of $\Delta$, the divisor $v_j=\zeta u_i$ occurs to odd order in its own expression in (9) and to order zero in the other three expressions at the generic point. Hence their four square classes are independent. The grid correspondence is therefore a single geometrically integral cover of degree $16$, not a union of components some of which might have nondominant output maps.

## Four-output dominance

On a local sheet write $w(u,v)=v r(v/u)$. Implicit differentiation of (2) gives

```math
(w_u,w_v)=(1/2,1/2)\quad(q=1,r=1),\qquad
(w_u,w_v)=(0,1)\quad(q=-1,r=1).
\tag{10}
```

Both are smooth points of the quadratic cover. At $(u_1,u_2,v_1,v_2)=(1,-1,1,-1)$, choose $r=1$ on each sheet. In the order $(w_{11},w_{12},w_{21},w_{22})$, the derivative matrix is

```math
\begin{pmatrix}
1/2&0&1/2&0\\
0&0&0&1\\
0&0&1&0\\
0&1/2&0&1/2
\end{pmatrix},\qquad \det=-1/4.
\tag{11}
```

Consequently the output map is dominant and generically finite on the entire irreducible grid. This certificate uses points outside the eventual nondegenerate configuration domain, but that is harmless: the determinant is a nonzero rational function, so it remains nonzero somewhere on every dense open. No counted configuration is required to use $q=\pm1$.

## Separate input covers preserve the quadratic surface

Put $L=k(u,v)$. Let $E_0/L$ be the compositum of the normal closures of arbitrary separate covers of the $u$- and $v$-lines. Such an extension is unramified at the generic point of every nonvertical and nonhorizontal divisor $v=\zeta u$.

At a simple root $\zeta$ of $\Delta$, the valuation of $\Delta(v/u)$ is one. It stays one under every extension of that valuation to $E_0$, since the extension is unramified there. Thus the quadratic defining $F/L$ remains irreducible over $E_0$. The compositum $E=FE_0$ is a field and is Galois over $F$. This also proves integrality for the original nonnormal input covers by passage to subextensions.

## No separate output cover can split the correspondence

Since $w=qru$ and $qr$ is a nonzero function on $C$,

```math
F=k(C)(w).
\tag{12}
```

Thus $F/k(w)$ is regular. Let $L_w/k(w)$ be the normal closure of a separate output cover and $M=FL_w$. Then $M/F$ has the same Galois group as $L_w/k(w)$.

For every $b\in\mathbb P^1(k)$ there is a divisor on a model of $S$ on which $w-b$ has order one (or $w$ has a simple pole when $b=\infty$), and both $u$ and $v$ vary:

- If $b\ne0,\infty$, use the fibre $w=b$. It is a copy of $C$ on a dense open, with $u=b/(qr)$ and $v=b/r$. Both are nonconstant: neither $r$ nor $qr$ can be constant in (2).
- If $b=0$, choose a root of $B(q)$ and the branch $r=0$. The root of $B$ is simple and $D(q)\ne0$. Thus $r$, and therefore $w$, has a simple zero; $u$ is free and $v=qu$ varies.
- If $b=\infty$, choose a root of $A(q)$ and the branch $r=\infty$. In the local variable $t=1/r$, equation (2) becomes $A-Dt-Bt^2=0$. Since $A$ has a simple root and $D\ne0$, $t$ has a simple zero and $w$ a simple pole. Again $u,v$ vary.

The extension $E/F$ is unramified on each such divisor. A target inertia group from $L_w/k(w)$ is retained after the multiplicity-one base change to that divisor. Since $E\cap M$ is Galois over $F$, its corresponding quotient of the output Galois group kills every inertia group. Such a quotient would define a connected finite étale cover of $\mathbb P^1_k$, which is trivial in characteristic zero. Therefore $E\cap M=F$. It follows that $S$ stays geometrically integral after all three separate coordinate covers.

## The fifth root survives every separate cover

Choose a root $q_0$ of $A$. On the **finite** branch of (2),

```math
r_0=-\frac{B(q_0)}{q_0(q_0+1)}\ne0.
\tag{13}
```

The derivative of (2) with respect to $r$ equals $-D(q_0)\ne0$ there, so $q-q_0$ is a local parameter. Rewriting (4) in $(u,q,r)$ gives

```math
G_5=-\lambda\frac{u^2 A(q)}{q r(q+1)}.
\tag{14}
```

Along the divisor $q=q_0,r=r_0$, $G_5$ has valuation exactly one. The coordinate functions are $u$, $v=q_0u$, and $w=q_0r_0u$, so all three vary. Every separate coordinate cover is unramified at its generic point. Consequently, after their combined base change, the valuation of $G_5$ is still one. The polynomial $T^5-G_5$ is Eisenstein for that valuation and remains irreducible. This proves the required geometric integrality after arbitrary separate covers.

The argument is uniform for every nonzero scalar $\lambda$: it is a valuation unit. It does not matter whether $\lambda$ is a square in a finite field.

## Exact counting change for a bounded correspondence

Use the same primary inputs from [Tao's paper](https://arxiv.org/pdf/1211.2894), Lemma 23, Theorem 25, Corollary 37, and Lemma 26, as in [the audited quadratic argument](partial-rational-expansion-independent-audit.md). The replacement for its single-valued kernel is

```math
B_f(u,v)=\sum_{w:\,(u,v,w)\in S}
1_{\{G_5(u,v,w)\in(\mathbb F_p^*)^5\}}f(w).
\tag{15}
```

It has magnitude at most two. Its four-grid expansion chooses one sheet at each of the four positions. The irreducible grid and (11) give a bounded definable output-fibre count away from a proper locus with $O(p^3)$ preimage points. The fifth-power restrictions are bounded existence indicators; irreducibility of a fourfold fifth-root cover is neither claimed nor needed. Applying product regularity and two Cauchy–Schwarz steps gives the same error $O(p^{15/16}\sqrt{|X||Y|})$.

For positivity in an output cell $U_j$, use the bounded definable integer weight

```math
F_j(u,v)=\#\{w\in U_j:(u,v,w)\in S,\ G_5(u,v,w)\in(\mathbb F_p^*)^5\}.
\tag{16}
```

Apply two-variable regularity to its finitely many level sets. A zero full-cell coefficient contradicts the three separate curve-cover construction and Lang–Weil, by the geometric integrality just proved. Projection to $(u,v)$ has bounded fibres: at most two correspondence points, at most five roots, and boundedly many points from the selected coordinate covers. Thus all full-cell coefficients are positive standard constants. The quantitative argument and the simultaneous-constant ultraproduct contradiction from the quadratic audit carry over unchanged.

In particular there are absolute $c,C>0$, uniform in $\lambda\ne0$, such that the number of eligible correspondence points over $X\times Y$ with $w\in Z$ is at least

```math
c\frac{|X||Y||Z|}{p}-C p^{15/16}\sqrt{|X||Y|}.
\tag{17}
```

The proof is in characteristic-zero ultraproducts of primes. It does not assert a uniform ramification statement for arbitrary wild covers in fixed positive characteristic. Uniformity in varying $\lambda$ follows by including it as a parameter in the hypothetical violating ultraproduct sequence; all geometric arguments hold for every nonzero value. Finitely many bad small characteristics are absorbed into the sufficiently-large-prime condition.

## Consequence for a full palette

One of the two quadratic classes contains at least half of $H\setminus\{0\}$. Write that part as $H_\lambda\subseteq\lambda(\mathbb F_p^*)^2$ and set $U=\{u:\lambda u^2\in H_\lambda\}$. Then $|U|=2|H_\lambda|$. Split **the potential set** $H_\lambda$ into two comparable disjoint subsets and let $X,Y$ be their full square-root lifts. This guarantees $v\ne\pm u$, not merely $v\ne u$. Take $Z=U$.

If $|H|$ exceeds a sufficiently large constant times $p^{31/32}$, (17) supplies an eligible correspondence point and a nonzero fifth root $a$. Equations (5)–(6) then give a repeated-color four-cycle using the full nonzero palette. Therefore a simple proper coloring of this full common-potential form whose four-cycles are all rainbow has

```math
|H|=O(p^{31/32}),\qquad m=O(p^{63/32}).
\tag{18}
```

Zero potential contributes at most $p-1$ additional incidences and does not change the bound. This audit does not derive missing-color, missing-incidence, or dilation-defect extensions for the cubic palette; their combinatorial multiplicities require a separate check. It also does not resolve an arbitrary dense restricted palette. The properness-only character-sum bound mentioned at the start, if retained after its separate audit, supersedes (18) as an extremal conclusion for the completed full-palette model.
