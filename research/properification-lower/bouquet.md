# The sharp half-order bound for blocks sharing one edge

For infinitely many orders $n$, there is a connected graph on which even the best admissible initial coloring costs **exactly $n/2$ deletions** to become proper while preserving its labels. Deleting one edge permits a proper recoloring. The smallest example in this family has 12 vertices and 29 edges. Keeping the original colors costs at least six edges, and an initial coloring attaining six exists. With recoloring, one deletion suffices.

For a support $G$, write $D(G)$ for the minimum number of deletions needed for properness, minimized over every original rainbow-four-cycle coloring with at most $n$ colors. Write $R(G)$ for the minimum number of deletions that allows a new proper rainbow-four-cycle coloring with the same budget. Within the family below, $D(G)\le\lfloor n/2\rfloor$ even when the blocks have different sizes. For every odd $s\ge3$, order $n=s(s+1)$ attains $D(G)=n/2$ and $R(G)=1$. [Block obstruction and post-deletion coloring](shared-edge.md) · [C++ construction](shared_edge.cpp)

## The exact cost of a collection of blocks

Use blocks $K_{1,a_i,b_i}$ with $2\le a_i\le b_i$, identifying one cross edge $uv$ in every block. All their other vertices are private. An optional path starting at a private vertex brings the order to $n$. Suppose every block is feasible, meaning $b_i(a_i+1)\le n$. Define

$$
p_i=a_i+b_i-1,\qquad d_i=\max(0,a_i b_i+a_i+b_i-n).
$$

The required number of vertices is $2+\sum_i p_i$. Whenever it fits, the two costs satisfy

$$
D(G)=\sum_i d_i,\qquad R(G)=\begin{cases}1 & \text{if some }d_i>0,\\0&\text{otherwise.}\end{cases}
$$

The block lemma forces $d_i$ deletions among the spokes of its private apex. The cyclic initial coloring of a block attains this cost. If there are enough extra labels to split every repeated pair, use distinct colors throughout that block. Its edges at $u$ or $v$, including $uv$, have distinct local colors. It remains to show that the local colorings can always share the global palette under the vertex bound alone. [Block lemma in Lean](../hall-reduction/SharedEdgeBlock.lean)

With one block, use its coloring directly. With $h\ge2$ blocks, index them cyclically. Reserve one global label for $uv$. In block $i$, select a cross edge $u b_{i,1}$ and a cross edge $a_{i,1}v$, where the subscript 1 selects a private vertex in the indicated part. Give $u b_{i,1}$ and $a_{i+1,1}v$ the same boundary label. Use a distinct label for each of these $h$ pairs and for each remaining boundary edge. Before pairing, excluding $uv$, there are $\sum_i(a_i+b_i)$ boundary labels. After pairing, including $uv$, there are exactly $1+\sum_i p_i\le n-1$. Each block has an injective assignment on its boundary labels that extends to its entire local palette.

The two edges of each new pair are disjoint. The only cycle of length four crossing two blocks has the form $u z_i v z_j u$ for their private apices $z_i,z_j$. The four apex spokes in this cycle received distinct boundary labels. The entire graph is therefore admissible, and every incident repetition is within a private apex. For the punctured graph, the proper coloring in the block proof uses $b_i+1$ distinct boundary labels. Disjoint reservations for these labels fit because $b_i+1\le p_i$. A path can always be colored successively with a color unused at its attachment vertex. This proves the two cost formulas.

## Why half the order is the upper limit in this family

Write $n=b_i(a_i+1)+r_i$. A positive contribution is $d_i=a_i-r_i$. Hence

$$
2d_i-p_i=a_i-b_i+1-2r_i.
$$

This is positive only for a square block, $a_i=b_i=s$, at order $n=s(s+1)$. At every other order, summing the inequalities gives $2D(G)\le n-2$.

At order $n=s(s+1)$, every block with positive contribution has $d_i\le a_i\le s$ by feasibility. It also needs at least $2s-1$ private vertices. Indeed, if $a_i+b_i\le2s-1$, the integer product $(a_i+1)(b_i+1)$ is at most $s(s+1)$, by balancing its two factors. The block then has at most $n-1$ edges. Consequently

$$
D(G)\le s\left\lfloor\frac{s(s+1)-2}{2s-1}\right\rfloor
     =s\left\lceil\frac{s}{2}\right\rceil \qquad(s\ge2).
$$

Take $\lceil s/2\rceil$ blocks of side $s$. Each contributes $s$ deletions, attaining equality. For odd $s$ the value is $n/2$. For even $s$ it is $(n-s)/2$. At orders outside the sequence $s(s+1)$, the construction in the preceding note gives $D(G)\ge n/2-O(n^{3/4})$ for every sufficiently large $n$. [Formalized packing inequalities](../hall-reduction/BouquetPacking.lean) · [All-orders construction](shared-edge.md)

| Order | Edges before deletion | Minimum inherited deletions | Deletions with recoloring | Rainbow four-cycles before / after |
| ---: | ---: | ---: | ---: | ---: |
| 12 | 29 | 6 | 1 | 55 / 39 |
| 30 | 104 | 15 | 1 | 603 / 531 |
| 420 | 4,419 | 200 | 1 | 437,045 / 433,055 |
| 462 | 5,312 | 231 | 1 | 582,175 / 577,335 |

With the generator and checker built as in the preceding note, use `shared-edge --square 21 original` or `shared-edge --square 21 recolored` and pipe its output to `audit --cycles`. The half-order upper bound applies to the specified block family. The maximum possible $D(G)$ among all graphs with $R(G)=1$ is a separate question.
