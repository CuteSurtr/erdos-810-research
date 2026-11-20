# A short proof using matched rows and columns

Let each four-cycle of a properly colored graph have four different colors. In any rectangle of its adjacency matrix, the entries of one color form a matching. If this matching has size $k$, its $k$ rows and $k$ columns contain at most $k(k+1)/2$ occupied entries. For each pair of distinct matching entries at most one of the two crossed entries can be occupied. This finite observation gives the pointwise bound $W\le1/2$ in every graphon limit when the palette has $O(n)$ colors. [Matching count in Lean](../hall-reduction/MatchingRectangle.lean) · [Alternative mask proof](quarter.md)

## A finite inequality with a comparison matrix

Write $q$ for the palette size, $G$ for the adjacency matrix and $e$ for its number of oriented entries on $A\times B$. Let $U$ be any real matrix on the same vertices, and let $D$ bound $\sum_{X\times Y}(U-G)$ for all vertex sets $X,Y$. For every $t\ge1/2$,
$$
 (t-1/2)e^2\le qe/2+q^2D+q|A|\sum_{A\times B}(t-U)_+. \tag{1}
$$
To see this, write $A_c,B_c$ for the rows and columns of the matching of color $c$ on $A\times B$, and $k_c$ for its size. The sums of $G$ and $U$ on $A_c\times B_c$ differ in the required direction by at most $D$. Hence
$$
 (t-1/2)k_c^2\le k_c/2+D+\sum_{A_c\times B_c}(t-U)_+ .
$$
At a fixed cell $(x,y)$ the last sum counts its shortfall at most $|A|$ times over all colors. Each counted color must occur on an edge from $y$ to some vertex of $A$, and a single edge has one color. Sum over colors, use $\sum k_c=e$ and $e^2\le q\sum k_c^2$, and obtain (1).

The finite comparison (1), the approximation argument, and the one-quarter coefficient are checked in Lean. The written finite proof also gives an explicit cutoff. [One-quarter theorem](../hall-reduction/QuarterDensity.lean) [Comparison theorem](../hall-reduction/WeightedMatchingCut.lean) · [Finite approximation and cutoff](finite-model.md)

## Every rectangle, uniformly over a linear palette

For any positive integer $c$ and $\varepsilon>0$, all sufficiently large $n$ satisfy the following. If a graph has at most $cn$ colors and rainbow four-cycles, every pair $A,B$ of vertex sets satisfies
$$
 e_G(A,B)\le |A||B|/2+\varepsilon n^2.
$$
Edges are counted with their orientation from $A$ to $B$, which may overlap. For at most $n$ colors, use the half-bounded cut approximation after properification. For $q\le cn$, embed the graph in $cn$ vertices by adding isolated vertices and use error $\varepsilon/c^2$ on the larger graph. The two original sets have the same sizes, yielding the displayed coefficient in the original normalization. [Uniform rectangle theorem in Lean](../hall-reduction/LinearPalette.lean)

## Applying the count to a graphon limit

Suppose $q\le Cn$. Pad unused labels so that $q/n\to C>0$ and relabel the vertex cells so that $G_n\to W$ in cut norm. Fix measurable $A,B$ of measures $a,b$ and put $E_n=\int_{A\times B}G_n$. The normalized limiting form of (1) is
$$
 (t-1/2)\left(\int_{A\times B}W\right)^2
 \le Ca\int_{A\times B}(t-W)_+. \tag{2}
$$

