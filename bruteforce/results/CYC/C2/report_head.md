# CYC/C2: cyclic orbit family, n = 39, 48, 50, 61, 71, 80, 82, 93

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

All computation ran in this cloud container. The solvers were built from source:
- kissat and CaDiCaL from `github.com/arminbiere/{kissat,cadical}` master (Oct 2026);
- drat-trim from `github.com/marijnheule/drat-trim`.

pip `python-sat` was not available, so nothing here uses pysat.

## 2. Results

k = |D| orbits, so |E| = n·k, coloured with n colours. Statuses: *proved* means SAT at k plus UNSAT at
k+1 with a checked DRAT proof. Otherwise the line says what is missing.
