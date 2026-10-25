### Timings

- **Encoding.** About 0.4M keys and 10.4M clauses at n = 95, encoded in about 6 s. CNFs range from
  6 MB (n = 42) to about 200 MB (n = 95).
- **Validation.** sym-2 UNSAT at k_max+1 takes 0.0–3.5 s for n ≤ 32 and 31.5 s at n = 36. sym 0
  is 5–40 s by n = 22–25. The DRAT proofs for all 23 validation UNSATs check in at most 65 s each.
- **First pass.** 25 min wall per n with 4 parallel kissat jobs, 05:19–08:40 UTC. New SAT answers
  came either in seconds to about a minute (53: k = 13 in 36 s; 63: k = 13 in 8 s; 85: k = 17 in
  61 s; 95: k = 18 in 8 s) or late (56: k = 13 after 1092 s). No k above the table's k_lo was
  decided either way within the cap at any n.
- **Second pass.** 08:40–09:58 UTC: n = 42, k = 11: CaDiCaL proved it UNSAT in 1918 s with a 2.4 GB binary DRAT proof, and drat-trim timed out after 3001 s. kissat `--unsat` (seed 1) independently returned UNSAT after 3924 s on the same CNF. n = 56, k = 14: two kissat sym-1 runs (default with seed 4, `--sat` with seed 3) ran 4677 s each with no answer. The "solver seconds" column of the results table sums wall time over all jobs for that n.

## 5. Where the code lives (`bruteforce/results/CYC/C4/`)

| file | purpose |
|---|---|
| `src/cycenc.c` | DIMACS encoder (`gcc -O2 -o src/cycenc src/cycenc.c`; binary git-ignored) |
| `src/check.py` | deliberately simple explicit 4-cycle checker |
| `src/run.py` | encode (cached), solve with kissat/CaDiCaL, decode and check; one JSON line out |
| `src/drive.py` | per-n 4-job driver (section 4) |
| `src/prove.sh` | CaDiCaL + DRAT, then drat-trim |
| `src/brute_small.py`, `src/count.py`, `src/test_action.py` | brute force, projected model counts, multiplier-action test |
| `src/validate.sh`, `src/validate2.sh` | validation runs, producing `validation.jsonl` |
| `src/master*.sh`, `src/pass2.sh` | first- and second-pass schedules |
| `src/collect.py`, `src/make_report.py` | `table.tsv`, `solutions.json`, `certs.json` and `REPORT.md` |
| `runs/`, `runs_drive<n>.log` | raw per-job records (JSON lines) and driver logs |
| `validation.jsonl`, `drat_validation.jsonl`, `drat.jsonl` | validation solver runs and proof checks |

Solver binaries were built from source in the scratchpad: kissat 4.0.4, CaDiCaL and drat-trim, all
GitHub master. To rebuild, clone them and point `SATBIN` (used by `run.py`) at the folder that
contains them.

## 6. Surprises and next steps

1. **n = 14 in the task table.** k_max(14) = 3, not 4 (see the validation section). This agrees with
   CONSTR's raw data, so it is not a discrepancy with CONSTR.
2. **New lower bounds for M(n).** The family alone now gives M(53) ≥ 689, M(56) ≥ 728 and
   M(63) ≥ 819. CONSTR's best for these n was 636, 672 and 812. For n = 74, 85, 88 and 95 CONSTR had
   no value; here M(74) ≥ 1110, M(85) ≥ 1445, M(88) ≥ 1496 and M(95) ≥ 1710.
3. **k = n/4 for multiples of 4.** At n = 56 the best is 13 = n/4 − 1. At n = 88 it is 17 = n/4 − 5;
   k = 22 got 25 min of `--sat` with no answer. Neither case is decided. The proved pattern
   k_max = n/4 (n = 28, 32, 36, and n = 40 from CYC/C0) is therefore unconfirmed beyond 40 in my
   rows.
4. **k/n is drifting down.** The best k/n falls from 0.245 (53) to 0.19 (95), but these are lower
   bounds from 25-min runs, so the drift is at least partly an effort artefact. Note how quickly
   k = 17 at 85 and k = 18 at 95 were found, against how hard k = 14 at 56 has been.
5. **Lost logs, and a lesson for other agents.** `git pull --rebase` replaces every tracked file in
   the results folder with a new inode. A driver that already has a results file open for append
   keeps writing to the deleted inode, and the data vanish. This happened to the first-pass records
   for n = 42, 63, 74, 85, 88 and 95 (the SAT models for 85, 88 and 95 were regenerated
   deterministically). The pass-2 jobs were rescued with `tail -f /proc/<pid>/fd/1`. Fix: keep live
   logs outside the repository, or untracked, and copy them in before committing.
6. **Lex-leader hurts SAT-finding.** At larger n the lex-leader hurts finding SAT models more
   than it helps (as other agents also found). Use sym 1 for SAT jobs and sym 2 for UNSAT jobs.

**Next steps (sharding plan).**
- **Check the n = 42 proof.** Re-run `src/prove.sh 42 11 3600 20000` (about 32 min to solve, then drat-trim with no 50-min cap), or use CaDiCaL `--lrat` with `lrat-check`, which is usually much faster to check. That would turn k_max(42) = 10 into a DRAT-verified result.
- **UNSAT at n ≥ 42.** This is out of reach for plain CDCL in 25 min: the sym-2 UNSAT time roughly
  doubles every 1–2 steps of n (2.4 s at n = 32, 31.5 s at 36, about 444 s at 40 per CYC/C0, and
  1918 s at 42 with CaDiCaL). A cube-and-conquer split on the presence vector (p_1, …, p_m) with
  m ≈ 6–8 would parallelise it, and the lex-leader already kills most cubes with p_1 = 0. Command
  per cube: `cycenc 42 11 2 > base.cnf`, append the cube's unit clauses, then
  `cadical --binary=true -t T cube.cnf cube.drat && drat-trim cube.cnf cube.drat`. The 2^m sign
  patterns cover all cases, so the cubes' UNSATs together prove the whole.
- **SAT at k_lo+1.** Run sym-1 `kissat --sat` with many seeds (each run is cheap), or seed an
  annealer from the current best (D, g) by adding one orbit.
