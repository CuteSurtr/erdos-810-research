# Coloring an additive table from the 17 octagon coordinates

The same 17 points project to a rainbow-four-cycle graph on **152 vertices** with **1,292 edges**, using **76 colors**. Among all finite abelian targets, 76 is the exact minimum group size for the construction below with these coordinates and an arbitrary additive endomorphism. If the endomorphism must be an integer scalar, the minimum is 77. In the other construction that labels each edge by its shift, the minimum is 285 and the graph uses only 17 colors. [Pinned coordinates](octagon-anchor.json) · [Exhaustive search and graph checks](check_square_quotients.py) · [Shift-color construction](quotients.md)

## Opposite edges and four-term progressions

Let \(G\) be a finite abelian group of order \(m\), \(S\subseteq G\), and \(f:G\to G\) an additive endomorphism. Use one copy of \(G\) for each side of a bipartite graph. Keep the edge \((x,y)\) exactly when \(x+f(y)\in S\), and color it \(x+y\). There are \(m|S|\) edges, since each column has \(|S|\) neighbors, and at most \(m\) colors.

Every four-cycle is rainbow if and only if for every \(h\ne0\) there is no \(z\) with
\[
 z,\qquad z+h,\qquad z+f(h),\qquad z+h+f(h) \quad\text{all in }S.
\]
Indeed, adjacent cells in a rectangle always have different colors. If two opposite colors agree, orient its rows and columns so that \(x+(y+h)=(x+h)+y\) with \(h\ne0\). Its four support tests give the displayed shape with \(z=x+f(y)\). Conversely every such shape occurs with rows \(z,z+h\) and columns \(0,h\). This includes torsion, even when some displayed values coincide. Lean checks the equivalence for every abelian group. [Formal proof](../hall-reduction/SumColorSquares.lean)

For \(f(h)=2h\) the four values are a four-term arithmetic progression. Let \(r_4([L])\) denote the largest size of a four-term-progression-free subset of \(\{0,\ldots,L-1\}\), and \(M(n)\) the #810 maximum using \(n\) colors. For each \(m>2(L-1)\) the construction gives
\[
 M(2m)\ge m\,r_4([L]),\qquad M(4m)\ge4m\,r_4([L]).
\]
For the first inequality embed the integer set into \(\mathbb Z/m\). The second differences of four representatives in this interval have absolute value at most \(2(L-1)<m\). If the representatives are a modular progression the two second differences therefore vanish as integers, and a nonzero group step forces a nonconstant integer progression. For the second inequality double every vertex and label each edge by its group color and its two copy indices. A projected rectangle with distinct base rows and columns is rainbow. If a base row or column repeats, properness distinguishes different base cells, and the copy labels distinguish equal ones. The doubled graph has \(4m\) vertices and at most \(4m\) colors.

Four-term-progression-free sets and their relationship to this extremal question have a long history. Burr, Erdős, Graham and Sós discuss \(r_4\) on printed page 273. The displayed finite factors here follow directly from the table above. Solymosi's finite-group theorem forces an opposite-color collision in every fixed-positive-density subset of sufficiently large group tables. Thus any density gain from the choice of \(S\) in this construction still tends to zero. [Burr–Erdős–Graham–Sós](https://fanchung.ucsd.edu/ron/papers/89_04_maximal_antiramsey.pdf) · [O'Bryant on progression-free sets](https://arxiv.org/abs/0811.3057) · [Solymosi, Theorem 5](https://arxiv.org/pdf/1309.0133)

## Minimum for the ES set

Project the integer coordinates by any affine homomorphism into the target \(G\), retaining all 17 distinct images as \(S\). A translation of \(S\) has no effect. The following graphs use the given color rule throughout. Doubling uses the two copy labels described above.

| Group | Copies | Vertices | Edges | Colors used | Rainbow four-cycles |
| --- | ---: | ---: | ---: | ---: | ---: |
| \(\mathbb Z_2\times\mathbb Z_{38}\) | 1 | 152 | 1,292 | 76 | 16,074 |
| \(\mathbb Z_{77}\) | 1 | 154 | 1,309 | 77 | 14,938 |
| \(\mathbb Z_2\times\mathbb Z_{38}\) | 2 | 304 | 5,168 | 304 | 341,164 |
| \(\mathbb Z_{77}\) | 2 | 308 | 5,236 | 308 | 324,093 |

At order 76, reduce the two integer coordinates modulo 2 and 38 respectively, and take \(f(u,v)=(u+v\bmod2,9v\bmod38)\). At order 77 use \(7x+3y\bmod77\) and \(f(h)=2h\). Both group maps from the coordinate lattice are onto. All four cycle counts in the table were obtained by enumerating pairs of rows and pairs of common columns and checking their four actual labels.

For completeness, every surjective projection has kernel with basis \((a,0),(b,c)\), where \(a,c>0\), \(0\le b<a\), and \(ac=|G|\). At orders through 77 there are 4,880 kernels and 356 retain 17 distinct points. For cyclic quotients every endomorphism is a scalar. The only successful scalar cases use \((a,b,c)=(11,8,7)\) and \(t\in\{2,38,39,75\}\) modulo 77. For all noncyclic quotients retaining 17 points there are 11,718 endomorphisms in total. They are exactly the possible images \(U,V\) of the coordinate generators satisfying \(aU=0\), \(bU+cV=0\). There are eight successes, all on the single kernel \((2,0,38)\). For every tested map, the checker compares direct shape detection with the intersection of the sets of starting points of pairs of difference \(h\). [Enumeration](check_square_quotients.py)

A projection can land in a proper subgroup \(H\) of its target. The first image retaining all 17 points has order 29. Thus for a target of order at most 77, a proper image has index two and order at most 38. There are precisely seven possible kernels in this range, all with cyclic image. Identify the generator of \(H\) with 1. Since \(2f(1)\in H\), write it as \(t\in\mathbb Z_{|H|}\). For *every* \(t\) in each of these seven cases the checker finds \(k,z\) with \(2k\ne0\) and \(z,z+2k,z+kt,z+k(2+t)\) all in the projected set. This is the forbidden shape with \(h=2k\) for any extension to the ambient group. It completes the minimum over targets, including maps whose image is not preserved by \(f\).
