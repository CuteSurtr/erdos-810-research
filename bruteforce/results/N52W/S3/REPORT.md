# N52W shard S3: (1,2,3,4) with g(2) ∈ {1, 37..44}, n = 52, k = 13

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          14           0           0          15
Swap:              0           0           0
```

All computation ran in this cloud container, 4 workers, from 13:01 to 15:04 UTC on 2026-10-26.

## 2. Results

| root | status | leaves | solver s | LRAT GB |
|---|---|---|---|---|
| 1,2,3,4,2:1 | **CLOSED** (proved) | 52 | 196 | 0.00 |
| 1,2,3,4,2:37 | **CLOSED** (proved) | 52 | 3462 | 6.12 |
| 1,2,3,4,2:38 | **CLOSED** (proved) | 52 | 3239 | 5.80 |
| 1,2,3,4,2:39 | **CLOSED** (proved) | 52 | 3297 | 5.70 |
| 1,2,3,4,2:40 | **CLOSED** (proved) | 52 | 3334 | 5.72 |
| 1,2,3,4,2:41 | **CLOSED** (proved) | 52 | 3377 | 5.88 |
| 1,2,3,4,2:42 | **CLOSED** (proved) | 52 | 3664 | 6.39 |
| 1,2,3,4,2:43 | **CLOSED** (proved) | 52 | 4058 | 6.94 |
| 1,2,3,4,2:44 | **CLOSED** (proved) | 52 | 4510 | 7.13 |
| **total** | 9/9 closed, 0 open | 468 | 29136 | 49.67 |

- All 9 roots of S3 are CLOSED with no symmetry used. Every root was pre-split on g(3) into 52 leaves.
  Each of the 468 leaves is UNSAT with a streamed binary LRAT proof that cake_lpr checked (`s VERIFIED UNSAT`).
- Max leaf time: 177.8 s (1,2,3,4,2:44,3:9). No leaf hit the 400 s cap, so there were no UNKNOWN re-splits.
- No SAT leaf, no ERROR, no unverified UNSAT line.
- The u = −1 mirror lemma was not used. These roots are the mirrors of 2:0 and 2:16..2:9 (a ↦ 1 − a mod 52),
  and their costs match those representatives (≈ 3200–4500 s each; 2:1 is cheap like 2:0).

## 3. Closure check

`python3 ../common/closecheck.py 52 13 c_52_13_3.cnf --roots <9 roots> --logs ../../PUSH2/N52/logs/leaves_n52*.jsonl logs/leaves_new.jsonl`
(exit code 0), `logs/closecheck.txt`:

```
CLOSED 1,2,3,4,2:1
CLOSED 1,2,3,4,2:37
CLOSED 1,2,3,4,2:38
CLOSED 1,2,3,4,2:39
CLOSED 1,2,3,4,2:40
CLOSED 1,2,3,4,2:41
CLOSED 1,2,3,4,2:42
CLOSED 1,2,3,4,2:43
CLOSED 1,2,3,4,2:44
n=52 k=13: verified leaves used 468, internal 9, open branches 0, unverified UNSAT lines 0, SAT lines 0
```

## 4. Method

- Tools built as in PUSH2: CaDiCaL 3.0.1 @ c60730422e75 and cake_lpr @ a36874a8b750 (`gcc -O2 basis_ffi.c cake_lpr.S`,
  self-test on `example.cnf`: `s VERIFIED UNSAT`), both in `/tmp/claude-0/b/`.
  `cycenc` was compiled from `src/cycenc.c`. `src/` is a copy of `PUSH2/N52/src` and is unchanged.
- The base CNF `cycenc 52 13 3` has sha256 `f0bba6f2545c2658065ae1a75bbcdd0bf8c0192d8532bb89a13c716a148620c6` (matches).
- The LEAFLOG `/tmp/claude-0/logs/s3.jsonl` was seeded with the three `PUSH2/N52/logs/leaves_n52*.jsonl`
  files (2003 lines). Command: `LEAFLOG=... python3 src/tree.py 52 13 400 4 $(cat logs/roots.txt)`.
- `logs/leaves_new.jsonl` holds the S3 lines after the seed (9 PRESPLIT + 468 UNSAT), followed by the helper lines (§5).
  `logs/tree_stdout.txt` is the run's stdout (empty, so there were no PROOF NOT VERIFIED lines).

## 5. Helping S4

S3 closed at 15:04 UTC, so I started helping S4. I took S4's `leaves_new.jsonl` as of 15:04 (fetched) and added it
to a seed with a separate LEAFLOG (`s3h.jsonl`). Then I ran S4's roots in reverse order (`logs/help_S4_roots.txt`):
`1,-2,3,4,3:51` down to `3:0`, then `1,2,3,4,2:51..45`. At 15:23 a fetch showed that S4 had already closed all
59 of its roots (commit af58f64, closecheck with 0 open branches), so I stopped the helper through `STOP`.
The helper added 704 verified UNSAT leaves in (1,¬2,3,4), for g(3) = 51..39 and part of 38: 4327 solver s,
5.37 GB LRAT, max leaf 13.0 s. They duplicate S4's leaves; duplicates are harmless.
The closure check above uses only the S3 roots.

## 6. Files

| path | content |
|---|---|
| `src/` | copy of `PUSH2/N52/src` (the `cycenc` binary is gitignored) |
| `logs/leaves_new.jsonl` | all new leaf lines (S3 run, then the S4 helper) |
| `logs/closecheck.txt` | closure check output |
| `logs/roots.txt`, `logs/help_S4_roots.txt` | root lists |
| `logs/placement.txt`, `logs/tree_stdout.txt`, `logs/help_S4_stdout.txt` | placement and run stdout |

## 7. Surprises and next steps

- None. No SAT leaf: every leaf of the S3 roots is UNSAT and verified.
- Once S1, S2 and S5 to S8 also report CLOSED, all first-level cubes of `cycenc 52 13 3` are closed without the
  mirror lemma, and so k_max(52) = 12 < 52/4 in this encoding. Next step: a merged closecheck over all
  shards' logs with the 9 level-1 roots.
