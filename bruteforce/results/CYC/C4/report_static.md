## 4. Method

### Encoder (`src/cycenc.c`)

Re-derived from the task statement; nothing was copied from CONSTR's `cycsat.py` except the conventions.

- **Variables.** `x[d][g]` (orbit d present with offset g), var `1+(d-1)n+g`, for d = 1..H, g ∈ Z_n;
  `p[d] = Hn + d`; then auxiliaries.
- **Channelling.** `p_d → OR_g x[d][g]`, `x[d][g] → p_d`, pairwise at-most-one over g.
- **4-cycles through 0.** All closed walks 0 → v1 → v2 → v3 → 0 with 3 free steps (d, ±1) and the
  closing step forced (it is skipped when the closing difference is the excluded diameter n/2). The
  4 vertices must be distinct. A step v → v+d uses edge (d, offset v), colour v + g(d); a step v → v−d
  uses edge (d, offset v−d), colour v−d+g(d). For each pair of edges in different orbits d_a < d_b
  with offsets o_a, o_b, the colours coincide iff g(d_a) − g(d_b) ≡ o_b − o_a =: δ. The key
  (d_a, d_b, δ, others) is stored, where "others" is the set of orbits of the cycle other than d_a, d_b
  (at most 2). Same-orbit pairs never collide: two edges of a 4-cycle in the same orbit with equal
  offset would be the same edge, and the encoder asserts this never happens.
  Every 4-cycle is a rotation of one through 0, and rotation by t maps the colour coincidence
  condition to itself (both colours shift by t), so cycles through 0 suffice.
- **Auxiliaries.** For every (d_a, d_b, δ) that occurs: `y[d_a][d_b][δ] ← x[d_a][g] ∧ x[d_b][g−δ]` for all g
  (n ternary clauses). Only this direction is needed: y is only used negatively. Each key then becomes
  one clause `¬y ∨ ¬p_o1 ∨ ¬p_o2`. Every (d_a, d_b, δ) turns out to occur, so there are C(H,2)·n
  y-variables. For n = 95: about 0.4M distinct keys, 103k y-variables and 10.4M clauses, a 6 s encode.
- **Cardinality.** Σ p_d ≥ k uses a sequential counter s[i][j] ("at least j of p_1..p_i"), with clauses
  `s[i][j] → s[i−1][j] ∨ p_i` and `s[i][j] → s[i−1][j] ∨ s[i−1][j−1]`, plus the unit s[H][k].
- **Symmetry levels.** `sym=0` adds nothing. `sym=1` adds the colour-translation fix. `sym=2` adds the
  translation fix and the lex-leader over all units.

### Symmetry-breaking soundness

*Colour translation.* Replacing g by g + t (all orbits) recolours every edge c ↦ c + t, a bijection
of Z_n. So rainbow 4-cycles stay rainbow. Given any solution, take d0 = min D and t = −g(d0): the new
solution has g(d0) = 0. Clause: `¬p_d ∨ p_1 ∨ … ∨ p_{d−1} ∨ x[d][0]`.

*Multipliers.* Let u ∈ Z_n^×, with vertex map φ(i) = ui and colour map ψ(c) = uc. Both are bijections,
so (φ, ψ) maps a valid coloured graph to a valid coloured graph (4-cycles map to 4-cycles, and distinct
colours stay distinct). The image of edge {i, i+d} with colour i + g(d) is {ui, ui + ud} with colour
ui + u·g(d). Write ud ≡ σe with e = rep(ud) ∈ 1..H. The diameter is excluded and u is odd for even n,
so ud ≢ n/2 and d ↦ e is a permutation of 1..H.
- σ = +1: the edge is {j, j+e} with j = ui and colour j + u·g(d), so g′(e) = u·g(d).
- σ = −1: the edge is {j, j+e} with j = ui − e and colour ui + u·g(d) = j + e + u·g(d),
  so g′(e) = e + u·g(d).

So (D, g) ↦ (D′, g′) is again a member of the family, with p′_e = p_{rep(u⁻¹e)}.
`src/test_action.py` checks this formula against the explicit image graph for every unit on every
SAT model of the validation run (466 checks, all pass).

*Lex-leader.* The maps p ↦ p∘u form a group action on presence vectors. In the orbit of p under this
action pick the lex-maximal p* (realised by some solution, by the above), then translate colours so
that g(min D) = 0. Translation does not change p. The result satisfies p* ≥_lex p*∘u for all units u
and the translation fix, so adding both is sound. The encoding uses prefix-equality auxiliaries
a_i: `a_{i−1} ∧ q_i → p_i`, `a_{i−1} ∧ p_i ∧ q_i → a_i`, `a_{i−1} ∧ ¬p_i ∧ ¬q_i → a_i`, skipping
fixed points. Setting a_i true spuriously only adds constraints, so every lex-leader extends to a
model. Units u and −u induce the same permutation of orbits, so only u = 2..n/2 are used, and identity
permutations are skipped.

*Empirical check.* For all n = 13..30, k_max agrees between sym 2 and sym 0 (sym 1 for the UNSAT
side at n ≥ 25; sym 0 there was slower and I stopped it). Projected model counts at k = k_max:

| n, k | brute force (g(min D)=0) | sym 0 | sym 1 | sym 2 |
|---|---|---|---|---|
| 13, 3 | 340 | 4420 = 13·340 | 340 | 82 |
| 14, 3 | 614 | 8596 = 14·614 | 614 | 206 |
| 15, 4 | 92 | 1380 = 15·92 | 92 | 30 |
| 16, 4 | 464 | 7424 = 16·464 | 464 | 116 |

The brute force (`src/brute_small.py`) enumerates all (D, g) with g(min D) = 0 and tests each with the
simple checker. It also confirms k = 4 is impossible for n = 13 and n = 14.

### Checker (`src/check.py`)

It builds the explicit edge set {i, i+d} with colours (i+g) mod n and asserts there are no duplicate
edges and that colours lie in 0..n−1. For every vertex pair {a, c} and every pair {b, d} of common
neighbours, it checks that the 4 colours of a-b-c-d are distinct. This covers every 4-cycle, each one
twice. It shares no code with the encoder. Every SAT model is decoded and re-checked inside
`src/run.py`, and `src/collect.py` re-checks again before writing `solutions.json` and `certs.json`.

### Per-n driver (`src/drive.py`)

Four kissat 4.0.4 jobs run in parallel:
- A: default config, sym 2, at k = best+1;
- B: `--sat` with seed 1, sym 1, at best+1;
- C: `--unsat`, sym 2, at best+1;
- D: `--sat` with seed 2, sym 1, at n/4 when n ≡ 0 (mod 4) and n/4 > best+1, otherwise at best+2.

A verified SAT at k raises best and restarts the lower jobs, and an UNSAT at best+1 ends the search.
Up to 06:12 UTC (n = 53 and an aborted n = 56 start) B and D also used sym 2. Other agents reported
that the lex-leader slows SAT-finding at large n, so I switched B and D to sym 1.

### UNSAT proofs (`src/prove.sh`)

CaDiCaL (master, built from GitHub) writes a binary DRAT proof of the sym-2 CNF, and drat-trim
(GitHub master) checks it. Note that the proof certifies the symmetry-broken CNF, whose soundness is
argued above.

Tools: kissat 4.0.4, CaDiCaL and drat-trim, all built from source (`git clone` from github.com/arminbiere
and github.com/marijnheule). pysat was used only for model counting (`src/count.py`).
