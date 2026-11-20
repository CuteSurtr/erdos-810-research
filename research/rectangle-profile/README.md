# An upper bound from unbalanced bipartite cuts

Let $M(N)$ be the maximum number of edges of a simple graph on $N$ vertices with at most $N$ colors in which every four-cycle has four different colors. Then
```math
\limsup_{N\to\infty} M(N)/N^2 \le 291521/1000000=0.291521 .
```
This improves the repository's October coefficient $0.2984440375\ldots$. Six polynomial bounds and a correction for unequal side sizes first give $0.297354$. Two further iterations yield $0.297331$. Counting degrees on the row side separately gives $0.295155$. Repeating that estimate on the shorter side of each rectangle gives $0.291632$. Keeping the aspect ratio of the child rectangle in the denominator gives $0.291521$ in Lean. A separate end-to-end Lean proof gives $1/4$. [One-quarter theorem](../hall-reduction/QuarterDensity.lean) [Aspect-aware theorem](../hall-reduction/AspectDensity.lean) · [Pointwise proof](../graph-limits/quarter.md) [Width contraction and proof](contraction.md) The question whether $M(N)/N^2$ stays bounded away from zero remains open. [October profile argument](../local-progress/asymptotic-2026-10-15/profile-density-bound.txt) · [Erdős problem #810](https://www.erdosproblems.com/810)

## A bound for rectangles

First assume the coloring is proper. One can obtain a proper subgraph of any graph under consideration by deleting $o(N^2)$ edges uniformly and keeping the original colors. We may pad the palette with unused labels to size $N$. [Properification in Lean](../hall-reduction/Properification.lean)

Take two disjoint vertex sets with sizes $aN,bN$. Write $s=a+b\le1$ and let $mN^2$ count the edges between them. For a continuous profile $P$ with $0\le P\le1$ on $[0,1]$, put
```math
F_P(a,b)=\frac{ab s}{s+ab(1+sP(s))},\qquad F_P(0,0)=0.
```
Call $P$ valid if $m\le F_P(a,b)+o(1)$ uniformly in the graph and the choice of sides. The zero profile is valid. In integer coordinates, rectangles with sides $A,B$, $q$ colors and $e$ edges satisfy $[q(A+B)+AB]e\le qAB(A+B+1)$. After normalization the extra term in the upper bound is at most $1/N$. Also $0\le F_P(a,b)\le ab$, which gives continuity at the origin. [Rectangle inequality in Lean](../hall-reduction/RectangleBound.lean)

Fix a color occurring on $kN=K$ edges in this rectangle. These edges form a matching, with endpoint sets $L_c,R_c$ of size $K$ on its two sides. The rectangle $L_c\times R_c$ contains at most $K(K+1)/2$ edges. It contains the $K$ matching edges, and each unordered pair of matching edges allows at most one of its two cross edges. Having both would complete a four-cycle with two edges of that color.

Sum the row degrees on $L_c$ and the column degrees on $R_c$. The internal rectangle contributes twice, and the two remaining rectangles have normalized side sizes $(k,b-k)$ and $(a-k,k)$. For a valid $P$, this bounds the normalized sum for color $c$ by
```math
h(k)+k/N+o(1),\qquad h(k)=k^2+F_P(k,b-k)+F_P(a-k,k).
```
The error is uniform. Take the mean over all $N$ colors. Their normalized matching sizes have mean $m$. Properness makes the summed endpoint degrees equal to the sum of squared row and column degrees. Cauchy–Schwarz on the two sides therefore gives, for positive $a,b$,
```math
m^2(1/a+1/b)\le h(m)+o(1). \tag{1}
```

Here is the averaging step in (1). For $v=a$ or $b$ write $z_k=k(v-k)$ and $d=1/v+P(v)$. The corresponding cut is $z_k/(1+dz_k)$. The tangent to $z/(1+dz)$ at $z_m$ is an upper bound, with slope $H_v=(1+dz_m)^{-2}$. Since $z_k-z_m=(v-2m)(k-m)-(k-m)^2$, the cut is at most its affine tangent in $k$ minus $H_v(k-m)^2$. Also $dz_m\le(v+v^2)/4\le v/2$. One side has size at most $1/2$ and both have size at most $1$, giving $H_a+H_b\ge16/25+4/9>1$. Adding the two inequalities and the identity for $k^2$ shows that $h$ lies below its affine tangent at $m$. The linear terms disappear on averaging. Empty rectangles have zero edges.

