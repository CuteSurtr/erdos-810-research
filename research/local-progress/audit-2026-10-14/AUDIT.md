# Adversarial audit of the Erdős #810 claims

**Second-pass correction:** the overlap decomposition and `2N/5` linearization
were already published by Füredi in 2012, and the proper-coloring obstruction
classification by Gyárfás–Sárközy in 2023. The report below is the first-pass
record. See [the subsequent research report](../research-2026-10-14/RESEARCH.md)
for corrected provenance, stronger reductions, `M(11)=34`, and the complete
classification of extremal graphs for `M(10)=30`.

14 October 2026. Audited the local `HypergraphReduction.lean`, finite certificates,
search programs, and cited literature. Original claim files were preserved.

**Verdict:** the advertised three new structural theorems do not establish new
asymptotic progress on #810. Their Lean proofs are valid, but the hypotheses and
conclusions are substantially narrower than the surrounding claims. The audit
does establish an additional exact finite value by exhaustive computation and
derives several precise structural refinements. Their publication novelty has
not been established.

Here `M(n)` is the maximum number of edges in an `n`-vertex graph that can be
colored with at most `n` colors so that every, not necessarily induced, `C4` is
rainbow. The original question asks whether `M(n) >= epsilon*n^2` eventually for
some fixed positive `epsilon`.

## What fails in the advertised claims

| Claim | Audit finding |
| --- | --- |
| A new `(7,4)` hypergraph reduction | The actual theorem's cycle-span hypothesis is equivalent to rainbow `C4`. It does not construct a hypergraph, extract a graph, or prove an extremal inequality. The genuine reduction was already in BEGS89. |
| The hypothesis is Brown–Erdős–Sós `(7,4)`-freeness | False identification. Full freeness forbids **any four distinct triples** on at most seven points; the code only examines triples coming from a graph `C4`. |
| Group-sum coloring offers a new dense construction | Cancellation handles adjacent edges, but the difficult opposite-edge inequality is assumed. Solymosi's existing theorem actually rules out the proposed dense route for groups of order proportional to the graph size. |
| The fiber theorem explains the finite obstruction | The Lean result sums lengths of arbitrary lists already assumed to have length at most two. It neither proves the conflict-graph independence bound nor checks an exhaustive graph family. |
| There are 37,569 seven-vertex examples with `K8`-free conflict graphs | False. Exactly 420 of the 54,264 labeled 15-edge graphs have `K8`-free conflict graphs. The number 37,569 counts graphs with conflict independence number at most two, most of which also contain `K8`. |
| `M(10)=30` was already proved by the supplied artifacts | The supplied metadata said exact, but the only attached proof was a lower bound. This audit supplies the missing computational upper bound. |

The five principal declarations in `HypergraphReduction.lean` compiled under
Lean 4.24.0 with empty axiom sets. The problem is the gap between the prose and
the precise statements, not a failed Lean kernel check. The file is also absent
from the project's normal Lake targets and `Audit.lean`.

Two counterexamples make the semantic gap explicit:

* A monochromatic four-edge star has no `C4`, hence satisfies the local condition,
  while its four lifted triples span only six points.
* More strongly, the path `0—1—2—3—4` colored `red,blue,red,blue` is properly
  colored and bipartite, and every `C4` is rainbow vacuously. Its lift is linear,
  but its four triples span seven points. Both counterexamples are kernel-checked.

See `SemanticAudit.lean` and `ProperBipartiteLift.lean`.

## A concrete finite extension: M(10) = 30

The existing 30-edge coloring is valid. We additionally established:

> Every 31-edge graph on ten vertices has eleven edges that are pairwise in
> conflict: every pair occurs together in some `C4`.

Those eleven edges require eleven distinct colors. An independently written C++
checker and the supplied Python enumerator both examined **2,735,357**
representatives and excluded every one by a conflict `K11`. Their conflict-graph
builders use different methods. A symmetry argument proves that the enumeration
covers every isomorphism class; duplicates are harmless. Graphs with more than
31 edges are excluded by deleting edges down to 31.

Thus `M(10)=30` has an exhaustive computational proof. **The upper bound is not
yet a Lean/kernel proof.** This is newly established by this audit relative to
the supplied evidence, not a claim that nobody has previously computed it.

All supplied lower-bound certificates through 25 vertices passed an independent
checker. The 25-vertex example has 152 edges and 2,124 rainbow `C4`s. An attempted
order-11 upper-bound extension was stopped without a result; it establishes no
additional bound.

The original `BruteForce.lean` also compiled independently under the installed
Lean/Mathlib 4.24.0 environment, including its no-`sorry` audit. Its exact results
through order six and lower bounds through order twelve survive this check.

The order-ten witness also has a short description: it is the complement of the
pentagonal prism, with a cyclic ten-color rule. Its proof, the symmetry-coverage
argument, source, logs, and hashes are in `finite-results.md` and the files it links.

## Stronger structural follow-through

