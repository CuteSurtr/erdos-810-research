# How many edges must be deleted to make the coloring proper?

For every sufficiently large $n$, there is a simple graph on $n$ vertices with at most $n$ colors in which every four-cycle is rainbow, and making the given coloring proper by deleting edges costs at least
```math
\frac{n^2}{36}\exp(-8\sqrt{\log n}).
```
In particular, a uniform $O(n^{2-\eta})$ deletion bound is impossible for every fixed $\eta>0$. This concerns the colors already assigned to the edges. It complements the upper bound of $o(n^2)$ from the triangle removal lemma. Both bounds allow a density tending to zero in Erdős #810. [Properification upper bound](../hall-reduction/Properification.lean) · [Problem statement](https://www.erdosproblems.com/810)

A connected example now separates the two deletion costs on the same graph. For all sufficiently large orders, every admissible initial coloring forces at least $n/2-O(n^{3/4})$ deletions with labels fixed. One edge deletion permits a proper recoloring of all remaining edges using the original palette budget. [Shared-edge construction and proof](shared-edge.md)

Within this construction the largest cost is exactly half the order for infinitely many orders, even allowing different block sizes. On 12 vertices the two costs are six and one. [Sharp bound for blocks sharing an edge](bouquet.md)

## A graph that loses half its edges

Fix a positive integer $L$ and a set $S\subseteq\{0,\ldots,L-1\}$ in which $a+c=2b$ and $a+2c=3b$ have only constant solutions. Take one set of $L$ centers indexed by $i$, and two disjoint sets of $2L$ outer vertices indexed by $z$. For every pair $(i,a)$ with $a\in S$, join $i$ to the first outer vertex with coordinate $L+i-a$ and the second outer vertex with coordinate $i+a$. Give both edges color $i+2a$. There are $5L$ vertices, fewer than or equal to $3L$ colors, and exactly $2L|S|$ edges.

To check the four-cycles, subtract $L$ from the coordinates in the first outer set. An outer coordinate then has the form $i+\sigma a$ with $\sigma\in\{-1,1\}$. In a four-cycle with distinct centers $i,j$, let the offsets at the first outer vertex be $a,b$ and the offsets at the second be $c,d$. For signs $\sigma,\tau$ the two equalities are
```math
j-i=\sigma(a-b)=\tau(c-d).
```
Equal colors at an outer vertex would give $j-i=2(a-b)$, forcing $i=j$. At center $i$ equal colors mean $a=c$. Equal tags would then give the same outer vertex. Opposite tags give $b+d=2a$, so the offset condition again forces $i=j$. Interchanging the centers handles $j$. Finally, equal colors on opposite edges can be written $j-i=2(a-d)$. For $\sigma=1$ this gives $a+b=2d$, and for $\sigma=-1$ it gives $b+2d=3a$. In either case all participating offsets coincide. Exchanging the two outer vertices treats the other diagonal. [Four-cycle proof](../hall-reduction/LayerBoard.lean)

Each center and offset produces a monochromatic path of length two. The paths partition the edge set, so every proper restriction deletes at least $L|S|$ edges. Keeping just one tag attains that number. At a center the remaining colors distinguish offsets. At an outer vertex two incident edges with equal colors would again have $j-i=2(a-b)=\sigma(a-b)$. [Counting proof](../hall-reduction/LayerDeletion.lean) · [Exhaustive check of 718 small sets](check_construction.py)

## Many offsets