## Retaining both side sizes

Consider any subsequence along which $(a,b,m)$ converges, and use the same letters for the limits. When $m>0$, both $a$ and $b$ are positive since $m\le ab$. The uniform error in (1) vanishes. Write $f(v)=v/(1+vP(v))$. Expanding its right side using
```math
F_P(m,v-m)=m(v-m)-\frac{m^2(v-m)^2}{f(v)+m(v-m)}
```
and dividing by $m$ gives
```math
m\le\frac{ab s}{s+ab(1+L(m))},\qquad
L(m)=\frac{(a-m)^2}{f(a)+m(a-m)}+\frac{(b-m)^2}{f(b)+m(b-m)}. \tag{2}
```

Cauchy–Schwarz gives
```math
L(m)\ge \frac{(s-2m)^2}{f(a)+f(b)+m(s-2m)}.
```
This last fraction decreases with $m$ on $[0,ab]$. Its reciprocal is $[f(a)+f(b)]/(s-2m)^2+m/(s-2m)$, and $s-2m\ge s-s^2/2>0$. Validity gives $m\le M=F_P(a,b)$. Thus a nonnegative profile $Q\le1$ is valid whenever
```math
(s-2M)^2\ge sQ(s)[f(a)+f(b)+M(s-2M)]. \tag{3}
```
To see uniformity, failure would give a sequence with $N\to\infty$ and a fixed positive excess over $F_Q$. Compactness supplies a convergent subsequence in $[0,1]^3$. The limiting $m$ would be positive, and (2)–(3) give $m\le F_Q$, a contradiction. Each induction step uses only the preceding uniform bound.

By symmetry write $a=sx$, $b=sy$, $x=(1+t)/2$, $y=(1-t)/2$ for $t\in[0,1]$. Put
```math
D=xy,\quad U=1+aP(a),\quad V=1+bP(b),\quad
J=1+sD(1+sP(s)),\quad B=J-2sD.
```
Then $M=s^2D/J$. Substitution in (3) and clearing positive denominators gives the polynomial inequality
```math
B^2UV-Q(s)\big[(xV+yU)J^2+s^2DBUV\big]\ge0. \tag{4}
```
Starting with zero, use the following six polynomials in order. Each row gives the coefficients from constant to quintic, in units of $10^{-6}$.

| Stage | Constant | Linear | Quadratic | Cubic | Quartic | Quintic |
|---:|---:|---:|---:|---:|---:|---:|
| 1 | 999982 | −1000908 | 260051 | 211655 | −207088 | 57719 |
| 2 | 999976 | −500632 | −497000 | 802099 | −489786 | 121804 |
| 3 | 999973 | −499097 | −390702 | 667511 | −414504 | 102855 |
| 4 | 999972 | −499094 | −390068 | 676897 | −418799 | 102409 |
| 5 | 999973 | −499129 | −389683 | 675471 | −415911 | 101306 |
| 6 | 999973 | −499133 | −389642 | 675359 | −415825 | 101377 |

At every step the rational certificate verifies $Q\ge0$, $1-Q\ge0$ and (4) on the full unit square. It expands in the tensor-product Bernstein basis, whose functions are nonnegative there. For degree $n$ in one variable, the coefficient of $x^k$ in this conversion at index $i$ is $\binom{i}{k}/\binom{n}{k}$ for $i\ge k$ and zero otherwise. If a box has a negative coefficient, midpoint subdivision gives exact Bernstein coefficients for its two children. Every leaf has only nonnegative coefficients. The six checks of (4) accept respectively 6, 2, 2, 2, 2 and 2 leaves. [Exact arithmetic and subdivision](check_profiles.py)

## The cut from a global color class

Let $uN$ be the number of endpoints of a color in the original graph. The cut from these endpoints to their complement has $a=u$, $b=1-u$, $s=1$, $z=ab$. Let $P$ be the sixth profile. Its initial limiting bound on this cut is $M_0=z/[1+z(1+P(1))]$. For this final cut keep both terms of (2). Each decreases with $m$ on $[0,\min(a,b)]$, since its reciprocal is $f(v)/(v-m)^2+m/(v-m)$ for $m<v$. For $0<u<1$ define
```math
M_{i+1}=\frac{z}{1+z(1+L(M_i))},\qquad i=0,1.
```
The actual limiting cut density is at most each $M_i$. Every $M_i\le z\le\min(a,b)$. Reapplying (2) uses the same sixth profile for the two subrectangles each time.

