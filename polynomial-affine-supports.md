# Fixed-degree nonlinear polynomial intercepts: a common-support power saving

This is a restricted-class theorem for proper $`B`$-colorings, not a solution of unrestricted Erdős problem #810. The proof uses the classical Weil bound for prime-field Kloosterman sums. Historical priority of this formulation has not been established.

## 1. Theorem

Let $`p`$ be an odd prime, and let $`\beta\in\mathbb F_p[T]`$ have degree $`D`$, where $`2\le D<p`$. Let $`A\subseteq\mathbb F_p^\times`$ have size $`d`$. For each $`a\in A`$, choose $`D_a\subseteq X\subseteq\mathbb F_p`$, and select the edges

```math
x\longmapsto \sigma_a(x)=ax+\beta(a),\qquad x\in D_a,
```

with color $`a`$. Assume that the selected graph is simple and properly colored, and that every $`C_4`$ is rainbow (condition $`B`$). Set

```math
m=\sum_{a\in A}|D_a|,
\qquad
R=\sum_{a\in A}\bigl(|X|-|D_a|\bigr).
```

For each fixed $`D`$, there is a constant $`C_D`$, independent of $`p,\beta,A,X`$, such that

```math
m\le C_Dp^{19/10}+\sqrt{2}\,p\sqrt R.
\tag{1}
```

Consequently, common support gives $`O_D(p^{19/10})`$ edges, and $`R=o(p^2)`$ gives $`m=o(p^2)`$ for bounded $`D`$. Common support together with $`d\ge\delta p`$ gives the sharper estimate $`O_{D,\delta}(p^{15/8})`$.

The exclusion of degree at most one is essential to this power-saving argument. Such intercepts give concurrent affine pencils. The theorem does not assume additive or multiplicative structure of $`A`$, and $`\beta`$ may vary with $`p`$ subject to the fixed degree bound.

## 2. Crossed involutions and the combinatorial estimate

On $`V=\mathbb F_p^2`$, define

```math
\tau_a(x,y)=\left(\frac{y-\beta(a)}a,\;ax+\beta(a)\right),
\qquad
S_Af=\sum_{a\in A}f\circ\tau_a.
```

These maps are involutions, so $`S_A`$ is self-adjoint and has constant degree $`d`$.

Let $`E`$ be the selected edge set. An internal transition is an ordered triple $`(a,x,z)`$ such that both $`(x,\sigma_a(z))`$ and $`(z,\sigma_a(x))`$ lie in $`E`$. If the two diagonal color-$`a`$ incidences at $`x,z`$ are present, condition $`B`$ forces $`x=z`$. The actual loops contribute exactly $`m`$. Every other transition has a missing diagonal incidence, including any virtual loop whose point is present in another color. Each missing incidence $`(a,x)`$ occurs in at most $`\deg_E(x)\le d`$ transitions in either position. Therefore

```math
\langle\mathbf 1_E,S_A\mathbf 1_E\rangle\le m+2dR.
\tag{2}
```

For $`R=0`$, equality holds. This proof uses only that $`\sigma_a`$ is a permutation and that the actual graph is simple, proper, and $`B`$-colored.

## 3. The general Fourier block and its Kloosterman fourth moment

For $`\chi_{\xi,\eta}(x,y)=e_p(\xi x+\eta y)`$,

```math
P_{\tau_a}\chi_{\xi,\eta}
=e_p\!\left(\beta(a)\left(\eta-\frac\xi a\right)\right)
\chi_{a\eta,\xi/a}.
```

The frequency product $`\xi\eta`$ is invariant. In a nonzero product block $`t`$, indexed by $`(r,t/r)`$, the matrix is

```math
M_t(r,s)
=\mathbf 1_A\!\left(\frac{rs}t\right)
e_p\!\left((r-s)\frac{\beta(rs/t)}{rs/t}\right).
\tag{3}
```

It is Hermitian. Write $`F(a)=\beta(a)/a`$. Expand $`\mathrm{tr}(M_t^4)`$ over $`r,s,u,v`$, and make the bijective change of variables

```math
a=\frac{rs}t,\qquad q=\frac ur,\qquad h=\frac vs,
\qquad
s=\frac{ta}r,\qquad u=qr,\qquad v=\frac{hta}r.
```

The four membership tests are $`a,qa,qha,ha\in A`$. The phase is $`\alpha r+\gamma/r`$, where

```math
\begin{aligned}
\alpha
&=\frac{h\beta(a)-h\beta(qa)+\beta(qha)-\beta(ha)}{ha},\\
\gamma
&=\frac tq\bigl[-q\beta(a)+\beta(qa)-\beta(qha)+q\beta(ha)\bigr].
\end{aligned}
\tag{4}
```

One direct check is that the coefficient of $`r`$ before substituting $`s=ta/r`$ is

```math
F(a)-qF(qa)+qF(qha)-F(ha),
```

and the coefficient of $`s`$ is

```math
-F(a)+F(qa)-hF(qha)+hF(ha).
```

If $`(\alpha,\gamma)\ne(0,0)`$, the sum over $`r\ne0`$ has absolute value at most $`2\sqrt p`$. This is Weil's Kloosterman estimate when both coefficients are nonzero; additive-character orthogonality gives $`-1`$ when exactly one is nonzero. If both vanish, the sum is $`p-1`$.

## 4. Collinearity controls all exceptional triples

The cases $`q=1`$ or $`h=1`$ are automatically exceptional and account for $`2d^2-d`$ supported triples. Suppose now that $`q\ne1`$ and $`h\ne1`$. The two coefficient rows in (4), acting on the value vector $`(\beta(a),\beta(qa),\beta(qha),\beta(ha))`$, are

