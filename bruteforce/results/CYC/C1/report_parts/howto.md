## 5. Code (`src/`)

| file | purpose |
|---|---|
| `cycenc.c` | DIMACS encoder: `cycenc n k sym out.cnf` (sym bit 1 = translation fix, bit 2 = lex-leader over units) |
| `run.py` | one solver run on one (n, k): `run.py n k sym timeout {cadical,kissat,cd195} seed [lrat_path]`. It decodes the model and re-checks it with `check.py` |
| `drive.py` | per-n portfolio driver: `drive.py n k_lo cap_s`. It logs to `logs/n<n>.jsonl` |
| `chain.sh` | first pass over the 8 values of n, at 25 min each |
| `watchdog.sh` | hard-kills pysat-kissat jobs past their time limit, because pysat's kissat ignores `interrupt()` |
| `check.py` | deliberately simple 4-cycle checker on (D, g) |
| `certcheck.py` | independent checker on raw `[u, v, c]` edge lists (`certs.json`) |
| `lratcheck.c` | small LRAT (RUP-hint) proof checker |
| `count.py` | solution counting with blocking clauses (symmetry-breaking check) |
| `brute14.py` | exhaustive (D, g) search, used for n = 14 |
| `collect.py` | builds `table.tsv`, `solutions.json` and `certs.json` from the logs |

Build: `gcc -O2 -o src/cycenc src/cycenc.c && gcc -O2 -o src/lratcheck src/lratcheck.c`.
Solvers: `apt-get install cadical` (1.7.3) and `pip install python-sat` (provides kissat404 and cadical195; use `/usr/bin/python3`).

To resume an unfinished (n, k), for example on another machine:

```
CYCWORK=/tmp/w python3 src/run.py <n> <k> 3 <seconds> cadical 0 /tmp/w/p.lrat   # UNSAT side, with proof
CYCWORK=/tmp/w python3 src/run.py <n> <k> 3 <seconds> cadical 1                 # --sat config
src/lratcheck /tmp/w/c_<n>_<k>_3.cnf /tmp/w/p.lrat
```
