# Erdős #810: asymptotic results and novelty audit

15 October 2026. Written mathematical proofs with independent adversarial
checks. These general theorems are **not Lean formalized**. No finite graph
search is used below. Publication priority and best-published status have
not been established.

Let \(M(N)\) be the maximum edge count of a simple graph on \(N\) vertices,
colored with at most \(N\) colors, such that **every** four-cycle is rainbow.
Properness is not required. Erdős #810 asks whether \(M(N)=o(N^2)\).

## Main result

The direct asymptotic argument developed and audited here gives

\[
\boxed{M(N)\leq(0.298444037510\ldots+o(1))N^2.}
\]

This is an independently derived bound. We have not certified that it
improves the best published bound: the full text of the related 2026 paper
on perfect B-colorings remains unavailable in the sources checked. The
bound does **not** establish \(o(N^2)\).

The factor-three reduction then gives a concrete hypergraph consequence:

\[
\boxed{g(N)\leq(0.0994813458367\ldots+o(1))N^2,}
\]

where \(g(N)\) is the maximum size of a 3-uniform hypergraph in which every
four distinct triples span at least eight vertices. In particular,
\(g(N)<N^2/10\) for all sufficiently large \(N\).

Two structural results accompany the density bound:

1. Every rainbow-\(C_4\) coloring becomes proper after deleting \(o(N^2)\)
   edges, uniformly in the number of colors.
2. There are proper rainbow-\(C_4\) examples with \(N^{2-o(1)}\) edges and
   at most \(N/2\) colors for which every inherited C-colored subgraph keeps
   only \(o(|E|)\) edges. Here C additionally forbids an alternating two-color
   path with four edges. Fixed bounded splitting of colors or vertices
   does not repair this obstruction.

The second result concerns a retained fraction of the input edges. Its
examples have vanishing quadratic density. It does not rule out a reduction
assuming \(|E|\geq\varepsilon N^2\) for a fixed \(\varepsilon>0\).

## Novelty verdict on the original claims

Write \(g_{\rm lin}(N)\) for the version of \(g(N)\) restricted to linear
hypergraphs.

| Claim | Audit verdict |
|---|---|
| A reduction from the (7,4) hypergraph problem to #810 | Explicitly known in Burr–Erdős–Graham–Sós (1989), pp. 272–273. |
| \(M(N)\geq3g_{\rm lin}(N)\), using the entire shadow | Exact coefficient not located. A short strengthening of a known projection construction; originality unestablished. |
| \(M(N)\geq3g(N)-2\lfloor N/4\rfloor\), \(N\geq5\) | Exact extremal replacement bound not located. Its overlap decomposition has direct prior art in Füredi (2012). |
| Sharp deletion loss \(2\lfloor N/5\rfloor+\mathbf1_{N\bmod5=4}\), \(N\geq5\) | A rounding/packing refinement of Füredi's published \(2N/5\) argument. |
| Natural shadow B-coloring versus 2-cancellativity | A useful reformulation of published forbidden configurations; the central classification is known. |

The improved nonlinear correction replaces an extremal hypergraph. It does
not say that every input hypergraph has a linear subfamily after deleting
only \(\lfloor N/4\rfloor\) triples. Both additive corrections disappear
after division by \(N^2\).

