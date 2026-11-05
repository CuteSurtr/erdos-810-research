# Overnight research checkpoint — 15 October 2026

**Latest completed continuation:** [Pass 5 report](PASS5-REPORT.md).
Affine colors with one color per slope now have an audited \(m=o(p^2)\)
theorem whenever their actual row supports have uniformly bounded VC
dimension, with arbitrary intercepts. More generally the same holds
when the support bigraph omits a fixed induced bipartite pattern.
A graphon-and-bracketing argument resolves the finite-cover difficulty
left in Pass 4; the result has no explicit rate.

For polynomial intercepts of fixed degree \(D\ge2\), a separate
actual-support Fourier argument gives
\(m\le C_Dp^{47/24}W^{2/3}\), where
\(W=\sum_k\sup_a|\widehat{1_{D_a}}(k)|\).
Thus \(W=o(p^{1/16})\) suffices. This includes intersections of
color-dependent cyclic intervals along a shared list of \(r\)
frequencies, even with
\(\limsup r\log\log p/\log p<1/16\).
Common row-and-column eligibility and a repeated-slope class are
also covered under the explicit hypotheses in the report.

The [Pass 4 results](PASS4-REPORT.md) remain available, including the
explicit common-row bound for arbitrary intercepts and the stronger
\(O_D(p^{19/10})\) estimate for polynomial intercepts. All new results
have independent hand audits, but no Lean certificate or established
historical priority.

The next target is **unrestricted actual supports**. A hypothetical
dense affine example must contain every fixed induced support pattern
with positive density; in the polynomial class it must also have a
large joint Fourier majorant. A uniform small-negative-spectrum bound
for arbitrary proper masks is false. The latest exact phase checkpoint
isolates a promising but unproved direction for quadratic masks with
color-dependent frequencies. Read Pass 5 before repeating any direction
below. The unrestricted #810 bound and its novelty status are unchanged.

This is the starting point for the eight authorized hourly overnight
continuations. Continue substantive mathematical research; do not repeat
finite graph enumerations or describe a conditional result as a solution.
The user authorized research while asleep, not publication or contacting
authors. Preserve the original Gemini artifacts.

## Current mathematical status

For the original problem, let \(M(N)\) be the maximum edge count of a simple
\(N\)-vertex graph with at most \(N\) colors in which every \(C_4\) is rainbow.
The properly colored variant is called B in these notes. Properification
costs \(o(N^2)\) edges in the relevant regime.

- The current universal bound is still
  \(M(N)\leq(0.2984440375099955469\ldots+o(1))N^2\).
  Its proof has independent hand audits and an exact coefficient
  certificate. Historical novelty and record status remain unverified.
- We have not proved a universal bound below \(N^2/4\), or \(o(N^2)\).
  The earlier \(1/4\) barrier is a limitation of an endpoint-moment
  relaxation, not a graph counterexample.
- There are audited conditional vanishing-density theorems for palettes
  whose permutation completions have a small difference set, and a
  necessary vanishing global-energy theorem. They do not supply the
  missing general structural theorem.
- No new theorem in this directory has a Lean certificate or an
  established historical novelty claim. The notes distinguish conditional
  positive results using published inputs, exact obstructions to proposed
  methods, and still-unproved targets.

Read the [previous main report](../multicolor-2026-10-15/REPORT.md) for the
conditional theorems and the [earlier asymptotic
results](../asymptotic-2026-10-15/RESULTS.md) for the universal bound.

## What the first overnight pass established

### Global energy does not capture the needed local constraints

The [formal audit](formal-audit-energy-and-partial-kernel.txt) contains:

1. A tensor family of perfect colorings of complete \(K_{n,n}\) with
   \(E(S)=o(n^3)\) while \(E_x(S)=n^3\) at every point. There is no
   completion freedom. The family is **not B**. It disproves a bridge
   using only density, properness and pointwise coincidence counts.
2. A probabilistic padding argument: every partial proper coloring with
   \(q=O(n)\) colors has completions on \(2n\) points with the minimum
   possible energy \(E(S)=2q^2-q\). Thus minimizing completion energy is
   uninformative. The earlier theorem, which applies to every completion,
   remains valid.
3. An intrinsic replacement. For actual matching matrices \(B_a\), set
   \(Q_{ab}=B_a^T B_b\). The Gram matrix
   \(G_{ab,ce}=\langle Q_{ab},Q_{ce}\rangle_F\) counts agreements of
   defined partial maps. Its off-diagonal entries for overlapping color
   pairs vanish exactly when the proper coloring is B.
4. An explicit positive-density abstract Gram model satisfying those
   zeros, diagonal sizes, trace and total-mass constraints, transpose
   symmetry, and both bipartition-side PSD conditions with their exact
   reshuffling identity. It does **not** realize actual matching
   matrices. Therefore these scalar/matrix constraints alone cannot
   prove vanishing density.

