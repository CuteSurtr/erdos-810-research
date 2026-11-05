# A propriety obstruction for monomial common potentials

This note concerns a restricted family of colored graphs, not the general Erdős problem #810. The argument uses no condition on four-cycles. It shows that the cubic version of the common-potential question is substantially easier than the quadratic version. Historical priority has not been established, and the argument has not been formalized in Lean.

## 1. Statement and conventions

Fix an integer $d\ge 3$. For primes $p>d$, write $e=d-1$ and consider the affine color maps

```math
\sigma_a(x)=ax+a^d,\qquad a\in\mathbb F_p^*.
```

The potential of a color-$a$ incidence ending at column $y$ is

```math
h=a^e y.
```

Thus a prescribed pair $(a,h)$ determines the edge

```math
(x,y)=\left(\frac{h}{a^d}-a^{d-1},\frac{h}{a^{d-1}}\right).
```

Let $A\subseteq\mathbb F_p^*$, let $H\subseteq\mathbb F_p$, and select some of the eligible incidences $(a,h)\in A\times H$. Assume that no two selected incidences of different colors are the same edge. Since each $\sigma_a$ is a bijection, this is exactly the additional requirement needed for these incidences to define a simple properly edge-colored bipartite graph. Put

```math
D=p-1-|A|,\qquad R=|A||H|-m,
```

where $m$ is the number of selected incidences. Then

```math
m\ll_d p^{3/2}+p\sqrt{R+pD}.
```

In particular, the full palette and all eligible incidences can be proper only if $|H|=O_d(\sqrt p)$, and then $m=O_d(p^{3/2})$. More generally, $D=o(p)$ and $R=o(p^2)$ force $m=o(p^2)$.

The exponent $d=2$ is excluded for an algebraic reason explained in Section 6.

## 2. Exact collision equations

For distinct nonzero colors $a,b=aq$, their two affine lines intersect at

```math
x=-a^{d-1}(1+q+\cdots+q^{d-1}),\qquad
y=-a^dP(q),
\qquad P(q)=q+q^2+\cdots+q^{d-1}.
```

The two potentials at this edge are therefore

```math
h_1=-a^{2d-1}P(q),\qquad h_2=q^{d-1}h_1.
```

Write $n=2d-1=2e+1$. For nonzero potentials, the allowed ratios are

```math
q\ne0,\qquad q\ne1,\qquad P(q)\ne0.
```

Since $p>d$, the nonzero roots of $P$ are exactly the nonidentity $e$th roots of unity. They are simple. In particular, $P$ has at least one simple nonzero root over the algebraic closure when $e\ge2$.

Let $N(H)$ be the number of ordered pairs $(a,b)$ of distinct colors in the full palette for which both nonzero collision potentials belong to $H$. Every such ordered pair is an actual conflicting pair of eligible incidences. We prove

```math
N(H)\ge |H\setminus\{0\}|^2-C_d\sqrt p\,|H\setminus\{0\}|.
```

## 3. The character-sum input

