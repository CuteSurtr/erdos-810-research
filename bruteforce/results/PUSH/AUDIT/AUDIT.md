# Referee audit of the draft `paper/main.tex` (PUSH/AUDIT, 2026-10-25)

Scope: `paper/main.tex`, `paper/OUTLINE.md`, `paper/refs.bib`, `paper/make_tables.py` and the task
reports they cite, all read at commit 4443afa of `bruteforce-2026-10`. Nothing under `paper/` was edited.
Every check I ran myself is in `src/` and its output is in `logs/`. The placement is in `REPORT.md`.

How to read this file:
- **[A]** must fix before submission: a false statement, or a claim stronger than its evidence.
- **[B]** should fix: imprecise wording, a minor gap, or an inconsistency.
- **[C]** optional polish.

For each item I give the location, the problem, and **exact replacement wording** where useful.

---

## 0. Summary

- **Mathematics.** I found no fatal error. Lemma 1, the PRUNE argument, the SAT symmetry-breaking
  argument, Lemma 2, Lemma 3 and Proposition 4 are all correct as mathematics.
  - Lemma 3 omits one small step, injectivity of d ↦ e (§1.5).
  - Proposition 4 needs its asymptotic statement made precise (§1.6).
  - The b ∈ {0,1} claim has no proof in the paper. A two-line proof is given in §1.6.
- **Overclaims.** The most serious issues are in the abstract:
  - "linear … rules give o(n)" is proved only for slopes that are fixed rationals of bounded
    height (§4.1).
  - "exact optimum for 12 ≤ n ≤ 42 (n ≠ 35) and n = 47" includes four values that do not rest on a
    standard-checker proof (§4.2).
  - "SAT proofs checked by DRAT for n ≤ 11" is true only for n = 9, 10, 11 (§4.3).
- **Numbers.** Almost every number I checked matches its source, and many are confirmed by my own
  independent code (§2). The exceptions are:
  - **Table 2 has 10 rows below the paper's own trivial padding bound** M(n+1) ≥ M(n)+1. These are
    n = 54, 55, 62, 63, 64, 65, 101, 106, 118 and 122 (§2.4).
  - The "Other families" density ranges do not match CONSTR's table (§2.6).
  - The type labels at n = 18 and 21 say "symmetric", although a cyclic construction gives the same
    count (§2.4).
- **Tables.** `make_tables.py` regenerates `tables/cyclic.tex`, `tables/lower_bounds.tex` and
  `data/best_lower_bounds.json` **byte-identically** (§2.1). However, the "exact" status column of
  Table 3 is hard-coded in the script and not derived from result files.
- **References.**
  - GT17 is correct; the TODO can be removed (DOI added below).
  - The CaDiCaL entry cites the 2024 competition description. That is not the right reference for
    the solver versions actually used (§3).
  - Kissat, march_cu/cube-and-conquer, PySAT, Roth, Ajtai–Szemerédi and Erdős #1178 are used or
    mentioned but not cited.
- **Status may already be stale.** Today's PUSH/N44A/B/C and CERT tasks are pushing proofs for
  n = 44, 38, 42, 47 and 35. Before submission, re-read `results/PUSH/*/REPORT.md` and update the
  abstract, the Remark on n ≡ 0 (mod 4), Table 3 and open problem 3. Remote commit e675c99 already
  reports that C1's LRAT cubes were re-proved with cake_lpr.

---

## 1. Mathematics, line by line

### 1.1 Conflict graph and Lemma 1 (heredity): correct

- **Definition of Q(G).**
  - Adjacent edges uv, vw lie on a common C4 iff there is an x ∉ {u, v, w} with x ~ u and x ~ w.
    x ≠ u, w is automatic, so "a common neighbour other than v" is right.
  - Disjoint edges uv, xy lie on a common C4 iff the cycle is u-v-y-x (ux, vy ∈ E) or u-v-x-y
    (uy, vx ∈ E). Right.
- **Lemma 1.** The proof is complete. In the "in particular" part, the step from "an n-good graph
  with > e+1 edges" to "an n-good graph with exactly e+1 edges" is the deletion argument, which the
  proof states.
- **[B] "Trivially M(n+1) ≥ M(n)+1."** This fails at n = 0, since M(1) = 0 = M(0). It needs n ≥ 1,
  because the pendant edge needs an existing vertex. Wording: "For n ≥ 1, M(n+1) ≥ M(n)+1: …".
  The same remark should drive Table 2 (§2.4).
