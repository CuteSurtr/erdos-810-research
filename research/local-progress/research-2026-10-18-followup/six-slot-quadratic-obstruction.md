# A small-bias obstruction for the six-slot multiplicative model

18 October 2026. This note gives an explicit obstruction to one proposed proof strategy. It is not a counterexample to the actual rational-surface recurrence, and it does not establish a construction for Erdős problem 810.

## Statement

Let $G_n=\mathbb Z/n\mathbb Z$, with all expectations normalized. There are sets $A_n,H_n\subset G_n$, each of density $1/8+o(1)$, and nonnegative functions $\mu_n:G_n^3\to\mathbb R$ such that

```math
\mathbb E\mu_n=1,\qquad \|\mu_n\|_\infty\le 3,
\qquad
\max_{\xi\ne0}|\widehat\mu_n(\xi)|
\ll \frac{\tau(n)\log(2n)}n=n^{-1+o(1)}.
```

Here $\tau(n)$ is the number of positive divisors of $n$. Define

```math
\begin{aligned}
L_1&=t,&L_2&=t+y,&L_3&=t+x+y,\\
L_4&=3t+x+y-z,&L_5&=3t+2x+y-z,&L_6&=3t+2x+2y-z.
\end{aligned}
```

Nevertheless,

```math
\mathbb E_{t,x,y,z}\mu_n(x,y,z)
\prod_{i=1}^3 1_{A_n}(L_i)
\prod_{i=4}^6 1_{H_n}(L_i)=0,
```

whereas the same average with $\mu_n$ replaced by $1$ is at least

```math
\left(\frac{|A_n|}{n}\frac{|H_n|}{n}\right)^3
=8^{-6}+o(1)>0.
```

The result holds for every sufficiently large integer $n$, so in particular for $n=p-1$, the order of the multiplicative group of a prime field. Thus even stronger than square-root cancellation of every nonconstant multiplicative character mode does not, by itself, transfer the positive torus model to the six-slot recurrence.

## Construction and exact vanishing

Put $M=\lfloor n/16\rfloor$ and let $J$ be the residues represented by the integers from $-M$ to $M$. Let $I=J-J+J-J$, the interval from $-4M$ to $4M$; there is no wraparound because $8M<n$. Set

```math
A_n=\{s:3s^2\in J\},\qquad H_n=\{s:s^2\in J\},
\qquad w=1_{G_n\setminus I}.
```

The quadratic identity

```math
3L_3^2-3L_2^2+L_4^2-L_5^2=2x(2y+z)=:Q(x,y,z)
```

holds over every commutative ring. If all six membership tests hold, then already the four tests at slots $2,3,4,5$ force $Q\in I$. Therefore $w(Q)=0$ on every such tuple. Define

```math
\rho_n=\mathbb E_{x,y,z}w(Q(x,y,z)),
\qquad \mu_n=w(Q)/\rho_n.
```

The estimates below give $\rho_n=1/2+o(1)$, proving the stated normalization and boundedness. Exact vanishing follows directly from the identity.

## Fourier bounds, including composite moduli

Write $e_n(s)=\exp(2\pi i s/n)$ and
$\widehat f(s)=\mathbb E_u f(u)e_n(-su)$.
For an interval in $G_n$ and $s\ne0$, the geometric-series formula gives

```math
|\widehat {1_I}(s)|\ll\frac1{\min(s,n-s)}.
```

The same estimate applies to $\widehat w(s)$ for $s\ne0$.

For $d_s=\gcd(2s,n)$, averaging first in $v$ gives

```math
\left|\mathbb E_{x,v}e_n(2sxv-ax-cv)\right|\le\frac{d_s}{n}.
```

Indeed the inner average is zero unless $2sx=c$; that congruence has either zero or $d_s$ solutions. For $a=c=0$ the average equals $d_s/n$.

Change variables from $(x,y,z)$ to $(x,y,v=2y+z)$. In the Fourier coefficient at $(a,b,c)$, the $y$ average vanishes unless $b=2c$. If $b=2c$ and $(a,b,c)\ne0$, the constant Fourier mode of $w$ vanishes after averaging $(x,v)$, so

```math
|\widehat {w(Q)}(a,b,c)|
\le\frac1n\sum_{s\ne0}|\widehat w(s)|\gcd(2s,n)
\ll\frac{\tau(n)\log(2n)}n.
```

For completeness, using $\gcd(2s,n)\le2\gcd(s,n)$ and symmetry about $n/2$, the required divisor estimate is

```math
\sum_{s=1}^{\lfloor n/2\rfloor}\frac{\gcd(s,n)}s
\le\sum_{d\mid n}d\sum_{\substack{s\le n/2\\d\mid s}}\frac1s
\le\tau(n)(1+\log n).
```

The zero-frequency calculation, with the constant mode retained, yields

```math
\rho_n=\frac{|G_n\setminus I|}{n}
+O\!\left(\frac{\tau(n)\log(2n)}n\right)
=\frac12+o(1).
```

