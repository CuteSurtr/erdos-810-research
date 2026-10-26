# N52W / S4: (1,2,3,4,2:G) for G = 45..51 and (1,¬2,3,4,3:G) for G = 0..51. **All 59 roots CLOSED**

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          14           0           0          15
Swap:              0           0           0
```

The run started at 2026-10-26 13:15:48 UTC and the shard's tree finished at 15:17 UTC (about 2 h 01 min wall on 4 cores).

## 2. Results

| root | status |
|---|---|
| `1,2,3,4,2:G`, G = 45..51 (7 roots) | **proved** (CLOSED: every leaf UNSAT with a cake_lpr-verified LRAT proof) |
| `1,-2,3,4,3:G`, G = 0..51 (52 roots) | **proved** (CLOSED: every leaf UNSAT with a cake_lpr-verified LRAT proof) |

There was no SAT leaf. No branch relies on the u = −1 mirror lemma: each root fixes one offset, so `tree.py`
pre-splits it on the next present orbit's offset (g(3) for the first group, g(4) for the second) and queues
all 52 children as ordinary children, never as mirror children.

Together with PUSH2's closed cubes and the other shards, this closes the whole (1,¬2,3,4) first-level cube
(all 52 values of g(3)). It also closes the (1,2,3,4) values G = 45..51.

## 3. Leaf statistics (`logs/leaves_new.jsonl`, S4's own shard lines)

| part | verified UNSAT leaves | solver s (CaDiCaL + streamed cake_lpr) | max leaf s | LRAT volume |
|---|---|---|---|---|
| (1,2,3,4,2:45..51) × g(3) | 364 | 12 878 | 166.6 (`1,2,3,4,2:45,3:29`) | 23.14 GB |
| (1,¬2,3,4,3:0..51) × g(4) | 2 695 | 15 273 | 13.1 | 21.23 GB |
| **total** | **3 059** | **28 152** | 166.6 | **44.37 GB** (largest single proof 307.9 MB) |

- Per root, (1,2,3,4): 2:45 = 4384 s, 2:46 = 3998 s, 2:47 = 2434 s, 2:48 = 1658 s, 2:49 = 132 s, 2:50 = 138 s,
  2:51 = 135 s (52 leaves each).
- (1,¬2,3,4): 9 of its 2704 leaves were already verified in PUSH2's `leaves_n52_sample.jsonl`. They were skipped, and
  the other 2695 ran here.
- PRESPLIT lines: 32. The other 27 roots (1,¬2,3,4,3:G for G = 0, 1, 3..27) were already logged as PRESPLIT in
  PUSH2's logs, so they were split straight from the seed.
- UNKNOWN at the 400 s cap: **0**, so there were no re-splits. ERROR lines: 0. Verified UNSAT lines: all of them
  (`check == "s VERIFIED UNSAT"`).
- The task estimate was ≈ 13 000 + 17 000 core-s. The measured times were 12 878 + 15 273 s.

## 4. Closure check

The command is run from `S4/` (`logs/closecheck.txt`). The base CNF is `cycenc 52 13 3` with sha256
`f0bba6f2545c2658065ae1a75bbcdd0bf8c0192d8532bb89a13c716a148620c6`, which matches the task.

```
python3 ../common/closecheck.py 52 13 /tmp/claude-0/w/c_52_13_3.cnf --roots $(cat logs/roots.txt) \
  --logs ../../PUSH2/N52/logs/leaves_n52*.jsonl logs/leaves_new.jsonl
