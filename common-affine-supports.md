# Arbitrary affine intercepts with common or nearly common support

**Status.** This is a subquadratic theorem for a support subclass. Section 8 also gives an explicit common-support rate from integer Roth bounds. No polynomial hypothesis is imposed on the intercept function. This does not solve arbitrary-support affine colorings or unrestricted Erdős #810. Historical priority is unverified. No Lean certification is asserted.

## 1. Statement

For each odd prime $`p`$, let $`A\subseteq\mathbb F_p^\times`$ and let $`\beta:A\to\mathbb F_p`$ be arbitrary. For $`a\in A`$, select exactly the color-$`a`$ edges

```math
x\longmapsto ax+\beta(a),\qquad x\in D_a,
```

where $`D_a\subseteq X\subseteq\mathbb F_p`$. Suppose the resulting colored graph is simple and proper, and every $`C_4`$ is rainbow (property B). Write

```math
d=|A|,\qquad
m=\sum_{a\in A}|D_a|,\qquad
R=\sum_{a\in A}\bigl(|X|-|D_a|\bigr).
```

**Theorem.** Uniformly over all these choices, $`R=o(p^2)`$ implies $`m=o(p^2)`$. In particular, common row support $`D_a=X`$ always implies $`m=o(p^2)`$. There is one original color per slope, so the representing affine maps are distinct and $`d\le p-1`$. No degree restriction or structured formula for $`\beta`$ is used.

For **exact common support**, the additional argument in Section 8 proves

```math
\begin{aligned}
\frac{m}{p^2}
&\ll p^{-1/11}+\left(\frac{r_3([p-1])}{p}\right)^{1/6}\\
&\ll \exp\!\left(-c(\log p)^{1/12}\right).
\end{aligned}
\tag{Q}
```

Here $`r_3([n])`$ denotes the maximum size of an integer subset of $`\{0,\ldots,n-1\}`$ containing no nontrivial three-term arithmetic progression. The last inequality uses a published Kelley–Meka-type Roth bound.

The proof below uses three established inputs: Weil's Kloosterman bound, the affine-energy bound of Petridis–Roche-Newton–Rudnev–Warren, and Solymosi's finite-group-table theorem.

## 2. A master spectral inequality for any intercept function

Let $`P=\{(a,\beta(a)):a\in A\}`$ in the coefficient plane, and let $`L`$ be the largest number of its points on an affine line (take $`L=0`$ if $`A`$ is empty). Let $`E_{\mathrm{aff}}`$ be the quotient energy of $`S=\{\sigma_a:a\in A\}`$:

```math
E_{\mathrm{aff}}
=\#\bigl\{(g,h,u,v)\in S^4:gh^{-1}=uv^{-1}\bigr\}.
```

Let $`E_\times(A)`$ be the multiplicative energy of the slope set, at most $`d^3`$. Define crossed involutions on $`\mathbb F_p^2`$ by

```math
\tau_a(x,y)=\left(\frac{y-\beta(a)}{a},\,ax+\beta(a)\right),
\qquad
S_Af=\sum_{a\in A}f\circ\tau_a.
```

On mean-zero functions,

```math
\begin{aligned}
\|S_A\|&\le\lambda,\\
\lambda^4&\le
\max\left\{(p-1)E_{\mathrm{aff}},\;
p(L+2)d^2+2\sqrt p\,E_\times(A)\right\}.
\end{aligned}
\tag{1}
```

Here $`\lambda`$ may be chosen as the fourth root of the right-hand side. It need not be less than $`d`$ in sparse ranges.

**Proof of (1).** The Fourier product blocks and phase coefficients are exactly those in [Polynomial affine supports](polynomial-affine-supports.md), Sections 3–4. The proof there did not use polynomiality until bounding line intersections. For $`q,h\ne1`$, the two coefficient equations vanish exactly when the values at slopes $`a,qa,qha,ha`$ are affine in slope; the rank-two argument includes repeated slopes. Choose ordered $`a,b=qa`$ with $`a\ne b`$, then choose $`c=ha`$ on their coefficient-plane line. There are at most $`L`$ choices for $`c`$, and the fourth slope $`bc/a`$ is determined. The $`q=1`$ or $`h=1`$ cases contribute $`2d^2-d`$. Thus at most $`(L+2)d^2`$ exceptional triples occur. All other $`r`$-sums are bounded by $`2\sqrt p`$, proving the second term in (1). The axis-block character argument gives the first term $`(p-1)E_{\mathrm{aff}}`$ without any special formula for $`\beta`$. $`\square`$

For the actual edge set $`E`$, the missing-incidence charging argument also uses no polynomial hypothesis:

```math
\langle\mathbf 1_E,S_A\mathbf 1_E\rangle\le m+2dR.
```

In particular, it charges virtual fixed-point loops correctly. Centering $`\mathbf 1_E`$ gives the exact useful inequality

```math
\frac{(d+\lambda)m^2}{p^2}\le(1+\lambda)m+2dR.
\tag{2}
```

