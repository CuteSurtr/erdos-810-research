## Validation (n = 13..30, 32, 36)

Expected values come from CONSTR's `cyclic_family_status.json`, where k_max = (first UNSAT k) − 1.
For each n we ran SAT at k_max and UNSAT at k_max + 1, with symmetry breaking (sym 2) and without it (sym 0).
Every SAT model was decoded and re-checked by `src/check.py`. That checker builds the explicit graph on Z_n
and enumerates every 4-cycle a-b-c-d through common neighbours of each vertex pair. It also checks colours
in 0..n−1 and n·|D| distinct edges. sym-2 UNSAT runs used CaDiCaL with a DRAT proof checked by drat-trim.
Raw lines are in `validation.jsonl`.

**Discrepancy with the task file, not with CONSTR.** The task file's summary table says k_max = 4 for n = 14.
CONSTR's own status JSON says k = 4 is UNSAT at n = 14, so k_max(14) = 3. We get k_max(14) = 3:
- k = 4 is UNSAT with and without breaking;
- an independent exhaustive search without SAT (`src/brute_small.py`) also finds no configuration.

That search enumerates every 4-subset D and every g with g(min D) = 0, pruning by the simple checker.
Pruning is sound because removing an orbit removes edges, and validity is closed under removing edges.
Every other value agrees with both CONSTR and the task table. The task table's "14–17: 4" should read
"14: 3, 15–17: 4".

`brute_small.py` also confirms UNSAT at k_max + 1 for n = 13..21 by direct enumeration (`brute_small.txt`).
