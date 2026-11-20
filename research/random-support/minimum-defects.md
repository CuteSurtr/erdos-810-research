# The minimum number of non-rainbow four-cycles in a random graph

Let \(G=G(n,p)\) and write \(R_q(G)\) for the **minimum** number of unoriented non-rainbow four-cycles over all edge colorings with at most \(q\) labels. Colors may repeat at a vertex and the coloring may depend on the entire sampled graph. If \(np^3/\log n\to\infty\), then with probability tending to one,
\[
 R_n(G)\ge (1-o(1))\,p^4n^3/8.
\]
**When \(n\) is a power of two this is an asymptotic equality.** At every order an upper bound within a factor \(2+o(1)\) of the displayed lower bound also holds. For example, at \(p=1/2\) the sharp leading count along powers of two is \(n^3/128\). This covers fixed densities and probabilities tending to zero above the scale where a fully rainbow coloring first becomes possible. [Whole-host zero-collision threshold](README.md) · [Complete-host specialization](../graph-limits/complete-defects.md)

More generally, for fixed \(0<c\le C\), uniformly for \(cn\le q\le Cn\) the lower bound is \((1-o(1))p^4n^4/(8q)\). It is sharp whenever \(q\ge n\) is a power of two. Exact enumeration checks the finite identities. The probabilistic theorem is a written proof.

## Uniform control of possible color classes

Fix a constant \(B\). For any possible set \(H\) of at most \(Bpn\) edges of the complete graph, let \(k=|H|\), \(d_x=\deg_H(x)\), \(T_H=\sum_x d_x^2\), and \(W_H=\sum_x\binom{d_x}2\). For each unordered pair of disjoint edges of \(H\) there are two ways of completing them to opposite edges of a four-cycle. Count in \(Z_H\) the completions whose two cross edges belong to the random graph. The edges of \(H\) are fixed during this count and need not belong to the host. Thus
\[
  \mathbb E Z_H=2p^2\bigl(\tbinom k2-W_H\bigr).
\]
With probability tending to one, simultaneously for every such \(H\),
\[
 Z_H\ \ge\ \mathbb E Z_H
   -O_B\bigl((p k+p^{3/2}T_H)\sqrt{pn\log n}\bigr).                 \tag{1}
\]

