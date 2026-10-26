# N52W / S5: (1,2,3,¬4,2:G) for G = 0..17. **All 18 roots CLOSED** (proved, cake_lpr-verified LRAT)

## 1. Placement

Taken at the start of the run, 2026-10-26 13:18 UTC (scheduled 12:55 UTC):

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          14           0           0          15
Swap:              0           0           0
```

## 2. Results

| root | status |
|---|---|
| `1,2,3,-4,2:G`, G = 0..17 (18 roots) | **proved**: CLOSED by closecheck, every leaf `s VERIFIED UNSAT` by cake_lpr |

- There are no SAT leaves and no UNKNOWN re-splits. All leaves finished well under the 400 s cap.
- Leaf lines from this shard: 929 UNSAT, all verified, plus 1 PRESPLIT (`2:1`).
  The other 17 roots' PRESPLIT lines were already in the PUSH2 seed logs.
- closecheck used 936 verified leaves. The 7 extra leaves come from the PUSH2 seed logs.
- CaDiCaL time was 24 182 s in total. The longest leaf took 83.2 s (`1,2,3,-4,2:8,3:26`).
- LRAT volume was 42.5 GB of streamed binary LRAT. It was checked on the fly and nothing was stored.
  cake_lpr took 129 s more after the solvers finished.
- The tree ran from 13:19 to 15:02 UTC on 4 workers.

## 3. Closure check

```
python3 ../common/closecheck.py 52 13 c_52_13_3.cnf --roots $(cat logs/roots.txt) \
  --logs ../../PUSH2/N52/logs/leaves_n52*.jsonl logs/leaves_new.jsonl
```

The exit code was 0. The full output is in `logs/closecheck.txt`:

```
CLOSED 1,2,3,-4,2:0 ... CLOSED 1,2,3,-4,2:17   (all 18)
n=52 k=13: verified leaves used 936, internal 18, open branches 0, unverified UNSAT lines 0, SAT lines 0
```

## 4. Method

- **Tools.** CaDiCaL 3.0.1 @ c60730422e75 (`./configure && make -j4`). cake_lpr @ a36874a8b750
  (`make cake_lpr` from the shipped `cake_lpr.S`). Both were built in `/tmp/claude-0/b/`.
- **CNF.** `cycenc` was compiled from `src/cycenc.c` with `gcc -O2`; the binary is not committed.
  The base CNF `cycenc 52 13 3` has sha256 `f0bba6f2545c2658065ae1a75bbcdd0bf8c0192d8532bb89a13c716a148620c6`,
  which matches the task.
- **Source.** `src/` is an unchanged copy of `PUSH2/N52/src/`.
- **Seed.** The LEAFLOG at `/tmp/claude-0/logs/s5.jsonl` was seeded with the 2003 lines of
  `PUSH2/N52/logs/leaves_n52*.jsonl`.
- **Run.** `LEAFLOG=/tmp/claude-0/logs/s5.jsonl python3 src/tree.py 52 13 400 4 $(cat logs/roots.txt)`.
  Each root was pre-split on g(3), giving 52 leaves per root. No mirror lemma was used, as closecheck confirms.
- **Log.** `logs/leaves_new.jsonl` holds only the lines added after the seed.

## 5. Helping S6 (`1,2,3,-4,2:G`, G = 34 down to 18)

S5 closed at 15:02 UTC, before the 16:00 cutoff. S6 had committed no leaves (its runs were blocked at the tool
build), so S5 ran S6's roots in reverse order (`logs/help_roots_S6.txt`). S4 was helping S6 at the same time,
going forward from G = 18.

- **Seed.** The helper LEAFLOG started from S5's full LEAFLOG plus S6's empty `leaves_new.jsonl`.
- **Restart at 16:17.** tree.py's queue had put the children of 2:27 and 2:29 behind 2:22..2:18, which S4 had
  already closed. One root (2:29) is pre-split by a worker while another worker splits the roots already in
  `done`, so the order changes. I stopped the run and restarted it with S4's committed `leaves_new.jsonl`
  (commit e9ae984 lineage, fetched 16:16) added to the seed. About 4 in-flight leaves (under 90 s each) were lost.
  No partial lines were written: a leaf logs only when it finishes.
- **Results.** The help work added 608 verified UNSAT leaves and 8 PRESPLIT lines. CaDiCaL time was 20 842 s,
  the longest leaf took 85.9 s, and the LRAT volume was 37.4 GB. There were no SAT, UNKNOWN or ERROR lines.
  Some leaves of 2:23..2:26 duplicate S4's; that is harmless.
- **Closure check.** S6's 17 roots, with S4's log included:

```
python3 ../common/closecheck.py 52 13 c_52_13_3.cnf --roots $(cat logs/help_roots_S6.txt) \
  --logs ../../PUSH2/N52/logs/leaves_n52*.jsonl logs/leaves_new.jsonl ../S4/logs/leaves_new.jsonl
-> all 17 CLOSED; verified leaves used 884, internal 17, open branches 0, unverified UNSAT lines 0, SAT lines 0
```

The full output is in `logs/closecheck_help_S6.txt`. So **(1,2,3,¬4,2:G) for G = 18..34 is closed** by the union of
S5's and S4's logs. S5 itself ran G = 26..34, 2:27 and 2:29 in full, plus the tails of 2:23..2:25.

## 6. Files, surprises, next steps

**Files.**
- `src/`: an unchanged copy of PUSH2/N52/src.
- `logs/roots.txt` and `logs/help_roots_S6.txt`: the roots run.
- `logs/leaves_new.jsonl`: every line this session added (S5 shard, then S6 help), never the seed.
- `logs/closecheck.txt` and `logs/closecheck_help_S6.txt`: the closure checks.
- `logs/placement.txt`: placement taken mid-run, under load.

**Surprises.**
- S5 cost ≈ 24 000 core-s, against an estimate of 27 000. No leaf came near the 400 s cap.
- tree.py's queue order is not strictly the root order when some roots are already split in the seed.
  This was harmless, but it matters when helpers split work by order.
- Watch out when killing jobs: `pkill -f` with an unbracketed pattern also matched and killed my own shell.

**Next steps.** None for S5 or S6. The final merge is a closecheck over all eight shards' logs for the
roots (1,2,3,4), (1,2,3,¬4), (1,2,¬3,4) and (1,¬2,3,4).
