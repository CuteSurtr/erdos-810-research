# The palette threshold on a binomial random graph

For the full random graph $G(n,p)$, the threshold order for the existence of an $n$-coloring in which every four-cycle is rainbow is

$$
p_0(n)=(\log n/n)^{1/3}.
$$

More precisely, there is an absolute $c>0$ such that at $p\le c p_0$ a coloring exists with probability tending to one. At $np^3\ge(2+\varepsilon)\log n$ it fails with probability tending to one, for every fixed $\varepsilon>0$. The positive assertion supplies a proper coloring. The negative assertion covers the original rule, which allows incident colors to repeat. These statements concern coloring the entire sampled graph.

For fixed $0<\alpha<1/2$ and $p=n^{-\alpha}$, the typical minimum palette is $\Theta_\alpha(n^2p^3/\log n)$. At any fixed $0<p<1$ it is $\Theta_p(n^2/\log n)$. In particular, the transition at a linear palette takes place at roughly $n^{5/3}(\log n)^{1/3}$ edges in the random-graph process. The argument gives a threshold order, with a constant-factor gap.

If edge deletion is permitted, a fixed-density random host satisfies a different upper bound. With high probability every subgraph that admits a linear palette has at most $(p/2-p^2/4+o(1))n^2$ edges. For example, at $p=1/2$ at least a quarter of the sampled edges must be deleted. [Subgraph theorem and proof](subgraphs.md)

## A deterministic sufficient condition

