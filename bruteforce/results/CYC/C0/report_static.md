## 4. Method

### 4.1 Encoder (`src/cycenc.c`)

Vertices Z_n, H = ⌈n/2⌉ − 1, orbits d ∈ 1..H. Orbit d present means edges {i, i+d} with colour
i + g(d) mod n.

**Derivation, re-done.** A 4-cycle through 0 is a closed walk 0 → v1 → v2 → v3 → 0 on four
distinct vertices, where each step is ±d for an orbit d.
- A step v → v + d uses the edge {v, v+d}: orbit d, offset v, colour v + g(d).
- A step v → v − d uses the edge {v−d, v}: orbit d, offset v − d, colour v − d + g(d).

The closing step is forced: it is −v3, which must be a legal step (not 0, and not n/2 for even
n, since that orbit is excluded). Every pair of distinct vertices lies in exactly one orbit,
so each walk gives one subgraph. Two edges (d_a, o_a) and (d_b, o_b) with d_a ≠ d_b collide iff
g(d_a) − g(d_b) ≡ o_b − o_a. Two edges in the same orbit with different offsets have different
colours. The encoder asserts that a 4-cycle never has two equal (orbit, offset) pairs.

Rotation by t maps (d, o) to (d, o + t), which leaves every collision condition unchanged.
Every 4-cycle is a rotation of one through 0, so cycles through 0 are enough.

**Keys.** Each colliding pair gives a key (d_a < d_b, δ = o_b − o_a mod n, other orbits of the
cycle minus {d_a, d_b}). There are at most 2 other orbits. Keys are packed into 64-bit
integers, sorted and de-duplicated. For n = 90 that leaves 322,363 keys.

**Variables.**
- x[d][g] = (d−1)·n + g + 1, for "orbit d is present with offset g".
- p[d] = H·n + d, for "orbit d is present".

**Clauses.**
- p[d] ↔ ∨_g x[d][g].
- At most one g per orbit: a Sinz sequential counter (n − 1 auxiliaries per orbit).
- For each (d_a, d_b, δ) that occurs: one auxiliary y with y ← x[d_a][g] ∧ x[d_b][g−δ] for all g.
  That is n ternary clauses. Only this implication direction is needed: y is only ever
  required to be false.
- Each key then becomes the single clause ¬y ∨ ¬p[o1] ∨ ¬p[o2].
- Σ p[d] ≥ k: a Sinz sequential counter on "at most H − k of the ¬p[d]".
- Size for n = 90, k = 22: 94k variables and 8.0M clauses, versus 29M clauses for the direct
  CONSTR-style encoding (`noaux=1`).

`cycenc n k lex trans noaux dump`. `dump=1` prints the keys. They feed the annealer, the
fixed-g experiment and LNS.

### 4.2 Symmetry breaking and its soundness

**Colour translation (trans=1).** Replacing g by g + t adds t to every colour, a bijection of
Z_n, so a rainbow 4-cycle stays rainbow. The presence vector p does not change. So whenever a
solution exists, one exists with g(min D) = 0. Clause, for each d:
¬p[d] ∨ ∨_{e<d} p[e] ∨ x[d][0].

**Multipliers (lex=1).** Take u ∈ Z_n^×. Map vertex i ↦ ui, a graph isomorphism of the
circulant onto its image, and colour c ↦ uc, a bijection of colours.
- The edge {i, i+d} with colour i + g(d) goes to {ui, ui+ud} with colour ui + u·g(d).
- Let ud ≡ σe with e = rep(ud) ∈ 1..H. (Orbit n/2 never arises, because u is a unit and
  d ≠ n/2.)
- If σ = +1: the image is {j, j+e} with j = ui and colour j + u·g(d), so g′(e) = u·g(d).
- If σ = −1: the image is {j−e, j} = {j′, j′+e} with j′ = j − e and colour
  j′ + e + u·g(d), so g′(e) = e + u·g(d).

Isomorphisms map 4-cycles to 4-cycles, and a colour bijection keeps 4 distinct colours
distinct. So (D′, g′) is valid, with p′_e = p_{rep(u⁻¹e)}. Units u and −u induce the same
permutation of orbits, so one representative per {u, −u} is used, u ≠ ±1.

**Lex-leader.** The constraint is p ≥_lex p∘π_u, with p_1 the most significant position and
π_u(e) = rep(u⁻¹e), for every such u. It is encoded with prefix-equality auxiliaries:
- eq_{i−1} → p_i ≥ q_i;
- eq_i ← eq_{i−1} ∧ (p_i ↔ q_i);
- fixed points of π_u are skipped.

**Why it is sound.** Take any solution. Among its images under the full multiplier group,
pick one whose p is lex-maximal. Then p ≥_lex p∘π_u for every u, because p∘π_u is the presence
vector of another image. Next translate its colours to get g(min D) = 0. Translation does not
change p, so the lex constraints still hold. So every satisfiable (n, k) stays satisfiable.

**Empirical checks.**
- *Formula check.* Every SAT model in the validation and production logs was mapped by every
  unit u and by translations t = 1, 2, 3, then re-checked explicitly with `check.py`. All
  938 transformed models were valid (`src/symtest.py`). As a control, the wrong formula
  (dropping the "+e" for σ = −1) gave invalid colourings in 658 of 679 cases.
- *Counts.* Solutions at k_max were enumerated with blocking clauses on x (`src/count.py`)
  and compared with an independent brute force over all (D, g) with g(min D) = 0, which uses
  only `check.py` (`src/brute.py`).

| n | k | brute force (trans) | SAT count, trans only | SAT count, lex + trans |
|---|---|---|---|---|
| 13 | 3 | 340 | 340 | 82 |
| 14 | 3 | 614 | 614 | 206 |
| 15 | 4 | 92 | 92 | 30 |
| 16 | 4 | 464 | 464 | 116 |
| 17 | 4 | 3056 | 3056 | 526 |

The encoding with translation only matches brute force exactly. Lex-leader shrinks the counts
by 3–6× and never to 0.

### 4.3 Checker (`src/check.py`)

The checker is deliberately simple. It builds the explicit edge → colour map from (D, g) and
rejects duplicate edges and colours outside 0..n−1. It then enumerates every 4-cycle a-b-c-d:
for each pair {a, c} it takes every pair {b, d} of common neighbours, and requires 4 distinct
colours. It shares no code with the encoder. Every SAT model from every solver and annealer
run is re-checked with it before it is logged as SAT. `make_table.py` re-checks every best
solution again and asserts |E| = n·k.

### 4.4 Solvers and search

- kissat 4.0.4 and CaDiCaL 3.0.1 were built from the GitHub sources (arminbiere/kissat and
  arminbiere/cadical), along with drat-trim (marijnheule/drat-trim). PySAT (`python-sat`) is
  used for counting and LNS.
- *UNSAT side:* kissat with lex=1, trans=1 and default options. DRAT is written in text format
  and checked by drat-trim (backward mode).
- *SAT side:* kissat `--sat` with lex=0, trans=1 was far better than lex=1 for finding large
  solutions. For example, n=72 k=15 took 25 s with `--sat`/lex=0, while n=72 k=16 with lex=1
  timed out at 600 s. CaDiCaL `--sat` was also used, plus a dedicated annealer
  (`src/cycls.c`) on the same keys.
- *Negative experiments:*
  - Fixed quadratic offsets g(d) = a·d² + b·d (`src/fixg.py`) with an exact RC2 maximum
    independent set over D give at most 8 orbits for n = 40 and 7 for n = 36, below n/4.
  - Annealing plus SAT completion under assumptions (LNS, `src/lns.py`) did not beat plain
    kissat.
