# Two thirds of the vertices can be forced deletions

For every sufficiently large $n$, there is a connected $n$-vertex graph $G$ on which **every** rainbow-four-cycle coloring with at most $n$ labels needs at least $(2/3)n-O(n^{3/4})$ edge deletions to become proper while keeping its labels. Deleting one specified edge $uv$ permits a proper recoloring with the same budget. Starting from the particular proper coloring we give on $G-uv$, restoring $uv$ while keeping the old labels also costs $(2/3)n-O(n^{3/4})$ old edges. This answers the question of whether the inherited deletion fraction can exceed one half asymptotically. The optimum among all graphs with one-edge repair remains open. The examples here have $O(n^{3/2})$ edges, so the positive-density question in Erdős #810 remains open. [Earlier half-order family](bouquet.md) · [Nine-vertex example](nine-vertex.md) · [Erdős #810](https://www.erdosproblems.com/810)

On 169 vertices the three costs are **96, one and 96**. On 1,369 vertices they are **864, one and 864**. Write $D$ for the minimum inherited cost over all admissible colorings of the full graph, $R$ for the least cost with arbitrary recoloring, and $L$ for the minimum cost to restore the edge to the specified proper coloring with old labels fixed. [C++ generator](crossed_rectangles.cpp) · [Verified counts](crossed-counts.tsv) · [Independent checker of all three graphs](check_split.py)

## Support and exact statement

Choose even $s\ge2$, $t\ge s$ and $n=(s+1)(t+1)+\delta$ with $0\le2\delta\le s$. Put $g=\lfloor(n-2)/(4t+2s)\rfloor$ and suppose $g\ge1$. Start with the edge $uv$. Each of $g$ groups has $4t+2s$ private vertices. Within a group take disjoint $P_0,P_1$ of size $s$. Split each into two halves. Form $Q_0$ from the first half of each $P_i$ and $Q_1$ from the second halves. Both $P_0,P_1$ and $Q_0,Q_1$ partition the same $2s$ vertices.

Join both hubs to every vertex in these two partitions. Add four disjoint sets $X_0,X_1,Y_0,Y_1$, each of size $t$. Each $x\in X_i$ has neighborhood $P_i\cup\{u\}$, and each $y\in Y_j$ has neighborhood $Q_j\cup\{v\}$. Use no other group edges. Add any padding vertices as a path attached to one private $X$ vertex. Then
$$
D(G)=4g(s-\delta),\qquad R(G)=1,\qquad L(G-uv,uv)=4gs.
$$

## Forced deletions in every original coloring

Consider one $X$ set and its $P$. The edges between $X\cup\{v\}$ and $P\cup\{u\}$ form a complete bipartite graph. Every pair of its edges lies on a common four-cycle. Its $(s+1)(t+1)$ edges therefore have distinct colors, leaving at most $\delta$ colors outside this rectangle.

For each $p\in P$, the spoke $up$ conflicts with every edge of $X\times P$ and with every spoke $vp'$ for $p'\in P$. For $xp'$ with $p'\ne p$, use the cycle $u,p,x,p'$. For $xp$, use another vertex of $P$ on $u,p,x,p'$. For $vp'$ use $u,p,v,p'$ when $p'\ne p$. When $p'=p$, the same cycle through another member of $P$ contains both $up$ and $vp$. Thus any color on $uP$ occurring in the rectangle already appears on $uX$ or $uv$. The symmetric argument applies to $vQ$ and $vY$.

All $4gs$ spokes from either hub to the partitioned vertices have different colors because they form a single complete bipartite graph with two hubs. In each of the $4g$ rectangles, at least $s-\delta$ constrained spokes therefore match a partner at their own hub. Partners in the local $uX$ or $vY$ sets are distinct, and the color of $uv$ can occur on at most one constrained spoke globally. These monochromatic incident pairs have disjoint edge sets. Every proper restriction hits all of them, giving $D\ge4g(s-\delta)$. Lean checks the palette-slack inequality, its sum over disjoint pairs, and the two-list allocation used below. [Counting lemmas](../hall-reduction/CrossedRectangles.lean)

## Colorings that attain the bound

Reserve one label for $uv$ and a distinct boundary label for each edge from a hub to a partitioned vertex. In the original graph, give $s-\delta$ of the $uX_i$ edges the colors of distinct $uP_i$ edges and give the other $t-s+\delta$ edges new boundary labels. Do the same for $vY_j$ with $vQ_j$. All new boundary labels are distinct across groups. The total reservation is $1+4g(t+\delta)\le n$ because $2\delta\le s$.

For the proper coloring after deleting $uv$, instead pair $s$ of the $uX_i$ edges with distinct $vP_i$ edges. Pair $s$ of the $vY_j$ edges with distinct $uQ_j$ edges. Reserve fresh labels for the remaining spokes and keep the label of $uv$ unused. Each equal pair is disjoint. Its only possible four-cycle would use $uv$, since $X_i$ has no neighbor $v$ and $Y_j$ has no neighbor $u$.

