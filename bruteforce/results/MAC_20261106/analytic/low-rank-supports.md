# Low-rank actual supports in polynomial affine colorings

6 November 2026. A quantitative corollary of the archived weighted
completed-operator estimate. This does not resolve arbitrary affine supports
or Erdős #810. Historical novelty and external verification are not claimed.

## Statement

Let $p$ be an odd prime, $2\le D<p$, $A\subseteq\mathbb F_p^*$, and
$\beta\in\mathbb F_p[T]$ have degree $D$. Retain the color-$a$ edge
$(x,ax+\beta(a))$ precisely when $F_{a,x}=1$, for a binary matrix
$F\in\{0,1\}^{A\times\mathbb F_p}$. Assume the resulting graph is simple
and proper and every four-cycle is rainbow. Let $m$ be its number of edges.

**Theorem.** If $r=\operatorname{rank}_{\mathbb R}F$, then
\[
m\le C_Dp^{47/24}r^{1/3}.                                      \tag{1}
\]
More generally, for any matrix $B\in[0,1]^{A\times\mathbb F_p}$ of real
rank $r$, put
\[
R=\sum_{a,x}|F_{a,x}-B_{a,x}|.
\]
Then
\[
m\le C_Dp^{47/24}r^{1/3}+C p^{3/2}R^{1/4}.                    \tag{2}
\]
The constants are uniform over the prime, polynomial coefficients, palette,
and supports, with only $D$ fixed. The approximation $B$ need not represent
a valid colored graph. Consequently,
\[
r=o(p^{1/8}),\qquad R=o(p^2)\quad\Longrightarrow\quad m=o(p^2).
\]
The same statements hold using the color–column support matrix instead:
all masks and degree counts below can be placed on columns.

These are **real-rank** assertions. Finite-field rank, sign rank, unbounded
approximations, and spectral approximation without controlled entrywise
error do not satisfy the hypotheses.

## 1. The existing weighted operator input

