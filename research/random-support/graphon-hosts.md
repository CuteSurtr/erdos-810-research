# Colorable subgraphs of an inhomogeneous random host

Let \(W:[0,1]^2\to[0,1]\) be a fixed symmetric measurable function. Sample independent uniform vertex types \(X_i\), and conditional on the types retain each unordered edge independently with probability \(W(X_i,X_j)\). Write \(b(t)=t-t^2/2\). With probability tending to one, the largest subgraph admitting a rainbow-four-cycle coloring with at most \(Cn\) colors has at most
\[
             \left(\tfrac12\int b(W)+o(1)\right)n^2
\]
edges for every fixed \(C>0\). The same conclusion holds if one permits at most \(\eta_n n^3\) bad cycles, for any deterministic \(\eta_n\to0\). A bad cycle has at least two of its four edges the same color.

For example, with two equal-sized types, within-type edge probability \(4/5\), and between-type probability \(1/5\), the coefficient is at most \(33/200=0.165\). A homogeneous host with the same mean \(1/2\) gives the bound \(3/16=0.1875\). In general, if \(p=\int W\), then the improvement in the upper coefficient over the homogeneous formula is exactly \(\operatorname{Var}(W)/4\), by expanding the square. [Homogeneous host theorem](subgraphs.md)

In particular, for **every fixed nonzero graphon** the minimum number of bad cycles in the entire sampled host has order \(n^3\) with high probability when the palette is between \(cn\) and \(Cn\), for fixed \(c,C>0\). The lower-bound constant may depend on \(W\). The expected host edge coefficient tends to \(\frac12\int W\), and its gap above the displayed cap is \(\frac14\int W^2>0\). The random-label upper bound holds on any support. This excludes independent sampling from a fixed nonzero graphon as a source of a positive-density solution of #810. [Universal upper estimate for the minimum](../graph-limits/repeated-cycles.md)

## Robustness in a homogeneous block

First fix an edge probability \(t\) and consider the homogeneous host \(G(n,t)\). The matching-list estimate gives \(b(t)k^2+O(k)+o(n^2)\) occupied entries on a matched rectangle of size \(k\) when all cycles are rainbow. For a proper coloring with defects, add the number of unordered distinct matching-dart pairs for which both crossed cells are occupied in the subgraph. The inequality holds because a pair with both crosses adds at most one beyond the maximum allowed by the union of the two host cells. For weighted lists with weights in \([0,1]\), the extra count is bounded by the same unweighted count. Summed over colors it is at most \(4R\), since a bad cycle has at most two repeated opposite pairs and two orientations giving its two crossed cells for each repeated pair.

Consequently the averaged comparison used in the homogeneous proof changes by \(O(R/(qn^2))\) after padding the palette to \(q=\lceil Cn\rceil\). When \(R=o(n^3)\), the error tends to zero and every cut limit is again bounded by \(b(t)\). For arbitrary colorings apply the shade-refinement bound with fixed \(\tau>0\). The proper subgraph loses at most \(\tau n^2+o(n^2)\) edges, has a fixed linear palette and has at most the original number of defects. For oriented rectangles the resulting loss is at most twice as large. Letting \(\tau\) tend to zero gives, uniformly over the subgraphs, their colorings and all vertex sets \(S,T\),
\[
                e_F(S,T)\le b(t)|S||T|+o(n^2).
\]
The uniformity follows by contradiction along a subsequence with violating rectangles, using cut convergence of the proper subgraphs and the pointwise limit bound. [Uniform random-host matching estimate](subgraphs.md) · [Finite shade refinement](../graph-limits/repeated-cycles.md)

## From blocks to measurable kernels

If \(W\) is constant \(p_{ij}\) on each product of cells of a finite partition, expose the sampled class sizes. Couple the edges in each unordered block to the same entries of a homogeneous \(G(n,p_{ij})\) on the full vertex set by filling unused entries independently. There are finitely many blocks, so with high probability all their uniform rectangle statements hold at once. Restrict an arbitrary colored subgraph to each block. A block restriction can only remove bad cycles. Sum the oriented rectangle bounds over all ordered block pairs and divide by two. The empirical class proportions converge to their measures. This gives the asserted integral for every step kernel, including blocks with probability zero or one.

For general \(W\), take a symmetric step approximation \(U\) in \(L^1\) on a common finite partition. Use the same latent vertices and one uniform random variable per edge to couple the two sampled graphs. The number of differing unordered edges divided by \(n^2\) converges in probability to \(\frac12\|W-U\|_1\). Indeed the type-pair average has that limiting mean and variance \(O(1/n)\), since pairs with disjoint indices are independent. Conditional edge-sampling variance is \(O(1/n^2)\) after normalization. Intersect a colored subgraph of the \(W\)-sample with the \(U\)-sample. It loses at most this many edges and retains at most its original number of defects. Finally \(b\) is 1-Lipschitz on \([0,1]\). Apply the finite-partition estimate and take the approximation error to zero.

For the full-host lower bound fix the step approximation and the tolerances so the coupling error and block size errors together are smaller than a quarter of the density gap. The homogeneous matching-list events give deterministic bounds on their good hosts. A fixed positive defect constant works there for this fixed gap. Its failure would give hosts at successively larger orders obeying all the matching-list estimates, with a subgraph retaining the gap and \(R/n^3\to0\). The uniform rectangle argument in the finitely many blocks rules out such a sequence. The joint good event and approximation estimates have probability tending to one.
