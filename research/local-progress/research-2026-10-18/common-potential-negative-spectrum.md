# Negative spectrum of the common-potential operator

## Status

The deterministic estimate $\lambda_{\min}(T_{A,H})\ge-o(p)$ for arbitrary $A,H\subseteq\mathbb F_p^*$ remains unproved. No example with a negative eigenvalue of order $p$ was found in this investigation. The established statements here are an exact positive block decomposition and a random-thinning stability theorem. Neither resolves the deterministic question.

Let $p$ be an odd prime, $A,H\subseteq\mathbb F_p^*$, and

```math
\tau_a(x,y)=(y/a-a,ax+a^2),\qquad
u_a(x)=a^2x+a^3.
\tag{1}
```

On functions on $\mathbb F_p^2$ with counting-measure inner product, put

```math
(T_{A,H}f)(x,y)
=\sum_{a\in A}1_H(ay)1_H(u_a(x))f(\tau_a(x,y)).
\tag{2}
```

This is a self-adjoint operator. Both potential values are nonzero on any active transition, so its support is contained in $y\ne0$, and transitions remain in that set. No simplicity or properness hypothesis is needed for the operator statements below.

## 1. An enlarged positive diagonal

On $y\ne0$ use the bijective coordinates $(q,y)=(xy,y)$ and the unitary Fourier expansion

```math
f(q,y)=\frac1{\sqrt p}\sum_{s\in\mathbb F_p}e_p(sq)g_s(y).
\tag{3}
```

The block from input frequency $t$ to output frequency $s$ has matrix entries

```math
M_{s,t}(y,y')=
\frac1p\sum_{a\in A}1_H(ay)1_H(ay')
e_p\!\left(\frac{(t-s)yy'}a+a(sy-ty')\right).
\tag{4}
```

To verify (4), the transition of color $a$ with output column $y$ and input column $y'$ occurs at the unique coordinates

```math
q=\frac{y(y'-a^2)}a,\qquad
q'=\frac{y'(y-a^2)}a.
\tag{5}
```

Its Fourier phase is $tq'-sq$. The two masks become $1_H(ay)$ and $1_H(ay')$.

At equal frequencies,

```math
M_{s,s}=\frac1p\sum_{a\in A}|v_{a,s}\rangle\langle v_{a,s}|,
\qquad v_{a,s}(y)=1_H(ay)e_p(say).
\tag{6}
```

Thus the block-diagonal part $\bigoplus_sM_{s,s}$ is positive semidefinite. It includes the large positive character direction that defeated the earlier, smaller proposed positive main.

This positivity is not specific to a shared $H$: the same computation works for arbitrary actual column masks, replacing $1_H(ay)$ by the relevant mask and $a$ in the phase shift by $\beta(a)/a$. Therefore (6) alone does not distinguish the present problem from the previously observed bad examples with unrelated masks. The unresolved part is the aggregate of $s\ne t$ blocks.

For the shared mask, replacing $ay,ay'$ by $v,v'$ rewrites the phase in (4) as

```math
\frac{(t-s)vv'}{a^3}+sv-tv'.
\tag{7}
```

This exposes a cubic dependence on the color, but no uniform bound for the assembled blocks is established here.

