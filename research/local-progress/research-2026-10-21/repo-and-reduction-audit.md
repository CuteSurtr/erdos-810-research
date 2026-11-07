# Repository and hypergraph-reduction audit — 21 October 2026

## Scope and repository status

Read-only audit of `erdos-810-standalone`, on clean branch `lean-formalization` at `1d40c5cf70e66fc04c7e4ba166dedad0d69bf891`, tracking the same remote commit. The fetched `origin/main` is `bb67788`; local `main` is older. No builds, package installations, public edits, pushes, or external messages were performed.

The formalization commit imports an earlier archive unchanged. Its own README says **verification pending** and explicitly disclaims verified results. It is not a completed proof of Erdős #810. Source inspection finds:

- `AntiRamsey.lean`: explicit proof terms for the rainbow-copy and conflict-graph equivalences, elementary edge-count bounds, and the maximal-anti-Ramsey-number characterization. There are no `sorry` proof bodies in this file.
- `Erdos810.lean`: definitions of the finite functions and explicit proofs of formulation equivalences and elementary graph examples. The main open problem, three open variants, the Brown–Erdős–Sós comparison, the path result, its limit version, and the Sárközy–Selkow result all have `sorry` bodies. They are statements, not supplied proofs.
- `Audit.lean`: a selected list of declarations checked only for `sorryAx` dependence. It includes a negative check demonstrating that the main problem depends on `sorryAx`. It does not establish all imported axioms are trusted, all declarations are audited, or the prose claims are proved. The Lake settings suppress `sorry` warnings for `Erdos810`.
- `legacy/BruteForce.lean`: self-contained alternative definitions and finite certificates; excluded from default build targets. It states exact values through six vertices and lower bounds through twelve. Transfer to the main definitions needs an equivalence proof.
- `legacy/HypergraphReduction.lean`: a cycle-local condition already equivalent to rainbow C4, an elementary group-sum criterion, and a bounded-fiber counting statement. It constructs no general hypergraph-to-graph extraction and proves no extremal comparison between the main functions. Its comments overstate this scope.

These are **source-audit findings**, not a claim that this checkout was compiled or kernel checked in this session.

## Hall reduction: direction and prior local work

For the repository's definition of `g(n;7,4)`, assume `n ≥ 7`. Its exact-seven-point condition is then equivalent to saying every four distinct triples have union of size at least eight. Below `n=7` this equivalence fails: the repository condition is vacuous.

The Hall argument proves **`g(n;7,4) ≤ M(n)`**, not the reverse. Every pair lies in at most three triples. In the bipartite containment graph between triples and pairs, left degree is three and right degree at most three, so every triple subfamily has at least its own size in neighboring pairs. Hall assigns a distinct contained pair to each triple. Color each chosen pair by its omitted point. A nonrainbow C4 would lift to four distinct triples on at most seven vertices.

The reverse inequality is already false at seven vertices: `g(7;7,4)=3`, whereas a seven-cycle has seven edges and no C4.

This Hall result was already written in `research-2026-10-14/novelty.md`, alongside its proper-coloring refinement. The older research also proved `M(n) ≥ 3 g_linear(n)` and `M(n) ≥ 3g(n) − 2 floor(n/4)`. Repeating Hall is therefore not new progress.

## New strengthening: retain all five edges of a diamond

**Written proof, pending a second independent audit.** The argument below improves the old general comparison to

\[
M(n)\ge 3g(n;7,4)-\lfloor n/4\rfloor\qquad(n\ge7).
\]

It changes only a linear error term and does not resolve the asymptotic problem. Publication originality is unestablished.

Use the standard overlap decomposition of a (7,4)-free triple system: after removing isolated three-triple blocks on five vertices, every nonsingleton overlap component is a diamond `abc,abd`. Distinct such supports are disjoint. A three-triple block on four vertices must be the whole family. These structural facts are already in Füredi's 2012 paper, §8; they are not new here.

### Boundary lemma

