# A verified 0.07354 upper density for the (7,4) problem

For $n\ge10^6$, a linear $(7,4)$-free triple system has fewer than $0.07354 n^2$ triples. Every such system, including systems with two triples sharing a pair of points, has fewer than $0.07354 n^2+n/2$ triples. Thus $\limsup_{n\to\infty}g(n;7,4)/n^2\le0.07354$. The full implications from the original definitions have been verified in Lean 4. The kernel reports the standard axioms of propositional extensionality, choice and quotient soundness. [Linear theorem](../hall-reduction/ShadowDensity.lean) · [General finite and asymptotic theorems](../hall-reduction/SevenFourDensity.lean)

Gishboliner and Solymosi give $2/27$ as the leading coefficient for linear systems. The present improvement uses both the distribution of degrees at a triple and a count of missing edges across its shadow cuts. The positive-density question remains open. [Gishboliner and Solymosi, Theorem 1.1](https://arxiv.org/html/2606.25931v1) · [Definitions and triangle counts](README.md) · [Degree deviations at a triple](refinement.md)

A width-dependent cut bound and a quadratic estimate on each triple subsequently improve the asymptotic coefficient to $0.073272$. The $10^6$ cutoff above applies to the $0.07354$ estimate. [Asymptotic theorem](width.md)

## A stronger bound across the cut

In a proper rainbow-four-cycle coloring with $q$ colors, let a rectangle have $a$ rows, $b$ columns and $e$ edges. Then
```math
(2q+a)e\le aq(2b+1).
```
If color $j$ appears $k_j$ times in the rectangle, its matched rows and columns span at most $k_j(k_j+1)/2$ edges. Its rows and unmatched columns span at most $k_j(b-k_j)$ edges. Summing the degrees of the matched rows over colors gives the sum of squared row degrees. Cauchy–Schwarz therefore gives
```math
2e^2\le a\sum_j[k_j(k_j+1)+2 k_j(b-k_j)]
      =a[(2b+1)e-\sum_j k_j^2].
```
Another application of Cauchy–Schwarz, $e^2\le q\sum_j k_j^2$, proves the assertion. [Finite rectangle proof](../hall-reduction/ThinRectangle.lean)

For a shadow edge, let $c$ and $b$ be the fractions of points adjacent to both or neither endpoint. Set $p=cb$, $h=1/n$. The cut between these two sets has normalized edge count $p-l$, where $l$ is its missing-edge count divided by $n^2$. Applying the rectangle bound with the neither-neighbor set as the rows gives $(2+b)l\ge b(p-h)$. Thus $(2c+p)l\ge p^2-hp$. For any real $t$, the square $(p-t(2c+p))^2\ge0$ and $p\le c$ give
```math
l\ge(2t-t^2)p-2t^2c-h/2 .
```
This stronger estimate applies to every cut in the previous proof. [Exact counts and cut inequality](../hall-reduction/ShadowCuts.lean)

## Separating the bounds

Write $r=3m/n^2$, $v$ for the vertex-degree variance, $D$ for the total normalized triple defect and $L$ for the total normalized missing-edge count. Let $P=r\mathbb E[p]$ and $C=r\mathbb E[c]$, averaging uniformly over shadow edges. Counting triangles, then summing the root estimates, gives
```math
D+3v=r(2/3+h-3r),\qquad L\le 2D/3,\qquad
L\le\tfrac32[(5/17)(D+3v)+hD].
```
The degree-moment and cut inequalities give
```math
4P\ge r[1/9-(1-4r)^2]-8v\quad(r\le1/4),\qquad
2C\le r(4r-2/3)+D+4v,\qquad
L\ge (2t-t^2)P-2t^2 C-rh/2 .
```
[Block and degree identities](../hall-reduction/ShadowBlocks.lean) · [Local square inequalities](../hall-reduction/ShadowScatter.lean) · [Global upper counts](../hall-reduction/ShadowUpper.lean)

Suppose $r\ge r_0=3(0.07354)$ and set $h_0=10^{-6}$, $r_1=2/9+h_0/3$, $B=r_1(2/3+h_0-3r_0)$. Nonnegativity gives $r\le r_1<1/4$ and $D+3v\le B$. Choose $t=93/1000$, $k=2t-t^2$, $w=(2k+t^2)/2$. The lower bound becomes
```math
L\ge k r_0[1/9-(1-4r_0)^2]/4-t^2[r_1(4r_1-2/3)+B]-r_1h_0/2-2wv.
```
Taking weights $w,1-w$ of the two upper bounds gives
$L\le [2w/3+(1-w)(3/2)(5/17+h_0)]B-2wv$. The variance terms cancel. The rational lower bound exceeds the upper bound by exactly
```math
\frac{358996108322838523369}{1836000000000000000000000000}.
```
Finally, removing both triples of each pair sharing two points costs at most $n/2$ triples because distinct removed pairs occupy disjoint four-point supports. [Rational separation](../hall-reduction/ShadowThreshold.lean) · [Removal proof](../hall-reduction/LinearCleanup.lean) · [Independent exact checker](check_counts.py)
