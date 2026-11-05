# Overnight pass 1: affine subclasses and the remaining support problem

15 October 2026. Two conditional vanishing-density results have complete
hand proofs and independent audits. They are applications of existing
group-table and Roth theorems; originality of the affine formulations is
unverified. There is no Lean certificate.

The unrestricted bound remains
\(M(N)\leq(0.2984440375\ldots+o(1))N^2\). Neither a universal improvement
below \(N^2/4\) nor \(M(N)=o(N^2)\) has been proved.

## 1. Affine colors with a slowly growing number of omissions

Let both vertex classes be labeled by a finite field of order \(n\).
Suppose every color is a restriction of an affine permutation
\(x\mapsto ax+b\), and every color omits at most \(r\) of its \(n\)
possible edges. If every \(C_4\) is rainbow and \(n>4r+1\), then
\[
m\leq C(r+1)n^2\exp[-c(\log n)^{1/12}]
\]
for absolute positive constants. In particular,
\[
\log(r+1)=o((\log n)^{1/12})\quad\Longrightarrow\quad m=o(n^2).
\]
Here \(n\) is the size of each side, so the total graph has \(2n\)
vertices.

The elementary structural inequality is
\[
d\leq(r+1)L,
\]
where \(d\) is the number of color lines and \(L\) is the largest number
in a parallel or concurrent pencil. At a point incident with \(t\)
color lines, at least \(t-1\) colored incidences must be omitted.
Counting nonparallel line pairs through these points, and parallel
pairs separately, proves the inequality.

The B condition supplies the additional step: a nontrivial identity
\(C=AB^{-1}A\) among color permutations would give a forbidden rectangle
for all but at most \(4r+1\) initial rows. Thus the palette is strongly
progression-free. Each pencil normalizes to an additive or
multiplicative group of the field, where an existing quantitative Roth
bound applies. The exponent is an input from the literature, not a new
Roth estimate.

Evidence:

- [Complete quantitative proof](pass1-affine-quantitative-audit.txt).
- [Independent quantitative audit](pass1-affine-quantitative-independent-audit.txt).
- [Pencil cover and exact incidence inequality](pass1-affine-bounded-deficit.txt).
- [Primary Roth input, Theorem 11.4](https://arxiv.org/html/2512.15125v1#S11.SS2).

This proves more than the initially targeted fixed-deficit statement,
but does not cover an arbitrary fixed positive support fraction.

## 2. Arbitrary supports for homogeneous affine palettes

Let \(H\leq\mathbb F_n^\times\) have size \(h\), and let an intercept
function satisfy
\[
\beta(ua)=u\beta(a)\qquad(u\in H,\ a\ne0).
\]
There is at most one color per slope \(a\), with actual edges an
arbitrary subset of \(x\mapsto ax+\beta(a)\). If every \(C_4\) is
rainbow, then
\[
h\longrightarrow\infty\quad\Longrightarrow\quad m=o(n^2).
\]
No lower bound on individual color supports is required.

This includes \(\beta(a)=a^s\) over \(\mathbb F_{s^k}\), as \(s\to\infty\),
with arbitrary extension degree \(k\). More generally it includes
every function homogeneous over a growing subfield, including
linearized polynomials.

The exact estimate is
\[
m\leq \left(\frac{n-1}{h}\right)^2 R_B(H)+\frac{n-1}{h},
\]
where \(R_B(H)=o(h^2)\) is the known extremal bound for a partial group
table on \(H\). Partition slopes into \(gH\). In one family,
\[
\sigma_{gu}(x)=u[gx+\beta(g)].
\]
Relabeling its rows therefore turns its colors into multiplication by
elements of \(H\). The nonzero rows and columns split into \(H\)-coset
blocks. Although the number of blocks grows, their total capacity is
\((n-1)^2\), so the uniform group-table estimate sums to \(o(n^2)\).

- [Complete theorem and block proof](pass1-affine-homogeneous-palette-theorem.txt).
- [Independent audit, weighted-cover corollary and its Sidon limitation](pass1-orbit-and-homogeneous-independent-audit.txt).
- The group-table input is
  [Solymosi, Theorem 5](https://arxiv.org/pdf/1309.0133).

The subgroup-block method is established prior work. This explicit
affine application is also a consequence of the previous uniform
small-difference theorem, applied separately to palette pieces and
summed with their sizes. It is a useful concrete subclass, not a new
general structural theorem.

The weighted version has a precise limit: a palette with all
nonidentity ordered quotients distinct cannot be covered by growing
subgroup cosets with total group order \(O(n)\), unless the palette
itself has \(o(n)\) elements. The quadratic example below has exactly
this obstruction. Thus the weighted corollary does not supply the
missing inverse theorem.

## 3. What the counterexamples now rule out

Two exact non-B constructions distinguish the new theorems from
insufficient global hypotheses.

- **Quadratic palette:** over odd prime fields, take
  \(\sigma_a(x)=ax+a^2\) with one representative of each antipodal pair.
  All nonidentity ordered quotients are distinct, so
  \(E(S)=2d^2-d\), the minimum possible. There are no nontrivial strong
  permutation progressions. Nevertheless a proper coloring can retain
  about \(3n/4\) edges per color and \(3n^2/8\) edges overall.
  An explicit nonrainbow square survives every choice used in the
  construction. Thus low energy, progression avoidance and heaviness
  together still do not encode B.
  [Proof](pass1-affine-global-relations-barrier.txt).
- **Frobenius palette:** over \(\mathbb F_{s^2}\), the maps
  \(ax+a^s\) give a properly colored complete bipartite graph with
  \((1-o(1))n^2\) edges, only \(\sqrt n+1\) omissions per color, and
  \(E(S)=O(n^{5/2})\). Any pencil cover needs order \(\sqrt n\) pencils.
  This disproves extending the bounded-pencil structural lemma to all
  sublinear deficits using properness alone. The graph is not B.
  The homogeneous-palette theorem now proves that any inherited B
  subgraph of this particular example retains only \(o(n^2)\) edges.
  [Construction and audit](pass1-affine-sublinear-deficit-barrier.txt).

For actions whose nonidentity four-letter words fix at most \(f=o(n)\)
points, the actual repeated-rectangle statistic satisfies
\[
R\leq fn d^3+n^2E(S)=o(n^5)
\]
for heavy B palettes with \(d=\Theta(n)\). This is below the input
threshold of the inspected Gowers–Long inverse theorem. An integral
positive-density abstract tensor also survives the two-sided Gram
constraints, the one-fixed-point bound, and the necessary first
moments. Actual partial-map realization remains missing.
[Complete fixed-point and integral-Gram audit](pass1-fixed-points-and-coherent-kernel.txt).

## 4. What the next pass should try

The general affine problem with arbitrary positive-density supports
remains unresolved. The quadratic palette has no growing subgroup of
scalar homogeneities, and its Sidon quotient property prevents large
subsets with bounded relative difference sets. It is a concrete place
where the new decomposition argument does not apply.

Do not rerun the palette energy calculation, finite graph searches,
ordinary colored removal, or the first two Gram relaxations. Useful
next questions are:

1. Can the actual B support conditions force sparsity for the quadratic
   family despite its absence of global permutation relations? Its
   exact reformulation is a coupled four-pair sum-product pattern,
   recorded in the affine literature audit.
2. Can actual partial-map composition force a decomposition with
   controlled total size, or a different density decrement, for
   palettes with no large low-difference subsets? Any claim must
   explain where the non-B quadratic example fails its hypotheses.
3. Can the slowly growing-deficit result be extended to all \(r=o(n)\)
   by using B itself? The Frobenius construction disproves a generic
   bounded-pencil claim, but its palette is now handled by small
   orbit blocks.

The primary-source search found no theorem resolving these questions.
See [affine literature audit](pass1-affine-literature.md) and
[bounded-deletion novelty check](pass1-bounded-deletion-novelty.md).
The separate [homogeneous-affine novelty check](pass1-homogeneous-affine-novelty.md)
identifies explicit prior coset-block arguments and preserves the
unverified-priority verdict for the affine formulation.
The remaining scheduled overnight passes should continue from these
specific gaps. This is an intermediate checkpoint, not the final
morning report.
