# Common-potential masks: multiplicative Fourier control and an aggregate-norm obstruction

## Scope

The unrestricted common-potential problem remains open in this note. The established result below treats masks with a controlled multiplicative Fourier envelope. The final section rules out a uniform small **absolute** norm for one previously proposed remainder; it does not rule out a useful lower bound for that remainder on actual edge sets.

Throughout, $p$ is an odd prime. A proper $B$-coloring means a simple properly edge-colored bipartite graph in which every $C_4$ is rainbow. Hilbert-space norms use counting measure.

## 1. The actual supports have a multiplicative column description

For the quadratic palette, write

```math
\sigma_a(x)=ax+a^2,
\qquad
u_a(x)=a^2x+a^3=a\sigma_a(x),
\qquad a\in A\subseteq\mathbb F_p^\times.
```

If $D_a=\{x:u_a(x)\in H\}$, the actual edge of color $a$ at column $y$ is present exactly when $ay\in H$. Equivalently, the selected edges are parametrized by

```math
(a,h)\longmapsto
\left(\frac{h}{a^2}-a,\frac ha\right),
\qquad (a,h)\in A\times H.
\tag{1}
```

Simplicity ensures that these are $|A||H|$ distinct edges. The domain formula alone does not ensure simplicity or condition $B$.

For the crossed involution

```math
\tau_a(x,y)=\left(\frac ya-a,ax+a^2\right),
```

put $f_a(x,y)=\mathbf 1_H(ay)$. The masked crossed operator has the exact alternate expression

```math
T=\sum_{a\in A}M_{f_a}U_{\tau_a}M_{f_a}.
\tag{2}
```

Indeed, the two multipliers at $(x,y)$ and $\tau_a(x,y)$ are $\mathbf 1_H(ay)$ and $\mathbf 1_H(a\sigma_a(x))$. Thus (2) is the same actual-support operator obtained from the row domains $D_a$.

## 2. A multiplicative Fourier-envelope theorem

The following statement also allows color-dependent masks and a fixed-degree polynomial palette.

Let $\beta\in\mathbb F_p[T]$ have degree $D$ with $2\le D<p$. For $a\in A\subseteq\mathbb F_p^\times$, put

```math
\sigma_a(x)=ax+\beta(a),
\qquad
v_a=\frac{\beta(a)}a,
\qquad
u_a(x)=v_a\sigma_a(x).
```

Choose sets $H_a\subseteq\mathbb F_p$ and retain exactly the color-$a$ edges whose rows satisfy $u_a(x)\in H_a$. Assume the resulting graph is a proper $B$-coloring.

Delete the at most $D$ colors with $\beta(a)=0$ and delete the edges at column $y=0$. This costs at most $(D+1)p$ edges. Let $A_0$ be the remaining palette, $d=|A_0|$, and replace every remaining $H_a$ by $H_a\setminus\{0\}$. These deletions preserve condition $B$. For a multiplicative character $\chi$ of $\mathbb F_p^\times$, define

```math
c_a(\chi)=\frac1{p-1}
\sum_{t\in\mathbb F_p^\times}\mathbf 1_{H_a}(t)\overline{\chi(t)},
\qquad
B_\times=\sum_\chi\sup_{a\in A_0}|c_a(\chi)|.
\tag{3}
```

For an empty remaining palette set $B_\times=0$. There is a constant depending only on $D$ such that the original edge count satisfies

```math
m_{\mathrm{original}}
\le (D+1)p+C_Dp^{47/24}B_\times^{2/3}.
\tag{4}
```

In particular, $B_\times=o(p^{1/16})$ implies $m_{\mathrm{original}}=o(p^2)$ for bounded $D$. For a common set $H$, $B_\times$ is simply its multiplicative Fourier $\ell^1$ norm, after removing $0$.

### Proof

All remaining $v_a$ are nonzero. Extend every multiplicative character by $\chi(0)=0$, including the trivial character. Multiplicative Fourier inversion gives the exact identity on all columns, including $0$,

```math
f_a(x,y)=\mathbf 1_{H_a}(v_ay)
=\sum_\chi c_a(\chi)\chi(v_a)\chi(y).
\tag{5}
```

The completed crossed operators satisfy the previously established weighted estimate