Let `S={a,b,c,d}` support an ordinary diamond `abc,abd`. Every external triple meets `S` in at most one point; otherwise it joins the diamond to form a three-triple block on at most five points. The outside pairs of distinct external triples meeting `S` are disjoint: otherwise those two triples and the diamond use at most seven vertices.

Consequently each vertex outside `S` has **at most one neighbor in `S` in the entire two-shadow**. In particular, a C4 containing an edge inside `S` is either wholly inside `S`, or contains exactly one edge inside `S`.

Take the full two-shadow, initially coloring every pair by the omitted point of any selected containing triple. Recolor the five pairs of a diamond using only labels from `S`, with its unique C4 rainbow. For example, under `(a,b,c,d)=(0,1,2,3)`, use `01:0, 02:0, 03:1, 12:2, 13:3`. Proper coloring is not claimed or required.

Consider a mixed C4 `u-v-x-y-u`, with `u,v∈S` and `x,y∉S`. The omitted colors of `vx` and `yu` lie outside `S`. If the omitted color of `xy` were `s∈S`, its supporting triple `sxy` would make `s` a neighbor of both `x` and `y`. Uniqueness of their neighbors in `S` would force `s=v=u`, impossible. Therefore no changed internal color can collide with an unchanged color in this cycle.

This argument remains valid when all diamonds are recolored simultaneously. Changed colors from different diamond supports belong to disjoint sets. If both changed edges belong to one support, their C4 is wholly inside that support and is explicitly rainbow.

Finally, a collision between two unchanged edges would already have been a collision in the original omitted-point coloring. The previous localization lemma says every such bad C4 is contained in one diamond or one isolated three-triple block; those cases are handled locally. Thus no other collision survives.

An ordinary diamond now contributes **five** graph edges, improving the earlier construction's four. A singleton triple contributes three.

### Isolated blocks and the extremal count

An isolated three-triple block on five vertices can be replaced at graph level by the following seven-edge graph using five colors:

`01:4, 02:3, 03:2, 04:0, 12:1, 14:4, 23:0`.

Its only two C4s are `0-1-2-3-0` and `0-2-1-4-0`; their colors are respectively `(4,1,0,2)` and `(3,1,4,0)`. Thus the block loses only two edges relative to three times its triple count. Isolation makes this replacement independent of the rest.

The previous extremal replacement lemmas in `research-2026-10-14/shadow-extraction-proof.txt` show that an extremizer has at most one isolated five-point block and, if it has one, has no ordinary diamond. The first lemma uses a seven-triple linear gadget on ten vertices; the second uses the six row/column triples of a 3×3 grid to replace a block plus diamond. Their proofs are written, with a finite certificate for the first gadget, not formalized general arguments.

For `n≥8`, if an extremizer has no five-point block, it has `b≤floor(n/4)` disjoint diamond supports, and the construction gives `3g(n)−b` edges. If it has one block, it has no diamonds and the construction gives `3g(n)−2`, at least the claimed bound. The exceptional whole three-edge family on four points is not extremal for `n≥8`, because the four linear triples `012,234,456,670` are (7,4)-free.

For `n=7`, `g=3`, so the bound requires only eight edges. The seven-edge five-vertex graph displayed above, with a triangle attached at one vertex using two additional vertices, has ten edges and still every C4 rainbow. Thus the claim holds there as well.

### Literature status

Primary sources checked in this session:

- Füredi, *2-Cancellative Hypergraphs and Codes* (2012), especially §8: <https://iuuk.mff.cuni.cz/~samal/DS/S0963548311000563a.pdf>.
- Burr–Erdős–Graham–Sós, *Maximal anti-Ramsey graphs and the strong chromatic number* (1989), pp. 272–273: <https://fanchung.ucsd.edu/ron/papers/89_04_maximal_antiramsey.pdf>.

The basic hypergraph reduction and the overlap decomposition are prior art. The new point relative to the existing local archive is the safe recoloring lemma retaining all five diamond-shadow edges. A targeted publication search is still needed before any originality claim.
