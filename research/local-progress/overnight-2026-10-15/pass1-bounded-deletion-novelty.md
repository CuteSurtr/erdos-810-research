# Bounded deletions from affine lines: novelty addendum

Date: 2026-10-15. Targeted literature check, plus a simplification of the
locally derived covering argument. Originality is not established.

## Sharper elementary cover

Suppose every selected affine line l retains all but at most r of its field
points, and retained point sets of different lines are disjoint. Then all
the lines lie in at most

    (r+1)²

parallel or concurrent pencils. No rainbow-C4 hypothesis is needed for this
geometric statement.

If there are at most r lines, the assertion is immediate. Otherwise choose
r+1 base lines l_1,...,l_{r+1}, and let D_i be the at most r deleted points
of l_i. Take the following cover:

* the r+1 parallel classes containing the base lines;
* the pencils through all points of union_i D_i.

There are at most (r+1)+r(r+1)=(r+1)² pencils. If a further line l were
uncovered, it would meet each l_i at a point p_i retained by l_i. Those
points are distinct: equality p_i=p_j would place one point in two retained
base supports. Disjointness now forces l to delete all r+1 of them, a
contradiction.

The original proposed cover also included pencils through intersections of
pairs of base lines, giving (r+1)(3r+2)/2. They are redundant: such an
intersection is deleted from at least one of the two base lines and is
already in union_i D_i. No sharpness claim is made for (r+1)².

For repeated affine completions under different color names, bounded r and
Q>2r exclude this possibility: two disjoint subsets of the same Q-point
line cannot both have size at least Q−r. Alternatively the covering
statement can be phrased for distinct supporting lines throughout.

## What the searched sources do, and do not, establish

[Bereg, Levy and Sudborough, *Constructing Permutation Arrays from Groups*](https://arxiv.org/pdf/1511.04494)
studies affine/semilinear permutation families and their pairwise Hamming
distances. Section 2.1, PDF pp. 6–8, concerns contraction: removing a symbol
and rerouting permutation entries, with controlled loss of distance. This
is different from deleting at most r arbitrary entries of each affine map
so that every remaining grid point belongs to at most one map. The paper's
affine-group constructions and contraction bounds do not provide the above
pencil cover as a stated result.

[Peter J. Cameron, *Permutation codes*](https://webspace.maths.qmul.ac.uk/p.j.cameron/preprints/permcode.pdf),
European Journal of Combinatorics 31 (2010), 482–490, Section 1.8, discusses
partial permutations and permutation geometries. This supplies relevant
terminology, but the inspected discussion concerns their order and
composition structures; it does not state the bounded-deletion pencil
cover. Pairwise agreement at at most one coordinate would be much weaker:
all Q(Q−1) affine maps already have that property.

The method resembles the standard finite-geometry principle that a maximal
general-position set covers external points by its secants. For example,
[Simeon Ball, *On small complete arcs in a finite plane*](https://web.mat.upc.edu/simeon.michael.ball/complete.pdf)
uses complete-arc secants and the corresponding dual blocking sets in its
introduction and Section 3. That is background for the covering mechanism,
not a prior theorem with our marked-deletion hypothesis or constant.

The targeted queries also covered almost-disjoint line families, erased
affine permutation arrays, partial permutation codes, and pencil covers.
No exact prior statement or direct equivalent was identified in the sources
actually inspected. This limited negative result is insufficient to claim
the lemma is original. Its short, elementary proof makes unrecorded or
independently known formulations especially plausible.

## The rainbow-C4 consequence and how to describe it

Each parallel pencil of affine maps is a coset of the translation subgroup;
each finite-point pencil is a coset of a point-stabilizer subgroup. Both
subgroups are abelian and have size at most Q. Thus the earlier audited
commuting-color-cover result implies that for fixed r, a B-colored graph
whose affine colors each omit at most r field points has o(Q²) edges.

This is a deduction combining the elementary pencil cover with the
previously sourced square/recurrence input. The defensible description is
“a locally derived bounded-deletion affine corollary; priority unverified,”
not “a new solution of the affine case” or an advance on arbitrary partial
supports. The hypothesis Q−r retained points per color is much stronger
than retaining a fixed positive fraction ηQ.

There is also a quantitative follow-through worth keeping separate. After
normalizing a pencil, its colors act as translations on F_Q or as
multiplications on F_Q*; the latter action is free off its common fixed
point. A nontrivial strong 3-term progression of colors produces a
nonrainbow rectangle at every basepoint in that free orbit. At most 4r
basepoints are eliminated by the four edge omissions. Hence if Q−1>4r,
the palette within each pencil is strongly progression-free. Combining
this with an appropriate uniform quantitative abelian Roth bound and the
(r+1)² cover can extend the conclusion to some slowly growing r. The main
team is auditing that quantitative formulation; this addendum does not
claim a new published rate or an optimal threshold.
