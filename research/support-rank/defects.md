# The exact cost of allowing defects in a fooling set

Call $\{i,j\}$, $i<j$, a defect of a square matrix $A$ if $A_{ij}A_{ji}\ne0$. Require all diagonal entries to be nonzero. In characteristic zero, among all $N$ by $N$ matrices of rank at most $r\ge1$, the **minimum possible number of defects** is
$$
S\binom a2+ab,\qquad S=\binom{r+1}{2},\quad N=aS+b,\quad 0\le b<S.
$$
This is exact at every size and rank budget. It includes the sharp zero-defect result at $N=S$. Equivalently the number $D$ of ordered nonzero reciprocal pairs, including the diagonal, satisfies $D\ge N^2/S$. The exact formula retains the integer rounding. [Sharp fooling-set rank theorem](fooling-sets.md)

## Upper limit on the defect-free pairs

Join two distinct indices if their reciprocal product is zero. A clique restricts $A$ to a principal fooling-set matrix of rank at most $r$, hence has at most $S$ vertices. Turán's theorem bounds the total number of edges by the balanced complete $S$-partite graph. Its missing pairs are exactly the pairs in $S$ bins of sizes $a,a+1$, of which $b$ are larger. This proves the displayed lower bound on defects. Lean checks the exact Turán upper bound for this matrix graph and its simpler quadratic consequence. [Formal proof](../hall-reduction/FoolingSetDefects.lean) · [Turán theorem used in Lean](https://leanprover-community.github.io/mathlib4_docs/Mathlib/Combinatorics/SimpleGraph/Extremal/Turan.html)

For sharpness take a rational fooling-set matrix of size $S$ and rank $r$. Repeat its $i$th row and its $i$th column by the same factor, using $a+1$ copies for $b$ indices and $a$ for the others. Zero copies delete an index. Reciprocal products are nonzero exactly within classes of copies, and rank cannot increase. When $N\ge r$ one can even require rank exactly $r$. For $N\ge S$ every original index remains. For $r\le N<S$ retain an $r$-square nonsingular principal block, available in the published construction. [Friesen, Hamed, Lee and Theis, Theorem 5.1](https://arxiv.org/pdf/1208.2920)

More generally, under any distribution with weights $w_i\ge0$, two independent draws yield a reciprocal nonzero pair with probability at least $1/S$. Multiply rational weights by a common denominator and repeat the corresponding rows and columns. The quadratic bound proves the assertion, which extends to real weights by continuity. The uniform distribution on the $S$ indices of a sharp example gives equality.

## Why low rank forces many bad four-cycles

For a graph with $n$ vertices, $m$ edges and a palette of $q$ colors, let $R$ count its four-cycles with any color repetition. Let $U$ count unordered vertex pairs with exactly one common neighbor. Let a matrix fitting the graph's adjacency support have rank $r$. The coloring may assign the same color to edges that meet. In all characteristics use $T=\binom r2$. In characteristic zero one may also use $T=\lfloor\binom{r+1}2/2\rfloor$. Then
$$
m^2\ \le\ qT(m+2U+12R).
$$

For one color, form a graph on its $m_c$ edges. Two edges conflict if they meet or are opposite sides of a four-cycle. Any independent set is a matching with neither possible crossed pairing present between two members. The matching-minor argument therefore bounds it by $T$ even if other parts of the original graph contain bad cycles. For the characteristic-zero option take both orientations of this matching. [Matching rank arguments](README.md)

If this conflict graph has $e_c$ edges, the independence estimate gives $m_c^2\le T(m_c+2e_c)$. One proof chooses edges occurring before all their conflict-neighbors in a random ordering, as in the zero-defect case. A monochromatic incident pair with just one common neighbor of its other endpoints is determined by those endpoints, so there are at most $U$ such pairs altogether. Every other conflict occurs together on some bad four-cycle, which contains only six unordered pairs of edges. Thus $\sum_c e_c\le U+6R$. Summing the independence estimates and applying Cauchy–Schwarz gives the claim.

In particular, a graph of density bounded below with $q=O(n)$ and support rank $r=o(\sqrt n)$ over any field has $\Omega(n^3/r^2)$ bad four-cycles under **every** coloring with that palette. This follows since $U\le\binom n2$ and $m=O(n^2)$. If the coloring is proper then all conflicts are opposite pairs, so $\sum_c e_c\le2R$ and the stronger bound $m^2\le qT(m+4R)$ holds. At constant support rank the cubic exponent is sharp, as the following explicit examples show.

## The complete bipartite example

In $K_{s,s}$ with a proper coloring, any pair of edges of one color is opposite in exactly one rectangle. Write $T_0=\sum_c\binom{m_c}{2}$ and write $I$ for the number of rectangles alternating between two colors. Each other bad rectangle contains exactly one equal opposite pair. Hence $R=T_0-I\ge T_0/2$. Balance the color sizes to minimize $T_0$.

For $s=2^k$ and a power of two $d$ dividing $s$, the exact minimum over proper colorings with at most $q=ds$ colors is
$$
R=\frac{ds}{2}\binom{s/d}{2}.
$$
Index rows and columns by $\mathbb F_2^k$ and color $(x,y)$ by $(x+y,\pi(x))$, where $\pi$ is a surjective linear map with $d$ images. Each color occurs $s/d$ times. If two opposite entries have equal colors, their row and column differences coincide and belong to $\ker\pi$. The other two entries then also have equal colors, so $I=T_0/2$. For $q=2s$, the number of graph vertices, this is $s^2(s-2)/8$.

For arbitrary colorings with at most the same $q$, each same-color disjoint pair occurs in one rectangle, and each incident pair occurs in $s-1$ rectangles. Charge one unit per disjoint pair and distribute one unit equally over the rectangles of an incident pair. At most two opposite and four incident pairs contribute to a given rectangle. Consequently $R\ge T_0/(2+4/(s-1))$ for $s\ge2$. The proper construction above has at most a $1+2/(s-1)$ factor more bad rectangles than this unconditional lower bound. The symmetric adjacency matrix of the complete bipartite graph has rank two over every field.
