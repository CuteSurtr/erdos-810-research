# An explicit correlation forced by the quadratic-log obstruction

18 October 2026. This is a reduction for one particular family of potential counterexamples. It does not prove cancellation of the resulting sums and does not treat arbitrary dense sets. It sharpens the remaining test beyond a generic lower bound on a Fourier norm, while retaining the simplicity condition.

## 1. The restricted family and the conclusion

Let $p\equiv1\pmod3$ be prime, let $n=p-1$, and choose a generator of $\mathbb F_p^\times$. All logarithms take values in $G_n=\mathbb Z/n\mathbb Z$, and $e=\log(-1)=n/2$ is divisible by three.

Choose fixed continuous nonnegative functions $w_A,w_H:\mathbb R/\mathbb Z\to[0,1]$ with positive integrals, supported inside fixed proper arcs. Define multiplicative sets by the logarithmic tests

```math
A_p=\{a:\log a\equiv0\pmod3,
                \ w_A(3(\log a)^2/n)>0\},
```

```math
H_p=\{h:\log h-e\equiv1\pmod3,
                \ w_H((\log h-e)^2/n)>0\}.
```

Arguments of $w_A,w_H$ are read modulo one; the quadratic residues modulo $n$ make these definitions independent of integer representatives. These sets have positive densities bounded away from zero for large $p$. For example, continuous bump functions supported inside the arcs used in the earlier obstruction give exactly the kind of repeated sets considered there, with smaller supports if desired.

The palette consists of cubes and the potential support lies in a noncube class. Thus their quadratic common-potential family is simple: the collision potentials $-a^2b$ and $-ab^2$ are cubes and are excluded. Individual colors are automatically matchings.

Define

```math
r(q)=\frac{q+1}{q^2+1},\qquad B(q)=q^2+q+1,
```

```math
x=\log q,\quad y=\log r(q),\quad z=\log B(q),
```

```math
Q_1(x,y,z)=2x(2y+z),\qquad Q_2(x,y,z)=2z(x+y).
```

Let $\Omega$ be the nondegenerate parameter set excluding $0,1,-1$ and the roots of $(q^2+1)B(q)$.

If, along a sequence of such primes, the completed family can be made a rainbow-four-cycle coloring after omitting $o(p^2)$ incidences, then there are **fixed integers** $(j,k)\ne(0,0)$ and fixed $(u,v,w)\in\{0,1,2\}^3$ for which, on a subsequence,

```math
\left|\frac1p\sum_{q\in\Omega}
e_n\!\bigl(jQ_1(x,y,z)+kQ_2(x,y,z)\bigr)
e_3(ux+vy+wz)\right|\ge c>0.                  \tag{1}
```

The integers and the constant may depend on the two fixed bump functions, but not on $p$ along that subsequence. Thus cancellation for every fixed nonzero $(j,k)$, even allowing an order-three multiplicative-character twist, would rule out this explicit class of simple quadratic-log obstructions.

## 2. Averaging the common scale

Use the six forms

```math
\begin{aligned}
L_1&=t,&L_2&=t+y,&L_3&=t+x+y,\\
L_4&=3t+x+y-z,&L_5&=3t+2x+y-z,&L_6&=3t+2x+2y-z.
\end{aligned}
```

The actual color logs are the first three forms, and the actual potential logs are the last three plus $e$. Consequently all six residue conditions are precisely

```math
t\equiv x\equiv y\equiv0\pmod3,\qquad z\equiv2\pmod3.   \tag{2}
```

Let $W_p$ denote the normalized weighted configuration count, averaged over $t\in G_n$ and $q\in\Omega$ with normalization $np$. Its summand is the indicator of (2), multiplied by

```math
\prod_{i=1}^3w_A(3L_i^2/n)
\prod_{i=4}^6w_H(L_i^2/n).
```

It is nonnegative and at most the unweighted configuration indicator. Each missing actual incidence kills at most sixteen ordered configurations, so the stated omission hypothesis implies $W_p=o(1)$.

## 3. Which fixed Fourier modes can survive?

Approximate each fixed bump uniformly by a trigonometric polynomial, with a sufficiently small fixed error. One can use Fejér polynomials, whose constant coefficient equals the integral of the bump. The degrees are fixed independently of $p$. The error in the product of six bounded factors is uniformly small.

For one frequency tuple $(m_1,\ldots,m_6)$ in the resulting finite expansion, write

