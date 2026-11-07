# Optimal linear Fourier flatness does not force four-slot positivity

18 October 2026. The construction and composite-modulus estimates below passed an [independent mathematical audit](cubic-four-slot-fourier-independent-audit.md). They obstruct an inference based only on nonnegative weights and small linear Fourier coefficients. The constructed weight is not the measure of the actual cubic collision surface, and the result is not a graph counterexample.

This is an elementary obstruction to a proposed proof strategy, with historical novelty unverified; no new general Fourier theorem is claimed.

## 1. Four logarithmic slots

On $G_n=\mathbb Z/n\mathbb Z$, use the forms

```math
L_1=t,\quad L_2=t+x,\quad
L_3=3t+x+z,\quad L_4=3t+2x+z.
```

They satisfy the universal relation $L_1+L_4=L_2+L_3$. The map $(t,x,z)\mapsto(L_1,L_2,L_3)$ is unimodular, so uniform averaging over the three parameters is uniform averaging over the three freely chosen slots.

For arbitrary subsets $A,H\subseteq G_n$ with densities $\alpha,\beta$, their uniform four-slot count is

```math
\mathbb E_{t,x,z}
1_A(L_1)1_A(L_2)1_H(L_3)1_H(L_4)
=\sum_\gamma |\widehat{1_A}(\gamma)|^2
                   |\widehat{1_H}(\gamma)|^2
\ge\alpha^2\beta^2.                                \tag{1}
```

This is the ordinary cross additive-energy identity. In particular, the universal relation itself does not prevent positivity for repeated sets.

## 2. Dense repeated sets and a weight that annihilates them

Choose a fixed closed arc $J$ centered at zero in $\mathbb R/\mathbb Z$, of positive length small enough that $3J-J$ is a proper arc. Define

```math
S_n=\{s\in G_n:s^2/n\pmod1\in J\},\qquad A=H=S_n.
```

These sets have density tending to $|J|>0$ as $n\to\infty$. Indeed, for every fixed nonzero integer $k$,

```math
\left|\mathbb E_{s\in G_n}e_n(ks^2)\right|
\le\sqrt{\gcd(2k,n)/n}\longrightarrow0.
```

Trigonometric approximation, followed by approximation of the arc indicator, gives the density assertion. No primality or factorization condition on $n$ is needed.

Choose a fixed smooth nonnegative periodic function $w$, vanishing on $3J-J$, positive somewhere outside that arc. Put

```math
Q=L_1^2+L_2^2+L_3^2-L_4^2
 =2t^2-4tx-2x^2-2xz,
```

and define, for all sufficiently large $n$,

```math
\mu_n(t,x,z)=\frac{w(Q/n)}{\mathbb E_{t,x,z}w(Q/n)}. \tag{2}
```

Its denominator tends to the positive number $\int w$, as proved below. Thus these are nonnegative weights with mean one and a uniform pointwise upper bound.

Whenever all four slots lie in $S_n$, the value $Q/n$ lies in $3J-J$ modulo one. Therefore

```math
\mathbb E_{t,x,z}\mu_n(t,x,z)
1_{S_n}(L_1)1_{S_n}(L_2)1_{S_n}(L_3)1_{S_n}(L_4)=0.  \tag{3}
```

All expressions are independent of the chosen integer representatives modulo $n$.

## 3. A uniform composite-modulus quadratic estimate

The unimodular change

```math
u=t-x,\qquad v=z+2x
```

gives

```math
Q=2u^2-2xv.                                        \tag{4}
```

For every $s\in G_n$ and every linear phase in the three variables, the normalized quadratic average consequently factors into a one-variable quadratic sum and a bilinear sum. The first has modulus at most

```math
\sqrt{\gcd(4s,n)/n}.
```

This follows by squaring its absolute value and averaging over the difference of two inputs: the remaining linear sum vanishes unless $4s$ times that difference is zero modulo $n$.

The bilinear average has modulus at most $\gcd(2s,n)/n$. Indeed, averaging one variable forces a congruence $2sx=\gamma$, with at most $\gcd(2s,n)$ solutions. The remaining linear phase can only reduce the bound. Since $\gcd(4s,n)\le2\gcd(2s,n)$, the full estimate is

