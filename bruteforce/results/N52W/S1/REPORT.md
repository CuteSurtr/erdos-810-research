# N52W / S1: (1,2,3,4,2:G) for G = 17..26. **All 10 roots CLOSED**

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

Run started 2026-10-26 13:21 UTC (scheduled 12:55 UTC). Tree ran 13:23 to 15:41 UTC on 4 workers.

## 2. Results

| root | status |
|---|---|
| `1,2,3,4,2:G`, G = 17..26 (10 roots) | **proved** UNSAT: all CLOSED by `closecheck.py`, every leaf cake_lpr `s VERIFIED UNSAT`, no symmetry lemma |

No SAT leaf, so there is no `certs.json` / `solutions.json`. No UNKNOWN leaves, so no re-splits: every root was
pre-split on g(3) into 52 leaves and every leaf finished under the 400 s cap.

## 3. Method and counts

- `src/` copied unchanged from `PUSH2/N52/src/`; `cycenc` built with `gcc -O2` (binary not committed).
  Base CNF `cycenc 52 13 3` sha256 `f0bba6f2545c2658065ae1a75bbcdd0bf8c0192d8532bb89a13c716a148620c6` (matches).
- CaDiCaL 3.0.1 @ c60730422e75 (`./configure && make -j4`) and cake_lpr @ a36874a8b750 (`make cake_lpr` from the
  shipped `cake_lpr.S`), in `/tmp/claude-0/b/`. No other external code.
- LEAFLOG `/tmp/claude-0/logs/s.jsonl`, seeded with the three `PUSH2/N52/logs/leaves_n52*.jsonl` (2003 lines).
  Command: `LEAFLOG=/tmp/claude-0/logs/s.jsonl python3 src/tree.py 52 13 400 4 $(cat logs/roots.txt)`.
- `logs/leaves_new.jsonl` holds the log lines after the seed (`tail -n +2004`).

Own shard: 494 new leaves (2:17 had 26 done in PUSH2), all `UNSAT` with `s VERIFIED UNSAT`.
Solver time 32 840 s (CaDiCaL with streamed LRAT check), max leaf 180.8 s (`1,2,3,4,2:17,3:26`),
LRAT streamed 59.1 GB (largest single proof 288 MB).

| g(2) child | new leaves | solver s | max leaf s | LRAT GB |
|---|---|---|---|---|
| 2:17 | 26 | 2495 | 180.8 | 4.12 |
| 2:18 | 52 | 3451 | 150.4 | 6.29 |
| 2:19 | 52 | 3461 | 159.3 | 6.15 |
| 2:20 | 52 | 3199 | 145.2 | 5.81 |
| 2:21 | 52 | 3180 | 145.0 | 5.85 |
| 2:22 | 52 | 3362 | 133.7 | 5.90 |
| 2:23 | 52 | 3183 | 116.6 | 5.88 |
| 2:24 | 52 | 3156 | 121.3 | 5.73 |
| 2:25 | 52 | 3842 | 147.5 | 6.93 |
| 2:26 | 52 | 3511 | 128.3 | 6.44 |

## 4. Closure check

```
python3 ../common/closecheck.py 52 13 /tmp/claude-0/w/c_52_13_3.cnf --roots $(cat logs/roots.txt) \
  --logs ../../PUSH2/N52/logs/leaves_n52*.jsonl logs/leaves_new.jsonl
```

Exit code 0. Output (`logs/closecheck.txt`):

```
CLOSED 1,2,3,4,2:17
CLOSED 1,2,3,4,2:18
CLOSED 1,2,3,4,2:19
CLOSED 1,2,3,4,2:20
CLOSED 1,2,3,4,2:21
CLOSED 1,2,3,4,2:22
CLOSED 1,2,3,4,2:23
CLOSED 1,2,3,4,2:24
CLOSED 1,2,3,4,2:25
CLOSED 1,2,3,4,2:26
n=52 k=13: verified leaves used 520, internal 10, open branches 0, unverified UNSAT lines 0, SAT lines 0
```

## 5. Helping S2

