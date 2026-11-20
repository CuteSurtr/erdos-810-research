# Maximum density of a colorable subgraph in a random host

Fix $0<p\le1$ and $C>0$. With probability tending to one, **every** spanning subgraph $H$ of $G(n,p)$ with at most $Cn$ colors and every four-cycle rainbow has

$$
|E(H)|\le \left(\frac p2-\frac{p^2}{4}+o(1)\right)n^2.
$$

The error tends to zero uniformly over the choice of subgraph and coloring, for fixed $p,C$. More strongly, every cut limit of these subgraphs is bounded pointwise almost everywhere by $b=p-p^2/2$. At $p=1/2$ the edge coefficient is $3/16$; at least a quarter of the host's edges must be deleted asymptotically. The bound at $p=1$ recovers the repository's unrestricted coefficient $1/4$. [Unrestricted comparison argument](../graph-limits/quarter-short.md)

## Uniform control over all partial matchings

Write $F$ for the host adjacency matrix. Consider any $k$ directed pairs $(u_i,v_i)$ with distinct starts, distinct ends, and no loops. We impose no host-edge condition on these pairs. Define

$$
Z=\sum_{i<j}\max(F_{u_i v_j},F_{u_j v_i}).
$$

For a given $i<j$ the two crossed cells correspond to different unordered pairs, unless a cell is a loop, in which case its value is zero. Indeed, equality with the same orientation would duplicate rows, and equality with reverse orientation would make both original pairs loops. Hence $\mathbb E Z\le(2p-p^2)\binom{k}{2}$.

An unordered host edge appears at most twice among the entries of this $k\times k$ rectangle, since the starts and ends are separately injective. Changing one Bernoulli edge changes $Z$ by at most two; at most $k^2$ edge variables matter. Bounded differences give $\Pr(Z-\mathbb EZ>t)\le\exp(-t^2/(2k^2))$. There are at most $(n+1)n^{2n}$ lists of all lengths. Consequently, with high probability, *simultaneously for every list*,

$$
Z\le (2p-p^2)\binom{k}{2}+D_n,\qquad D_n=4n^{3/2}\sqrt{\log(n+1)}=o(n^2).
$$

For a monochromatic list in a properly colored rainbow subgraph $H\subseteq F$, at most one of the two crossed entries of $H$ can be occupied. If both crossed entries were present, the original darts would complete a four-cycle with a repeated color. Reverse darts cause no exception because both crossed entries are then loops. Thus the sum of the entries of $H$ in the whole matched rectangle is at most $k+Z\le b k^2+(1-b)k+D_n$.

The same estimate holds with weights $0\le w_i\le1$ in the form

$$
\sum_{i,j}w_iw_j H_{u_i v_j}\le b\!\left(\sum_i w_i\right)^2+O(n)+D_n.
$$

Independently retain pair $i$ with probability $w_i$ and apply the already uniform estimate to the resulting list. In the quadratic size term the variance is at most $n$, and replacing expected diagonal weights $w_i$ by $w_i^2$ can only decrease the left side. This justifies the weighted version even for vertex cells split by measurable sets.

## Transferring the bound to the cut limit

Work along any sequence satisfying the uniform host event. Delete $o(n^2)$ edges to make the coloring proper, using the palette-independent properification theorem for rainbow four-cycles. Pass to a cut-convergent subsequence, with limit $W$, and pad the palette to $q=\lceil Cn\rceil$. Relabel the vertex cells with the graph. [Properification theorem](../hall-reduction/Properification.lean)

Fix measurable sets $A,B$ and put $a=|A|$. For each color restrict its directed matching entries to $A\times B$. Give a full vertex cell of a dart mass $1/n$, uniformly over its area; after restriction its surviving fraction is $w_i$. Let $k_c=\sum_i w_i/n$. The row and column marginals have densities $0\le f_c,g_c\le1$ supported on $A,B$. For example, on the row cell of a dart, $f_c$ equals the indicator of $A$ times the fraction of its column cell in $B$. Integrating $H_n f_c g_c$ gives precisely the weighted sum above divided by $n^2$. Hence, uniformly in the color,

$$
\int W f_c g_c\le b k_c^2+o(1),
$$

using cut convergence against products of two functions valued in $[0,1]$. For a uniform color, $\mathbb E k_c=(n/q)\int_{A\times B}H_n$. Also $\sum_c f_c(x)g_c(y)\le n a$ on $A\times B$. Indeed, one may discard $f_c\le1$, and each edge ending at the vertex containing $y$ accounts for the fraction of a different row cell in $A$. For any $t>b$, write $t k_c^2\le\int W f_cg_c+\int(t-W)_+ f_cg_c$. Averaging, using Jensen and passing to the limit yields

$$
(t-b)\left(\int_{A\times B}W\right)^2\le C a\int_{A\times B}(t-W)_+ .
$$

For each fixed $B$, divide by $a^2$ and differentiate along intervals $A$ shrinking to a row $x$. Take first a countable dense family of finite unions of rational intervals $B$, then approximate arbitrary measurable $B$ in measure. For almost every $x$ this gives $(t-b)(\int_B W(x,y)\,dy)^2\le C\int_B(t-W(x,y))_+\,dy$ for every $B$. Taking $B=\{y:W(x,y)\ge t\}$ forces this set to have measure zero. Let rational $t$ decrease to $b$ and integrate $W\le b$. A sequence of subgraphs violating the stated uniform conclusion would have a cut-convergent subsequence contradicting the bound.

This is a written proof. The independent Bernoulli-edge calculation uses the random host beyond its ordinary cut limit. The [whole-host threshold](README.md) answers the separate question of when the sampled graph itself uses at most $n$ colors.
