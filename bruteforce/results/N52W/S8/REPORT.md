# N52W / S8: (1,2,¬3,4,2:G) for G = 0..51. **Not run (blocked)**

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          14           0           0          15
Swap:              0           0           0
```

Run started 2026-10-26 13:03 UTC. A second run (routine re-fire) started 13:09 UTC and a third at 14:30 UTC, each on a machine with the same placement output, and both were blocked the same way (see §3).

## 2. Results

| root | status |
|---|---|
| `1,2,-3,4,2:G`, G = 0..51 | **unfinished**: all 52 OPEN |

No leaves were run, so there was no SAT leaf. The only verified leaves under these roots are PUSH2's 9 sample
leaves in `leaves_n52_sample.jsonl`. `logs/leaves_new.jsonl` is empty.

## 3. What happened

- `src/` is copied unchanged from `PUSH2/N52/src/`. `cycenc.c` was compiled with `gcc -O2`, and the binary is not committed.
  `cycenc 52 13 3` has sha256 `f0bba6f2545c2658065ae1a75bbcdd0bf8c0192d8532bb89a13c716a148620c6`, which matches the task.
- The CaDiCaL (c60730422e75, VERSION 3.0.1) and cake_lpr (a36874a8b750) sources were cloned into `/tmp/claude-0/b/`.
- **Blocker.** The session's auto-mode permission classifier denied building them (`./configure && make`
  for CaDiCaL, `make` for cake_lpr), with the reason "Code from External". This is the same denial that S2 reports.
  Without these two tools, `leaf.py` cannot produce cake_lpr-verified LRAT, so no leaf would count. I did not try to get around the denial.
  S3 and S7 did build the tools in their sessions.
- **Second attempt (13:09 UTC).** A re-fired routine re-cloned and checked out both repositories (CaDiCaL `c6073042`, VERSION 3.0.1;
  cake_lpr `a36874a`). The single build command (`./configure && make -j4` for CaDiCaL, then `make cake_lpr`) was again denied
  by the auto-mode classifier with "Code from External". I did not retry it in another form. The routine forbids other external code, so
  python-sat was not an option, and a self-written checker would not meet the cake_lpr requirement. So nothing ran this time either.
  To unblock, allow building and running these two pinned tools in the session's permission settings, or let S7 (or another shard that has
  the tools) run these roots.
- **Third attempt (14:30 UTC).** The routine prompt now explicitly authorizes building and running the two pinned tools. Both repositories
  were cloned and checked out (CaDiCaL `c6073042`, VERSION 3.0.1; cake_lpr `a36874a`). The build command
  (`./configure && make -j4`, then `make cake_lpr`) was denied once more by the auto-mode classifier with "Code from External".
  The written authorization in the routine prompt does not reach the session's permission classifier. I did not retry the build in another
  form, because that would be working around the denial. The fix has to be in the session's permission settings (for example, an allow rule
  for building in `/tmp/claude-0/b/`), or a different shard has to run these roots.
- At 14:30 UTC no shard's `leaves_new.jsonl` contained any `(1,2,¬3,4)` leaf, so S7 had not started helping S8 yet.

## 4. Closure check (current state)

`logs/closecheck.txt`, from
`python3 ../common/closecheck.py 52 13 c_52_13_3.cnf --roots <52 roots> --logs ../../PUSH2/N52/logs/leaves_n52*.jsonl logs/leaves_new.jsonl`:

```
n=52 k=13: verified leaves used 9, internal 26, open branches 1369, unverified UNSAT lines 0, SAT lines 0
```

Every root is OPEN.

## 5. Remaining cost and how to finish

The task's estimate is unchanged: about 22 000 core-s, or about 1.5 h on 4 cores. PUSH2's (1,2,¬3,4) leaves averaged 8.3 s each,
and that root has about 2695 leaves. To finish, use a session where building the tools is allowed and run:

```
cd bruteforce/results/N52W/S8
cat ../../PUSH2/N52/logs/leaves_n52*.jsonl > /tmp/claude-0/logs/s.jsonl
LEAFLOG=/tmp/claude-0/logs/s.jsonl python3 src/tree.py 52 13 400 4 $(cat logs/roots.txt)
```

Alternatively, S7, which helps S8 in reverse order if it finishes before 16:00 UTC, can cover these roots.

## 6. Files

- `src/`: PUSH2's scripts, unchanged.
- `logs/roots.txt`: this shard's 52 roots, in task order.
- `logs/closecheck.txt`: the closure check output.
- `logs/leaves_new.jsonl`: empty.
