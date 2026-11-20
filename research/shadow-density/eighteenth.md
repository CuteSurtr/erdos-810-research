# A one-eighteenth upper density for the (7,4) problem

Let $g(n;7,4)$ be the largest number of distinct triples on $n$ points such that any four span at least eight points. The graph-limit argument gives
$$
\limsup_{n\to\infty} g(n;7,4)/n^2\le 1/18=0.055555\ldots .
$$
The coefficient is 25% smaller than $2/27$, the leading coefficient in Gishboliner and Solymosi's Theorem 1.1 specialized to linear triple systems. The result uses the pointwise graphon bound $W\le1/2$, which is stronger than the corresponding bound on the integral of $W$. A finite proof of the one-eighteenth coefficient has been verified end to end in Lean, including the cleanup for nonlinear systems. [Pointwise graphon theorem](../graph-limits/quarter.md) · [One-eighteenth Lean theorem](../hall-reduction/HalfBoundedModel.lean) · [Gishboliner and Solymosi](https://arxiv.org/html/2606.25931v1)

In Corollary 1.3 of their June 24 preprint, setting $k=4$ gives the finite threshold $2n^2/27+n/3$ for four triples on at most seven points in a linear system. Their normalized density is $c=3m/\binom n2$. The two leading coefficients in that convention are $4/9$ and $1/3$, again a ratio of $3/4$. The comparison concerns the leading term. [Corollary 1.3 and normalization (1)](https://arxiv.org/html/2606.25931v1)

Take a linear admissible system and color every edge of its shadow graph by the third point of its triple. This is a proper coloring with every four-cycle rainbow. If $x$ lies in $d_x$ triples, its shadow neighborhood splits into $d_x$ disjoint pairs, one for each of those triples. There is at most one shadow edge between any two such pairs. Indeed the two triples through $x$ cover five points. Each cross edge belongs to a further triple, adding at most one point. Two distinct cross edges belonging to distinct triples would give four triples on at most seven points. A single further triple cannot contain two cross edges between these pairs: it would contain both points of one of the pairs, contrary to linearity. Thus
$$
 e(G[N(x)])\le d_x+\binom{d_x}{2}.
$$
[Formal shadow coloring](../hall-reduction/ShadowCuts.lean) · [Root arm count](../hall-reduction/ShadowArms.lean)

Take a subsequential graphon limit $W$ of the shadow graphs and put $d(x)=\int W(x,y)dy$, $p=\int d(x)dx$, $D_2=\int d(x)^2dx$. The triangle density $T$ counts ordered triangles. Summing the neighborhood inequality gives $T\le D_2/4$ because the ordinary shadow degree at each vertex is $2d_x$. The finite normalized error is at most $1/(2n)$. Both $T$ and $D_2$ converge in cut distance, as they count homomorphisms of the triangle and the two-edge path. Alternatively the usual single-edge telescoping proof bounds their differences by three and two times the cut norm, respectively.

The graph theorem gives $0\le W\le1/2$ almost everywhere. For $U=2W$, the two numbers $U(x,z)$ and $U(y,z)$ lie in $[0,1]$, so their product is at least their sum minus one. Multiply by $U(x,y)$ and integrate over $x,y,z$. This yields
$$
8T\ge 8D_2-2p .
$$
Combining the inequalities gives $3D_2\le p$. Cauchy–Schwarz gives $p^2\le D_2$, hence $p\le1/3$. A linear system with $m$ triples contributes $3m$ shadow edges, so $p=\lim 6m/n^2$ along the chosen subsequence. It follows that its upper triple density is at most $1/18$.

The finite shadow triangle upper bound, the weighted triangle lower bound for matrices bounded by one half, and the final moment inequality have also been checked by Lean. [Triangle and moment lemmas](../hall-reduction/ShadowTriangleCap.lean)

Finally, deleting at most $n/2$ triples makes any admissible system linear. This removes $o(n^2)$ triples and proves the same leading coefficient for unrestricted systems. The question whether $g(n;7,4)=o(n^2)$ remains open. [Deletion proof](../hall-reduction/LinearCleanup.lean)

A finite matrix approximation gives an independent proof of the same triple coefficient with an explicit (tower-size) cutoff. [Finite proof and cutoff](../graph-limits/finite-model.md)

## What equality would force

If a sequence reaches $1/18$, the cut limit of its linearized shadows is unique up to measure-preserving equivalence. Split the vertex space into three sets of measure $1/3$. The limit is zero within the sets and $1/2$ between any two sets. The same conclusion in cut distance holds for every sequence whose triple density tends to $1/18$.

To prove this, put $U=2W$ and $V=1-U$. Let $I=\int U(x,y)V(x,z)V(y,z)\,dx\,dy\,dz$. This is the probability of one specified induced two-edge path in the random graph sampled from $V$. The two triangle estimates give
$$
 0\le D_2-p^2\le p(1/3-p),\qquad
 0\le I=2p-8D_2+8T\le 6p(1/3-p).
$$
At $p=1/3$, $V$ therefore has degree $1/3$ almost everywhere and $I=0$. For almost every $z$, almost every pair of points of $S_z=\{x:V(x,z)>0\}$ satisfy $V(x,y)=1$. Since typical points have degree $1/3$, this gives $|S_z|\le1/3$, while the degree at $z$ gives $|S_z|\ge1/3$. Thus $V$ is one almost everywhere on $S_z^2$, and zero almost everywhere from $S_z$ to its complement. Choosing a typical $z$ and repeating on its complement gives exactly three equal complete parts for $V$. This identifies $W$. For this three-part matrix, $p=1/3$, $D_2=1/9$, and $T=1/36$, so the two limiting moment inequalities alone permit the stated coefficient. Compactness and uniqueness give the cut-distance assertion. Deleting $O(n)$ hyperedges to achieve linearity changes only $O(n)$ shadow edges. The structural implication is conditional on reaching the bound. [Graphon compactness](https://math.osu.edu/sites/math.osu.edu/files/graphons.pdf)

For a limiting shadow whose density is $\delta$ below $1/3$, a three-part model already approximates the kernel in $L^1$ with error $O(\delta)$. Requiring three exactly equal parts gives error $O(\sqrt{\delta})$. [Quantitative stability proof](stability.md)

## Quasirandom shadows

If a sequence of linear systems has quasirandom shadow graphs, its upper triple coefficient is $1/24$. Lean verifies the following finite estimate. More quantitatively, let $p=6m/n^2$ and let $\eta$ be the normalized cut distance of the shadow adjacency matrix from the constant matrix $p$. Telescoping the two-edge path and triangle densities gives
$$
 p^2(p-1/4)\le 7\eta/2+p/(2n).
$$
Indeed the constant matrix has path density $p^2$ and triangle density $p^3$. The shadow triangle upper estimate and the cut errors $2\eta$ and $3\eta$ give the displayed inequality. If $p\ge1/4$, then $p^2\ge1/16$ and $p\le1$, so
$$
 m/n^2\le1/24+(28/3)\eta+4/(3n).
$$
The same inequality holds for $p\le1/4$ directly. Thus the density range between $1/24$ and $1/18$ requires a shadow that stays a positive cut distance from a constant matrix. [Finite discrepancy proof](../hall-reduction/ShadowDiscrepancy.lean)
