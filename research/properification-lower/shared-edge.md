# One deleted edge can change the cost of making a coloring proper

**For every $n\ge112$, there is a connected $n$-vertex graph with the following two properties. Every coloring with at most $n$ colors that makes every four-cycle rainbow requires at least $n/2-O(n^{3/4})$ edge deletions to become proper with its labels fixed. Deleting one specified edge permits a proper rainbow-four-cycle coloring with the same palette.** A coloring is proper when all edges incident with the same vertex have different colors.

For example, one graph on 420 vertices has 4,419 edges and 437,045 rainbow four-cycles. Every admissible 420-coloring forces at least 200 deletions if the surviving edges keep their labels. A coloring attaining 200 exists. Deleting one shared edge and coloring the other 4,418 edges afresh suffices. The lower bound applies to every possible starting coloring. The earlier near-quadratic lower bound in this project concerns a specified coloring. [Construction in C++](shared_edge.cpp) · [Earlier deletion result](README.md) · [Original question](https://www.erdosproblems.com/810)

## A block in which the repeated colors are forced

Let $2\le s\le t$. Take a complete tripartite graph with parts $\{z\}$, $A=\{a_0,\ldots,a_{s-1}\}$ and $B=\{b_0,\ldots,b_{t-1}\}$. Call the $st$ edges between $A$ and $B$ the cross edges. Every two cross edges are on a common four-cycle, including pairs sharing one endpoint. Each cross edge also lies on a four-cycle with every edge incident to $z$. For example, for $a_i b_j$ and $za_h$ with $h\ne i$, use $z,a_h,b_j,a_i$. When $h=i$, use any other vertex of $A$. The case of a spoke to $B$ is symmetric. Two spokes to the same part also lie on a four-cycle. A spoke to $A$ and a spoke to $B$ have outer endpoints with exactly one common neighbor, $z$, so they can reuse a label.

The least admissible palette is $st+t=t(s+1)$. The cross edges take $st$ exclusive labels, and the $t$ spokes to $B$ require $t$ more. Pairing each spoke to $A$ with a distinct spoke to $B$ attains this bound. With a palette of $n\ge t(s+1)$ colors, at most $n-st$ of the $s+t$ spokes can survive in a proper restriction. At least $st+s+t-n$ **apex spokes** must be deleted whenever this difference is positive. Deleting cross edges cannot release their already assigned labels on the remaining spokes. Lean checks this bound for each block and its sum over the indexed private apex sets, from the three possible types of four-cycle. [Kernel-checked block lemma](../hall-reduction/SharedEdgeBlock.lean)

Write $n=t(s+1)+\delta$ with $0\le\delta<s$. To attain exactly $s-\delta$ necessary deletions, give the spoke to $a_i$ the color of the spoke to $b_{(i+1)\bmod t}$, then split $\delta$ pairs with fresh colors. The two spokes to $a_0$ and $b_0$ have different colors.

Deleting $a_0b_0$ gives a different option. For each $1\le i<s$, give the two disjoint edges $a_0b_i$ and $a_i b_0$ a common color. The missing edge $a_0b_0$ breaks their only potential four-cycle, since there are no edges inside $A$ or $B$. Give every other edge a distinct color. This coloring is proper, every four-cycle is rainbow, and the number of labels used is exactly $st+s+t-1-(s-1)=t(s+1)$. Lean also checks this explicit coloring for rectangular blocks. An injection from the $s-1$ private row indices into the $t-1$ private column indices specifies the pairs. The formal proof covers all three cycle types, properness and the palette cardinality. [Rectangular punctured-board lemmas](../hall-reduction/RectangularBlock.lean)

## Several blocks share the same edge

Take $h$ copies, identify all their $a_0$ vertices as $u$, and identify all their $b_0$ vertices as $v$. The edge $uv$ occurs once. All other vertices and edges belong to individual blocks. The $h$ sets of apex spokes are disjoint. Restricting any admissible coloring to each block therefore forces at least $h(s-\delta)$ distinct deletions to preserve labels and obtain properness.

The only four-cycles using more than one block are $u,z_i,v,z_j,u$. Removing $u,v$ separates all private vertices of different blocks. A four-cycle meeting two blocks therefore splits into two paths of length two between $u$ and $v$. A cycle using $uv$ and a path of length three stays in one block, since the two internal vertices of the path are adjacent. The only common neighbor of $u$ and $v$ in block $i$ is $z_i$. The mixed cycles persist after deleting $uv$. When $h\ge2$, they require $uz_i$ and $vz_i$ to have different labels even though these spokes can agree in an isolated block.

Suppose $2+h(s+t-1)\le n$ and $h(s+t)\le n-1$. In the original block coloring above, assign $uv$ the same label in every block. Within one block the edges at $u$ or $v$ other than $uv$ use $s+t$ distinct labels. Reserve disjoint sets of that size for the different blocks, and extend each local renaming to a permutation of the palette. The cross-block cycles then have four different colors. The only incident repetitions are the $s-\delta$ pairs at each private apex, so the lower bound on deletions is attained.

After deleting $uv$, use the proper block coloring. The labels appearing at $u$ or $v$ within one block now number $t+1$, because $s-1$ labels occur at both vertices. Reserve disjoint boundary label sets across blocks again. This gives a proper coloring of the entire graph, including all cross-block four-cycles. The undeleted graph admits no proper coloring with the palette, since any one full block already forces an apex deletion.

Attach any remaining vertices as a path starting at a private vertex of the first block. Each new edge can receive a label unused at its attachment vertex, and the path introduces no four-cycles. The graph is connected on exactly $n$ vertices.

## Exact examples and all large orders

For $s=t\ge2$, choose $n=s(s+1)$ and $h=\lfloor s/2\rfloor$. The two size conditions above hold. The minimum inherited loss over all admissible colorings is exactly $s\lfloor s/2\rfloor$, while the optimal deletion cost with recoloring is one. At $s=20$ this gives the 420-vertex example.

For odd $s\ge3$ one additional block fits if two disjoint boundary edges in different blocks can share a label. The generator uses this refinement. It attains exactly $n/2$ inherited deletions at every such order, the maximum in this family even with unequal blocks. [Sharp packing bound](bouquet.md)

For a general large $n$, let $L=\lceil2\sqrt n\rceil$, $p=\lfloor L/2\rfloor$, and $q=\lceil L/2\rceil$. Then $D=pq-n$ is nonnegative and $D=O(\sqrt n)$. Choose the least $j\ge0$ for which $(p-j)(q+j)\le n$. Since the product falls by $j^2+(q-p)j$, we have $j=O(n^{1/4})$. The excess fall at the first crossing is at most $2j$, giving
$$
a=p-j,\qquad b=q+j,\qquad 0\le n-ab=O(n^{1/4}).
$$
Set $s=a-1$, $t=b$, $\delta=n-ab$, and $h=\lfloor(n-2)/L\rfloor$. Then $s,t=\sqrt n+O(n^{1/4})$, $0\le\delta<s$ for large $n$, and $h=\sqrt n/2+O(1)$. Both size conditions hold because $s+t+1=L$. Consequently $h(s-\delta)=n/2-O(n^{3/4})$. The construction has $(1/2+o(1))n^{3/2}$ edges, so its density tends to zero.

### A numerical bound valid from order 112

At every $n\ge112$ the same rounded construction gives

$$
h(s-\delta)\ \ge\ \frac n2-\frac32n^{3/4}-\frac{16}{5}\sqrt n.
$$

Put $x=\sqrt n$ and $y=\sqrt x$. First suppose $n\ge256$. Then $2x\le L<2x+1$, $p\ge x-1/2$, and $0\le D<x+1/4$. If $j>0$, its minimality implies $(j-1)^2<D$. Since $D$ and the falling products are integers, the overshoot satisfies $\delta\le 2j-1$. Thus $j<1+y+1/(8y)$ and

$$
s-\delta \ge x-1/2-3j > x-3y-29/8.
$$

The last inequality uses $y\ge4$. When $j=0$, $D=\delta=0$ and $s\ge x-3/2$ gives the same bound. Also

$$
h>\frac{x^2-2}{2x+1}-1
 =\frac x2-\frac54-\frac{7}{4(2x+1)}
 >\frac x2-\frac43.
$$

Both lower bounds are positive because $y(y-3)\ge4$. The part sizes satisfy $2\le s\le t$ and $\delta<s$. Multiplication gives an error of at most $(3/2)xy+(151/48)x$, which implies the displayed bound. For $112\le n\le255$, Lean checks the integer construction at all 144 orders, including its palette and vertex inequalities. The right-hand side of the bound is negative throughout this interval because $y\le4$ gives $y(y-3)/2\le2$. The rounding recipe itself fails at 111. [Finite-range kernel check](../hall-reduction/BouquetPacking.lean)

## Reproduction

The block, rectangular recoloring and packing lemmas compile with Lean and Mathlib 4.24.0. Run `lake build SharedEdgeBlock RectangularBlock BouquetPacking` in `research/hall-reduction`. The mixed-cycle argument and the analytic estimates are given above.

The C++ program can use the exact square family (`--square`), optimize over homogeneous blocks (`--order`), or follow the rounding proof exactly (`--rounded`). It writes a complete colored edge list to standard output. The audit checks every four-cycle individually. For the 420-vertex pair it counts 437,045 four-cycles before deletion and 433,055 after. For general $s,t,h$, the original count is
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
"$SCRATCH/shared-edge" --rounded 112 original | "$SCRATCH/audit" --cycles
```
