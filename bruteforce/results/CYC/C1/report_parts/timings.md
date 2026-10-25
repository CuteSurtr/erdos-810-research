## Timings (wall clock, 4 cores)

| step | wall |
|---|---|
| validation n = 13..36 (76 runs, 4 parallel) | about 12 min; slowest single run 68 s with sym 0 |
| n = 38: SAT k = 9 in 0.2 s; UNSAT k = 10 in 121 / 148 / 170 s (cadical --sat, kissat, cadical + LRAT); LRAT check 11 s | 3 min |
| n = 44: SAT k = 10 in 0.5 s; k = 11 unknown after a 25 min portfolio, then the cube phase (below) | 25 min + cubes |
| n = 49: SAT k = 11 in 0.4 s; k = 12 portfolio ran its full 25 min (outcome log lost, not SAT) | 25 min |
| n = 59: SAT k = 13 in about 18 s; k = 14 ran its full 25 min (outcome log lost, not SAT) | 25 min |
| n = 70: SAT k = 15 in about 4.5 min; k = 16 unknown after the remaining 20.6 min | 25 min |
| n = 76: k = 17 unknown after 25 min; k = 16 SAT in 117 s (separate nice'd run) | 25 min |
| n = 81: SAT k = 15, 16 within minutes; k = 17 unknown at the cap | 25 min |
| n = 91: k = 20 unknown after 25 min; k = 17 SAT in 3.5 s and k = 16 SAT in 3.2 s (separate runs); k = 18 run, see table | 25 min + extra |

Encoding time: under 1 s for n ≤ 44, 7 s for n = 91.
