# Cubically many non-rainbow four-cycles in arbitrary colorings

Fix \(C>0\) and \(\alpha>0\). For all sufficiently large \(n\), any graph with at least \((1/4+\alpha)n^2\) edges colored using at most \(Cn\) colors has at least \(c(C,\alpha)n^3\) four-cycles with a repeated color, for some \(c(C,\alpha)>0\). **Incident edges may have the same color.** For the #810 budget of \(n\) colors and each \(0<\alpha<1/4\), the minimum number of these cycles over such graphs is \(\Theta_\alpha(n^3)\).

Here a four-cycle is counted up to rotation and reversal. A four-vertex set can contain three different four-cycles. The previous cubic bound assumed a proper coloring. The argument below converts a coloring with few bad cycles into a dense properly colored subgraph by splitting each old color into a bounded number of shades. [Proper-coloring supersaturation](quarter-short.md#supersaturation-for-proper-colorings) · [Original problem](https://www.erdosproblems.com/810)

## A finite refinement bound

In a graph \(G\) with \(n\) vertices and \(q\) colors, let \(A\) count the four-cycles with a repeated color on *adjacent* edges, and \(R\) all non-rainbow four-cycles. Choose \(0<\tau\le1\), put \(K=\lceil4/\tau^2\rceil\), and assume \(n\ge K\). There is a subgraph obtained by deleting at most
\[
                 \tau n^2+4A/n
\]
edges, on which a refinement with at most \(2Kq\) colors is proper. Every cycle rainbow in the original labeling remains rainbow if it survives.

First designate all vertices of original degree at least \(\tau n\) as high-degree vertices. Deleting all edges incident with the remaining vertices costs at most \(\tau n^2\). Use the original graph when counting the cycles that pay for the further deletions.

At any center \(b\) and color \(c\), take the set \(T\) of its high-degree neighbors joined to \(b\) in color \(c\), and put \(k=|T|\). For every vertex \(y\), write \(r_y=|N_G(y)\cap T|\). There are exactly
\[
 Z_{bc}=\sum_{y\ne b}\binom{r_y}2
       =\tfrac12\left(\sum_y r_y^2-\sum_y r_y-k(k-1)\right)
\]
four-cycles marked at \(b\) using two spokes in this set. Each choice of \(y\ne b\) and two of its neighbors in \(T\) is a simple cycle because the graph has no loops. A four-cycle has at most four choices of marked center, each determining its repeated color. Thus \(\sum_{b,c} Z_{bc}\le4A\).

Consider a star with \(k\ge K\). Its leaves have total degree \(\sum_y r_y\ge\tau nk\). Cauchy–Schwarz gives \(\sum_y r_y^2\ge\tau^2nk^2\), and \(\sum_y r_y\le nk\). Both \(nk\) and \(k^2\) are at most \(\tau^2nk^2/4\). It follows that
\[
                  Z_{bc}\ge\tau^2nk^2/4\ge nk .
\]
Delete the spokes at every such center and color. Their total number counted with multiplicities is at most \(4A/n\). Every original color class left in the subgraph has maximum degree below \(K\). Greedily assign at most \(2K\) shades within each old color. Each edge has fewer than \(2K\) previously colored incident edges in that class. Use the pair (old color, shade) as the new label. This proves the finite bound. [Lean proof of the incidence count and cost inequality](../hall-reduction/RepeatedCycleStars.lean)

## Consequences for #810

Suppose a sequence had \(R=o(n^3)\), \(q\le Cn\) and at least \((1/4+\alpha)n^2\) edges. Take \(\tau<\alpha/2\). For large \(n\) the refinement retains at least \((1/4+\alpha/2)n^2\) edges, uses at most \(2KCn\) colors and has at most the original \(R\) bad cycles. The cubic supersaturation theorem for proper colorings with this fixed linear palette gives a contradiction. Selecting a sequence with \(R/n^3\to0\) would be possible if no positive constant worked, proving the stated uniform lower bound.

In fact the cubic upper estimate holds on every fixed graph support when the palette has at least a fixed positive multiple of \(n\) colors. Give the edges independent uniform colors. Each of the six edge pairs on a cycle agrees with probability \(1/q\), so the expected bad count is at most \(6/q\) times the number of cycles, or \(O(n^3)\). Some coloring attains this bound. For \(q=n\) there is also a proper upper example on every graph by restricting a proper coloring of \(K_n\). Two distinct edges of the same matching can be opposite in at most two cycles. Thus in every support above a fixed threshold between \(1/4\) and \(1/2\) the minimum over its colorings has sharp cubic order. The leading constants can be evaluated on two complete hosts along powers of two. [Complete and bipartite host counts](complete-defects.md)

The same proof yields a statement for every rectangle of the adjacency matrix. In an arbitrary coloring with \(q=O(n)\) and \(R=o(n^3)\), the number of oriented edges from any vertex set \(X\) to any vertex set \(Y\) is at most \(|X||Y|/2+o(n^2)\), uniformly in the two sets. For each fixed \(\tau\) the proper refined graph obeys the rectangle bound with subcubic error by the matched-rectangle proof. The deleted edges change an oriented rectangle count by at most \(2\tau n^2+o(n^2)\). Then take \(\tau\downarrow0\). The original positive-density question below the one-quarter coefficient remains open. [Matched-rectangle proof with a defect term](quarter-short.md#supersaturation-for-proper-colorings)

## Verification

Lean checks the star inequality from actual finite leaf neighborhoods, its binomial marked-cycle count, and the summed deletion cost. The deduction from proper supersaturation and the full general-coloring theorem above are written proofs.

The C++ audit compares the star counts against direct four-vertex enumeration, verifies the greedy shades are proper, and checks the loss and cycle counts before and after refinement. It tests every one of the 4,096 labeled graphs on four vertices with three available colors and optional missing edges. It also tests 36 larger colorings, including graphs with many monochromatic stars, graphs with low-degree vertices and proper controls. Compile from the repository root and run the resulting executable. [C++ checker](check_repeated_stars.cpp)

```sh
c++ -O2 -std=c++17 research/graph-limits/check_repeated_stars.cpp -o /tmp/check_repeated_stars
/tmp/check_repeated_stars
```
