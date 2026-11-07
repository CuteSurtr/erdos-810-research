# Task CYC: exact optima of the cyclic orbit family for n = 37..100

Results folder: `bruteforce/results/CYC/C<i>/`, with i ∈ {0..7} given in your prompt.
Agent i takes the 8 values of n in its row below, working through them in increasing order. Each row has two multiples of 4.

| i | n |
|---|---|
| 0 | 37, 40, 47, 58, 69, 72, 79, 90 |
| 1 | 38, 44, 49, 59, 70, 76, 81, 91 |
| 2 | 39, 48, 50, 61, 71, 80, 82, 93 |
| 3 | 41, 51, 52, 62, 73, 83, 84, 94 |
| 4 | 42, 53, 56, 63, 74, 85, 88, 95 |
| 5 | 43, 54, 60, 65, 75, 86, 92, 97 |
| 6 | 45, 55, 64, 66, 77, 87, 96, 98 |
| 7 | 46, 57, 67, 68, 78, 89, 99, 100 |
Wrap up by the deadline in your prompt.

## The family (from `results/CONSTR/REPORT.md` F3, `cycsat.py`, `derivations.md`)

- Vertices are Z_n.
- Orbits are d ∈ {1, …, H}, where H = ⌈n/2⌉ − 1. The diameter n/2 is excluded, as in CONSTR.
- Each chosen orbit d ∈ D contributes the n edges {i, i+d}, and edge {i, i+d} gets colour i + g(d) (mod n).
- So |E| = n·|D|, with n colours. **k_max(n)** is the largest |D| for which some g makes every 4-cycle rainbow.

**Why it matters.** If k_max(n) ≥ εn for all large n, then M(n) ≥ εn², which would answer Erdős #810 positively.

**What CONSTR found** (`results/CONSTR/cyclic_family_status.json`, where "unsat" is the first k proved UNSAT):

| n | 13 | 14–17 | 18–20 | 21 | 22 | 23–26 | 27–30 | 31 | 32–34 | 36 |
|---|---|---|---|---|---|---|---|---|---|---|
| k_max | 3 | 4 | 5 | 6 | 5 | 6 | 7 | 8 | 8 | 9 |

For example, k_max(28) = 7, k_max(32) = 8, k_max(36) = 9: exactly **n/4** for these multiples of 4.

**Lower bounds only (annealing or SAT finds):**

| n | 37 | 40–42 | 46–50 | 52–55 | 59–62 |
|---|---|---|---|---|---|
| k | 9 | 10 | 11 | 12 | 13 |

**The central question.** Does k = n/4 stay achievable for n ≡ 0 (mod 4), and how does k_max(n)/n behave up to n = 100?

## Encoding (re-derive it; do not just copy)

Take a 4-cycle through vertex 0, written as a closed walk 0 → v1 → v2 → v3 → 0 on 4 distinct vertices.

- A step v → v + d (d ∈ 1..H) uses edge {v, v+d}, which has colour v + g(d).
- A step v → v − d uses edge {v−d, v}, which has colour (v − d) + g(d).
- So every edge colour has the form o + g(d), where the offset o is determined by the walk.
- Two edges with offsets o_a, o_b in different orbits d_a ≠ d_b collide iff g(d_a) − g(d_b) ≡ o_b − o_a.
- Two edges in the same orbit never collide.
- Rotations by Z_n move every 4-cycle to one through 0, so cycles through 0 suffice.

Required constraint: for every such cycle and every pair of its edges in different orbits, forbid that coincidence whenever all orbits on the cycle are present.

**Write a C (or C++) encoder that emits DIMACS.**
- CONSTR's Python encoder writes n clauses per forbidden (d_a, d_b, δ, other orbits) key, which blows up for large n.
- Use auxiliary variables y[d_a][d_b][δ] ⇐ ∃g: x[d_a][g] ∧ x[d_b][g−δ]. You only need the implication y ← (x ∧ x). Then each key becomes one short clause.
- Use a cardinality encoding for Σ p_d ≥ k, such as a totalizer or sequential counter.

## Symmetry (prove soundness in your REPORT)

**Colour translation.** Replacing g by g + t preserves validity, so you may fix g(smallest present orbit) = 0.

**Multipliers.** For a unit u ∈ Z_n^×, use the vertex map i ↦ ui and the colour map c ↦ uc.
- Orbit d maps to e = rep(ud) ∈ 1..H, with a sign σ = ±1 such that ud ≡ σe.
- The offset transforms as g′(e) = u·g(d) if σ = +1, and g′(e) = e + u·g(d) if σ = −1. Verify this.
- So the group Z_n^× acts on solutions, and changes the presence vector p by p′_e = p_{rep(u⁻¹e)}.

**Lex-leader.** Add constraints p ≥_lex p∘u for every unit u, or for a generating set, which is weaker but still sound.
- Combine them with the colour-translation fix.
- Sound order: first pick u that lex-maximises p, then translate colours; translation does not change p.
- Check empirically: with and without breaking, k_max must agree for n = 13..30, and solution counts should shrink.

## Validation (before your own n)

Reproduce k_max(n) for n = 13..30, 32 and 36 from the table above: SAT at k_max, UNSAT at k_max + 1.
- Re-check every SAT model as an explicit graph with a separate, deliberately simple 4-cycle checker.
- If anything differs from CONSTR, stop and report it.

## Per-n procedure (for your 8 values of n)

1. **Initial lower bound k_lo.**
   - Start from the best known k for this n: CONSTR's tables, or ⌊n/4⌋ − 2 if none is known.
   - Optionally improve it quickly with an annealer. CONSTR's `cyc.c` may be reused for seeding only.
2. **SAT upward.** Run SAT at k = k_lo + 1 upward with kissat or CaDiCaL, using several seeds or configurations in parallel.
   - **If n ≡ 0 (mod 4), try k = n/4 explicitly**, whatever k_lo is.
3. **UNSAT proof.** Try to prove UNSAT at the first k that fails, with CaDiCaL writing DRAT.
   - Check the proof with drat-trim if it is under about 5 GB and time allows.
   - Otherwise label it "UNSAT (solver, proof unchecked)".
4. **Time caps.** Cap the first pass at about 25 min wall per n. Spend the remaining time on unresolved n, preferring n ≡ 0 (mod 4).
5. **Record.** Write one line per n to `table.tsv`: n, k_lo, k_unsat (first UNSAT k, or blank), status, k_lo/n, seconds, notes.
   - Save every best (D, g) to `solutions.json` as {n: [[d, g], …]}, re-verified explicitly.
   - Commit at least every 30 minutes.

## Output

`REPORT.md` contains:
- placement;
- the encoder design and symmetry-breaking soundness;
- the validation table;
- your 8 rows with status;
- the observed k/n, including any n where k = n/4 is UNSAT or SAT;
- timings.

Commit the code in `src/` and put binaries in `.gitignore`.
