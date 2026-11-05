# Second-pass novelty audit — 14 October 2026

The first audit missed important prior art. In particular, the overlap-component argument and its `2N/5` additive linearization bound were published in 2012. The exact residue formula is a small arithmetic refinement of that proof. The obstruction classification for proper bipartite colorings was published in 2023. Neither should be presented as a newly discovered structural advance on Erdős #810.

## Direct prior art for additive linearization

Zoltán Füredi, **2-Cancellative Hypergraphs and Codes**, *Combinatorics, Probability and Computing* **21** (2012), 159–177, DOI [10.1017/S0963548311000563](https://doi.org/10.1017/S0963548311000563). [Full paper](https://iuuk.mff.cuni.cz/~samal/DS/S0963548311000563a.pdf).

The proof of Theorem 4.1, §8, printed p.166 (PDF index 8), explicitly asserts that every `(7,4)`-free triple system H has a linear subfamily of size at least `|H|−2N/5`. Its proof removes two edges from each three-edge overlap component on five vertices, then one edge from each remaining two-edge component; supports of these components are disjoint. This is the same structural mechanism rediscovered in the audit. Theorem 4.1 itself, printed p.163, compares `(7,4)`-free systems with 2-cancellative systems. Proposition 8.2, p.167, already identifies the two forbidden configurations in linear tripartite systems.

The p.166 argument silently omits the three-edge system on four vertices. Under our convention that the union of every four edges has size at least eight, this is an exceptional case when N=4. It does not affect the bound for N≥5. The sharp audit formula

`L(N) = 2 floor(N/5) + 1_{N mod 5 = 4}`

improves the integer interpretation `floor(2N/5)` only when `N ≡ 3 (mod 5)`, by one edge. The extremal gadget argument establishes sharpness, but originality of this exact rounding statement has not been established.

## Known classification of proper-coloring obstructions

András Gyárfás and Gábor N. Sárközy, **“Less” Strong Chromatic Indices and the (7,4)-Conjecture**, *Studia Scientiarum Mathematicarum Hungarica* **60** (2023), 109–122, DOI [10.1556/012.2023.01539](https://doi.org/10.1556/012.2023.01539). [Full paper](https://real.mtak.hu/191892/1/012-article-p109.pdf).

Printed pp.111–112 define A-colorings (proper, no bichromatic four-edge path or cycle), B-colorings (proper, all C4 rainbow), and C-colorings (both). Figure 2, p.112, explicitly shows the projections of the two linear tripartite `(7,4)` obstructions: a three-colored C4, an alternating four-edge path, and an alternating C4. Proposition 1.6, p.113, establishes the equivalence of the C-variant and the `(7,4)` conjecture; its proof is on pp.116–117. Question 1.3 is the B-variant. Proposition 1.4 says a positive answer to either the A- or B-variant implies the conjecture.

Thus the audited “rainbow C4 plus no bichromatic four-edge path” classification is prior art, including the distinction between B and C. The paper's introduction cites only a weaker one-third linearization through Solymosi; this does not erase Füredi's earlier additive result. The paper does not visibly supply the general, possibly improper coloring-to-proper-subgraph bridge being explored in the current audit.

## Latest 2026 paper on perfect B-colorings

András Gyárfás, Gábor N. Sárközy, Adam Zsolt Wagner, **Perfect proper edge colorings of regular bipartite graphs with rainbow C4-s**, *Discrete Mathematics* **349** (2026), 115005, DOI [10.1016/j.disc.2026.115005](https://doi.org/10.1016/j.disc.2026.115005). [Publisher page](https://www.sciencedirect.com/science/article/pii/S0012365X26000294).

The primary abstract defines f(d) as the smallest part size of a d-regular bipartite graph with a B-coloring into d perfect matchings. It establishes superlinearity for shifted and, more generally, translation-invariant colorings, relates equality in its general lower bounds to symmetric designs, and determines several small cases. The publisher's indexed abstract loses its formulas. The author bibliographies and public metadata identify the paper, but an accessible primary full-text copy has not been recovered: publisher HTML/PDF requests returned 403, and the public API supplies metadata but requires authentication for its full view. This is an access limitation, not evidence of mathematical novelty.

**Search lead only, requiring primary confirmation:** [an abstract transcription](https://eurekamag.com/research/102/778/102778796.php) reports `f(d)≥2d+1` for odd d and `f(d)≥2d−1` for even d, and `f(3)=7`, `f(4)=8`, `f(5)=12`, `12≤f(6)≤14`, `f(7)=16`. These exact numbers should guide further checking, not be attributed to a primary text we have not inspected. In particular, the elementary bound `n≥2d−1` and the symmetric-design equality obstruction cannot safely be described as new.

## Projection refinements and their status

The BEGS1989 implication from sparse triple systems to rainbow-C4 colorings is already known. [BEGS full paper](https://fanchung.ucsd.edu/ron/papers/89_04_maximal_antiramsey.pdf), printed pp.272–273, gives the reduction in the original source; its definition of g there includes linearity. Our balanced two-part projection on 2n hypergraph vertices has retention probability

`p = 3n / (4(2n−1))`,

because each fixed triple has exactly two points in a uniform n-set with that probability. A C4 with a repeated color lifts to four distinct triples supported on at most seven points. For arbitrary `(7,4)`-free H, retaining one triple per projected graph edge yields the audit's expectation bound

`M(n) ≥ ceil(p|H| − n²(n−1)/(4(2n−1)(2n−3)))`, for n≥3.

The correction comes from exact local collision counting. We have not located this formula in the searched sources. That supports only the description “an explicit quantitative refinement derived during this audit, originality unestablished.” It supplies no new asymptotic regime or resolution of #810.

There is also a simpler same-size projection derived by the parent during the second pass. If H is `(7,4)`-free, every pair lies in at most three triples. Form the incidence bipartite graph between triples and their contained pairs. Left degrees are three; right degrees are at most three. Hence every family of triples has at least as many neighboring pairs, and Hall's theorem assigns a different contained pair to every triple. Color each chosen pair by the triple's omitted point. All edges are retained on the same N vertices, using at most N colors. A nonrainbow C4 would lift to four triples whose union has size at most seven. Therefore

`M(N) ≥ g_general(N;7,4)`.

The palette and graph may reuse the same labels; this is permitted in #810. An arbitrary Hall matching need not give a proper coloring, but the explicit component argument below can do so. This removes the need for linearization in this same-N implication, but it is a direct refinement of the established reduction. No claim of historical novelty is justified by the present search. It is distinct from asserting equality between the general and linear hypergraph extremal functions.

## Stronger same-size projections derived during the second pass

### Keeping one pair per triple, with a proper coloring

For every `(7,4)`-free H, one can choose a distinct representing pair for every triple so that the omitted-point coloring is proper. Consider components under adjacency when two triples share two vertices. Each component has at most three edges. Up to renaming vertices the nontrivial types, and valid omitted colors in the displayed edge order, are:

| Component triples | Omitted colors | Representing pairs |
| --- | --- | --- |
| `abc, abd` | `a, b` | `bc, ad` |
| `abc, abd, abe` | `a, b, e` | `bc, ad, ab` |
| `abc, abd, ade` | `b, d, e` | `ac, ab, ad` |
| `abc, abd, acd` | `c, a, d` | `ab, bd, ac` |

Singleton components can choose arbitrarily. Repeated representing pairs would give two shared hypergraph vertices, and same-colored incident graph edges would also give two shared hypergraph vertices. Either event therefore occurs within one component, where the displayed choices exclude it. A nonrainbow C4 lifts to four distinct triples with union at most seven, which is forbidden. Thus the exact same-N inequality can be strengthened to the proper version of M. The small component classification underlying this construction is already in Füredi's 2012 proof; no published occurrence of this choice-of-pairs corollary was located, but its originality is unestablished.

### Keeping the entire shadow of a linear hypergraph

If H is linear, every pair belongs to at most one triple. Use all three pairs of every triple, colored by the omitted third point. This produces a simple proper coloring of the full 2-shadow with exactly `3|H|` graph edges and at most N colors.

If H is also `(7,4)`-free, every C4 is rainbow. Indeed, properness means that any repeated color on a C4 occurs on opposite edges. Label the cycle `a-b-c-d-a` and suppose `ab` and `cd` both have color z. Then z lies outside the four cycle vertices, and their lift triples are `abz` and `cdz`. The lift of `bc` differs from both: equality would force z to equal a cycle vertex. The lift of `da` likewise differs from both, and these two cross lifts differ from each other because a triple cannot contain all four cycle vertices. These are four distinct triples whose union consists of `a,b,c,d,z` and at most the two cross-edge colors, at most seven vertices, a contradiction. Consequently

`M_proper(N) ≥ 3 g_linear(N;7,4)`.

The factor three is exact for this full-shadow operation. Combined with Füredi's deletion bound alone, it gives `M_proper(N) ≥ 3 g_general(N;7,4) − 3L(N)` for N≥5. The parent audit separately investigates stronger extremal rewiring bounds; those require their own verification and are not consequences of Füredi's deletion statement. The full-shadow proof is a useful concrete strengthening of the audit's earlier balanced/Hall projections. We have not established that it is historically new.

### Exact link with 2-cancellative linear triple systems

For an arbitrary linear triple system H, its natural omitted-point coloring of the full 2-shadow has every C4 rainbow **if and only if H is 2-cancellative**. Here 2-cancellative means there are no four distinct triples A,B,C,D such that `A∪B∪C = A∪B∪D`.

The nonrainbow cycle just described proves one direction: set `C=abz`, `D=cdz`, and let A and B be the two cross-edge lifts. Then A and B cover `a,b,c,d`, so adding C or D has the same effect, namely adding z if needed.

Conversely, suppose the union equality holds for four distinct triples. Then `C\(A∪B) = D\(A∪B)` is a subset of `C∩D`. If C and D were disjoint, A and B could cover at most four of their six vertices by linearity, impossible. Thus C and D share exactly one vertex z; write `C=abz` and `D=cdz` with a,b,c,d all distinct. A and B must cover these four vertices. Each meets each of C and D in at most one vertex, so each contains one vertex from `{a,b}` and one from `{c,d}`, with the two cross pairs disjoint. Neither A nor B contains z. Relabeling within C and D makes the pairs `bc` and `da`, and the shadow has a C4 with opposite edges `ab,cd` both colored z.

This proves an exact characterization, stronger than the sufficient `(7,4)` condition. It does not characterize arbitrary proper rainbow-C4 graphs: omitted-point shadow colorings have extra triangle and label consistency. Füredi's 2012 paper already supplies the 2-cancellative framework, and §8 also shows that a general 2-cancellative triple system can be made linear with at most N deletions. Hence, writing `c2(N,3)` for its extremal size, the characterization gives `M_proper(N) ≥ 3c2(N,3)−3N`. That is a direct corollary of the framework, not evidence of a new asymptotic bound.

Searches for the full-shadow/rainbow-C4 characterization and exact factor three did not recover a matching statement. Related omitted-point/link colorings are standard elsewhere: for example, [Keevash–Mubayi, Stability theorems for cancellative hypergraphs](https://people.maths.ox.ac.uk/keevash/papers/cancellative-stability-journal.pdf), Lemma 2.1, printed p.166, colors pairs by their link vertex and relates ordinary cancellativity to rainbow triangles. That concerns 1-cancellativity and a union of three links, not the exact 2-cancellative/C4 equivalence above. The appropriate novelty wording remains “proved during this audit; originality unestablished.”

## Finite results and an additional 2023 source

The computational agent's certificate-backed claims `M(11)=34` and the classification of extremal 10-vertex, 30-edge underlying graphs as the complements of the pentagonal prism and the 10-vertex Möbius ladder have no matching primary-source statement in the searches performed here. This is not a bibliographic proof of novelty. Their mathematical status should be stated separately from their historical status and supported by the saved search and verification certificates.

Another relevant primary source is [Gyárfás–Sárközy, Proper Edge Colorings of Cartesian Products with Rainbow C4-s](https://link.springer.com/article/10.1007/s00373-023-02697-x), *Graphs and Combinatorics* **39** (2023), 98. Its openly accessible full text studies B-chromatic indices of Cartesian products, cubes, and products of cycles. It does not give these all-graph finite extrema or the full-shadow characterization. Its references include Faudree–Gyárfás–Lesniak–Schelp, *Rainbow coloring of the cube* (1993), and Faudree–Gyárfás–Schelp, *An edge coloring problem for graph products* (1996), emphasizing that the rainbow-C4 terminology has a longer history than the 2023 proper variant.

## Subsequent rewiring and shadow refinements

The parent audit subsequently derives, for N≥5,

`g_general(N;7,4) ≤ g_linear(N;7,4) + floor(N/4)`.

This is an extremal comparison using rewiring, not a theorem that every input H has a linear subfamily of that size. A set of three triples on five vertices is isolated from every remaining edge. It can therefore be replaced on those same five vertices by two linear triples, losing one edge rather than the two potentially required by deletion. A two-edge overlap component uses four vertices and costs one deletion. Thus `5a+4b≤N` bounds the total loss `a+b` by `floor(N/4)`. The exceptional three triples on four vertices are the entire edge family and, when N≥5, can also be replaced by two intersecting-in-one-point triples on five vertices. At N=4 the stated extremal inequality is false: the general maximum is three and the linear maximum is one.

For the stronger graph inequality, the audit keeps four suitably chosen shadow edges from each ordinary two-edge overlap component, losing two relative to three times the triple count; an isolated three-on-five block is rewired to two linear triples, giving six shadow edges and losing three. Furthermore, two disjoint isolated three-on-five blocks can be replaced by seven linear triples on the same ten vertices:

`457, 349, 248, 189, 367, 058, 016`.

The local artifact `linear10-seven-certificate.json` records this gadget, and `ExtremalReplacementCertificate.lean` certifies it. Replacing the six original triples by seven preserves `(7,4)`-freeness, since all old remaining edges are disjoint from these ten vertices and mixed collections of four triples have sufficiently large union. Hence an extremizer has at most one isolated three-on-five block. The resulting audit inequality is

`M(N) ≥ 3g_general(N;7,4) − floor(N/2) − 1_{N mod 4 = 1}`, for N≥5.

Here M is the original, possibly improper coloring parameter: keeping four natural shadow edges from a diamond need not preserve properness. The loss follows by maximizing `2b+3a` subject to `4b+5a≤N` and `a∈{0,1}`. The case of an entire family on four vertices must be handled separately, as above. The parent proof additionally checks that remaining nonrainbow shadow cycles localize to the overlap blocks; those checks are recorded in `shadow_localization_check.py` and `shadow-localization-checks.json`. This paragraph summarizes the combined audit derivation; the detailed proof and certificates, rather than the literature search, establish mathematical validity.

No inspected primary paper states either of these exact inequalities. The conceptual ingredients are close to Füredi's existing decomposition and the longstanding hypergraph-to-coloring reduction, so “new theorem” or “previously unknown” would overstate what the search establishes. They are precise strengthened reductions proved during the audit, with external originality unresolved, and they give no new subquadratic bound or resolution of #810.

The final proof improves the graph correction further to
`M(N) ≥ 3g_general(N;7,4) − 2 floor(N/4)`, for `N≥5`.
An extremizer cannot contain both an isolated five-point block and an ordinary
diamond: a six-triple grid on their nine vertices replaces the five old triples
while preserving every mixed four-edge condition. The detailed external-edge
checks and the small-order cases are in `shadow-extraction-proof.txt`. This is
the final bound summarized in `RESEARCH.md`; the preceding formula remains valid
but is weaker.

## Other primary sources checked and limits of the search

- [Gishboliner–Shapira, Constructing Dense Grid-Free Linear 3-Graphs](https://people.math.ethz.ch/~lgishboli/grid_free.pdf), *Proc. AMS* 150 (2022), 69–74: introductory footnote 1 gives a general constant-factor passage to linear hypergraphs. It does not improve on Füredi's additive result in the `(7,4)` case.
- [Solymosi, The (7,4)-conjecture in finite groups](https://arxiv.org/pdf/1309.0133): Theorem 5, preprint p.4, rules out positive-density subsets of a finite multiplication table whose relevant rectangles all have unequal opposite products. This blocks the proposed dense sum/product-coloring approach when the ambient group has order O(n). It does not settle arbitrary quasigroup colorings or embeddings in a much larger group.
- [Shapira–Tyomkyn, A new approach for the Brown–Erdős–Sós problem](https://arxiv.org/pdf/2301.07758), §2: invokes the known reduction to linear tripartite systems and studies an auxiliary graph on pairs. It does not establish the exact additive rounding formula or the same-size Hall projection above.
- [Glock–Kim–Lichev–Pikhurko–Sun, On the (k+2,k)-problem ...](https://arxiv.org/html/2403.04474v2), and [the October 2026 quadratic BES paper](https://arxiv.org/abs/2610.03323), concern the quadratic `k+2` regime. Their deletion lemmas and extremal densities do not settle the `k+3`, `(7,4)` case.

No inspected primary source established a theorem that the nonlinear and linear `(7,4)` extremal numbers are exactly equal for all sufficiently large N. Such equality is false for some small N (on four vertices, three triples are allowed but a linear family has at most one). We should neither claim eventual equality nor infer its novelty or falsity from unsuccessful searches.

The first-pass notes in `audit-2026-10-14/literature-notes.md` predate the decisive 2012, 2023, and 2026 source checks. Use this document to qualify their novelty language.
