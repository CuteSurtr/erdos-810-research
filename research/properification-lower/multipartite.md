# Four-cycles through disjoint edges

Suppose every two vertex-disjoint edges of a graph lie on a common four-cycle. After isolated vertices are removed, its support is complete multipartite. Within this class, the maximum number of edges with an admissible palette of $n$ colors on $n$ vertices is $n+\sqrt n+O(n^{1/4})$. An exact formula is given below. If the four-cycle condition on disjoint edges is imposed separately in each component, the maximum grows to $n^{3/2}/\sqrt2+O(n)$. [Erdős problem 810](https://www.erdosproblems.com/810)

## The support and its palette

If a nonisolated vertex $x$ misses both endpoints of an edge $uv$, any edge $xy$ at $x$ is disjoint from $uv$ and cannot lie on a four-cycle with it. Consequently nonadjacency on the nonisolated vertices is an equivalence relation. Its equivalence classes are the independent parts of a complete multipartite graph. Conversely, for disjoint edges $ab$ and $cd$ in such a graph, either $ac,bd$ or $ad,bc$ are edges. For instance, when $a,c$ belong to the same part, both $ad$ and $bc$ exist. The same argument applies if $b,d$ belong to the same part. This proves the characterization. [Lean equivalence](../hall-reduction/MultipartiteSquares.lean)

Two incident edges $xy,xz$ can share a color only if $x$ is the sole common neighbor of $y,z$. In a complete multipartite component, if $y,z$ belong to one part, every other vertex except $x$ must lie in that part. The component is a star. If they belong to different parts, all vertices except $x$ lie in the two end parts. The component is $K_{1,s,t}$ for $1\le s\le t$. In every remaining shape all distinct edges conflict, so an admissible coloring uses one color per edge.

A star with edges and a triangle each need just one color. A book $K_{1,1,t}$ for $t\ge2$ needs $2t$ colors. Its $2t$ edges to the large part pairwise conflict, and the spine belongs to no four-cycle. For $2\le s\le t$, the least palette on $K_{1,s,t}$ is $t(s+1)$. There are $st$ exclusive cross-edge labels and $t$ distinct labels on the spokes to the larger part. Pairing each spoke to the smaller part with a distinct spoke to the larger part attains this count. [Block coloring and exact palette](shared-edge.md)

## Exact maximum with one nontrivial component

For $n\ge4$ the maximum is

$$
T(n)=n+\max_{s\ge1,\ s(s+1)\le n}\bigl(s-(n\bmod(s+1))\bigr).
$$

For a fixed shorter side $s$, take $t=\lfloor n/(s+1)\rfloor$. These choices fit on $n$ vertices, with the remaining vertices isolated. Indeed $t\ge2$ whenever $s=1$ and $n\ge4$, and $1+s+t\le t(s+1)$ for $st\ge s+1$. They give $st+s+t=n+s-(n\bmod(s+1))$ edges. The book with $s=1$ already gives at least $n$ edges, so components requiring a fresh color for every edge cannot exceed the formula. [Formal integer identities](../hall-reduction/MultipartiteSquares.lean)

Write $S$ for the largest integer satisfying $S(S+1)\le n$. Then $T(n)\le n+S$, with equality exactly at $n=S(S+1)$ and $n=(S+1)^2$. Equality requires $s=S$ and zero remainder. Between consecutive products $S(S+1)$ and $(S+1)(S+2)$ these are the only multiples of $S+1$. The rounded rectangle construction gives $s-(n-t(s+1))\ge\sqrt n-3n^{1/4}-29/8$ for $n\ge256$. Together these estimates give the asserted asymptotic. [Rounding estimate](shared-edge.md)

## Independent components

For a feasible complete multipartite component $C$ of $m_C$ edges, a proper restriction of a fixed coloring can retain exactly one edge of each used color. Every two disjoint edges conflict, and two incident same-color edges cannot both survive. Keeping one edge of each color attains the bound. Splitting color classes lets an admissible initial coloring use $\min(m_C,n)$ distinct colors. Thus the minimum inherited deletion cost over original colorings is $(m_C-n)_+$. If $m_C>n$, one edge deletion permits a proper recoloring. Delete the spine in a book or a cross edge in a rectangular block. If $m_C\le n$, give all its edges different colors. Colors may be reused freely between components. [Proper rectangular recoloring](../hall-reduction/RectangularBlock.lean)

Let $D$ be the minimum inherited cost and $R$ the minimum cost when recoloring is allowed. For a disjoint union of complete multipartite components, $D=\sum_C(m_C-n)_+$ and $R$ is the number of components with $m_C>n$. A dense component of shape $(1,s,t)$ contributes $d\le s$ and occupies $1+s+t\ge2d+1$ vertices. Hence $2D+R\le n$. At $n=s(s+1)$ for $s\ge2$, the exact maximum inherited cost is $s\lfloor s/2\rfloor$. Each dense component has gain at most $s$ and needs at least $2s+1$ vertices. The latter follows from balancing the two factors $(a+1)(b+1)$ if $a+b\le2s-1$. Exactly $\lfloor n/(2s+1)\rfloor=\lfloor s/2\rfloor$ square blocks fit. [Packing bounds in Lean](../hall-reduction/BouquetPacking.lean) · [Component sum in Lean](../hall-reduction/MultipartiteSquares.lean)

For the edge maximum, a component of order $v$ satisfies $m_C\le\min(v^2/2,n+\sqrt n)$. Its edges per vertex are at most $\sqrt{(n+\sqrt n)/2}$. Summing over components gives $n^{3/2}/\sqrt2+O(n)$. For the matching lower bound, take as many disjoint copies of $K_r$ as fit, with $r$ the largest integer satisfying $\binom r2\le n$. Use distinct labels within each clique. There are $\lfloor n/r\rfloor$ cliques, so their total is $n^{3/2}/\sqrt2-O(n)$.

There is an exact result at infinitely many orders. For odd $r\ge7$ and $n=\binom r2$, the unique extremal support in this component class consists of $(r-1)/2$ copies of $K_r$, giving $n(r-1)/2$ edges. Components of order $v\le r$ have at most $(r-1)/2$ edges per vertex, with equality only for $K_r$. A larger component with $m_C\le n$ has strictly smaller ratio. For $m_C>n$ the component has parts $(1,a,b)$ with $a\le b$. If $v\le r+1$, then $a+b\le r$ gives $ab+a+b\le r^2/4+r\le\binom r2$ for $r\ge6$, a contradiction. Hence $v\ge r+2$. Feasibility gives $a\le r-2$ and $m_C\le n+a\le n+r-2<(r-1)(r+2)/2$. Its ratio is again strictly smaller. Equality in the sum forces every component to be $K_r$.

## Exhaustive finite check

The C++ audit tests the characterization on every unlabelled graph through ten vertices, including the 12,005,168 supports at order ten. On each qualifying support it calls the coloring solver around the predicted minimum palette, checks properness at the order-sized palette and tests one-edge repair whenever the component has excess edges. The last column gives the directly observed edge maximum. [C++ checker](check_multipartite.cpp) · [Counts by order](multipartite-counts.tsv) · [Coloring solver](../../bruteforce/results/2026-11-21-0600/native/coloring.cpp)

```sh
c++ -O3 -std=c++17 check_multipartite.cpp ../../bruteforce/results/2026-11-21-0600/native/coloring.cpp -o "$SCRATCH/check-multipartite"
for n in 1 2 3 4 5 6 7 8 9 10
do
    "$NAUTY/geng" -q "$n" | "$SCRATCH/check-multipartite"
done
```