Dividing the nonconstant coefficient bound by $\rho_n$ proves the asserted Fourier estimate. The elementary estimate $\tau(n)=n^{o(1)}$ follows, for example, by separating the finitely many primes below $2^{2/\varepsilon}$ and bounding each remaining prime-power divisor factor by its $\varepsilon$-power contribution; this gives $\tau(n)\ll_\varepsilon n^\varepsilon$ for every $\varepsilon>0$.

## Densities of the repeated sets

For every integer $k$,

```math
\left|\mathbb E_u e_n(ku^2)\right|
\le\sqrt{\frac{\gcd(2k,n)}n}.
```

To verify this, square the absolute value, substitute the difference $h$ of the two arguments, and average the remaining linear phase. Only $h$ with $2kh=0$ survive; their number is $\gcd(2k,n)$.

Expanding $1_J$ and applying this estimate with $k=s$ and $k=3s$ gives

```math
\frac{|A_n|}{n},\frac{|H_n|}{n}
=\frac{|J|}{n}
+O\!\left(\frac{\tau(n)\log(2n)}{\sqrt n}\right)
=\frac18+o(1).
```

One can obtain the displayed error by the interval coefficient bound and

```math
\sum_{s=1}^{\lfloor n/2\rfloor}\frac{\sqrt{\gcd(s,n)}}s
\le\sum_{d\mid n}d^{-1/2}(1+\log n)
\le\tau(n)(1+\log n).
```

No assumption that $n$ is prime, odd, or coprime to $3$ is needed.

## Positive uniform model

Use the bijective change of variables

```math
a=L_1,\quad b=L_2,\quad c=L_3,
\quad S=L_1+L_6=4t+2x+2y-z.
```

Its inverse is $t=a$, $y=b-a$, $x=c-b$, $z=2a+2c-S$. Then $(L_4,L_5,L_6)=(S-c,S-b,S-a)$. Consequently the uniform count is

```math
\mathbb E_S\left(\mathbb E_a1_{A_n}(a)1_{H_n}(S-a)\right)^3
\ge
\left(\mathbb E_{S,a}1_{A_n}(a)1_{H_n}(S-a)\right)^3
=\left(\frac{|A_n||H_n|}{n^2}\right)^3.
```

This also identifies the two universal additive relations among the six logarithmic coordinates; writing the actual potential coordinates as $(u,v,k)$, multiplicatively they are $ak=bv=cu$.

## Compatibility with the same-edge collision restriction

For $n$ divisible by six, replace the repeated sets by

```math
A'_n=A_n\cap\{s:s\equiv0\pmod3\},\qquad
H'_n=H_n\cap\{s:s\equiv1\pmod3\}.
```

Keep exactly the same measure $\mu_n$. Both densities are $1/24+o(1)$; the Fourier estimate and exact vanishing remain valid. For the density assertion, expand the residue-class indicator into its three linear characters. The quadratic Gauss estimate used above remains valid with any additional linear phase:

```math
\left|\mathbb E_u e_n(ku^2+\ell u)\right|
\le\sqrt{\gcd(2k,n)/n}.
```

The proof by squaring and taking the difference of arguments is unchanged. Combining this with the interval expansion gives the same $O(\tau(n)\log(2n)/\sqrt n)$ error, and the constant quadratic mode contributes one third of the previous main term. The uniform six-slot model still has positive lower bound $(24^{-2}+o(1))^3$ by Jensen.

When $n=p-1$ with $p\equiv1\pmod3$, the common translation $\log(-1)=n/2$ is divisible by three. Thus the actual multiplicative palette represented by $A'_n$ consists of cubes, while the actual support represented by $H'_n$ (including that common translation if needed) lies in one noncube class. The only way two distinct colors $a,b$ represent the same graph edge is to use potentials $-a^2b$ and $-ab^2$. Both are cubes when $a,b$ and $-1$ are cubes, so neither lies in this support. The resulting common-potential family is therefore simple. Each individual color is automatically a matching because both endpoint coordinates are injective functions of its potential.

This is still an abstract parameter-measure countermodel, not an actual rational-curve construction. It establishes that adding the elementary same-edge collision restriction and matching condition does not repair the proposed small-Fourier-bias transfer argument. The actual curve may satisfy additional constraints that force configurations; in particular, the [growing-index Fourier criterion](growing-index-wiener-palettes.md) rules out actual counterexamples when the entire repeated-set condition factors through a quotient of order $o(p^{1/3})$.

## Relation to the actual rational surface

For the equal-cross configuration, put

```math
r(q)=\frac{q+1}{q^2+1},\quad B(q)=q^2+q+1,
\quad x=\log q,\quad y=\log r(q),\quad z=\log B(q).
```

With $t=\log a$, the six output logarithms have the forms above, up to the same fixed translation $\log(-1)$ in the last three slots. Translating $H_n$ removes this constant. The actual parameter measure is supported on this rationally parametrized curve in $G_{p-1}^3$. The constructed $\mu_n$ is a different measure and is not asserted to arise from such a curve.