- `M(n) ≥ ex(n, C4)`: correct for n ≥ 1, since one colour is available.

### 1.2 PRUNE soundness (§3.1): correct

geng extends by adding a vertex together with its neighbourhood, so every ancestor of an output is an
induced subgraph of it. k-goodness (k fixed at the final n) is closed under vertex deletion, so no
ancestor of a good output is pruned. M12 §4.1 also notes that PRUNE is applied to the final graphs.

**[C]** Say explicitly that k is fixed to the *final* n, not the current vertex count. The text does
say "where n is the final number of vertices"; good.

### 1.3 SAT symmetry breaking (§3.3, SAT REPORT §4.2): correct, with two wording gaps

I re-derived the V2 condition.

- L(G) is the set of labellings satisfying V1. For 1 ≤ i < j in the same block with deg i = deg j,
  the transposition (i j) preserves vertex 0, N(0) = {1..deg 0} as a set, and the per-block degree
  order. So it maps L(G) to itself, and a lex-max element x of L(G) satisfies x ≥lex x∘(i j).
- In row-major order, the first positions that (i j) moves are (a,i)/(a,j) for 1 ≤ a < i. The next
  are (i,b)/(j,b) for b > i, b ≠ j. Every other moved position is a later twin.
- So the condition is exactly "row i ≥lex row j on the columns ∉ {0, i, j}", as the report says.
- The colour relabelling is applied after π and does not change G, so the combination is sound.
- I independently confirmed the empirical test's denominator. Of the 156 graphs on 6 vertices,
  **127 are 6-good** (`src/smallgood.py`, `logs/smallgood_n6.log`). The same run gives M(6) = 11
  with a unique extremal graph.

Wording gaps:

- **[B]** "Degrees are non-increasing within the neighbourhood of 0 and within its complement." The
  complement must be V ∖ N[0], excluding vertex 0. Vertex 0 cannot take part in the transpositions,
  since swapping 0 breaks V1. Write "within N(0) and within V∖N[0]", and in item 3 "for transpositions
  of equal-degree vertices i, j ≥ 1 in the same block".
- **[B]** "We also tested soundness exhaustively" holds for n = 6 only. Write "exhaustively at n = 6,
  where every one of the 127 … ; at n = 7, 8 on 200 random good graphs each".
- **[C]** A DRAT/LRAT check certifies only that the CNF is UNSAT. The link from CNF to theorem rests
  on the encoder and on the soundness argument, validated on n ≤ 9 (SAT) and on brute force (cyclic).
  One sentence saying this would pre-empt a referee.

### 1.4 Lemma 2 (walk and collision criterion): correct

- The colour formulas follow from the definition.
- Edges of one orbit d are {j, j+d}, and since d ≤ H < n/2 the representation j is unique. So two
  distinct edges of orbit d have distinct offsets j and distinct colours j + g(d).
- The reduction to cycles through 0 is by rotation. Every 4-cycle contains a vertex, and rotation
  adds a constant to all colours.

**[C]** Note that H = ⌈n/2⌉ − 1 deliberately excludes the diameter orbit n/2 for even n. This
uniqueness of j uses it. It is also a restriction of the family, so the definition of k_max(n) is
relative to it.

### 1.5 Lemma 3 (multiplier action): correct, one step missing; numerics confirmed

- The proof is right. The images of the two cases are {j, j+e} with j = ui or j = ui − e, and the
  colours are as stated. For even n, e ≠ n/2 because u is odd, so ud ≡ n/2 would force d ≡ n/2.
- **[B] Missing step.** The map d ↦ e must be injective, so that |D′| = |D| and the multipliers act on
  solutions with a fixed k.
  - If ud ≡ ±ud′, then d ≡ ±d′. Since 1 ≤ d, d′ ≤ H < n/2, this gives d = d′.
  - Add: "Since u is a unit and D ⊆ {1, …, H}, the map d ↦ e is injective, so |D′| = |D|."
- **[C]** "Together with the colour translations … gives the symmetry group". The pairs (u, t) act
  through i ↦ ui and c ↦ uc + t. This is a group action of Z_n^× ⋉ Z_n on colourings, and Γ(n, D′, g′)
  is the unique cyclic representation of the image, so it is an action on pairs (D, g). One clause
  would make this explicit.

