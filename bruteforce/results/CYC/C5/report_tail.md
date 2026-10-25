
## 5. Solving procedure and timings

- **`src/cycrun.py`** runs one query (encode → solve → decode → `check4.py`) and prints one JSON
  line. Raw per-racer records are in `runs/n<n>.jsonl`.
- **`src/drive.py`** runs the per-n race. For each k, parallel racers start and the first definite
  answer wins; the rest are killed. SAT moves on to k+1. UNSAT or the wall cap stops the run.
  Results are in `runs/drive_n<n>.jsonl`.
  - Default racers from n = 65 on: kissat `--sat` seed 0 (S1+S2), kissat `--sat` seed 1 (S1 only),
    kissat `--unsat` seed 2 (S1+S2), and CaDiCaL seed 0 (S1+S2) writing a DRAT proof.
  - n = 43 ran with three default kissat seeds plus CaDiCaL.
  - n = 54 and 60 ran with kissat sat/sat/unsat (all S1+S2) plus CaDiCaL.
  - The S1-only racer was added after the CYC/C0 agent reported faster SAT finds without lex
    breaking.
- **First pass** (`src/firstpass.sh`, `src/firstpass2.sh`): 25 min wall per n.
  - For n = 60 and 92 the explicit k = n/4 attempt came first, capped at half of the 25 min.
  - k_start was CONSTR's best + 1 for n = 43, 54, 60 (CONSTR has certificates for 10, 12, 13).
  - For n = 65..97, ⌊n/4⌋ − 2 (14, 16, 19, 21, 22) is already above the frontier, so k_start was
    set lower (13, 14, 16, 17, 17) to obtain a certificate quickly, then climbed. CONSTR's
    n = 97 certificate has k = 16.
- **Second pass** (`src/phase2.sh`): 08:41–09:55 UTC, the multiples of 4 only, two racers each
  (CaDiCaL seed 1 and kissat `--sat` seed 7, both S1 only).
  - n = 60 at k = 14 and n = 92 at k = 19; for n = 92 the run climbs on if it gets SAT.
- **UNSAT proofs.** No UNSAT was reached for any of the 8 n, so there is no proof to check. The
  DRAT pipeline was exercised on validation instances (`runs/val/drat.jsonl`):

| n | k | CaDiCaL | proof size | drat-trim |
|---|---|---|---|---|
| 28 | 8 | UNSAT 0.7 s | 1.1 MB | VERIFIED (0.9 s) |
| 32 | 9 | UNSAT 3.1 s | 5.7 MB | VERIFIED (5.5 s) |
| 36 | 10 | UNSAT 39.4 s | 59 MB | VERIFIED (97 s) |

## 6. Where things are

| path | content |
|---|---|
| `src/cycenc.c` | DIMACS encoder (build: `gcc -O2 -o bin/cycenc src/cycenc.c`) |
| `src/check4.py` | independent explicit 4-cycle checker for (D, g) |
| `src/cycrun.py`, `src/drive.py` | single query / per-n race driver |
| `src/firstpass.sh`, `src/firstpass2.sh`, `src/phase2.sh` | the exact schedules that were run |
| `src/validate.sh`, `src/validate2.sh`, `src/valsummary.py`, `src/count.py` | validation |
| `src/collect.py` | builds `table.tsv`, `solutions.json`, `certs.json` (re-verifies each) |
| `src/cycanneal.c` | annealer (written, smoke-tested only; SAT was faster, not used for results) |
| `runs/` | all raw JSON-lines logs |
| `table.tsv`, `solutions.json`, `certs.json` | results |

Binaries go in `bin/`, which is git-ignored. Solver paths are hard-coded in `src/cycrun.py`
(`/opt/solvers/...`).

**Reproducing a race:** `python3 src/drive.py <n> <k_start> <cap_secs> [--also K]`, with kissat,
cadical and drat-trim built at `/opt/solvers/{kissat/build/kissat,cadical/build/cadical,drat-trim/drat-trim}`.

## 7. Surprises and next steps

- **Table error in CYC.md.** CYC.md lists k_max = 4 for all of n = 14–17, but CONSTR's own data
  (`cyclic_family_status.json`: n = 14 has "unsat": 4) and this run both give **k_max(14) = 3**.
  This is a transcription error in the task table, not a disagreement with CONSTR.
- **n/4 stops being reached.** k = n/4 was not reached at n = 60 (15) or n = 92 (23). Both are
  UNKNOWN, not UNSAT. The best k found is 13 at n = 60 (0.217 n) and 18 at n = 92 (0.196 n).
- **k/n falls.** The best ratio k/n drops from 0.233 at n = 43 to about 0.196 at n = 86..97.
  Neighbouring agents see the same trend, e.g. CYC/C0 has 0.190 at n = 79 and 0.189 at n = 90.
  These are lower bounds only, but the decline is consistent with k_max(n) = o(n) for this family.
- **Hardness.** The SAT/UNSAT frontier is hard from about n = 43 on: 4 cores × 25 min decided
  none of k_lo + 1.
  - Instances below the frontier are trivial: seconds, mostly found by CaDiCaL.
  - Instances at the frontier time out with every configuration.
- **Next steps:**
  - Give the n = 43, k = 11 instance (the smallest open one) hours with kissat `--unsat` + DRAT.
    k_max(40) = 10 needed 444 s for C0, and k_max(39) = 9 needed 518 s for C2.
  - Use cube-and-conquer on p (split on the presence of the first few orbits) to shard the
    UNSAT proofs across agents.
  - Search structured g (e.g. g(d) = a·d² + b·d) to get fast lower bounds for n ≥ 100.