For a graph $G$, let $D$ be its maximum degree and $L$ its maximum number of common neighbors of two distinct vertices. Construct a graph $H$ on the edges of $G$. Two edges conflict if they meet or lie opposite each other on a four-cycle. A vertex coloring of $H$ gives a proper edge coloring of $G$ with every four-cycle rainbow. The same conflict-graph formulation of proper rainbow coloring is usually called B-coloring. [Gyárfás, Martin, Ruszinkó and Sárközy](https://arxiv.org/abs/2408.09059)

Set $K=D(L+2)$ and $J=D+2L+4L^2$. Then $\Delta(H)\le K$, and every neighborhood in $H$ spans at most $KJ$ edges. Fix $e=uv$. At most $2D$ neighbors touch $e$. Every opposite neighbor has an orientation $xy$ with $x\in N(u)\setminus\{v\}$ and $y\in N(x)\cap N(v)$, giving at most $DL$ choices. Every edge in $N_H(e)$ has both endpoints in $S=N(u)\cup N(v)$.

To count edges *inside* $N_H(e)$, the at most $2D$ edges touching $e$ contribute at most $2DK$ to the degree sum. For a disjoint $f=xy\in N_H(e)$, the number of edges of $G[S]$ incident to $x$ or $y$ is at most $4L$, since $x,y$ differ from $u,v$. An edge of $G[S]$ opposite $f$ must have both endpoints in $S\cap(N(x)\cup N(y))$, a union of four common-neighbor sets of size at most $4L$ altogether. This gives at most $8L^2$ more neighbors of $f$. The degree sum is at most $2DK+K(4L+8L^2)$. Halving proves the claim.

The sparse-neighborhood coloring theorem of Alon, Krivelevich and Sudakov now gives $\chi(H)=O(K/\log(K/J))$ when $K/J\ge2$. The same proof uses upper bounds on $D,L$ in place of the actual maxima. One can adjoin a disjoint star if one wants the maximum degree in the cited theorem to equal the chosen integer cap. [Alon, Krivelevich and Sudakov, Theorem 1.1](https://people.math.ethz.ch/~sudakovb/sparse.pdf)

## Upper side of the threshold

At $p=c(\log n/n)^{1/3}$ for a fixed $c>0$, simultaneous Chernoff bounds give $D\le\lceil2np\rceil$ and $L\le\lceil2np^2\rceil$ with probability tending to one. Each individual degree or codegree has a binomial distribution. Both means exceed $\log n$ by a polynomial factor, allowing a union bound over all pairs.

Use these two ceilings to form $K,J$. One has $K=(4+o(1))n^2p^3$ and $K/J=n^{1/3+o(1)}$. Thus the deterministic upper bound is at most an absolute constant times $c^3 n$ for all sufficiently large $n$. Choosing $c$ small enough makes this at most $n$, and the same holds for smaller $p$ by subgraph monotonicity. For $p=n^{-\alpha}$ in the stated range, $K=O(n^2p^3)$ and $K/J$ is of order $\min(np^2,1/p)$, polynomially large. This gives the asserted palette upper bound there.

## Lower side of the threshold

When $np^2\gg\log n$, with high probability every pair of vertices has at least two common neighbors. Two same-colored edges incident at $v$ would then lie on a four-cycle through a different common neighbor of their endpoints. Hence every valid coloring of the sample must be proper.

For a fixed matching of size $k$, first require its $k$ edges to be present. For every pair of matched edges, neither of the two crossed perfect matchings of their four endpoints may be present. These two events concern disjoint pairs of Bernoulli edges, and the four underlying cross edges are disjoint as *edge variables* for different pairs of matching edges. The probability that the specified matching is present and can use one color is precisely $p^k(1-p^2)^{k(k-1)}$. The expected number $X_k$ of such matchings satisfies

$$
\mathbb E X_k\le\frac{n^{2k}p^k}{2^k k!}(1-p^2)^{k(k-1)}
 \le\left(\frac{\mathrm e n^2p}{2k}\exp[-p^2(k-1)]\right)^k.
$$

Take $np^3=(2+\varepsilon)\log n$, and $k=\lceil(1-\delta)np/2\rceil$ for a small fixed $\delta>0$ such that $(1-\delta)(2+\varepsilon)>2$. The first factor in parentheses is $O(n)$ while the exponential is at most $n^{-1-\eta}$ for some $\eta>0$ and large $n$. Thus with high probability there is no such matching. The edge count is $(1+o(1))pn^2/2$, so one of $n$ colors would have to contain at least $k$ edges. This proves failure at the stated point and, by monotonicity, above it. For $p=n^{-\alpha}$ simply take $k=\lceil3\log n/p^2\rceil$. The first moment gives $X_k=0$ with high probability, which yields the matching palette lower bound.

## Fixed positive edge probability

Write $a=-\log(1-p^2)$. The same first moment, now using $k=\lceil(2+\eta)\log n/a\rceil$ and the exact factor $(1-p^2)^{k(k-1)}$, gives a palette lower bound $(1-o(1))pn^2a/(4\log n)$.

For a direct upper bound, partition the edges of the complete graph into $n+O(1)$ matchings of size $\lfloor n/2\rfloor$ using a one-factorization (add a dummy vertex when $n$ is odd). In a fixed matching, conditional on the $k$ edges that occur in $G$, their conflict graph is exactly $G(k,1-(1-p^2)^2)$. The disjoint cross-edge variables above give independence for different pairs. Simultaneously $k=(1+o(1))pn/2$ in all factors with high probability. Bollobás's chromatic-number theorem gives $(1+o(1))ak/\log k$ colors per factor. For the simultaneous conclusion, exposing for each vertex its edges to lower-indexed vertices gives $k$ independent blocks, each of which can change the chromatic number by at most one. Bounded differences give tails $\exp(-\Omega_\eta(k/\log^2 k))$ at a fixed relative error from the typical value, so a union bound over the factors is valid. Use disjoint palettes across factors to obtain $(1+o(1))pn^2 a/(2\log n)$ colors. Frieze, Krivelevich and Sudakov also give an upper bound of the same order under the stronger requirement that every color class induce a matching. [Bollobás's theorem](https://doi.org/10.1007/BF02122551) · [Strong edge colorings of random graphs](https://doi.org/10.1137/S0895480104445757)

The deterministic counts were tested on all 33,867 labeled graphs with one through six vertices. For a fixed matching of three edges and $p=1/2$, direct enumeration accepts 729 of the 4,096 choices of cross edges, as the matching probability predicts. These are finite checks accompanying the probabilistic proof. [Independent enumeration](check_conflicts.py)