**Numerical check (independent code, `src/cycgroup.py`, `src/lemma3_check.py`, `logs/lemma3_check.log`).**

- For n = 20, 21, 24, 27, 28, 31, 32, 36, 40 I took every normal form in CYCPAT's
  `solutions/enum_n*_k*.json` and applied every unit u with my own implementation of g′. I then
  checked each image with my own explicit-graph checker, which enumerates all 4-cycles through
  pairs of common neighbours.
- **Result: all images are valid.**
  - Over n ∈ {20, 21, 24, 27, 28, 31, 32}, the distinct normalised images number 1320 + 4 + 2884 +
    180 + 3420 + 30 + 2048 = **9886**, exactly the paper's figure.
  - The paper's count is of distinct images. Counted per (form, unit) there are 9906.
- **The "drop the +e" variant fails** for every u ≠ 1 at every n tested, not only at n = 28 and 40.
- The recomputed orbit counts equal CYCPAT's n_orbits at every n tested: 165, 1, 362, 10, 285, 1,
  128, 59, 4.

### 1.6 Proposition 4 and its remarks

**Main implication: correct.**

- With d1 = m+vr, d2 = m+(v−u)r, d3 = m, d4 = m+ur we get d1 − d2 + d3 − d4 = 0.
- The walk visits 0, d1, ur, d4. The six pairwise differences d1, ur, d4, (v−u)r, d2, m are all
  ≢ 0 under the hypotheses.
- Edges 1 and 3 get bm + bvr ≡ bm + ur and ur + bm.
- Four distinct vertices on a closed 4-walk give four distinct edges, so this is a genuine C4
  subgraph.
- The d_i need not be distinct as integers (d2 = d4 when v = 2u), and that does no harm.

**Random test, `src/prop4_check.py`.**

- Setup: n ∈ [15, 70], u ∈ [−4, 5], v ∈ [1, 4] with gcd(v, n) = 1, random non-degenerate patterns,
  g prescribed only on d1 and d3, every other g value random.
- Result: 3286 instances, **0 valid**, as the proof predicts. The remark "the proof uses only g(d1)
  and g(d3)" is thereby confirmed numerically too.

**Consequence |D| = o(n): correct in substance. State it precisely.**

- **[B]** "Consequently |D| = o(n)" needs the quantifiers. Suggested wording:
  "Consequently, for fixed u, v and every δ > 0 there is n₀ such that, for n ≥ n₀ with gcd(n, v) = 1,
  every such D has |D| < δn."
- **[B] Szemerédi for a general pattern.** Sz75 gives arithmetic progressions. Add half a sentence:
  P = {0, v, v−u, u} − min P lies in {0, …, L} with L = max P − min P. Hence any (L+1)-term AP
  a + r·{0..L} contains the copy (a − r·min P) + r·P with the same r ≥ 1.
- **[B] Varnavides.** Var59 proves the "many 3-APs" statement. Its averaging argument applies verbatim
  to (L+1)-APs given Szemerédi. Write "by the averaging argument of Varnavides [Var59]" rather than
  attributing the general count to [Var59].
- **The O(n) degenerate count is correct.** r ranges over 1..H < n. The number of r with ur ≡ 0 is
  gcd(u, n) − 1 ≤ |u| − 1, and similarly for v − u. Both u ≠ 0 and v − u ≠ 0 hold because b ∉ {0, 1}.
  Each r has ≤ n choices of m. Against ≫_δ n², the bound "at most |u| + |u−v| residues" is a valid
  overestimate.

**b = 2 ⇒ 4-AP: correct.**

- With u = 2, v = 1 the pattern is {m−r, m, m+r, m+2r}.
- Non-degeneracy holds automatically: 2r ≤ 2H/3 < n and −r ≢ 0. So D has *no* 4-AP at all, and
  |D| ≤ r₄(H).
- With GT17, r₄(H) ≪ H(log H)^{−c}, so O(n(log n)^{−c}) is right.
- Note that CYCPAT §6.3 quotes the weaker GT II bound n·exp(−c(log log n)^{c′}). The paper's GT17
  form is the stronger and correct citation.

**Piecewise-affine remark: correct, with one caveat.**

