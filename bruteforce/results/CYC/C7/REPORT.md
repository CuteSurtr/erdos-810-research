# CYC/C7: cyclic orbit family, n = 46, 57, 67, 68, 78, 89, 99, 100

## 1. Placement

```
$ uname -a; nproc; free -g
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

All computation ran in this cloud container. Solvers: kissat and CaDiCaL built from
`github.com/arminbiere/{kissat,cadical}` (master, shallow clone, 2026-10-25), drat-trim from
`github.com/marijnheule/drat-trim`. No pysat (not needed).

## 2. Results

| n | best k (certificate-verified) | k/n | |E| = nk | how found | larger k tried (no answer within cap) | k = n/4 | status |
|---|---|---|---|---|---|---|---|
| 46 | 11 | 0.2391 | 506 | kissat, 140.9 s | k=12: longest 8577 s | – | lower bound k ≥ 11; k_max unfinished |
| 57 | 13 | 0.2281 | 741 | cadical, 551.3 s | k=14: longest 1199 s | – | lower bound k ≥ 13; k_max unfinished |
| 67 | 14 | 0.2090 | 938 | kissat, 9.9 s | k=15: longest 1487 s | – | lower bound k ≥ 14; k_max unfinished |
| 68 | 14 | 0.2059 | 952 | cadical --sat, 3.6 s | k=15: longest 8577 s, k=17: longest 499 s | k=17: not found (499 s) | lower bound k ≥ 14; k_max unfinished |
| 78 | 16 | 0.2051 | 1248 | cadical, 150.0 s | k=17: longest 1499 s | – | lower bound k ≥ 16; k_max unfinished |
| 89 | 17 | 0.1910 | 1513 | kissat --sat, 21.8 s | k=18: longest 1199 s, k=19: longest 400 s, k=20: longest 1499 s | – | lower bound k ≥ 17; k_max unfinished |
| 99 | 19 | 0.1919 | 1881 | kissat --sat, 249.8 s | k=20: longest 1199 s, k=21: longest 400 s, k=22: longest 1499 s | – | lower bound k ≥ 19; k_max unfinished |
| 100 | 19 | 0.1900 | 1900 | kissat --sat, 44.4 s | k=20: longest 8351 s, k=23: longest 999 s, k=25: longest 497 s | k=25: not found (497 s) | lower bound k ≥ 19; k_max unfinished |

Status labels: every k above is *certificate-verified*: (D, g) is in `solutions.json`, and the
explicit edge list `[u, v, colour]` is in `certs.json`. Each was re-checked by `src/check.py`
(enumerates all 4-cycles). No k_max for my eight n is *proved*. No UNSAT result was obtained at any
k for these n, so every larger k is *unfinished*, not "infeasible". `table.tsv` has the per-n line
the task asks for (k_lo = best certificate, k_unsat blank).

**Observed k/n.** Best k/n: 0.239 (46), 0.228 (57), 0.209 (67), 0.206 (68), 0.205 (78),
0.191 (89), 0.192 (99), 0.190 (100). For the two multiples of 4, **k = n/4 was not found**:
n = 68 (k = 17) and n = 100 (k = 25), and neither was any k between the best and n/4. There is no
UNSAT proof at n/4 either, so the question "does n/4 persist" stays open for these n. The
negative evidence is only search failure.

**Compared with earlier bounds.** n = 57: k = 13 (741 edges) beats CONSTR's cyclic k = 12 (684) and
its general local-search value (684). n = 67: k = 14 (938 edges) beats CONSTR's general bound 909.
n = 46: k = 11, the same as CONSTR. n = 89: k = 17, the same as CONSTR's cyclic 1513 (its general
local search has 1519). n = 68, 78, 99, 100 had no CONSTR value.

## 3. Certificates

`certs.json`: `{"n": [[u, v, c], ...]}` (n·k edges each). `solutions.json`: `{"n": [[d, g], ...]}`,
the edge set {i, i+d} with colour i + g(d) mod n. Both are produced by `src/make_tables.py`, which
re-runs the checker on every entry.


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

*Empirical check* (§4.5): with sym = 0 (none), 1 (translation only), 2 (translation +
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

### 4.4 Runs (per n) and timings

- **First pass** (`src/pern.py`, about 25 min wall per n, two n at a time). Kissat (default, seed 1)
  and CaDiCaL (default, seed 2) race at k = k_lo, k_lo + 1, …; the first definite answer wins. For
  n ≡ 0 (mod 4), k = n/4 also got a third of the cap. Starting k: 46 → 12; 57 → 13 (CONSTR had 12);
  ⌊n/4⌋ − 2 otherwise (67 → 14, 68 → 15 + 17, 78 → 17, 89 → 20, 99 → 22, 100 → 23 + 25).
- **Certificate fallback** (`src/down.py`): for n with no SAT, race again at decreasing k with
  400 s per k. Seeds from CONSTR's annealer (`src/cyc_constr.c`, 120 s, `anneal/`) were also
  verified and logged as certificates of last resort.
- **Second pass** (`src/second.py`, until 09:55 UTC): one solver per core.
  46/k = 12 with kissat `--unsat`; 68 climbing from k = 15 with kissat `--sat`; 100 climbing from
  best + 1 with kissat `--sat`; quick `--sat` probes climbing on 89, 99, 78, 67, 57
  (`src/probe.sh`, 300 s then 1200 s per n).
- Every solver run is one JSON line in `data/main.jsonl` (n, k, solver, config, seed, result,
  seconds, and (D, g) when SAT).

**Lost log lines (disclosed).** The first n = 46, k = 12 race (kissat and CaDiCaL default, from
05:27 UTC) ran to its 1500 s cap; the k = 11 run chained after it finished at 05:54, 141 s later.
Its UNKNOWN lines went to an unlinked file because a `git pull --rebase` replaced
`logs/main.jsonl` while the processes had it open. A second rebase, replaying a commit that untracked
`logs/`, deleted the live files. All other lines were restored from the snapshot committed at
06:33 (`git show 7a8c19b:…/data/main.jsonl`). The 46/k = 12 result is recorded in `notes.json` and
counted in the table as "no answer in 1500 s".

### 4.5 Validation (n = 13..30, 32, 36)

All SAT/UNSAT answers reproduce CONSTR's k_max (`results/CONSTR/REPORT.md` §2c and
`cyclic_family_status.json`). Every SAT model was re-checked by `check.py`. Columns sym0/1/2 are
no symmetry breaking / colour translation only / translation + lex-leader. Brute force is
`src/brute.c` (independent, explicit 4-cycles), which gives counts of valid (D, g) at k_max and 0
at k_max + 1 for n = 13..27.

**Note on the task table.** `tasks/CYC.md` lists k_max = 4 for n = 14 ("14–17 | 4"). CONSTR's own
data says k_max(14) = 3 (`cyclic_family_status.json`: first UNSAT k = 4; REPORT §2c: 3). My SAT
encodings (all three symmetry modes) and the brute force agree with CONSTR, so this is a
transcription slip in the task file, not a disagreement with CONSTR.

| n | CONSTR k_max | sym0 SAT@k / UNSAT@k+1 (s) | sym1 | sym2 | brute force #(D,g) at k: all / g(min)=0 / +lex-leader ; at k+1 |
|---|---|---|---|---|---|
| 13 | 3 | SAT/UNSAT (0.0/0.0) | SAT/UNSAT (0.0/0.0) | SAT/UNSAT (0.0/0.0) | 4420 / 340 / 82 ; 0 |
| 14 | 3 | SAT/UNSAT (0.0/0.0) | SAT/UNSAT (0.0/0.0) | SAT/UNSAT (0.1/0.0) | 8596 / 614 / 206 ; 0 |
| 15 | 4 | SAT/UNSAT (0.0/0.1) | SAT/UNSAT (0.0/0.0) | SAT/UNSAT (0.0/0.0) | 1380 / 92 / 30 ; 0 |
| 16 | 4 | SAT/UNSAT (0.0/0.1) | SAT/UNSAT (0.0/0.0) | SAT/UNSAT (0.0/0.0) | 7424 / 464 / 116 ; 0 |
| 17 | 4 | SAT/UNSAT (0.0/0.4) | SAT/UNSAT (0.0/0.1) | SAT/UNSAT (0.0/0.0) | 51952 / 3056 / 526 ; 0 |
| 18 | 5 | SAT/UNSAT (0.0/0.1) | SAT/UNSAT (0.0/0.0) | SAT/UNSAT (0.0/0.0) | 108 / 6 / 2 ; 0 |
| 19 | 5 | SAT/UNSAT (0.0/0.5) | SAT/UNSAT (0.0/0.0) | SAT/UNSAT (0.0/0.0) | 4788 / 252 / 28 ; 0 |
| 20 | 5 | SAT/UNSAT (0.0/0.8) | SAT/UNSAT (0.0/0.1) | SAT/UNSAT (0.0/0.0) | 26400 / 1320 / 410 ; 0 |
| 21 | 6 | SAT/UNSAT (0.1/0.8) | SAT/UNSAT (0.1/0.1) | SAT/UNSAT (0.1/0.0) | 84 / 4 / 2 ; 0 |
| 22 | 5 | SAT/UNSAT (0.1/4.4) | SAT/UNSAT (0.1/0.2) | SAT/UNSAT (0.1/0.1) | 953260 / 43330 / 8666 ; 0 |
| 23 | 6 | SAT/UNSAT (0.1/5.1) | SAT/UNSAT (0.1/0.2) | SAT/UNSAT (0.1/0.1) | 14168 / 616 / 56 ; 0 |
| 24 | 6 | SAT/UNSAT (0.1/6.3) | SAT/UNSAT (0.1/0.3) | SAT/UNSAT (0.1/0.1) | 69216 / 2884 / 934 ; 0 |
| 25 | 6 | SAT/UNSAT (0.1/46.8) | SAT/UNSAT (0.1/1.8) | SAT/UNSAT (0.1/0.2) | 1132500 / 45300 / 4744 ; 0 |
| 26 | 6 | SAT/UNSAT (0.1/62.6) | SAT/UNSAT (0.1/1.8) | SAT/UNSAT (0.1/0.4) | 4925544 / 189444 / 33434 ; 0 |
| 27 | 7 | SAT/UNSAT (0.6/76.5) | SAT/UNSAT (0.2/2.4) | SAT/UNSAT (0.2/0.4) | 4860 / 180 / 20 ; 0 |
| 28 | 7 | SAT/UNSAT (0.2/62.3) | SAT/UNSAT (0.2/2.4) | SAT/UNSAT (0.2/0.6) | – |
| 29 | 7 | SAT/UNSAT (0.2/625.6) | SAT/UNSAT (0.3/11.6) | SAT/UNSAT (0.2/1.1) | – |
| 30 | 7 | SAT/UNSAT (0.3/947.5) | SAT/UNSAT (0.3/17.3) | SAT/UNSAT (0.2/3.7) | – |
| 32 | 8 | – | – | SAT/UNSAT (0.4/2.4) | – |
| 36 | 9 | – | – | SAT/UNSAT (2.4/30.6) | – |

Mismatches with CONSTR: 0


## 5. Code (all in `src/`; binaries are in `.gitignore`)

| file | purpose |
|---|---|
| `cycenc.c` | DIMACS encoder: `cycenc n k sym amo out.cnf` (sym 0 none / 1 translation / 2 translation + lex-leader) |
| `run.py` | encode, run kissat or CaDiCaL, decode the model, re-check with `check.py`; one JSON line |
| `check.py` | simple explicit 4-cycle checker for (n, [[d, g], ...]) |
| `brute.c` | independent brute force over (D, g) with explicit 4-cycle checks; solution counts |
| `brute_all.sh`, `validate.sh` | validation drivers (n = 13..36) |
| `pern.py` | per-n driver: races kissat (seed 1) and CaDiCaL (seed 2) at k, k+1, ... under a wall cap |
| `streamA.sh`, `streamB.sh` | the first-pass queues (two 2-core streams) |
| `race.py`, `down.py`, `streamC.sh`, `streamD.sh` | certificate fallback (race at decreasing k) |
| `second.py`, `second.sh`, `probe.sh`, `probe2.sh` | second pass (one solver per core, `$CYCCONF` = `--sat`/`--unsat`) |
| `cycls.c` | constraint-level local search (experimental, not used for any result) |
| `units.py` | units of Z_n and their order modulo ±1 (for the invariance experiments) |
| `valtable.py`, `report.py` | build `validation.md` and `REPORT.md` |
| `make_tables.py` | builds `table.tsv`, `solutions.json`, `certs.json` from `logs/main.jsonl`, re-verifying |
| `cyc_constr.c` | CONSTR's annealer, copied unchanged, used only for seeding (`anneal/`) |

Build: `gcc -O2 -o src/cycenc src/cycenc.c; gcc -O2 -o src/brute src/brute.c; gcc -O2 -o src/cyc src/cyc_constr.c -lm`.
Solvers are expected at `/tmp/kissat/build/kissat` and `/tmp/cadical/build/cadical`
(`git clone --depth 1 https://github.com/arminbiere/kissat; ./configure && make`, same for cadical).

