
## 5. Where things are

- `src/cycenc.c`: DIMACS encoder (the binary `src/cycenc` is git-ignored; build with
  `gcc -O2 -o src/cycenc src/cycenc.c`).
- `src/check4.py`: deliberately simple explicit checker (walk enumeration of 4-cycles).
  `../../CONSTR/check.py`, which uses diagonal enumeration, was also run on `certs.json`:
  see `logs/constr_check.txt` and `logs/check4.txt`. Both give identical 4-cycle counts.
- `src/run.py`: portfolio driver with DRAT checking. `src/drive.py`: per-n first pass.
  `src/pass1.sh`, `src/pass1b.sh`, `src/pass2.sh`: the exact schedules that were run.
- `src/validate.sh`, `src/brute.py`, `src/count.py`: validation, the independent brute force,
  and solution counts.
- `src/cycls.c`: a simple annealer over (D, g). It was too weak to help (it failed to find
  k = 10 at n = 41 in 60 CPU-s), so it was not used for any result.
- `logs/n<n>.jsonl`: every solver call for my n (result, winner, seconds, model, DRAT verdict).
  `logs/validate.jsonl`: every validation call. `logs/drat_*.txt`: drat-trim output.
- `table.tsv`, `solutions.json` ({n: [[d, g], …]}) and `certs.json` ({n: [[u, v, c], …]}).
- Tools: kissat and CaDiCaL (latest master of arminbiere/kissat and arminbiere/cadical, cloned
  2026-10-25) and drat-trim (marijnheule/drat-trim), all built from source in the scratchpad.

## 6. Surprises and next steps

- **Task table typo at n = 14.** The CYC task table says k_max(14) = 4. CONSTR's own record
  (`runs/cycsat/n14.jsonl`: k = 4 UNSAT; `cyclic_family_status.json`: unsat = 4) and my runs
  (DRAT-verified UNSAT at k = 4, plus brute force) all give **k_max(14) = 3**. Every other
  validated n agrees with the table.
- **The ratio k_max/n declines.** Its proved values are exactly 1/4 at n = 28, 32, 36, 40
  (C0), but only 0.244 at n = 41 (proved). The best found values are 0.235 at n = 51–52,
  0.21 at n = 62–84 and 0.19 at n = 94. Beyond about n = 60 these are only lower bounds, so the
  decline could partly reflect SAT difficulty rather than the true optimum.
- **New general lower bounds for M(n).** The cyclic certificates here give M(73) ≥ 1095 and
  M(83) ≥ 1411. These beat CONSTR's previous best (1057 and 1325, from seeded local search),
  and both certificates are re-checked by two independent checkers. Also M(51) ≥ 612
  (CONSTR: 561), M(84) ≥ 1428 and M(94) ≥ 1692.
- **Symmetry breaking.** It is essential for UNSAT: at n = 29, 30, k_max + 1 is UNSAT in
  1–4 s with full breaking, 13–21 s with translation only, and > 600 s with none. For SAT at
  large n the picture is mixed:
  - full breaking found 83/k = 17 and 94/k = 18;
  - the translation-only CNF found 84/k = 17;
  - this agrees with C0's observation that lex constraints can slow SAT finding.
- **Odd behaviour at n = 94.** k = 19 was UNKNOWN after 25 min, yet k = 18 was SAT in 25 s.
  So k = 19 at n = 94 (and k = 18 at n = 83, 84) are good targets for longer runs.
- **Next steps.**
  - Cube-and-conquer on the presence vector for the UNSAT side, e.g. n = 51 k = 13 and
    n = 52 k = 13. With prime n, the lex-leader already forces orbit 1, so cubes could split
    on p_2..p_6.
  - Longer SAT runs at k = k_lo + 1 for n ≥ 62, with more seeds and translation-only CNFs.
  - **Exact sharding plan.** For each open (n, k) run `python3 src/run.py n k --proof --jobs 4
    --timeout T` (one instance per 4-core machine). The open instances are:
    - n = 51, 52 at k = 13;
    - n = 62 at k = 14;
    - n = 73 at k = 16;
    - n = 83, 84 at k = 18;
    - n = 94 at k = 19;
    - n = 84 at k = 21.
    Measured so far:
    - 25 min with 4 solvers on each of these gave no answer;
    - n = 52 k = 13 had a further 70 min (see the table);
    - n = 41 k = 11 needed 11 min to UNSAT, plus 44 min for drat-trim on a 474 MB proof.
