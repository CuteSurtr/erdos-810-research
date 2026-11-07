# Homogeneous affine palettes: source and novelty scope

Date: 2026-10-15. This note concerns the arbitrary-support theorem in
`pass1-affine-homogeneous-palette-theorem.txt`, not the unrestricted affine
case. No publication-priority claim is established.

## Recommended description

This is a **concrete homogeneous-affine application of the known group-table
theorem**, with an elementary explicit block decomposition. Its formulation
was derived in this investigation. I did not identify the exact affine
statement in the primary sources inspected, but the underlying subgroup-
block method is already explicit in those papers. It would be misleading
to describe that method as new.

Moreover, the general coset-cover condition below is already a consequence
of our earlier uniform small-difference theorem. Thus this should not be
presented as a stronger general structural theorem. The independent direct
proof from Solymosi is valuable because it makes the concrete affine result
shorter, more transparent, and dependent on an established published input.

## Exact local result and scope

Let F have order n, let H≤F* have order h, and suppose

    beta(ua)=u beta(a)   for every u∈H and a∈F*.

For one color per used slope a, take any subset of the matching
sigma_a(x)=a*x+beta(a), assigning each retained grid point at most one
color. If all C4s are rainbow, then

    m ≤ ((n−1)/h)² R_B(H)+(n−1)/h,

where R_B(H) is the maximum size of a rainbow-C4 partial group table with
coloring (x,y)↦yx^(-1). Consequently m=o(n²) uniformly when h→∞.

The affine calculation is sigma_(gu)(x)=u[gx+beta(g)]. Within the color
coset gH, relabel rows by x'=gx+beta(g). Nonzero edges split into multiplicative
H-orbits, each a group table on H. There is at most one zero edge per color
coset. The total capacity of all nonzero blocks is exactly (n−1)².

No density assumption on individual color supports is used. This genuinely
handles more partial supports than the separate bounded-deletion corollary.
It does not show that arbitrary beta has a growing homogeneity subgroup.
For beta(a)=a² that subgroup is trivial, so the quadratic-palette test case
remains outside this argument.

For F=F_(s^k), beta(a)=a^s and H=F_s* give the result when s→∞, even when k
varies. The same reasoning covers F_s-linear maps and homogeneous functions
that need not be additive. Merely calling a map “linearized” is insufficient:
the size of a scalar subgroup over which it is homogeneous must tend to
infinity. A fixed prime subfield with increasing extension degree does not
by itself satisfy that condition.

## Explicit prior matches for the method

1. [József Solymosi, *The (7,4)-conjecture in finite groups*](https://arxiv.org/pdf/1309.0133),
   Theorem 5, PDF p. 4; published in Combinatorics, Probability and Computing
   24(4) (2015), 680–686,
   [DOI](https://doi.org/10.1017/S0963548314000856).
   This is the exact established configuration input. For every fixed
   positive density, every sufficiently large finite group table contains
   a rectangle with equal diagonal products. Replacing coordinates by
   (y,x^(-1)) gives the yx^(-1) coloring used here. Its proof already passes
   to a product of a left and right coset of a large abelian subgroup with
   at least the original density. Thus the density-preserving coset-block
   mechanism is explicitly prior art.

2. [Nenadov, Sudakov and Tyomkyn, *Proof of the Brown–Erdős–Sós conjecture in
   groups*](https://arxiv.org/pdf/1902.07614), Section 2, PDF p. 3.
   The proof explicitly partitions the ambient table into products of
   subgroup cosets and relabels a dense block as a subgroup table. It also
   explains preservation of configuration sizes under this relabeling.
   This supports the general method, but its displayed setup is a dense
   subset of one group table; it does not explicitly state the present
   affine-action palette application.

3. [Jason Long, *A note on the Brown–Erdős–Sós conjecture in groups*](https://arxiv.org/pdf/1902.07693),
   proof of Theorem 2.5, PDF p. 5.
   This proof again partitions by left/right subgroup cosets, identifies
   each block with the subgroup's table, and selects a block preserving
   density. It then finds richer configurations using additive structure.
   The homogeneous affine formulation is not stated in the portions
   inspected.

These sources establish substantially more than a superficial resemblance:
the crucial averaging and group-table preservation are the same operations.
The additional work here is recognizing and verifying the affine
normalization and summing its block capacities.

## Relationship with our earlier small-difference theorem

Suppose a palette is covered by cosets g_i H_i with

    sum_i |H_i|=O(n),     min_i |H_i|→∞.

Partition the actual colors among these cosets. A piece with q_i colors has
difference-set size at most |H_i| (up to conjugation, depending on coset
convention). For any fixed δ>0:

* pieces with q_i<δ|H_i| have at most δ n sum_i|H_i| edges altogether;
* the other pieces have difference-set size ≤q_i/δ, so the earlier uniform
  small-difference result gives o(q_i n) edges, uniformly as their q_i grow.

The second collection has q_i→∞ because min_i|H_i|→∞. Summing and then
letting δ→0 proves o(n²). This deduction needs no free-action hypothesis;
the ambient action-size assumptions of the earlier theorem still apply.
Consequently the free-orbit block criterion is a convenient sufficient
condition and direct proof, not a strict generalization of that earlier
result.

## Limits of this novelty audit

Targeted searches covered homogeneous affine palettes, affine group actions
in Brown–Erdős–Sós problems, subfield/linearized constructions, and
translation-invariant rainbow-C4 colorings. No exact statement matching
beta(ua)=u beta(a), or the displayed affine edge bound, was identified in
the primary papers actually inspected. This does not establish originality.

The 2026 Gyárfás–Sárközy–Wagner paper's full definition and theorem for
“translation invariant colorings” remain an access/comparison gap. Its
abstract alone is insufficient to decide whether it explicitly includes
this application or a still broader one. Previously unsuccessful access
routes were not repeated, and no authors were contacted.

The safe final claim is therefore: **an audited homogeneous-affine
corollary of established group-table theory, useful for the present
investigation, with historical priority of this formulation unverified.**