- Apply the argument to A (a piece with g ≡ bd + c) with d1, d3 ∈ A and d2, d4 ∈ D. Then each piece
  of slope b ∉ {0, 1} has |A| = o(n), uniformly in c, and boundedly many pieces give |D| = o(n).
- **[B]** Add "with each slope b = u/v of bounded height and gcd(v, n) = 1".

**b ∈ {0, 1}, "such a piece has at most one element": true, but no proof is given.**

- **[B]** Add one sentence:
  "If d ≠ d′ lie in a piece with g ≡ c (resp. g ≡ d + c), the 4-cycle 0, d, d+d′, d′ has the two
  edges at 0 (resp. the two edges at d+d′) of the same colour c (resp. d+d′+c)."
- I checked this by hand and on 2000 random instances, with 0 valid.

**Other claims in this section.**

- **[A]** "Every fixed index eventually fails" in the Coset-rules experiment is an empirical
  statement for r = 4, 6, 8, 10, 12 only (CYCPAT §6.2). Suggested wording:
  "For each index r ≤ 12 that we tested, the rule stops working beyond a finite prime (the last
  successes are p = 61, 643, 1993, 4271 and ≥ 9013 for r = 4, …, 12)."
- **[C]** The sum-colouring bound in "Other families" (|E| ≈ r₃(n)·n/2 by Roth) is correct, but the
  paper gives no argument. Sketch: if s, t, 2s − t ∈ S with t ≠ s, choose b + c = t with b ≠ c and
  2b, 2c ≠ s. Then a = s − b, d = s − c gives a 4-cycle a, b, c, d with a + b = c + d. So S has no
  non-trivial 3-AP. Cite Roth (1953) for Z_n.

---

## 2. Numbers

### 2.1 Tables regenerate identically

I copied `paper/` to the scratchpad, linked `bruteforce/` beside it, and ran `python3 make_tables.py`.
This took 184 s and reported "verified 220 certificates; best bounds for 100 values of n; cyclic data
for 64". The three outputs are byte-identical to the committed files:

| file | sha256 |
|---|---|
| tables/cyclic.tex | aca312a1452397dd61f89bdcc725095abaf130ad097307b4e62a373d3d9feb2c |
| tables/lower_bounds.tex | 70b13b54c9b6c44f26f3a206e595e938956569a70a88df77bd5a3e2e6dfeb848 |
| data/best_lower_bounds.json | 891a294c008cb929514727fab6b1152351d02b41d39b2b2072d4b23d6e169368 |

- **[B] The Table 3 status column is not regenerated from data.** `CYCLIC_EXACT` (k_max and the
  proof label for every "exact" row) is typed into the script. The only data check is that no cyclic
  certificate beats it. So the Appendix sentence "regenerates Tables 2 and 3" is true of the
  numbers, but not of the proof statuses.
  - Either read the statuses from the task `table.tsv` files and proof logs, or say:
    "The exact values and proof statuses in Table 3 are entered from the task reports; the script
    checks them against every certificate."

### 2.2 All 100 cited certificates re-verified by an independent checker

- `src/certcheck.py` re-reads every certificate named in `data/best_lower_bounds.json` from its source
  file. It checks, by its own code: simple graph, colours in 0..n−1, and every 4-cycle rainbow (all
  pairs of common neighbours of every vertex pair).
- **100/100 OK**, and each edge count matches (`logs/certcheck.log`).
- `src/leancerts.py` extracted cert4..cert12 from `formalization/legacy/BruteForce.lean` (branch
  `lean-formalization`, read only). All 9 are valid with 5, 7, 11, 14, 17, 23, 30, 34, 40 edges.
- The Lean file contains no `sorry`, `admit` or `native_decide`, and ends with `#assert_no_sorry` over
  the cited theorems. I did **not** compile it (no Lean toolchain in this container).

### 2.3 Exact-value section (Table 1, §3)

