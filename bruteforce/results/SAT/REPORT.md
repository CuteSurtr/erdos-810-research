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

| Claim | Status | Evidence |
|---|---|---|
| M(9) = 23 (validation) | **proved** | e=23 SAT, certificate-verified. e=24 UNSAT with a checked DRAT proof (`degcollex`, logged). It was also checked under `degcol` (drat-trim `s VERIFIED`, 34 s), but that output went only to the console |
| M(10) ≥ 30 | **certificate-verified** | `certs.json["10"]` |
| M(10) ≤ 30 (e=31 UNSAT) | **proved** (DRAT-checked) | full formula plus all 10 cubes Δ=0..9, each with a drat-trim `s VERIFIED` proof. The older `degcol` encoding agrees (CaDiCaL with checked DRAT on cubes Δ=7,8,9; Kissat 53 s on the full formula) |
| **M(10) = 30** | **proved** | agrees with the unverified first run |
| M(11) ≥ 34 | **certificate-verified** | `certs.json["11"]` |
| M(11) ≤ 34 (e=35 UNSAT) | **proved** (DRAT-checked) | 11 cubes Δ=0..10, each with a drat-trim `s VERIFIED` proof (Δ=7: 926 s solve, 1645 s check) |
| **M(11) = 34** | **proved** | agrees with the unverified first run |
| n=12, e=41 UNSAT | **unfinished** | Δ=0..6, 10, 11: UNSAT and DRAT-checked. Δ=9: CaDiCaL stopped at 11132 s with no answer. Δ=7, 8: split by march_cu, partly probed (see 4.4). No 41-edge good graph was found |
| **M(13) ≥ 47** (previous LB 46) | **certificate-verified** | `certs.json["13"]`, Kissat `--sat` on n=13, e=47 (`degcollex`), 999 s |
| **M(14) ≥ 54** (previous LB 53) | **certificate-verified** | `certs.json["14"]`, Kissat `--sat` on n=14, e=54, 1005 s |
| n=13, e=48; n=12, e=41; n=15, e=61 | **unfinished** | Kissat `--sat` seed 1 stopped at 7888 s, 7888 s and 4769 s with no answer (`logs/stopped_runs.txt`) |

Neither the upper bounds nor the cube proofs use the K_{s,t} lemma (`--kst`), and they use
nothing from the M12 task or `data/first-run/src`.

## 3. Certificates

`certs.json` has the format `{"n": [[u, v, colour], ...]}`, with vertices 0..n−1 and
colours 0..n−1. Both checkers pass on every entry (`logs/check*.log`):

- `check.py` enumerates all ordered 4-tuples (a, b, c, d) of distinct vertices. When ab, bc, cd
  and da are all edges, it requires 4 distinct colours. It also checks colour range and that
  no edge repeats.
- `check_q.py` builds Q(G) from the README definition and checks that the colouring is proper on Q.

New lower bound, n = 13, 47 edges (previous best 46):

```
[[0, 1, 0], [0, 2, 1], [0, 3, 2], [0, 4, 3], [0, 5, 4], [0, 6, 5], [0, 7, 6], [0, 8, 7], [0, 9, 8], [1, 2, 9], [1, 3, 10], [1, 4, 11], [1, 5, 6], [1, 6, 12], [1, 11, 1], [1, 12, 5], [2, 3, 12], [2, 4, 5], [2, 5, 8], [2, 7, 7], [2, 10, 0], [3, 4, 4], [3, 7, 11], [3, 11, 6], [3, 12, 3], [4, 9, 10], [4, 10, 2], [4, 11, 8], [5, 6, 2], [5, 8, 3], [5, 10, 12], [5, 12, 11], [6, 7, 3], [6, 8, 10], [6, 9, 1], [6, 11, 4], [7, 9, 12], [7, 10, 9], [7, 12, 1], [8, 9, 0], [8, 10, 5], [8, 11, 9], [8, 12, 8], [9, 10, 11], [10, 11, 7], [10, 12, 10], [11, 12, 0]]
```