```math
\left|\mathbb E_{t,x,z}e_n(sQ+\ell_1t+\ell_2x+\ell_3z)\right|
\le\sqrt2\left(\frac{\gcd(2s,n)}n\right)^{3/2}.      \tag{5}
```

This holds for every modulus, with no oddness or squarefreeness assumption. For $s\ne0$, let $d(s)=\min(s,n-s)$ using representatives $1,\ldots,n-1$. Then $\gcd(2s,n)\le2d(s)$.

## 4. Optimal-size linear Fourier coefficients

Let $c_{n,s}$ be the discrete Fourier coefficients of the sampled values $w(j/n)$. Smoothness and the aliasing formula for its continuous Fourier series give, for every fixed $M$,

```math
|c_{n,s}|\ll_{w,M}d(s)^{-M}\quad(s\ne0),
\qquad c_{n,0}=\int w+O_{w,M}(n^{-M}).
```

Expand $w(Q/n)=\sum_s c_{n,s}e_n(sQ)$. At any nonzero linear frequency, the term $s=0$ contributes zero. Using (5), $\gcd(2s,n)\le2d(s)$, and any $M>5/2$ yields

```math
\max_{\boldsymbol\ell\ne0}
\left|\mathbb E_{t,x,z}
w(Q/n)e_n(\ell_1t+\ell_2x+\ell_3z)\right|
\ll_w n^{-3/2}.                                   \tag{6}
```

The same estimate for the nonzero $s$ terms at zero linear frequency gives

```math
\mathbb E w(Q/n)=\int w+O_w(n^{-3/2}).
```

Normalizing in (2), we obtain

```math
\max_{\boldsymbol\ell\ne0}|\widehat{\mu_n}(\boldsymbol\ell)|
\ll_w n^{-3/2}.                                    \tag{7}
```

This scale is optimal for a bounded weight whose variance stays positive on a group of size $n^3$. Applying the same mean calculation to $w^2$ shows that the variance of $\mu_n$ tends to $\int w^2/(\int w)^2-1>0$. Parseval therefore also gives a lower bound $\max_{\boldsymbol\ell\ne0}|\widehat{\mu_n}(\boldsymbol\ell)|\gg_w n^{-3/2}$.

Despite this optimal linear Fourier flatness, (3) is zero, whereas the uniform count in (1) tends to a positive constant.

## 5. Comparison with the actual cubic parameter measure

For the cubic collision model with coefficient $\kappa\ne0$, put $n=p-1$ and, for $a,b\ne0$ with $1+\kappa(a+b)\ne0$, set

```math
t=\log a,\quad x=\log(b/a),\quad
z=\log(1+\kappa(a+b)).
```

The color logs are $L_1,L_2$. The potential logs are $L_3+e,L_4+e$, where $e=\log(-1)$. Thus the support slots above use the shifted logarithmic support $\log H-e$. This fixed shift does not change the universal relation.

The actual parameter set has

```math
D=(p-1)^2-(p-2)=p^2-3p+3
```

points. Every nontrivial linear Fourier coefficient of its normalized measure is $O(1/p)$. Here is an elementary verification. Such a coefficient is, up to constant unit factors, a normalized sum

```math
\sum_{r,s\in\mathbb F_p}
\alpha(r)\beta(s)\gamma(1-r-s),                      \tag{8}
```

where the characters are extended by zero at zero and are not all trivial. The change from the original three frequency characters to $\alpha,\beta,\gamma$ is invertible. For additive frequency $\xi\ne0$, the Fourier transform of a nontrivial multiplicative character has magnitude $\sqrt p$, while that of the extended trivial character has magnitude one. The zero-frequency product vanishes because at least one character is nontrivial. Fourier inversion for the triple convolution in (8) leaves one ordinary Gauss sum for the product character, or the sum $-1$ if that product is trivial. In every case the absolute value of (8) is at most $p$. Division by $D$ proves the stated $O(1/p)$ bound.

The artificial weights (2) have even smaller linear Fourier coefficients, yet fail the desired positivity completely. Thus those linear character estimates alone cannot imply positivity for arbitrary repeated palette and support sets. A successful argument must exploit additional information about the actual cubic parameter surface, or control higher-degree correlations. This note supplies neither a counterexample on that actual surface nor a claim that the graph problem is false.
