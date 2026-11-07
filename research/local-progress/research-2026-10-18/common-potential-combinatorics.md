# Common-potential quadratic supports: combinatorial results and obstructions

18 October 2026. Analytic and probabilistic arguments only; no finite graph enumeration or Lean compilation. The unrestricted common-potential sparsity question remains open in this note. Historical novelty is not asserted.

For an odd prime $p$, let $A\subseteq\mathbb F_p^\times$, $H\subseteq\mathbb F_p$, and

```math
\sigma_a(x)=ax+a^2,\qquad
u_a(x)=a^2x+a^3=a\sigma_a(x),\qquad
D_a=\{x:u_a(x)\in H\}.
```

The selected color-$a$ edges are $(x,\sigma_a(x))$ with $x\in D_a$. Each $u_a$ is a permutation, so each color has $|H|$ selected incidences. When these incidences form a simple graph, $m=|A||H|$.

## 1. Exact collision condition

The two full color lines for distinct $a,b$ intersect only at

```math
(x,y)=(-a-b,-ab).
```

The potential coordinates of that point are $-a^2b$ for color $a$ and $-ab^2$ for color $b$. Consequently the selected incidences define a simple, properly colored graph exactly when

```math
\text{there are no distinct }a,b\in A
\text{ with }-a^2b,-ab^2\in H.                         \tag{1}
```

Each individual color is already a matching. Thus the only additional obstruction to obtaining a well-defined simple proper coloring is a point retained in two color lines.

Writing $n=p-1$ and choosing a generator $g$ of $\mathbb F_p^\times$, condition (1), for nonzero $H$, forbids the four multiplicative-logarithm tests

```math
i,j\in\log_g A,\qquad
\frac n2+2i+j,\ \frac n2+i+2j\in\log_g H.
```

This is an exact linear-form obstruction in $\mathbb Z_n$. It does not imply that the support matrices contain large nearly complete rectangles, as the next theorem shows.

## 2. Dense proper examples with no nearly complete large support rectangles

**Theorem.** For every sufficiently large odd prime $p$, there exist $A\subseteq\mathbb F_p^\times$ and $H\subseteq\mathbb F_p^\times$ such that:

1. The selected common-potential graph is simple and proper.
2. $|A|=(1/20+o(1))p$, $|H|=(1/8+o(1))p$, and therefore $m=(1/160+o(1))p^2$.
3. For both support matrices
   ```math
   B^{\mathrm{row}}(a,x)=\mathbf 1_H(a^2x+a^3),\qquad
   B^{\mathrm{col}}(a,y)=\mathbf 1_H(ay),
   ```
   every rectangle with two linearly large sides has density at most $1/2+o(1)$, uniformly for each fixed lower bound on the two side densities.
4. If desired, the examples can be chosen to contain an explicit repeated-color four-cycle, so they are not B-colorings.

The third assertion in particular rules out extracting, from properness alone, color–row or color–column rectangles with two linearly large sides and only $o(p^2)$ missing incidences. The theorem does not impose or contradict the B condition.

### 2.1. Palette and potential container

Put

```math
n=p-1,\qquad d=\lfloor n/20\rfloor,\qquad j=\lfloor n/4\rfloor,
```

and choose a generator $g$. Define

```math
I=\{0,\ldots,d-1\},\qquad
A=\{g^i:i\in I\},\qquad
J=\{g^k:0\le k<j\}.
```

Choose $H\subseteq J$ by retaining each element of $J$ independently with probability $1/2$.