New lower bound, n = 14, 54 edges (previous best 53):

```
[[0, 1, 0], [0, 2, 1], [0, 3, 2], [0, 4, 3], [0, 5, 4], [0, 6, 5], [0, 7, 6], [0, 8, 7], [1, 2, 8], [1, 3, 9], [1, 4, 10], [1, 6, 4], [1, 7, 11], [1, 9, 12], [1, 10, 13], [2, 3, 7], [2, 4, 11], [2, 6, 6], [2, 9, 3], [2, 10, 2], [2, 11, 13], [3, 5, 8], [3, 7, 3], [3, 9, 10], [3, 11, 5], [3, 12, 0], [4, 8, 2], [4, 10, 9], [4, 11, 6], [4, 12, 8], [4, 13, 1], [5, 7, 1], [5, 9, 6], [5, 10, 10], [5, 11, 11], [5, 12, 13], [5, 13, 2], [6, 8, 8], [6, 9, 11], [6, 10, 7], [6, 13, 12], [7, 8, 13], [7, 10, 12], [7, 12, 7], [8, 9, 9], [8, 11, 0], [8, 13, 10], [9, 11, 1], [9, 12, 4], [10, 12, 5], [10, 13, 0], [11, 12, 12], [11, 13, 7], [12, 13, 3]]
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

Per-cube timings: CaDiCaL solve / drat-trim check, wall-clock seconds. Up to 4 jobs ran at
once on 4 cores, so the times include contention.

| instance | Δ cubes 0..6 | Δ=7 | Δ=8 | Δ=9 | Δ=10 | Δ=11 | full formula |
|---|---|---|---|---|---|---|---|
| n=9, e=24 | — | — | — | — | — | — | 1 / 1 |
| n=10, e=31 | each ≤ 1 / ≤ 1 | 2 / 1 | 2 / 1 | 2 / 1 | — | — | 5 / 3 |
| n=11, e=35 | each ≤ 1 / ≤ 1 | 926 / 1645 | 160 / 203 | 59 / 60 | 23 / 18 | — | not run |
| n=12, e=41 | each ≤ 1 / ≤ 1 | split (4.4) | split (4.4) | >11132 (stopped) | 2556 / 2753 | 506 / 929 | not run |

The symmetry breaking matters a great deal. On n=10, e=31 (single core):

| SB | time |
|---|---|
| `deg` only (V1) | >600 s, stopped |
| `col` only (C) | >600 s, stopped |
| `degcol` (V1+C) | 67 s |
| `degcollex` (V1+V2+C) | 5 s |

On n=9, e=24 the times are 27 s (`degcol`) and 1 s (`degcollex`). On n=11, the `degcol` cubes ran
65 min without finishing; with `degcollex` the hardest cube took 926 s.

### 4.4 n = 12, e = 41: state and sharding plan

Done: cubes Δ ∈ {0,…,6, 10, 11} are UNSAT with checked DRAT proofs (hashes in the logs).

Remaining: Δ = 7, 8, 9. All commands run from `bruteforce/results/SAT/`, after building
CaDiCaL, drat-trim and CnC/march_cu (`-fcommon`) and symlinking them as `cadical_bin`,
`drat_bin` and `march_bin`:

```bash
python3 enc.py 12 41 cnf/n12e41_lex_d$D.cnf --sb degcollex --maxdeg $D   # sha256 in cnf_sha256.txt
```

- **Δ = 9:** one CaDiCaL run went past 3.1 h with no answer, and its DRAT reached 6.2 GB.
  Split it first:
  `./march_bin cnf/n12e41_lex_d9.cnf -d 10 -o cubes/n12e41_lex_d9.d10.icnf`.
  Then `python3 mkcubes.py cnf/n12e41_lex_d9.cnf cubes/n12e41_lex_d9.d10.icnf cnf/cub n12d9`,
  and run `./run_cube.sh <name> cnf/cub/<name>.cnf <proofdir>` on each cube and on `n12d9_cover`.
- **Δ = 8:** `cubes/n12e41_lex_d8.d10.icnf` has 509 cubes. Regenerate the CNFs with
  `python3 mkcubes.py cnf/n12e41_lex_d8.cnf cubes/n12e41_lex_d8.d10.icnf cnf/cub n12d8`.
  Probe at a 60 s cap (`logs/probe_n12d8.log`, first 187 cubes): 168 UNSAT, 49 s in total, and
  19 hit the cap (≈10%). Extrapolated, about 50 of the 509 need more than 60 s and should be
  re-split with march at depth 10–12. The cover CNF `n12d8_cover` was not yet run.
- **Δ = 7:** `cubes/n12e41_lex_d7.d9.icnf` has 66 cubes. 65 cubes and the cover CNF are UNSAT
  in ≤ 1 s each (`logs/probe_n12d7.log`, not yet DRAT-checked). Cube 65 is hard. It was re-split
  as `cubes/n12e41_lex_d7_c0065.d12.icnf` (997 cubes) with
  `python3 mkcubes.py cnf/cub/n12d7_c0065.cnf cubes/n12e41_lex_d7_c0065.d12.icnf cnf/cub2 n12d7c65`.
  Probe at 60 s (`logs/probe_n12d7c65.log`, first 125): 107 UNSAT in 208 s total and 18 at the
  cap (≈14%), so about 140 hard subcubes. One of them (c0041) was still open after 400 s even
  with the K_{s,t} lemma clauses.
- **Proof obligations per shard:** every cube CNF and every cover CNF needs `s VERIFIED` from
  drat-trim. Then F_D is UNSAT because F_D ∧ ¬C_1 ∧ … ∧ ¬C_m is UNSAT (cover) and each
  F_D ∧ C_i is UNSAT. Nested splits compose the same way.
- **Rough cost** with the current encoding: one to a few hundred core-hours for Δ = 7 + 8 + 9,
  plus about as much again for DRAT checking. This is a guess from the probes, not a measurement.
  Δ = 9 is the most uncertain part.

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

- **New lower bounds from plain SAT:** M(13) ≥ 47 and M(14) ≥ 54 each beat the local-search
  table by one, and each took about 1000 s of Kissat with full symmetry breaking. The rest of the
  local-search table (n = 15..25) is probably not tight either. Next step: Kissat/CaDiCaL `--sat`
  with several seeds on n = 13, e = 48 (stopped at 2.2 h); n = 14, e = 55; and n = 15, e = 61
  (stopped at 1.3 h) and up. Seeding with the known certificates (phase hints) may help.
- **The lex rule V2 is the decisive speedup:** 13–27× on n = 9, 10. It is Codish et al.'s row
  comparison, made sound on top of the degree canonical form by guarding it with "same block and
  equal degree".
- **n = 12 hardness:** the rare cubes are hard because, with ≥ 10 vertices of degree 7 (Δ = 7,
  41 edges), the degree rules carry almost no information. Stronger graph symmetry breaking
  (SAT Modulo Symmetries) should pay off most there. `pysms` failed to build from pip
  (setuptools `install_layout` error); the source is at
  github.com/markirch/sat-modulo-symmetries.
- **Pigeonhole cores:** K_{s,t} ⊆ G forces a clique of size st in Q(G), because all its edges
  pairwise conflict, so for k = n graphs are K_{s,t}-free whenever st > n. Adding these clauses
  (`--kst`, lemma proved in `enc.py`) gave ≈2× on n = 9, 10 but did not settle the hard
  n = 12 subcubes. No claim uses it.
- **Cross-check with M12:** these SAT results independently confirm M(10) = 30 and M(11) = 34.
  They are compatible with the first run's "no good 41-edge graph on 12 vertices", which is not
  yet settled here.
