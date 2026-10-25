## Validation (n = 13..30, 32, 36)

All runs use CaDiCaL 1.7.3 with a 900 s cap (`logs/validation.jsonl`). sym = 3 means translation fix plus lex-leader; sym = 0 means no symmetry breaking. Every SAT model was re-checked by `src/check.py`.

**Discrepancy note.** The compressed table in `tasks/CYC.md` lists "14–17: 4". CONSTR's own data says k_max(14) = 3: both `cyclic_family_status.json` (first UNSAT at k = 4) and the full table in `CONSTR/REPORT.md` (§ k_max). My results agree with CONSTR's data for every n:

- k = 4 is UNSAT for n = 14 with and without symmetry breaking, and with CONSTR's own `cycsat.py`.
- An exhaustive brute force (`src/brute14.py`) finds 0 valid colourings among all 41160 four-orbit candidates with g(min D) = 0.

So this is a transcription slip in the task file, not a disagreement with CONSTR.

| n | k_max (CONSTR) | SAT at k_max (sym 3) | UNSAT at k_max+1 (sym 3) | sym 0 agrees |
|---|---|---|---|---|
| 13 | 3 | ✓ 0.0 s | ✓ 0.0 s | ✓ |
| 14 | 3 | ✓ 0.0 s | ✓ 0.0 s | ✓ (+ brute force) |
| 15 | 4 | ✓ | ✓ 0.0 s | ✓ |
| 16 | 4 | ✓ | ✓ 0.0 s | ✓ |
| 17 | 4 | ✓ | ✓ 0.0 s | ✓ (UNSAT 0.2 s) |
| 18 | 5 | ✓ | ✓ 0.0 s | ✓ |
| 19 | 5 | ✓ | ✓ 0.0 s | ✓ (0.3 s) |
| 20 | 5 | ✓ | ✓ 0.0 s | ✓ (0.5 s) |
| 21 | 6 | ✓ | ✓ 0.0 s | ✓ (0.4 s) |
| 22 | 5 | ✓ | ✓ 0.0 s | ✓ (3.4 s) |
| 23 | 6 | ✓ | ✓ 0.0 s | ✓ (4.7 s) |
| 24 | 6 | ✓ | ✓ 0.1 s | ✓ (5.2 s) |
| 25 | 6 | ✓ | ✓ 0.1 s | ✓ (39.4 s) |
| 26 | 6 | ✓ | ✓ 0.4 s | ✓ (54.5 s) |
| 27 | 7 | ✓ | ✓ 0.2 s | ✓ (67.8 s) |
| 28 | 7 | ✓ | ✓ 0.4 s | ✓ (53.2 s) |
| 29 | 7 | ✓ | ✓ 0.7 s | SAT ✓; UNSAT side SEE_29 |
| 30 | 7 | ✓ | ✓ 3.1 s | SAT ✓; UNSAT side SEE_30 |
| 32 | 8 | ✓ 0.1 s | ✓ 1.9 s | – |
| 36 | 9 | ✓ 3.1 s | ✓ 24.9 s | – |

Symmetry breaking speeds up the UNSAT side by 100× or more at n = 25..30.
