## 4. Encoder design (`src/cycenc.c`)

**Family.** Vertices Z_n, orbits d ∈ {1..H} with H = ⌈n/2⌉ − 1 (the diameter n/2 is excluded).
Orbit d ∈ D gives the n edges {i, i+d}, and {i, i+d} has colour i + g(d) mod n. Since d ≠ n − d for
d ≤ H, each edge has exactly one representation {i, i+d}, so the colouring is well defined.

**Re-derivation of the constraints.** Every 4-cycle is a rotation of one through 0, and rotation
i ↦ i + t sends colours c ↦ c + t, so a cycle is rainbow iff its rotation through 0 is.
A 4-cycle through 0 is a closed walk 0 → v1 → v2 → v3 → 0 on 4 distinct vertices, each step ±d with
d ∈ 1..H. The encoder enumerates all (2H)³ choices of the first three steps and closes the walk
with the unique orbit step v3 → 0 (if −v3 ≡ ±d for some d ≤ H; otherwise v3 = n/2 and there is no
edge).
- Step v → v + d uses edge {v, v+d}: colour v + g(d), offset o = v.
- Step v → v − d uses edge {v−d, v}: colour (v−d) + g(d), offset o = v − d.
- Two distinct edges of the same orbit have distinct offsets (the offset determines the edge),
  so they never collide.
- Edges a, b with orbits d_a < d_b collide iff g(d_a) − g(d_b) ≡ o_b − o_a =: δ.

Each pair of edges on each cycle yields a key (d_a, d_b, δ, O), where O is the set of the cycle's
other orbits (|O| ≤ 2). The cycle exists in the graph iff {d_a, d_b} ∪ O ⊆ D, so the constraint
is "if all of {d_a, d_b} ∪ O are present then g(d_a) − g(d_b) ≢ δ". Keys are packed into 64-bit
integers, sorted and de-duplicated.

**CNF.**
- x[d][g] (orbit d with offset g) and p[d] (orbit d present), with p[d] ↔ ∨_g x[d][g] and an
  at-most-one ladder over x[d][·].
- For each (d_a, d_b, δ) that occurs: if some key has O = ∅, emit the n binary clauses
  ¬x[d_a][g] ∨ ¬x[d_b][g−δ]. Otherwise introduce y[d_a][d_b][δ] with the n clauses
  ¬x[d_a][g] ∨ ¬x[d_b][g−δ] ∨ y (only y ⇐ x ∧ x is needed, since y occurs only negatively), and one
  clause ¬y ∨ ⋁_{o∈O} ¬p[o] per key. Keys whose O is a superset of another key's O for the same
  (d_a, d_b, δ) are dropped because they are subsumed.
- Σ p[d] ≥ k by a sequential counter (s[i][j] ⇒ "at least j of p_1..p_i").
- Size at n = 97: 857,280 directed cycles through 0, 426,192 keys, 104,856 y variables,
  about 10.8 M clauses (2 s to encode).

Decoding: D = {d : p[d]}, g(d) = the unique g with x[d][g]. Every SAT model is rebuilt as an
explicit graph and checked by `src/check4.py`, which shares no code with the encoder.

## Symmetry breaking and soundness

**(S1) Colour translation.** If (D, g) is valid then so is (D, g + t): every colour shifts by t,
which is a bijection of Z_n and preserves rainbow-ness. So we may require g(min D) = 0. Clause:
¬p[d] ∨ ⋁_{e<d} p[e] ∨ x[d][0] for each d.

**(S2) Multipliers.** Let u ∈ Z_n^×, φ(i) = u·i on vertices and ψ(c) = u·c on colours. Both are
bijections of Z_n. If c is a valid colouring of G then c′(φ(e)) = ψ(c(e)) is a valid colouring of
φ(G): 4-cycles map to 4-cycles, and distinct colours stay distinct. Image of an edge
{i, i+d} with colour i + g(d) is {ui, ui + ud} with colour ui + u·g(d). Write ud ≡ σe with
e = rep(ud) ∈ 1..H and σ = ±1 (ud ≢ n/2 because d ≢ n/2 and u is a unit).
- σ = +1: the edge is {j, j+e} with j = ui and colour j + u·g(d), so g′(e) = u·g(d).
- σ = −1: the edge is {ui − e, ui} = {j, j+e} with j = ui − e and colour ui + u·g(d) = j + e + u·g(d),
  so g′(e) = e + u·g(d).
So (D′, g′) with D′ = rep(u·D) is again in the family, and p′_e = p_{rep(u⁻¹e)}.
(Checked: this is exactly the computation above.) u and −u induce the same permutation of
orbits, so the encoder uses one representative of each class in Z_n^×/{±1} other than ±1.

**Lex-leader.** For every such u the encoder adds p ≥_lex p∘π_u, where (p∘π_u)_e = p_{rep(u⁻¹e)},
the lex order is on (p_1, …, p_H) with p_1 most significant, and fixed points of π_u are skipped.
Encoding: chain variables a_i ("prefix equal through i"), clauses a_{i−1} → (p_i ∨ ¬q_i),
a_{i−1} ∧ ¬p_i → a_i, a_{i−1} ∧ q_i → a_i.

**Soundness of S1 + S2 together.** Take any valid (D, g). The set {p∘π_u} is the orbit of p under a
group, so it has a lex-maximum p∘π_{u*}. Apply u* to get (D*, g*), which is valid with presence
vector p* = p∘π_{u*}. For every unit v, p*∘π_v = p∘π_{u*}∘π_v lies in the same orbit, so
p* ≥_lex p*∘π_v and all lex constraints hold. Then translate colours so that g*(min D*) = 0. This
leaves p* and all lex constraints unchanged, and S1 now holds. The size |D*| = |D|, so the answer
to "is there a valid D with |D| ≥ k" is unchanged.

**Empirical check.** k_max agrees with and without breaking (table below). Solution counts
(projected on x, enumerated by blocking clauses, `src/count.py`, file `runs/val/counts.txt`):

| n | k | no breaking | S1 | S1 + S2 |
|---|---|---|---|---|
| 13 | 3 | 4420 | 340 | 82 |
| 14 | 3 | 8596 | 614 | 206 |
| 15 | 4 | 1380 | 92 | 30 |
| 16 | 4 | 7424 | 464 | 116 |
| 17 | 4 | 51952 | 3056 | 526 |
| 18 | 5 | 108 | 6 | 2 |

The S1 counts are exactly the no-breaking counts divided by n, as expected.
