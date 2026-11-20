# A one-quarter upper bound for Erdős problem 810

Let $M(n)$ be the greatest number of edges of an $n$-vertex graph with at most $n$ colors and every four-cycle rainbow. Then
$$
\limsup_{n\to\infty}M(n)/n^2\le 1/4 .
$$
More generally, along any such sequence converging in cut distance, its limiting graphon satisfies $W(x,y)\le1/2$ almost everywhere. The same conclusion holds with at most $Cn$ colors for any fixed $C$. The graphon argument below is written. A finite proof verifies the one-quarter coefficient end to end in Lean. [One-quarter Lean theorem](../hall-reduction/QuarterDensity.lean) A positive edge density below one quarter remains possible under this theorem. [Original problem](https://www.erdosproblems.com/810) · [Properification](../hall-reduction/Properification.lean) · [Graphon compactness](https://math.osu.edu/sites/math.osu.edu/files/graphons.pdf)

A shorter argument averages the shortfall of a comparison matrix over the row and column sets of a single color. [Direct comparison proof](quarter-short.md)

## The matching measures

It suffices to treat proper colorings. Deleting $o(n^2)$ edges gives one with the inherited palette and changes its graphon by $o(1)$ in cut norm. Take a subsequence with $n\to\infty$ and graphons $W_n$ converging to $W$ in cut norm after measure-preserving relabelings. The vertex cells need only be measurable sets of measure $1/n$. We count oriented edges using separate row and column copies of the vertex space. A color class is then a bipartite matching, even for a graph which is not bipartite.

First pad the palette to $n$ labels. On each rectangle belonging to a dart of color $c$, put density $n$ with respect to Lebesgue area, and put zero elsewhere. Call the resulting measure $\mu_c$. Both marginals have densities at most one, so its mass is at most one. With $c$ uniform over labels,
$$
\mathbb E_c\mu_c = W_n(x,y)\,dx\,dy .
$$
Write $Q_n=\mathbb E_c[\mu_c\otimes\mu_c]$, on two pairs $(x,y),(x',y')$. These are finite measures. Each of the crossed marginals $(x,y')$ and $(x',y)$ is dominated by Lebesgue area because for each $c$ it is the product of two marginals with densities at most one.

For two distinct darts of the same color the two crossed entries cannot both be edges. If both are edges, their four endpoints form a four-cycle: the matching gives distinct rows and distinct columns, and any coincidence of a row with a column would be a loop on an edge. The darts coinciding in a single matched cell have total $Q_n$-mass at most $1/n$, since each cell has mass $1/n$ for its color. Consequently, for every measurable $0\le F\le1$,
$$
\int F[W_n(x,y')+W_n(x',y)-1]\,dQ_n\le 1/n . \tag{1}
$$

## Passing the crossed entries to the limit

Fix $t>1/2$ and let $H=1_{\{W>t\}}$. Put $F=H(x,y')H(x',y)$. For either crossed coordinate $(u,v)$,
$$
\int F[W_n(u,v)-W(u,v)]\,dQ_n\longrightarrow0 . \tag{2}
$$
To verify this, approximate $H$ in $L^1$ by a bounded $[0,1]$-valued step function on a fixed finite measurable partition. Replacing both occurrences of $H$ costs at most twice that approximation error, uniformly in $n$, by domination of the crossed marginals. The new $F$ is a finite linear combination of $1_A(x)1_B(y)1_D(x')1_E(y')$. For one such product and $(u,v)=(x,y')$, restrict the first copy of $\mu_c$ to $A\times B$ and the second to $D\times E$. The relevant cross marginal is $f_c(x)g_c(y')\,dx\,dy'$ with $0\le f_c,g_c\le1$. The absolute integral of $W_n-W$ against this product is at most $\|W_n-W\|_\square$, by writing each bounded factor as an integral of its level-set indicators. This bound holds for each color. The other crossed coordinate follows by switching the copies. First send $n\to\infty$ with the partition fixed, then send the approximation error to zero. This order removes any dependence on the number of partition cells.

On $\{F=1\}$ the bracket in (1), with $W$ in place of $W_n$, is at least $2t-1$. Thus (1)–(2) imply
$$
\int H(x,y')H(x',y)\,dQ_n=o(1). \tag{3}
$$

## Counting the pairs with a missing crossed entry

Fix arbitrary measurable $A,B$ of measures $a,b$, and set $k_c=\mu_c(A\times B)$. Jensen gives $(\int_{A\times B}W_n)^2\le\mathbb E_c k_c^2$. For a pair of color-$c$ entries in this rectangle, either both crossed entries lie in $H$, or at least one is missing from $H$. The first type costs $o(1)$ in total by (3).

For a missing entry at $(x,y')$, the cross marginal after restricting both copies to $A\times B$ is $f_c(x)g_c(y')\,dx\,dy'$, supported on $A\times B$. We have $0\le f_c\le1$ and
$$
\mathbb E_c g_c(y')=1_B(y')\int_A W_n(x',y')\,dx'\le a\,1_B(y').
$$
Consequently $\mathbb E_c[f_c(x)g_c(y')]\le a$ on this rectangle. The other crossed entry costs the same amount. Passing to the limit in the resulting inequality gives, for every $A,B$,
$$
\left(\int_{A\times B} W\right)^2\le 2a\int_{A\times B}(1-H). \tag{4}
$$
The factor $a$ comes from averaging the restricted column marginal over all colors. This factor allows arbitrarily small row sets.

For fixed $B$ divide (4) by $a^2$ and differentiate the row averages over shrinking intervals. For almost every $x$,
$$
\left(\int_B W(x,y)\,dy\right)^2\le 2\int_B(1-H(x,y))\,dy .
$$
First impose the inequality simultaneously on finite unions of intervals with rational endpoints. Approximation in measure extends it to every measurable $B$ for the same full-measure set of rows, since the integrands are bounded. Now choose $B=\{y:W(x,y)>t\}$. The right side vanishes, while the left side is at least $t^2|B|^2$. Thus $H=0$ almost everywhere. Taking a countable sequence $t\downarrow1/2$ proves the claim.

For $q\le Cn$ colors, average over $\lceil Cn\rceil$ padded labels instead. The mean matching measure becomes $n/\lceil Cn\rceil$ times $W_n\,dx\,dy$. Dividing by its squared factor multiplies the right side of (4) by $C$ in the limit; the last step still gives zero. Finally $2|E(G_n)|/n^2=\int W_n\to\int W\le1/2$ gives the one-quarter coefficient.
