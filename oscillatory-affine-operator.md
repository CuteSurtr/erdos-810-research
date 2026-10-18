# Oscillatory affine operators over prime fields

## 1. Statement

Let $`p`$ be an odd prime, $`s\in\mathbb F_p^\times`$, and $`w:\mathbb F_p^\times\to\mathbb C`$ satisfy $`|w(a)|\leq1`$. On functions on $`\mathbb F_p`$, define

```math
C_{s,w}f(x)
=\sum_{a\neq0}w(a)e_p\!\left(s(a^2x+a^3)\right)f(ax+a^2).
```

Then, for an absolute constant $`C`$,

```math
\|C_{s,w}\|_{2\to2}\leq Cp^{7/8}.
\tag{1}
```

The norm is unchanged by choosing counting or normalized counting measure. No $`L^\infty`$ bound on the input or test function is needed. The estimate is uniform in the weights, their support, and $`s\neq0`$.

The exact partial Fourier and Mellin decomposition in Section 5 then proves the same estimate for arbitrary complex weights $`|v(a)|\leq1`$ in

```math
\begin{aligned}
R_{s,v}
&=\sum_{a\neq0}v(a)M_{e_p(s(a^2x+a^3))}U_{\tau_a},\\
\tau_a(x,y)&=\left(\frac ya-a,\;ax+a^2\right).
\end{aligned}
```

This estimate controls individual nonzero Fourier slices. It does not by itself control their full sum for arbitrary support sets.

## 2. Two Cauchy–Schwarz steps and the exact pair phase

Write $`\mathbb E_x=p^{-1}\sum_x`$, and take $`\mathbb E|f|^2=\mathbb E|g|^2=1`$. Extend $`w`$ by $`w(0)=0`$. Set

```math
\begin{aligned}
T
&=\mathbb E_x\overline{g(x)}\,
  \mathbb E_a w(a)e_p\!\left(s(a^2x+a^3)\right)f(ax+a^2)\\
&=p^{-1}\mathbb E_x\overline{g(x)}\,C_{s,w}f(x).
\end{aligned}
```

Cauchy–Schwarz in $`x`$, then the triangle inequality and Cauchy–Schwarz over the $`p^2`$ ordered pairs $`(a,b)`$, give

```math
|T|^4\leq p^{-2}\sum_{a,b\neq0}|I_{ab}|^2,
\tag{2}
```

where

```math
\begin{aligned}
I_{ab}
&=\mathbb E_x e_p\!\left(s(u_a(x)-u_b(x))\right)
  f(ax+a^2)\overline{f(bx+b^2)},\\
u_a(x)&=a^2x+a^3.
\end{aligned}
```

Put $`b=ta`$ and $`y=ax+a^2`$. Then

```math
\begin{aligned}
bx+b^2&=ty+a^2t(t-1),\\
u_a(x)-u_b(x)&=a(1-t^2)y-a^3t^2(t-1).
\end{aligned}
```

The last term is constant in $`y`$ and disappears under the absolute value in (2). Thus, writing $`c=t(t-1)`$ and $`d=s(1-t^2)`$,

```math
|I_{ab}|
=\left|\mathbb E_y f(y)\overline{f(ty+ca^2)}e_p(day)\right|.
\tag{3}
```

For $`t=1`$ or $`t=-1`$, the absolute value in (3) is at most $`1`$, by Cauchy–Schwarz and the fact that $`y\mapsto ty+ca^2`$ is a permutation. Their total contribution to (2) is at most $`2/p`$.

## 3. Fixed $`t`$ different from $`0,1,-1`$

Fix such a $`t`$, so both $`c`$ and $`d`$ are nonzero. The nonnegative sum over $`a\neq0`$ may be enlarged to the sum over all $`a`$. Put

```math
S_t
=\sum_a\left|\mathbb E_y f(y)\overline{f(ty+ca^2)}e_p(day)\right|^2.
```

Expanding and writing $`r=y-y'`$ gives

```math
S_t=p^{-2}\sum_r\sum_y G_r(y)(L_rH_r)(y),
```

where

```math
\begin{aligned}
G_r(y)&=f(y)\overline{f(y-r)},\\
H_r(z)&=\overline{f(z)}f(z-tr),\\
L_rH(y)&=\sum_a e_p(dar)H(ty+ca^2).
\end{aligned}
```

All norms in the rest of this section use counting measure.

For $`r\neq0`$, $`L_r`$ sends the normalized Fourier character of frequency $`\xi`$ to that of frequency $`t\xi`$, multiplied by

```math
\sum_a e_p(c\xi a^2+dra).
```

