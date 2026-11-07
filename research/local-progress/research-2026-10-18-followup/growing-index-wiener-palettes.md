# Growing multiplicative complexity and a Fourier criterion

18 October 2026. This note gives an elementary quantitative extension for the common-potential quadratic construction. Both the palette and support may have complexity growing with the prime. The inputs are the already verified equal-cross configuration, a multiplicative-character Weil bound, and Fourier analysis on a finite cyclic group. The argument is a specialized standard character-sum consequence; historical novelty is unverified.

## 1. Setup and conclusions

Let $p>3$ be prime, $A,H\subseteq\mathbb F_p^\times$, and let $R$ incidences be omitted from $A\times H$. The incidence $(a,h)$ represents the edge

```math
(h/a^2-a,\ h/a)
```

with color $a$. Assume the retained family is a simple proper coloring in which every four-cycle is rainbow. Write $m$ for its number of edges.

If $A$ and $H$ are arbitrary unions of cosets of a common subgroup of index $\ell\mid p-1$, then

```math
m\ll \ell p^{5/3}+p^{4/3}R^{1/3}.                         \tag{1}
```

In particular, $\ell=o(p^{1/3})$ and $R=o(p^2)$ force $m=o(p^2)$. The number of selected cosets is unrestricted. This permits growing index and arbitrary growing unions of classes; it is not a fixed-formula theorem.

For the broader Fourier statement, fix a generator of $\mathbb F_p^\times$, put $n=p-1$, and identify the multiplicative group with $G=\mathbb Z/n\mathbb Z$. Let $f$ and $g$ be the logarithmic indicator functions of $A$ and $H$, respectively. Use normalized Fourier coefficients and define

```math
M_A=\sum_{j\in G}|\widehat f(j)|,\qquad
M_H=\sum_{j\in G}|\widehat g(j)|.
```

Then

```math
m\ll p^{11/6}M_AM_H+p^{4/3}R^{1/3}.                      \tag{2}
```

A still more general criterion involving the three-variable kernel appears in Section 4. For example, if both $A$ and $H$ are intersections of a fixed number of multiplicative-character arc conditions, then

```math
m\ll_d p^{11/6}(\log p)^d+p^{4/3}R^{1/3},               \tag{3}
```

where $d$ is the total number of arc conditions. The character orders and characters themselves may vary arbitrarily with $p$.

## 2. The actual six-slot count and its uniform model

Set

```math
Q=q^2+1,\quad B=q^2+q+1,\quad r=(q+1)/Q,
\quad F=-BQ/[q(q+1)].
```

Let $\Omega$ exclude $q=0,1,-1$ and the roots of $Q B$. Thus $|\mathbb F_p\setminus\Omega|\le7$. For $a\ne0$ and $q\in\Omega$, the established configuration has colors and potentials

```math
(a,b,c)=(a,ar,aqr),\qquad
(u,v,k)=(a^3/F,\ qa^3/F,\ qra^3/F).
```

Its three colors and three potentials are distinct in their respective copies. Each missing actual incidence destroys at most sixteen ordered configurations. Consequently, if $N$ counts parameters $(a,q)$ for which all three colors lie in $A$ and all three potentials lie in $H$, then

```math
N\le16R.                                                \tag{4}
```

Put $e=\log(-1)$ and $g_0(s)=g(s+e)$. This common translation accounts for the minus sign in $F$; it preserves the mean and Fourier norm of $g$. Define

```math
\begin{aligned}
L_1&=t,&L_2&=t+y,&L_3&=t+x+y,\\
L_4&=3t+x+y-z,&L_5&=3t+2x+y-z,&L_6&=3t+2x+2y-z,
\end{aligned}
```

and the kernel

```math
T(x,y,z)=\mathbb E_t
\prod_{i=1}^3 f(L_i)\prod_{i=4}^6g_0(L_i).
```

All expectations are normalized. Thus $0\le T\le1$, and the actual count is exactly

```math
N=(p-1)\sum_{q\in\Omega}
T\bigl(\log q,\log r(q),\log B(q)\bigr).                 \tag{5}
```

Let $\alpha=|A|/(p-1)$, $\beta=|H|/(p-1)$ and $\mu=\mathbb E_{x,y,z}T$. The invertible change of variables

```math
a=L_1,\quad b=L_2,\quad c=L_3,\quad
S=L_1+L_6
```

has inverse $t=a$, $y=b-a$, $x=c-b$, $z=2a+2c-S$, over every cyclic group. Its last three forms are $(S-c,S-b,S-a)$. Jensen's inequality gives

```math
\mu=\mathbb E_S\left(\mathbb E_a f(a)g_0(S-a)\right)^3
\ge(\alpha\beta)^3.                                    \tag{6}
```

This treats the two universal multiplicative relations exactly, rather than incorrectly assuming six independent slots.

## 3. Uniform square-root estimates for every nonconstant mode

For any divisor $\ell\mid p-1$, let $\chi$ be a character of order $\ell$. For $(j_1,j_2,j_3)\ne(0,0,0)$ in $(\mathbb Z/\ell\mathbb Z)^3$,