```math
(c_1,c_2,c_3)=(3m_1,3m_2,3m_3),\qquad
(c_4,c_5,c_6)=(m_4,m_5,m_6),
```

and

```math
\sum_{i=1}^6c_iL_i^2=Ut^2+V(x,y,z)t+W(x,y,z).
```

Here $U$ is a fixed integer, and $V$ is a fixed integral linear form. Put $m=n/3$. Averaging with the condition $t\equiv0\pmod3$ gives exactly

```math
\mathbb E_{t\in G_n}1_{3\mid t}e_n(Ut^2+Vt+W)
=\frac13e_n(W)\mathbb E_{s\in G_m}e_m(3Us^2+Vs).        \tag{3}
```

If $U\ne0$, the elementary quadratic Gauss estimate bounds the last average by

```math
\sqrt{\gcd(6U,m)/m}=O_U(n^{-1/2}).
```

This estimate follows by squaring, taking the difference of the two arguments, and noting that the remaining linear average vanishes unless $6Us=0$ modulo $m$. It remains valid for composite $m$ and arbitrary $V$.

If $U=0$ but $V=v_1x+v_2y+v_3z$ is not the zero integral form, (3) vanishes unless $V\equiv0\pmod m$. This implies

```math
\bigl(q^{v_1}r(q)^{v_2}B(q)^{v_3}\bigr)^3=1.
```

The rational function in parentheses is nonconstant: valuations at $q=0$, $q=-1$, and the roots of $B$ prove multiplicative independence of $q,r,B$. For fixed exponents, the displayed equation has only $O_{v_1,v_2,v_3}(1)$ roots, excluding at most finitely many primes where the fixed integral identity degenerates. Its normalized contribution is therefore $o(1)$.

The only remaining terms have $U=0$ and $V=0$ identically. The elementary coefficient classification proved in the [quadratic-obstruction note](six-slot-quadratic-obstruction.md) gives

```math
c_4+c_5+c_6=0,\qquad
(c_1,c_2,c_3)=(3c_6,3c_5,3c_4).
```

Thus for integers $j,k$,

```math
(m_1,m_2,m_3)=(-k,-j,j+k),\qquad
(m_4,m_5,m_6)=(j+k,-j,-k),
```

and $W=jQ_1+kQ_2$. The zero pair $(j,k)=(0,0)$ is exactly the all-zero frequency tuple.

## 4. Positivity of the constant term and the forced correlation

The constant tuple contributes

```math
\left(\int w_A\right)^3\left(\int w_H\right)^3
\cdot\frac13\cdot\frac1p
\#\{q\in\Omega:x\equiv y\equiv0,\ z\equiv2\pmod3\}.
```

The character-sum calculation in the [growing-index note](growing-index-wiener-palettes.md) gives the last normalized cardinality as $1/27+O(p^{-1/2})$. The constant contribution therefore tends to

```math
c_0=\frac1{81}\left(\int w_A\right)^3\left(\int w_H\right)^3>0.
```

Choose the uniform trigonometric approximation error small enough that the total product error is at most $c_0/4$. All modes except the finitely many nonzero pairs $(j,k)$ identified above contribute $o(1)$. Since $W_p=o(1)$, at least one of those finitely many pairs must have a correlation bounded away from zero on a subsequence, with the extra indicator $x\equiv y\equiv0,z\equiv2\pmod3$.

Expand that indicator into its twenty-seven order-three characters. At least one character-twisted correlation is bounded away from zero as well. Passing to a further subsequence fixes its three exponents and gives (1).

The positive density assertion for the supports follows from the same elementary Gauss estimate and continuous trigonometric approximation: each fixed nonconstant quadratic mode has average $o(1)$ even after restricting to any fixed residue class modulo three. The weighted means tend to $(\int w_A)/3$ and $(\int w_H)/3$, respectively, so their supports have positive density.

## 5. The remaining gap

The character exponents in (1) depend quadratically on discrete logarithms of distinct rational functions. The standard multiplicative-character Weil estimate does not apply to that part of the summand. The bounded-order twist is harmless, but it does not linearize $Q_1$ or $Q_2$.

No cancellation estimate for (1) has been proved here. The conclusion is a precise necessary correlation for the specific quadratic-arc construction, compatible with simplicity and with small incidence deletions. It does not show that every arbitrary dense obstruction is governed by quadratic phases, nor that controlling this two-parameter family would settle the common-potential problem for arbitrary sets.
