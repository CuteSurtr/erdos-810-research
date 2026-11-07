## 4. Method

### Encoder (`src/cycenc.c`, C, writes DIMACS)

Vertices are Z_n, H = ⌈n/2⌉ − 1, and orbit d ∈ 1..H contributes the edges {i, i+d} coloured i + g(d).

Variables:

- x(d,g) for d ∈ 1..H and g ∈ Z_n means "orbit d is present with offset g". p(d) means "orbit d is present".
- p(d) → OR_g x(d,g) and x(d,g) → p(d). A Sinz sequential counter enforces at most one g per d.

**Re-derived 4-cycle constraint.** Every 4-cycle is a rotation of one through 0, because rotation by t maps the orbit structure to itself and shifts every colour by t. So it suffices to enumerate closed walks 0 → v1 → v2 → v3 → 0 with v1, v2, v3 distinct, nonzero vertices, where each step w − v ≡ ±d with d ∈ 1..H (the diameter n/2 is excluded).

- A step v → v + d uses edge {v, v+d}, which has colour v + g(d), so its offset is v.
- A step v → v − d uses edge {v−d, v}, which has colour v − d + g(d), so its offset is v − d.
- Two edges with orbits d_a ≠ d_b and offsets o_a, o_b get the same colour iff g(d_a) − g(d_b) ≡ o_b − o_a (mod n).
- Two distinct edges in the same orbit have distinct offsets, so they never collide.

For every walk and every pair of its edges in different orbits, the encoder forms the key (d_a < d_b, δ = o_b − o_a, O), where O is the set of the cycle's other orbits (|O| ≤ 2). The key forbids g(d_a) − g(d_b) ≡ δ whenever every orbit in O is present. Presence of d_a and d_b is implied by the x variables.

- Keys are deduplicated in a hash table.
- A key is dropped when the same (d_a, d_b, δ) already appears with a subset of O, since its clause is subsumed.

**Auxiliaries.** y(d_a,d_b,δ) ← x(d_a,g) ∧ x(d_b,g−δ), one ternary clause per g, and only the implication is encoded. Each key then becomes a single clause ¬y ∨ ∨_{o∈O} ¬p(o).

- This is sound: if a model has g(d_a) − g(d_b) = δ, then y is forced and the key clause applies.
- Extra true y values only add constraints, so they cannot create invalid models.

**Cardinality.** Σ p(d) ≥ k is encoded as "at most H − k orbits absent" with a Sinz sequential counter.

**Sizes.** n = 91 gives 101k variables and 8.4M clauses (160 MB), encoded in 7 s. n = 44 gives about 0.9M clauses.

### Symmetry breaking and its soundness

1. **Colour translation (bit 1).** If (D, g) is valid then so is (D, g + t): every colour shifts by t, a bijection of Z_n, so rainbow cycles stay rainbow. The clause ¬p(d) ∨ ∨_{e<d} p(e) ∨ x(d,0) forces g = 0 on the smallest present orbit. Every solution class contains exactly one such representative.
2. **Multipliers (bit 2).** For u ∈ Z_n^×, take φ(i) = ui on vertices and c ↦ uc on colours. Both are bijections of Z_n.
   - Edge {i, i+d} with colour i + g(d) maps to edge {ui, ui + ud} with colour ui + u·g(d).
   - If ud ≡ +e with e ∈ 1..H, this is {j, j+e} with j = ui and colour j + u·g(d), so g′(e) = u·g(d).
   - If ud ≡ −e, this is {j′, j′+e} with j′ = ui − e and colour ui + u·g(d) = j′ + e + u·g(d), so g′(e) = e + u·g(d).
   - The map is a graph isomorphism combined with a colour bijection, so 4-cycles map to 4-cycles and rainbowness is preserved. This gives a group action of Z_n^× on solutions, with p′_e = p_{rep(u⁻¹e)}. The units ±1 act trivially on p.
   - The encoder adds p ≥_lex p∘u for every unit u modulo ±1, comparing positions e = 1..H in order and skipping fixed points.
   - The lex chain uses one auxiliary a_e per position. a_{e−1} → (p_e ≥ q_e), and a_e is forced true when a_{e−1} holds and p_e = q_e. A spuriously true a_e only adds constraints, and the exact assignment satisfies everything.
3. **Combined soundness.** Take any solution (p, g). Its orbit under Z_n^× contains a p* that is lex-maximal, and that p* satisfies p* ≥_lex p*∘v for every v because the action is a group action. Then translate colours so that g(min D) = 0. Translation does not change p, so the result satisfies both families of constraints. Hence SAT with breaking ⇔ SAT without breaking.

**Empirical check.** With and without breaking, k_max agrees on n = 13..28 (n = 29 and 30 without breaking: see the validation notes). Solution counts with |D| ≥ k_max, enumerated with blocking clauses (`logs/symcount.txt`):

- The count without breaking is exactly n × the count with translation only. Examples: 13: 4420 = 13·340, and 14: 8596 = 14·614.
- Adding lex-leader shrinks it further, for example 340 → 82 (n = 13) and 3056 → 526 (n = 17).
- Independently, a brute force over every (D, g) with g(min D) = 0 for n = 14 (`src/brute14.py`) finds 614 valid 3-orbit colourings. This matches the SAT count with translation only exactly. It finds no valid 4-orbit colouring among all 41160 candidates.

### Solving

- **Solvers.** CaDiCaL 1.7.3 (Debian package; building kissat or CaDiCaL from GitHub source was blocked in this container), plus kissat 4.0.4 and CaDiCaL 1.9.5 through `python-sat` 1.9.dev17 (pip).
- **Portfolio per (n, k)** (`src/drive.py`): CaDiCaL seed 0 writing LRAT, CaDiCaL `--sat` seed 1, CaDiCaL `--unsat` seed 2, and kissat. The first verified SAT moves on to k + 1. On UNSAT the driver waits for the proof job.
- **Monotonicity.** Deleting an orbit keeps a colouring valid, so UNSAT at k implies UNSAT for every k′ > k. In particular, k = n/4 is settled whenever a smaller k is UNSAT.
- **Proofs.** LRAT proofs are checked by `src/lratcheck.c`, a small independent RUP checker written for this task (drat-trim could not be built here). It re-propagates every hint chain in order and must reach the empty clause. Tests: it accepts CaDiCaL proofs, and it rejects proofs with one hint removed or with one literal dropped from a lemma. Proofs above 8 GB are abandoned.
- **Checking SAT models.** Every SAT model is decoded to (D, g) and rebuilt as an explicit graph. `src/check.py` then enumerates every 4-cycle by walking a–b–c–d–a. `certs.json` is checked again by `src/certcheck.py`, which works on the raw [u, v, c] edge lists.