The primary sources are
[BEGS (1989)](https://fanchung.ucsd.edu/ron/papers/89_04_maximal_antiramsey.pdf),
[Füredi (2012)](https://iuuk.mff.cuni.cz/~samal/DS/S0963548311000563a.pdf), and
[Gyárfás–Sárközy (2023)](https://real.mtak.hu/191892/1/012-article-p109.pdf).
The detailed comparison and literature gaps are in [novelty.md](novelty.md).
The original reduction proofs are in
[shadow-extraction-proof.txt](../research-2026-10-14/shadow-extraction-proof.txt).

## Exact statement of the density theorem

Define \(C_*>1\) and \(\alpha_*\) by

\[
9C_*^4+32C_*^3+13C_*^2-45C_*-36=0,
\qquad \alpha_*=\frac1{1+C_*}.
\]

There is exactly one such root. Let \(\rho_*\) be the unique root in
\([0,1/2]\) of

\[
4(1+\alpha_*)\rho_*^3-2(1+\alpha_*)\rho_*^2-3\rho_*+1=0.
\]

Then

\[
\limsup_{N\to\infty}\frac{M(N)}{N^2}\leq\rho_*.
\]

Exact rational sign certificates give

\[
\begin{aligned}
1.18541655912282415&<C_*<1.18541655912282417,\\
0.29844403750999554&<\rho_*<0.29844403750999556.
\end{aligned}
\]

Thus \(M(N)\leq0.298445N^2\) for all sufficiently large \(N\). No useful
explicit threshold for “sufficiently large” is supplied.

### Properification

Pack an inclusion-maximal family of edge-disjoint monochromatic two-edge
paths \(u-v-w\). Each pair \(u,w\) has \(v\) as its unique common neighbor:
another one would close a non-rainbow four-cycle.

On three copies of the vertex set, turn each packed path into a triangle
\(u_Av_Bw_C\). These triangles are edge-disjoint. Every triangle in the
auxiliary graph is one of them: its \(A\)-\(C\) edge specifies a packed
endpoint pair, and its \(B\) vertex must be that pair's unique common
neighbor. Thus there are \(O(N^2)\) triangles and no additional triangles.

The triangle-removal lemma forces the packing size to be \(o(N^2)\).
Deleting both legs of each packed path leaves a proper coloring by
maximality. This argument does not depend on the palette size. Its external
input is classical
[triangle removal](https://annals.math.princeton.edu/2011/174-1/p17).

### Endpoint counting

Call a proper rainbow-\(C_4\) coloring a B-coloring. In a bipartite B-colored
graph with parts of sizes \(A,B\), a color matching of size \(K\) spans at
most \(K(K+1)/2\) edges among its endpoints: two matching edges cannot
have both cross edges. Summing endpoint degree bounds gives

\[
\sum_vd(v)^2+\sum_cK_c^2\leq(A+B+1)E.
\]

If at most \(q\) colors are available, Cauchy–Schwarz yields

\[
E\leq\frac{qAB(A+B+1)}{q(A+B)+AB}.
\]

In a general B-colored graph, a matching of size \(K\) spans at most
\(K^2\) edges among its \(2K\) endpoints. Its endpoint degree sum is at
most \(2K^2\) plus the number of edges from those endpoints to the rest of
the graph. Applying the bipartite bound to this cut already improves the
elementary coefficient \(1/3\) to \((\sqrt5-1)/4\).

### A recursion that retains the sizes of smaller rectangles

Keep the same available palette of size \(N\) in every cut and subcut,
including unused colors. Set \(a=A/N,\ b=B/N,\ s=a+b\leq1\), and define

\[
F_C(a,b)=\frac{ab\,s}{s+ab\left(1+\frac{s}{1+Cs}\right)},
\qquad C\geq1.
\]

The base inequality followed by one endpoint decomposition proves

\[
E\leq N^2F_{19/9}(a,b)+o(N^2)
\]

uniformly over the graph and part sizes. The recursive step replaces any
valid parameter \(C\) by

\[
K(C)=\frac{19C^3+75C^2+93C+36}{9C^3+51C^2+88C+48}.
\]

To prove it, split each color's endpoint degree sum into an internal
rectangle and two smaller rectangles. Apply the previous bound to those
two rectangles, followed by Jensen and Cauchy–Schwarz. All needed
concavity statements hold over their whole domains. The last scalar
inequality has an exact polynomial positivity certificate.

Starting at \(C_0=19/9\), the sequence \(C_{j+1}=K(C_j)\) decreases to
\(C_*\). Each fixed iteration has a uniform \(o(N^2)\) error. Take
\(N\to\infty\) first and \(j\to\infty\) second; no uniformity in the iteration
count is assumed.

For a color matching of normalized size \(x=K/N\) in a general graph,
write \(z=2x(1-2x)\). Its normalized endpoint degree sum is at most

\[
h(x)=2x^2+\frac{z}{1+(1+\alpha_*)z}+o(1).
\]

The function \(h\) is concave on \([0,1/2]\). Sum over \(N\) colors, use
Jensen, and compare with \(\sum_vd(v)^2\geq4E^2/N\). Every limiting density
\(\rho=E/N^2\) satisfies \(4\rho^2\leq h(\rho)\). Rearrangement gives the
cubic inequality defining \(\rho_*\). Properification transfers the result
to colorings that were not initially proper.

The complete derivations are
[recursive-density-bound.txt](recursive-density-bound.txt) and
[profile-density-bound.txt](profile-density-bound.txt). The former proves
the intermediate coefficient \(0.2992250288\ldots\); the latter proves the
strongest bound above. The algebra checker is
[check_profile_polynomial.py](check_profile_polynomial.py), with output in
[profile-polynomial-certificate.json](profile-polynomial-certificate.json).
These checks verify identities and root intervals, not the whole
combinatorial proof.

### Consequence for the (7,4) problem

Combining \(M(N)\leq(\rho_*+o(1))N^2\) with
\(M(N)\geq3g(N)-O(N)\) gives \(g(N)\leq(\rho_*/3+o(1))N^2\).
Even Füredi's older \(2N/5\) linearization loss suffices; the improved
additive correction is unnecessary at this scale.

There is a verified published benchmark: a linear (7,4)-free hypergraph is
sail-free. The [linear Turán theorem for the sail, Theorem 3](https://www.renyi.hu/~gyarfas/Cikkek/191_amm.pdf)
gives \(g(N)\leq N^2/9+O(N)\) after linearization. The new derivation's
coefficient \(\rho_*/3=0.0994813458367\ldots\) is smaller than \(1/9\).
This comparison does not certify that the sail theorem gives the best
previously known bound for (7,4).

## Obstruction to a stronger extraction theorem

Take an odd cyclic group \(\mathbb Z/Q\mathbb Z\) and a nontrivial
three-term-progression-free set \(S\). Between two copies of the group,
include \(xy\) when \(y-x\in S\), coloring the edge by \(y-x\).
The coloring is proper. A repeated color on a four-cycle would give
\(b+c=2a\) in \(S\), so every four-cycle is rainbow. Any two different
color matchings form even cycles of length at least six, hence contain an
alternating two-color four-edge path.

In tensor powers, edges are words over the finite alphabet of base edges.
A combinatorial line gives a color-preserving copy of the whole base graph.
By [density Hales–Jewett](https://annals.math.princeton.edu/2012/175-3/p06),
every fixed positive fraction of the edges contains the forbidden path in
sufficiently large tensor dimension.

An elementary sphere construction provides progression-free sets of size
\(Q^{1-o(1)}\). A diagonal choice of group orders and dimensions gives
graphs with \(N^{2-o(1)}\) edges and at most \(N/2\) colors, while every
inherited C-colored subgraph has \(o(|E|)\) edges. Bounded color or vertex
splitting is handled by partitioning retained edges by the extra indices.

The full proof, including quantifiers and the sphere construction, is in
[near-quadratic-extraction-barrier.txt](near-quadratic-extraction-barrier.txt).
This particular use of standard tools has not been certified historically
new. The construction does not rule out reductions under a fixed positive
quadratic-density hypothesis.

## Where the endpoint method stops

The current scalar inequalities cannot by themselves prove vanishing
density. Their leading-order constraints admit the formal bipartite profile

\[
F(a,b)=\tfrac12ab.
\]

Its endpoint integrand is

\[
x^2+\tfrac12x(a-x)+\tfrac12x(b-x)=\tfrac12(a+b)x,
\]

and the degree-square inequality is attained at \(E/N^2=ab/2\). In the
general-graph step this profile gives \(h(x)=x\), allowing \(\rho=1/4\).

This is a feasible **abstract moment model**, not a graph construction or
a counterexample to #810. It identifies missing information: correlations
between different color matchings and the nonedges they force. See
[endpoint-method-moment-barrier.txt](endpoint-method-moment-barrier.txt).

A concrete next target is a reduction for \(|E|\geq\varepsilon N^2\) with
a retained fraction depending on \(\varepsilon\). The tensor construction
does not exclude it. Alternatively, an upper-bound argument needs
additional constraints involving several color classes simultaneously.
Neither step is proved here.

## Verification record

- Two mathematical auditors independently checked properification,
  endpoint counting, concavity, uniform errors, and transfer to the
  original problem.
- The profile polynomial was independently expanded with exact integer
  arithmetic; rational signs certify the root intervals.
- The tensor obstruction and its near-quadratic amplification were
  separately checked, including bounded color and vertex splitting.
- Primary sources were inspected for prior results. No exact match for the
  final bound was found, but originality and best-published status remain
  unverified.
- All ten original Gemini input files still match their recorded SHA-256
  hashes. They were not replaced by these research notes.