| claim in paper | source | my check |
|---|---|---|
| Pólya counts 71,318 / 24,630,887 / 15,108,047 / 2,411,961,516 | M12 §2.1 | **reproduced** by my own cycle-index code, `src/polya.py` (also (13,48) = 584,089,835,857, as quoted in §7) |
| four V12 totals sum to 2,411,961,516 | V0–V3 | **sums exactly** |
| "all but 753 … 13-clique" | V0–V3 bad_by_search 185+193+191+184 | = 753 ✓ |
| main pruned run: 512 shards, 9,165 CPU-s, no output | M12 §4.3 | ✓ |
| (11,35): only 2 graphs avoid a 12-clique | V12 tables | ✓ (15,108,045 + 2) |
| one of 131 extremal 11-graphs is 10-good | M12 §2.2 | ✓ |
| 3,330 good (12,40) graphs with Δ ≤ 9 | M12 §2.3 | ✓ (it is a one-method count, as the paper says) |
| (11,35) Δ = 7: 926 s solve, 1645 s check | SAT §4.3 | ✓ |
| (12,41) DRAT cubes Δ ∈ {0..6,10,11} | SAT §4.4 | ✓ = 9 of 12 |
| extremal counts 5, 45, 3, 2, 131 | M12 §4.2, V12 | ✓ (matching across 4+ checkers); n = 6: my code gives 1 |
| 127 good classes on 6 vertices | SAT §4.2 | **reproduced** (my code) |

Issues in this section:

- **[A] Abstract: "SAT proofs that are checked by a DRAT proof checker for n ≤ 11".** By Table 1 and
  SAT §4.3, DRAT exists for n = 9 (full formula), 10 and 11 (all cubes). For n = 7, 8 the SAT runs
  have no checked proof, and n ≤ 6 is covered by Lean. Suggested wording:
  "…together with SAT proofs checked by a DRAT proof checker for 9 ≤ n ≤ 11, and Lean kernel proofs
  for n ≤ 6."
- **[A] "the new values being M(10) = 30, M(11) = 34 and M(12) = 40".** This implies that M(7..9) were
  known before. LITERATURE.md finds no published exact values, and the README attributes 7–9 to "an
  earlier exhaustive search" of this project. If nothing was published, say "the values for
  7 ≤ n ≤ 12 appear to be new", or cite the earlier source.
- **[B] Table 1, n = 12, "E (pruned, 2 checkers; …)".** Checker B covered only Δ ≤ 9 (M12 §4.3).
  Write "E (pruned: checker A; checker B for Δ ≤ 9 with S for Δ ≥ 10; unpruned, 4 checkers)", or add
  a footnote.
- **[C]** §3.1 Validation: "identical sets of good graphs for 6 ≤ n ≤ 11". M12 shows identical
  *counts* for n ≤ 10 and identical *sets* at n = 11. The counts are 0–3 at n ≤ 10, so this is
  harmless; "identical counts (and, for n = 11, identical sets)" is exact.
- **[C]** §3.3: "we estimate them at a few hundred core-hours". SAT §4.4 says "one to a few hundred
  core-hours, plus about as much again for DRAT checking … a guess". Keep "rough guess".
- **[C]** The Remark "all have maximum degree 7, 8 or 9": Δ ≥ 10 was searched in only 35% of the space
  (M12 §2.3). Write "all those found (the full Δ ≤ 9 range and 35% of the Δ ≥ 10 range) have …".

### 2.4 Lower bounds (Table 2, §4)

- AlphaEvolve values in `make_tables.py` match the list in LITERATURE.md (n = 4..25).
- "Improve AlphaEvolve for all 14 ≤ n ≤ 25": ✓. n = 13 matches (47 = 47).
- "M(21) ≥ 126 = 0.286 n²": ✓.
- "Explicit certificates for every 13 ≤ n ≤ 64": ✓, the table has no gap in 13..64.
- "Ratio near 1/4 up to n ≈ 40, about 0.17 at n = 128": ✓ (0.173).

**[A] Ten rows are weaker than the trivial padding bound that §2 of the paper states**
(`logs/monotonicity.log`):

| n | table | padding bound | from |
|---|---|---|---|
| 54 | 648 | 690 | M(53) ≥ 689 |
| 55 | 660 | 691 | M(53) |
| 62 | 806 | 916 | M(61) ≥ 915 |
| 63 | 819 | 917 | M(61) |
| 64 | 835 | 918 | M(61) |
| 65 | 910 | 919 | M(61) |
| 101 | 1867 | 1901 | M(100) ≥ 1900 |
| 106 | 992 | 1941 | M(103) ≥ 1938 |
| 118 | 1195 | 2282 | M(113) ≥ 2277 |
| 122 | 1267 | 2569 | M(121) ≥ 2568 |