### Exactly what the bipartite lift is missing

For a **properly colored bipartite** graph, its lifted triple system is `(7,4)`-free
if and only if both conditions hold:

1. Every `C4` is rainbow.
2. There is no four-edge path on five distinct vertices colored alternately with
   two colors.

Proof: consider four distinct graph edges whose lifted triples span at most seven
points. If their colors number one, properness forces a four-edge matching, which
already uses eight graph vertices. If there are two colors, their graph has
maximum degree two and uses at most five vertices. Bipartiteness then forces a
`C4` or a four-edge path. With three colors there are at most four graph vertices,
so the four edges must form a `C4`. Four colors leave at most three graph vertices,
impossible in a simple bipartite graph with four edges. Conversely, either listed
obstruction lifts to four triples on at most seven points.

This classification was also exhaustively checked on all 7,352 proper bipartite
four-edge colorings up to eight labeled support vertices, modulo color renaming.
The general classification is a written proof, not a Lean theorem. The alternating
path counterexample is Lean-certified. `BipartiteHypergraphExtraction.lean` adds an
actual global-freeness-to-rainbow theorem using genuine finite sets of triples.

### An exact projection constant

If a linear `(7,4)`-free triple system `H` has `2n` vertices, choose half as graph
vertices and half as colors. Retain triples with two graph vertices and one color.
No extra bipartition of the graph vertices is necessary. Averaging gives

\[
 M(n)\geq\left\lceil \frac{3n}{4(2n-1)}|H|\right\rceil.
\]

The limiting retention factor is `3/8`. This refines the extraction step; the
underlying reduction is old. It does not change the known asymptotic order.

### Sharp loss when making a triple system linear

For `N >= 5`, every simple `(7,4)`-free triple system can be made linear by deleting
at most

\[
 L(N)=2\lfloor N/5\rfloor+\mathbf 1_{N\bmod5=4}
\]

triples. This worst-case bound is sharp, attained by disjoint three-edge
common-pair sunflowers on five points, with a two-edge diamond on four points
when the remainder is four. For `N=4` the bound is two; for `N<=3` it is zero.

The proof classifies the components formed by joining triples that overlap in
two points. Each component has at most three triples, and distinct nontrivial
components have disjoint vertex supports. The full argument is in
`literature-notes.md`, Deduction B.

Projecting before removing all overlaps gives an even better bound. For any
possibly nonlinear `(7,4)`-free `H` on `2n` vertices, `n>=3`,

\[
 M(n)\geq\left\lceil
 \frac{3n|H|}{4(2n-1)}
 -\frac{n^2(n-1)}{4(2n-1)(2n-3)}
 \right\rceil.
\]

The additive correction is asymptotic to `n/16`. This follows by counting duplicate
projected edges exactly in the small overlap components. The expected-loss bound
is attained by appropriate disjoint sunflower systems; this does **not** assert
sharpness for `M(n)`.

These statements have written proofs and independent finite checks. The tests
covered 8,720 small hypergraphs, all 72,380 `(7,4)`-free four-triple systems on eight
vertices, 240 randomly generated larger systems, 126,700 balanced projections,
and 58 sharpness examples. They are not represented as Lean proofs.

## Literature limits and novelty

* [Burr–Erdős–Graham–Sós (1989), pp. 272–273](https://fanchung.ucsd.edu/ron/papers/89_04_maximal_antiramsey.pdf)
  already gives the hypergraph reduction and a rainbow-path construction yielding
  `M(n) >= n^2 / exp(O(sqrt(log n)))`. Consequently small examples of appreciable
  density are not evidence for a fixed positive asymptotic density.
* [Solymosi (2013), Theorem 5](https://arxiv.org/pdf/1309.0133) finds an opposite-color
  collision rectangle in every sufficiently dense subset of a finite group's
  multiplication table. This blocks the finite-group construction when the group
  order is `O(n)`. It does not automatically cover arbitrary quasigroups or groups
  much larger than the graph.
* The same lower-bound numerical values were already present in the
  [public #810 discussion](https://www.erdosproblems.com/forum/discuss/810), without
  claims of optimality. Verified upper bounds must be distinguished from these
  existing constructions.

The exact finite upper bound and the refinements above are useful outputs of this
audit. A targeted literature search did not establish publication novelty for
them. No positive-density construction, subquadratic upper bound, or solution of
#810 has been obtained.

## Reproduce the checks

From this directory:

```sh
python3 finite_audit.py
python3 structural_checks.py
c++ -O3 -std=c++17 exhaustive.cpp -o exhaustive
./exhaustive 10 31
```

The C++ SDK-specific command used on this Mac is in `exhaustive_metadata.json`.
The original Python order-ten replay is recorded in `original_python_n10_m31.log`.
Lean commands and axiom outputs are recorded in `formal-checks.md` and the
corresponding kernel logs. The normal project configuration requests Lean 4.33.1;
the standalone audit uses the installed Lean/Mathlib 4.24.0 environment.
