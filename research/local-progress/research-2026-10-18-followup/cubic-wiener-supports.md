# A one-sided Fourier criterion for cubic common-potential colorings

18 October 2026. This proof uses an elementary Gauss-sum operator bound. It applies to arbitrary palettes and multiplicatively regular potential supports. The complete argument passed an [independent mathematical audit](cubic-wiener-supports-independent-audit.md). Its historical novelty is unverified.

## Statement

Let $p>3$, $t\ne0$, $A\subseteq\mathbb F_p^\times$, and $H\subseteq\mathbb F_p^\times$. Prescribe the incidences

```math
(a,h)\longmapsto(h/a^2-a-ta^2,h/a).
```

Retain a subset defining at most one color on every ordered pair of endpoints. Write $R$ for the number of omitted incidences in $A\times H$ and $m$ for the retained count. With the multiplicative Fourier normalization

```math
\widehat H(\chi)=\frac1{p-1}\sum_{h\ne0}1_H(h)\overline{\chi(h)},
\qquad M_H=\sum_\chi|\widehat H(\chi)|,
```

Writing $\beta=|H|/(p-1)$, one has, with an absolute constant and for nonempty $H$,

```math
m\ll \min\{p^{7/4}M_H,\ p^{3/2}M_H^2/\beta\}+p\sqrt R. \tag{1}
```

In particular, no restriction at all is imposed on $A$. If $H$ is an arbitrary union of cosets of a common subgroup of index $\ell$, then $M_H^2\le\ell\beta$, giving

```math
m\ll \ell p^{3/2}+p\sqrt R.                         \tag{2}
```

Thus $\ell=o(p^{1/2})$ and $R=o(p^2)$ force $m=o(p^2)$. A fixed-index support coset gives $O_\ell(p^{3/2})$ edges without omissions. If $H$ is the intersection of a fixed number $d$ of multiplicative-character arc conditions, allowing arbitrary character orders, then $M_H\ll_d(\log p)^d$ and (1) gives $m\ll_d p^{7/4}(\log p)^d+p\sqrt R$. When $\beta\ge\delta>0$, this improves to $m\ll_{d,\delta}p^{3/2}(\log p)^{2d}+p\sqrt R$.

These statements concern the cubic perturbation and use only single-valued colors on edges. They are not bounds for unrestricted Erdős #810.

## 1. The collision count

Put $s=|A|$, $\beta=|H|/(p-1)$, and $L(a,b)=1+t(a+b)$. Let

```math
N=\sum_{a,b\in A}
1_H(-a^2bL(a,b))\,1_H(-ab^2L(a,b)).                  \tag{3}
```

When $a\ne b$, the two prescribed incidences in (3) have the same endpoints, with distinct colors. There are at most $s$ diagonal pairs. A fixed omitted incidence belongs to at most four ordered configurations: for fixed $(a,u)$, the equation

```math
u=-a^2b(1+t(a+b))
```

is quadratic in $b$, and the incidence may occupy either of the two ordered positions. Therefore

```math
N\le s+4R.                                         \tag{4}
```

All multiplicative characters, including the trivial one, are extended by zero at zero. Fourier inversion then gives $1_H(x)=\sum_\chi\widehat H(\chi)\chi(x)$ for every $x\in\mathbb F_p$, including zero.

## 2. The nonnegative main contribution

Expanding (3), the pair of characters $(\chi,\psi)$ contributes its coefficient times

```math
(\chi\psi)(-1)
\sum_{a,b\in A}
(\chi^2\psi)(a)(\chi\psi^2)(b)
(\chi\psi)(L(a,b)).                               \tag{5}
```

When $\psi=\chi^{-1}$, the coefficient is $|\widehat H(\chi)|^2$, and the sum is

```math
\left|\sum_{a\in A}\chi(a)\right|^2
-\sum_{\substack{a,b\in A\\L(a,b)=0}}\chi(a/b).
```

For each $a$, at most one $b$ satisfies $L(a,b)=0$. Parseval gives $\sum_\chi|\widehat H(\chi)|^2=\beta$. Hence the total contribution of these character pairs is at least

```math
\beta^2s^2-\beta s.                                \tag{6}
```

The first term uses just the trivial character inside a sum of nonnegative terms. The correction is necessary: the trivial character still vanishes at $L=0$ under the chosen extension convention.

