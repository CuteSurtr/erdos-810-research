# The exact restricted problem at neighborhood VC dimension one

Let $M_{\le1}(n)$ be the maximum number of edges in an $n$-vertex graph with at most $n$ colors, every four-cycle rainbow, and open-neighborhood VC dimension at most one. Then

$$
M_{\le1}(n)=\frac{n^{3/2}}{\sqrt e}+O(n).
$$

There is also an exact finite formula for every $n\ge5$. Write $F_q(a,b)=\sum_{i=1}^a\min(b,\lfloor q/i\rfloor)$ and $f_q(s)=F_q(\lfloor s/2\rfloor,\lceil s/2\rceil)$. Then

$$
M_{\le1}(n)=\max_{s_1+\cdots+s_t=n}\sum_{j=1}^t f_n(s_j).
$$

The connected maximum for $n\ge5$ is precisely $f_n(n)=n\log n+O(n)$, with natural logarithm. For example, at $n=128$ the unrestricted-component maximum within VC dimension one is 836. At $n=1000$ it is 18,890. The restriction concerns the graph before coloring.

## Which graphs have this VC dimension?

Two vertices $u,v$ are shattered if all four membership patterns occur in $N(u)$ and $N(v)$ as the witness vertex varies. For nonadjacent $u,v$ the empty pattern is realized by $u$. If they have a common neighbor, their neighborhoods must therefore be nested. For adjacent $u,v$, their two endpoints realize the two singletons. If they have a common neighbor, $N(u)\cup N(v)$ must cover the whole graph.

Suppose the graph contains a triangle. Each of its three edges is dominating by the preceding observation. Every vertex is adjacent to at least two of the three triangle vertices, including the triangle vertices themselves. Every pair consequently has a common neighbor. If the two vertices in a pair are adjacent their neighborhoods cover the graph, so two nonneighbors of any fixed vertex cannot be adjacent. Nonadjacency, with equality included, is an equivalence relation and the graph is complete multipartite. Conversely, two vertices of a complete multipartite graph have equal neighborhoods or neighborhoods whose union is the whole graph.

In a triangle-free graph of VC dimension at most one there is no induced five-vertex path. Along such a path, the second and fourth vertices have a common neighbor and incomparable neighborhoods. There is also no induced odd cycle of length at least five, by the same two-vertices-at-distance-two argument, including a five-cycle. A shortest odd cycle would be induced, so the graph is bipartite. In any connected component two distinct vertices on the same side share a neighbor, since otherwise a shortest path between them contains an induced five-vertex path. Their neighborhoods are therefore nested. The nontrivial components are bipartite chain graphs, namely graphs whose neighborhoods on each side form a chain under inclusion. Conversely, a union of these graphs has no shattered pair. Different sides or components have disjoint neighborhoods, and same-side neighborhoods in a component are nested.

For $n\ge5$, a complete multipartite graph containing a triangle has a union of parts of size between $2$ and $n-2$. If some part has such a size use it, otherwise all parts are singletons. The cut across that union contains a complete rectangle of area at least $2(n-2)>n$, contradicting the palette constraint. This leaves precisely the chain components to optimize.

## One component can be colored optimally

Order the $a$ row vertices of a chain component by decreasing degree, and order its $b$ columns so the row neighborhoods are prefixes of lengths $d_1\ge\cdots\ge d_a$. For $i,d_i\ge2$, the first $i$ rows and first $d_i$ columns give a complete rectangle; all $i d_i$ cells need different colors. The same numerical inequality $i d_i\le q$ holds for a side of size one whenever $q\ge\max(a,b)$, as here for $q=n$. It follows that the component has at most $F_q(a,b)$ edges.

Equality is attainable using all cells $(i,j)$ with $i j\le q$. More generally, whenever $\max_i i d_i\le q$, define $h_j=|\{i:d_i\ge j\}|$. Assign the cell $(i,j)$ the interval of indices $[i,h_j]$. At index $t$ exactly the $t d_t$ cells of rows $1,\ldots,t$ and columns $1,\ldots,d_t$ have intervals covering $t$. Color the intervals greedily in increasing order of their left endpoint, recycling any color whose previous interval has already ended. At most $q$ colors are needed. Every full rectangle lies in the one indexed by its largest row, so every four-cycle is rainbow. Edges sharing a row or a column also receive distinct colors.

For fixed $s=a+b$, balancing the sides maximizes $F_q$. If $b\ge a+2$, passing from $(a,b)$ to $(a+1,b-1)$ gains $\min(b-1,\lfloor q/(a+1)\rfloor)$ cells and loses $\min(a,\lfloor q/b\rfloor)$, so the count can only increase. Components can reuse the entire palette. This proves the exact partition formula, including isolated vertices as parts of size one, and the connected formula.

## The constant and the component size

The decreasing function $g(x)=\min(b,q/x)$ gives

$$
\int_0^a g(x)\,dx-a-b \ \le\ F_q(a,b)\ \le\ \int_0^a g(x)\,dx.
$$

Indeed rounding the heights costs less than $a$, and replacing the integral by its right-endpoint sum costs at most $b$. With $z=ab/q$, the integral is $qz$ for $z\le1$, and $q(1+\log z)$ for $z\ge1$. Since $a+b\ge2\sqrt{qz}$, its ratio to $(a+b)\sqrt q$ is at most $\sqrt z/2$ or $(1+\log z)/(2\sqrt z)$ respectively. The maximum is $1/\sqrt e$, at $z=e$. This gives the finite upper bound $M_{\le1}(n)\le n^{3/2}/\sqrt e$ for $n\ge5$.

Take square components with side $\lfloor\sqrt{e n}\rfloor$, using the colored hyperbola board above. Each loses $O(\sqrt n)$ cells to rounding and the integral approximation. Their ratio of edges to vertices is $\sqrt{n/e}+O(1)$. Packing whole components into $n$ vertices leaves $O(\sqrt n)$ unused vertices and costs $O(n)$ edges in total. Taking one balanced component of size $n$ instead gives the stated connected asymptotic from the same integral.

## Reproduction

Lean checks the local nesting condition, the complete multipartite implication in the triangle case, the local obstruction used for paths, and the logarithmic inequality yielding the constant. The classification, coloring algorithm and finite maximum have the written proofs above. [Lean lemmas](../hall-reduction/NeighborhoodVCOne.lean)

Run the accompanying Python program from the repository root. It checks the classification on every labeled graph through six vertices, independently searches exact conflict-graph colorings for the small maxima, checks the hyperbola coloring, and computes the partition recurrence. [Finite checks](check_vc_one.py)