For $a=g^i,b=g^{i'}\in A$, the exponents of $-a^2b$ and $-ab^2$ lie in

```math
\left[\frac n2,\frac n2+3(d-1)\right]\subset[ n/2,n),
```

without wrapping modulo $n$. This interval is disjoint from $[0,j)$. Both possible collision incidences are therefore absent, for every choice of $H\subseteq J$. This proves properness.

Scalar concentration gives, with probability tending to one,

```math
|H|=\frac j2+O\!\left(\sqrt{p\log p}\right).
```

For example, Hoeffding's bound for $j$ independent Bernoulli variables gives a tail at most $2\exp(-2t^2/j)$ for a deviation $t$. Hence all color supports have size $(1/8+o(1))p$, and

```math
m=d|H|=\frac{p^2}{160}+O\!\left(p^{3/2}\sqrt{\log p}+p\right).
\tag{2}
```

### 2.2. Uniform control of the color–row support matrix

Initially allow all nonzero slopes, not only $A$. For each $t\in\mathbb F_p$, let $M_t$ be the $(p-1)\times p$ matrix

```math
M_t(a,x)=\mathbf 1_{a^2x+a^3=t}.
```

Each row has exactly one nonzero entry. Each column has at most three, because $a^3+xa^2-t$ is a nonzero cubic polynomial in $a$. Thus $\|M_t\|\le\sqrt3$, although the Rademacher estimate below only needs the sums of squares.

The two exact variance identities are

```math
\sum_{t\in\mathbb F_p}M_t^*M_t=(p-1)I_p,                  \tag{3}
```

and

```math
\sum_{t\in\mathbb F_p}M_tM_t^*
=(p-1)I_{p-1}+\mathbf J-P_{-}.                            \tag{4}
```

Here $\mathbf J$ is the all-ones matrix and $P_-$ is the permutation matrix for $a\mapsto-a$ on $\mathbb F_p^\times$.

To verify (3), for a fixed slope $a$ two distinct columns cannot have the same potential value, while each column appears for exactly one $t$. For (4), the diagonal entry is $p$. For distinct $a,b$, equality of potential values at a common row is the equation

```math
(a^2-b^2)x+(a^3-b^3)=0.
```

It has exactly one solution if $b\ne-a$. If $b=-a$, its constant term is $2a^3\ne0$, so it has no solution. These are exactly the entries of (4). In particular, the operator norms in (3)–(4) are at most $2p$.

Write $\zeta_t=\mathbf 1_H(t)-1/2$ for $t\in J$. The full centered matrix is

```math
Z^{\mathrm{row}}
=\sum_{t\in J}\zeta_tM_t
=\frac12\sum_{t\in J}\varepsilon_tM_t,
```

with independent signs $\varepsilon_t\in\{-1,1\}$. Restricting either sum of positive-semidefinite matrices in (3)–(4) to $t\in J$ can only decrease it in the positive-semidefinite order. The rectangular Rademacher variance parameter is consequently at most $p/2$.

Tropp's rectangular Rademacher-series inequality therefore gives

```math
\Pr\!\left(\|Z^{\mathrm{row}}\|\ge u\right)
\le(2p-1)\exp(-u^2/p).
\tag{5}
```

In particular, with probability $1-o(1)$,

```math
\|Z^{\mathrm{row}}\|\le2\sqrt{p\log p}.                 \tag{6}
```

Restricting the slope rows to $A$ preserves this operator-norm bound.

For arbitrary $U\subseteq A$ and $V\subseteq\mathbb F_p$, (6) implies

```math
\begin{aligned}
\sum_{a\in U,x\in V}\mathbf 1_H(a^2x+a^3)
&\le\frac12\sum_{a\in U,x\in V}\mathbf 1_J(a^2x+a^3)
   +2\sqrt{p\log p}\sqrt{|U||V|}\\
&\le\frac12|U||V|+2\sqrt{p\log p}\sqrt{|U||V|}.
\end{aligned}
\tag{7}
```

Thus the number of missing incidences in the rectangle is at least

```math
\frac12|U||V|-2\sqrt{p\log p}\sqrt{|U||V|}.              \tag{8}
```

If $|U|,|V|\ge\delta p$ for fixed $\delta>0$, this is $(1/2-o_\delta(1))|U||V|$, uniformly over all such subsets. In particular it is not $o(p^2)$.

### 2.3. The color–column support matrix

On the two copies of $\mathbb F_p^\times$, put

```math
N_t(a,y)=\mathbf 1_{ay=t}\qquad(t\ne0).
```

Every $N_t$ is a permutation matrix. Hence

```math
\sum_{t\in J}N_tN_t^*
=\sum_{t\in J}N_t^*N_t
=jI_{p-1}.
```

The same Rademacher bound gives

```math
\left\|\sum_{t\in J}\zeta_tN_t\right\|
=O\!\left(\sqrt{p\log p}\right)
```

with probability tending to one. This event and (6) hold simultaneously by a union bound; independence between these two events is not needed. Restrict rows to $A$ and use the same cut estimate as in (7). The column $y=0$ is identically absent because $0\notin H$, and adjoining it causes no difficulty. This proves the color–column assertion.

### 2.4. Ensuring that the example is not B

This optional step makes the scope explicit without any finite search. Roth's theorem gives a nontrivial three-term arithmetic progression

```math
a-t,\ a,\ a+t\in A
```

for all sufficiently large $p$, since $|A|=(1/20+o(1))p$. One may apply the integer version to the representatives in $\{0,\ldots,p-1\}$. Here $a\ne0$, $t\ne0$, and $t\ne\pm a$.

The four potential values

```math
F=\{a^2(a-t),\ a^2(a+t),\ a(a-t)^2,\ a(a+t)^2\}
\tag{9}
```

all lie in $J$: each is the product of three elements of $A$, and its multiplicative-logarithm exponent is at most $3(d-1)<j$ for large $p$. Replace $H$ by $H\cup F$.

This changes $|H|$ by at most four, changes the row centered matrix by operator norm at most $4\sqrt3$, and changes the column centered matrix by at most four. Thus (2), (7), and (8), with harmless bounded changes in their error terms, still hold. Properness also remains true because $H\cup F\subseteq J$.

There is now a four-cycle with rows $-t,t$ and columns $a(a-t),a(a+t)$. In row order $-t,t$ and that column order, its colors are

```math
\begin{pmatrix}
a & a+t\\
a-t & a
\end{pmatrix}.
```

The four selected potential values are exactly (9). The rows and columns are distinct because $2t\ne0$ and $2at\ne0$. The repeated diagonal color $a$ proves that this graph is not B.

### 2.5. Inputs and precise consequence

The concentration input is Joel A. Tropp, *User-Friendly Tail Bounds for Sums of Random Matrices*, [Theorem 1.5, printed page 5 of the primary preprint](https://tropp.caltech.edu/papers/Tro11-User-Friendly-preprint.pdf), the rectangular Rademacher-series inequality. The primary statement has tail $(d_1+d_2)\exp(-u^2/(2\sigma^2))$, with $\sigma^2$ the maximum of the two operator norms of the sums of squares. Equations (3)–(4) verify its hypotheses here. The weaker rectangular Bernstein inequality, Theorem 1.6 on the same page, also suffices.

The optional non-B step uses only the qualitative consequence of the integer Roth bound, for example [Bloom–Sisask, Theorem 1](https://msp.org/ent/2023/2-1/ent-v2-n1-p02-p.pdf).

The obstruction is to the implication

```math
\text{proper common-potential coloring of positive density}
\ \Longrightarrow\
\text{a nearly complete support rectangle of positive density}.
```

It also defeats any proof relying on a bounded number of such rectangles to capture a positive fraction of the incidences: a fixed collection of rectangles with a sublinear side has total area $o(p^2)$, while rectangles with two linearly large sides have a positive proportion of omissions. No analogous counterexample with the B condition is provided.

## 3. Exact repeated-color parametrization

Write the repeated color as $a$, the cross-colors as $ar,au$, the repeated-color diagonal columns as $y,w$, and

```math
h_1=ay,\qquad h_2=aw.
```

The two cross-edge conditions are exactly

```math
h_2=rh_1+a^3r(r-1),\qquad
h_1=uh_2+a^3u(u-1).                                    \tag{10}
```

When $ru\ne1$, these give

```math
\frac{h_1}{a^3}
=\frac{u\bigl(r(r-1)+(u-1)\bigr)}{1-ru},\qquad
\frac{h_2}{a^3}
=r\frac{h_1}{a^3}+r(r-1).                               \tag{11}
```

The exact membership requirements are

```math
a,ar,au\in A,\qquad
h_1,h_2,rh_2,uh_1\in H.                                 \tag{12}
```

These are tests in the same $A$ and the same $H$. Replacing them by independently chosen slot sets loses the required correlation.

## 4. A rational path reaching an arbitrary diagonal potential

A direct first-order collision path normally approaches potential $-a^3$, whereas the arithmetic-progression template approaches $a^3$. There is a second-order path that reaches any prescribed normalized potential $\gamma\ne-1$.

Over a field of odd characteristic, put

```math
r=1+t,\qquad u=1-t+\kappa t^2,\qquad
\kappa=\frac{\gamma-1}{\gamma+1}.
```

After canceling $t^2$ in (11), the normalized first potential is

```math
F_\kappa(t)
=\frac{(1+\kappa)(1-t+\kappa t^2)}{1-\kappa-\kappa t},
\qquad
G_\kappa(t)=(1+t)F_\kappa(t)+t+t^2.                      \tag{13}
```

Both are regular at $t=0$ because $\kappa\ne1$, and

```math
F_\kappa(0)=G_\kappa(0)=\frac{1+\kappa}{1-\kappa}=\gamma.
```

The four required potential functions are

```math
a^3F_\kappa(t),\quad a^3G_\kappa(t),\quad
a^3(1+t)G_\kappa(t),\quad
a^3(1-t+\kappa t^2)F_\kappa(t).
```

All have constant value $\gamma a^3$ at $t=0$. The color functions all have constant value $a$. Moreover

```math
G_\kappa(t)-F_\kappa(t)
=t\bigl(F_\kappa(t)+1+t\bigr)
```

is not identically zero when $\gamma\ne-1$. Thus this is a genuinely nondegenerate rational family away from finitely many exceptional parameter values.

This algebra supplies an anchored rational configuration, not a recurrence theorem. No applicable result has been established here that forces all seven tests (12) for arbitrary dense $A,H$. In particular, the displayed functions are not shared-base additive polynomial translations, so ordinary polynomial Szemerédi cannot be invoked without further work.

## 5. A narrow obstruction to a direct monomial recurrence encoding

The following statement concerns identities in a Laurent function field $K(z)$, with $\operatorname{char}K\ne2$. It does not classify all rational parameterizations or all finite-field functions.

There is no nondegenerate repeated-color family of the form

```math
r=z^{r_0},\quad u=z^{s_0},\quad
h_1/a^3=\gamma z^{v_0},\quad h_2/a^3=\gamma z^{w_0},
```

with integers $r_0,s_0\ne0$, $v_0\ne w_0$, and $\gamma\in K^\times$.

Indeed, the first identity in (10) becomes

```math
\gamma\bigl(z^{w_0}-z^{r_0+v_0}\bigr)
=z^{2r_0}-z^{r_0}.                                      \tag{14}
```

The right side has two distinct exponents. Matching the two exponents and their coefficients either gives

```math
\gamma=1,\quad v_0=0,\quad w_0=2r_0,
```

or gives $\gamma=-1$ and $v_0=w_0=r_0$, which is excluded by nondegeneracy. In the first case, the second identity in (10) becomes

```math
1+z^{s_0}=z^{s_0+2r_0}+z^{2s_0}.                        \tag{15}
```

The left side has two distinct exponents, so the right side must as well; equality forces the multisets of exponents to agree. Either matching gives $s_0=0$ or $r_0=0$, a contradiction.

Thus a common-base monomial pattern, which would be a direct linear progression in multiplicative logarithms, cannot encode the required nondegenerate four-cycle in this form. Arbitrary algebraic or rational recurrence remains outside this obstruction.

## 6. Equal cross potentials: an exact three-value reduction

Suppose that the two cross potentials in (12) coincide. Write

```math
h_1=x,\qquad h_2=qx,\qquad rh_2=uh_1=k,
```

where $a,x\ne0$ and $q\ne1$. Then $u=qr$, and the two equations in (10) give

```math
(q-r)x=a^3r(r-1),\qquad
(1-rq^2)x=a^3rq(rq-1).
```

Eliminating $a^3/x$, and retaining nonzero colors, gives

```math
(q-1)\bigl((q+1)-r(q^2+1)\bigr)=0.
```

Consequently, on the nondegenerate open set,

```math
r=\frac{q+1}{q^2+1},\qquad
u=\frac{q(q+1)}{q^2+1},\qquad
k=x\frac{q(q+1)}{q^2+1},
\qquad
\frac{a^3}{x}
=-\frac{(q^2+q+1)(q^2+1)}{q(q+1)}.                    \tag{16}
```

It suffices to exclude

```math
q\in\{0,1,-1\},\qquad q^2+1=0,\qquad q^2+q+1=0.
```

These exclusions ensure that every displayed denominator is nonzero, the three colors $a,ar,au$ are nonzero and pairwise distinct, and the two diagonal columns $x/a,qx/a$ are distinct. Conversely, (16), these exclusions, and the six membership tests

```math
a,ar,au\in A,\qquad x,qx,k\in H
```

produce the required repeated-color four-cycle. Thus this reduction uses only three potential values, but it retains a cube-root condition and three coupled palette tests.

With $y=qx$, the potential relation and the cube condition become

```math
k=K(x,y):=\frac{xy(x+y)}{x^2+y^2},\qquad
a^3=-\frac{x^2+xy+y^2}{K(x,y)}.                         \tag{17}
```

An image-expansion result for $K$ alone therefore does not prove the original graph statement. In particular, it cannot discard the cube condition or replace the three palette tests by membership in unrelated sets.

## 7. Exact properness classification for the full palette

When $A=\mathbb F_p^\times$, the collision condition has a particularly simple form. For distinct nonzero potentials $h_1,h_2$, the equations

```math
h_1=-a^2b,\qquad h_2=-ab^2
```

have a solution in distinct nonzero colors if and only if $h_1^2/h_2$ is a cube. Indeed,

```math
a^3=-\frac{h_1^2}{h_2},\qquad b=a\frac{h_2}{h_1},
```

and $-1$ is itself a cube. These identities also prove the converse and show $a\ne b$ whenever $h_1\ne h_2$.

For primes $p\equiv2\pmod3$, cubing is bijective, so properness is equivalent to

```math
|H\setminus\{0\}|\le1.
```

For primes $p\equiv1\pmod3$, choose a cubic character $\chi$ taking values in $\{1,\omega,\omega^2\}$. The collision condition for distinct $h_1,h_2$ is

```math
\chi(h_1)\chi(h_2)=1.
```

Therefore properness is equivalent to both of the following: $H$ contains at most one nonzero cube, and it does not meet both nontrivial cubic cosets. An arbitrary subset of one nontrivial coset, together with at most one cube, passes this properness test. Zero is unrestricted by collision propriety, since the collision potentials for nonzero colors are always nonzero.

This classification concerns properness, not condition B. In particular, the two nontrivial cubic cosets are genuine remaining cases for a full-palette B argument.

## 8. Robust transfer from configuration counts to actual B-colorings

This section is an exact combinatorial transfer. The counting input is supplied by the complete extension of Tao's argument in [the cube-restricted counting proof](partial-rational-expansion-independent-audit.md), using [the separate-cover geometry](rational-expander-cover-proof.md). Image expansion for $K$ alone would not suffice. With these inputs, the final numerical bound below is a proved corollary of the written arguments; it is not a formally verified theorem or a claim of historical priority.

Let $H\subseteq\mathbb F_p^\times$, $h=|H|$, and let $T(H)$ count the ordered nondegenerate triples $(x,y,a)$ in (17) with $x,y,K(x,y)\in H$. Equivalently, use the parameters $a,q$ from (16), with all listed exclusions. Write

```math
B(q)=q^2+q+1,\qquad Q(q)=q^2+1,\qquad
F(q)=-\frac{B(q)Q(q)}{q(q+1)},\qquad
r(q)=\frac{q+1}{Q(q)}.
```

Then

```math
x=\frac{a^3}{F(q)},\quad y=qx,\quad k=qr(q)x,
\qquad b=ar(q),\quad c=aqr(q).
```

The associated rectangle has rows $x/a^2-a,y/a^2-a$, columns $x/a,y/a$, and color matrix

```math
\begin{pmatrix}a&b\\c&a\end{pmatrix}.
```

Its four colored incidences, expressed as color/potential pairs, are

```math
(a,x),\quad(a,y),\quad(b,k),\quad(c,k).                \tag{18}
```

All four underlying edges are distinct and all three colors are distinct on the nondegenerate parameter set.

### 8.1. A fixed omitted incidence destroys at most sixteen configurations

Fix a nonzero color and a nonzero potential. For the four possible roles in (18), the parameter $q$ obeys, respectively, one of the equations

```math
\begin{aligned}
\frac{a^3}{x}&=F(q),\\
\frac{a^3}{y}&=\frac{F(q)}q,\\
\frac{b^3}{k}&=-\frac{B(q)(q+1)}{q^2Q(q)},\\
\frac{c^3}{k}&=-\frac{qB(q)(q+1)}{Q(q)}.
\end{aligned}                                        \tag{19}
```

Each right side is a nonconstant rational function, and clearing denominators produces a nonzero polynomial of degree at most four. For the first, second, and fourth equations the numerator has degree four and strictly larger degree than the denominator. For the third the denominator has degree four and the numerator degree three; the prescribed left side is nonzero. Therefore each equation has at most four possible parameters $q$. Once the role and $q$ are fixed, all other colors and potentials are determined. A fixed colored incidence consequently belongs to at most sixteen configurations counted by $T(H)$.

Likewise a fixed color can occur in at most $3p$ configurations. There are three color roles, $a,b,c$, and at most $p$ choices of $q$ for each. For role $b$ one recovers $a=b/r(q)$; for role $c$ one recovers $a=c/(qr(q))$.

### 8.2. Missing colors and omitted eligible incidences

Let $A\subseteq\mathbb F_p^\times$ omit $D=(p-1)-|A|$ colors. Suppose an actual simple proper B-coloring selects a subset of the eligible incidences

```math
\{(a,h_0):a\in A,\ h_0\in H\},
```

and omits $R$ of them. No properness or B assumption is imposed on the completed eligible incidence system. Each configuration whose three colors lie in $A$ must lose at least one of its four incidences; otherwise the actual graph contains the repeated-color rectangle (18). The preceding multiplicity bounds and a union bound yield

```math
T(H)\le 3pD+16R.                                     \tag{20}
```

In particular, a positive lower bound $T(H)\ge c_\delta p^2$ for every $|H|\ge\delta p$ would rule out positive-density actual B-colorings whenever $D=o(p)$ and $R=o(p^2)$.

### 8.3. Quantitative sparsity, including omissions

The companion counting proof, equations (16)–(19), gives absolute constants $c,C>0$ such that

```math
T(H)\ge c\frac{h^3}{p}-C p^{15/16}h                 \tag{21}
```

for all sufficiently large primes and all nonzero $H$. To ensure nondegeneracy, apply that proof to two disjoint subsets of $H$ of comparable size, with the output required to lie in $H$. Each admitted pair has at least one nonzero cube root $a$ and therefore contributes to $T(H)$. The bounded cases $h<2$ are absorbed into the error term. Combining (20) and (21), and separating according to which right-hand term is at least half of $c h^3/p$, gives

```math
h\ll p^{31/32}+p^{1/3}(R+pD)^{1/3}.
```

The actual edge count is at most $ph$, so

```math
m\ll p^{63/32}+p^{4/3}(R+pD)^{1/3}.                    \tag{22}
```

If the original potential set also contains zero, the at most $p$ selected zero-potential incidences can be deleted first and restored into the first error term of (22). Thus this issue does not affect the stated exponents or the qualitative consequence.

In particular, the full palette with no omissions has $m=O(p^{63/32})$. If $D=o(p)$ and $R=o(p^2)$, then (22) gives $m=o(p^2)$. Arbitrary common potential sets $H$ are allowed in these conclusions; no Fourier-complexity assumption on $H$ is needed.

Estimate (22) depends on the cube-refined counting theorem (21), not merely on ordinary expansion of $K$. The completed eligible system need not be proper. Only the actual selected graph is required to be a simple proper B-coloring.

## 9. Current status

The same-potential question for arbitrary dense $A,H$ and the full B condition has not been resolved. Section 8 proves sparsity for a full or nearly complete palette, including the stated incidence omissions. A separate multiplicative Fourier/Wiener-norm argument treats arbitrary palettes under a Fourier-complexity hypothesis on the masks. The other results here are the properness-only extraction obstruction, exact correlated configuration formulas, and a limited obstruction to a monomial recurrence strategy.

The random examples above deliberately contain repeated-color four-cycles. They demonstrate why the B hypothesis must enter any support-extraction argument in an essential way; they are not candidates for a dense B construction.
