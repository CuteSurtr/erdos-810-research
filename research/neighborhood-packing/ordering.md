# A shorter neighborhood tour improves the bounded-VC exponent

For any fixed neighborhood VC dimension $d\ge2$, an $n$-vertex graph in Erdős #810 has

$$
m=O_d\!\left(n^{\,2-1/(2d)}\right).
$$

This improves the exponent $2-1/(2d+1)$ obtained by bounding clusters about individual high-degree vertices. For $d=1$ a separate characterization gives the exact leading constant. [Previous cluster bound](README.md) · [VC dimension one](vc-one.md)

For $0\le t\le n$, let $P(t)$ be the largest number of open neighborhoods at pairwise symmetric-difference distance greater than $t$. The following finite estimate applies without any VC assumption:

$$
m \le n\sqrt{\,n+\int_0^n(P(t)-1)\,dt\,} \qquad (n\ge2).
$$

Equip the vertex set with the pseudometric $d(u,v)=|N(u)\mathbin\triangle N(v)|$ and take a minimum spanning tree of total weight $L$. If the graph of all pairs at distance at most $t$ has $c(t)$ components, one representative from each gives $c(t)\le P(t)$. Kruskal's algorithm connects these components at each threshold, so the number of tree edges of weight greater than $t$ is $c(t)-1$. Integrating yields $L\le\int_0^n(P(t)-1)\,dt$.

Walk along every tree edge in both directions and order the vertices by first visit. By the triangle inequality the sum of consecutive distances in this order is at most $2L$. Write $R$ for the total number of occupied runs in the rows of the adjacency matrix in this column order. Symmetry identifies the columns with the open neighborhoods. Counting the two ends of every run gives $2R$ equal to the first and last column sizes plus the sum of the consecutive distances. Hence $R\le n+L$.

If $R>0$, choose $s=\lceil n/\sqrt R\rceil$. One has $2\le s\le n$ since $R<n^2$. The consecutive-window bound gives $2m\le(s-1)R+n^2/s\le 2n\sqrt R$. The empty graph is immediate. [Finite window inequality in Lean](../hall-reduction/IntervalWindows.lean)

For VC dimension $d$, Haussler's sphere-packing bound gives $P(t)\le\min\{n,C_d(n/t)^d\}$ for $t>0$, with $C_d=e(d+1)(2e)^d$. At integer distances one can use the first integer strictly exceeding $t$. Splitting the integral at $C_d^{1/d}n^{1-1/d}$ and extending the upper tail to infinity shows $L\le \frac{d}{d-1}C_d^{1/d}n^{2-1/d}$ for $d>1$. Substitution proves the claimed exponent. [Haussler's packing theorem](https://www.sciencedirect.com/science/article/pii/0097316595900527)
