# Counting non-rainbow four-cycles on complete hosts

Write \(R\) for the number of unoriented four-cycles whose colors repeat. With \(n\) colors, the minimum on \(K_n\) is at least \((1/8-o(1))n^3\). On the balanced complete bipartite graph with \(n\) total vertices it is at least \((1/64-o(1))n^3\). Both leading constants are attained along powers of two. The lower bounds allow arbitrary repetitions at a vertex. On 128 vertices the binary constructions give **256,032** bad cycles on \(K_{128}\) and **31,744** on \(K_{64,64}\). [C audit](check_complete.c) · [General graph supersaturation](repeated-cycles.md)

## Weighting monochromatic edge pairs

Let \(m_c\) be the size of color \(c\), let \(q\) bound the palette, and put \(E=\sum_c m_c\), \(P=\sum_c\binom{m_c}2\). By Cauchy–Schwarz, \(P\ge(E^2/q-E)/2\). On \(K_n\), a pair of disjoint edges lies in two cycles as opposite edges, and a pair with a common endpoint lies in \(n-3\) cycles. Give a same-color opposite pair weight \(1/2\) in each cycle, and an incident one weight \(1/(n-3)\). Total weight is \(P\). Each bad cycle contributes at most \(1+4/(n-3)\), so
\[
 R(K_n)\ge \frac{P}{1+4/(n-3)}.
\]

On \(K_{a,b}\), two edges in different rows and columns determine one rectangle. A pair in one row occurs in \(a-1\) rectangles, and a pair in one column in \(b-1\). Giving each pair total weight one now yields
\[
 R(K_{a,b})\ge\frac{P}{2+2/(a-1)+2/(b-1)}\quad(a,b\ge2).
\]
For a proper coloring every contributing pair is opposite. The denominators then sharpen to 1 and 2 respectively, exactly. The claimed asymptotic lower bounds follow by using the actual edge counts and \(q=n\).

## Binary colorings that attain the leading constants

For \(n=2^d\), label vertices by \(\mathbb F_2^d\) and color \(xy\) in \(K_n\) by \(x+y\). Each nonzero color forms a perfect matching. When \(x+y=z+w\) for four distinct vertices, the other two partitions of these vertices into pairs also have identical sums. Every bad cycle therefore has two repeated opposite pairs. Counting gives
\[
                    R=(n-1)\binom{n/2}{2}.
\]
For the balanced rectangular host, take its row set and column set to be two distinct linear hyperplanes in the same group, using disjoint vertex copies. Their sum fills the group and each color occurs exactly \(n/4\) times. Again an opposite collision forces the other one. Here
\[
                    R=\tfrac n2\binom{n/4}{2},\qquad d\ge2.
\]
In particular this rectangular coloring attains the **exact** minimum among proper \(n\)-colorings of this host at every such order. The unrestricted lower bound establishes its leading constant.

## Proper complete colorings and commuting matchings

For even \(n\), every proper coloring of \(K_n\) with \(n-1\) labels partitions its edges into perfect matchings. Let \(T_c\) swap the endpoints in matching \(c\). Then the exact excess over the binary lower bound is
\[
 R-(n-1)\binom{n/2}{2}
  =\tfrac14\sum_{a<b}|\{x:T_aT_b(x)\ne T_bT_a(x)\}|.
\]
Indeed let \(D\) be the number of cycles with two repeated opposite pairs. Counting all repeated opposite pairs with multiplicity gives \(R=2P-D\). For fixed colors \(a,b\), their matchings form disjoint even cycles. The compositions agree at \(x\) precisely on the components of length four, each of which contributes four agreements. Finally \(4P=n\binom{n-1}2\).

Consequently equality holds precisely when the involutions commute. The group they generate then acts transitively since every vertex reaches every other one in one step from a matching. A faithful abelian transitive permutation group acts freely, since a point stabilizer fixes every point. The group is therefore regular and elementary abelian, and the coloring is the binary difference coloring up to vertex and color permutations. The four-cycle case is part of the literature on uniform one-factorizations. The identity above expresses the defect directly in terms of commutation failures. [Dinitz on the four-cycle case](https://ftp.mathe2.uni-bayreuth.de/ALCOMA05/dinitz_alcoma.pdf)

## Stability for arbitrary colorings of the complete graph

If a sequence of arbitrary \(n\)-colorings of \(K_n\) has \(R\le(1/8+o(1))n^3\), then deleting \(o(n^2)\) edges makes its **original labels proper**. Its color classes also satisfy \(\sum_c(m_c-E/n)^2=o(n^3)\), with unused colors of size zero.

Let \(W\) count equally colored incident edge pairs. Each gives \(n-3\) marks on cycles, so \(W\le4R/(n-3)=O(n^2)\). The number of monochromatic cycles is \(o(n^3)\). To see this, set \(D_0=n^{2/3}\). In a cycle with a vertex of degree at most \(D_0\) in its color class, take an opposite pair containing that vertex. Over all color classes the sum of common-neighbor counts of unordered pairs is \(W\). For a pair containing such a vertex the number of choices of its two common neighbors is at most \(D_0\) times its common-neighbor count. This bounds the low-degree cycles by \(O(D_0W)\). Over all colors the sum of squared vertex degrees is \(2W+2E=O(n^2)\). Thus there are \(O(n^2/D_0^2)\) vertex-color pairs of higher degree. The fourth power of this number bounds cycles wholly among these pairs. Both estimates give \(O(n^{8/3})\).

The total number of opposite repetitions on all cycles is \(2(P-W)\). The number of bad cycles with fewer than two such repetitions is at most \(2R-2(P-W)=o(n^3)\), since \(P\ge(1/8-o(1))n^3\) and \(W=O(n^2)\). A cycle with two opposite repeats and an adjacent repeat is monochromatic. Therefore all \((n-3)W\) incident-repeat marks lie on \(o(n^3)\) cycles, with at most four marks per cycle. This gives \(W=o(n^2)\). Delete one edge from every originally conflicting pair, choosing an edge only if both still survive. Finally \(P\le R+W\) implies the claimed variance bound by expansion.

The C checker tests all 729 three-colorings of \(K_4\) and of \(K_{2,3}\), both binary constructions through 128 vertices, and the commutator identity on round-robin one-factorizations at every even order from 4 to 32 and on the corresponding binary controls. Build and run it with a C11 compiler. [C source](check_complete.c)
