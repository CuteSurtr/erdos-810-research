# N52W / S6: (1,2,3,¬4,2:G) for G = 18..34. **Not run (blocked)**

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          14           0           0          15
Swap:              0           0           0
Mon Oct 26 14:31:02 UTC 2026
```

First run: 2026-10-26 13:16 UTC. Second run (this update): 2026-10-26 14:30 UTC.

## 2. Results

| root | status |
|---|---|
| `1,2,3,-4,2:G`, G = 18..34 (17 roots) | **unfinished**: all OPEN |

No leaves ran, so there are no SAT leaves and no UNKNOWN re-splits. Leaf count 0, solver time 0 s, LRAT volume 0.
`logs/leaves_new.jsonl` is empty.

## 3. What happened

- `src/` is copied unchanged from `PUSH2/N52/src/`. `cycenc` was compiled with `gcc -O2`; the binary is not committed.
  `cycenc 52 13 3` has sha256 `f0bba6f2545c2658065ae1a75bbcdd0bf8c0192d8532bb89a13c716a148620c6`, which matches the task.
- CaDiCaL (`c60730422e75`, VERSION 3.0.1) and cake_lpr (`a36874a8b750`) were cloned and checked out in `/tmp/claude-0/b/`.
- **Blocker.** The session's auto-mode permission classifier denied the build command
  (`./configure && make -j4` for CaDiCaL, then `make cake_lpr`) with "Code from External". S2 and S8 report the same denial.
  **Second run, 14:30 UTC:** the routine prompt explicitly authorized these builds. The tools were re-cloned at the pinned commits (`c6073042`, `a36874a`), but the auto-mode classifier denied `./configure && make -j4` / `make cake_lpr` again with "Code from External". I did not retry it in another form. `cycenc` was rebuilt and its base CNF hash re-confirmed. Without CaDiCaL and cake_lpr, `leaf.py` cannot produce cake_lpr-verified LRAT,
  so no leaf would count toward closure. No other solver or checker was used, because the routine forbids other external code.

## 4. Closure check (current state)

Command (14:3x UTC; it also counts every other shard's `leaves_new.jsonl` in case S5 or anyone else helped):
`python3 ../common/closecheck.py 52 13 c_52_13_3.cnf --roots $(cat logs/roots.txt) --logs ../../PUSH2/N52/logs/leaves_n52*.jsonl ../S*/logs/leaves_new.jsonl`

Output summary (full output in `logs/closecheck.txt`):

```
n=52 k=13: verified leaves used 2, internal 9, open branches 474, unverified UNSAT lines 0, SAT lines 0
```

All 17 roots are OPEN.

## 5. Remaining cost and how to finish

The task's estimate is unchanged at about 27 000 core-s, roughly 2 h on 4 cores. In a session where building the two pinned tools is allowed:

```
cd bruteforce/results/N52W/S6
gcc -O2 -o src/cycenc src/cycenc.c
cat ../../PUSH2/N52/logs/leaves_n52*.jsonl > /tmp/claude-0/logs/s.jsonl
LEAFLOG=/tmp/claude-0/logs/s.jsonl python3 src/tree.py 52 13 400 4 $(cat logs/roots.txt)
```

S3 and S7 did build the tools in their sessions. To unblock this shard, either allow the build in this routine's
permission settings or let a shard that has the tools run these roots.
