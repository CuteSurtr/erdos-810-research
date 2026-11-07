# Overnight continuation 2 — 15 October 2026

This pass establishes a stronger **conditional asymptotic result for affine
colors over prime fields**. It does not solve Erdős #810, change the universal
coefficient \(0.298444\ldots\), or establish historical novelty.

## Verified advance: polynomial average defect

Let a properly colored bipartite graph on two copies of \(\mathbb F_p\) have
every \(C_4\) rainbow. Suppose every color is a restriction of a nonconstant
affine permutation \(x\mapsto ax+b\). If there are \(d\) original color labels
and \(m\) actual edges, define the total missing colored incidences by
\[
D=\sum_c(p-|E_c|)=dp-m.
\]
Repeated affine completions are permitted in this definition.

There are absolute constants \(C,c>0\) such that
\[
\boxed{\quad
m\le Cp(D+1)^{7/11}+8D+
Cp^2\exp[-c(\log p)^{1/12}].
\quad}
\]
Consequently,
\[
D=o(p^{11/7})\quad\Longrightarrow\quad m=o(p^2).
\]
The same conclusion holds if the **average** missing size \(D/d\) is
\(o(p^{4/7})\), and therefore if every color misses at most
\(r=o(p^{4/7})\) points. This replaces pass 1's stretched-log permitted
defect by a polynomial range over prime fields.

The [complete proof](pass2-prime-field-average-defect.txt) and
[independent audit](pass2-prime-affine-deficit-independent-audit.txt)
include all cardinality restrictions, missing-edge tests, and
characteristic conditions. The root reviewer also checked the three
incidence ranges, geometric sums, pruning, duplicate exclusion, and the
normalizations of the pencils. These are hand proofs, not Lean certificates.

The proof uses the actual selected edges:

1. Delete colors missing at least \(p/8\) edges, losing at most \(8D\)
   actual edges. The surviving completions are distinct, with fewer than
   \(8p/7\) colors.
2. Dualize each affine line \(y=ax+b\) to \((a,b)\). An original point on
   \(t\) completed lines costs at least \(t-1\) omissions. Thus the total
   incidences of the dual palette with **all its determined lines** are
   at most \(2D+d\).
3. An adaptation of the dyadic proof of Stevens–de Zeeuw's Beck
   corollary gives a dichotomy: a fixed positive fraction of the dual
   points are collinear, or those incidences number at least
   \(c_0d^{11/7}\). The latter implies \(d=O((D+1)^{7/11})\).
4. In the former case, the original lines form a large parallel or
   concurrent pencil. The four-edge missing-support test makes its
   normalized palette progression-free. The previously checked
   quantitative Roth bound gives the exponential term above.

The qualitative proof also works by excluding a large pencil using
Solymosi's arbitrary-support group-table theorem. It reaches the same
defect threshold without needing the quantitative Roth estimate.

This is an application of published incidence and Roth/group-table
results. The geometric dichotomy is a standard adaptation of the
published Beck proof, not a claimed new incidence theorem.
The [primary-source novelty audit](pass2-prime-defect-literature.md)
found no exact prior formulation or verified better applicable exponent,
but it does not establish priority or best-published status.

The restriction remains substantial. This does not cover arbitrary
positive support fractions, all average defects \(o(p)\), extension
fields in small characteristic, or general color permutations.
In particular, for a quadratic palette with linearly many slopes,
properness alone already forces a linear average defect. The theorem
therefore does not settle that harder arbitrary-support test case.

## Quadratic supports: a constraint and two failed shortcuts

For \(\sigma_a(x)=ax+a^2\), and an antipodal-free slope palette \(A\), write
\(T(A)\) for its nontrivial additive three-term progressions, identifying
the two orientations of each progression. A repeated-color square from
\(a-t,a,a+t\) uses rows \(-t,t\). All four positions are unique to their
palette lines; each colored incidence belongs to at most two such squares.
Thus, writing \(d=|A|\),
\[
m\le dp-\binom d2-\tfrac12T(A).
\]
The [proof](pass2-quadratic-arithmetic-support-constraint.txt) includes
the elementary Varnavides argument showing \(T(A)\ge c_\delta p^2\)
when \(|A|\ge\delta p\). This locates an additional loss in actual
supports, beyond the intersection loss required by properness.

It does **not** imply vanishing density. An
[explicit family](pass2-quadratic-arithmetic-progression-obstruction.txt)
has \((3/32+o(1))p^2\) edges, linearly many colors each on at least
\((1/4+o(1))p\) rows, and avoids every one of these progression templates.
It is not B: the note gives another repeated-color square present
throughout the family. An ordinary Roth argument on slope triples alone
therefore cannot resolve arbitrary supports.

A proposed commuting linearization also fails as a reduction. The maps
\[
M_a(x,t)=(ax+a^2t,at),\qquad t\ne0,
\]
become translations by \((a,a)\) in
\((\mathbb F_p,+)\times(\mathbb F_p^*,\cdot)\). This is a classical Sidon
palette. Its complete graph is already \(C_4\)-free, independently of
the original supports. The [independent audit](pass2-commuting-linearization-obstruction.txt)
shows both that density falls by a factor \(p-1\), and that no fixed
right-vertex projection compatible with the natural left projection
recovers a dense original graph. Algebraically commuting formulas have
not provided an equivalent graph representation.

## Next concrete step

The remaining quadratic target is a theorem for **four simultaneous
marked root pairs**, not another count of unmarked coincidences. Put
\[
R\subset\mathbb F_p^*\times\mathbb F_p,\qquad
(a,b)\leftrightarrow (x,y)=(-a-b,-ab).
\]
The needed configurations have
\[
(a,b),(a,c),(d,e),(f,g)\in R,\qquad
a+b=d+e,\ ac=de,\ a+c=f+g,\ ab=fg.
\]
For proper supports, a nondegenerate solution is exactly a forbidden
repeated-color rectangle. A uniform removal theorem for this system,
at its \(p^3\) solution scale with \(o(p^2)\) pair deletions, would suffice.
That theorem has **not** been proved or found in the literature inspected.
The [exact conditional reduction](pass2-quadratic-removal-target-audit.txt)
checks the diagonal solutions and degeneracies.

The [targeted literature audit](pass2-targeted-literature.md) records why
the rational Roth, algebraic regularity, sum-product spectrum, and general
configuration-removal papers do not yet supply that missing statement.
Future work should try an exact hypergraph representation or a counting
argument for this system, with its actual four support tests. Do not
repeat the slope-AP-only or commuting-encoding shortcuts.

## Unchanged status and operation

- No unrestricted \(o(N^2)\) theorem or bound below \(N^2/4\) was proved.
- The audited universal \(0.298444\ldots\) coefficient still has
  unverified historical novelty and record status.
- The 2026 perfect-B paper remains an uninspected full-text gap.
- Original Gemini artifacts were preserved. No publication, external
  messages, or author contact occurred.
- This is completed scheduled pass **2 of 8**. The existing overnight
  schedule remains in place; the consolidated morning report is still due.
