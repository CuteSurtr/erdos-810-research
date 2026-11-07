# Erdős #810: novelty audit and asymptotic multicolor constraints

15 October 2026. These are mathematical proofs with independent hand audits,
not Lean certificates. No finite graph search was used for the results below.

The useful outcome of this pass is a **vanishing-density theorem for partial
color matchings with bounded permutation-product complexity**, followed by
a stronger **vanishing multiplicative-energy obstruction**. Neither proves
the unrestricted conjecture. Historical novelty of the assembled statements
remains unverified.

## 1. What the novelty search established

Write \(M(N)\) for the largest edge count of a simple \(N\)-vertex graph with
at most \(N\) colors in which every four-cycle is rainbow. The previously
derived bound remains

\[
M(N)\leq(0.2984440375099955469\ldots+o(1))N^2.
\]

Its proof and exact polynomial checks are in the
[previous report](../asymptotic-2026-10-15/RESULTS.md).
This pass did not locate that coefficient, its profile recurrence, or a
stronger applicable universal coefficient in the primary literature inspected.
That supports calling it an independently derived candidate improvement;
it does **not** establish originality or a best-published record.

The full text of the closely related 2026 paper
[*Perfect proper edge colorings of regular bipartite graphs with rainbow C4-s*](https://doi.org/10.1016/j.disc.2026.115005)
remains an explicit gap. Its accessible abstract concerns perfect colorings,
but auxiliary observations in its body have not been checked.

Two tempting prior-work comparisons were resolved:

- The induced-matching threshold \(1/4\) concerns the size of each **induced**
  matching. A rainbow-\(C_4\) color class need not be induced, so that theorem
  does not supply a universal \(N^2/4\) bound here.
- The vanishing-density theorem for partial finite-group tables is already
  [Solymosi's Theorem 5](https://arxiv.org/pdf/1309.0133).
  It must not be presented as new.

The detailed search, sources, scope comparisons, and access limitations are
recorded in [novelty-followup.md](novelty-followup.md).

## 2. A theorem beyond constant-density improvements

Let a properly colored bipartite graph have every four-cycle rainbow.
Embed its two sides separately into the same \(n\)-element set \(\Omega\).
Each color matching can be extended to a permutation \(\sigma_c\) of
\(\Omega\): an original edge of color \(c\) has the form
\(x\mapsto\sigma_c(x)\).

The added edges of these permutations are only bookkeeping. We do **not**
assume that they form a rainbow-\(C_4\) coloring.

Let \(q\) be the number of original colors and let
\(S=\{\sigma_c:c\text{ is a color}\}\). The set

\[
SS^{-1}=\{\sigma_c\sigma_b^{-1}:c,b\text{ are colors}\}
\]

counts distinct relative permutations between pairs of colors.

**Theorem.** For fixed \(K\), if
\[
|SS^{-1}|\leq Kq,\qquad q\longrightarrow\infty,
\]
then
\[
\boxed{m=o(qn).}
\]

The conclusion is uniform over the graph, the permutation extensions, and
the ambient permutation group. It permits partial matchings, unequal color
sizes, and initially identical extensions for different colors.

For the scale relevant to #810, we also prove directly:

\[
\boxed{
N\text{ vertices},\quad q=O(N),\quad |\Omega|=O(N),\quad
|SS^{-1}|=O(N)
\quad\Longrightarrow\quad m=o(N^2).
}
\]

This is stronger than assuming the whole generated group has order \(O(N)\).
Only products of two colors are controlled. In the stated class, the
conclusion eventually beats every positive constant multiplying \(N^2\).
For unrestricted colorings, the product-set hypothesis remains unproved.

### Why the partial-matching theorem works

The full proof is in
[partial-small-difference-theorem.txt](partial-small-difference-theorem.txt).
Its four substantive steps are:

1. **Extract colors with controlled products without losing density.**
   Discard small color classes and remove duplicate representing permutations
   at constant cost. Tao's small-product theorem covers the remaining palette
   by boundedly many translates of an approximate group \(A\). Choose a
   translate by the number of original edges its colors carry.
2. **Lift the partial graph to a dense local group table.**
   After normalizing that translate, its color permutations form \(U\subset A\).
   For a basepoint \(z\in\Omega\), put \((u^{-1},vu^{-1})\) in \(F_z\) whenever
   the original color-\(v\) edge exists at \(u^{-1}z\). The exact identity
   \[
   \sum_{z\in\Omega}|F_z|=|U|m'
   \]
   supplies a dense \(F_z\subset A\times A^2\).
   A repeated-color square in the lift gives one in the original graph.
   If projection collapses its vertices, uniqueness of the original edge's
   color instead forces the lifted vertices to coincide—a contradiction.
3. **Find commuting cubes inside an approximate group.**
   The full BGT structure theorem supplies a large coset nilprogression
   inside \(A^4\). Either its finite subgroup has a large abelian subgroup,
   or a long progression direction supplies powers of one element.
   In either case, every fixed-dimensional commuting cube can be placed
   inside \(A^4\), with no nonempty subset product equal to the identity.
4. **Force a forbidden square by density Hales–Jewett.**
   Average two cube shifts over explicitly bounded powers of \(A\).
   A four-letter combinatorial line produces
   \[
   (x,y),\ (xt,y),\ (x,yt),\ (xt,yt),\qquad t\ne1.
   \]
   The group-table colors of the diagonal entries agree because
   \((yt)(xt)^{-1}=yx^{-1}\).

The structural inputs are established results:
[Tao, Theorem 4.6](https://arxiv.org/pdf/math/0601431),
[Breuillard–Green–Tao, Theorem 2.10](https://arxiv.org/pdf/1110.5008),
[Erdős–Straus, Theorem 1.1](https://www.renyi.hu/~p_erdos/1975-16.pdf),
and [density Hales–Jewett](https://annals.math.princeton.edu/2012/175-3/p06).
The qualitative proof requires no conjecture or recent informal proof sketch.

## 3. Pushing further: large color classes have vanishing global energy

The product-count theorem can be strengthened. Fix \(\eta>0\). Suppose \(d\)
chosen colors each have at least \(\eta n\) original edges, and their chosen
extensions are pairwise distinct. Set \(S=\{\sigma_1,\ldots,\sigma_d\}\).
Define

\[
E(S)=
\#\{(a,b,c,e)\in S^4:ab^{-1}=ce^{-1}\}.
\]

**Theorem.** Uniformly as \(d\to\infty\),
\[
\boxed{E(S)=o(d^3).}
\]

There is no bounded-doubling hypothesis in this statement. It is a necessary
constraint on every such rainbow-\(C_4\) coloring.

Proof: positive normalized energy would, by
[Tao's noncommutative BSG theorem, Theorem 5.4](https://arxiv.org/pdf/math/0601431),
put a positive fraction of \(S\) in one translate of an approximate group
of size \(O(d)\). Each selected color still carries \(\eta n\) original
edges. The same basepoint lift would give a dense local group table,
contradicting the square lemma above.

Cauchy–Schwarz then gives
\[
|SS^{-1}|\geq\frac{d^4}{E(S)},\qquad
\frac{|SS^{-1}|}{d}\longrightarrow\infty.
\]
The energy conclusion is stronger than product-set growth: it also excludes
a positive fraction of the products concentrating on a small set.

The full proof and its consequences are in
[multiplicative-energy-obstruction.txt](multiplicative-energy-obstruction.txt).
Both independent auditors found no gap.

## 4. The remaining obstacle is now precise

For \(x\in\Omega\), count coincidences only at that vertex:
\[
E_x(S)=
\#\{(a,b,c,e)\in S^4:(ab^{-1})(x)=(ce^{-1})(x)\}.
\]
There are \(d^2\) ordered products and at most \(n\) possible images of \(x\),
so
\[
E_x(S)\geq d^4/n.
\]

A hypothetical positive-density counterexample to #810 has, after discarding
small classes and duplicate extensions, \(d=\Theta(n)\) large color classes.
It must therefore satisfy simultaneously
\[
\boxed{E_x(S)=\Omega(d^3)\text{ for every }x,\qquad E(S)=o(d^3).}
\]

Thus almost all of the required coincidence mass must come from **different
global permutations agreeing at individual vertices**. An argument that
silently identifies those pointwise coincidences with global permutation
identities is invalid. The rainbow-\(C_4\) condition removes particular
repeated-color words but permits many four-color squares.

No result proved here bridges this gap. We have not proved a universal bound
below \(N^2/4\), nor \(M(N)=o(N^2)\). The earlier \(1/4\) obstruction concerns
the endpoint-moment method; it is not a construction disproving #810.

## 5. Other audited directions and validation

- For perfect matching colors in a solvable group, the progression-free
  palette argument and Schildkraut's results give an explicit saving under
  \(|SS^{-1}|\leq Kn\):
  \[
  m=O_K\!\left(n^2\exp[-c'(\log n)^{1/870}]\right).
  \]
  The exponent \(1/870\) follows by specializing his proof to solvable
  groups; it is an attributed deduction, not an asserted new theorem.
  See [local-roth-color-permutations.txt](local-roth-color-permutations.txt).
- A crossed-pair operator gives another conditional \(o(n^2)\) criterion.
  Its first color-level compression has only one negative aggregate
  direction, explaining why that calculation alone does not iterate into a
  contradiction. See [crossed-pair-operator.txt](crossed-pair-operator.txt).
- The direct local-square and partial-action proof was independently checked
  against the primary BGT and Tao statements. See
  [approximate-square-independent-audit.txt](approximate-square-independent-audit.txt).
- The energy argument received two independent checks, including its
  uniformity, heavy-class selection, and the orientation of its fixed-point
  identity. See [energy-independent-audit.txt](energy-independent-audit.txt).

No exact prior statement of the local approximate-group square theorem or
the partial-action corollary was located in the sources inspected. These
remain candidate formulations for further expert review. The universal
coefficient \(0.298444\ldots\) is unchanged by this pass.

## 6. Overnight follow-up: limits of the energy interpretation

The [next audit](../overnight-2026-10-15/formal-audit-energy-and-partial-kernel.txt)
shows that the local/global energy separation in Section 4 also occurs
in perfect colorings of complete bipartite graphs that fail B. Moreover,
adding an unused block permits essentially minimal global energy for
any partial proper coloring. The energy theorem above remains valid,
but low global energy alone supplies no contradiction to positive
density; a successful bridge must use the B condition beyond generic
pointwise coincidence counts.

The audit replaces completions with the actual partial-map agreement
kernel. Its overlap zeros encode B exactly. Even its two-sided Gram
positivity constraints admit a dense abstract model, leaving actual
composition and support compatibility as essential unresolved
information. The [overnight checkpoint](../overnight-2026-10-15/README.md)
records these proofs, a separate colored-removal obstruction, the
literature gaps, and concrete directions for continued work.

## 7. First scheduled continuation: concrete affine subclasses

The [pass 1 report](../overnight-2026-10-15/PASS1-REPORT.md) proves two
additional conditional applications with independent audits:

- For affine color completions omitting at most \(r\) points each,
  \(m\leq C(r+1)n^2\exp[-c(\log n)^{1/12}]\) when \(n>4r+1\).
  This gives vanishing density for a specified slowly growing range
  of \(r\).
- For affine palettes \(x\mapsto ax+\beta(a)\), arbitrary partial
  supports suffice if \(\beta(ua)=u\beta(a)\) for a multiplicative
  subgroup whose order tends to infinity.

These are deductions from known Roth and group-table inputs. The
second is also a weighted application of the small-difference theorem
above. Their exact historical priority remains unverified, and neither
changes the unrestricted coefficient or proves #810.

## 8. Second scheduled continuation: polynomial average defect

The [pass 2 report](../overnight-2026-10-15/PASS2-REPORT.md) strengthens
the affine result over prime fields. If \(D=dp-m\) is the total number
of missing colored incidences, it proves
\[
m\le Cp(D+1)^{7/11}+8D+
Cp^2\exp[-c(\log p)^{1/12}].
\]
Thus average defect \(D/d=o(p^{4/7})\) forces \(m=o(p^2)\).
Actual missing supports bound all determined-line incidences of the
dual palette; a Stevens–de Zeeuw incidence argument then leaves a
large pencil, which the B condition and Roth exclude.

The complete proof has independent hand audits and primary-source
checks. It is an application of existing inputs with unverified
historical priority. Arbitrary positive support fractions, including
the quadratic palette test case, remain unresolved. The pass also
records why a slope-progression-only argument and a particular
commuting linearization do not resolve that gap.

## 9. Third scheduled continuation: all sublinear affine deficits

The [pass 3 report](../overnight-2026-10-15/PASS3-REPORT.md) strengthens
the prime-field affine theorem again, using
[Lewko's recent incidence preprint, Theorem 1](https://arxiv.org/html/2609.27023v3):
\[
m\le Cp\sqrt{D+1}+8D+
Cp^2\exp[-c(\log p)^{1/12}].
\]
Consequently average missing class size \(D/d=o(p)\) forces
\(m=o(p^2)\). The improvement comes from a stronger Beck dichotomy
for the dual palette. Our deduction has independent hand audits.
The primary proof, actual Lean statements, and matching source hashes
were inspected; the external Lean build was not rerun. This is an
attributed application of a recent preprint, with no established
historical priority for our corollary.

The pass also identifies a cubic phase identity that defeats four-slot
counting based only on uniform color, row, and column marginals, even
for four supports sharing a proper orientation. It classifies the
low-degree formal polynomial identities and proves two scoped
representation obstructions. These do not refute the common-support
removal target or produce a counterexample to #810.

At the end of Pass 3, arbitrary fixed support fractions remained
unresolved even in the narrower quadratic common-row-mask class.
The next section resolves that common-support subclass.
There is still no new universal coefficient or unrestricted
vanishing-density theorem.

## 10. Fourth scheduled continuation: arbitrary common affine supports

The [pass 4 report](../overnight-2026-10-15/PASS4-REPORT.md) proves
vanishing density for affine colors \(x\mapsto ax+\beta(a)\), with
one color per nonzero slope, whenever all colors share any row set
\(X\), or omit only \(o(p^2)\) incidences in total from \(A\times X\).
The intercept function may be arbitrary. For exactly common supports,
the quantitative bound is
\[
m\ll p^2\exp[-c(\log p)^{1/12}].
\]
For a nonlinear polynomial intercept of fixed degree \(D\), the
stronger estimate is
\[
m\le C_Dp^{19/10}+\sqrt2\,p\sqrt R,
\qquad R=\sum_a|X\setminus D_a|.
\]
Nested or interval domains also admit a power saving in that
polynomial class.

The new transfer acts on edge positions using crossed involutions.
The B condition controls actual internal transitions, and a Fourier
fourth-moment estimate retains all palette tests. The qualitative
arbitrary-intercept argument uses published Weil, PRRW affine-energy,
and Solymosi group-table theorems; the explicit common-support rate
also uses Roth. It does not depend on the recent incidence preprint
used in Pass 3.

Complete proofs, independent hand audits, primary-source checks,
and a Behrend obstruction to any uniform power saving for arbitrary
intercepts are linked in the report. Originality is unestablished,
and no Lean certificate is claimed. Unrelated partial supports,
general permutation colors, and unrestricted #810 remain open.

## 11. Fifth scheduled continuation: color-dependent support structure

The [pass 5 report](../overnight-2026-10-15/PASS5-REPORT.md) proves
\(m=o(p^2)\) for affine colors with arbitrary intercepts and one color
per nonzero slope, when their actual row domains have uniformly bounded
VC dimension. The same conclusion holds if the color–row support
bigraph omits any fixed induced bipartite pattern, or is within
\(o(p^2)\) edits of such a family. These qualitative results have no
explicit rate. They extend the common-support results using established
Lovász–Szegedy graphon structure and Adams–Nobel finite bracketing.

A separate support-weighted Fourier argument proves
\[
m\le C_Dp^{47/24}W^{2/3},\qquad
W=\sum_k\sup_a|\widehat{1_{D_a}}(k)|,
\]
for polynomial intercepts of fixed degree \(D\ge2\). Thus
\(W=o(p^{1/16})\) forces vanishing density. A concrete application
allows domains defined by color-dependent intervals along a shared list
of frequencies whose length \(r\) grows with \(p\), provided
\(\limsup r\log\log p/\log p<1/16\).

The report also extends the common-support theorem to arbitrary common
row-and-column eligibility, and permits repeated slopes under a stated
weighted slope-energy condition. An explicit proper quadratic example
rules out treating arbitrary masks by a uniform \(o(p)\) lower-spectrum
estimate; it is not B and does not refute an actual-edge-specific
argument.

Complete proofs, independent audits, primary-source checks, limitations,
and the next exact phase target are linked in the report. These are
restricted representation/support classes, not a representation theorem
for arbitrary #810 graphs. Historical originality remains unverified,
and there is no Lean certificate. Arbitrary affine supports and the
unrestricted problem remain unresolved; the universal coefficient is
unchanged.