Put $w=5951/10000$ and $j=4756/10000$. Exact arithmetic verifies
```math
M_2\le w^2+j(u-w)-u^2/2. \tag{5}
```
For explicit denominator clearing, if $M_i=p/q$ let $A=aq-p$, $U=1+aP(a)$, $n_a=A^2U$ and $d_a=aq^2+pAU$. Define $n_b,d_b$ by exchanging $a,b$. Then
```math
p'=z d_a d_b,\qquad q'=d_a d_b+z(d_a d_b+n_a d_b+n_b d_a).
```
Starting at $p=z$, $q=1+z(1+P(1))$, two such updates give the numerator and denominator of $M_2$. They have positive denominator for $0<u<1$. The degree-114 polynomial $[w^2+j(u-w)-u^2/2]q'-p'$ after both updates has nonnegative Bernstein coefficients on five subintervals. At $u=0,1$ the cut is empty and the right side of (5) is positive directly. The right side is concave, so it is positive throughout. The same subsequence argument as for (3) makes the resulting bound on cut densities uniform, including sequences approaching either endpoint. [Exact terminal check](check_profiles.py)

A contraction improves the coefficient and reduces the degree of the terminal polynomial. Write $T(k)=z/[1+z(1+L(k))]$. If $0\le x\le y\le v$ and $f=f(v)$, the fall in the corresponding side term is
$$
L_v(x)-L_v(y)=(y-x)\frac{f(2v-x-y)+v(v-x)(v-y)}{[f+x(v-x)][f+y(v-y)]}.
$$
Since $f\ge v/2$, this is at most $(4+4v)(y-x)$. Summing over the two sides and using $z\le1/4$ gives $T(y)-T(x)\le(3/4)(y-x)$. If $h\ge0$ satisfies $T(h)\le h$ whenever $h<z$, equation (2) forces $m\le h$. Otherwise $0<m-h\le T(m)-T(h)\le(3/4)(m-h)$. [Contraction proof](../hall-reduction/FullCutContraction.lean)

For $w=1190169/2000000$, $j=4754683/10000000$ and $h=w^2+j(u-w)-u^2/2$, one exact update at $p=h$, $q=1$ verifies $T(h)\le h$ on $[1/16,15/16]$ whenever $h<z$. The resulting polynomial has degree 24. On the two outer intervals $h\ge z$. Thus the same affine bound (5) holds with these new constants. [Kernel sign check](../hall-reduction/FixedPointSigns.lean) · [Unrestricted upper bound in Lean](../hall-reduction/CertifiedDensity.lean)

## An improvement for unequal sides

For $s>0$ put $K(s)=(4-3s)/(5s)$. The fifth and sixth profiles give the stronger uniform estimate
$$
m\le F_{P_6}(a,b)-K(s)(ab)^2(a-b)^2+o(1). \tag{6}
$$
The correction vanishes on a square. To check (6), use the fifth profile in (3). In the notation of (4), set $z=ab=s^2D$, $C=1+sD$, $R=B^2UV$, $H=(xV+yU)J^2+zBUV$ and $q=P_6(s)$. The estimate before replacing the next profile by $q$ is $m\le zH/(CH+zR)$. Subtraction from $F_{P_6}=z/(C+zq)$ leaves $z^2(R-qH)/[(C+zq)(CH+zR)]$. Consequently (6) follows from
$$
R-qH-\tfrac15(4-3s)s t^2(C+zq)(CH+zR)\ge0 .
$$
The Bernstein coefficients on the whole unit square are nonnegative. Compactness again makes the error uniform. [Exact sign](../hall-reduction/ShapeSigns.lean) · [Interpretation and limiting argument](../hall-reduction/ShapeAlgebra.lean)

