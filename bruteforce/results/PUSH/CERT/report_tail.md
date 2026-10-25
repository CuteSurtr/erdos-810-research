
"NO VERDICT" rows are two cake_lpr runs killed by the memory cgroup (OOM). Four checks of about 4.2 GB
each ran at once. Both cubes were re-solved and re-checked (the `s VERIFIED UNSAT` row under each).
After that, `prove.sh` allows at most two cake_lpr runs at a time. Tags `n47C1_cube_*` are the
optional second sweep with C1's encoder (§6).

### 4.6 Timeline and abandoned attempts

- **drat-trim on large proofs is too slow here.**
  - n = 38: 199 MB DRAT, 551 s check. n = 35: 92 MB, 279 s.
  - Three n = 47 cubes solved by kissat (0.9–1.1 GB DRAT each) were still not checked after 60–105
    min of drat-trim. I killed them and redid those cubes with LRAT.
  - The n = 42 DRAT (2.51 GB, CaDiCaL 1.7.3, 35 min solve, sha256 of the CNF as in the
    n42k11_C4s2_lrat row) ran 81 min in drat-trim. I killed it once the LRAT proof of the same CNF
    had been verified.
  - None of these runs gave a verdict; they are not counted anywhere.
- **LRAT + cake_lpr is the right pipeline.** CaDiCaL 3.0.1 solves these instances about as fast as
  kissat 4.0.4. Its binary LRAT is 2–3× larger than DRAT. cake_lpr checks it in about 20–35 % of
  the solve time (for example 6.4 GB in 678 s).
- **Worker incident.** The first two queue workers were started with relative paths. A
  `git pull --rebase` recreated the results directory under them, so they drained the n = 47 queue
  without running anything. No results were affected. I rebuilt the queue, and `worker.sh` now
  uses absolute paths.

## 5. Code and files (`bruteforce/results/PUSH/CERT/`)

| file | purpose |
|---|---|
| `src/cycenc_C0.c`, `src/cycenc_C1.c`, `src/cycenc_C4.c` | verbatim copies of the encoders of CYC/C0, C1 and C4 (sha256 `82d0019f…`, `866a463c…`, `e0ee15fa…`) |
| `src/prove.sh` | solver with proof, then checker, then one JSON line to `logs/proofs.jsonl` |
| `src/worker.sh` | flock queue worker running `prove.sh` |
| `src/mkcube.py` | base CNF + cube unit clauses on p_d = Hn + d |
| `src/cover.py` | coverage check of a presence-bit cube split against verified proofs |
| `src/satrun.py` | SAT search with decoding and re-check (used for n = 35, k = 8, 9) |
| `src/check4.py`, `src/check_certs.py` | simple 4-cycle checkers, from (D, g) and from the explicit edge list |
| `src/tables.py` | tables of §4.5 and `n47_tree.json` |
| `logs/proofs.jsonl` | one line per proof run: CNF sha256, header, solver and version, result, times, proof bytes, checker, verdict line |
| `logs/dt_<tag>.txt` | tail of each checker's output |
| `logs/n35.jsonl` | n = 35 SAT runs (k = 8 SAT in 1 s; k = 9 `--sat` 600 s UNKNOWN) |
| `logs/cover47.txt`, `logs/check_certs.txt`, `logs/cubes47_queue.txt` | coverage output, certificate checks, and the C0 cube list (with C0's kissat times) |
| `certs.json`, `solutions.json`, `n47_tree.json` | certificates and the n = 47 cube tree |

Reproduce one result, for example n = 42:
```
gcc -O2 -o cycenc_C4 src/cycenc_C4.c && ./cycenc_C4 42 11 2 > n42.cnf      # sha256 60a35d25…
cadical-3.0.1 --lrat --binary=true n42.cnf n42.lrat                         # 2392 s, 6.4 GB
cake_lpr n42.cnf n42.lrat                                                   # s VERIFIED UNSAT, 678 s
```
n = 47: `./cycenc_C0 47 12 1 1 > base.cnf`. For each cube in `logs/cubes47_queue.txt`, run
`python3 src/mkcube.py base.cnf 47 <cube> c.cnf`, then the same two commands. Then run
`python3 src/cover.py logs/proofs.jsonl n47k12_cube_`.

## 6. Surprises and next steps

- **k_max(35) = 8.** n = 35 sits between k_max(34) = 8 and k_max(36) = 9 = n/4. So the step to 9
  happens exactly at the multiple of 4.
- **Independence from the multiplier argument.** For n = 35 (k = 9) and n = 38 (k = 10), the UNSAT
  proof also goes through with translation-only breaking (C1 sym 1, no lex-leader), checked by
  cake_lpr. Translation is a trivially sound symmetry. So these two results do not depend on the
  lex-leader soundness argument at all. For n = 42 and n = 47 the proofs use the lex-leader.
- **Independence from one encoder.** n = 35 and n = 38 are UNSAT under both the C1 and C4 encoders.
  n = 42 is UNSAT under both C4 (the main proof) and C1. Both runs used LRAT checked by cake_lpr.
- **n = 47 under a second encoder (optional).** At the deadline, SWEEP_STATUS.
- **Suggestion.** Future PUSH and CYC agents should use CaDiCaL ≥ 2 with binary LRAT and cake_lpr
  instead of DRAT and drat-trim. In this container, drat-trim did not finish 1 GB proofs in 100 min,
  while cake_lpr checked 6–7 GB in 11–13 min. Limit concurrent cake_lpr runs to (memory limit)/4.3 GB.