The conclusion is therefore limited but decisive: a proof using only small nontrivial Fourier coefficients of the parameter measure and the two universal multiplicative relations cannot establish the required recurrence, even with identical sets in each group of three slots. Extra information about the actual curve is essential. One possible missing input is control of quadratic logarithmic correlations, including

```math
\mathbb E_q e_{p-1}\!\left(2\log q\,[2\log r(q)+\log B(q)]\right).
```

The ordinary multiplicative-character Weil bound does not estimate this expression: its character exponent varies with $q$. A successful argument need not establish this exact estimate, but it must overcome the obstruction represented by these quadratic phases.

## The complete quadratic unary-phase obstruction space

Over a field of characteristic zero, or of characteristic greater than $3$, suppose $\sum_{i=1}^6 c_iL_i^2$ is independent of $t$. Equating the coefficients of $t^2,tx,ty,tz$ gives

```math
c_4+c_5+c_6=0,\qquad
(c_1,c_2,c_3)=(3c_6,3c_5,3c_4).
```

Consequently the resulting quadratic form is a linear combination of

```math
Q_1=3L_3^2-3L_2^2+L_4^2-L_5^2=2x(2y+z),
```

and

```math
Q_2=3L_3^2-3L_1^2+L_4^2-L_6^2=2z(x+y).
```

There is no nonzero cubic unary combination $\sum_i c_iL_i^3$ independent of $t$. Indeed, its $tz^2,txz,tyz$ coefficients imply respectively

```math
c_4+c_5+c_6=0,\quad c_4+2c_5+2c_6=0,
\quad c_4+c_5+2c_6=0,
```

so $c_4=c_5=c_6=0$. The $tx^2,ty^2,t^3$ coefficients then force $c_3=c_2=c_1=0$. More generally, no highest degree $d\ge3$ is possible in a unary polynomial identity independent of $t$, in characteristic zero or greater than $d$: differentiate its homogeneous degree-$d$ part $d-3$ times in $t$. For $d=3$ the previous argument applies directly, and for $d>3$ the resulting homogeneous cubic combination vanishes. Each original leading coefficient is multiplied by a nonzero scalar, so all vanish.

This elementary classification makes the first higher-order tests explicit. It is not a characteristic-factor theorem for arbitrary bounded functions, and does not justify reducing arbitrary sets to polynomial phases.

## Updated primary-source check

Nikos Frantzikinakis, [*Decomposition results for multiplicative actions and applications*, v4, 9 October 2026](https://arxiv.org/pdf/2503.15175), Theorems 2.1–2.2, proves recurrence for linear forms and certain pairs of rational iterates. General recurrence for several rational iterates factoring into linear forms remains Conjecture 2 in §9.1. These results do not directly supply six simultaneous tests along our shared rational parameter. Moreover, qualitative recurrence for a fixed finite multiplicative action can occur on parameter residue classes yielding degenerate configurations; a uniform finite-field conclusion needs a separate nondegeneracy argument.

James Leng, Redmond McNamara and Andreas Mountakis, [*Monochromatic Almost-Pythagorean Quadruples*, 2 October 2026](https://arxiv.org/pdf/2610.04078), Theorem 4, allows several polynomial triples. Its parameter pairs are independent across triples, and an additional freely chosen multiplicative divisor occurs in one ratio of each triple. No identification preserving our single shared parameter, all three palette memberships, and all three potential memberships has been obtained. Its two-set recurrence therefore does not presently close this gap.

Dimitrios Charamaras, Andreas Koutsogiannis and Konstantinos Tsinas, [*Multiple ergodic averages for commuting multiplicative actions*, September 2026](https://arxiv.org/pdf/2609.00405), Theorem 1.1, establishes convergence for commuting finitely generated actions evaluated at the same integer. This is not a positivity theorem for the rational iterates required here.

William D. Banks and Igor E. Shparlinski, [*Exponential sums with polynomial values of the discrete logarithm*, Uniform Distribution Theory 2(2) (2007), 67–72](https://pcwww.liv.ac.uk/~karpenk/JournalUDT/vol02/no2/BanShpa07.pdf), Lemma 1, gives a power saving for a polynomial in a **single** discrete logarithm with a nonzero additive field twist. Its Weyl differencing lowers the polynomial degree because replacing $q$ by $cq$ adds a constant to $\log q$. For $Q_1$ or $Q_2$ on our curve, the same change introduces $\log r(cq)$ and $\log B(cq)$, which are not constant translates of their original logarithms. No degree-lowering reduction follows. The indexed lemma and proof were inspected; the full PDF fetch timed out.

Lucas Reis, [*Arithmetic constraints of polynomial maps through discrete logarithms*](https://arxiv.org/pdf/2007.04114), Theorem 2.3, counts prescribed logarithmic residue classes by ordinary multiplicative-character expansions. Its error is a fixed root-count constant times the square root of the field size. This applies to bounded-index constraints and does not estimate quadratic products of logarithms with growing modulus.

These are applicability checks, not assertions that no relevant theorem exists elsewhere. The countermodel is a concrete proof-strategy obstruction; historical novelty is not claimed.