Choose one squared Euclidean norm in the digit box $\{0,\ldots,d-1\}^r$ and read the vectors at that norm in base $3d$. Both weighted-average equations are carry-free. If $X+wZ=(1+w)Y$ coordinatewise, with $w=1$ or $2$, then
```math
(1+w)\big(\|X\|^2+w\|Z\|^2-(1+w)\|Y\|^2\big)=w\|X-Z\|^2 .
```
Equal norms force $X=Y=Z$. Pigeonholing the norm gives a set of at least $d^r/(r d^2)$ integers less than $(3d)^r$. This is the sphere construction used in Behrend's lower bound, with a larger radix to accommodate the weighted equation. [Weighted sphere proof](../hall-reduction/WeightedSphere.lean) · [Mathlib's Behrend construction](https://github.com/leanprover-community/mathlib4/blob/v4.24.0/Mathlib/Combinatorics/Additive/AP/Three/Behrend.lean)

For large $L$, set $X=\sqrt{\log L}$, $r=\lceil X\rceil$, $q=L^{1/r}$ and $d=\lfloor q/3\rfloor$. Then $X\le r\le2X$, $X/2\le\log q\le X$, and $q/6\le d\le q/3$. Thus $(3d)^r\le L$ and
```math
|S|\ge \frac{L}{6^r r q^2}\ge L\exp(-8X).
```
Indeed $r\log6+\log r+2\log q\le 8X$. For a prescribed graph order $n$, use $L=\lfloor n/5\rfloor$ and add isolated vertices. For $n\ge25$ one has $n\le6L$, giving the displayed lower bound. [Offset estimate](../hall-reduction/WeightedDensity.lean) · [Padding and deletion lower bound](../hall-reduction/ProperificationLower.lean)

The dimension can be optimized. For any fixed maximum weight $K>1$, take $r$ close to $a\sqrt{\log L}$. In the logarithm of the density loss, the leading coefficient is $a\log K+2/a$, minimized at $a=\sqrt{2/\log K}$. Rounding the dimension and radix contributes $o(\sqrt{\log L})$. Thus every constant $c>2\sqrt{2\log 3}$ may replace 8 in the original deletion bound. [Optimized offset sets](../hall-reduction/OptimizedSphere.lean) · [Deletion theorem](../hall-reduction/SphereBounds.lean)

## A finite guarantee in the other direction

In any admissible graph, let $W$ count unordered pairs of incident edges with the same color. The two outer endpoints of such a path have only one common neighbor, or a second common neighbor would complete a non-rainbow four-cycle. Each unordered endpoint pair accounts for at most one path, so $W\le\binom n2$. Form the graph with the original edges as vertices and the $W$ conflicting pairs as edges. Turán's theorem on its complement gives an independent set of size $s$ with
$$
m^2\le s(m+2W)\le s[m+n(n-1)].
$$
This independent set is a proper restriction of the original coloring. The statement has no restriction on the palette size. [Conflict graph and proof](../hall-reduction/ConflictPacking.lean)

For a prime $p$, take the $p^2$ points and $p^2$ nonvertical lines of the affine plane over $\mathbb F_p$. Color an incidence by its line. Two distinct lines have at most one common point, so the incidence graph has no four-cycle. Its $p^3$ edges split into $p^2$ monochromatic stars of size $p$. A proper restriction takes one edge per star, attainable by keeping the incidences at a fixed horizontal coordinate. The conflict graph consists of disjoint $p$-cliques, so the first inequality is exact here. The order-only bound gives the same order of magnitude. [Affine-plane proof](../hall-reduction/AffinePlanePacking.lean)

## Arbitrarily small retained fractions

There is a multi-layer version. Fix $k\ge2$ and choose $S\subseteq[0,L)$ so that every equation
```math
u a+v b=(u+v)c,\qquad u,v\ge1,\quad u+v\le k+1
```
has only constant solutions. Reading equal-norm vectors in base $(k+1)d$ gives this property by the same squared-norm identity, now with
$(u+v)(u\|A\|^2+v\|B\|^2)-\|uA+vB\|^2=uv\|A-B\|^2$.
For each fixed $k$, the pigeonhole estimate and the choice $r=\lceil\sqrt{\log L}\rceil$, $d=\lfloor L^{1/r}/(k+1)\rfloor$ give $|S|\ge L\exp(-O_k(\sqrt{\log L}))$.

Use centers $i\in[0,L)$ and $k$ outer sets indexed by $t=1,\ldots,k$, each of size $(k+1)L$. Join $i$ to $(t,i+ta)$ for every $a\in S$. All $k$ edges of this star receive color $i+(k+1)a$. Set $\lambda=k+1$. There are $[1+k(k+1)]L$ vertices, at most $(k+2)L$ colors, and $kL|S|$ edges.

In a four-cycle with centers $i,j$, write $j-i=t(a-b)=u(c-d)$ for the two outer tags $t,u$. An equal-color pair at the first outer vertex gives $t(a-b)=\lambda(a-b)$, which forces $a=b$ and $i=j$. A diagonal collision gives $t(a-b)=\lambda(a-d)$, hence $(\lambda-t)a+tb=\lambda d$. Again $a=b$. At center $i$, equal colors give $a=c$. Equal tags would make the outer vertices identical. For $t>u$, the two incidence equalities now give $tb=(t-u)a+ud$. For $u>t$, they give $ud=(u-t)a+tb$. The chosen offset condition excludes each possibility. Relabeling the centers or the outer vertices covers the remaining edge pairs.

A proper restriction keeps at most one edge of every monochromatic $k$-edge star. Keeping a single tag gives a proper subgraph of exactly $L|S|$ edges, so the maximum retainable fraction is $1/k$. For any fixed retained fraction and any fixed $\eta>0$, graphs exceeding $n^{2-\eta}$ edges eventually exist that force a smaller fraction. The exact finite construction and the maximum size of a proper restriction are formalized for every larger graph order, with isolated vertices used for padding. [Star and rectangle argument](../hall-reduction/WeightedStars.lean) · [Single-tag restriction](../hall-reduction/StarRestriction.lean) · [Padding](../hall-reduction/RestrictionMap.lean)

## An explicit bound at every large order

Write $x=\log_2 n$. For every $n\ge65536$, there is an admissible graph with at least
$$
n^2\,2^{-20x^{2/3}}
$$
edges, in which a proper restriction retains at most a fraction $2^{4-x^{1/3}}$ of the edges with their given colors. Thus graphs with $n^{2-o(1)}$ edges can force the deletion of a fraction tending to one.

Use $K=2^r$, $k=K-1$, $d=2^{r^2}$ and $L=(Kd)^r$. The construction fits in $K^2L=2^{f(r)}$ vertices, where $f(r)=r^3+r^2+2r$. Choose the largest $r$ with $2^{f(r)}\le n$, so $r\ge2$ and $r^3\le x<(r+3)^3$. If $E$ is the edge count, the offset estimate gives $2^{2r^3+r^2}\le E\,2^{r+2r^2}$. Since $2f(r+1)+r+2r^2\le 2r^3+r^2+20r^2$, padding still gives $n^2\le E\,2^{20r^2}$. The exact maximum retained fraction is $1/(2^r-1)\le2^{1-r}$. Substituting the two bounds on $x$ gives the displayed estimates. [All-orders integer inequalities in Lean](../hall-reduction/StarTradeoff.lean)
