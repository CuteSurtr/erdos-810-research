# A 0.073272 upper density for the (7,4) problem

Let $g(n;7,4)$ be the largest number of triples on $n$ points such that every four distinct triples span at least eight points. Then
$$
\limsup_{n\to\infty} g(n;7,4)/n^2 \le 0.073272.
$$
This includes triples sharing a pair. Gishboliner and Solymosi's Theorem 1.1 gives $2/27=0.074074\ldots$ for linear triple systems. The existing explicit bound $g(n;7,4)<0.07354n^2+n/2$ holds for $n\ge10^6$. The stronger asymptotic estimate uses uniform convergence of the rectangle bounds. [Lean theorem](../hall-reduction/ShadowWidthDensity.lean) · [Explicit finite bound](verified.md) · [Gishboliner and Solymosi](https://arxiv.org/html/2606.25931v1)

The graph-limit proof subsequently gives $1/18$ for the same problem. [One-eighteenth theorem](eighteenth.md)

## Lower count of missing edges

Start with a linear system and color its shadow edges by the third point of their triple. This is a proper coloring with every four-cycle rainbow. For a shadow edge, write $c,b$ for the normalized sizes of the common-neighbor and neither-neighbor sets, $s=c+b$, and $p=cb$. By the rectangle bound, the normalized number of edges between the two sets is at most $p/U(s)+o(1)$, uniformly, where $U(s)=1+s/2-s^2/12$. [Width contraction](../rectangle-profile/contraction.md)

Put $A=36849/208849$ and $B=243/208849$. The missing-edge fraction is at least $Ap-B-o(1)$. To check this line, use $p\le s^2/4$. If $(1-A)U(s)-1\ge0$, positivity is immediate. Otherwise the required numerator is at least
$$
BU(s)+[(1-A)U(s)-1]s^2/4
=\frac{(s-3/10)^2(8100+58050s-10750s^2)}{626547}\ge0 .
$$
[Supporting line in Lean](../hall-reduction/ShadowWidth.lean)

## Upper count from one triple

Use the normalized intersection and unused-arm counts $t_i,u_i$ at a root triple. Write $p_0=\sum_i t_i$, $s_0=\sum_i u_i$, $T_i=t_i-p_0/3$, $U_i=u_i-s_0/3$. The arm counts give $3p_0+2s_0\le1$ and $s_0\le D_e$ for the normalized root defect $D_e$. Nonnegativity gives
$$
\sum_i T_iU_i\le 2p_0s_0/3,\qquad
\sum_i U_i^2\le 2s_0^2/3,\qquad
(9/2)\sum_iT_iU_i+3\sum_iU_i^2\le s_0 .
$$
For $\alpha\ge1/9$, $\beta>0$ and $(2+2\beta-9\alpha/2)^2\le4\beta(\beta+3\alpha)$, completing a square gives
$$
2TU\le \alpha[(9/2)TU+3U^2]+\beta(T-U)^2 .
$$
Since the difference $T_i-U_i$ is the centered hyperdegree, summing the scalar inequality bounds the weighted root defect by $(\alpha+1/n)D_e+\beta\sum_i(d_i-\bar d)^2$. Here $d_i$ is the normalized hyperdegree and its center $\bar d$ can be replaced by the global mean. [Local quadratic proof](../hall-reduction/ShadowScatter.lean) · [Summation over triples](../hall-reduction/ShadowUpper.lean) · [Definitions of the root counts](refinement.md)

## Numerical separation

Let $r=3m/n^2$, $v$ be the degree variance, $D$ the total normalized root defect, $h=1/n$, $P=r\mathbb E[p]$ for a uniform shadow edge, and $L$ the normalized missing-edge count. The balance and moment inequalities give
$$
D+3v=r(2/3+h-3r),\qquad 4P\ge r[1/9-(1-4r)^2]-8v
$$
for $r\le1/4$. For all sufficiently large $n$, the rectangle error is at most $10^{-7}$ and the two counts imply
$$
AP-(B+10^{-7})r\le L\le \tfrac32[(\alpha+h)D+(\beta/2)v].
$$
Take $\alpha=28141/100000$, $\beta=1217/1000$. They meet the square condition and $(3/2)(\beta/2-3\alpha)\le-2A$. Under the contrary assumption $r\ge3(0.073272)$, bounding $h\le10^{-6}$ leaves the following positive rational gap between the lower and upper estimates after accounting for the variance:
$$
\frac{223245434762836703}{1253094000000000000000000}.
$$
Deleting at most $n/2$ triples makes a general admissible system linear, which preserves the leading coefficient. [Moment calculation and theorem](../hall-reduction/ShadowWidthDensity.lean) · [Linearization](../hall-reduction/LinearCleanup.lean) · [Exact independent arithmetic](check_counts.py)