At $`\xi=0`$ this is zero. At $`\xi\neq0`$ it has absolute value $`\sqrt p`$. For completeness, if $`\alpha\neq0`$, expansion of

```math
\left|\sum_a e_p(\alpha a^2+\beta a)\right|^2
```

and the substitution $`a=b+h`$ give

```math
\sum_h e_p(\alpha h^2+\beta h)\sum_b e_p(2\alpha hb)=p,
```

because $`p`$ is odd and only $`h=0`$ survives. Hence $`\|L_r\|=\sqrt p`$.

Furthermore,

```math
\begin{aligned}
\sum_r\|G_r\|_2^2
&=\left(\sum_y|f(y)|^2\right)^2=p^2,\\
\sum_r\|H_r\|_2^2
&=\left(\sum_z|f(z)|^2\right)^2=p^2,
\end{aligned}
```

where the second equality uses $`t\neq0`$. Cauchy–Schwarz first in $`y`$ and then in $`r`$ bounds the absolute contribution from $`r\neq0`$ by

```math
p^{-2}\sqrt p\sum_{r\neq0}\|G_r\|_2\|H_r\|_2\leq\sqrt p.
```

For $`r=0`$, its nonnegative contribution is

```math
p^{-2}\sum_y|f(y)|^2\sum_a|f(ty+ca^2)|^2\leq2.
```

Indeed, for each fixed $`y`$, the map $`a\mapsto ty+ca^2`$ has at most two preimages per value, and $`\sum_z|f(z)|^2=p`$. Therefore

```math
S_t\leq2+\sqrt p.
\tag{4}
```

## 4. Summation and norm conclusion

There are $`p-3`$ values of $`t`$ other than $`0,1,-1`$. Equations (2)–(4) give

```math
|T|^4
\leq\frac2p+\frac{(p-3)(2+\sqrt p)}{p^2}
=O(p^{-1/2}).
\tag{5}
```

Since $`T=p^{-1}\langle g,C_{s,w}f\rangle`$ with normalized inner product, taking the supremum over unit $`f,g`$ gives (1). Every use of $`f`$ involved only its $`L^2`$ norm or the exact correlation identities above. The proof does not assume flatness, bounded entries, or an $`L^\infty`$ norm.

## 5. Exact decomposition of the crossed operator

For $`a,b\neq0`$, put

```math
r=\frac ab,\qquad
q=\frac{a^2-b^2}{b},\qquad
t=b(b-a),\qquad
c_0=sa^2(a-b).
```

The exact pair-product identity is

```math
R_aR_b^*f(x,y)
=e_p(-srtx+c_0)\,
f(rx+q,r^{-1}y+t).
```

Expand $`f(x,y)=\sum_\eta f_\eta(x)e_p(\eta y)`$. The output frequency $`\eta`$ uses input frequency $`r\eta`$, and the coefficient is

```math
e_p(-srtx+r\eta t+c_0)\,f_{r\eta}(rx+q).
```

The unitary, $`\eta`$-dependent shift $`g_\eta(z)=f_\eta(z+\eta/s)`$ changes this to

```math
e_p(-srtz+c_0)\,g_{r\eta}(rz+q).
```

On $`\eta=0`$ this is the trivial-character block. On $`\eta\neq0`$, decompose by the full orthonormal multiplicative-character basis. For a block $`g_\eta(z)=\chi(\eta)g(z)`$, the additional factor is

```math
\chi(r)=\chi(a)\overline{\chi(b)}.
```

For arbitrary complex weights $`v(a)`$, the pair product also contains $`v(a)\overline{v(b)}`$. The block of $`R_{s,v}R_{s,v}^*`$ is therefore

```math
C_{s,\chi v}C_{s,\chi v}^*.
```

The trivial character also occurs in the $`\eta=0`$ block. These blocks exhaust the whole space, so

```math
\|R_{s,v}\|=\max_\chi\|C_{s,\chi v}\|.
```

Applying (1) gives $`\|R_{s,v}\|=O(p^{7/8})`$, uniformly in $`|v|\leq1`$ and $`s\neq0`$. Taking $`v=1_A`$ gives the operator for a selected palette $`A`$.

## 6. Scope and limitations

For the common-potential masks $`1_H(a^2x+a^3)`$, the full operator has coefficients $`\widehat h(s-\ell)\widehat h(\ell)`$ multiplying chirp conjugates of $`R_s`$. A uniform estimate for each $`R_s`$ does not justify dropping or freely summing these coefficients. Their absolute total can grow with $`p`$. A separate argument is still needed for arbitrary $`H`$; the estimate above does not imply sparsity for that full class.