```math
\left|\sum_{q\in\Omega}
\chi\bigl(q^{j_1}r(q)^{j_2}B(q)^{j_3}\bigr)\right|
\le C\sqrt p,                                          \tag{7}
```

with an absolute constant independent of $\ell$ and the exponents.

Indeed, replace every exponent of each of the polynomial factors $q$, $q+1$, $Q$, and $B$ by its residue in $\{0,\ldots,\ell-1\}$. The resulting polynomial agrees with the rational-character expression away from the excluded roots and has at most six distinct roots in its splitting field. It is not a constant times an $\ell$th power: the multiplicities at $0$, $-1$, and either root of $B$ are respectively $j_1,j_2,j_3$ modulo $\ell$. These roots are distinct for $p>3$. At least one of these multiplicities is nonzero modulo $\ell$. The standard multiplicative-character Weil estimate bounds the complete sum by five times $\sqrt p$, and deleting at most seven points changes it by at most seven. Increasing $C$ proves (7).

A source stating precisely the root-count version used here is Lucas Reis, [*Arithmetic constraints of polynomial maps through discrete logarithms*, Theorem 3.2](https://arxiv.org/pdf/2007.04114), which cites the standard finite-field character-sum theorem. The point relevant here is that the bound depends on the number of distinct roots, not on the exponents or character order.

Fourier expansion of (5), using (7), now gives

```math
\frac N{p-1}\ge (p-7)\mu-C\sqrt p\,\|\widehat T\|_1.    \tag{8}
```

For $\ell=1$ the sum of nonconstant modes is empty and the same displayed inequality remains valid.

## 4. The general Fourier criterion

Take $\ell=n=p-1$. Equations (4), (6), and (8) imply

```math
(\alpha\beta)^3
\ll p^{-1/2}\|\widehat T\|_1+R/p^2.
```

Therefore

```math
m\le|A||H|
\ll p^{11/6}\|\widehat T\|_1^{1/3}
     +p^{4/3}R^{1/3}.                                  \tag{9}
```

In particular, $\|\widehat T\|_1=o(\sqrt p)$ and $R=o(p^2)$ force vanishing edge density. Equivalently, positive-density palette and support with $o(p^2)$ omissions force $\|\widehat T\|_1\gg\sqrt p$.

Pullback along a homomorphism does not increase Fourier $\ell^1$ norm. The norm is submultiplicative under pointwise products, and averaging in $t$ only discards Fourier modes. Applying these three facts to the six factors defining $T$ gives

```math
\|\widehat T\|_1\le M_A^3M_H^3.
```

This proves (2), without a coset hypothesis.

For an interval $I$ in a finite cyclic group of order $d$, the geometric-series formula gives $\|\widehat {1_I}\|_1\ll\log(2d)$. A multiplicative-character arc condition pulls back such an interval from the image of that character. Intersecting $d_A$ such conditions for $A$ gives $M_A\ll_{d_A}(\log p)^{d_A}$, and similarly for $H$. This proves (3), with $d=d_A+d_H$. Fixed finite unions can be handled by inclusion–exclusion, with constants depending on the number of sets. No bounded-order or definability assumption on the characters is required.

## 5. Better dependence for arbitrary coset unions

Suppose both logarithmic indicators factor through $G_\ell=\mathbb Z/\ell\mathbb Z$. Define $T$ on $G_\ell^3$ by the same formula. The mean is still $\mu$, and the exact count (5) still holds because each logarithmic residue class contains exactly $(p-1)/\ell$ values of $a$.

Parseval and $0\le T\le1$ give

```math
\|\widehat T\|_1
\le\ell^{3/2}\left(\mathbb E|T|^2\right)^{1/2}
\le\ell^{3/2}\sqrt\mu.                                 \tag{10}
```

Combining (4), (8), and (10), then applying the inequality $2xy\le x^2+y^2$, yields

```math
\mu\ll \ell^3/p+R/p^2.
```

By (6), $\alpha\beta\ll \ell p^{-1/3}+(R/p^2)^{1/3}$. Multiplication by $(p-1)^2$ proves (1).

## 6. Scope and relation to the quadratic-log obstruction

The new hypotheses constrain both the palette and the potential support, whereas the fixed-formula theorem constrains only one side. These results are complementary. The present proof uses no algebraic regularity theorem, finite-cover descent, or ineffectively varying formula constants; it has an absolute numerical exponent and allows growing multiplicative complexity.

The abstract quadratic-log small-bias countermodel cannot be realized by the actual rational curve when its repeated sets factor through a quotient of order $o(p^{1/3})$ with positive densities. Equations (5)–(10) force actual configurations. At full modulus $p-1$, the general Parseval estimate is too large, and the earlier abstract countermodel remains a valid obstruction to transferring arbitrary bounded functions from only per-mode square-root cancellation. Nothing here proves the needed bound on $\|\widehat T\|_1$ for arbitrary dense sets.

Adding zero to the support contributes at most $p-1$ incidences, absorbed into the displayed upper bounds. Missing core colors or support values can be incorporated by treating all their incidences as omissions, at a cost at most $p$ times the number removed. Arbitrary additional values outside both controlled sets are not covered by the quantitative edge bounds without a further hypothesis.
