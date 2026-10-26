# N52W / S2: (1,2,3,4,2:G) for G = 27..36. **Not run (blocked)**

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

Run started 2026-10-26 13:00 UTC. Re-run (second attempt) started 13:09 UTC; same placement.

## 2. Results

| root | status |
|---|---|
| `1,2,3,4,2:G`, G = 27..36 | **unfinished**: OPEN. No leaves were run, and no verified leaves exist for these roots in PUSH2's logs |

No SAT leaf was found, because no leaf ran.

## 3. What happened

- `src/` is copied unchanged from `PUSH2/N52/src/`. `cycenc.c` compiled with `gcc -O2`.
  `cycenc 52 13 3` gives sha256 `f0bba6f2545c2658065ae1a75bbcdd0bf8c0192d8532bb89a13c716a148620c6`, which
  matches the task (18741 vars, 846389 clauses).
- The cadical (c60730422e75, VERSION 3.0.1) and cake_lpr (a36874a8b750) sources were cloned into `/tmp/claude-0/b/`.
- **Blocker.** The session's auto-mode permission classifier denied building them (`./configure && make` for
  CaDiCaL), with the reason "Code from External". Without CaDiCaL and cake_lpr, `leaf.py` cannot produce the
  cake_lpr-verified LRAT that the closure check requires. README rule 5's fallback is pip `python-sat`, but it
  provides neither CaDiCaL 3.0.1 nor cake_lpr, so its leaves would not count. I did not try to get around the denial.
- **Second attempt (13:09 UTC).** The routine prompt explicitly authorized building both tools at the pinned commits. Both clones were checked out (cadical c6073042, VERSION 3.0.1; cake_lpr a36874a). The combined `./configure && make -j4` / `make cake_lpr` command was denied again by the classifier ("Code from External"). I did not retry it in another form. No leaves ran. S3 and S7 did build the tools in their sessions, so the block depends on the session, not the task.
- So the closure check was not run. All 10 roots are OPEN, because none of their leaves exist in any log.

## 4. Remaining cost and how to finish

The estimate is unchanged from the task file: about 30 000 core-s (about 2.1 h on 4 cores). These are the
mirror g(2) children of (1,2,3,4). The PUSH2 representatives 2:5..2:16 cost 1800 to 4500 s each.

To finish, use a session where building the two tools is permitted, and follow `tasks/N52W.md` unchanged:

```
cd bruteforce/results/N52W/S2
cat ../../PUSH2/N52/logs/leaves_n52*.jsonl > /tmp/claude-0/logs/s.jsonl
LEAFLOG=/tmp/claude-0/logs/s.jsonl python3 src/tree.py 52 13 400 4 \
  1,2,3,4,2:27 1,2,3,4,2:28 1,2,3,4,2:29 1,2,3,4,2:30 1,2,3,4,2:31 \
  1,2,3,4,2:32 1,2,3,4,2:33 1,2,3,4,2:34 1,2,3,4,2:35 1,2,3,4,2:36
```

Alternatively, S3 (which helps S2 in reverse order if it finishes early) can cover these roots.

## 5. Files

`src/`: PUSH2's scripts, unchanged (no binaries committed).