There is a limited frequency-localization bound. For $s\ne t$, the matrix with entries $e_p((t-s)yy'/a)$ is a restriction of a Fourier matrix of norm $\sqrt p$. The two other phase factors and the two masks are diagonal contractions. Therefore

```math
\|M_{s,t}\|\le\frac{|A|}{\sqrt p}.
\tag{7a}
```

For a test vector whose expansion (3) uses at most $r$ frequencies, Cauchy–Schwarz and (6) give

```math
\langle f,T_{A,H}f\rangle
\ge-\frac{(r-1)|A|}{\sqrt p}\|f\|_2^2.
\tag{7b}
```

Thus a negative eigenvalue of order $p$ cannot be witnessed by a vector supported on $o(\sqrt p)$ of these Fourier blocks. This estimate also applies to unrelated column masks, so it is a test-vector restriction rather than a shared-mask theorem.

## 2. Exact nonnegative diagonal tests

For any multiplicative character $\chi$ and additive frequency $s$, define

```math
f_{\chi,s}(x,y)=\chi(y)e_p(sxy),
\qquad \chi(0)=0.
\tag{8}
```

These functions form an orthogonal basis of the functions supported on $y\ne0$. Directly parametrizing a color patch by $h,k\in H$ gives

```math
\langle f_{\chi,s},T_{A,H}f_{\chi,s}\rangle
=|A|\left|\sum_{h\in H}\chi(h)e_p(-sh)\right|^2\ge0.
\tag{9}
```

Indeed, the two swapped states are

```math
\left(h/a^2-a,k/a\right),\qquad
\left(k/a^2-a,h/a\right),
\tag{10}
```

and the product of the conjugated first value and second value is
$\chi(h)\overline{\chi(k)}e_p(s(k-h))$. Positivity of every diagonal basis entry does not imply that the whole operator is positive semidefinite; cross-frequency terms are the remaining issue.

## 3. One potential value changes the operator by at most four

If $H,H'\subseteq\mathbb F_p^*$ differ at exactly one value $t$, then

```math
\|T_{A,H}-T_{A,H'}\|\le4.
\tag{11}
```

At a fixed state $(x,y)$ with $y\ne0$, a color contribution can change only if

```math
ay=t\qquad\text{or}\qquad a^3+xa^2=t.
\tag{12}
```

The first equation has at most one solution in $a$, and the second at most three. Each changed color contributes absolute row sum at most one. The difference matrix is symmetric, so its operator norm is at most its maximum absolute row sum, which is at most four. At $y=0$, all contributions vanish because neither mask contains zero.

By toggling values one at a time,

```math
\|T_{A,H}-T_{A,H'}\|\le4|H\triangle H'|.
\tag{13}
```

In particular, arbitrary changes to $o(p)$ potential values preserve a lower spectral bound of the form $-o(p)$.

## 4. Random thinning preserves a lower spectral bound

Fix $A,J\subseteq\mathbb F_p^*$ and $0\le\eta\le1$. Include each element of $J$ in $H$ independently with probability $\eta$. Let $L_{A,J}$ be the diagonal matrix

```math
L_{A,J}(x,y;x,y)
=\#\{a\in A:y=ax+a^2,\ ay\in J\}.
\tag{14}
```

Then

```math
\mathbb E T_{A,H}
=\eta^2 T_{A,J}+\eta(1-\eta)L_{A,J}.
\tag{15}
```

For distinct potential values, the expected product of indicators is $\eta^2$. Equality of the two potential values means $ay=u_a(x)$, hence $y=ax+a^2$, exactly the fixed-point condition for $\tau_a$. Those terms are diagonal and have expected indicator $\eta$. This proves (15), and $L_{A,J}$ is positive semidefinite even if the eligible colored graph is not simple.

For every $t\ge0$ and nonempty $J$,

```math
\Pr\!\left(\|T_{A,H}-\mathbb E T_{A,H}\|\ge t\right)
\le2p^2\exp\!\left(-\frac{t^2}{128|J|}\right).
\tag{16}
```

This follows from (11) and the matrix bounded-differences inequality: each coordinate difference has square bounded above by $16I$, so the variance proxy is $16|J|$. Apply the upper-tail bound to both signs. The primary source is Joel Tropp, [*User-Friendly Tail Bounds for Sums of Random Matrices*](https://tropp.caltech.edu/papers/Tro11-User-Friendly-preprint.pdf), Corollary 7.5, printed p.28; the stated exponent is $-t^2/(8\sigma^2)$.

Consequently, if $\lambda_{\min}(T_{A,J})\ge-\lambda$, then outside the exceptional event in (16),

```math
\lambda_{\min}(T_{A,H})\ge-\eta^2\lambda-t.
\tag{17}
```

For example, taking $t=\sqrt{128|J|(K+3)\log p}$ gives failure probability at most $2p^{-K-1}$. Thus every fixed near-positive-semidefinite base mask remains so under independent thinning, up to $O(\sqrt{p\log p})$.

## 5. A proper example beyond small Fourier envelopes

Let $\chi$ be the quadratic character, take $A$ to be the nonzero squares, and put

```math
J=\{t\in\mathbb F_p^*: \chi(t)=-\chi(-1)\}.
\tag{18}
```

The complete eligible graph for $A,J$ is simple and proper, and deleting potential values preserves these properties. The collision between two distinct colors $a,b\in A$ would require the selected potential values $-a^2b,-ab^2$, both of character $\chi(-1)$, so it is excluded.

Because multiplication by $a\in A$ preserves $J$, the base operator is

```math
T_{A,J}=M_{1_J(y)}S_A M_{1_J(y)},\qquad
S_A=\sum_{a\in A}U_{\tau_a}.
\tag{19}
```

The previously established completed estimate $S_A=|A|P+O_{\mathrm{op}}(p^{7/8})$ therefore gives $\lambda_{\min}(T_{A,J})\ge-Cp^{7/8}$. For an independent Bernoulli subset $H$ of $J$, (17) yields

```math
\lambda_{\min}(T_{A,H})\ge-Cp^{7/8}
\tag{20}
```

with probability tending to one faster than any fixed inverse power, after adjusting the constant. This estimate does not require any Fourier norm assumption on the sampled $H$.

For fixed $0<\eta<1$, the sampled eligible graph has $\Theta(p^2)$ edges with high probability. The triangle-removal spectral criterion from [common-potential-analysis.md](common-potential-analysis.md), Section 5, then shows that it cannot have every four-cycle rainbow. This is a random-family statement, not an upper bound for adversarial masks.

The probability estimate also permits a union bound over a predetermined family of palettes and base masks whose logarithmic cardinality is $o(p)$, provided their base lower spectral bounds are uniformly $-o(p)$. It does not permit a uniform conclusion over all $2^{p-1}$ palettes: that union bound would require a deviation of order $p$.

## 6. Remaining deterministic gap

Neither the positive Fourier diagonal nor random-thinning stability proves a lower bound for arbitrary dense $H$. The first leaves uncontrolled off-diagonal blocks, while the second controls most masks drawn from a specified distribution and allows exponentially rare exceptions. No negative counterexample or deterministic closure argument is asserted.