For detail covering sets that split vertex cells, place mass $1/n$ uniformly on each oriented cell of color $c$ and restrict this measure to $A\times B$. Its mass is $k_c$, and its row and column marginals have densities $f_c,g_c\le1$ supported on $A,B$. The integral of $G_n(x,y)f_c(x)g_c(y)$ counts one crossed entry of two matching samples. Exchanging the two samples and using the two-cross restriction shows it is at most $(k_c^2+k_c/n)/2$. Indeed the mass of each restricted matched cell is at most $1/n$. The cut-norm error for replacing $G_n$ by $W$ against $f_cg_c$ is at most $\|G_n-W\|_\square$, by the level-set representation of a nonnegative bounded function. For a uniform color, $\mathbb E k_c=(n/q)E_n$, and $\mathbb E f_c(x)g_c(y)\le\mathbb E g_c(y)\le (n/q)a$ on the rectangle. Thus the normalized single-color inequality and Jensen give
$$
 (t-1/2)(n/q)^2E_n^2
 \le (n/q) E_n/(2n)+\|G_n-W\|_\square+(n/q)a\int_{A\times B}(t-W)_+ .
$$
Taking the limit gives (2).

For a fixed $B$, divide (2) by $a^2$ and differentiate over intervals $A$ shrinking to a row $x$. By first taking the countable family of finite unions of rational intervals, then approximating in measure, we obtain for almost every $x$ and every measurable $B$
$$
 (t-1/2)\left(\int_B W(x,y)\,dy\right)^2
 \le C\int_B(t-W(x,y))_+\,dy .
$$
Take $1/2<t<1$ and choose $B=\{y:W(x,y)\ge t\}$. The right side is zero, so $|B|=0$. A countable sequence $t\downarrow1/2$ gives $W\le1/2$ almost everywhere. The graph edge coefficient follows on integrating and dividing by two. An arbitrary rainbow-four-cycle coloring has a proper restriction on the same vertices after $o(n^2)$ edge deletions, so the conclusion covers the original problem. [Sparse deletion](../hall-reduction/Properification.lean)

## Supersaturation for proper colorings

Fix $C>0$ and $\alpha>0$. There are $c_{C,\alpha}>0$ and $N_{C,\alpha}$ such that every **properly** colored graph on $n\ge N_{C,\alpha}$ vertices with at most $Cn$ colors and at least $(1/4+\alpha)n^2$ edges has at least $c_{C,\alpha}n^3$ four-cycles with a repeated color. The cubic exponent is sharp whenever the setting admits such dense graphs. This supersaturation extension is a written result.

Let $R$ count distinct unoriented four-cycles with a repeated color, counting different cycles on the same four vertices separately. On the matched subrectangle of one color, the upper bound $k_c(k_c+1)/2$ has to be increased by at most the number of unordered pairs of distinct darts of that color for which both crossed entries are occupied. For one bad cycle there are at most two choices of a repeated opposite-edge pair and two choices of its orientations giving this particular cycle. Thus the sum of all such error counts, over the palette on any fixed rectangle, is at most $4R$. In finite inequality (1) this adds $4qR$ to the right. In the normalized inequality with $q/n\le C$, the added error is at most $4CR/n^3$.

If $R=o(n^3)$, the error tends to zero, and the subsequential cut-limit proof gives $W\le1/2$ almost everywhere. For measurable sets splitting vertex cells, restrict the two dart samples as above. A pair of cells has product mass at most $1/n^2$ for its color, so the same normalized error bound applies. A sequence violating the supersaturation assertion would have density at least $1/4+\alpha$ and $R/n^3\to0$, an impossibility.

For the order of magnitude, every bad cycle contains two opposite edges of one color. Any two disjoint undirected edges occur as opposites in at most two cycles. Therefore
$$
 R\le2\sum_c\binom{|M_c|}{2}\le(n/2)|E(G)|=O(n^3).
$$
The charge count was also checked on all 4,246 proper five-vertex colorings with up to four colors, up to renaming the colors. Of them, 2,135 contain a repeated-color four-cycle. [Integer check](check_counts.py)

A complete graph on even $n$ has a proper $(n-1)$-coloring by its one-factorization, so the dense regime already occurs with a linear palette. For colorings allowing equal adjacent edges, deletion of one edge per bad cycle gives the separate lower bound $(\alpha-o(1))n^2$ on bad cycles above $(1/4+\alpha)n^2$, using the linear-palette theorem.
