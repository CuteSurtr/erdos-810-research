# Erdős #810: novelty audit and further results

14 October 2026. This supersedes the novelty assessment in the first audit.

**Conclusion:** the main sharp-linearization mechanism was already published.
The second investigation nevertheless produced stronger exact reductions and
two substantial finite results. These are mathematical/computational results
derived and checked here; their publication novelty is not established. None
settles the positive-density question in #810.

## What was already known

Füredi's *2-Cancellative Hypergraphs and Codes* (2012), §8, printed p.166,
already gives the same overlap-component argument and deletion bound `2N/5`.
Our exact formula

`2 floor(N/5) + 1_{N mod 5 = 4}`

improves the integer rounding only by one edge when `N ≡ 3 (mod 5)`.
It should not be presented as a new structural breakthrough.
[Primary paper](https://iuuk.mff.cuni.cz/~samal/DS/S0963548311000563a.pdf).

Gyárfás–Sárközy (2023), Figure 2 and Proposition 1.6, already distinguishes
proper rainbow-C4 colorings from those also excluding alternating four-edge
paths, and connects the latter to the `(7,4)` problem.
[Primary paper](https://real.mtak.hu/191892/1/012-article-p109.pdf).

The exact balanced-projection formula from the first audit was not located
in the inspected sources, but it refines an established reduction. Lack of a
search hit is not evidence of originality. The source-by-source assessment,
including limitations on access to the 2026 perfect-coloring paper, is in
[novelty.md](novelty.md).

## Stronger deductions obtained in this pass

Let `M(N)` be the largest number of graph edges on `N` vertices colorable with
at most `N` colors so that every C4 is rainbow. Let `g(N)` be the largest
number of triples on `N` points such that every four distinct triples span
at least eight points, and let `g_lin(N)` impose linearity too.

The main statements proved in this investigation are

1. **Full-shadow reduction:** `M(N) ≥ 3 g_lin(N)`.
2. **Rewiring comparison:** `g(N) ≤ g_lin(N) + floor(N/4)`, for `N ≥ 5`.
3. **Refined general reduction:** `M(N) ≥ 3 g(N) − 2 floor(N/4)`, for `N ≥ 5`.

For (1), keep all three pairs from each triple, coloring a pair by its omitted
point. Linearity makes this a simple, properly colored graph with exactly
three edges per triple. A nonrainbow C4 would have two equally colored opposite
edges. Its four supporting triples must be distinct: coincidence of adjacent
supports is incompatible with that repeated opposite color and linearity.
Those four triples would use at most four graph vertices and three colors,
contradicting the `(7,4)` condition. The full proof also handles repeated
supports directly and proves a localization lemma for nonlinear systems.

For (2), an isolated three-edge block on five points can be replaced by two
linear triples on those five points, losing only one edge. Each remaining
two-edge overlap needs one deletion and occupies four points. The replacement
preserves the forbidden-configuration condition. This is a comparison of
extremal numbers allowing rewiring; it does **not** improve the sharp deletion
bound for a prescribed input family. In particular, it improves the additive
term in Füredi's displayed comparison with 2-cancellative triple systems from
`2N/5` to `floor(N/4)` by a different permissible operation.

For (3), a two-triple overlap contributes four usable shadow edges instead of
the three obtained by deleting one triple first. Two replacement lemmas show
that an extremizer has at most one isolated three-edge block, and cannot have
both such a block and an ordinary two-edge overlap. The second lemma replaces
five triples on nine points by the six row/column triples of a 3-by-3 grid,
while checking all possible interactions with external triples. Counting the
remaining losses gives the stated correction.

There is also an exact characterization: the natural full-shadow coloring of
a linear triple system has every C4 rainbow **if and only if** the system is
2-cancellative. Its proof is included in the novelty appendix. Thus the
construction applies more broadly than just `(7,4)`-free systems.

The complete written proofs, including the mixed-edge cases in the replacement
lemma and the small orders, are in
[shadow-extraction-proof.txt](shadow-extraction-proof.txt).
These exact inequalities are stronger deductions than the earlier extraction
argument, but the qualitative implication from #810 to the `(7,4)` conjecture
was already known. No new asymptotic bound is established.

## Finite advances

**`M(11)=34`.** An exhaustive upper-bound computation at 35 edges leaves only
two graph isomorphism types without a conflict K12. Both have conflict
independence number three, so eleven colors cover at most 33 edges. The
remaining obstruction has a uniform direct proof. Together with the previously
verified 34-edge witness, this establishes the exact value computationally.
The lower-bound witness need not be properly colored; the definition of #810
does not require properness.
[Proof, counts and reproduction](m11-result.md).

**The extremal graphs for `M(10)=30` are classified.** Up to isomorphism they
are exactly the complements of the pentagonal prism and of the ten-vertex
Möbius ladder. Independent code checked all 288 surviving colorings and their
isomorphisms. [Classification and certificates](m10-extremal-classification.md).

These two results extend the repository's earlier certified information.
Their historical novelty has not been established by the literature search.

## Verification and unsuccessful directions

- The parent independently reran the n=10 and n=11 certificate checkers: both
  passed. Exhaustiveness still relies on the documented graph enumeration;
  these upper bounds are not Lean theorems.
- The shadow stress test checks 8,835 families, including 2,284 linear ones,
  and localizes all 10,974 nonrainbow cycles encountered. It supports the
  general written proof rather than replacing it.
- The seven-edge/ten-point replacement gadget has separate exhaustive checks.
  The final Lean status is recorded in `replacement-verification-status.json`;
  no general extraction or rewiring theorem is claimed formalized.
- Contracting the two tips of a diamond can create a forbidden four-triple
  configuration. A concrete counterexample is recorded with the proofs.
- Searches for a six-regular perfect B-coloring on bipartition sizes 12 and 13
  both returned **UNKNOWN**, after 180 and 300 seconds. A known five-regular
  order-12 case was recovered and independently checked by enumerating all
  rectangles. No new perfect-coloring bound follows.
- Bounded n=12 graph searches were inconclusive. No n=12 upper bound is claimed.

The unresolved obstacle remains the order of growth: these refinements do not
show `M(N)=o(N²)`, nor construct colorings with a fixed positive edge density.
The factor-three construction and the finite classifications are concrete
results worth preserving, with the novelty qualifications kept explicit.
