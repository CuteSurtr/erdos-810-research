# AFFQ: affine model with fixed intercept formulas and arbitrary supports

## 1. Placement

```
{{PLACEMENT}}
```

Everything ran in this cloud container. Solvers: OR-Tools CP-SAT 9.15 and
python-sat 1.9.dev17 (RC2 with Glucose 4), both from pip. nauty `dreadnaut` came
from apt. The local search `ls.c` was written for this task.

## 2. Results

Model, as in the task file: rows X = F_p, columns Y = F_p. Colour a ∈ F_p^× is
the set of edges {(x, ax + β(a)) : x ∈ D_a}. The graph must be simple and every
4-cycle rainbow. We maximise m = Σ|D_a|. The graph has 2p vertices and p − 1
colours, so m is a lower bound for M(2p).

Status labels:

- **proved**: two independent exact methods agree, each validated on
  smaller cases.
- **exact by one method**: only one exact method finished.
- **H**: heuristic lower bound with a certificate-verified configuration. Its
  upper bound is the stated one. "distinct points" means the trivial bound: each
  point (x, y) carries at most one colour.

{{TABLE}}

The full table, with status strings, is in `table.tsv`.

### Headline findings

{{HEADLINES}}

## 3. Certificates

`certs.json` maps `beta -> {"2p": [[u, v, c], ...]}`. Vertices 0..p−1 are rows
x and p..2p−1 are columns y. Colour c = a − 1 lies in 0..p−2, inside the
0..2p−1 range allowed for n = 2p. Every configuration in it was rebuilt as an
explicit 2p-vertex graph. `check_simple.py` then checked it independently: it
tests simplicity and the colour range, and enumerates every 4-cycle directly. For
each pair of vertices u < w, every two common neighbours v1, v2 give the cycle
u–v1–w–v2. That checker has no knowledge of the affine structure.
`configs.json` lists the explicit supports D_a for p ≤ 13, as `supports[a]`.
For larger p it gives the support-size profile.

## 4. Method, parameters, validation

**Constraints (`model.py`).**
- Simplicity pairs: two colours whose lines pass through the same point (x, y)
  cannot both use row x.
- Bad 4-cycles: rows x1 < x2, colour a at both rows, a colour b through
  (x2, a·x1 + β(a)) and a colour c through (x1, a·x2 + β(a)). The four
  incidences (a,x1), (a,x2), (b,x2), (c,x1) must not all be present.

The colouring is automatically proper, because each colour is a partial
bijection. Counts are 1–2 × p³ clauses on p(p−1) variables.

**Cross-check (`crosscheck.py`).** For p = 5, 7, 11, 13 and every β, we drew
150–400 random supports of density 0.05–0.5. The clause test agreed with direct
4-cycle enumeration (`check_simple.py`) every time, on both valid and invalid
cases. The number of simplicity pairs matched the number of multi-edges in the
full candidate graph.

**Symmetries (`symmetry.py`, `autgroup.py`).** We brute-forced every map
(x,y) ↦ (sx+t, uy+v), and every transposed map, that preserves the family. The
results:
- a²: (x,y) ↦ (rx, r²y), with a ↦ ra.
- a³: (x,y) ↦ (r²x, r³y), with a ↦ ra.
- 1/a: (x,y) ↦ (r²x, ry), with a ↦ a/r.

Each group has order p − 1 and acts regularly on colours.
For β = 0 the group (x,y) ↦ (sx, uy) and its transposes has order 2(p−1)².
We also computed the full automorphism group of the clause hypergraph with
nauty. For a², a³ and 1/a it has order exactly p − 1 when p = 11 and 13, so
the affine maps are all the symmetries. (At p = 7 it is larger, 288 or 24.)
For β = 0 it is huge: 5.8·10⁹ at p = 11 and 1.1·10¹² at p = 13. The reason is
given in Section 6.

Symmetry breaking for the exact solvers:
- "size": the group is transitive on colours, so we may assume |D_1| ≥ |D_a|.
  For β = 0 we also assume row 1 has the largest count among nonzero rows; the
  group is transitive on (colour, nonzero row) pairs.
- "lex": lex-leader constraints for all group elements, from the closure of the
  nauty generators, capped at 300 elements.

**Exact methods.**
1. CP-SAT (`solve_cpsat.py`, size or lex breaking) maximises m.
   `decide.py` is the decision version, m ≥ target.
2. RC2 MaxSAT (`exact_rc2.py`) has no symmetry breaking. It is independent of
   method 1 except for the clause generator, which was validated separately.
3. At p = 5, `brute_p5.py` enumerates all 2²⁰ supports.

All three agree on every case they all finished (p = 5, 7, 11, 13; table).
The families 1/a and a² are isomorphic, by rows ↔ columns
(x,y) ↦ (y, −x) and a ↦ −1/a (`transfer.py`, verified by the checker), so their
optimal values are equal. Their proofs are shared, and the same values were also
obtained on each side separately.

**Heuristics.**
- `ls.c` is simulated annealing on incidence sets with conflict-repair moves:
  add v, then drop one other incidence from each clause v would complete, at most
  3 drops. Temperature falls linearly from 0.6 to 0.02, with a short tabu.
  - Round 1: 2·10⁴·p² iterations × 2 seeds.
  - Round 2: 6·10⁴·p² iterations, restarted from the best so far.
- `sym_solve.py` restricts to supports invariant under a cyclic subgroup of the
  symmetry group. At p = 13 it was strictly worse than unrestricted solving
  (best 75 vs 77 for a²), so we did not use it at larger p.
- `improve.sh` / `decide.py` runs CP-SAT on "best + 1" for p = 17–23.

**Timings.**
- p ≤ 11 is solved in under 1 s, except β = 0, p = 11 (Section 6).
- a²/1/a at p = 13: CP-SAT 5 s, RC2 1–13 s.
- a³ at p = 13: the optimiser was stuck at 76 for 900 s. The decision run
  "m ≥ 77" found a solution in 22–29 s.
- One LS run at p = 101 takes 2–5 min.

{{EXTRA}}

## 5. Code

All code is in this folder:
- `model.py`: constraints.
- `check_simple.py`: independent checker.
- `crosscheck.py`, `brute_p5.py`.
- `symmetry.py`, `autgroup.py`: symmetry groups.
- `solve_cpsat.py`, `decide.py`, `exact_rc2.py`.
- `ls.c` with `run_ls.py`, `sweep_ls.sh`, `sweep_ls2.sh`, `improve.sh`.
- `sym_solve.py`, `transfer.py`.
- `torus_squares.py`: the β = 0 reformulation.
- `analyze.py`, `make_table.py`, `fit.py`.
- `runs/`: every solution as incidence lists. Variable index (a−1)·p + x.
- `logs/`.

To rebuild: `gcc -O2 -o ls ls.c -lm`, then `python3 make_table.py` and
`python3 fit.py`.

## 6. Surprises and next steps

{{SURPRISES}}
