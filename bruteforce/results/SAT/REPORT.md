# Task SAT: independent SAT line for M(10), M(11), M(12)

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

All computation ran in this cloud container (4 cores, 15 GB RAM), 11:45 to 16:30 UTC on 2026-10-24.

## 2. Results

__RESULTS__

## 3. Certificates

`certs.json` has the format `{"n": [[u, v, colour], ...]}`, with vertices 0..n−1 and
colours 0..n−1. Both checkers pass on every entry (`logs/check*.log`):

- `check.py` enumerates all ordered 4-tuples (a, b, c, d) of distinct vertices. When ab, bc, cd
  and da are all edges, it requires 4 distinct colours. It also checks colour range and that
  no edge repeats.
- `check_q.py` builds Q(G) from the README definition and checks that the colouring is proper on Q.

New lower bound, n = 13, 47 edges (previous best 46):

```
__CERT13__
```

The n = 9 (23 edges), 10 (30) and 11 (34) certificates are in `certs.json`.

## 4. Method

### 4.1 Encoding (`enc.py`)

- `x_uv` for each of the C(n,2) vertex pairs, and `y_{uv,c}` for each pair and colour c < k
  (k = n throughout).
- **Colour existence:** `x_uv → OR_c y_{uv,c}` (at least one), and `y_{uv,c} → x_uv`.
- **4-cycles:** for every 4-cycle C (3 per 4-set of vertices) and every pair {e, f} of its edges,
  let g, h be the other two edges. Clause `¬x_g ∨ ¬x_h ∨ z_{e,f}`. Then for every colour c,
  `¬z_{e,f} ∨ ¬y_{e,c} ∨ ¬y_{f,c}`. Here `z_{e,f}` means "e and f lie on a common 4-cycle of G";
  only the implying direction is encoded.
- **Cardinality:** `Σ x ≥ e` by the pysat totalizer.

**Soundness (model → good graph).** Let G = {uv : x_uv}. G has ≥ e edges. Each edge gets
one of its true colours (at least one exists). Take a 4-cycle of G and two of its edges e, f.
The other two edges are present, so `z_{e,f}` is true, and then no colour is true on both e and f.
So the chosen colours are distinct on every 4-cycle.

**Completeness (good graph → model).** Set x = G and set y to the colouring, one colour per edge.
Set `z_{e,f}` true exactly when e, f lie on a 4-cycle of G, and give the totalizer its intended
values. Every clause holds.

At-least-one is enough, because a model with several true colours on an edge still yields a
valid colouring by picking any one. No at-most-one is needed. Adding it did not change speed
(n = 9, e = 24: 27 s either way).

### 4.2 Symmetry breaking (`--sb degcollex`, used for every claimed result)

Every good graph with a valid colouring has an image under (vertex relabelling π, colour
relabelling σ) that satisfies all the constraints below. π is chosen from G alone. σ is chosen
afterwards and does not change G, so the vertex rules stay satisfied. That is why combining the
two kinds of breaking is sound.

Exact unary degree counters `ge(v,t) ⇔ deg(v) ≥ t` (sequential counter with both directions).

**(V1) Degree rules.** Vertex 0 has maximum degree. N(0) = {1, …, deg 0}, encoded as
`x_{0j} → x_{0,j−1}`. Inside N(0), and inside V∖N[0], degrees are non-increasing in the label.
*Sound:* pick any maximum-degree vertex as 0, label its neighbours first, then sort each block
by degree. Call the set of labellings of G satisfying V1 L(G). It is never empty.

**(V2) Lex rule.** Order the pairs (0,1), (0,2), …, (0,n−1), (1,2), … (row-major) and let x(G)
be the bit string. From L(G) choose the labelling with **lex-maximal** x(G). Take 1 ≤ i < j in the
same block (x_{0i} = x_{0j}) with deg i = deg j. The transposition τ = (i j) maps L(G) to itself:
vertex 0, N(0) as a set, and the sorted degree sequence of each block are unchanged. So
x(G) ≥_lex x(τG). In row-major order the positions τ moves are, in order: (a,i)/(a,j) for a < i,
then (i,b)/(j,b) for b > i, b ≠ j. Positions (a,j) with i < a < j are twins of (i,a), which
comes earlier. Later twins are equal whenever every earlier position is equal. So the
condition is exactly: **row i ≥_lex row j, both restricted to columns ∉ {i, j}, column 0
dropped as well** (x_{0i} = x_{0j} there). This is the Codish–Miller–Prosser–Stuckey row
comparison, guarded by "same block ∧ equal degree". The encoding forces the guard variable
q0 true whenever the guard holds (witness variables `w_t ⇒ ge(i,t) ∧ ¬ge(j,t)`). It uses
prefix-equality variables q_k forced true while the prefix is equal, plus `q_{k−1} → (X_k ≥ Y_k)`.
Setting every auxiliary variable to its intended value satisfies all clauses.