Logs: `logs/validate.jsonl` (validation SAT runs), `logs/brute.txt` (brute-force counts),
`logs/main.jsonl` (every solver run on my 8 values of n, one JSON line each; the losing solver of a
race is killed and not logged).

`REPORT.md` is assembled by `src/report.py` from `report_parts/` and `data/main.jsonl`
(copied from the live `logs/`). `validation.md` comes from `src/valtable.py`.

## 6. Surprises and next steps

1. **The solver configuration matters more than the cap.** With default settings, kissat and
   CaDiCaL found nothing at 89 (k = 18, 19), 99 (k = 19, 20) or 100 (k = 23) in 400–1500 s. With
   `--sat` (kissat: `--target=2 --restartint=50`), kissat found 89 at k = 17 in 22 s, 99 at
   k = 17, 18, 19 in 21 / 21 / 250 s and 100 at k = 18, 19 in 21 / 44 s, and CaDiCaL `--sat`
   found 68 at k = 14 in 3.6 s. Any further SAT-side search on this family should use `--sat`
   and several seeds.
2. **No n/4 at 68 or 100.** k = 17 at n = 68 and k = 25 at n = 100 were not found, and neither were
   k = 15 at 68 (kissat `--sat`, 8577 s) or k = 20 at 100 (kissat `--sat`, 8351 s). The best found k/n drops from 0.239 (n = 46) to about 0.19
   (n = 89..100). This is only a search failure, not an UNSAT result: the hard instances near k/n
   ≈ 0.2 are beyond a 25-minute single-core SAT run at these sizes. The data is consistent with
   k_max(n)/n decreasing, but it proves nothing about it.
