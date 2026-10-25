# CYC/C7: cyclic orbit family, n = 46, 57, 67, 68, 78, 89, 99, 100

## 1. Placement

```
$ uname -a; nproc; free -g
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

All computation ran in this cloud container. Solvers: kissat and CaDiCaL built from
`github.com/arminbiere/{kissat,cadical}` (master, shallow clone, 2026-10-25), drat-trim from
`github.com/marijnheule/drat-trim`. No pysat (not needed).
