# Spectral and graph-limit obstructions for rainbow four-cycles

Write $r=2|E(G)|/n^2$. All graphs below have $n$ vertices, at most $n$ edge colors and four different colors on every four-cycle.

Every cut-limit graphon of these graphs is bounded by $1/2$ almost everywhere, so their upper edge coefficient is $1/4$. A finite regularity argument proves the same edge bound directly. The one-quarter edge coefficient and its one-eighteenth consequence for triples have end-to-end Lean proofs. [Graph theorem](../hall-reduction/QuarterDensity.lean) · [Triple theorem](../hall-reduction/HalfBoundedModel.lean) The spectral and entropy estimates below give other restrictions at finite orders and for special graph sequences. [Pointwise theorem](quarter.md) · [Finite counting argument](quarter-finite.md)

For any fixed $\alpha>0$ in the attainable range, a graph above $(1/4+\alpha)n^2$ edges needs $\Omega_\alpha(n\sqrt{\log^* n})$ colors for every four-cycle to be rainbow. Keeping the palette size in the finite energy recurrence gives this rate. [Quantitative lower bound on colors](finite-model.md#how-many-colors-are-needed-above-one-quarter)

For proper colorings with a linear palette, a fixed positive density gap above one quarter forces order $n^3$ four-cycles with a repeated color. The matching count also gives an upper bound of this same order. [Supersaturation proof](quarter-short.md#supersaturation-for-proper-colorings)

For any fixed positive density, the graph of equal-color moves on unordered vertex pairs has a negative adjacency eigenvalue of order $n$. At the one-quarter coefficient it admits a bipartition after $o(n^3)$ edge deletions. The same deletion count measures a constraint on the original adjacency matrix. [Pair graph, proof and finite check](pair-energy.md)

## What a graph at one quarter would look like

If the edges divided by $n^2$ tend to $1/4$, the adjacency matrices converge in cut distance to the constant $1/2$. Indeed a limiting $W\le1/2$ has integral $1/2$ and hence equals $1/2$ almost everywhere. Quantitatively $\|W-1/2\|_\square=1/2-\int W$. Thus every fixed graph has its fair-coin homomorphism density along a sequence reaching this coefficient.

There is a separate constraint visible in each large color. Pass to a proper restriction and write $S_c$ for the endpoints of color $c$ and $\pi_c$ for its fixed-point-free matching involution. Let $s_c=|S_c|$, let $D_c$ be the number of oriented edges inside $S_c$, and put $d=\|G-1/2\|_\square$ with normalized cut norm. Among the ordered pairs $u,v\in S_c$, precisely $s_c$ have both $uv$ and $\pi_c(u)\pi_c(v)$ occupied: these are the ordered edges of the original matching. Otherwise these two occupied edges would form a four-cycle with two edges of color $c$. The involution preserves the number of occupied entries, so the number for which both entries are absent is $s_c^2+s_c-2D_c$. The total number with equal adjacency is therefore
$$
 s_c^2+2s_c-2D_c\le 2d n^2+2s_c .
$$
At the one-quarter coefficient, every color on a fixed positive fraction of the vertices must switch occupancy on all but $o(n^2)$ endpoint pairs. This gives a necessary property for any construction approaching the coefficient. [Short graph proof](quarter-short.md) · [Finite approximation](finite-model.md)

## A negative eigenvalue above one quarter

If the least eigenvalue of the adjacency matrix is at least $-\eta n$, where $\eta\ge0$ is fixed, then
$$
r(r-1/2)\le \eta(1-r)+o(1).
$$
The error is uniform over graphs and colorings. It is zero when the coloring is proper. Thus a sequence with $r\to r_0>1/2$ satisfies
$$
\limsup \lambda_{\min}(A_G)/n\le-\frac{r_0(r_0-1/2)}{1-r_0}.
$$
For example a sequence with $0.28n^2+o(n^2)$ edges requires a least eigenvalue at most $-(0.07636\ldots)n+o(n)$. A sequence with $\lambda_{\min}(A_G)=o(n)$ has at most $(1/4+o(1))n^2$ edges. [Finite spectral proof](../hall-reduction/CutRayleigh.lean) · [Uniform theorem including improper colorings](../hall-reduction/SpectralDeletion.lean)

For a proper coloring let $S_c$ be the endpoints of color $c$, $s_c=|S_c|/n$, $I_c$ the number of oriented internal edges divided by $n^2$, and $D_c=n^{-2}\sum_{v\in S_c}d(v)$. Color averages include unused colors. The finite counting facts are
$$
I_c\le s_c^2/2,\qquad \mathbb E_c s_c=r,\qquad
\mathbb E_c D_c=n^{-1}\sum_v(d(v)/n)^2\ge r^2 .
$$
The vector $f_c=1_{S_c}-s_c\mathbf{1}$ has squared norm $ns_c(1-s_c)$, and $n^{-2}f_c^\top A_G f_c=I_c-2s_cD_c+s_c^2r$. The eigenvalue hypothesis therefore implies $2D_c\le(1/2+r-\eta)s_c+\eta$ after division by $s_c$ for nonempty supports. Empty supports satisfy the same inequality. Averaging proves the theorem. Conversely, whenever $\eta(1-r)<r(r-1/2)$, the indicator of at least one color support, after centering, witnesses a Rayleigh quotient below $-\eta n$. [Endpoint double count and witnessing color](../hall-reduction/SupportSpectrum.lean)

A general coloring has a proper restriction after deletion of $o(n^2)$ edges. Deleting $t$ edges changes the adjacency matrix by a matrix of Frobenius norm $\sqrt{2t}$, so every unit-vector Rayleigh quotient changes by at most $\sqrt{2t}$. This proves the uniform extension. [Sparse deletion](../hall-reduction/Properification.lean) · [Formal perturbation estimate](../hall-reduction/SpectralDeletion.lean)

## Neighborhoods cannot concentrate on almost-complete rectangles

Let $W$ be a graphon limit of such graphs in cut distance. For almost every $x$ and every measurable set $B$ of measure $b$,
$$
\int_B W(x,y)\,dy\le \frac{b}{1+b/2}. \tag{1}
$$
In particular $W(x,y)=1$ on a set of measure zero. A $\{0,1\}$-valued graphon limit must be identically zero almost everywhere. The inequality also restricts the conditional variance of an edge. Writing $r=\int W$, it gives
$$
\iint W(x,y)(1-W(x,y))\,dx\,dy\ge r^2/2-r^3/12 .
$$

For the finite count take any column set $B$ of size $b_0$ in a proper coloring with $q$ colors. The one-sided rectangle inequality, applied with $B$ as the rows and the vertices of positive excess as the columns, yields
$$
\sum_x [(2q+b_0)d_B(x)-2qb_0]_+\le qb_0 .
$$
Equivalently, for a fixed $B$, the sum of all excesses over $2qb_0/(2q+b_0)$ neighbors is at most $qb_0/(2q+b_0)$. [Finite excess theorem](../hall-reduction/RectangleObstructions.lean) · [One-sided count](../hall-reduction/ThinRectangle.lean)

For $q=n$, the rectangle inequality gives $\int_{A\times B}W\le |A|b/(1+b/2)$ for each measurable $A,B$ in the limit. To justify the passage, first take vertex subsets in the finite graph. For arbitrary measurable sets in its step graphon, independently sample row and column vertex subsets using the fractions of each vertex interval they occupy. Their sizes and normalized edge counts concentrate around their expectations by bounded differences. Relabelings preserve these inequalities. Sparse deletion changes every normalized cut by $o(1)$. Fixing $B$ and varying $A$ proves (1) for almost every $x$. First intersect the full-measure sets for finite unions of intervals with rational endpoints, then approximate any other $B$ in measure. The absence of a positive atom at one follows by applying (1) to $B=\{y:W(x,y)=1\}$.

For the variance claim put $d=\int W(x,y)\,dy$ at a fixed admissible $x$. The decreasing rearrangement of this row has cumulative integral bounded by $F(b)=\min\{d,b/(1+b/2)\}$. The derivative $F'$ equals $(1+b/2)^{-2}$ up to $b=2d/(2-d)$ and is zero afterwards. For a decreasing function $v$, $\int(v-t)_+=\max_b(\int_0^b v-tb)$. The cumulative bound therefore implies $\int(W(x,y)-t)_+\,dy\le\int(F'-t)_+$ for every $t$. Integrating twice the two sides over $0\le t\le1$ gives $\int W(x,y)^2\,dy\le\int(F')^2=d-d^2/2+d^3/12$. Jensen's inequality for the convex function $d^2/2-d^3/12$ proves the displayed global result. The finite input is Lean-verified. The passage to graphons and the integration argument are written proofs.

## An obstruction for continuous graphons

For every pair of measurable sets $A,B$ of positive measure on which $W$ is essentially bounded below by a constant $p>1/2$, the following finite counting argument gives a contradiction. In particular a continuous graphon limit satisfies $W\le1/2$ everywhere, and a finite-step graphon satisfies this bound on every positive-measure block.

In a proper coloring, a rectangle with $e$ edges and $q$ colors contains a color with $k\ge e/q$ entries. Its matched rows and columns determine a $k$ by $k$ subrectangle with at most $k(k+1)/2$ entries. Thus every pair of linear-sized sides with positive edge density contains a linear-sized square of density at most $1/2+o(1)$. [Finite sparse-square theorem](../hall-reduction/RectangleObstructions.lean)

For a cut-convergent sequence relabeled on $[0,1]$, it suffices to work first with measurable sets $A,B$ and their fractional memberships on vertex intervals. If their limiting rectangle mass is $m>0$, there are unions of vertex cells $A',B'$ with mass at least $m/2$ and a fixed positive lower membership in $A,B$ on every selected cell. Indeed discard all cells on each side with membership below $m/4$. The discarded overlap contributes at most $m/2$ in total in the limit. Deleting the $o(n^2)$ improper edges changes this bound by $o(1)$. Apply the square theorem to the surviving cells. Intersect its row and column unions with $A,B$. To keep the density comparison valid with fractional memberships, discretize the retained membership fractions into finitely many bins of relative width $1+\gamma$ on each side and choose one pair of bins with positive rectangle mass. The weights on a square inside these two bins change its density by a factor at most $(1+\gamma)^2$. The two intersections have positive measure bounded below independently of $n$, as the initial bin pair has a fixed positive mass and each retained cell has membership at least $m/4$. Cut convergence now contradicts $W\ge p$ there if $(1+\gamma)^2/2<p$. A continuous value above $1/2$ supplies such a rectangle by continuity.
