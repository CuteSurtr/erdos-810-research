## Encoder (`src/cycenc.c`)

Usage `cycenc n k sym [extra-clauses]`, DIMACS on stdout. H = ⌈n/2⌉ − 1.

- x(d,g), d ∈ 1..H, g ∈ Z_n: orbit d present with offset g. p(d) ↔ ∨_g x(d,g); at most one g per d
  (sequential counter, n − 1 aux per orbit).
- 4-cycles: all closed walks 0 → v1 → v2 → v3 → 0 with v1, v2, v3 distinct and nonzero and each step
  ±d, d ∈ 1..H (O(n³) walks). Step v → v+d uses edge {v, v+d}, offset v. Step v → v−d uses edge {v−d, v},
  offset v − d. So the colour is offset + g(d). For each pair of cycle edges in different orbits a < b
  with offsets o_a, o_b, the colours coincide iff g(a) − g(b) ≡ o_b − o_a =: δ. Key = (a, b, δ, set of the
  other orbits on the cycle, at most 2). Two edges in the same orbit with the same offset would be the same
  edge, so they cannot both lie on a 4-cycle. The encoder asserts this never happens.
- Keys are sorted and deduplicated. For each distinct (a, b, δ), one auxiliary y(a,b,δ) is defined by
  the n clauses ¬x(a,g) ∨ ¬x(b,g−δ) ∨ y (only the implication y ⇐ x∧x is needed). Each key then gives
  the single clause ¬y ∨ ¬p(o1) ∨ ¬p(o2). Presence of a and b is implied by y.
- Rotation i ↦ i+1 maps orbit edges to orbit edges and shifts every colour by 1, so every 4-cycle is
  a rotation of one through vertex 0 with the same colour coincidences. Cycles through 0 suffice.
- Σ p(d) ≥ k: sequential counter r(i,j) ("at least j of p1..pi"), with r(i,j) → r(i−1,j) ∨ p_i,
  r(i,j) → r(i−1,j) ∨ r(i−1,j−1), r(i,j) false for j > i, and the unit r(H,k).
- Size at n = 93, k = 5: 4.45M raw keys, 374k distinct keys, 96k y variables, 106k vars, 9.35M clauses.

## Symmetry breaking and its soundness

sym = 0: none. sym = 1: colour translation only. sym = 2: translation plus lex-leader under Z_n^×.

**Colour translation.** If (D, g) is valid, so is (D, g + t), because every colour is shifted by t.
This is a bijection on colours, so distinct colours stay distinct. The encoder adds, for each d, the clause
p(d) ∧ ¬p(1) ∧ … ∧ ¬p(d−1) → x(d, 0). In words: the smallest present orbit has g = 0. Every solution can
be translated to satisfy this without changing p.

**Multipliers.** Let u ∈ Z_n^×. Map vertices i ↦ ui and colours c ↦ uc. Both maps are bijections of Z_n,
so a 4-cycle maps to a 4-cycle and a rainbow cycle stays rainbow. Edge {i, i+d} of colour i + g(d) maps to
{ui, ui+ud} of colour ui + u·g(d). Write ud ≡ σe with e = rep(ud) ∈ 1..H. (ud ≢ 0 and ud ≢ n/2 because
u is a unit and d ≠ n/2.)
- σ = +1: the image edge is {j, j+e} with j = ui, colour j + u·g(d). So g′(e) = u·g(d).
- σ = −1: the image edge is {ui−e, ui} = {j, j+e} with j = ui − e, colour ui + u·g(d) = j + e + u·g(d).
  So g′(e) = e + u·g(d).

Every image edge has the orbit form, so the image is again a family member, with D′ = rep(uD). Hence
p′_e = p_{rep(u⁻¹e)}. The map d ↦ rep(ud) is a permutation of 1..H, and u and −u give the same permutation.

**Lex-leader.** For every unit u ∈ 2..⌊n/2⌋ the encoder adds p ≥_lex p∘π_u, where
(p∘π_u)_e = p_{rep(u⁻¹e)} and positions are ordered 1..H. It uses the standard chain e_i with
e_{i−1} → (a_i ∨ ¬b_i) and e_i ⇐ e_{i−1} ∧ (¬a_i ∨ b_i), where e_i means "prefix equal". Fixed positions are skipped.

**Soundness.** Take any valid (D, g). Among its images under Z_n^×, pick u* whose presence vector is
lex-maximal. Because the action is a group action, that vector is ≥_lex all its images, so it satisfies
every lex clause. Then translate colours so the smallest present orbit has g = 0. Translation does not
change p, so the lex clauses stay satisfied. So if any valid configuration with |D| ≥ k exists, the
symmetry-broken formula is SAT. The converse is trivial because breaking only adds clauses. k_max is unchanged.

**Empirical check** (`src/count_p.py`, `src/orbits.py`, `symcheck.txt`). We enumerated all optimal D at
k_max by SAT with blocking clauses, without breaking (sym 0) and with it (sym 2). We then computed the
Z_n^× orbits of the sym-0 sets. In every case the sym-2 count equals the number of orbits exactly, and
every sym-2 set is the lex-max of its orbit:

| n | k | #D (no breaking) | #orbits | #D (sym 2) |
|---|---|---|---|---|
| 13 | 3 | 20 | 4 | 4 |
| 15 | 4 | 14 | 4 | 4 |
| 20 | 5 | 42 | 12 | 12 |
| 24 | 6 | 144 | 43 | 43 |
| 27 | 7 | 63 | 7 | 7 |
