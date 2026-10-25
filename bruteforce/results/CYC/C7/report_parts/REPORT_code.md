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