- The rows for 106, 118 and 122 (≈ 0.086 n²) stand out as a referee red flag.
- Fix: have `make_tables.py` take max(certificate, best smaller m + (n − m)) and emit the padded
  certificate (add n − m pendant vertices, each joined to vertex 0 with colour 0; pendant edges lie
  on no C4). Mark these rows as type "padded".
- Alternatively, drop such rows. In either case, rewrite "drifts down to about 0.17" if the curve
  changes.

**[B] Type labels.**

- n = 18 (90 edges) and n = 21 (126 edges) are labelled "symmetric". The cyclic family attains the
  same counts: k_max(18) = 5 gives 90, and k_max(21) = 6 gives 126 (CYCPAT, CONSTR §2c example at
  n = 21).
- This happens because `load_all` does not read CYCPAT's `solutions/enum_*` files. Load them (the
  script already prefers "cyclic" on ties), or note that the type records the certificate actually
  stored.

### 2.5 Cyclic family (Table 3, §5)

**Independent brute force.** `src/cycbrute.c` is my own plain backtracking. It enumerates all D with
|D| = k and all g with g(min D) = 0, and checks every closed 4-walk through 0 directly for 4 distinct
colours. It uses no SAT, shares no code with CYCPAT, and is not told the collision criterion of
Lemma 2. Orbits are computed by my `src/cycgroup.py`.

BRUTE_TABLE_PLACEHOLDER

- **Everything matches** CYCPAT's brute-force and SAT-enumeration counts.
- The orbit counts 24, 58, 165, 362 (n = 12, 16, 20, 24) and the uniqueness at n = 18, 21 (and 31,
  via the CYCPAT list and Lemma 3 check) are confirmed.

**Other numbers checked.**

- k_max values 13..41 and the statuses in the generated table match C4's validation table (DRAT
  VERIFIED, n = 13–34 and 36), C0 (37, 40), C2 (39), C3 (41), C1 (38, LRAT with `src/lratcheck`),
  C4 (42, solver only) and C0 (47).
- **n = 47 coverage, re-checked independently** (`logs/cover47.log`): the 29 UNSAT cubes in
  `CYC/C0/logs/cube47.jsonl` cover all 512 assignments of p2..p10, with 0 uncovered.
  - p1 needs no split: 47 is prime, so every orbit is a unit and lex-leader forces p1 = 1.
- **n = 44.**
  - C1: 8/9 cubes UNSAT, 6 with LRAT checked by C1's own checker.
  - CYCPAT: 19/21 sub-cases.
  - The cover arguments of both splits are sound. C1's ¬p1 cube is a single D by the lex-leader
    (non-units in 1..21 are the 10 evens plus 11). CYCPAT's "unit" case maps a unit to 1 and then
    translates g(1) = 0.
- **[B] Remark (n ≡ 0 mod 4): "6 of them with checked LRAT proofs".** These were checked by a
  task-written checker, not a standard one. Write "6 of them with LRAT proofs checked by a
  task-written checker". Or, if PUSH/N44A's cake_lpr re-checks are final, say "checked by cake_lpr".
- **[B] "These counts come from complete SAT enumeration with blocking clauses."** The final UNSAT
  call of each enumeration is a solver result without a proof. Add "(solver results; for n ≤ 28 they
  agree with an independent brute-force count)". The CYCPAT brute force actually goes to n = 29, and
  this audit adds n ≤ BRUTE_MAXN.
- **[C]** Remark: "For several odd n, k_max(n)/n exceeds 1/4". It also exceeds 1/4 at the even
  n = 18 (5/18 = 0.278). Write "for several n (all odd except n = 18)".
- **[C]** §5.1, n = 12: "an independent backtracking counter (no SAT, no symmetry reduction)". The
  counter fixes g(min D) = 0, a translation normalisation. Write "no SAT; only colour translations
  are factored out".
- **[A] "No solution with k = n/4 has been found for any multiple of 4 in [44, 100]."** This is true
  but reads as if all were searched seriously.
  - n = 64 and n = 96 had no general cyclic search, only the linear rule g = 2d (CYCPAT `runs/lin2.jsonl`). Table 3 has no rows for them.
  - Several attempts were very short: n = 80, k = 20 for 60 s; n = 84, k = 21 for 10 min; n = 100,
    k = 25 for 497 s; n = 68, k = 17 for 499 s.
  - Suggested wording: "In time-limited SAT searches (from 1 min to a few hours) at
    n = 44, 48, …, 92 and 100 (not 64 or 96), no solution with k = n/4 was found."
  - The same correction applies to the Results bullet "no n/4 solution has been found for any
    44 ≤ n ≤ 100".