3. **D-invariance heuristics.** Forcing (D, g) to be invariant under a multiplier u up to a
   translation T (`cycenc ... U T`) was UNSAT at k = n/4 for n = 28, 32, 36 for every
   u of order ≤ 4 and every T class. Forcing only D to be invariant under u = n/2 − 1 (odd
   d ↦ n/2 − d, even d fixed) is SAT at k = n/4 for n = 28 and 36, but did not reach k = 10 at
   n = 40 within 300 s. It is not a shortcut.
4. **Constraint-level local search** (`src/cycls.c`, min-conflicts on the forbidden-coincidence
   keys) was weaker than SAT (k = 10 at n = 46 against SAT's 11) and was not used for any result.
5. **Process lesson.** A `git pull --rebase` replays your own commits and rewrites their files in
   the working tree. That broke append-mode logs twice here (§4.4). Keep live logs untracked and
   commit snapshots.

**Next steps (exact sharding plan for the open cases).** For each open (n, k), run
`CYCCONF=--sat python3 src/run.py n k 2 kissat <seed> <seconds>` with seeds 1..8 in parallel
(one core each). Encoding takes ≤ 3 s and ≤ 240 MB of DIMACS at n = 100, and kissat uses about
0.8 GB of RAM (CaDiCaL about 1.7 GB). The most informative targets are 46/k = 12 and 57/k = 14,
near the n/4 line. Kissat `--unsat` ran 8577 s on 46/k = 12 without an answer, so an UNSAT proof
needs more than 2.4 CPU-hours there. Cube-and-conquer is the natural sharding: split on the
presence bits p_1..p_6 (64 cubes, add them as unit clauses), and run one cube per core with
`--unsat`, adding `/tmp/proof.drat` as the 7th argument of `run.py` for a DRAT file. Then try
68/k = 15 and 100/k = 20.
