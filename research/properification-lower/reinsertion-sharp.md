# The sharp asymptotic cost of inserting an edge with the same palette

Let $H$ be a proper edge-colored graph on $n$ vertices in which every four-cycle is rainbow. Use a fixed palette of $n$ labels and let $uv$ be a missing edge. When every surviving old edge keeps its color and the inserted edge must survive, the largest possible minimum number of old edges to delete is
$$
\mathbf{(2/3+o(1))n}.
$$
This closes the interval from $2/3$ to $2-\sqrt7/2$ in the earlier insertion bound. The upper bound combines an explicit label-selection algorithm with the project's uniform half-density theorem for vertex rectangles. Examples attain at least $\lfloor 2(n-2)/3\rfloor-O(1)$ at every order. A separate family has both a large insertion cost and large forced loss on every original coloring of the full graph. [Lower examples](edge-insertion.md#constructions-attaining-the-lower-bound) · [Simultaneous deletion costs](crossed-rectangles.md) · [Uniform rectangle theorem in Lean](../hall-reduction/LinearPalette.lean)

## Clear only the spokes implicated by a label

Let $A=N_H(u)$, $B=N_H(v)$, of sizes $a,b$. Put $W=A\cap B$, $w=|W|$ and $N=n-2$. A split path $u,p,q,v$ has equal colors on $up$ and $qv$. Each split color gives exactly one such path by properness. Write $k$ for their number. The $k$ left endpoints are distinct, as are their $k$ right endpoints. Remove these endpoints from $A$ and $B$ on their respective sides to form $A_0,B_0$. Each split path has an exclusive neighbor occurring in no other such path, hence $k\le N-w$. [Split-path proof](edge-insertion.md#exact-cost-with-a-fresh-label)

For any candidate color $c$ on $uv$, declare the $k$ split spokes active on each side. Also declare $up$ and $vq$ active whenever $p\in A$, $q\in B$ and $pq$ has color $c$. Clear every active spoke on the side with the smaller active count. Delete any remaining old edges of color $c$ at either hub and insert $uv$ in color $c$.

The new edge is proper. Every new four-cycle follows a three-edge old path between the hubs. If its end colors agree, it is split. If its middle edge has color $c$, both its end spokes were active. If an end spoke has color $c$, that spoke was removed. These are all possibilities since incident old edges already have distinct colors. [C++ implementation](insert_label.cpp)

Let $\ell_c,r_c$ count the extra active spokes beyond the split ones. Let $h_c$ be the number of hubs using color $c$, minus one when $c$ is split. After clearing either side, exactly $h_c$ additional spokes of color $c$ need deletion. An unsplit boundary spoke of color $c$ cannot itself touch a middle edge of color $c$ by properness. The algorithm therefore uses at most $k+(\ell_c+r_c)/2+h_c$ deletions.

Write $e(S,T)$ for oriented adjacent pairs from $S$ to $T$, allowing the sets to overlap. Each vertex sees a given color at most once. Consequently
$$
\sum_c\ell_c=e(A_0,B),\qquad \sum_c r_c=e(A,B_0),\qquad \sum_c h_c=a+b-k.
$$
Choosing the cheapest label gives the finite inequality
$$
2nL\le 2nk+e(A_0,B)+e(A,B_0)+2(a+b-k).
$$
One can also clear the smaller whole star and choose a label missing at the other hub, giving $2L\le a+b$. [Finite averaging and optimization in Lean](../hall-reduction/ActiveSpokes.lean)

## Optimization and stability

Let $\Delta=\max_{S,T}(e(S,T)-|S||T|/2)$. The uniform rectangle theorem gives $\Delta=o(n^2)$ over all admissible graphs and all vertex subsets. Since $a+b-k\le 2n$, the new inequality implies
$$
L\le 2+k+\frac{2ab-k(a+b)}{4n}+\frac{\Delta}{n}.
$$
The numerator is nonnegative, so for $N>0$ the denominator $4n$ can be decreased to $4N$. Put $d=a+b$. Since $4ab\le d^2$, the variable part is at most $k+(d^2-2kd)/(8N)$. This is increasing in $d$ for $d\ge 2k$ and in $k$ for $d\le2N$. Use $d\le N+w$ and $k\le N-w$ to obtain
$$
L\le 2+N-w+\frac{(N+w)(3w-N)}{8N}+\frac{\Delta}{n}.
$$
When $w\le N/3$, clearing the smaller star already costs at most $2N/3$. When $w\ge N/3$, the gap between $2N/3$ and the variable part of the last bound is $(3w-N)(5N-3w)/(24N)\ge0$. Thus $L\le 2N/3+2+\Delta/n$ in all cases. The two-vertex case has zero cost. [Rectangle estimate](../graph-limits/quarter-short.md#every-rectangle-uniformly-over-a-linear-palette) · [Kernel-checked envelope](../hall-reduction/ActiveSpokes.lean)

If $L=(2/3-o(1))n$, the overlap is forced to be $w=(1/3+o(1))n$. Below one third the smaller-star bound loses half the overlap deficit. Above one third the displayed factorization loses at least one quarter of the excess. The individual degrees are then both $(2/3+o(1))n$, since both are at least $L$ and their sum is at most $N+w$. Substituting these degrees in the averaged inequality forces $k=(2/3+o(1))n$. Almost every spoke at each hub therefore belongs to a split path. Almost every non-hub vertex lies in one of the common, left-exclusive or right-exclusive neighbor sets, each of size $(1/3+o(1))n$.

## Exact check at small orders

With the two endpoints fixed and vertex labels retained, a separate C++ program enumerated every proper rainbow color partition using at most $n$ labels for $2\le n\le7$. It tests every possible color for the inserted edge and computes the exact minimum by branching on the three old edges of a spoiled cycle. The largest costs at orders two through seven are **0, 0, 1, 2, 2 and 3**. At order seven it checked 135,833,154 color partitions. The active-spoke algorithm was optimal on 135,813,834 of them. In the remaining 19,320 it used three deletions where two suffice. The finite averaging inequality held throughout. [Counts and cost distributions](reinsertion-small.tsv) · [Exact enumerator](insertion_census.cpp)

## Reproduction

The insertion program reads $n,m$ and $m$ triples of zero-based endpoints and colors. It expects a proper rainbow input and two distinct nonadjacent vertices. It prints the repaired graph to standard output and its deletion count, split count and free-spoke incidences to standard error.

```sh
c++ -std=c++17 -O3 crossed_rectangles.cpp -o "$SCRATCH/crossed"
c++ -std=c++17 -O3 insert_label.cpp -o "$SCRATCH/insert"
cc -O3 ../../bruteforce/results/2026-11-21-0600/large/audit.c -o "$SCRATCH/audit"
"$SCRATCH/crossed" 12 12 169 recolored > "$SCRATCH/old"
"$SCRATCH/insert" 0 1 < "$SCRATCH/old" > "$SCRATCH/new"
"$SCRATCH/audit" --cycles < "$SCRATCH/new"
```