### 2.6 Other families (§6)

**[B]** CONSTR §2b gives, for n = 26..128:

- F1 (sum-set) between **0.078** (n = 128) and **0.143** (n = 27); restricted to n ≤ 64, 0.093–0.143.
- F2 (free edge set) between **0.136** (n = 127) and **0.238** (n = 32); restricted to n ≤ 64,
  0.170–0.238.

The paper's "0.10–0.13" and "0.17–0.21" were copied from CONSTR's prose, which does not match its own
table. Suggested wording: "about 0.08–0.14 n² … about 0.14–0.24 n² (n = 26..128)".

The affine-family numbers (0.48 at p = 5, about 0.30 at p ≈ 97–101, so 0.075 n² with n = 2p) match
AFFQ/AFFARB. BEGS (F5) is weaker throughout: ✓.

---

## 3. References (`refs.bib`)

Checked online where reachable. erdosproblems.com, renyi.hu and terrytao.wordpress.com did not
resolve from this container (DNS), so forum dates, the BEGS page number (p. 273) and Erdős #1178 are
**not independently checked**.

| key | verdict | action |
|---|---|---|
| BEGS89 | ✓ J. Graph Theory 13(3) 263–282, doi 10.1002/jgt.3190130302 | none (title is "anti-Ramsey" in the indexes; fine) |
| SS06 | ✓ J. Graph Theory 52(2) 147–156 (SZTAKI record) | The statement in the paper ("connected bipartite, neither a star nor complete bipartite") agrees with Fan Chung's problem page ("connected non-complete bipartite", stars being K_{1,t}). LITERATURE.md says the paper was not read; read it before submission, as the TODO says. |
| GT17 | ✓ Mathematika 63(3) (2017) 944–1040, arXiv 1705.01703, doi 10.1112/S0025579317000316 | **remove TODO**, add doi |
| CaDiCaL | the cited 2024 competition description exists (Biere, Faller, Fazekas, Fleury, Froleyks, Pollitt; Proc. SAT Competition 2024, Univ. Helsinki Report B-2024-1, pp. 8–10), but it is the wrong primary reference | **[B]** cite Biere et al., "CaDiCaL 2.0", CAV 2024, LNCS 14681, pp. 133–152, doi 10.1007/978-3-031-65627-9_7. State the versions actually used: CaDiCaL 1.7.3 (CYC/C1), 1.9.5 via PySAT (M12), "3.0.1" (SAT; please double-check this version string), plus Kissat (CYC/C0, C2, C4) |
| CMPS19 | ✓ Constraints 24(1) (2019) 1–24, doi 10.1007/s10601-018-9294-5 | add issue and doi |
| Var59 | ✓ J. London Math. Soc. 34 (1959) 358–360, doi 10.1112/jlms/s1-34.3.358 | see §1.6 on attribution |
| Sz75 | ✓ Acta Arith. 27 (1975) 199–245 | none |
| RS78 | ✓ (standard citation) | none |
| nauty | ✓ J. Symbolic Comput. 60 (2014) 94–112 | state nauty 2.8.8 in the appendix |
| dratTrim | ✓ SAT 2014, LNCS 8561, 422–429 | none |
| AE25 | ✓ arXiv:2511.02864, Georgiev, Gómez-Serrano, Tao, Wagner | none |
| EP810, TaoForum, TaoAE | not checked (DNS) | — |

**[B] Missing citations** for tools and results that are used:

- Kissat (n = 37, 39, 40, 42, 47 rely on it).
- march_cu / cube-and-conquer: Heule, Kullmann, Wieringa, Biere, HVC 2011.
- PySAT: Ignatiev, Morgado, Marques-Silva, SAT 2018.
- cake_lpr, if the PUSH re-checks are adopted.
- Roth's theorem (used in §6).
- Ajtai–Szemerédi (named in the introduction).
- Erdős problem #1178 (named in the introduction; add a `\cite`).
- LITERATURE.md also lists Bucić–Chen–Ma (arXiv:2603.18952), Yang (arXiv:2607.05896) and the
  Li–Ning–Xie P4 result. A related-work sentence would help, because the intro says "for P4 … the
  answer is negative", and Li–Ning–Xie reportedly answer a P4 question negatively too.
