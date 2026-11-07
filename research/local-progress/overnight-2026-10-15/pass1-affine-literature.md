# Pass 1: affine colors with partially marked supports

Date: 2026-10-15. Primary-source applicability audit; no originality claim.

## Verdict

I did not establish that every proper rainbow-C4 coloring represented by O(n)
affine maps of F_n has o(n²) marked edges. The inspected incidence and polynomial
configuration theorems do not directly prove this statement. This is an
applicability conclusion, not a claim that the affine case is open in the entire
literature.

The most concrete next target is a **marked-line square theorem**, described
below. Ordinary point-line incidence counts discard precisely the support/color
correlation that it needs. The quadratic palette a*x+a² supplies a clean test
case: its global multiplicative energy is only O(n²), so the existing energy
obstruction does not settle it.

## Exact formulation of what is needed

Write Q for the field order, to distinguish it from the number d of colors.
Let L be d≤C Q distinct maps l(x)=a_l x+b_l, a_l≠0, with supports D_l⊂F_Q.
Assume a grid point is selected by at most one color. Define

    f_l(x)=1_{D_l}(x),
    E(x,y)=sum_l f_l(x) 1_{y=l(x)} ∈ {0,1}.

Each color is automatically a matching. Therefore the rainbow-C4 condition is
equivalent to

    sum_l sum_{x≠x'} f_l(x) f_l(x') E(x,l(x')) E(x',l(x)) = 0.       (A)

The missing theorem would say that (A) is impossible for large Q if
sum_l|D_l|≥δ Q². After the usual pruning, one may require |D_l|≥η Q and
d=Θ(Q). The count in (A) is on a potential scale Q³. In contrast, ordinary
dense-grid rectangle counting concerns Q⁴ potential rectangles and imposes no
condition on the labels of opposite corners.

For one fixed line, the two cross corners differ by a vector proportional to
(1,-a_l), while the same-color diagonal differs by (1,a_l). Scaling one
coordinate turns this into a square. This observation alone is insufficient:
a dense E can have many squares without having the required two corners marked
by the selected line l. A successful application of multidimensional Szemerédi
must preserve these labels, rather than merely find a square in E.

## Rich-line results: the exact scale obstruction

[Brendan Murphy, *Upper and lower bounds for rich lines in grids*](https://arxiv.org/pdf/1709.10438),
Theorem 4 and its proof, PDF pp. 15–17, gives a large parallel or concurrent
subfamily of rich lines. In prime characteristic its use requires

    |Y| ≤ (α/2)^(2^J) p.

Taking Y=F_p violates this for every α≤1 and J≥1. Thus it cannot be applied at
the full-field scale by simply observing that our marked lines are rich.
The ambient unmarked incidence condition is vacuous there: every affine map
has exactly p points in F_p×F_p.

[Petridis, Roche-Newton, Rudnev and Warren,
*An Energy Bound in the Affine Group*](https://arxiv.org/pdf/1911.03401),
Theorem 2.3, PDF p. 4, gives quantitative parallel/concurrent concentration for
k lines rich in an n×n Cartesian grid, but in characteristic p requires
p≫max{k,α^(-2)n}. It does not justify the desired assertion for n=p, nor for
the full grid of an extension field. Their Theorem 2.1, PDF p. 3, is an upper
bound on affine-group energy, of the form

    E(A) ≪ m^(1/2)|A|^(5/2) + M|A|²,

with the stated characteristic restriction m|A|≤p²; m and M are maximum
vertical-line and arbitrary-line occupancies in parameter space. This is not
the lower bound on global energy needed to invoke our structured-core result.

[Lê Anh Vinh, *Szemerédi–Trotter type theorem and sum-product estimate in finite
fields*](https://arxiv.org/pdf/0711.4427), Theorem 3, PDF p. 2, bounds incidences by

    I(P,L) ≤ |P||L|/Q + sqrt(Q|P||L|).

For |P|=Θ(Q²) and |L|=Θ(Q), both scales on the right are Θ(Q²).
It therefore permits exactly the incidence density under consideration and
does not see condition (A).

The action-BSG obstruction is consistent with these facts: the affine action
has nonidentity fixed-point count at most one, but its full group has Q(Q−1)
elements. The almost-free conclusion discussed in `literature-bridges.md`
can produce a core on the Q² scale, which loses the constant density required
by our local square lemma.

## Cases that our earlier arguments do cover

If the palette is covered by a fixed number of cosets of abelian subgroups of
Aff(F_Q), the previously audited commuting-color-cover corollary applies to
the action on Q points. In geometric language this includes a fixed number
of parallel or concurrent families. It gives o(Q²) marked edges, including
partial supports.

Perfect matchings are much easier: two affine maps of different slopes agree
at exactly one point, so they cannot be two distinct colors of a simple graph
when both are fully present. All perfect affine colors have one slope, hence
belong to one coset of the translation subgroup. This reasoning fails for
partial supports, which can omit the intersection.

There is no argument here that arbitrary dense marked families have boundedly
many slopes or a constant-density parallel/concurrent core.

## Polynomial configuration theorems inspected

[Han, Lacey and Yang, *A Polynomial Roth Theorem for Corners in Finite Fields*](https://arxiv.org/pdf/2012.11686),
Theorem 1.1, PDF p. 1, forces three points

    (u,v), (u+P(t),v), (u,v+R(t))

in sufficiently dense subsets of F_p², for the specified independent
polynomials (distinct degrees, or the covered quadratic case). It does not
supply a fourth selected corner, a specified diagonal label, or a pattern
whose increments depend on the basepoint.

[Li, Shen, Truong and Wu,
*Polynomial corners in finite fields beyond the distinct-degree case*](https://arxiv.org/pdf/2609.13891)
is a September 2026 preprint extending this type of **three-point** result to
linearly independent polynomial pairs. It does not remove the above pattern
mismatch. No proof audit of that preprint is claimed here.

[Laurence P. Wijaya, *Polynomial Corners Over finite Fields*](https://arxiv.org/pdf/2606.08890),
Theorem 1.2, PDF p. 2, treats the equal-side polynomial three-point corner.
Again, the fourth point and its prescribed color are absent. Its quantitative
claims are unnecessary for our conclusion and were not independently audited.

[Borys Kuca, *Multidimensional polynomial Szemerédi theorem in finite fields
for polynomials of distinct degrees*](https://arxiv.org/pdf/2103.12606)
treats configurations x+v_i P_i(t), with fixed directions and polynomials.
This can force more points, but only once a valid translated-polynomial
parametrization of the desired marked configuration has been supplied. No
such parametrization was found. Calling the defining relations polynomial
does not by itself make that theorem applicable.

## Quadratic palette: exact reduction and an energy diagnostic

Take odd Q and g_a(x)=a x+a² for a∈F_Q*. Except for O(Q) double-root points,
a point on this family corresponds to an unordered pair {a,b}:

    (x,y)=(-(a+b),-ab).

Selecting its color chooses one orientation (a,b), with the first coordinate
the chosen color. Consequently a marked partial coloring is encoded by a
set R⊂(F_Q*)² with at most one of (a,b),(b,a) present. Dense marked edge sets
give dense R after discarding exceptional points.

A nonrainbow rectangle with repeated color a corresponds to four marked
ordered pairs

    (a,b), (a,c), (d,e), (f,g)

obeying

    a+b=d+e,   ac=de,
    a+c=f+g,   ab=fg,

with the nondegeneracy conditions that the two row values and two column
values differ. The last two pairs may be oriented either way according to
the original marking. These are coupled sum-product equations, not the
translated three-point polynomial corners supplied by the above sources.

An elementary computation shows why global energy alone cannot settle this
test case. Put S={g_a:a≠0}, d=Q−1, and define
E(S)=#{(a,b,c,e):g_a g_b^(-1)=g_c g_e^(-1)}. For r=a/b,

    g_a g_b^(-1)(x) = r x + r(r−1)b².

For r=1 the identity has multiplicity d. For every r≠1 the possible nonzero
squares b² each have exactly two preimages. Thus

    E(S)=d² + 2d(d−1) = (Q−1)(3Q−5).

In particular E(S)=O(d²)=o(d³) regardless of the chosen supports. Our prior
energy theorem is fully compatible with this palette. Likewise

    |SS^(-1)| = 1 + (Q−2)(Q−1)/2 = Θ(Q²),

so the bounded-quotient-size theorem does not apply. These calculations are
derived here only as diagnostics, with no priority claim.

Root translations also explain a tempting parametrization failure. Replacing
every root r by r+h changes the sum-product coordinates by

    s ↦ s+2h,   p ↦ p+h s+h².

The second coordinate undergoes a shear depending on the first. This generally
does not preserve axis-parallel rectangles. Hence a translated homothetic copy
in the root-pair plane cannot automatically be interpreted as the required
rectangle in coefficient coordinates.

## Most promising precise gap

Prove an appropriate recurrence/counting theorem for the marked-line count
(A), even just for the parabola palette. A theorem forcing the displayed
four-pair sum-product pattern in every positive-density oriented pair set
would settle that subclass. The inspected literature supplies either
unmarked incidences, structured palettes under additional scale assumptions,
or differently shaped polynomial configurations. None establishes this
four-pair statement as a direct corollary.

The unavailable full 2026 perfect-B paper was not retried in this pass, as
requested. Its precise treatment of translation-invariant colorings remains
a separate comparison gap; no novelty conclusion is drawn from it.
