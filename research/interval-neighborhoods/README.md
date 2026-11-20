# Sharp edge counts for ordered neighborhoods

Let $M_k(v)$ be the maximum number of edges in a simple graph on $v$ vertices with at most $v$ edge colors, every four-cycle rainbow, and a common linear order in which the open neighborhood of each vertex is a union of at most $k$ intervals. For every fixed positive integer $k$,

$$
M_k(v)=\sqrt{k}\,v^{3/2}+O_k(v).
$$

The same leading constant holds uniformly for $1\le k\le v^{1-\delta}$ for any fixed $\delta>0$, in the sense that $M_k(v)/(v\sqrt{kv})\to1$. The upper bound allows edges at the same vertex to share a color. The lower examples are properly colored bipartite graphs. This settles the leading term for this ordered subclass of the [original problem](https://www.erdosproblems.com/810).

## Finite upper bound

Put an occupied cell at each edge of a bipartite board with $a$ rows and $b$ linearly ordered columns. Write $E$ for its occupied-cell count, $R$ for the sum of the numbers of nonempty consecutive runs in its rows, and $q$ for its color budget. The same argument applies when the board is the full adjacency matrix of a simple graph. For every integer $2\le s\le b$,

$$
E\le (s-1)R+(b-s+1)\max\{1,\lfloor q/s\rfloor\}. \tag{1}
$$

A run of length $d$ contains $\max(0,d-s+1)\ge d-s+1$ consecutive windows of width $s$. Thus the rows together contain at least $E-(s-1)R$ such windows, counted with multiplicity. If the same window occurs in $t\ge2$ rows, its $ts$ cells form a complete rectangle. Every two distinct cells of that rectangle lie on a common four-cycle, so all $ts$ colors are different. This also works in an adjacency matrix because the zero diagonal forces the row and column vertices of a full rectangle to be disjoint. Counting the $b-s+1$ possible starts proves (1). Lean checks this argument from the original rainbow assumption. [IntervalWindows.lean](../hall-reduction/IntervalWindows.lean)

For the adjacency matrix, $E=2m$, $b=v$ and $R\le kv$. If $k<q\le v$ and $v\ge2$, take $s=\lceil\sqrt{q/k}\rceil$. Then $s-1<\sqrt{q/k}$, $q/s\le\sqrt{kq}$ and $s\le q$. Formula (1) gives $m\le v\sqrt{kq}$. One can use the budget $q=v$ even for a graph using fewer colors. More generally the bound applies to the total run count, allowing some neighborhoods to have many more intervals than others.

## A band with an optimal palette

Use $h$ rows and $h$ columns indexed by $0,\ldots,h-1$. Occupy $(i,i+t)$ whenever $0\le t<L$ and $i+t<h$, with $1\le L\le h$. For each offset $t$ reserve a separate palette of

$$
d_t=1+\min(t,L-1-t)
$$

colors and give the cell color $(t,\,i\bmod d_t)$. Edges sharing an endpoint have different offsets. If two opposite cells of the same offset occur on a rectangle and their row difference is $d>0$, its two crossed cells have offsets $t-d$ and $t+d$. Consequently $1\le d<d_t$, so the repeated offset has distinct residues. The coloring has exactly

$$
Q(L)=\sum_{t=0}^{L-1}d_t=\left\lfloor (L+1)^2/4\right\rfloor
$$

colors and $hL-L(L-1)/2$ edges. For $L\ge3$, rows $0,\ldots,i-1$ and columns $i-1,\ldots,L-1$ give a complete $i\times(L+1-i)$ rectangle. Taking $i$ nearest to $(L+1)/2$ proves that any valid coloring of this band needs $Q(L)$ colors.

## Obtaining the factor $\sqrt{k}$

Use a second, properly colored board with $M$ rows and $M$ columns, all degrees $k$, and exactly $k$ colors. To construct it, choose an odd $M$ and a $k$-element set $S\subseteq\mathbb Z/M\mathbb Z$ with no nonconstant three-term arithmetic progression. Give $(i,i+s)$ color $s$ for every $i$ and $s\in S$. Equal colors in opposite cells would force $s-d,s,s+d\in S$ for a nonzero row difference $d$. Since $M$ is odd these are distinct. For fixed $k$, one elementary choice is $M=3^{\lceil\log_2 k\rceil}$ and any $k$ ternary strings of that length with digits zero and one. In $a+b=2c$ the digits add without carries, and both sides are smaller than $M$, so $a=b=c$.

Take the direct product of this board with the band. A product cell is present when both factor cells are present, and its color is the ordered pair of their colors. In a full rectangle in the product, each factor projects to a rectangle, possibly with a repeated row or column. In a nondegenerate projection all its colors are distinct. In a degenerate projection properness distinguishes any two distinct cells. Equal product colors on two corners would therefore force identical factor cells in both coordinates, hence identical corners. In particular, the product works with the same color convention as #810.

Order the $h$ local positions consecutively within each of the $M$ blocks. On either side of the product board every neighborhood is a union of at most $k$ intervals. Order the left side before the right side to obtain a common vertex ordering. The product has $2Mh$ vertices, $kQ(L)$ colors, and

$$
Mk\big(hL-L(L-1)/2\big)
$$

edges. Take $h=\lfloor v/(2M)\rfloor$ and $L=\lfloor2\sqrt{\lfloor v/k\rfloor}\rfloor-1$, adding isolated vertices to reach $v$. For large $v$ and fixed $k$ this has $1\le L\le h$ and $kQ(L)\le v$. The leading term is $v\sqrt{kv}$ and the rounding and band boundary cost $O_k(v)$.

For the uniform assertion, Behrend's construction gives $k$ progression-free integers in $[0,N)$ with $N\le k\exp(O(\sqrt{\log(k+1)}))$. Embedding them in an odd cyclic group of order $2N+1$ introduces no wraparound. This choice gives $M=o(\sqrt{vk})$ uniformly for $k\le v^{1-\delta}$, hence $h/L\to\infty$. Relative to $v\sqrt{kv}$, the three errors are $O(\sqrt{k/v})$ from rounding $L$, $O(M/v)$ from rounding $h$, and $O(M/\sqrt{vk})$ from the band boundary. Each tends to zero uniformly. [Behrend's construction](https://pmc.ncbi.nlm.nih.gov/articles/PMC1078964/)

## Reproducing the finite checks

Run `python3 research/interval-neighborhoods/check_intervals.py` from the repository root. It checks (1) for all 4,096 three-by-four binary boards with the palette forced by complete rectangles, checks band colorings for widths 2 through 23, and checks products for $k=1,2,3,4$ by listing all pairs of rows. The $k=3$ example has 630 vertices, 588 colors, 16,038 edges and 6,251,661 rainbow four-cycles. The asymptotic lower bound above is a written proof.