**(C) Colour first-occurrence.** With the same fixed edge order, `u_{i,c}` ⇔ colour c is used on
one of edges 0..i. The clause `y_{e_i,c} → u_{i−1,c−1} ∨ u_{i−1,c}` for c ≥ 1, and edge 0 can
only take colour 0. *Sound:* renumber colours by order of first appearance (σ). A colour c
appearing for the first time at e_i has c−1 already used before.

**Empirical soundness tests** (`sbtest.py`, `logs/sbtest_degcollex.log`):

- n = 6, all 2^15 labelled graphs: every one of the 127 isomorphism classes of good graphs
  contains an SB-accepted labelling, and no non-good graph is accepted.
- n = 7, 8: for 200 random good graphs each, a random-relabelling search found an
  SB-accepted labelling every time.

**Value checks** (`validate_small.py`, `logs/validate_small*.log`): M(n) for n = 2..9 is
reproduced exactly (e = M SAT with checked certificate, e = M+1 UNSAT). This holds with
`degcollex`, with `degcol` (V1 + C only, n ≤ 8), and with no symmetry breaking (n ≤ 7).
Also n = 10, e = 30 and n = 11, e = 34 are SAT under `degcollex`.

### 4.3 Cubes, proofs and checking

- **Max-degree split.** Cube d adds `deg(0) = d`, d = 0..n−1. Under V1 this means Δ(G) = d.
  The cubes are exhaustive because deg(0) ∈ {0..n−1}. Every d was run, including the trivially
  UNSAT d < ⌈2e/n⌉, so no extra argument is needed.
- **Proofs.** Each cube is solved by CaDiCaL 3.0.1 writing a binary DRAT proof, then checked by
  drat-trim (`run_cube.sh`). The CNF hash is appended to each `logs/*.drat.log`. Proof files
  were deleted after `s VERIFIED` (they are 0.1–1.5 GB each).
- **Determinism.** The CNFs are regenerated byte-identically by `enc.py` (checked for all
  n = 10, 11, 12 cubes). SHA-256 hashes are in `cnf_sha256.txt`.
- **march cubes.** For n = 12 the hard Δ = 7, 8 cubes were split further with `march_cu`
  (CnC, Heule). `mkcubes.py` writes one CNF per cube plus a *cover* CNF: the base formula plus
  the negation of every cube. Cover UNSAT ⇒ the cubes cover the base formula's models.

__TABLES__

## 5. Files

- `enc.py`: encoder (CLI and `build()` API). Options: `--sb none|deg|col|degcol|degcollex`,
  `--maxdeg d`, `--fix v=d,…`, `--kst` (experimental, not used for any claim), `--amo`.
- `solve.py`: pysat solve and decode. `decode_model.py`: decode a DIMACS model and re-check it
  against the CNF.
- `check.py`, `check_q.py`: the two independent certificate checkers.
- `validate_small.py`, `validate8.py`, `sbtest.py`: validation.
- `run_cube.sh`: solve + DRAT + check. `run_kissat.sh`: SAT search.
  `mkcubes.py`: march cubes → per-cube CNFs + cover CNF.
- `cubes/*.icnf`: march cube files (n = 12, Δ = 7 depth 9, its last cube at depth 12, and
  Δ = 8 depth 10).
- `logs/`: every solver and checker log with times. `logs/old_degcol/`: the superseded first
  n = 11 attempt.
- `certs.json`.

Tools: CaDiCaL 3.0.1 (git c607304), Kissat 4.0.4 (8af8e56), drat-trim (2e3b2dc), march_cu from
CnC (705b60c, built with `-fcommon`) and python-sat 1.9.dev17, all built from GitHub or pip.
`pysms` failed to build from pip and was not used.

## 6. Surprises and next steps

__NEXT__