S1 closed before 16:00, so per the task it helps S2. S2's three attempts were blocked at the tool build and its
`leaves_new.jsonl` is empty. From 15:42 UTC S1 runs S2's roots in reverse order (`logs/help_S2_roots.txt`:
`1,2,3,4,2:G` for G = 36 down to 27) on the same LEAFLOG; those leaves also go to `logs/leaves_new.jsonl`.
Status of the help run: see §6.

## 6. Help run status (S2's roots)

Stopped at 17:31 UTC through `STOP` for wrap-up. 413 new leaves, all `UNSAT` with `s VERIFIED UNSAT`
(plus 10 `PRESPLIT` bookkeeping lines from tree.py). No SAT, no UNKNOWN. Solver time 25 890 s, max leaf 156.9 s
(`1,2,3,4,2:36,3:28`), LRAT 49.7 GB. tree.py did not take the roots strictly in the given order: after
2:36..2:31 it ran 2:27 and then 2:28.

| g(2) child | leaves | solver s | max leaf s | LRAT GB | closecheck |
|---|---|---|---|---|---|
| 2:36 | 52 | 3414 | 156.9 | 6.29 | CLOSED |
| 2:35 | 52 | 3394 | 155.6 | 6.38 | CLOSED |
| 2:34 | 52 | 3195 | 145.0 | 6.08 | CLOSED |
| 2:33 | 52 | 3068 | 138.2 | 5.90 | CLOSED |
| 2:32 | 52 | 3047 | 130.2 | 5.82 | CLOSED |
| 2:31 | 52 | 3027 | 129.0 | 5.91 | CLOSED |
| 2:30 | 0 | | | | OPEN |
| 2:29 | 0 | | | | OPEN |
| 2:28 | 49 | 3405 | 129.1 | 6.84 | OPEN (3:49, 3:50, 3:51 missing) |
| 2:27 | 52 | 3339 | 121.9 | 6.50 | CLOSED |

Closure check for S2's roots (`logs/closecheck_help_S2.txt`, exit code 1):

```
python3 ../common/closecheck.py 52 13 /tmp/claude-0/w/c_52_13_3.cnf --roots $(cat logs/help_S2_roots.txt) \
  --logs ../../PUSH2/N52/logs/leaves_n52*.jsonl logs/leaves_new.jsonl
CLOSED 1,2,3,4,2:36
CLOSED 1,2,3,4,2:35
CLOSED 1,2,3,4,2:34
CLOSED 1,2,3,4,2:33
CLOSED 1,2,3,4,2:32
CLOSED 1,2,3,4,2:31
OPEN   1,2,3,4,2:30
OPEN   1,2,3,4,2:29
OPEN   1,2,3,4,2:28
CLOSED 1,2,3,4,2:27
n=52 k=13: verified leaves used 413, internal 10, open branches 107, unverified UNSAT lines 0, SAT lines 0
```

Re-running the S1 closure check with the full `leaves_new.jsonl` gives the same output as §4.

**Remaining for S2 (unfinished):** 107 leaves: `1,2,3,4,2:28,3:G` for G = 49, 50, 51, and all 52 g(3) leaves
of each of `1,2,3,4,2:29` and `1,2,3,4,2:30`. At the measured ≈ 64 s per leaf this is about 6 900 core-s, roughly
30 min on 4 cores. To finish, seed a LEAFLOG with `PUSH2/N52/logs/leaves_n52*.jsonl` and this folder's
`logs/leaves_new.jsonl`, then run
`LEAFLOG=... python3 src/tree.py 52 13 400 4 1,2,3,4,2:28 1,2,3,4,2:29 1,2,3,4,2:30`; done leaves are skipped.

## 7. Files

| path | content |
|---|---|
| `src/` | PUSH2/N52/src unchanged |
| `logs/roots.txt`, `logs/help_S2_roots.txt` | roots run |
| `logs/leaves_new.jsonl` | all new leaf lines (own shard, then S2 help) |
| `logs/closecheck.txt` | closure check for S1's roots |
| `logs/closecheck_help_S2.txt` | closure check for S2's roots (help run) |
| `logs/tree_stdout.txt`, `logs/tree_help_stdout.txt` | tree.py output |