Put $d=|A|\le p-1$, and on counting-measure $\ell^2(\mathbb F_p^2)$ define
\[
\tau_a(x,y)=((y-\beta(a))/a,ax+\beta(a)),\qquad U_af=f\circ\tau_a.
\]
Let $P$ project orthogonally onto constants. The archived theorem states,
for every complex weight $w$,
\[
\left\|\sum_aw(a)(U_a-P)\right\|
\le\Lambda\|w\|_\infty,\qquad\Lambda\le C_Dp^{7/8}.             \tag{3}
\]
The precise input is Section 2 of
[the weighted Fourier-majorant theorem](https://github.com/CuteSurtr/erdos-810-research/blob/0ad64e9/research/local-progress/overnight-2026-10-15/pass5-fourier-majorant-support-theorem.txt).
It uses fourth **singular** moments for nonreal weights. In particular it
retains, in absolute value, the nonidentity translation contribution in the
axis block. Its stated bound is
\[
\Lambda^4\le\max\{(p-1)E_{\rm aff}+d^3,\,
                 p(L+2)d^2+2\sqrt p\,E_\times(A)\}.
\]
Here $L\le D$, $E_{\rm aff}\le(2D-1)d^2$, and $E_\times(A)\le d^3$,
which prove (3). No stronger operator estimate is assumed in this note.

## 2. A separated norm bounded by the square root of real rank

For a real matrix $B$, define
\[
\Gamma(B)=\inf_{B_{a,x}=\sum_j u_j(a)v_j(x)}
                 \sum_j\|u_j\|_\infty\|v_j\|_\infty,
\]
where the infimum is over finite real separated expansions. We prove
\[
|B_{a,x}|\le1,\quad \operatorname{rank}_{\mathbb R}B=r
\quad\Longrightarrow\quad
\Gamma(B)\le K\sqrt r,\qquad K=\sinh(\pi/2).                  \tag{4}
\]
This is a standard type of factorization estimate; the details are included
to specify the exact norm needed by (3).

First work in the $r$-dimensional real row space of $B$. The symmetric
convex hull $\mathcal K$ of its rows has nonempty interior there. By the
symmetric John ellipsoid theorem there is an ellipsoid
\[
\mathcal E\subseteq\mathcal K\subseteq\sqrt r\,\mathcal E.
\]
After taking $\mathcal E$ as Euclidean unit ball, the row vectors $b_a$
have norm at most $\sqrt r$. Every column-evaluation functional has norm
at most one: its absolute value is at most one on $\mathcal K$, hence on
$\mathcal E$. Its representing vector $v_x$ thus satisfies $\|v_x\|\le1$.
Therefore
\[
B_{a,x}/\sqrt r=\langle u_a,v_x\rangle,\qquad
u_a=b_a/\sqrt r,\quad\|u_a\|,\|v_x\|\le1.                    \tag{5}
\]

For the primary ellipsoid input, see Gruber–Schuster,
[An Arithmetic Proof of John's Ellipsoid Theorem, Theorem 1](https://www.dmg.tuwien.ac.at/schuster/john1.pdf).
Their contact identity $I=\sum_i\lambda_i z_i z_i^\top$ in John position
gives the stated inclusion directly: supporting hyperplanes give
$|\langle z_i,z\rangle|\le1$ for $z\in\mathcal K$, and
$\sum_i\lambda_i=r$, so $\|z\|^2\le r$.

Pad the vectors in (5) to unit vectors by adding separate orthogonal
coordinates for the row and column vectors. All cross inner products stay
unchanged. For a standard Gaussian vector $g$ in this enlarged space, put
\[
\epsilon_a=\operatorname{sgn}\langle g,u_a\rangle,\qquad
\eta_x=\operatorname{sgn}\langle g,v_x\rangle.
\]
Rotational symmetry in the two-dimensional span of each pair shows
\[
Z_{a,x}:=\mathbb E[\epsilon_a\eta_x]
=\frac2\pi\arcsin(B_{a,x}/\sqrt r).
\]
Indeed the probability of unequal signs is
$\arccos(\langle u_a,v_x\rangle)/\pi$.

The matrix $Z$ lies in the convex hull of the finitely many rank-one sign
matrices. The same is true of every entrywise positive integer power
$Z^{\circ k}$: take $k$ independent sign pairs and multiply their row
signs and column signs. Consequently $\Gamma(Z^{\circ k})\le1$. Entrywise
sine inversion yields
\[
B/\sqrt r=\sum_{j\ge0}
       \frac{(-1)^j(\pi/2)^{2j+1}}{(2j+1)!}\,Z^{\circ(2j+1)}.
\]
The sum of absolute coefficients is $\sinh(\pi/2)=K$, so
$\Gamma(B)\le K\sqrt r$. To justify finite expansions, the unit ball
of $\Gamma$ is the convex hull of finitely many rank-one sign matrices
and is closed. Partial sums converge into its $K$-multiple; the limit
has a finite convex representation. This proves (4), including attainment.
The zero-rank matrix is zero and has $\Gamma=0$.

For comparison, a maximal absolute $r\times r$ minor gives the simpler
bound $\Gamma(B)\le r$: take its selected full rows as a basis and use
Cramer's rule. The square-root estimate in (4) is what improves the
density threshold from $p^{1/16}$ to $p^{1/8}$.

## 3. Approximate positivity of the masked operator

Write $b_a(x)=B_{a,x}$, and let $M_{b_a}$ multiply by this row function on
the state space $(x,y)$. Define
\[
T_B=\sum_aM_{b_a}U_aM_{b_a},\qquad
Q_B=\sum_aM_{b_a}PM_{b_a}.
\]
The operator $Q_B$ is positive semidefinite because the masks are real.
For any separated expansion $b_a(x)=\sum_j u_j(a)v_j(x)$,
\[
T_B-Q_B
=\sum_{i,j}M_{v_i}
   \left(\sum_a u_i(a)u_j(a)(U_a-P)\right)M_{v_j}.
\]
Applying (3) termwise and taking the infimum gives
\[
\|T_B-Q_B\|\le\Lambda\Gamma(B)^2\le K^2\Lambda r.             \tag{6}
\]
This step requires neither a Fourier basis nor any common ordering or
additional structure of the separated functions.

Let $E$ be the actual edge set and $f=1_E$ on $\mathbb F_p^2$. Thus
$\|f\|_2^2=m$. With the actual masks $F_a$, one has exactly
\[
\langle f,T_Ff\rangle=m.                                    \tag{7}
\]
Every nonfixed internal transition would have both closing color-$a$
edges present and hence give a nonrainbow four-cycle. Distinct rows
give distinct columns because $a\ne0$. The fixed transitions are exactly
the actual colored edges, counted once by simplicity.

Write $\rho_x$ for actual row degrees. Simplicity and propriety imply
\[
\rho_x=\sum_aF_{a,x},\qquad\sum_x\rho_x=m,\qquad0\le\rho_x\le p.
\]
For exact masks $B=F$, Cauchy–Schwarz gives
\[
\langle f,Q_Ff\rangle
=\frac1{p^2}\sum_a\left(\sum_xF_{a,x}\rho_x\right)^2
\ge\frac1{dp^2}\left(\sum_x\rho_x^2\right)^2
\ge\frac{m^4}{dp^4}.                                       \tag{8}
\]
For $m>0$, (6)–(8) imply
\[
m^3\le dp^4(1+K^2\Lambda r).
\]
Using $d\le p$, (3), and $r\ge1$ proves (1). If $r=0$, $F=0$.

## 4. Robustness to entrywise approximation error

Put $e_a(x)=|F_{a,x}-b_a(x)|$. Since both masks lie in $[0,1]$,
\[
|F_{a,x}F_{a,z}-b_a(x)b_a(z)|\le e_a(x)+e_a(z).
\]
In the quadratic form tested on $f=1_E$, fixing $a,x$ leaves at most
$\rho_x\le p$ choices of $y$. The other term has the same bound after
the involution $\tau_a$. Thus
\[
|\langle f,(T_F-T_B)f\rangle|\le2pR.                         \tag{9}
\]
Nonnegativity of $b_a$ and Cauchy–Schwarz also give
\[
\begin{aligned}
\sum_a\langle f,b_a\rangle
 &=\sum_x\rho_x\sum_a b_a(x)\\
 &\ge\sum_x\rho_x^2-pR\ge m^2/p-pR,\\
\langle f,Q_Bf\rangle
 &\ge\frac{(m^2/p-pR)_+^2}{dp^2},
\end{aligned}
\]
where $z_+=\max(z,0)$. Combining (6), (7), and (9) proves
\[
\boxed{\frac{(m^2/p-pR)_+^2}{dp^2}
       \le(1+K^2\Lambda r)m+2pR.}                           \tag{10}
\]
If $m^2\le2p^2R$, then $m\le\sqrt2\,p\sqrt R\le
\sqrt2\,p^{3/2}R^{1/4}$, since $R\le dp\le p^2$.

Otherwise (10) implies
\[
m^4\le4p^5(1+K^2\Lambda r)m+8p^6R.
\]
At least one term on the right is at least half the left, so
\[
m\le2p^{5/3}(1+K^2\Lambda r)^{1/3}
       +2p^{3/2}R^{1/4}.
\]
For $r\ge1$, (3) absorbs the first term into that of (2).
For $r=0$, $B=0$ and $R=m\le p^2$, so directly
$m\le p^{3/2}R^{1/4}$. This proves (2), including the zero-rank case.
Empty palettes are immediate and need no division by $d$.

## Scope

The argument combines an existing weighted operator estimate with a
standard real factorization bound; no new operator or ellipsoid theorem
is claimed. Bounded real rank of a binary support matrix implies bounded
VC dimension, so the bounded-rank qualitative conclusion is already
covered by the repository's bounded-VC theorem. The explicit gain here
is a quantitative obstruction for growing real rank and for bounded
approximations with controlled entrywise error.

For $m\ge\delta p^2$ with fixed $\delta>0$, the exact bound forces
$r\ge c_{D,\delta}p^{1/8}$. In the approximate version, rank
$o(p^{1/8})$ forces an entrywise error of order $p^2$. Generic support
matrices can have full real rank, so these bounds do not settle arbitrary
supports.
