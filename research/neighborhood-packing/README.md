# Neighborhood complexity in Erdős problem 810

Let $G$ be a simple graph on $n$ vertices with at most $n$ edge colors, in which every four-cycle has four distinct colors. Adjacent edges may have the same color. Write $\mathcal N=\{N(v):v\in V(G)\}$ for the family of open neighborhoods.

**Result.** If $G$ has at least $\delta n^2$ edges, there are at least $\delta^2n/2$ vertices whose neighborhoods have pairwise symmetric differences larger than $\delta^2n/12$. In particular a positive-density sequence must have neighborhood VC dimension of order at least $\log n$. For fixed neighborhood VC dimension $d\ge1$ the number of edges satisfies
```math
|E(G)|=O_d\bigl(n^{2-1/(2d+1)}\bigr).
```
The hypotheses concern the uncolored graph. The coloring, graph and color names can be chosen arbitrarily. This addresses a restricted case of the original positive-density question. The proof combines a necessary condition for a rainbow coloring with Haussler's classical packing theorem. [Original question](https://www.erdosproblems.com/810) · [Haussler, 1995](https://www.sciencedirect.com/science/article/pii/0097316595900527)

## A finite bound on a cluster of neighborhoods

In a complete bipartite subgraph with sides of sizes $k,s\ge2$, any two distinct edges lie on a common four-cycle. For two edges sharing a vertex, use a second vertex on the same side as that vertex. For disjoint edges their endpoints already give the cycle. Thus these $ks$ edges all require distinct colors, so $ks\le n$.

Fix $0<b\le1$ and a vertex $v$ with $|N(v)|\ge bn$. Put $k=\lceil 2/b\rceil$ and $\eta=b^2/12$. Suppose $k$ distinct vertices each miss at most $\eta n$ points of $N(v)$. Their common neighborhood inside $N(v)$ has size at least
```math
bn-k\eta n\ge 3bn/4,
```
since $k\le3/b$. The chosen vertices and their common neighbors are disjoint because the graph has no loops. Their two side sizes have product at least $3n/2>n$. The common neighborhood therefore has at least two points, since $k\le n$. This contradicts the biclique bound. The same argument applies to any fixed set $B$ of size at least $bn$ in place of $N(v)$.

Let $H_b=\{v:|N(v)|\ge bn\}$. Choose a maximal subfamily of its neighborhoods at pairwise symmetric-difference distance greater than $\eta n$. The radius-$\eta n$ balls about the chosen centers cover $H_b$, counting vertices even if neighborhoods repeat. Each ball has at most $k-1<2/b$ vertices by the preceding argument. Thus its number of centers is at least $b|H_b|/2$. If $|E(G)|\ge\delta n^2$, summing vertex degrees gives $|H_\delta|\ge\delta n$. This proves the stated finite packing bound.

## Consequences for VC dimension

The VC dimension of $\mathcal N$ is the greatest size of a set $S$ on which the intersections $S\cap N(v)$ realize all $2^{|S|}$ subsets. Haussler's sphere packing bound for a family of VC dimension $d$ bounds the size of an $\eta n$-separated subfamily by $e(d+1)(2e/\eta)^d$. For a noninteger separation threshold, take the first integer strictly above it, using that Hamming distances are integers. Hence, for every $0<b\le1$,
```math
|H_b|\le \min\{n,C_d b^{-(2d+1)}\},\qquad C_d=2e(d+1)(24e)^d .
```
For $d\ge1$, integrate this upper bound in the identity $2|E(G)|=n\int_0^1 |H_b|\,db$. Splitting the integral at $(C_d/n)^{1/(2d+1)}$ if that point is below one gives
```math
2|E(G)|\le (1+1/(2d))C_d^{1/(2d+1)}n^{2-1/(2d+1)}.
```
If $d=0$, all open neighborhoods coincide and the loopless graph is empty. For any $\delta>0$ with $|E(G)|\ge\delta n^2$, combine the packing lower bound with Haussler's bound and $d+1\le2^d$. This gives the explicit obstruction
```math
d\ge\frac{\log n-\log(2e/\delta^2)}{\log(48e/\delta^2)} .
```
[Haussler's packing theorem](https://www.cs.columbia.edu/~djhsu/coms4995-s20/haussler-packing.pdf)