```math
\left\|
\sum_{a\in A_0}w(a)U_{\tau_a}
-\left(\sum_{a\in A_0}w(a)\right)P
\right\|
\le C_Dp^{7/8}\|w\|_\infty,
\tag{6}
```

where $P$ is projection onto constants on $\mathbb F_p^2$. This estimate permits arbitrary complex weights. It follows from the polynomial palette's Kloosterman fourth-moment estimate and affine quotient-energy bound; the complex-weight axis estimate must retain the additional absolute translation contribution. Its proof is recorded in [the weighted Fourier-majorant theorem](../overnight-2026-10-15/pass5-fourier-majorant-support-theorem.txt). This is the only completed-operator input used here; the newer potential-modulated operator bound is unnecessary for this criterion.

Insert (5) into (2). For each pair of characters, the color-only weight is

```math
w_{\chi,\psi}(a)
=c_a(\chi)c_a(\psi)\chi(v_a)\psi(v_a).
```

The multipliers by $\chi(y)$ and $\psi(y)$ have norm at most one. Applying (6) term by term and then summing gives

```math
\|T-T_0\|\le C_Dp^{7/8}B_\times^2,
\qquad
T_0=\sum_{a\in A_0}M_{f_a}PM_{f_a}
=\frac1{p^2}\sum_{a\in A_0}|f_a\rangle\langle f_a|.
\tag{7}
```

The last equality uses that $f_a$ is real. In particular, $T_0$ is positive semidefinite. The extension $\chi(0)=0$ causes no error: (5) is exact and all selected edges at column $0$ were removed.

Let $E$ be the remaining edge set, $m=|E|$, and $F=\mathbf 1_E$. Condition $B$ gives

```math
\langle F,TF\rangle=m.
\tag{8}
```

To check (8), an internal non-loop transition of color $a$ has both closing color-$a$ incidences present, by the two actual-support multipliers. It would therefore give a genuine four-cycle with opposite edges of color $a$. The fixed transitions are exactly the $m$ actual edges, each counted once by simplicity.

Write $\deg_E(y)$ for the actual column degree and

```math
b_a=\langle F,f_a\rangle
=\sum_y f_a(y)\deg_E(y).
```

Because the selected graph is simple and every eligible color incidence is present, $\sum_a f_a(y)=\deg_E(y)$. Consequently,

```math
\sum_a b_a=\sum_y\deg_E(y)^2\ge\frac{m^2}{p},
\qquad
\langle F,T_0F\rangle
=\frac1{p^2}\sum_a b_a^2
\ge\frac{m^4}{dp^4}.
\tag{9}
```

For $m>0$, equations (7)–(9), together with $\|F\|_2^2=m$, imply

```math
m^3\le dp^4\left(1+C_Dp^{7/8}B_\times^2\right).
\tag{10}
```

Fourier inversion at a point in a nonempty $H_a$ gives $B_\times\ge1$, and $d\le p$. Therefore (10) yields $m\le C_Dp^{47/24}B_\times^{2/3}$. Restoring the deleted edges proves (4). If $m=0$, the deletion bound already proves the claim.

## 3. Concrete mask families

Let $n=p-1$ and fix a generator $g$ of $\mathbb F_p^\times$.

* **Multiplicative intervals.** If $H_a=\{g^t:t\in I_a\}$, where $I_a$ is an arbitrary cyclic interval in $\mathbb Z_n$, then $B_\times\le C\log(2p)$, uniformly in all interval endpoints and lengths. Thus (4) gives $O_D(p^{47/24}(\log(2p))^{2/3})$ edges.
* **Shared multiplicative Bohr boxes.** Fix frequencies $k_1,\ldots,k_r\in\mathbb Z_n$, shared by all colors, and let

```math
H_a=\{g^t:k_jt\in I_{a,j}\text{ for }1\le j\le r\},
```

  with arbitrary cyclic intervals $I_{a,j}$. Then $B_\times\le(C\log(2p))^r$. The conclusion is subquadratic for fixed $r$, and also when

```math
\limsup_{p\to\infty}\frac{r\log\log p}{\log p}<\frac1{16}.
```