## 3. An exact operator bound for all remaining pairs

For a nontrivial multiplicative character $\rho$, the matrix on $\mathbb F_p$ with entries

```math
K_\rho(a,b)=\rho(1+t(a+b))
```

has operator norm $\sqrt p$. Reflection in $b$ turns it into additive convolution. The Fourier coefficient at frequency zero vanishes, while each nonzero additive Fourier coefficient has absolute value $\sqrt p$: translation and scaling only contribute unit factors, and the ordinary Gauss sum has squared magnitude $p$.

For completeness, if $\xi\ne0$ and $G=\sum_{x\ne0}\rho(x)e_p(\xi x)$, then

```math
|G|^2
=\sum_{z\ne0}\rho(z)\sum_{y\ne0}e_p(\xi y(z-1))
=(p-1)-\sum_{z\ne0,1}\rho(z)=p.
```

For every pair with $\rho=\chi\psi\ne1$, the two outer weight vectors in (5) have Euclidean norm $\sqrt s$. Their bilinear sum is therefore bounded in absolute value by $\sqrt p\,s$. Summing absolute values of the Fourier coefficients bounds all these pairs by

```math
\sqrt p\,s\,M_H^2.
```

Together with (6), this proves

```math
N\ge\beta^2s^2-\beta s-\sqrt p\,sM_H^2.             \tag{7}
```

Combining (4) and (7), and using $s\le p$, yields

```math
\beta^2s^2\le p^{3/2}M_H^2+2p+4R.
```

For nonempty $H$, Fourier inversion at a point of $H$ gives $M_H\ge1$. Thus the $2p$ term is absorbed in the first term. Since $m\le s|H|=(p-1)\beta s$, this proves the first bound in (1). For the second bound, keep $s$ in the inequality rather than replacing it by $p$. With $x=\beta s$,

```math
x^2\le\frac{1+\beta+\sqrt p\,M_H^2}{\beta}\,x+4R,
```

so $x\ll\sqrt p\,M_H^2/\beta+\sqrt R$. Multiplying by $p-1$ proves the second bound in (1). Empty $H$ is trivial.

## 4. Fourier norms and a robust support-core variant

If $H$ is a union of cosets of an index-$\ell$ subgroup, its Fourier transform is supported on at most $\ell$ characters. Parseval and Cauchy–Schwarz give $M_H\le\sqrt{\ell\beta}\le\sqrt\ell$. For a character-arc condition of order $n$, the ordinary interval Fourier coefficients on $\mathbb Z/n\mathbb Z$ have absolute sum $O(1+\log n)$. Pullback by the character preserves that bound. Products of indicator functions have Fourier norm at most the product of their norms, giving the stated fixed-$d$ arc estimate. No bounded algebraic complexity or bounded character order is assumed.

There is also a dense-core version. Let $H_0\subseteq\mathbb F_p^\times$ have size at least $\delta p$, fixed $\delta>0$, and Wiener norm $M_{H_0}$. Let actual $H\subseteq\mathbb F_p$ be arbitrary, put $d=|H_0\setminus H|$, and count omissions only in $A\times(H\cap H_0)$. Then

```math
m\ll_\delta
\min\{p^{7/4}M_{H_0},\ p^{3/2}M_{H_0}^2\}
+p\sqrt{R+pd}.                                     \tag{8}
```

To verify the transfer, a fixed missing potential can occur in either ordered position; for each of the at most $p$ first colors the other color solves a quadratic, so there are at most $4p$ affected configurations. Thus the upper count (4) becomes $s+4R+4pd$. Inequality (7) applies with $H_0$, and its density lower bound controls $s$. Finally $m\le p s$ counts all actual potentials, including arbitrary extra values outside the core. The constant in (8) depends on $\delta$ in both terms.

## Limitation of the present estimate

For arbitrary $H$, Parseval only gives $M_H\le\sqrt{(p-1)\beta}$, which makes (1) trivial. The unresolved analytic issue is cancellation among the nontrivial $(\chi,\psi)$ terms of (5); controlling each shifted-character convolution separately does not resolve it. Full quartic monodromy likewise does not justify arbitrary color weights without an additional argument. The bound $p^{3/2}$ for a fixed-index support coset and the earlier bound $p^{7/4}$ for a fixed-index palette coset impose different one-sided hypotheses and must not be described as successive unrestricted records.
