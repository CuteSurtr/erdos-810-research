## 4. Method

### 4.1 Encoder (`src/cycenc.c`, C, emits DIMACS)

Variables: `x[d][g]` (orbit d present with offset g), d = 1..H, g ∈ Z_n; `p[d]` (orbit d present).
Clauses `p[d] → ∨_g x[d][g]` and `x[d][g] → p[d]`. No at-most-one on x is needed (optional flag):
every clause containing an x literal other than the `p → ∨x` clause has x negatively, so if a model
has several true `x[d][·]`, choosing any one of them still satisfies everything. The decoder takes
the smallest true g.

Derivation of the constraints (re-derived, not copied). A 4-cycle through vertex 0 is a closed walk
0 → v1 → v2 → v3 → 0 with 4 distinct vertices, each step ±d with d ∈ 1..H. A step v → v+d uses edge
{v, v+d}, which has colour v + g(d), so its offset is o = v; a step v → v−d uses edge {v−d, v},
colour (v−d) + g(d), offset o = v−d. The closing step is forced: diff = −v3 mod n must be ±d with
d ≤ H (diff = n/2 is the excluded diameter; then the walk is skipped). Two edges of the same orbit
have colours o_a + g(d), o_b + g(d), equal iff o_a = o_b, i.e. the same edge, impossible in a
4-cycle (the encoder asserts this never happens). Two edges with orbits d_a < d_b collide iff
g(d_a) − g(d_b) ≡ o_b − o_a =: δ. Every 4-cycle of the circulant is a rotation (i ↦ i + t) of one
through 0, and rotation maps edge {i, i+d} of colour i+g(d) to {i+t, i+t+d} with colour i+t+g(d):
the colour is shifted by t on every edge, so rainbowness is rotation invariant. Hence cycles
through 0 suffice. The encoder enumerates all (2H)^3 three-step walks.

For each forbidden key (d_a, d_b, δ, O) where O is the set of the cycle's other orbits (|O| ≤ 2):
auxiliary `y[d_a][d_b][δ]` with only the needed direction `x[d_a][g] ∧ x[d_b][g−δ] → y`
(n ternary clauses per y), and one key clause `¬y ∨ ∨_{o∈O} ¬p[o]`. Keys whose y also has an
empty-O key are subsumed and dropped.

Cardinality Σ p[d] ≥ k: sequential counter, one direction (s(i,j) → s(i−1,j) ∨ p_i,
s(i,j) → s(i−1,j) ∨ s(i−1,j−1), unit s(H,k)).

Size at n = 100, k = 25: 124,595 variables, 11,995,375 clauses (117,600 y-variables,
225,793 key clauses), 236 MB of DIMACS, written in 2.4 s.

### 4.2 Symmetry breaking and soundness

*Colour translation.* Replacing g by g + t (all orbits) adds t to every colour, a bijection of
Z_n, so rainbow 4-cycles stay rainbow. Encoded as: for each d,
`p[d] ∧ ¬p[1] ∧ … ∧ ¬p[d−1] → x[d][0]` (the smallest present orbit has g = 0).

*Multipliers.* Let u ∈ Z_n^×. Map vertices i ↦ ui and colours c ↦ uc (both bijections of Z_n).
Edge {i, i+d} with colour i + g(d) goes to {ui, ui+ud} with colour ui + u·g(d). Let e = rep(ud) ∈
1..H with ud ≡ σe.
- σ = +1: the edge is {j, j+e} with j = ui, colour j + u·g(d), so g′(e) = u·g(d).
- σ = −1: the edge is {ui−e, ui} = {j, j+e} with j = ui − e, colour ui + u·g(d) = j + e + u·g(d),
  so g′(e) = e + u·g(d).
ud ≢ ±(n/2) because d ≠ n/2 and u is a unit, so e ∈ 1..H. The vertex map is a graph isomorphism
from G(D) onto G(uD) and the colour map is a bijection, so (D, g) valid ⇔ (uD, g′) valid. The
presence vector transforms as p′_e = p_{rep(u⁻¹e)}. u and −u give the same p′, so only u ≤ n/2 are
used; units acting trivially on p are skipped.

*Lex-leader.* With p read as the word p_1 p_2 … p_H, we add p ≥_lex p∘u for every unit u
(standard chain encoding with "prefix-equal" auxiliaries, 3 clauses per non-fixed position).
Soundness: given any valid (D, g), the set {uD : u ∈ Z_n^×} is the orbit of D under the group, so
it has a lex-maximal element u*D; (u*D, g′) is valid; then translate colours so g′(min u*D) = 0,
which does not change p. The resulting solution satisfies p ≥_lex p∘u for all u (p is the
maximum of its orbit and p∘u lies in the same orbit) and the translation fix. So the constraints
remove no satisfiable k.

*Empirical check* (section 3): with sym = 0 (none), 1 (translation only), 2 (translation +
lex-leader), SAT/UNSAT answers agree for every n = 13..30. An independent brute force
(`src/brute.c`, builds the explicit graph orbit by orbit and checks every 4-cycle through each new
edge directly, no walk encoding) counts the solutions: e.g. n = 26, k = 6: 4,925,544 (D, g) in
total, 189,444 with g(min D) = 0 (exactly 1/n, as translation acts freely), 33,434 also
lex-leader. UNSAT times shrink accordingly (n = 30, k = 8: 947 s → 17 s → 3.7 s).

### 4.3 Model checking

Every SAT model is decoded to (D, g) and re-checked by `src/check.py`, a deliberately simple
checker: build the explicit coloured edge set, then for every vertex pair a < c and every pair of
common neighbours b < d, check that the 4 colours of a–b–c–d–a are distinct; colours are in
0..n−1 and edges are distinct by construction (asserted). The checker was tested to reject an
invalid colouring.
