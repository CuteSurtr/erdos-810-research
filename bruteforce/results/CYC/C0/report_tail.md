
### 4.5 Cube-and-conquer for n = 47, k = 12

A single kissat run (lex + trans) reached its 6000 s limit without an answer. Its 12 GB DRAT
file was discarded. After that the problem was split on the presence variables p_2, p_3, p_4,
… The base CNF keeps all symmetry breaking (lex + trans). Each cube adds unit clauses on p_d.
Splitting on variables is complete by construction. `src/cover.py` checks that the UNSAT cubes
cover all 2^m assignments of the split variables.

- Cubes were run by `src/ccdispatch.sh` (at most 4 kissat processes, `--unsat`, per-cube time
  limit 1500–2400 s). Cubes that timed out were split on the next two orbits.
- Log: `logs/cube47.jsonl`, one line per cube with result and time.
- The cubes are solver results only: no DRAT was kept for them.

CUBE_SUMMARY

### 4.6 Timings (single core each, kissat unless noted)

- UNSAT at k_max + 1, lex + trans:
  - n = 36, k = 10: 33 s
  - n = 37, k = 10: 38 s
  - n = 40, k = 11: 188 s, or 206 s while writing DRAT
- n = 47, k = 12: more than 6000 s on one core. Cube-and-conquer: see §4.5.
- SAT at the found k_lo (best single run):
  - n = 37, k = 9: 1.8 s
  - n = 40, k = 10: 51 s
  - n = 47, k = 11: 12 s
  - n = 58, k = 13: 94 s
  - n = 69, k = 14: 5.5 s
  - n = 72, k = 15: 25 s
  - n = 79, k = 16: 130 s
  - n = 90, k = 17: 31 s
- All timeouts are listed in `table.tsv` and `logs/prod.jsonl`.

## 5. Where the code lives (`bruteforce/results/CYC/C0/`)

| file | purpose |
|---|---|
| `src/cycenc.c` | DIMACS encoder (y-aux pair encoding, Sinz counters, lex-leader, translation fix; `dump` mode prints the keys) |
| `src/run.py` | encode → kissat/CaDiCaL (seed, time, `--sat`/`--unsat`, DRAT, `--cube`) → decode → `check.py` → JSON log |
| `src/check.py` | simple explicit 4-cycle checker from (n, D, g) |
| `src/verify_certs.py` | second, independent checker on the edge lists in `certs.json` |
| `src/brute.py`, `src/count.py` | brute-force enumeration and SAT model counting (validation of encoding and symmetry breaking) |
| `src/symtest.py` | empirical test of the multiplier/translation action on all models |
| `src/validate.sh` | validation driver for n = 13..36 |
| `src/cycls.c`, `src/anneal.py` | (D, g) annealer on the same conflict keys |
| `src/lns.py` | anneal + SAT completion under assumptions (did not help) |
| `src/fixg.py` | fixed quadratic offsets + exact max-|D| by RC2 (negative result) |
| `src/ccwork.sh`, `src/ccdispatch.sh`, `src/cover.py` | cube-and-conquer workers and the coverage check |
| `src/queue.sh` | sequential job queue |
| `src/make_table.py` | builds `table.tsv`, `solutions.json` and `certs.json` from the logs and re-checks every solution |
| `logs/` | `validate.jsonl`, `prod.jsonl`, `proof.jsonl`, `cube47.jsonl`, drat-trim outputs, counts, queue files |

Build: `gcc -O2 -o src/cycenc src/cycenc.c` and `gcc -O2 -o src/cycls src/cycls.c -lm`.
Solvers were built from github.com/arminbiere/kissat (4.0.4), github.com/arminbiere/cadical
(3.0.1) and github.com/marijnheule/drat-trim. Paths can be overridden with the `KISSAT`,
`CADICAL` and `SCR` (scratch directory for CNFs) environment variables. Binaries are
git-ignored.

## 6. Surprises and next steps

1. **Task-table typo.** k_max(14) = 3, not 4 (§2). CONSTR's json is right.
2. **Lex-leader cuts both ways.**
   - It speeds UNSAT 5–6× (n = 30: 4.2 s vs 19.9 s; n = 36: 33 s vs 219 s).
   - It strongly hurts SAT at large n: n = 69 k = 15, n = 72 k = 16 and n = 90 k = 20 all
     timed out with lex.
   - `kissat --sat` with only the translation fix found n = 72 k = 15 in 25 s and n = 90 k = 17
     in 31 s.
   - Use lex for UNSAT and no lex for SAT.
3. **Multiples of 4 are not special at n = 72.** n/4 is attained and optimal at 28, 32, 36
   and 40. At 72 even n/4 − 2 = 16 was not found. The divisor-rich n (72, 90) look harder than
   their neighbours (69, 79): compare k_lo(72) = 15 with k_lo(79) = 16.
4. **The cube difficulty is very uneven.**
   - For n = 47, cubes with orbit 2 or 3 absent close in 1–60 s.
   - The cubes with 2, 3, 4 and 5 all present carry nearly all the work.
   - A finer split there (on more small orbits up front) is the natural sharding for the
     next n.

**Sharding plan for what is unfinished.** All commands run from this folder after building
`src/cycenc` and `src/cycls`.

- *UNSAT side, n = 58 at k = 14.* Use the same cube scheme as n = 47, but split on p_2…p_6
  up front (32 cubes):
  `python3 src/run.py 58 14 --cube=<±2,±3,±4,±5,±6> --opt=--unsat --timeout 3600 --log logs/cube58.jsonl`
  - Re-split any cube that times out on the next two orbits.
  - Check coverage with `python3 src/cover.py logs/cube58.jsonl 58 14`.
  - Estimate: n = 47 needed roughly 6–8 core-hours (see `logs/cube47.jsonl`). n = 58 is
    likely 10–100× harder.
- *SAT side, n = 58 k = 14, n = 69 k = 15, n = 72 k = 16, n = 79 k = 17, n = 90 k = 18.* Run
  many independent seeds:
  `python3 src/run.py N K --lex 0 --seed S --opt=--sat --timeout 3600 --log logs/prod.jsonl`
  - Use seeds S = 100.., one per core.
  - Alternate kissat with `--solver cadical`.
  - Each config has only been tried 1–3 times so far.
- *n = 72 at k = 18 (the n/4 question).* Proving UNSAT is far out of reach with this
  encoding, even at k = 16. A structural argument, or a much stronger symmetry reduction
  (for example the reflection g ↦ d − g(d) from u = −1, which is unused here), would be
  needed.