To prove (1), index events by the two required cross edges. Each unordered cross pair occurs at most twice, since two disjoint edges on four vertices leave only two candidate matchings. Separate the occurrences into two simple families, one containing every pattern and another containing the patterns occurring twice. For either family its expectation \(\mu\) is at most \(p^2k^2\). A fixed host edge \(xy\) occurs in at most \(d_xd_y\) patterns. Indeed choose the candidate edge incident with \(x\) and the one incident with \(y\); these choices determine the other cross edge. Two distinct patterns sharing a host edge have joint probability \(p^3\). The ordered dependency sum \(\Delta\) of Janson's lower-tail inequality is therefore at most
\[
 p^3\sum_{x<y}(d_xd_y)^2\le p^3 T_H^2/2 .
\]
The inequality gives \(\Pr(X\le\mu-t)\le \exp[-t^2/(2(\mu+\Delta))]\) for \(0\le t\le\mu\). A bound allowing error larger than \(\mu\) holds automatically. Choose error \(D_B(pk+p^{3/2}T_H)\sqrt{pn\log n}\) in each family. There are only \(\exp(O_B(pn\log n))\) candidate edge sets with \(k\le Bpn\). The union bound with sufficiently large \(D_B\) proves (1). Since the event holds for every candidate in the complete graph it can be applied after seeing both the random graph and its coloring. [Janson and Warnke, lower-tail inequality](https://arxiv.org/pdf/1406.1248)

## Counting repeat pairs in an adaptive coloring

Under the stated hypothesis, \(p^2n\gg\log n\). With high probability every two vertices have \((1+o(1))p^2n\) common neighbors, by a binomial tail bound and a union bound. The edge count is \(m=(1+o(1))pn^2/2\). The number \(N_4\) of four-cycles equals half the sum over unordered vertex pairs of the binomial coefficient of their common-neighbor count taken two at a time, so \(N_4=(1+o(1))p^4n^4/8\).

Give edges independent uniform colors from \(q\) labels. The expected bad count is at most \(6N_4/q\). Consequently an optimal coloring has \(R=O_c(p^4n^3)\). Let \(W\) be the number of equally colored pairs incident at a vertex. Each such pair extends to at least \((1-o(1))p^2n\) bad cycles. Each bad cycle has at most four marked centers. Hence \(W=O_c(p^2n^2)\). Over all original color classes, the sum of squared vertex degrees is exactly \(2W+2m=O_c(pn^2)\).

Large classes can be split for counting without losing the quadratic lower bound. Put \(a=m/q\) and \(b=\max(1,\lceil2a\rceil)\). For an original class of size \(s<2b\), keep it whole and use \(s^2\ge 2as-a^2\). Otherwise partition its edges into pieces of size between \(b\) and \(2b-1\), appending the remainder to the last full piece. Their squared sizes sum to at least \(2as\). Thus the piece sizes \(k_i\) satisfy
\[
 \max_i k_i=O_c(pn),\qquad
 \sum_i k_i^2\ge2am-qa^2=m^2/q,\qquad
 \sum_i W_{H_i}\le W,\qquad \sum_i T_{H_i}\le 2W+2m .
\]
The grouping caps the number of edges to which (1) must be applied. Every pair in a piece still has the same original color.

In a realized \(Z_{H_i}\), both anchored edges and both cross edges are present in the host. Each bad cycle can be counted for at most its two opposite pairs, so \(2R\ge\sum_i Z_{H_i}\). Summing (1) yields
\[
 2R\ge p^2(m^2/q-m-2W)
       -O_c\bigl(\sqrt{pn\log n}\,[pm+p^{3/2}(2W+2m)]\bigr).
\]
The bracketed error including its square-root multiplier is \(O_c(p^{5/2}n^{5/2}\sqrt{\log n})\). Its ratio to \(p^4n^3\) is \(O_c(\sqrt{\log n/(np^3)})\). The remaining error \(p^2(m+2W)=O_c(p^3n^2)\) is smaller still. This gives the asserted lower bound on \(R\). Lean verifies the numerical aggregation and the squared influence and splitting inequalities. [Finite inequalities in Lean](../hall-reduction/RandomCollisionCounts.lean)

## A matching upper bound on binary orders

For any fixed graph with \(n\le q=2^d\), inject its vertices uniformly into \(\mathbb F_2^d\) and color each edge by the sum of its endpoints. This gives a proper coloring with at most \(q-1\) labels. On each fixed cycle the first three images are distinct and their sum is a distinct fourth value. The cycle is bad precisely when its fourth image equals that value. Its collision probability is exactly \(1/(q-3)\). Therefore some coloring has
\[
                 R_q(G)\le N_4(G)/(q-3).
\]
This proves the matching upper bound throughout the range above. It also supplies a deterministic existence bound on every fixed graph, including graphs with very few four-cycles.

For arbitrary \(q\ge n\ge4\), inject into an abelian group of order \(q\) and let \(t\) be the number of elements killed by doubling. The collision probability for a fixed cycle is
\[
       \frac{t-1}{(q-1)(q-3)}+\frac{2(q-t)}{(q-1)(q-2)}.
\]
To see this fix distinct opposite images \(x,z\) and let \(y\) be the next random vertex, different from both. The candidate fourth values are \(x+y-z\) and \(z+y-x\). If \(2(x-z)=0\) they coincide and are valid. Otherwise they differ, and each fails to be a new vertex for exactly one choice among the \(q-2\) possible values of \(y\). Average over \(x-z\). Taking a binary group times an odd cyclic group allows \(t=2^{v_2(q)}\). In particular the collision probability is at most \(2/(q-3)\) for every order.

## Finite checks

The C++ audit exhausts all **1,048,576** pairs of five-vertex candidate graphs and host graphs. It checks the expectation at \(p=1/2\) and \(1/3\) by exact weighted enumeration, the one-edge influence bound, the maximum multiplicity two, and the bound on the dependency sum for each of the two simple families. It also checks 86,688 finite class splits and the group labeling probability for every order from 4 through 32. In a fixed 64-vertex half-density test there were 1,003 edges and 114,751 four-cycles. The fixed binary coloring had 1,882 bad cycles. [C++ audit](check_random_defects.cpp)
