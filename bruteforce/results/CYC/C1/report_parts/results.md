**Labels.**

- *proved*: SAT certificate re-verified, plus UNSAT at k+1 with an LRAT proof checked by `src/lratcheck`.
- *certificate-verified*: lower bound only.
- *unfinished*: the next k was neither found SAT nor proved UNSAT.

These are optima of the cyclic family only, not values of M(n). Each lower bound gives M(n) ≥ n·k.

**Headline.**

- **k_max(38) = 9 is proved.** k = 10 is UNSAT, with a 1.19 GB LRAT proof checked by my checker. So CONSTR's 342-edge cyclic example is optimal within the family.
- **n = 44: k = n/4 = 11 is still undecided.** It is the first multiple of 4 above 36 where k = n/4 is in doubt. 25 min of portfolio solving left it open. A cube split then closed 6 of the 9 cubes as UNSAT (see below). The 3 remaining cubes all have orbits 1 and 2 present.
- **Observed k/n:** 0.237 (38), 0.227 (44), 0.224 (49), 0.220 (59), 0.214 (70), 0.211 (76), 0.198 (81), 0.198 (91). These are lower bounds, and the decline beyond n = 44 partly reflects the 25-min cap.
- **Multiples of 4:** k = n/4 is SAT at n = 28, 32, 36 (validation) and at n = 40 (CONSTR). It is undecided at n = 44 (11) and n = 76 (19). At n = 76 even k = 17 was unresolved after 25 min.
- **Task-file table:** k_max(14) = 3, not the 4 printed in `tasks/CYC.md`. See the validation section.

**Data-loss note.** The k = 12 result at n = 49 and the k = 14 result at n = 59 were lost. A `git pull --rebase` during a checkpoint replaced the log files that the running driver held open. This was fixed afterwards: the driver now reopens its log for every write.

- The CNF for k + 1 was never generated in either case, so neither k was found SAT.
- At n = 59 the proof job's LRAT file kept growing until the 25-min cap (last write 06:48), so that job did not finish.
- Both are therefore marked *unfinished*.
- The same mechanism hit two cube logs. One result was recovered through `/proc/<pid>/fd`, and the other cube was re-run (`logs/n44_cubes_b.jsonl`, `n44_cubes_c.jsonl`).

**Summary.** The final per-n table (`table.tsv`) follows.
