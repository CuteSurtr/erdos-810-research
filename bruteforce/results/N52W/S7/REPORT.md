# N52W / S7: (1,2,3,¬4,2:G) for G = 35..51, plus help for S8

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          14           0           0          15
Swap:              0           0           0
```

All computation ran in this cloud container, 12:58 to 17:23 UTC on 2026-10-26.

## 2. Results

| roots | status |
|---|---|
| S7: `1,2,3,-4,2:G`, G = 35..51 (17 roots) | **proved** UNSAT: all CLOSED by `closecheck.py`; 884 leaves, each cake_lpr `s VERIFIED UNSAT` |
| S8 (help): `1,2,-3,4,2:G`, G = 0..51 (52 roots) | **proved** UNSAT: all CLOSED by `closecheck.py`; 2704 leaves (2695 run here and PUSH2's 9 sample leaves), each `s VERIFIED UNSAT` |

- No SAT leaf, so there is no certificate (`certs.json` and `solutions.json` are not written).
- No branch relies on the u = −1 mirror lemma: closecheck derives every split from tree.py's rule and accepts only verified leaves.
- S8's own routine was blocked from building the tools (`S8/REPORT.md`). Under the helping rule (S7 helps S8), I ran S8's roots in reverse order, from 2:51 down to 2:0. **The whole first-level cube (1,2,¬3,4) is therefore closed by this run plus PUSH2's samples.**

## 3. Tools and method

- CaDiCaL 3.0.1 at c60730422e75 (`./configure && make`) and cake_lpr at a36874a8b750, built from the shipped
  `cake_lpr.S` (sha256 `2f3af32d…`, which matches `cake_lpr.sha256`), both in `/tmp/claude-0/b/`.
- `src/` is `PUSH2/N52/src/` copied unchanged. `cycenc` was compiled with `gcc -O2`; the binary is not committed.
- Base CNF `cycenc 52 13 3`: sha256 `f0bba6f2545c2658065ae1a75bbcdd0bf8c0192d8532bb89a13c716a148620c6` (matches).
- LEAFLOG `/tmp/claude-0/logs/s.jsonl`, seeded with the three `PUSH2/N52/logs/leaves_n52*.jsonl` files (2003 lines).
  `logs/leaves_new.jsonl` holds lines 2004 onward: 3622 lines, of which 3579 are verified UNSAT leaves and 43 are PRESPLIT lines (17 for S7, plus 26 for S8's 2:26..2:51; the PRESPLIT lines for 2:0..2:25 were already in the seed).
- S7 run: `LEAFLOG=… python3 src/tree.py 52 13 400 4 1,2,3,-4,2:35 … 1,2,3,-4,2:51`, 13:00 to 14:47 UTC.
- S8 help run: `LEAFLOG=… python3 src/tree.py 52 13 400 4 1,2,-3,4,2:51 … 1,2,-3,4,2:0` (same LEAFLOG), started
  automatically when the S7 run ended, 14:47 to 17:22 UTC.
- tree.py pre-split every root on the next offset: g(3) for S7, g(4) for S8. **There were no UNKNOWN re-splits.**
  Every leaf finished well inside the 400 s cap. tree.py printed nothing (`logs/tree_stdout.txt`, `logs/tree_help_stdout.txt`),
  so there was no `PROOF NOT VERIFIED` line.

## 4. Counts

### S7 roots

| root | verified UNSAT | UNKNOWN | other | solver s | max leaf s | LRAT GB |
|---|---|---|---|---|---|---|
| 1,2,3,-4,2:35 | 52 | 0 | 0 | 2052 | 85.4 | 3.56 |
| 1,2,3,-4,2:36 | 52 | 0 | 0 | 1751 | 69.0 | 3.18 |
| 1,2,3,-4,2:37 | 52 | 0 | 0 | 1638 | 59.4 | 3.07 |
| 1,2,3,-4,2:38 | 52 | 0 | 0 | 1563 | 65.8 | 2.83 |
| 1,2,3,-4,2:39 | 52 | 0 | 0 | 1528 | 67.8 | 2.82 |
| 1,2,3,-4,2:40 | 52 | 0 | 0 | 1650 | 74.0 | 2.87 |
| 1,2,3,-4,2:41 | 52 | 0 | 0 | 1654 | 61.5 | 3.08 |
| 1,2,3,-4,2:42 | 52 | 0 | 0 | 1996 | 78.7 | 3.78 |
| 1,2,3,-4,2:43 | 52 | 0 | 0 | 1741 | 69.6 | 3.14 |
| 1,2,3,-4,2:44 | 52 | 0 | 0 | 1616 | 64.4 | 3.04 |
| 1,2,3,-4,2:45 | 52 | 0 | 0 | 1873 | 79.5 | 3.50 |
| 1,2,3,-4,2:46 | 52 | 0 | 0 | 1398 | 57.1 | 2.53 |
| 1,2,3,-4,2:47 | 52 | 0 | 0 | 1847 | 67.4 | 3.40 |
| 1,2,3,-4,2:48 | 52 | 0 | 0 | 1591 | 74.8 | 3.19 |
| 1,2,3,-4,2:49 | 52 | 0 | 0 | 1202 | 53.7 | 2.47 |
| 1,2,3,-4,2:50 | 52 | 0 | 0 | 127 | 2.8 | 0.00 |
| 1,2,3,-4,2:51 | 52 | 0 | 0 | 125 | 2.8 | 0.00 |
| **total** | 884 | 0 | 0 | 25352 | 85.4 | 46.46 |

### S8 roots (help; leaves run here only, so the 9 PUSH2 sample leaves are not included)

| root | verified UNSAT | UNKNOWN | other | solver s | max leaf s | LRAT GB |
|---|---|---|---|---|---|---|
| 1,2,-3,4,2:0 | 51 | 0 | 0 | 118 | 2.5 | 0.00 |
| 1,2,-3,4,2:1 | 52 | 0 | 0 | 124 | 2.9 | 0.00 |
| 1,2,-3,4,2:2 | 52 | 0 | 0 | 119 | 2.7 | 0.00 |
| 1,2,-3,4,2:3 | 52 | 0 | 0 | 119 | 2.7 | 0.00 |
| 1,2,-3,4,2:4 | 52 | 0 | 0 | 646 | 23.3 | 1.32 |
| 1,2,-3,4,2:5 | 52 | 0 | 0 | 642 | 21.5 | 1.21 |
| 1,2,-3,4,2:6 | 51 | 0 | 0 | 579 | 18.8 | 1.05 |
| 1,2,-3,4,2:7 | 52 | 0 | 0 | 657 | 22.6 | 1.23 |
| 1,2,-3,4,2:8 | 51 | 0 | 0 | 694 | 28.2 | 1.31 |
| 1,2,-3,4,2:9 | 52 | 0 | 0 | 812 | 30.2 | 1.54 |
| 1,2,-3,4,2:10 | 51 | 0 | 0 | 792 | 28.1 | 1.54 |
| 1,2,-3,4,2:11 | 52 | 0 | 0 | 782 | 29.5 | 1.48 |
| 1,2,-3,4,2:12 | 52 | 0 | 0 | 827 | 32.5 | 1.49 |
| 1,2,-3,4,2:13 | 52 | 0 | 0 | 738 | 32.5 | 1.33 |
| 1,2,-3,4,2:14 | 52 | 0 | 0 | 738 | 29.6 | 1.38 |
| 1,2,-3,4,2:15 | 51 | 0 | 0 | 694 | 29.2 | 1.28 |
| 1,2,-3,4,2:16 | 50 | 0 | 0 | 749 | 29.1 | 1.40 |
| 1,2,-3,4,2:17 | 52 | 0 | 0 | 815 | 30.7 | 1.48 |
| 1,2,-3,4,2:18 | 51 | 0 | 0 | 900 | 36.8 | 1.72 |
| 1,2,-3,4,2:19 | 52 | 0 | 0 | 790 | 30.6 | 1.47 |
| 1,2,-3,4,2:20 | 52 | 0 | 0 | 776 | 25.2 | 1.39 |
| 1,2,-3,4,2:21 | 51 | 0 | 0 | 780 | 28.5 | 1.46 |
| 1,2,-3,4,2:22 | 52 | 0 | 0 | 752 | 25.5 | 1.31 |
| 1,2,-3,4,2:23 | 52 | 0 | 0 | 732 | 28.5 | 1.35 |
| 1,2,-3,4,2:24 | 52 | 0 | 0 | 790 | 27.0 | 1.41 |
| 1,2,-3,4,2:25 | 52 | 0 | 0 | 978 | 34.6 | 1.75 |
| 1,2,-3,4,2:26 | 52 | 0 | 0 | 902 | 32.9 | 1.64 |
| 1,2,-3,4,2:27 | 52 | 0 | 0 | 882 | 29.9 | 1.64 |
| 1,2,-3,4,2:28 | 52 | 0 | 0 | 920 | 30.6 | 1.77 |
| 1,2,-3,4,2:29 | 52 | 0 | 0 | 766 | 27.2 | 1.39 |
| 1,2,-3,4,2:30 | 52 | 0 | 0 | 768 | 27.8 | 1.35 |
| 1,2,-3,4,2:31 | 52 | 0 | 0 | 681 | 24.1 | 1.32 |
| 1,2,-3,4,2:32 | 52 | 0 | 0 | 808 | 28.6 | 1.50 |
| 1,2,-3,4,2:33 | 52 | 0 | 0 | 773 | 27.6 | 1.39 |
| 1,2,-3,4,2:34 | 52 | 0 | 0 | 819 | 33.4 | 1.47 |
| 1,2,-3,4,2:35 | 52 | 0 | 0 | 934 | 40.4 | 1.73 |
| 1,2,-3,4,2:36 | 52 | 0 | 0 | 825 | 29.7 | 1.47 |
| 1,2,-3,4,2:37 | 52 | 0 | 0 | 737 | 27.9 | 1.43 |
| 1,2,-3,4,2:38 | 52 | 0 | 0 | 733 | 28.5 | 1.28 |
| 1,2,-3,4,2:39 | 52 | 0 | 0 | 785 | 29.7 | 1.38 |
| 1,2,-3,4,2:40 | 52 | 0 | 0 | 759 | 32.9 | 1.33 |
| 1,2,-3,4,2:41 | 52 | 0 | 0 | 824 | 31.9 | 1.48 |
| 1,2,-3,4,2:42 | 52 | 0 | 0 | 840 | 32.4 | 1.48 |
| 1,2,-3,4,2:43 | 52 | 0 | 0 | 869 | 31.1 | 1.57 |
| 1,2,-3,4,2:44 | 52 | 0 | 0 | 849 | 31.0 | 1.55 |
| 1,2,-3,4,2:45 | 52 | 0 | 0 | 718 | 27.7 | 1.32 |
| 1,2,-3,4,2:46 | 52 | 0 | 0 | 711 | 24.4 | 1.22 |
| 1,2,-3,4,2:47 | 52 | 0 | 0 | 591 | 20.3 | 1.06 |
| 1,2,-3,4,2:48 | 52 | 0 | 0 | 665 | 27.1 | 1.21 |
| 1,2,-3,4,2:49 | 52 | 0 | 0 | 742 | 24.4 | 1.33 |
| 1,2,-3,4,2:50 | 52 | 0 | 0 | 126 | 2.9 | 0.00 |
| 1,2,-3,4,2:51 | 52 | 0 | 0 | 131 | 3.5 | 0.00 |
| **total** | 2695 | 0 | 0 | 36304 | 40.4 | 65.18 |

The 9 roots with 51 or 50 leaves here are the ones where PUSH2's sample leaves were reused.

**Totals:** 3579 leaves run, 61655 solver-seconds (4 parallel jobs),
max leaf 85.4 s, 111.64 GB of binary LRAT streamed into cake_lpr.

## 5. Closure checks

`python3 ../common/closecheck.py 52 13 /tmp/claude-0/w/c_52_13_3.cnf --roots <roots> --logs ../../PUSH2/N52/logs/leaves_n52*.jsonl logs/leaves_new.jsonl`

S7 roots (`logs/closecheck.txt`, exit 0):

```
CLOSED 1,2,3,-4,2:35
CLOSED 1,2,3,-4,2:36
CLOSED 1,2,3,-4,2:37
CLOSED 1,2,3,-4,2:38
CLOSED 1,2,3,-4,2:39
CLOSED 1,2,3,-4,2:40
CLOSED 1,2,3,-4,2:41
CLOSED 1,2,3,-4,2:42
CLOSED 1,2,3,-4,2:43
CLOSED 1,2,3,-4,2:44
CLOSED 1,2,3,-4,2:45
CLOSED 1,2,3,-4,2:46
CLOSED 1,2,3,-4,2:47
CLOSED 1,2,3,-4,2:48
CLOSED 1,2,3,-4,2:49
CLOSED 1,2,3,-4,2:50
CLOSED 1,2,3,-4,2:51
n=52 k=13: verified leaves used 884, internal 17, open branches 0, unverified UNSAT lines 0, SAT lines 0
```

S8 roots (`logs/closecheck_S8help.txt`, exit 0):

```
CLOSED 1,2,-3,4,2:51
CLOSED 1,2,-3,4,2:50
CLOSED 1,2,-3,4,2:49
CLOSED 1,2,-3,4,2:48
CLOSED 1,2,-3,4,2:47
CLOSED 1,2,-3,4,2:46
CLOSED 1,2,-3,4,2:45
CLOSED 1,2,-3,4,2:44
CLOSED 1,2,-3,4,2:43
CLOSED 1,2,-3,4,2:42
CLOSED 1,2,-3,4,2:41
CLOSED 1,2,-3,4,2:40
CLOSED 1,2,-3,4,2:39
CLOSED 1,2,-3,4,2:38
CLOSED 1,2,-3,4,2:37
CLOSED 1,2,-3,4,2:36
CLOSED 1,2,-3,4,2:35
CLOSED 1,2,-3,4,2:34
CLOSED 1,2,-3,4,2:33
CLOSED 1,2,-3,4,2:32
CLOSED 1,2,-3,4,2:31
CLOSED 1,2,-3,4,2:30
CLOSED 1,2,-3,4,2:29
CLOSED 1,2,-3,4,2:28
CLOSED 1,2,-3,4,2:27
CLOSED 1,2,-3,4,2:26
CLOSED 1,2,-3,4,2:25
CLOSED 1,2,-3,4,2:24
CLOSED 1,2,-3,4,2:23
CLOSED 1,2,-3,4,2:22
CLOSED 1,2,-3,4,2:21
CLOSED 1,2,-3,4,2:20
CLOSED 1,2,-3,4,2:19
CLOSED 1,2,-3,4,2:18
CLOSED 1,2,-3,4,2:17
CLOSED 1,2,-3,4,2:16
CLOSED 1,2,-3,4,2:15
CLOSED 1,2,-3,4,2:14
CLOSED 1,2,-3,4,2:13
CLOSED 1,2,-3,4,2:12
CLOSED 1,2,-3,4,2:11
CLOSED 1,2,-3,4,2:10
CLOSED 1,2,-3,4,2:9
CLOSED 1,2,-3,4,2:8
CLOSED 1,2,-3,4,2:7
CLOSED 1,2,-3,4,2:6
CLOSED 1,2,-3,4,2:5
CLOSED 1,2,-3,4,2:4
CLOSED 1,2,-3,4,2:3
CLOSED 1,2,-3,4,2:2
CLOSED 1,2,-3,4,2:1
CLOSED 1,2,-3,4,2:0
n=52 k=13: verified leaves used 2704, internal 52, open branches 0, unverified UNSAT lines 0, SAT lines 0
```

## 6. Files

| path | content |
|---|---|
| `src/` | PUSH2/N52/src, unchanged |
| `logs/leaves_new.jsonl` | every leaf line after the seed (S7 and S8-help runs) |
| `logs/closecheck.txt`, `logs/closecheck_S8help.txt` | closure check outputs |
| `logs/tree_stdout.txt`, `logs/tree_help_stdout.txt` | tree.py stdout (empty) |

## 7. Notes

- The leaf costs in (1,2,3,¬4,2:35..49) were steady, 23 to 40 s on average, with a max of 85 s. 2:50 and 2:51 were trivial (about 2.5 s per leaf).
- In (1,2,¬3,4) the leaves cost 2 to 40 s. The full cube took about 36 300 solver-s, above the ≈ 22 000 s that the task estimated for it.