* **Sparse multiplicative spectrum.** For a common $H\subseteq\mathbb F_p^\times$ with at most $K$ nonzero Fourier coefficients, Parseval and Cauchy–Schwarz give $B_\times\le\sqrt K$. Thus $K=o(p^{1/8})$ suffices. In particular, a union of cosets of a subgroup of index $K$ satisfies this criterion.

For the first two statements, the normalized Fourier coefficients of an interval in $\mathbb Z_n$ have a uniform summable majorant of total $O(\log(2n))$. Pullback by $t\mapsto kt$ cannot increase its total Fourier $\ell^1$ norm: coefficients with the same pulled-back frequency are grouped and the triangle inequality applies. Products of interval masks are handled by convolution of these nonnegative majorants. This also justifies the supremum over colors in (3), rather than merely a separate Fourier bound for each color.

These are sufficient conditions, not a bound for arbitrary $H$. For common quadratic-potential masks with both $|A|$ and $|H|$ bounded below by positive multiples of $p$, (10) forces $B_\times\gg p^{1/16}$ if the graph is $B$-colored. The previously established additive-potential criterion separately forces a large additive Fourier $\ell^1$ norm. Neither requirement excludes arbitrary dense sets.

## 4. A large positive remainder prevents an absolute-norm approach

Let $\chi$ be the quadratic character, extended by $\chi(0)=0$. Put

```math
A=\{a\in\mathbb F_p^\times:\chi(a)=1\},
\qquad
\varepsilon=-\chi(-1),
\qquad
H=\{y\in\mathbb F_p^\times:\chi(y)=\varepsilon\}.
\tag{11}
```

This common-potential graph is proper and simple. Indeed, two distinct completed color lines $a,b\in A$ intersect at $x=-a-b$, $y=-ab$. Their potential values are $-a^2b$ and $-ab^2$, both of quadratic character $\chi(-1)$, so neither is selected. Every individual color is a matching.

Since $a\in A$ is a square, $\mathbf 1_H(ay)=\mathbf 1_H(y)$. With $h(y)=\mathbf 1_H(y)$,

```math
T=M_hS_AM_h.
```

Let $f(x,y)=\chi(y)$. Then $\|f\|_2^2=p(p-1)$ and $M_hf=\varepsilon h$. The completed mean-zero estimate $\|S_A-dP\|\le\lambda$, with $d=(p-1)/2$ and $\lambda=O(p^{7/8})$, gives

```math
\frac{\langle f,Tf\rangle}{\|f\|_2^2}
\ge\frac{d|H|^2}{p(p-1)}-\lambda\frac{|H|}{p-1}
=\Omega(p).
\tag{12}
```

Now consider the additive-potential diagonal slice from the earlier decomposition. With $Q(x,y)=xy$, $C_\ell=M_{e_p(\ell Q)}$, and normalized additive Fourier coefficients $\widehat h(\ell)$, its positive main is

```math
B_0=\frac d{p^2}\sum_\ell|\widehat h(\ell)|^2
|e_p(-\ell Q)\rangle\langle e_p(-\ell Q)|.
```

Every vector $e_p(-\ell Q)$ is orthogonal to $f$. For $\ell=0$, this is $\sum_y\chi(y)=0$; for $\ell\ne0$, summing first over $x$ leaves only $y=0$, where $\chi(0)=0$. Thus $B_0f=0$ exactly. The valid slice-specific estimate is

```math
\|T_{\mathrm{diag}}-B_0\|\le\lambda\frac{|H|}{p}.
```

Combining this with (12) proves

```math
\|T-T_{\mathrm{diag}}\|\ge c p
```

for all sufficiently large $p$ and an absolute $c>0$. The witness is a large **positive** Rayleigh quotient.

The graph in (11) is not asserted to satisfy condition $B$; the theorem above in fact prevents it from doing so for sufficiently large $p$. The conclusion is therefore limited and precise: the aggregate remainder cannot have uniformly small absolute operator norm even under the common-potential formula and propriety. This leaves open a uniform lower-bound estimate, or a lower bound that uses condition $B$ and the specific test vector $\mathbf 1_E$.

## 5. A lower spectral bound would suffice

There is a precise reason to investigate only the negative spectrum. It applies to the intrinsic masked operator of any proper colored bipartite graph, not just the polynomial palette.