- **[B] Verify the P4 claim.** LITERATURE.md paraphrases BEGS Thm 6.3 as "χ_S(n, εn², P4) > cn". A
  negative answer to the P4 analogue needs χ_S(n, εn², P4) > n for large n, i.e. c ≥ 1 or /n → ∞.
  Please check the statement in BEGS (I could not reach the PDF).

---

## 4. Overclaims, with exact replacement wording

### 4.1 [A] Linear rules

- **Abstract**, "We also prove that offset rules that are linear, or piecewise affine with a bounded
  number of pieces, give only o(n) orbits." Replace with:
  > We also prove that offset rules g(d) ≡ bd + c with a fixed rational slope b ∉ {0, 1}, and more
  > generally piecewise-affine rules with boundedly many pieces whose slopes are fixed rationals,
  > give only o(n) orbits.
- **Results, last bullet.** Replace with:
  > Proposition 4: rules whose offsets are linear, or piecewise affine with boundedly many pieces,
  > with slopes that are fixed rationals (independent of n), give only o(n) orbits.
- **Why.** Every residue b mod n equals u/v with |u|, v ≤ √n. So "linear g(d) = bd" for an arbitrary
  residue b is *not* covered; the Varnavides constant depends on the pattern. CYCPAT §6.3 says so
  explicitly ("does not cover slopes depending on n, such as the coset rules"). The paper should
  repeat this caveat once in the text after the Remark:
  > Slopes depending on n, such as those of the coset rules below, are not covered.

### 4.2 [A] "Exact optimum for 12 ≤ n ≤ 42 (n ≠ 35) and n = 47"

Four of these values rest on something weaker than a standard proof checker:

- n = 12: solver plus brute force. That is fine, but it is not a proof certificate.
- n = 38: task-written LRAT checker.
- n = 42: two solvers, proof unchecked.
- n = 47: cube-and-conquer without per-cube proofs.

Suggested abstract wording, unless PUSH/CERT closes these today:

> For this family we determine the optimum k_max(n) for 12 ≤ n ≤ 42 (n ≠ 35) and n = 47; for
> n ≤ 41, n ≠ 12, 35, 38, the upper bound is certified by a proof checked with drat-trim, and for
> n = 12, 38, 42, 47 it rests on solver results (see Table 3).

The Results bullet "we compute the exact optimum" needs the same qualifier.

### 4.3 [A] DRAT for n ≤ 11 (abstract)

See §2.3.

### 4.4 [A] "No n/4 solution … for any 44 ≤ n ≤ 100"

See §2.5.

### 4.5 [B] "At n = 44 two independent exhaustive case splits leave only a few sub-cases open"

This is fine, but "exhaustive" should be "exhaustive (solver results)". Several of the closed cases
have no checked proof:

- C1: 2 solver-only cubes, and LRAT checked by its own checker.
- CYCPAT: all 19 cases are solver-only.

### 4.6 [B] The OUTLINE ledger is out of sync with main.tex

- OUTLINE §5 says "k_max(n) exact for 12 ≤ n ≤ 41 (n ≠ 35)", and contribution 3 says "n ≤ 41". The
  paper says ≤ 42 and adds 47.
- The OUTLINE's n/4 count list omits n = 12 (24).
- The ledger row "Proposition 4 … still needs an independent audit" can now point to this file.

### 4.7 [C] Smaller wording points

- Intro: "This note does that, and also pushes the constructions further". Fine.
- "Dropping the term e … fails for every u ≠ 1 at n = 28 and 40": true, and in fact at every n I
  tested (§1.5). Optional.
- Coset-rules experiment: "the best such k grows roughly like p^{3/4}" is labelled evidence. Fine.
- Doubling: "never admits a valid g" uses solver UNSAT without proofs. Add "(solver results)".

---

## 5. Things I could not check

- Lean compilation: no toolchain. The certificates themselves were re-checked (§2.2).
- DRAT/LRAT proof re-checking: proofs were deleted after checking, and that is the PUSH/CERT and N44A
  tasks' remit. I relied on the logged verdict lines.
- BEGS page numbers and the Erdős-forum dates (DNS blocked).
- The extremal counts for n = 8..11 by my own code. They are cross-checked by 4–5 independent
  checkers in M12/V12. N7_PLACEHOLDER