The missing information is the actual common origin of the maps:
\[
Q_{ab}Q_{bc}=B_a^T D_b^X B_c,\qquad
D_b^X=B_bB_b^T.
\]
In the perfect case this becomes \(Q_{ab}Q_{bc}=Q_{ac}\). Mere Gram
positivity, even on both sides, discards this product and support
compatibility.

The [independent two-sided audit](two-sided-gram-independent-audit.txt)
checks the exact reshuffling entry by entry. It also proves that adjoining
the fixed all-ones matrix to the Gram relaxation does not exclude the
model. The root reviewer checked the trace identity, the matching
probabilities and this Schur-complement calculation.

### Ordinary dense colored-removal normalization fails

The [sampling and removal audit](finite-sampling-and-removal-barrier.txt)
proves that a uniformly sampled fixed-size vertex set in any proper
coloring is asymptotically fully rainbow, regardless of B.

An odd cyclic Latin coloring of \(K_{n,n}\) has only
\(n^2(n-1)/2=o(n^4)\) nonrainbow squares but requires at least \(n^2/4\)
edge deletions to remove all of them. Thus a growing-palette colored
removal theorem using the ordinary \(n^4\) normalization is false.
Methods conditioning on colors or retaining the natural \(1/n\)
collision scale are not excluded.

The same audit corrects a possible extraction shortcut: the C variant
(B plus no alternating two-color four-edge path) is equivalent to the
open (7,4) Brown–Erdős–Sós problem. Extracting C at positive density
would reduce to that problem, not solve it. Induced-matching extraction
would be stronger and would allow the known (6,3) theorem to finish.

### Closest literature bridges have specific missing hypotheses

The [primary-source literature audit](literature-bridges.md) records:

- Murphy's action-BSG theorem has stabilizer-dependent losses not
  controlled here.
- Bays–Zou needs tuple-stabilizer control and can lose a polynomial
  fraction of the palette, insufficient for the current lift.
- Gowers–Long needs \(\Omega(n^5)\) pairs of identically labeled
  rectangles. The current density calculation supplies only
  \(\Omega(n^4)\). Its approximate model is not automatically an exact
  group model.
- Permutation stability requires an approximate group law already in
  hand. It cannot create that law from pointwise coincidences.
- A Frobenius-action subclass works, but its global fixed-point
  hypothesis is much stronger than pairwise derangement of colors.
- The 2026 Gyárfás–Sárközy–Wagner full text remains unavailable after
  multiple publisher and repository checks. This prevents a complete
  novelty verdict; do not silently upgrade the verdict.

## Next useful targets

Choose one concrete mathematical question for each continuation and
record the attempted proof or obstruction.

1. **Actual composition and simultaneous supports.** Determine what
   additional quantitative restriction follows from the product
   identities above together with the B zeros and nonnegative partial
   permutation realization. In the partial setting, track
   \(D_a\cap D_b\cap D_c\), not arbitrary completed edges. A useful
   outcome would force a density decrement or a structured positive
   fraction of actual color classes. Check any proposed scalar
   inequality against the abstract matching-moment model first.
2. **Repeated rectangles with the B condition used explicitly.**
   Test whether B forces extra concentration of labeled rectangle
   counts beyond the generic \(\Omega(n^4)\) estimate. Any attempt to
   invoke Gowers–Long must establish its \(n^5\) threshold and separately
   address the gap between a metric approximate model and the exact
   structure needed by the square lemma.
3. **Color-conditioned removal or regularity.** Work at the natural
   collision scale, or condition on chosen colors. Do not invoke a
   bounded-vertex colored graphon or ordinary \(o(n^4)\) colored-C4
   removal theorem: the explicit cyclic example defeats that route.
4. **B-specific action structure.** If pursuing action-BSG, state and
   prove the needed stabilizer estimate. Perfect color quotients being
   derangements does not control all elements of the generated group.
5. **A concrete larger representation class.** The
   [affine checkpoint](affine-direction-checkpoint.txt) derives the exact
   forbidden-rectangle equation for partial affine maps over a finite
   field. Proving a uniform vanishing-density result for this class
   would go beyond the current small-difference hypothesis. Its
   unresolved issue is correlation of the actual supports with the
   locally determined solutions. This remains a conditional class,
   not a representation theorem for arbitrary B graphs.

A new universal constant alone does not satisfy the user's requested
asymptotic advance, though a genuinely new useful lemma should be
preserved. No endless finite search is needed. Negative results are
useful when they eliminate an explicit proposed mechanism.

## Overnight operation and reporting

Heartbeat overnight-erd-s-810-research is active in this chat, scheduled
for eight hourly follow-ups from approximately 01:41 KST on 15 October.
Do not create a duplicate automation. A temporary eight-hour AC-power
sleep-prevention process was started; do not alter the user's existing
Amphetamine settings or other automations.

Stay quiet on scheduled runs without a meaningful development. Report a
verified advance, decisive obstruction, failure, or necessary user
question. Leave a candid consolidated morning status with links. Every
substantive new proof needs an independent audit; distinguish proof,
heuristic, novelty search, and formal verification.
