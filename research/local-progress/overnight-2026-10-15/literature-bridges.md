# From pointwise coincidences to structure: source audit

Checked 2026-10-15. This note records applicability, rather than asserting
priority. No source inspected closes the unrestricted Erdős #810 problem.

## Closest exact bridge: action Balog–Szemerédi–Gowers

[Brendan Murphy, *Group Action Combinatorics*](https://arxiv.org/pdf/1907.13569),
Theorem 24, preprint page 18, is the closest general theorem found.
For a group acting on X, put

    Sym_α(Y) = {g : |Y∩gY| ≥ α|Y|}.

For a palette S⊂Sym_α(Y), an integer J>0, and

    α_J = 2(α/2)^(2^J),
    K = (|Sym_{α_J}(Y)|/|S|)^(1/J),

the theorem supplies a small-tripling set and controls overlap of S or
S^{-1} with translates of it. Both the tripling constant and retained
proportion depend on K/α_J. Crucially, its general form does not provide
a useful cardinality bound for that structured set.

Theorem 29, pages 22–23, adds such control when **every** nonidentity
element of the acting group fixes fewer than a fixed integer f points.
Its structured set can still have size comparable to |Y|^f, rather than
|Y|. These are assumptions on the whole generated group, not just on
quotients of two colors.

**Application gap.** Taking Y to be the whole permutation domain Ω gives
Sym_β(Y)=Γ for every β≤1. The loss then depends on the possibly enormous
generated group Γ. Perfect matchings imply that quotients of distinct
colors are derangements, but say nothing comparable about arbitrary
elements of Γ. Thus neither theorem presently turns our large pointwise
collision count into the bounded-size approximate group needed by the
audited square argument.

Even if f is fixed, |H|=O(N^f) is insufficient: the lifted graph has only
Ω(N²) edges, so its density relative to |H|² can vanish. Applying the
local square lemma at a fixed positive density in H×H would be invalid.
The precise research target suggested by this source is a strengthening
that uses the color-supported forbidden-square relations to control
approximate stabilizers, or to produce an O(N)-sized structured set.
No such strengthening is proved in this note.

## A more recent theorem still needs stabilizer control

[Martin Bays and Tingxiang Zou, *An asymmetric version of Elekes–Szabó
via group actions*](https://arxiv.org/pdf/2408.14215), current Corollary B.5,
pages 47–48, is the finitary group-action BSG statement. Earlier versions
numbered the relevant appendix differently.

For fixed k,r,t,δ>0 it assumes polynomially comparable |S| and |A|,
many incidences s·a∈A, and

    #{a∈A^k : |Stab_<S>(a)| ≥ |A|^t} ≤ |A|^(k−δ).

It returns a |A|^δ-approximate group H with

    |H| ≤ |A|^(k+t+δ),
    |H∩hS| ≥ |A|^(−δ)|S|,

plus a large subset T⊂A whose H-image has controlled polynomial growth.
This is an exact group-theoretic result, but its conclusion is weaker
than a bounded-doubling, O(N)-size set capturing a constant palette
fraction. The tuple-stabilizer hypothesis is also unproved for arbitrary
color completions. Choosing δ small and fixed does not turn the losses
into constants. Sending δ to zero with N requires uniform estimates that
the stated result does not supply.

## What Gowers–Long actually provides

[W. T. Gowers and Jason Long, *Partial associativity and rough approximate
groups*](https://doi.org/10.1007/s00039-020-00553-1), Theorem 1.9, starts
from an n×n partial Latin square with Ω(n⁵) octahedra: pairs of identically
labeled rectangles. For every fixed accuracy parameter b, it finds a
positive-density subtable modeled in a metric group, with separated row,
column and color images and product relations holding within error 1/b.
Its Theorem 1.11 extracts a positive-density subtable satisfying the
quadrangle condition. The paper explicitly explains that this condition
for partial Latin squares does not force an exact group-table embedding.

Neither conclusion is the exact permutation-product model in the audited
small-difference theorem. Moreover, the Ω(n⁵) octahedron hypothesis does
not follow from density alone. These are two separate missing steps.

### Exact diagnostic for the first missing step

For a perfect coloring of a bipartite graph with n vertices in each part,
let P_a be the permutation of color a. Allow degeneracies and define

    t_abcd = |Fix(P_b^{-1} P_d P_c^{-1} P_a)|.

This counts ordered rectangles with color matrix

    a  b
    c  d.

Indeed, choose the first row x. Its two column labels are P_a(x) and
P_b(x), and the second row must be P_c^{-1}P_a(x). The last edge exists
with color d precisely when the displayed permutation fixes x. Since
every color is a full matching, no support condition is missing here.

Consequently the labeled rectangle count is Σt_abcd, and the labeled
octahedron/cuboctahedron count is Σt_abcd². For d=Θ(n) colors, density
forces Σt_abcd=Ω(n⁴). Squaring and dividing by d⁴ gives only Ω(n⁴),
not Ω(n⁵). To trigger Gowers–Long, one needs substantial concentration
of rectangle patterns across starting rows. The pointwise energy
calculation in the earlier note does not prove this concentration.

This is a reformulation of the obstruction, not an additional universal
bound. In particular, rainbow rectangles with four distinct colors are
allowed, and numerous isolated instances of such patterns need not create
global permutation identities.

## Primary evidence that the missing steps are real

[Kwan–Sah–Sawhney–Simkin, *Substructures in Latin squares*](https://arxiv.org/pdf/2202.05088),
Theorem 1.5, proves that a uniformly random Latin square has
(4+o(1))n⁴ labeled cuboctahedra with high probability. Thus even a full
Latin square can be one factor n below the Gowers–Long input. These
Latin squares are not asserted to be rainbow-C4 colorings, so this is
not a counterexample to a possible theorem using the B condition.

The same paper's high-girth Latin squares must not be misread as solving
or disproving #810. Their forbidden configurations use the usual
edge-count = vertex-count−2 threshold. A four-edge, three-color rectangle
has seven hypergraph vertices, so it lies at vertex-count−3 and is not
excluded by that high-girth condition.

[Ben Green, *On a conjecture of Gowers and Long*](https://arxiv.org/pdf/1911.11866),
Theorem 1.1, proves that nearest-point multiplication on finer nets in
SO(3) cannot agree on a positive fraction of entries with an exact group
operation under an injective map. This gives a rigorous obstruction to
upgrading approximate metric-group models indiscriminately. Its example
is only weakly cancellative; Section 7 explicitly distinguishes a
potential fully cancellative example. Therefore it is not a direct
counterexample concerning proper B-colorings or all partial Latin squares.

[Anna Taranenko, *Multidimensional quadrangle condition and cuboctahedra
in latin hypercubes*](https://arxiv.org/pdf/2511.17082), Theorem 3,
characterizes the maximum cuboctahedron count in higher-dimensional
hypercubes. The relevant two-dimensional benchmark is exact maximality
n⁵, not merely positive density or Ω(n⁴) instances. This recent result
does not supply the needed intermediate inverse theorem.

## Permutation stability is a later repair step, not the missing inverse step

[Becker–Chapman, *Stability of approximate group actions: uniform and
probabilistic*](https://arxiv.org/pdf/2005.06652), Theorems 1.2 and 1.6,
correct approximate homomorphisms from an already specified amenable
group into permutations, allowing a small enlargement of the domain.
The hypotheses involve a small uniform or mean Hamming defect in the
multiplication law. We have neither a palette group law nor this small
defect. Agreement of different products at occasional points is much
weaker. Invoking this stability theorem before constructing an
approximate homomorphism would assume the missing structure.

## Frobenius subclass: valid, with a narrow hypothesis

Suppose the perfect color permutations lie in a transitive permutation
group Γ on n points in which every nonidentity element fixes at most one
point. Distinct colors a,b are pointwise disjoint, so P_a P_b^{-1} is a
derangement. Frobenius' theorem says that the identity together with all
derangements forms a regular normal subgroup H of order n. Hence

    SS^{-1} ⊂ H,   |SS^{-1}| ≤ n.

The audited small-difference theorem immediately gives d=o(n), or
nd=o(n²) edges. This remains useful when |Γ| is much larger than n.

For a primary research reference recording the Frobenius-kernel fact,
see [Bailey–Cameron–Giudici–Royle, *Groups generated by derangements*](https://research-repository.st-andrews.ac.uk/bitstream/handle/10023/24587/ggd_revised.pdf?isAllowed=y&sequence=1),
pages 1–3. Their general derangement-generated subgroup D(Γ) is often
all of Γ, so replacing the Frobenius kernel by D(Γ) does not give an
O(n) bound in general.

The perfectness assumption in this deduction is essential to its stated
proof: partial matchings can have completions agreeing at unused points.
Also, the hypothesis bounds fixed points of every group element; the
rainbow-C4 condition alone does not imply it. This is an attributed
conditional corollary, with no originality claim.

## 2026 perfect-B paper: distinct access attempts

The publisher continues to index the abstract of
[Gyárfás–Sárközy–Wagner, *Perfect proper edge colorings of regular
bipartite graphs with rainbow C4-s*](https://doi.org/10.1016/j.disc.2026.115005)
as open access. The abstract confirms an induced-matching argument for
translation-invariant colorings, but the exact definition remains a
full-text gap.

New attempts in this pass used the publisher's article XML endpoint,
Semantic Scholar's openAccessPdf lookup, and OpenAIRE's DOI lookup.
The browsing tool returned access errors, not paper contents. A separate
browser-rendering attempt found no enabled browser surface. These are
access limitations, not evidence that the full text contains no relevant
theorem. No author was contacted, and no blocked publisher download
request was repeatedly retried.

## Most promising next theorem-sized target

The cleanest target is to strengthen the action-BSG route with the
forbidden-square condition: from positive-density B-colored partial
matchings, extract a constant fraction of large color classes whose
relative permutations have positive normalized **global** energy, or
an O(N)-sized approximate-group model. Either would contradict the
audited energy obstruction. Current action-BSG theorems expose exactly
the uncontrolled stabilizer term; Gowers–Long exposes a different form,
the need for Ω(n⁵) rather than Ω(n⁴) repeated rectangle patterns.

This note identifies those targets and documents why existing theorems
cannot simply be substituted for their proofs. It does not establish
either target.