The standard multiplicative Weil bound gives the following uniform estimate. A precise source is Iwaniec–Kowalski, *Analytic Number Theory*, Theorem 11.23, p. 289 ([author-hosted text](https://people.math.ethz.ch/~kowalski/ik-ant-exp-sums.pdf)). If $\eta$ is any multiplicative character of $\mathbb F_p^*$ and $\chi$ is any nontrivial multiplicative character, then

```math
\left|\sum_{q\in\mathbb F_p^*,\ P(q)\ne0}
\eta(q)\chi(P(q)^{-1})\right|\ll_d\sqrt p.
```

Here the implicit constant does not depend on the orders of $\eta$ and $\chi$. To check the essential nondegeneracy, express both characters as powers of one primitive character. At a simple nonzero root of $P$, the resulting rational function has valuation equal to a nonzero character exponent modulo $p-1$. The factor involving $\eta(q)$ has valuation zero there. Consequently the rational function is not a $(p-1)$st power. The number of distinct zeros and poles is bounded in terms of $d$, which is the parameter entering the Weil estimate.

More explicitly, let $M=p-1$, let $\theta$ generate the character group, and write $\eta=\theta^j$, $\chi=\theta^k$ with $1\le k<M$. Put $S_e(q)=1+q+\cdots+q^{e-1}$, so $P(q)=qS_e(q)$. Off the excluded zeros, the summand equals

```math
\theta\!\left(q^{[j-k]_M}S_e(q)^{M-k}\right).
```

This polynomial has at most $e$ distinct roots and is not an $M$th power, since each nonzero root of $S_e$ has multiplicity $M-k\not\equiv0\pmod M$. The cited theorem bounds the complete sum by $(e-1)\sqrt p$; excluding $q=0$ costs at most one.

Equivalently, the multiplicative convolution matrix on $\mathbb F_p^*$ with entries

```math
K_\chi(u,v)=\chi(P(v/u)^{-1}),
```

with value zero when $P(v/u)=0$, has operator norm $O_d(\sqrt p)$. This follows by diagonalizing the convolution with multiplicative characters. Removing the additional ratio $q=1$ changes the matrix by a scalar multiple of the identity, of norm at most one.

## 4. Counting all roots and all power classes

Let $g=\gcd(e,p-1)$. Partition $H^*=H\setminus\{0\}$ among the $g$ cosets of the subgroup of $e$th powers. For a coset representative $\lambda$, write its portion as $H_\lambda$ and set

```math
L_\lambda=\{u\in\mathbb F_p^*: \lambda u^e\in H_\lambda\}.
```

Then $|L_\lambda|=g|H_\lambda|$. Given $u,v\in L_\lambda$, put $q=v/u$. A collision lift is a solution of

```math
a^n=-\frac{\lambda u^e}{P(q)},
```

with the ratios of Section 2 excluded. The exact number of roots of $a^n=z\ne0$ is

```math
\sum_{\chi^n=1}\chi(z).
```

There are at most $n$ characters in this sum. Its trivial-character contribution, summed over $u,v\in L_\lambda$, is at least

```math
|L_\lambda|^2-e|L_\lambda|.
```

For each nontrivial character the summand factors as

```math
\chi(-\lambda)\chi(u^e)\chi(P(v/u)^{-1}).
```

The factor $\chi(u^e)$ is a diagonal unitary multiplier. The convolution estimate of Section 3 and Cauchy–Schwarz therefore bound its entire contribution by $O_d(\sqrt p)|L_\lambda|$, without any assumption on the set $L_\lambda$.

Every actual ordered collision with potentials in $H_\lambda$ has exactly $g$ lifts: choose one of the $g$ roots of $u^e=h_1/\lambda$, then set $v=(b/a)u$. Therefore

```math
N_\lambda\ge g|H_\lambda|^2-C_d\sqrt p\,|H_\lambda|.
```

All actual collisions have their two potentials in the same $e$th-power coset, because $h_2/h_1=q^e$. Summing over the $g$ cosets and using

```math
g\sum_\lambda |H_\lambda|^2\ge |H^*|^2
```

proves the asserted lower bound for $N(H)$.

## 5. Missing colors and missing incidences

Fix a nonzero colored incidence $(a,h)$. Its collision partners are roots of

```math
h=-a^nP(b/a).
```

As a polynomial equation in $b$, this has degree $e$ and nonzero leading coefficient. Thus there are at most $e$ possible partners. An omitted incidence destroys at most $2e$ ordered collisions, accounting for its occurrence in either ordered position. An omitted color occurs in at most $2(p-1)$ ordered collisions. Since no collision can survive in a simple selected graph,

```math
N(H)\le 2eR+2pD.
```

Combining the bounds, with $h=|H^*|$, gives

```math
h^2-C_d\sqrt p\,h\le 2eR+2pD,
\qquad
h\ll_d\sqrt p+\sqrt{R+pD}.
```

The potential zero contributes at most one selected incidence per color, hence at most $p$ further edges. Since $m\le p(h+1)$, this proves the statement in Section 1. No four-cycle condition was used.

## 6. Cubic specialization and the quadratic exception

For $d=3$, $e=2$, $n=5$ and $P(q)=q(q+1)$. In the square-root lift $h_1=\lambda u^2$, $h_2=\lambda v^2$,

```math
a^5=-\frac{\lambda u^4}{v(u+v)}.
```

For each nontrivial fifth-order character, the corresponding matrix is a diagonal modulation of the additive Hankel matrix $\chi(u+v)^{-1}$. Its norm is exactly $\sqrt p$ on the nonconstant additive Fourier modes, by the Gauss-sum identity, and at most $\sqrt p$ on the full space. Restriction to nonzero rows and columns can only decrease the norm. Removing $u=v$ costs at most one per row. The exclusion $u=-v$ is already represented by the character's value zero at zero. The trivial term loses at most two pairs per row.

Consequently one may take the explicit lower estimate

```math
N(H)\ge h^2-(4\sqrt p+6)h,
\qquad h=|H\setminus\{0\}|.
```

The constant 6 safely includes the diagonal removals in all character terms. Thus

```math
h^2-(4\sqrt p+6)h\le4R+2pD.
```

If $\gcd(5,p-1)=1$, every nonzero right-hand side has exactly one fifth root; the character argument simplifies further. Each square class of $H^*$ can contain at most one element in a proper full-palette graph.

For $d=2$, however, $P(q)=q$. A Mellin twist can exactly cancel the root character, leaving a convolution eigenvalue of order $p$. There is no simple nonzero root at which this cancellation is obstructed. This explains why the above argument does not settle the genuinely different quadratic common-potential problem.

## 7. Scope of the audit

The collision equations, root-lift multiplicities, and deletion bounds are exact algebraic statements. The analytic input is the classical multiplicative Weil estimate, with its nondegeneracy checked explicitly in Section 3. The result applies to every fixed monomial degree $d\ge3$ for sufficiently large primes. It makes the proposed cubic equal-cross-potential four-cycle argument unnecessary for the full or nearly full palette, although that configuration algebra can still be studied separately. It does not resolve arbitrary dense palettes, arbitrary supports, or the unrestricted Erdős problem.