```

```
CLOSED 1,2,3,4,2:45 ... CLOSED 1,2,3,4,2:51, CLOSED 1,-2,3,4,3:0 ... CLOSED 1,-2,3,4,3:51   (59 lines)
n=52 k=13: verified leaves used 3068, internal 59, open branches 0, unverified UNSAT lines 0, SAT lines 0
```

The 3068 verified leaves are S4's own 3059 plus PUSH2's 9 sample leaves.

## 5. Method and tools

- `src/` is copied unchanged from `PUSH2/N52/src/`. `cycenc` was built with `gcc -O2` and is not committed (`.gitignore`).
- CaDiCaL 3.0.1 is at github.com/arminbiere/cadical commit c60730422e75 (`./configure && make -j4`). cake_lpr is at
  github.com/tanyongkiam/cake_lpr commit a36874a8b750 (`make cake_lpr`, from the shipped `cake_lpr.S`). Both are in `/tmp/claude-0/b/`.
- LEAFLOG `/tmp/claude-0/logs/s.jsonl` was seeded with all three `PUSH2/N52/logs/leaves_n52*.jsonl` files (2003 lines).
  The run was `LEAFLOG=... python3 src/tree.py 52 13 400 4 $(cat logs/roots.txt)`. `logs/leaves_new.jsonl` holds the lines
  after the seed, and `logs/tree_stdout.txt` is the tree's stdout, which is empty: no "PROOF NOT VERIFIED".

## 6. Helping

S4 closed before 16:00 UTC. Its helping target S5 had already closed by then, so S4 followed the chain on, as S5 had
done, and helped the shards that were still open. All help lines are UNSAT with `s VERIFIED UNSAT`. There were 0 UNKNOWN and 0 SAT lines.

| helped | roots run (order) | verified leaves | solver s | max leaf s | LRAT |
|---|---|---|---|---|---|
| S6 (`1,2,3,-4,2:G`, G = 18..34; its own routine could not build tools) | forward from 2:18, while S5 ran in reverse from 2:34. Restarted at 16:27 with S5's lines merged into the seed. | 512 | 16 556 | 80.6 | 31.89 GB |
| S2 (`1,2,3,4,2:G`, G = 27..36; its own routine could not build tools) | forward 2:27 → 2:31 (16:37–17:37), while S1 ran in reverse | 220 | 14 167 | 143.3 | 26.15 GB |

- For S6, S4 completed 2:18..2:25 and 2:27, and part of 2:24, 2:26 and 2:29 (a 2:24 leaf was already in the seed). S5 did the rest.
  `logs/closecheck_help_S6.txt` (PUSH2 logs + S4 + S5): all 17 roots CLOSED, open branches 0.
- For S2, S4 completed 2:27..2:30, plus 12 leaves of 2:31 before stopping because S1 had closed it.
  `logs/closecheck_help_S2.txt` (PUSH2 logs + S4 + S1 + S2): all 10 roots CLOSED, open branches 0.
- Help seeds are kept outside the repository. `logs/help_roots_S6.txt` and `logs/help_roots_S2.txt` list the roots.
  `logs/tree_stdout_help*.txt` are empty.

**Whole-task check (17:37 UTC).** `logs/closecheck_all_N52W.txt` runs closecheck on all 192 N52W roots across the
eight shards: (1,2,3,4) 2:1 and 2:17..51, (1,2,3,¬4) 2:0..51, (1,2,¬3,4) 2:0..51 and (1,¬2,3,4) 3:0..51. Its logs are
`PUSH2/N52/logs/leaves_n52*.jsonl` + every `S*/logs/leaves_new.jsonl` as committed at that time:

```
192 CLOSED, 0 OPEN
n=52 k=13: verified leaves used 9984, internal 192, open branches 0, unverified UNSAT lines 0, SAT lines 0
```

The task says the (1,2,3,4) values G = 0 and 2..16 and the other five first-level cubes are already closed in PUSH2.
Combined with that, every first-level cube of `cycenc 52 13 3` is closed without the u = −1 mirror lemma, which gives
k_max(52) = 12 < 52/4. Before this is labelled *proved*, someone should run one consolidated closecheck/covercheck
over the whole tree, PUSH2 part included. closecheck accepts a leaf on its log line's cake_lpr verdict and the
recomputed CNF hash, so it trusts the logged verdicts of the other shards.

## 7. Files

- `logs/roots.txt`: the 59 roots in task order. `logs/placement.txt` and `logs/start.txt` record placement and start time.
- `logs/leaves_new.jsonl`: every leaf line S4 produced (3091 lines for the own shard, then 512 for the S6 help and 220 for the S2 help; 3823 lines in total).
- `logs/closecheck.txt`: S4's own roots. `logs/closecheck_help_S6.txt` and `logs/closecheck_help_S2.txt`: the helped roots.
  `logs/closecheck_all_N52W.txt`: all 192 task roots.
- `logs/tree_stdout*.txt`: tree stdout for each run, all empty.
- `src/`: an unchanged copy of `PUSH2/N52/src/`.
