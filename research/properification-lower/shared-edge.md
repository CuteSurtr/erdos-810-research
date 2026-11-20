# One deleted edge can change the cost of making a coloring proper

**For all sufficiently large $n$, there is a connected $n$-vertex graph with the following two properties. Every coloring with at most $n$ colors that makes every four-cycle rainbow requires at least $n/2-O(n^{3/4})$ edge deletions to become proper with its labels fixed. Deleting one specified edge permits a proper rainbow-four-cycle coloring with the same palette.** A coloring is proper when all edges incident with the same vertex have different colors.

For example, one graph on 420 vertices has 4,419 edges and 437,045 rainbow four-cycles. Every admissible 420-coloring forces at least 200 deletions if the surviving edges keep their labels. A coloring attaining 200 exists. Deleting one shared edge and coloring the other 4,418 edges afresh suffices. The lower bound applies to every possible starting coloring. The earlier near-quadratic lower bound in this project concerns a specified coloring. [Construction in C++](shared_edge.cpp) · [Earlier deletion result](README.md) · [Original question](https://www.erdosproblems.com/810)

## A block in which the repeated colors are forced

Let $2\le s\le t$. Take a complete tripartite graph with parts $\{z\}$, $A=\{a_0,\ldots,a_{s-1}\}$ and $B=\{b_0,\ldots,b_{t-1}\}$. Call the $st$ edges between $A$ and $B$ the cross edges. Every two cross edges are on a common four-cycle, including pairs sharing one endpoint. Each cross edge also lies on a four-cycle with every edge incident to $z$. For example, for $a_i b_j$ and $za_h$ with $h\ne i$, use $z,a_h,b_j,a_i$. When $h=i$, use any other vertex of $A$. The case of a spoke to $B$ is symmetric. Two spokes to the same part also lie on a four-cycle. A spoke to $A$ and a spoke to $B$ have outer endpoints with exactly one common neighbor, $z$, so they can reuse a label.

The least admissible palette is $st+t=t(s+1)$. The cross edges take $st$ exclusive labels, and the $t$ spokes to $B$ require $t$ more. Pairing each spoke to $A$ with a distinct spoke to $B$ attains this bound. With a palette of $n\ge t(s+1)$ colors, at most $n-st$ of the $s+t$ spokes can survive in a proper restriction. At least $st+s+t-n$ **apex spokes** must be deleted whenever this difference is positive. Deleting cross edges cannot release their already assigned labels on the remaining spokes. Lean checks this bound for each block and its sum over the indexed private apex sets, from the three possible types of four-cycle. [Kernel-checked block lemma](../hall-reduction/SharedEdgeBlock.lean)

Write $n=t(s+1)+\delta$ with $0\le\delta<s$. To attain exactly $s-\delta$ necessary deletions, give the spoke to $a_i$ the color of the spoke to $b_{(i+1)\bmod t}$, then split $\delta$ pairs with fresh colors. The two spokes to $a_0$ and $b_0$ have different colors.

Deleting $a_0b_0$ gives a different option. For each $1\le i<s$, give the two disjoint edges $a_0b_i$ and $a_i b_0$ a common color. The missing edge $a_0b_0$ breaks their only potential four-cycle, since there are no edges inside $A$ or $B$. Give every other edge a distinct color. This coloring is proper, every four-cycle is rainbow, and the number of labels used is exactly $st+s+t-1-(s-1)=t(s+1)$. For square blocks, Lean also checks the explicit punctured-board coloring, including all three cycle types, properness and the palette cardinality. [Punctured-board lemmas](../hall-reduction/SharedEdgeBlock.lean)

## Several blocks share the same edge

Take $h$ copies, identify all their $a_0$ vertices as $u$, and identify all their $b_0$ vertices as $v$. The edge $uv$ occurs once. All other vertices and edges belong to individual blocks. The $h$ sets of apex spokes are disjoint. Restricting any admissible coloring to each block therefore forces at least $h(s-\delta)$ distinct deletions to preserve labels and obtain properness.

The only four-cycles using more than one block are $u,z_i,v,z_j,u$. A cycle crossing blocks must pass through both $u$ and $v$, and the only path of length two between them inside block $i$ goes through $z_i$. In particular these cross-block cycles persist after deleting $uv$.

Suppose $2+h(s+t-1)\le n$ and $h(s+t)\le n-1$. In the original block coloring above, assign $uv$ the same label in every block. Within one block the edges at $u$ or $v$ other than $uv$ use $s+t$ distinct labels. Reserve disjoint sets of that size for the different blocks, and extend each local renaming to a permutation of the palette. The cross-block cycles then have four different colors. The only incident repetitions are the $s-\delta$ pairs at each private apex, so the lower bound on deletions is attained.

After deleting $uv$, use the proper block coloring. The labels appearing at $u$ or $v$ within one block now number $t+1$, because $s-1$ labels occur at both vertices. Reserve disjoint boundary label sets across blocks again. This gives a proper coloring of the entire graph, including all cross-block four-cycles. The undeleted graph admits no proper coloring with the palette, since any one full block already forces an apex deletion.

Attach any remaining vertices as a path starting at a private vertex of the first block. Each new edge can receive a label unused at its attachment vertex, and the path introduces no four-cycles. The graph is connected on exactly $n$ vertices.

## Exact examples and all large orders

For $s=t\ge2$, choose $n=s(s+1)$ and $h=\lfloor s/2\rfloor$. The two size conditions above hold. The minimum inherited loss over all admissible colorings is exactly $s\lfloor s/2\rfloor$, while the optimal deletion cost with recoloring is one. At $s=20$ this gives the 420-vertex example.

For odd $s\ge3$ one additional block fits if two disjoint boundary edges in different blocks can share a label. The generator uses this refinement. It attains exactly $n/2$ inherited deletions at every such order, the maximum in this family even with unequal blocks. [Sharp packing bound](bouquet.md)

For a general large $n$, let $L=\lceil2\sqrt n\rceil$, $a_0=\lfloor L/2\rfloor$, and $b_0=\lceil L/2\rceil$. Then $D=a_0b_0-n$ is nonnegative and $D=O(\sqrt n)$. Choose the least $j\ge0$ for which $(a_0-j)(b_0+j)\le n$. Since the product falls by $j^2+(b_0-a_0)j$, we have $j=O(n^{1/4})$. The excess fall at the first crossing is at most $2j$, giving
$$
a=a_0-j,\qquad b=b_0+j,\qquad 0\le n-ab=O(n^{1/4}).
$$
Set $s=a-1$, $t=b$, $\delta=n-ab$, and $h=\lfloor(n-2)/L\rfloor$. Then $s,t=\sqrt n+O(n^{1/4})$, $0\le\delta<s$ for large $n$, and $h=\sqrt n/2+O(1)$. Both size conditions hold because $s+t+1=L$. Consequently $h(s-\delta)=n/2-O(n^{3/4})$. The construction has $(1/2+o(1))n^{3/2}$ edges, so its density tends to zero.

## Reproduction

The block lemmas compile with Lean and Mathlib 4.24.0. Run `lake build SharedEdgeBlock` in `research/hall-reduction`. The gluing and the choice of integer part sizes are justified in the proof above.

The C++ program can use the exact square family or choose feasible part sizes for a specified order. It writes a complete colored edge list to standard output. The audit checks every four-cycle individually. For the 420-vertex pair it counts 437,045 four-cycles before deletion and 433,055 after. For general $s,t,h$, the original count is
$$
h\left[\binom{s}{2}\binom{t}{2}+t\binom{s}{2}+s\binom{t}{2}\right]+\binom h2.
$$
Deleting $uv$ removes exactly $h(st-1)$ of them. [C++ generator](shared_edge.cpp) · [C four-cycle audit](../../bruteforce/results/2026-11-21-0600/large/audit.c)

```sh
c++ -O3 -std=c++17 shared_edge.cpp -o "$SCRATCH/shared-edge"
cc -O3 ../../bruteforce/results/2026-11-21-0600/large/audit.c -o "$SCRATCH/audit"
"$SCRATCH/shared-edge" --square 20 original | "$SCRATCH/audit" --cycles
"$SCRATCH/shared-edge" --square 20 recolored | "$SCRATCH/audit" --cycles
"$SCRATCH/shared-edge" --order 809 original | "$SCRATCH/audit" --cycles
```
