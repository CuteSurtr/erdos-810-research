# Independent audit of the cubic-perturbation bounds

18 October 2026. The written proofs in [the first cubic note](cubic-perturbation.md) and [the stronger spectral note](cubic-perturbation-spectral.md) pass an independent mathematical audit. This is a handwritten proof audit, not a formal verification or a historical novelty determination.

## Audited conclusion

For $p>3$, $t\ne0$, and incidences

```math
(a,h)\longmapsto(h/a^2-a-ta^2,h/a),
```

let $A\subseteq\mathbb F_p^\times$, $H\subseteq\mathbb F_p$, $d=p-1-|A|$, and let $R$ count omitted incidences in $A\times H$. If the retained incidences assign at most one color to each ordered endpoint pair, their number satisfies

```math
m\ll p^{7/4}+p\sqrt{R+pd},
```

with an absolute constant. No four-cycle hypothesis is required. The earlier $p^{15/8}$ bound is also valid but is weaker.

## Algebra checked independently

Intersecting two lines $y=ax+a^2+ta^3$ and $y=bx+b^2+tb^3$ gives

```math
x=-(a+b)-t(a^2+ab+b^2),\qquad
y=-ab(1+t(a+b)).
```

Thus the two potentials are $u=-a^2b(1+t(a+b))$ and $v=-ab^2(1+t(a+b))$. For $u,v\ne0$, putting $z=1/a$ yields exactly

```math
z^4+(v/u^2)z+t v(u+v)/u^3=0.
```

For each fixed $u\ne0$, this polynomial is Eisenstein at $v=0$. Its resolvent is

```math
Y^3-4t v(u+v)Y/u^3-v^2/u^4.
```

A root in $k(v)$ lies in $k[v]$ by integral closedness. A root of degree at least two has a unique highest-degree contribution from $Y^3$, so its degree is at most one. Its constant coefficient is zero. Substitution $Y=\alpha v$ gives

```math
\alpha=-1/(4tu^2),\qquad \alpha^2=4t/u^3,
```

which is possible only at $u=1/(64t^3)$. The resolvent is therefore irreducible at every other nonzero row.

Writing $C=27/(256t^3)$ and $D_u(v)=(u+v)^3-Cuv$, the two discriminants are

```math
\operatorname{Disc}_z F_u=256t^3v^3D_u(v)/u^9,
\qquad
\operatorname{Disc}_vD_u=C^2u^3(4C-27u).
```

For $u\notin\{0,1/(64t^3)\}$, $D_u$ has three distinct nonzero roots. The quartic discriminant has valuation one at each, hence is nonsquare. Irreducibility, the irreducible cubic resolvent, and this nonsquare discriminant give geometric group $S_4$.

## Branch and arithmetic checks

The reciprocal quartic is monic in $z$ with polynomial coefficients in $v$. Its finite branch values are therefore contained in the zeros of its discriminant: $0$ and the three roots of $D_u$. In particular $v=-u$ introduces no additional branch point. It is excluded from the collision relation only because the reciprocal equation then has the inadmissible root $z=0$.

For distinct good rows $u,u'$, the cubics $D_u,D_{u'}$ have different $v^2$ coefficients, $3u$ and $3u'$. Their three-element root sets differ, giving a nonzero finite branch value of the first row at which the second is unramified. Inertia in the first is a transposition. An intersection of the two Galois closures is Galois; its corresponding normal subgroup contains this transposition, hence all transpositions and all of $S_4$. The intersection is the base field. The product cover therefore has geometric group $S_4^2$.

Arithmetic Galois groups act faithfully on the polynomial roots and embed in $S_4$ or $S_4^2$. Since the geometric groups already equal these groups, there is no residual constant-field extension.

All relevant groups have order dividing $24^2$ and are tame in characteristic greater than three. A pair of rows has at most eight branch points, including infinity. Riemann–Hurwitz gives a uniform genus bound; for example degree $n\le576$ and at most eight branch points imply $2g-2\le6n$. Thus the $O(\sqrt p)$ Frobenius-count errors are genuinely uniform over $u,u',t,p$.

## Counting and transfer checks

Exactly $15$ elements of $S_4$ have a fixed point, giving density $\delta=5/8$. Single and double row counts are consequently $\delta p+O(\sqrt p)$ and $\delta^2p+O(\sqrt p)$. Removing the two excluded potential values, the diagonal, opposite potentials, and branch specializations changes each count by only $O(1)$.

For $B=M-\delta J$, the off-diagonal entries of $BB^{\mathsf T}$ are $O(\sqrt p)$ and the diagonal entries are $O(p)$. The maximum absolute row sum is $O(p^{3/2})$, so $\|B\|_{\rm op}=O(p^{3/4})$. The resulting support inequality is

```math
\delta h^2-Cp^{3/4}h\le N,
```

where $h$ excludes only the two exceptional potential values and $N$ counts ordered same-endpoint collision configurations. Distinct potentials give distinct colors. Every accepted ordered potential pair yields at least one configuration, so no multiplicity division is needed for this lower bound.

