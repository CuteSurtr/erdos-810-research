# Overnight continuation 3 — 15 October 2026

Scheduled trigger: 04:40 KST. This pass used analytic proofs, independent
audits, and primary literature; no finite graph enumeration.

**The positive result is a stronger conditional vanishing-density theorem:
prime-field affine color classes with average missing size \(o(p)\) have
\(o(p^2)\) edges.** This extends the previous \(o(p^{4/7})\) range by applying
a recent incidence theorem of Lewko. It is an attributed deduction with
unverified historical priority, not a new incidence theorem or a solution
of unrestricted #810.

The universal coefficient remains \(0.2984440375099955469\ldots\).
Its novelty and record status remain unverified. We still have no universal
bound below \(N^2/4\), and no proof of \(o(N^2)\) for arbitrary colorings.
Our new deductions have hand audits, not Lean certificates.

## 1. All sublinear average deficits for prime-field affine colors

Let a proper bipartite B graph have both sides \(\mathbb F_p\), where B means
that every four-cycle is rainbow. Suppose each of its \(d_0\) color
matchings is a restriction of a nonconstant affine permutation. Write
\[
D=d_0p-m
\]
for the total number of missing colored incidences. Initial repeated
completions and unequal class sizes are allowed.

Using Lewko's prime-field incidence theorem, we obtain absolute \(C,c>0\):
\[
\boxed{m\le Cp\sqrt{D+1}+8D+
Cp^2\exp[-c(\log p)^{1/12}].}
\]
Consequently
\[
D=o(p^2)\ \Longrightarrow\ m=o(p^2),
\qquad
D/d_0=o(p)\ \Longrightarrow\ m=o(p^2).
\]
The second implication does not assume \(d_0=O(p)\): properness gives
\(d_0(p-D/d_0)=m\le p^2\), which supplies that bound.

The [complete proof](pass3-conditional-prime-incidence-defect-upgrade.txt)
retains the earlier support accounting and replaces its incidence step:

1. Remove classes missing at least \(p/8\) edges, losing at most \(8D\)
   actual edges. The remaining distinct affine maps number \(d<8p/7\).
2. Their dual points have total determined-line incidence at most \(2D+d\):
   concurrence of \(t\) completed lines costs at least \(t-1\) actual
   missing incidences.
3. Lewko's estimate gives a Beck dichotomy: either a line contains a fixed
   fraction of the \(d\) points, or those incidences are \(\Omega(d^2)\).
   The latter case gives \(d=O(\sqrt{D+1})\).
4. A large dual line is a parallel or concurrent affine pencil. The
   retained supports make its palette progression-free, so the previously
   audited Roth input bounds its size by the exponential term above.

The deduction received two independent hand checks, including its dyadic
constants and the average-defect formulation. Its limitation is substantial:
it allows sublinear missing size, but not an arbitrary fixed missing
fraction. It therefore does not settle the quadratic arbitrary-support
test case.

### Source and novelty checks

