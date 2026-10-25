## 4. Method

### Encoder (`src/cycenc.c`, C, emits DIMACS)

- Vertices Z_n, orbits d = 1..H with H = ⌈n/2⌉ − 1. Variables:
  - x[d][g] (orbit d present with offset g ∈ Z_n), var id (d−1)·n + g + 1;
  - p[d] ⇔ OR_g x[d][g]; at most one g per d (sequential counter, n−1 auxiliaries per d).
- **Cycles.** Enumerate all (2H)³ step triples 0 → v1 → v2 → v3, with a step ±d, and close
  with v3 → 0 when −v3 ≡ ±d′ for some d′ ∈ 1..H; keep only walks on 4 distinct vertices.
  - A step v → v+d uses edge {v, v+d}, colour v + g(d): offset o = v.
  - A step v → v−d uses edge {v−d, v}, colour v − d + g(d): offset o = v − d.
  - So edge colours are o + g(d). Two edges (d_a, o_a), (d_b, o_b) with d_a ≠ d_b collide iff
    g(d_a) − g(d_b) ≡ o_b − o_a. Two distinct edges of one orbit have distinct offsets, so they
    never collide (the encoder asserts that no same-orbit pair has equal offsets).
  - Rotation i ↦ i + t adds t to every offset and maps the family to itself, so the 4-cycles
    through 0 cover all 4-cycles up to rotation.
- **Keys.** Each pair of edges in different orbits of a cycle gives a key
  (d_a < d_b, δ = o_b − o_a, others = the remaining orbits of the cycle minus {d_a, d_b}),
  with duplicates removed after sorting.
- **Auxiliaries.** y[d_a][d_b][δ] ⇐ x[d_a][g] ∧ x[d_b][g − δ], one 3-clause per g, created only
  for δ values that occur. Each key is then a single clause ¬y ∨ ¬p[o] (o ∈ others).
  - Only the implication is needed. In a valid assignment, set y true exactly when the
    coincidence happens. In any model, a coincidence forces y, and then the key forbids all
    the other orbits being present (d_a and d_b are present because x implies p).
- **Cardinality.** Σ p_d ≥ k is encoded as "at most H − k of ¬p_d" with Sinz's sequential
  counter.
- **Size.** n = 94, k = 23: 108k variables, 9.5M clauses, 369k keys, written in about 1 s.
  The y-clauses dominate (Σ over (d_a, d_b, δ) of n).

### Symmetry breaking and its soundness

Let S be the set of valid (D, g) with |D| ≥ k. Two group actions preserve S:

1. **Colour translation.** g ↦ g + t (all d). Every colour shifts by t, a bijection of Z_n, so
   rainbow 4-cycles stay rainbow, and D (hence p) is unchanged.
2. **Multipliers.** For a unit u ∈ Z_n^×, the vertex map i ↦ ui is a graph automorphism of Z_n
   onto itself, and c ↦ uc is a bijection of colours. Edge {i, i+d} with colour i + g(d) goes
   to {ui, ui + ud} with colour ui + u·g(d). Let e = rep(ud) ∈ 1..H with ud ≡ σe.
   - If σ = +1: with j = ui this is edge {j, j+e} with colour j + u·g(d), so g′(e) = u·g(d).
   - If σ = −1: with j = ui − e this is edge {j, j+e} with colour j + e + u·g(d), so
     g′(e) = e + u·g(d).
   - rep(ud) ≠ n/2 for even n: ud ≡ n/2 would give d ≡ u⁻¹·n/2 ≡ n/2 (u⁻¹ is odd), but
     d ≤ H < n/2.
   - The image is the explicit graph relabelled with recoloured edges. 4-cycles map to
     4-cycles and distinct colours stay distinct, so the image is valid, lies in the family,
     and has |D′| = |D|. Its presence vector is p′_e = p_{rep(u⁻¹e)}.
   - u and −u induce the same permutation π_u of orbits, so the encoder uses u ∈ 2..H with
     gcd(u, n) = 1 (π_1 = id).

**Constraints added (default "full").**
- (a) Lex-leader: p ≥_lex p∘π_u for every unit u, over positions 1..H with p_1 most
  significant. The standard chain encoding uses prefix-equality auxiliaries a_i:
  a_{i−1} → (p_i ∨ ¬q_i), and a_{i−1} ∧ (p_i ↔ q_i) → a_i, where q_i = p_{π(i)}; fixed
  points of π are skipped. The a_i are only forced true when the prefix really is equal.
- (b) Translation fix: g(min present orbit) = 0, i.e. for each d,
  p_d ∧ ¬p_1 ∧ … ∧ ¬p_{d−1} → x[d][0].

**Soundness.** Take any (D, g) ∈ S.
- Among its images under all units (a group action on S), pick one whose p is lex-maximal.
  Every unit u gives an image with presence p∘π_u, and the set of images is closed under the
  group, so this representative satisfies (a) for every u.
- Translate its g so that g(min D) = 0. This does not change p, so (a) still holds, and (b)
  now holds.
- So S ≠ ∅ implies the constrained formula is satisfiable. The converse is trivial, since we
  only added constraints. Hence SAT/UNSAT at each k is unchanged.
- Empirically, k_max agrees with and without breaking for n = 13..30 (validation table), and
  solution counts shrink (see the counts below).

### Solving (`src/run.py`, `src/drive.py`)

- **Portfolio.** Four processes per instance run in parallel:
  - kissat 4.x `--unsat --seed=2`, writing a binary DRAT proof;
  - kissat `--seed=1`;
  - CaDiCaL 2.x `--seed=7`;
  - kissat `--sat --seed=3`.
  Solvers were built from the GitHub sources (arminbiere/kissat, arminbiere/cadical).
  The first definite answer wins.
- **UNSAT proofs.** On UNSAT the driver waits for the proof-writing member and runs
  drat-trim (marijnheule/drat-trim, built from source) on the proof when it is under 5 GB.
- **SAT models.** These are decoded to (D, g) and re-checked by `src/check4.py`, an
  independent, deliberately simple explicit checker. It builds all n·|D| edges and
  enumerates every walk a-b-c-d-a on 4 distinct vertices.
- **Per-n first pass (`drive.py`).** SAT at k_lo + 1, k_lo + 2, … until UNSAT or UNKNOWN,
  with a 25 min wall cap. For n ≡ 0 (mod 4), 40% of the cap is held back for an explicit
  attempt at k = n/4.