```math
\begin{pmatrix}h&-h&1&-1\end{pmatrix},
\qquad
\begin{pmatrix}-q&1&-1&q\end{pmatrix}.
```

They are linearly independent. Indeed, comparison at coordinate $`3`$ in a putative dependence forces the multiplier to be $`-1`$, and coordinates $`2`$ and $`1`$ would then force $`h=q=1`$. Both rows annihilate the independent vectors

```math
(1,1,1,1),\qquad (a,qa,qha,ha).
```

These vectors are independent because $`q\ne1`$. Thus the common kernel consists exactly of vectors of affine-in-slope values. In particular, an exceptional triple makes all four graph points

```math
(a,\beta(a)),\quad (qa,\beta(qa)),\quad
(qha,\beta(qha)),\quad (ha,\beta(ha))
```

collinear. This proof includes coincident slopes, such as $`q=h=-1`$; it never presumes four distinct points.

Choose $`a`$ and $`b=qa`$ as an ordered distinct pair from $`A`$. Their affine line intersects the graph of $`\beta`$ in at most $`D`$ points, because $`\beta(T)`$ minus that line's equation is a nonzero polynomial of degree $`D`$. Thus $`c=ha`$ has at most $`D`$ choices, and the fourth slope $`bc/a`$ is then determined. Hence

```math
\#\{\text{exceptional triples}\}
\le 2d^2-d+Dd(d-1)
\le(D+2)d^2.
\tag{5}
```

The total number of supported triples is the multiplicative energy

```math
E_\times(A)=\#\{(a,b,c,e)\in A^4:ae=bc\}\le d^3.
```

Therefore

```math
\mathrm{tr}(M_t^4)
\le(D+2)pd^2+2\sqrt p\,E_\times(A).
\tag{6}
```

## 5. The axis block

The nonzero coordinate axes form an off-diagonal block whose norm is the norm, on mean-zero functions, of the one-point affine operator $`C_A=\sum_aP_{\sigma_a}`$. Its Fourier matrix, up to taking an adjoint, is

```math
N(r,s)=\mathbf 1_A(r/s)e_p\!\left(s\beta(r/s)\right).
```

For an affine quotient $`\sigma_a\sigma_b^{-1}`$, put $`\rho=a/b`$. Its slope and intercept are

```math
\rho,\qquad \beta(\rho b)-\rho\beta(b).
\tag{7}
```

If $`\rho^{D-1}\ne1`$, the second expression is a polynomial of degree $`D`$ in $`b`$ with nonzero leading coefficient. Every quotient with that slope has at most $`D`$ representations. The contribution to quotient energy from all such slopes is therefore at most $`Dd^2`$.

There are at most $`D-1`$ remaining ratios $`\rho`$. For each one, the total number of pairs $`(a,b)\in A^2`$ with $`a/b=\rho`$ is at most $`d`$, so the sum of squared quotient multiplicities for that ratio is at most $`d^2`$. Thus the affine quotient energy satisfies

```math
\begin{aligned}
E_{\mathrm{aff}}(A)
&:=\#\bigl\{(a,b,c,e)\in A^4:
\sigma_a\sigma_b^{-1}=\sigma_c\sigma_e^{-1}\bigr\}\\
&\le(2D-1)d^2.
\end{aligned}
\tag{8}
```

The character of the mean-zero permutation representation of $`\mathrm{Aff}(\mathbb F_p)`$ is $`p-1`$ at the identity, $`-1`$ at a nontrivial translation, and zero elsewhere. Expanding $`\mathrm{tr}((C_AC_A^*)^2)`$ and dropping the negative translation terms proves

```math
\|N\|^4\le(p-1)E_{\mathrm{aff}}(A).
\tag{9}
```

Taking inverses, if necessary, to use a genuine representation rather than a pullback antirepresentation changes neither these norms nor the energy count.

## 6. Finishing the bound

Let $`K_D=\max(D+2,2D-1)`$. All nonconstant Fourier blocks are bounded by

```math
\begin{aligned}
\lambda
&=\left[K_Dpd^2+2\sqrt p\,E_\times(A)\right]^{1/4}\\
&\le C_D\left[p^{1/4}d^{1/2}+p^{1/8}d^{3/4}\right].
\end{aligned}
\tag{10}
```

Centering $`\mathbf 1_E`$ in the $`p^2`$-point space and using (2) gives

```math
\frac{(d+\lambda)m^2}{p^2}
\le(1+\lambda)m+2dR.
\tag{11}
```

For $`d>0`$, this implies

```math
\begin{aligned}
m
&\le\frac{p^2(1+\lambda)}d+\sqrt2\,p\sqrt R\\
&\le\frac{p^2}d+C_Dp^{9/4}d^{-1/2}
+C_Dp^{17/8}d^{-1/4}+\sqrt2\,p\sqrt R.
\end{aligned}
\tag{12}
```

If $`d\le p^{9/10}`$, use $`m\le dp`$. Otherwise, the first three terms in (12) are $`O_D(p^{19/10})`$. The case $`d=0`$ is empty. This proves (1).

## 7. Exponential-sum input

Iwaniec and Kowalski, *Analytic Number Theory*, Theorem 11.11 and equation (11.15), printed page 280: [Chapter 11, “Sums over finite fields”](https://people.math.ethz.ch/~kowalski/ik-ant-exp-sums.pdf).

The proof uses the stated exponential-sum theorem. Historical priority is not claimed.