For $`d>0`$, this implies

```math
m\le\frac{p^2(1+\lambda)}{d}+\sqrt 2\,p\sqrt R.
\tag{3}
```

## 3. The published affine-energy input and its hypotheses

Petridis, Roche-Newton, Rudnev and Warren, *An Energy Bound in the Affine Group*, Theorem 2.1, gives for an affine-map set $`S`$ of size $`d`$ with maximum line occupancy $`L`$ and vertical-line occupancy $`v`$,

```math
E_{\mathrm{aff}}\ll v^{1/2}d^{5/2}+Ld^2,
```

provided $`vd\le p^2`$ in characteristic $`p`$. For our $`P`$ there is at most one point on any vertical line, hence $`v=1`$ and $`d\le p-1`$ verifies the hypothesis. Thus

```math
E_{\mathrm{aff}}\ll d^{5/2}+Ld^2.
\tag{4}
```

Their displayed energy is $`\#\{g^{-1}h=u^{-1}v\}`$, which has the same value as our right-quotient energy: $`gh^{-1}=uv^{-1}`$ if and only if $`u^{-1}g=v^{-1}h`$. This is a bijection of ordered quadruples, not an abelian-group assumption.

Primary source: [Theorem 2.1, PDF page 3](https://arxiv.org/pdf/1911.03401). Published in [*IMRN* 2022, issue 2, pages 1154–1172](https://academic.oup.com/imrn/article/2022/2/1154/5850679).

## 4. A large collinear subpalette would contradict Solymosi's theorem

Assume for contradiction along a sequence $`p\to\infty`$ that

```math
m\ge\varepsilon p^2,\qquad R=o(p^2),
\tag{5}
```

with fixed $`\varepsilon>0`$. Since $`m\le d|X|`$ and $`d,|X|\le p`$, both $`d`$ and $`|X|`$ are at least $`\varepsilon p`$. We show $`L=o(p)`$ along this sequence.

If not, some coefficient-plane line contains at least $`\delta p`$ points for fixed $`\delta>0`$ along a subsequence. Vertical lines contain at most one point, so the line has equation $`\beta(a)=ua+v`$. The corresponding color subgraph has at least

```math
L|X|-R\ge\delta\varepsilon p^2-o(p^2)
```

actual edges. Make row and column changes $`x'=x+u`$, $`y'=y-v`$. These maps are bijections and the retained lines become $`y'=ax'`$. The only possible edge with $`x'=0`$ or $`y'=0`$ is the point $`(0,0)`$, and simplicity/properness allows at most one actual edge there. Delete it.

The remaining graph is a partial multiplication-table graph on the two sides $`\mathbb F_p^\times`$, with edge color $`a=y'/x'`$. Invert the row labels if desired to write the color as the product of row and column. Solymosi's Theorem 5 says that a positive-density subset of a sufficiently large finite group table contains a nondegenerate rectangle with equal diagonal products. This gives a $`C_4`$ with repeated opposite color, contrary to B. Consequently

```math
L=o(p).
\tag{6}
```

Source: J. Solymosi, *The (7,4)-conjecture in finite groups*, [Theorem 5, PDF page 4](https://arxiv.org/pdf/1309.0133).

The partial supports need not coincide within this pencil. The estimate $`L|X|-R`$ uses only the total missing-incidence budget, so the cited group theorem is applied to the actual retained edges, not to completed maps.

## 5. Finishing the qualitative theorem

Under (5) we have $`\varepsilon p\le d\le p`$. Equations (4) and (6) give $`E_{\mathrm{aff}}=o(p^3)`$. Equation (1) then gives

```math
\lambda^4\le
\max\left\{o(p^4),\;o(p^4)+O\!\left(p^{7/2}\right)\right\}
=o(p^4),
```

so $`\lambda=o(p)`$. Equation (3), together with $`d\ge\varepsilon p`$ and $`R=o(p^2)`$, forces $`m=o(p^2)`$, contradicting (5). This proves the theorem uniformly.

The error rates in this qualitative deduction include the finite-group-table theorem. Section 8 gives an explicit stretched-logarithmic rate for exact common support. No polynomial saving is asserted for arbitrary intercepts. Fixed-degree nonlinear polynomial intercepts admit the separate $`O_D(p^{19/10})`$ bound proved in the [companion note](polynomial-affine-supports.md).

## 6. Standard exponential-sum input

The nonexceptional block estimate uses only the prime-field Kloosterman bound, with one-zero coefficients handled by character orthogonality: Iwaniec–Kowalski, *Analytic Number Theory*, [Theorem 11.11 and (11.15), printed page 280](https://people.math.ethz.ch/~kowalski/ik-ant-exp-sums.pdf).

The Fourier reduction and the treatment of zero coefficients are fully written in [Polynomial affine supports](polynomial-affine-supports.md). There is no assumed randomness of the four palette membership tests.

## 7. Limitations

The conclusion requires a common container with $`o(p^2)`$ omissions, or a separate support decomposition that reduces to that situation. General partial affine colorings can have $`\Theta(p^2)`$ omissions in every such container; this proof supplies no universal way to repair them. It also assumes one color for each slope and prime fields. The theorem is a mathematical deduction, not a claim to solve general #810 or a certification of historical originality.

## 8. An explicit common-support rate via integer Roth

Suppose $`R=0`$, put $`\theta=|X|/p`$, $`\kappa=d/p`$, and $`\rho=m/p^2=\kappa\theta`$. If $`|X|\le1`$, the edge bound $`m\le p`$ is already stronger than (Q), so assume $`|X|\ge2`$. Consider any nonvertical coefficient-plane line containing $`L_0`$ palette points; write it $`\beta(a)=ua+v`$ and let $`T`$ be its slope set. Discard the possible exceptional row $`x=-u`$, and put $`Y=(X+u)\setminus\{0\}`$. Thus $`|Y|\ge|X|-1`$. After shifting columns by $`-v`$, the pencil edges are precisely $`(x',ax')`$ for $`a\in T`$ and $`x'\in Y`$.

Choose a generator of $`\mathbb F_p^\times`$, put $`n=p-1`$, and write $`A_0=\log T`$ and $`Y_0=\log Y`$ as subsets of $`\mathbb Z_n`$. For every $`t\in\mathbb Z_n`$, define

```math
H_t=A_0\cap(Y_0-t).
```

The set $`H_t`$ is strongly three-term-AP-free. Indeed, suppose $`h-r,h,h+r`$ all belong to $`H_t`$ with $`r\ne0`$ in $`\mathbb Z_n`$. Take two row logarithms $`t+h-r`$ and $`t+h`$ and diagonal color $`h`$. The column logarithms are $`t+2h-r`$ and $`t+2h`$. The cross-colors are $`h+r`$ and $`h-r`$, respectively. All four edges are selected by common support, all rows and columns are distinct because $`r\ne0`$, and the two diagonal colors coincide. This violates B.

This argument also handles an element $`r`$ of order two: $`h-r=h+r`$ can then hold, but the rectangle still has distinct rows and columns and repeated diagonal color. No odd-order group theorem is being assumed. Integer representatives of $`H_t`$ in $`\{0,\ldots,n-1\}`$ are consequently ordinary integer 3AP-free, so $`|H_t|\le r_3([n])`$. Averaging over $`t`$ gives

```math
L_0|Y|=\sum_{t\in\mathbb Z_n}|H_t|\le n\,r_3([n]).
\tag{20}
```

Vertical coefficient-plane lines contain at most one palette point. Let $`F=r_3([p-1])/p`$. Since $`|X|-1\ge|X|/2`$, (20) implies for the maximum line occupancy $`L`$

```math
\frac{L}{p}\le\frac{2F}{\theta},
\tag{21}
```

with a harmless absolute enlargement for the vertical-line case.

Using the affine-energy estimate (4) in the master bound (1), followed by taking fourth roots and using $`E_\times(A)\le d^3`$, gives

```math
\frac{\lambda}{d}
\ll p^{-1/8}\kappa^{-3/8}
 +\left(\frac{L}{p}\right)^{1/4}\kappa^{-1/2}
 +p^{-1/8}\kappa^{-1/4}.
\tag{22}
```

The exact common-support identity and the spectral lower bound yield $`\rho\le(1+\lambda)/(d+\lambda)\le(1+\lambda)/d`$. Substitute (21) and note $`\kappa\ge\rho`$ and $`\theta=\rho/\kappa`$. Since $`0<\rho\le1`$,

```math
\rho\ll
p^{-1}\rho^{-1}
+p^{-1/8}\rho^{-3/8}
+F^{1/4}\rho^{-1/2}.
\tag{23}
```

At least one of the three terms is a fixed positive fraction of $`\rho`$. The resulting alternatives give respectively $`\rho\ll p^{-1/2}`$, $`\rho\ll p^{-1/11}`$, or $`\rho\ll F^{1/6}`$. This proves the first estimate in (Q).

The published Bloom–Sisask exposition of the Kelley–Meka theorem gives $`r_3([n])/n\le C\exp(-c(\log n)^{1/12})`$. Taking its sixth root changes only the constant $`c`$, proving the final estimate in (Q). Using a stronger integer Roth estimate in the first part of (Q) is also legitimate; the displayed exponent is a conservative published input, not a claim of the currently best numerical Roth exponent.

Primary source: Thomas F. Bloom and Olof Sisask, *The Kelley–Meka bounds for sets free of three-term arithmetic progressions*, *Essential Number Theory* 2 (2023), 15–44, [Theorem 1](https://msp.org/ent/2023/2-1/ent-v2-n1-p02-p.pdf). The same published issue is accessible [here](https://msp.org/ent/2023/2-1/ent-v2-n1-s.pdf).

The rate follows from the structural argument and the stated Roth bound. Historical priority of the resulting formulation remains unverified.