A fixed absent color occupies either of two positions with at most $p-1$ choices for the other color, giving at most $2p$ configurations. A fixed omitted incidence gives a quadratic equation with nonzero leading coefficient in the other color in either position, giving at most four configurations. Thus

```math
N\le2pd+4R.
```

Solving the quadratic inequality gives $h\ll p^{3/4}+\sqrt{R+pd}$, and $m\le p(h+2)$ proves the conclusion.

## Scope

The exponent is a statement about this specific common-potential family with a full or nearly full palette. It does not bound all graphs in Erdős #810 and does not cover an arbitrary dense palette. The published-method inputs are standard; the application-specific calculations are explicit above. Priority and significance relative to the broader literature remain to be established.

## Additional audit: fixed-formula palettes

The subsequent proof [cubic-definable-palettes.md](cubic-definable-palettes.md) also passes independent audit. Its conclusion is weaker in exponent but broader in palette scope:

```math
m\ll_{\varphi,\delta}p^{15/8}+p\sqrt{R+pd}
```

for a positive-density core described by a fixed ring-language formula. For an exact fixed-formula palette with no omissions, the bound is $O_\varphi(p^{15/8})$ without a separately specified density lower bound.

The descended palette-cover construction and its residual-inertia normal generation were checked in [definable-palette-independent-audit.md](definable-palette-independent-audit.md). The new cubic step is the following valuation calculation. At $q=-1+\varepsilon$, the reciprocal collision equation

```math
u z^4+qz+tq(1+q)=0
```

has a simple root $z=0$ at $\varepsilon=0$, since its $z$-derivative there is $-1$. Its lift satisfies $z=-t\varepsilon+O(\varepsilon^2)$, hence $a=1/z$ has a pole of order one. Along this divisor the potential residues are $u$ and $-u$, both nonconstant. Every separate potential cover, including the designated root covers, is therefore unramified. Every prolongation retains pole order one. Consequently $X^n-\tau/a$ is Eisenstein for every positive integer $n$; the common color quotient is a genuine integral extension.

If the potential covers carry $u=\lambda x^n$ and $v=\lambda y^n$, the second quotient coordinate is exactly $w_b=w_a y/x$. Thus both colors map to the same descended Kummer quotient $a=\tau w_a^n$, $b=\tau w_b^n$.

For the residual palette covers, using the direct rational base $k(w_a,b)$ avoids any assumption that the full potential field is regular over $k(w_a)$. At $w_a=\theta\ne0$, the two potential residues are polynomials of degrees two and three in $b$ with nonzero leading coefficients. They remain nonconstant even if $1+t\tau\theta^n=0$. All earlier covers are unramified at every prolongation, while the selected residual cover retains its finite-nonzero inertia. The finite Galois closure and normal-generation argument is valid, and the same reasoning applies with the colors exchanged.

This verifies the integral pullback needed for every full-dimensional potential-cell pair. Binary regularity then supplies the stated $p^{7/4}$ count error, and the already checked $2p$ and $4$ deletion multiplicities give the bound. The omission count is needed only on the definable core, while the final inequality $m\le p|H|$ may count edges of every actual color. Neither this argument nor the spectral one assumes a rainbow-four-cycle condition.

## Additional audit: the symmetric support theorem

Section 6 of [cubic-definable-palettes.md](cubic-definable-palettes.md) also passes independent audit. It proves the same $p^{15/8}$ bound when the nonzero support, rather than the palette, has fixed formula complexity; the palette may be arbitrary.

At the divisor $1+t(a+b)=0$, both input colors are nonconstant, so the separate color covers are unramified. The first potential $u=-a^2b(1+t(a+b))$ has valuation one. Thus the support-quotient root $\xi^n=u/\lambda$ is an integral extension, and the designated input roots give the other quotient coordinate $\eta_v=\xi y/x$ exactly.

For the residual support cover, use the rational base $k(\eta_u,q)$. At a selected divisor $\eta_u=\theta\ne0$, putting $\rho=\lambda\theta^n$ gives the quartic relation

```math
\rho=-q a^3(1+t(1+q)a).
```

Its leading coefficient is a unit at this generic divisor. A repeated root requires $(1+q)^3-27q/(256t^3\rho)=0$, a nonzero polynomial for every $\rho\ne0$. The generic residue polynomial is therefore separable, so every divisor lift and the Galois closure are unramified. This argument does not require the stronger row-$S_4$ theorem and remains valid at its exceptional row.

On every residue component, neither color can be constant: fixing nonzero $a$ gives a nonzero quadratic equation for $b$, and fixing nonzero $b$ gives a nonzero cubic equation for $a$, whereas $q=b/a$ remains transcendental. The other potential $q\rho$ is nonconstant. Consequently all input covers and earlier residual support covers are unramified. The previously checked normal-generation argument applies to all finite nonzero support inertia and proves disjointness for each support coordinate.

The resulting count is $N\ge c|A|^2-Cp^{7/4}$. A missing support value destroys at most $4p$ ordered configurations; an omitted incidence destroys at most four. Thus $N\le4pd+4R$, and $m\le p|A|$ proves the stated bound while allowing arbitrary extra actual potentials. The exact-support finite/infinite alternative and the uniform fixed-formula hypothesis have the same justification as the palette version.