Let both vertex classes have size $p$ and let there be at most $p$ colors. Each color is a partial matching. For a color $a$, let $X_a$ and $Y_a$ be its incident row and column sets, and let $\sigma_a:X_a\to Y_a$ be its matching bijection. On $X\times Y$ define the partial involution operator

```math
(T_af)(x,y)=
\begin{cases}
f(\sigma_a^{-1}(y),\sigma_a(x)),&x\in X_a,\ y\in Y_a,\\
0,&\text{otherwise},
\end{cases}
\qquad T=\sum_aT_a.
\tag{13}
```

Each $T_a$ is self-adjoint with norm at most one. If the graph satisfies condition $B$ and $F=\mathbf 1_E$, then the same rectangle argument as before gives $\langle F,TF\rangle=m$.

For each row or column vertex $v$, let $A_v$ be its set of incident colors. Directly from (13),

```math
(T\mathbf 1)(x,y)=|A_x\cap A_y|.
```

Consequently,

```math
\mathcal C:=\langle F,T\mathbf 1\rangle
=\sum_{(x,y)\in E}|A_x\cap A_y|
\tag{14}
```

counts triangles in the tripartite graph on rows, columns, and colors, whose three edge types are actual row–column edges and the two color-incidence relations. Every actual colored edge supplies one of $m$ pairwise edge-disjoint triangles. Edge-disjointness follows respectively from simplicity and propriety at the two endpoints.

The triangle removal lemma therefore implies: for every $\delta>0$, there is $c_\delta>0$ such that

```math
m\ge\delta p^2
\quad\Longrightarrow\quad
\mathcal C\ge c_\delta p^3
\tag{15}
```

for all sufficiently large $p$. To make the normalization explicit, the tripartite graph has at most $3p$ vertices and needs at least $m$ edge deletions to destroy all triangles. Apply the removal lemma with deletion allowance $\delta/18$ times the square of its vertex count. This allowance is at most $\delta p^2/2<m$, so the lemma forces a positive cubic triangle count. A primary source for the removal theorem is [Fox, *A new proof of the graph removal lemma*](https://arxiv.org/abs/1006.1300).

Now put $\theta=\max(0,-\lambda_{\min}(T))$. Since $\|T\|\le p$, one has $0\le\theta\le p$, and $M=T+\theta I$ is positive semidefinite. Its Cauchy–Schwarz inequality gives

```math
\begin{aligned}
\mathcal C^2
&\le |\langle F,M\mathbf 1\rangle|^2\\
&\le \langle F,MF\rangle\langle\mathbf 1,M\mathbf 1\rangle\\
&\le m(1+\theta)(p+\theta)p^2\\
&\le 2p^5(1+\theta).
\end{aligned}
\tag{16}
```

The first inequality uses $\langle F,M\mathbf 1\rangle=\mathcal C+\theta m\ge\mathcal C$. The third uses condition $B$, the bound $T\mathbf 1\le p\mathbf 1$, and $\|\mathbf 1\|_2^2=p^2$; the last uses $m\le p^2$ and $\theta\le p$.

Combining (15) and (16), every such dense $B$-colored graph must satisfy

```math
-\lambda_{\min}(T)
\ge\frac{c_\delta^2}{2}p-1.
\tag{17}
```

In particular, proving $\lambda_{\min}(T)\ge-o(p)$ for the common-potential class would prove $m=o(p^2)$ for that class. No comparison with a chosen positive main operator would be needed. The lower spectral estimate itself remains unproved. Equation (17) is a conditional spectral reformulation using triangle removal, not an unconditional upper bound for the common-potential class.

## 6. Remaining target

For arbitrary dense $A,H$, a useful unresolved statement would be a lower bound for the masked operator on the actual edge indicator, after accounting for all positive structured components. The individual estimate $\|R_{s,w}\|=O(p^{7/8})$ for $s\ne0$ does not supply such a bound by itself: absolute summation of the two Fourier coefficients costs their $\ell^1$ norms. The example in Section 4 also shows why controlling the entire aggregate remainder in absolute norm is stronger than necessary and false without further hypotheses.

No conclusion for unrestricted Erdős problem #810 follows from the results in this note.