[Lewko, Theorem 1, arXiv:2609.27023v3](https://arxiv.org/html/2609.27023v3)
states
\[
I(P,\mathcal L)\le
3(|P||\mathcal L|)^{2/3}+|P|+|\mathcal L|
+|P||\mathcal L|/p
\]
over the prime field, without an additional size hypothesis. This is a
very recent preprint, revised 7 October 2026.

The source audit read the full central proof and the linked Lean sources,
including the actual incidence statements and their hypotheses. No gap
was found in those checks. The author-hosted axiom and kernel-check logs
were inspected; we did **not** run a fresh build of that external
formalization. Those logs certify neither our affine corollary nor #810.
The [source audit](pass3-lewko-incidence-source-audit.md) records the
precise checks and preserves the inspected source files and logs.

No historical novelty claim is made for the assembled affine corollary.
The inaccessible full text of the related 2026
Gyárfás–Sárközy–Wagner paper remains a separate gap in the universal-bound
priority check.

## 2. A genuine obstruction to naive four-slot mixing

For the quadratic palette \(\sigma_a(x)=ax+a^2\), encode an actual edge by
an ordered root pair \((a,b)\), with row \(-(a+b)\) and column \(-ab\).
Properness means choosing at most one orientation of a distinct nonzero
root pair.

The repeated-color square relation has four slots
\[
(a,b),(a,c),(d,e),(f,g)
\]
and equations
\[
a+b=d+e,\quad ac=de,\quad a+c=f+g,\quad ab=fg.
\]
Here \(a,d,f\ne0\); a square is nondegenerate exactly when \(b\ne c\).

Every solution satisfies the additional cubic identity
\[
a^2b-a^2c+de(d+e)-fg(f+g)=0.
\]
The [phase and support proof](pass3-quadratic-variety-and-cubic-phase-obstruction.txt)
uses it to produce four different dense supports with **no solutions**,
although each support has asymptotically uniform color, row, and column
marginals. All four can lie in one common proper orientation and have
density \(1/16+o(1)\). Thus even properness plus these marginal conditions
does not give four-partite supersaturation.

This is **not** a dense B construction: the four supports are different.
It does not disprove the proposed removal statement either, since there
are already no solutions to remove.

We also [classified every polynomial additive slot identity](pass3-all-polynomial-slot-potentials.txt)
over characteristic zero, or with degree bound below the characteristic,
when it holds on the full algebraic solution set. Modulo the evident
shared color, sum, and product potentials, there is exactly one scalar
cubic contribution, the one above. This is not an inverse theorem for
arbitrary functions or for a selected root branch. Historical priority
of this exact classification remains unverified.

## 3. Two precise representation barriers

The [triangle obstruction](pass3-triangle-representation-obstruction.txt)
rules out exact encodings of a positive fraction of the full solution
variety by triangles with \(O(p)\) vertices in each part, when each of the
four selected-edge labels is determined by one triangle edge. Any two
slot labels determine at most four configurations, whereas two of the
four labels would have to share an edge. Their required
\(\Omega(p^3)\) joint possibilities cannot fit on \(O(p^2)\) edges.

The [differential obstruction](pass3-four-projection-linearization-obstruction.txt)
rules out simultaneous local invertible changes making the four
projections affine-linear. A pair of their kernel directions spans a
nonintegrable plane precisely on the nondegenerate locus; constant
directions would have integrable spans.

These statements do not exclude auxiliary dimensions, nonlinear removal,
nonabelian models, or encodings tailored only to a particular support.
Ordinary hypergraph removal with a dummy coordinate also fails to preserve
deletions of whole original-label fibers; the
[literature note](pass3-four-slot-literature.md) explains that distinction.

## 4. Expansion is real, but is established incidence theory

We independently proved the mean-zero bound
\[
\left\|\sum_{a\ne0} f(\sigma_a(x),\sigma_a(z))\right\|_2
\le \sqrt{2p}\,\|f\|_2
\]
on ordered distinct pairs. The [spectral audit](pass3-quadratic-pair-action-spectral-audit.txt)
checks it exactly.

The [novelty check](pass3-pair-action-incidence-novelty.md) then identified
it as weighted finite-field point-line incidence: in coordinates
\(r=z-x,\ t=x/r\), a source pair corresponds to
\(y=r^{-2}x+t\), and a target pair to a point. The only multiplicity
is the two-to-one map \(r\mapsto r^{-2}\). This estimate must therefore
be treated as an application of known incidence theory.

Actual edge masks depend on the color as well as the input pair.
Moreover, the crossed-edge test couples both input and output. Neither
factor is controlled by the displayed fixed-set estimate.

## 5. The next concrete research target

The [common-mask note](pass3-common-mask-spectral-intermediate.txt) isolates
a smaller unresolved class:
\[
a\in A,\quad x\in X,\quad x\longmapsto ax+a^2,
\]
with one shared row set \(X\) for every selected color. Prove or disprove
that proper B in this class forces \(|A||X|=o(p^2)\).

This would allow a fixed positive retained fraction, beyond the
sublinear-defect theorem. Properness is exactly
\(X\cap-(A\mathbin{\dot+}A)=\varnothing\), which by itself permits positive
density.

The note proves that every such proper common-mask graph is quasirandom
on its row strip at positive density, using a fourth-moment bound for
arbitrary palette subsets. But the matrix for each individual color can
still have no reciprocal pair while being quasirandom. A successful
argument must use their **simultaneous realization by the same graph and
the specified affine maps**. Repeating unweighted pair expansion or
ordinary graph quasirandomness will not resolve that gap.

An alternative continuation is to classify exact linear parameter
families inside the four-slot variety, while remembering that the known
arithmetic-progression/antipodal families alone are insufficient.

## Evidence index and continuation status

- [Affine defect deduction](pass3-conditional-prime-incidence-defect-upgrade.txt).
- [Independent affine-defect audit](pass3-prime-defect-upgrade-independent-audit.txt).
- [Recent incidence source and formalization audit](pass3-lewko-incidence-source-audit.md).
- [Independent phase and geometry audit](pass3-independent-phase-and-geometry-audit.txt).
- [Second polynomial classification](pass3-polynomial-phase-classification.txt).
- [Four-slot primary literature and failed routes](pass3-four-slot-literature.md).
- [Pair-action prior-work match](pass3-pair-action-incidence-novelty.md).
- [Common-mask intermediate and exact remaining conditions](pass3-common-mask-spectral-intermediate.txt).
- [Independent common-mask and support-coherence audit](pass3-support-coherence-audit.txt).

This is continuation **3 of 8**, not the consolidated morning report.
Preserve the original Gemini artifacts. No authors were contacted and
nothing was published.