The correction in a subrectangle of side sum $v$ takes the form $K(v)A_v(k)^2$, where $A_v(k)=k(v-k)(v-2k)$. To average over color sizes $k$, the original integrand in (1) has a quadratic remainder of at least $(7/25)(k-m)^2$ below its affine tangent. Indeed $H_a+H_b\ge32/25$ follows by summing the lower tangent $(112-64v)/125$ for $(1+v/2)^{-2}$. For $0\le k,m\le v$, $|A_v(m)|\le v^3/8$ and
$$
A_v(k)-A_v(m)-A_v'(m)(k-m)=(k-m)^2(2k+4m-3v).
$$
Using the tangent inequality for the square gives a lower quadratic remainder of $-(3/4)v^4(k-m)^2$ for $A_v(k)^2$. Since $K(v)v^2\le4/15$ and $a+b\le1$, these two corrections together consume at most $(1/5)(k-m)^2$. Thus the corrected integrand still has an affine upper tangent at the mean. The case $v=0$ is empty. [Curvature and averaging](../hall-reduction/ShapeCurvature.lean) · [Corrected endpoint inequality](../hall-reduction/ShapeEndpoint.lean)

For a full cut, the resulting update is
$$
T_*(k)=\frac{z}{1+z[1+L(k)+E(k)]},\qquad
E(k)=\sum_{v\in\{a,b\}} K(v)(v-k)^2(v-2k)^2,
$$
where the sum counts both sides when $a=b$. If $0\le x\le y\le v$, the fall in $(v-k)^2(v-2k)^2$ is at most $6v^3(y-x)$. This follows by factoring the difference of squares and using $|(v-k)(v-2k)|\le v^2$. Therefore $E(x)-E(y)\le2(y-x)$. The earlier estimate for $L$ gives $T_*(y)-T_*(x)\le(7/8)(y-x)$ on $[0,z]$. [Fixed-point argument](../hall-reduction/ShapeFixedPoint.lean)

Now take $w=148677/250000$, $j=14777/31250$ and $h=w^2+j(u-w)-u^2/2$. On $[1/16,15/16]$ seven rational intervals certify $T_*(h)\le h$ whenever $h<z$. With $(p',q')$ the single update at $(h,1)$ from the preceding section, the polynomial checked is $z(hq'-p')+h[zE(h)]p'$. Both outer intervals satisfy $h\ge z$. Every limiting full cut thus satisfies $m\le h$ with the new constants. [Exact terminal certificate](../hall-reduction/ShapeTerminalSigns.lean) · [End-to-end theorem in Lean](../hall-reduction/ShapeDensity.lean)

## Using the imbalance a second time

Let $s=a+b>0$ and set $X=(a-m)(a-2m)$ and $Y=(b-m)(b-2m)$. Weighted Cauchy–Schwarz gives $K(a)X^2+K(b)Y^2\ge K(s)(X+Y)^2$, since $vK(v)=(4-3v)/5$ decreases with $v$. Expanding the square $(a-b)^2$ gives $2(X+Y)\ge(s-2m)(s-4m)$. The initial rectangle bound gives $m\le s^2/(4+s)$, so both factors on the right are nonnegative. These inequalities imply

$$
 E(m)\ge sG(s),\qquad G(s)=\frac{s^2(4-3s)^3(4-s)^2(9-4s)}{62500}.
$$

For the last step use $(9-4s)(4+s)^4\le3125$ on $[0,1]$. The difference is $(1-s)^2(821+362s+63s^2+4s^3)$. This lower bound on $E$ can be carried through the rectangular update at every side sum. [Gain inequality](../hall-reduction/ImbalanceGain.lean)

In the certificate for (6), replace $R$ by $R+G(s)H$. Starting from the sixth profile, the next two successful profiles have the following coefficients in units of $10^{-6}$.

| Stage | Constant | Linear | Quadratic | Cubic | Quartic | Quintic |
|---:|---:|---:|---:|---:|---:|---:|
| 7 | 999866 | −496052 | −274156 | 340952 | −93166 | −4677 |
| 8 | 999874 | −496301 | −271699 | 348470 | −109475 | 2786 |

For each transition, all Bernstein coefficients are nonnegative on the two boxes cut at $s=1/2$. The terminal comparison on the eighth profile uses $w=297331/500000$ and $j=472899/1000000$. Seven rational subintervals suffice for its fixed-point sign. This gives the full-cut bound with the new $w$. The rational-arithmetic checker reproduces both transitions and the terminal comparison. [Transitions](../hall-reduction/IteratedProfiles.lean) · [Terminal certificate](../hall-reduction/IteratedTerminal.lean) · [Extremal theorem](../hall-reduction/IteratedDensity.lean) · [Independent checker](check_profiles.py)

