# CYC/C5: cyclic orbit family, n = 43, 54, 60, 65, 75, 86, 92, 97

## 1. Placement

```
$ uname -a; nproc; free -g
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

All computation ran in this 4-core cloud container, 05:13–10:00 UTC on 2026-10-25.
Solvers were built from GitHub sources: kissat (arminbiere/kissat master), CaDiCaL
(arminbiere/cadical master) and drat-trim (marijnheule/drat-trim). python-sat came from pip and
was used only for solution counting.