It remains to assign colors to the four grids $X_i\times P_i$, $Y_j\times Q_j$ in each group. For an $X$ grid, exclude the color of $uv$, all labels on both hubs' edges to its own $P$, and the fresh labels on its own $uX$ edges. At least $st$ labels survive in both constructions. Use the symmetric exclusions for each $Y$ grid. Each grid will use $st$ different colors.

The only constraints between centers of different grids occur between $X_i\times (P_i\cap Q_j)$ and $Y_j\times (P_i\cap Q_j)$. A four-cycle containing an $X_i$ vertex and a $Y_j$ vertex as its opposite pair has both other vertices in this intersection. Distinct $X$ sets have only $u$ as a common neighbor of their rows, and distinct $Y$ sets have only $v$. Requiring disjoint color sets on the two grids at every intersection also prevents repetitions at their shared columns. A grid edge and a spoke to another partition column, outside its own grid's columns, cannot close a four-cycle together. A grid edge and a spoke to an opposite-type row cannot close one either. The group has no edges between partition columns or between private rows. Four-cycles meeting more than one group use only the four boundary spokes of two private common neighbors of $u,v$, which have distinct labels.

Here is an allocation satisfying all four intersection conditions. Choose lists $A_0,A_1$ of $st$ allowed labels for the two $X$ grids. Take a bijection $A_0\to A_1$ fixing their common labels. Split $A_0$ in half. Assign its two halves to the two column halves of $P_0$, and assign their images in reverse order to the column halves of $P_1$. For fixed $Q_j$, the two sets $F_0,F_1$ of colors already used at its two intersections are disjoint and have size $st/2$. Take any allowed $Y_j$ list $T$ of size $st$. Assign all of $T\cap F_1$ to the first intersection and extend it to $st/2$ members of $T\setminus F_0$. The unused half then avoids $F_1$. The two halves color the entire $Y_j$ grid injectively.

In the original coloring, the only incident repetitions are the $4g(s-\delta)$ designated pairs. The two outer endpoints of a repeated pair $ux,up$ have only $u$ as a common neighbor, so these repetitions preserve the four-cycle condition. The same holds at $v$. The punctured coloring is proper throughout. Color the padding path away from its attachment using locally unused labels different from the reserved label of $uv$. This proves the formulas for $D$ and $R$.

## Restoring the edge and passing to large orders

In the punctured coloring each of the $4gs$ paired boundary labels gives a length-three path from $u$ to $v$ whose first and last colors agree. Its middle edge belongs to the corresponding grid. These paths have disjoint edge sets, so restoring $uv$ requires at least one deletion per path. Delete their middle edges and restore $uv$ in its reserved color. Every new four-cycle consists of $uv$ and a surviving old three-edge path. Properness already distinguishes successive edges, and all equal end pairs have been removed. This proves $L=4gs$ with the original palette. The same examples approach the sharp two-thirds reinsertion bound even with the label of $uv$ reserved. [General edge-insertion theorem](edge-insertion.md)

For $s=t=6q$, $n=(6q+1)^2$ and $q\ge1$, exactly $g=q$ groups fit. Here
$$
D=L=24q^2=\tfrac23(\sqrt n-1)^2.
$$
For every large $n$, take $a=\lfloor\lceil2\sqrt n\rceil/2\rfloor$, $b=\lceil2\sqrt n\rceil-a$. Then $0\le ab-n=O(\sqrt n)$. Decrease $a$ and increase $b$ by the same least nonnegative $j$ until $(a-j)(b+j)\le n$. The decrease in the original product is $j^2+(b-a)j$, so $j=O(n^{1/4})$. Increase $j$ once more if necessary to make $a-j$ odd. Consecutive products near the crossing differ by $O(n^{1/4})$. Taking $s=a-j-1$ and $t=b+j-1$ gives even $s$, with $s,t=\sqrt n+O(n^{1/4})$ and $0\le\delta=O(n^{1/4})$. Eventually $2\delta\le s$ and $g=\sqrt n/6+O(n^{1/4})$. Substitution in the exact formulas gives both claimed bounds for all sufficiently large orders.

## Reproduction

The checker evaluates the three colored graphs, verifies all four-cycles, and inspects every repeated pair and every edge retained after insertion. The exact universal lower bound uses the rectangle proof above. [Audit table](crossed-counts.tsv)

```sh
c++ -O3 -std=c++17 crossed_rectangles.cpp -o "$SCRATCH/crossed"
cc -O3 ../../bruteforce/results/2026-11-21-0600/large/audit.c -o "$SCRATCH/audit"
for mode in original recolored reinserted
do
    "$SCRATCH/crossed" 12 12 169 "$mode" > "$SCRATCH/$mode"
done
python3 check_split.py "$SCRATCH/audit" "$SCRATCH/original" "$SCRATCH/recolored" "$SCRATCH/reinserted"
```