All four coefficient checks for stages seven and eight now run in Lean's kernel. The theorem's dependency audit lists only propositional extensionality, classical choice and quotient soundness. The separate Python checker recomputes the signs with exact fractions. [Stage seven](../hall-reduction/IteratedSigns7.lean) · [Stage eight](../hall-reduction/IteratedSigns8.lean) · [Independent checker](check_profiles.py)

## Counting only the row degrees

For a rectangle with $A$ rows and $B$ columns, write $e$ for its number of edges and $k_c$ for the size of the matching of color $c$. Its matched rows send at most $k_c(k_c+1)/2$ edges to the matched columns. Write $X_c$ for their edges to the remaining columns. Summing the original row degrees over all matched rows and all colors counts the sum of squared row degrees. Cauchy–Schwarz therefore gives the finite inequality

$$
2e^2\le A\sum_c [k_c(k_c+1)+2X_c].
$$

Each $X_c$ is another rectangle. In normalized coordinates its sides are $k$ and $b-k$. For a valid profile $P$, write $F_b(k)=k(b-k)/(1+(1/b+P(b))k(b-k))$. The tangent estimate used in (1) bounds $F_b(k)$ by its affine tangent at $m$ minus $H_b(k-m)^2$, where $H_b\ge(1+b/2)^{-2}$. When $b\le4/5$, $2H_b\ge1$, so $k^2+2F_b(k)$ also lies below its affine tangent. Averaging over color sizes and taking limits gives $2m^2\le a(m^2+2F_b(m))$ for $b<4/5$. When $m>0$, this is equivalent to

$$
(2-a)m\,[b+(1+bP(b))m(b-m)]\le 2ab(b-m).
$$

The inequality forces $m<b$. After division by $b-m$, its left side is $(2-a)[bm/(b-m)+(1+bP(b))m^2]$, strictly increasing on $[0,b)$. Thus a nonnegative $h$ satisfying the reverse polynomial inequality is an upper bound. [Finite count](../hall-reduction/MatchingRectangle.lean) · [Tangent and limiting inequality](../hall-reduction/DirectionalRectangle.lean)

For the full cut take $a=u$, $b=1-u$, $z=ab$, $P=P_8$, $w=59031/100000$, $j=43423/100000$ and $h=w^2+j(u-w)-u^2/2$. On $[0,1/4]$, exact arithmetic gives $h(1+z)\ge z$, as required by the zero profile. On $[15/16,1]$ it gives $h\ge z$. On the intervening interval seven rational pieces certify the reverse polynomial inequality at $h$. The step below then gives $\limsup M(n)/n^2\le w/2=0.295155$. All sign decisions use kernel reduction. [Unrestricted Lean theorem](../hall-reduction/DirectionalDensity.lean) · [Independent exact checker](check_profiles.py)

## Returning to the original graph

For a global color with $uN$ endpoints, the internal oriented edge count is at most $(uN)^2/2$. Each two matching edges can contribute at most two edges between their four ends, and two can occur only around a shared endpoint. Including the matching edges gives at most $(uN/2)^2$ undirected internal edges. The sum of the graph degrees on the endpoints equals the oriented internal count plus the cut. Using the final full-cut estimate, divided by $N^2$ it is at most $w^2+j(u-w)+o(1)$. [Formal internal-edge and degree counts](../hall-reduction/RectangleBound.lean)

Let $r=2|E|/N^2$. The $N$ endpoint fractions $u$ average to $r$. Summing their degree bounds counts every vertex degree $d_v$ exactly $d_v$ times. Since $\sum_v d_v^2\ge (2|E|)^2/N$, every subsequential limit satisfies $r^2\le w^2+j(r-w)$. If $r>w$, this would imply $r+w\le j$, whereas $2w>j$. Thus $\limsup r\le w$. Properification gives the claimed coefficient for arbitrary colorings.

From the repository root run `python3 research/rectangle-profile/check_profiles.py` to reproduce all polynomial signs. The check uses the Python standard library and exact rational arithmetic.
