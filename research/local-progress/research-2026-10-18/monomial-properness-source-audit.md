# Monomial properness bound: source and scope audit

18 October 2026. The character estimate below is a direct application of the classical Weil bound. The exact coloring formulation was not located in the limited source check, but no claim of originality follows from that fact.

## Verified theorem and its exact use

Iwaniec and Kowalski, [*Analytic Number Theory*, Theorem 11.23, printed p.289](https://people.math.ethz.ch/~kowalski/ik-ant-exp-sums.pdf), gives the multiplicative-character bound $(m-1)\sqrt p$ when the polynomial has $m$ distinct roots and is not a power of the character's order. The number of distinct roots, rather than polynomial degree, is the relevant parameter. The same page derives Corollary 11.24 by using large exponents to replace inverse characters. This is the checked source for precisely that maneuver here.

The historical original is Weil, [*On Some Exponential Sums*, PNAS 34 (1948), 204–207](https://doi.org/10.1073/pnas.34.5.204). Its bibliographic identity was verified, but the original scan was inaccessible in this pass. The exact theorem used here was checked in the author-hosted Iwaniec–Kowalski text, not inferred from the unavailable scan.

Fix $d\ge3$, put $e=d-1\ge2$, and assume $p>e$. Write

```math
S_e(q)=1+q+\cdots+q^{e-1}=\frac{q^e-1}{q-1},
\qquad P(q)=qS_e(q).
```

For arbitrary multiplicative $\eta$ and nontrivial multiplicative $\chi$, the needed estimate is

```math
\left|\sum_{q\in\mathbb F_p^*,\ P(q)\ne0}
\eta(q)\chi(P(q)^{-1})\right|
\le(e-1)\sqrt p+1.
\tag{1}
```

To check the power obstruction exactly, let $\theta$ generate the character group of order $M=p-1$, and write $\chi=\theta^k$ with $1\le k<M$, $\eta=\theta^j$. Away from the excluded zeros the summand equals $\theta(F(q))$, where

```math
F(q)=q^{\ell}S_e(q)^{M-k},\qquad
\ell\equiv j-k\pmod M,\quad0\le\ell<M.
```

The polynomial $S_e$ has $e-1$ distinct nonzero roots over the algebraic closure, because $p\nmid e$. At each such root the multiplicity in $F$ is $M-k$, which is not divisible by $M$. Thus $F$ is not an $M$th power even over the algebraic closure. It has at most $e$ distinct roots. The theorem applies; the possible contribution of $q=0$ changes the sum by at most one. This proves (1), uniformly in both characters and in $p$.

## Operator normalization

On $\ell^2(\mathbb F_p^*)$ with counting measure, the unnormalized multiplicative convolution kernel

```math
K_\chi(q)=1_{\{P(q)\ne0\}}\chi(P(q)^{-1})
```

has operator norm equal to the largest absolute Mellin coefficient in (1). The collision phase

```math
\chi\!\left(-\frac{\lambda u^e}{P(v/u)}\right)
```

differs from that convolution kernel only by a unit-modulus diagonal factor in $u$ and a constant. Therefore its sum over $u,v\in L$ is bounded by $((e-1)\sqrt p+1)|L|$. No Fourier $\ell^1$ loss is incurred: this is an operator norm estimate, not a sum of independently bounded Fourier modes against six arbitrary functions.

## Coloring consequence and the exceptional quadratic case

For the full palette $y=ax+a^d$ and potential $h=a^{d-1}y$, intersecting the two color lines $a$ and $aq$ gives

```math
h_1=-a^{2e+1}P(q),\qquad h_2=q^e h_1.
```

Lift a single $e$th-power coset by $h=\lambda u^e$. The root condition is $a^{2e+1}=-\lambda u^e/P(v/u)$. Expanding the number of roots with the at most $2e+1$ characters of order dividing $2e+1$, (1) bounds every nontrivial term by $O_d(\sqrt p|L|)$. Zeros of $P$ exclude only $O_d(|L|)$ pairs. Properness forbids the remaining off-diagonal collisions; the diagonal has only $O_d(|L|)$ roots. Thus $|L|=O_d(\sqrt p)$ and consequently $|H|=O_d(\sqrt p)$. The largest $e$th-power-coset lift has size at least $|H\setminus\{0\}|$, so passing to a coset loses only a fixed factor, and zero potential adds at most $p-1$ incidences.

This proves a full-palette $O_d(p^{3/2})$ edge bound using properness alone. It supersedes the $O(p^{63/32})$ cubic-palette consequence of the more elaborate correspondence argument. The latter's geometry may still be correct, but it does not improve the extremal conclusion in this completed model. Robust deletion bounds require the separate collision-multiplicity check recorded elsewhere.

For $d=2$, one has $e=1$ and $P(q)=q$. There is no nonzero root that prevents character cancellation: choosing $\eta=\chi$ makes the summand identically one. Thus (1) genuinely fails in that case. The quadratic common-potential rainbow-cycle theorem is not subsumed by this properness argument.

## Limited novelty comparison

The inspected exact-word searches did not locate this monomial affine/common-potential statement. The similarly titled recent [*Coloring Monomial Cayley Graphs: The One-Parameter Case*](https://arxiv.org/abs/2610.09474) concerns unit-distance vertex colorings in the complex plane and is not a match. The underlying method here is the standard character-sum/spectral method for algebraic relations, and the only analytic input is the classical bound (1). The defensible description is an elementary application of known estimates whose exact prior formulation has not been established, not a new exponential-sum theorem or a certified new advance on Erdős problem 810.
