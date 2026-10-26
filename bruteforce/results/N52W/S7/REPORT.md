# N52W / S7: (1,2,3,¬4,2:G) for G = 35..51

**Interim report (14:50 UTC).** The S7 shard is closed, and the run is now helping S8 (see §4). A final report follows.

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           8           7           0           0           7
Swap:              0           0           0
```

## 2. Results

| root | status |
|---|---|
| `1,2,3,-4,2:G`, G = 35..51 (all 17) | **proved** UNSAT: CLOSED by `closecheck.py`, 884 leaves, each cake_lpr `s VERIFIED UNSAT`, no mirror lemma |

No SAT leaf, so no certificate.

## 3. Counts (S7 roots; 400 s cap, 4 workers, 13:00 to 14:47 UTC)

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

There were no UNKNOWN re-splits: each root was pre-split on g(3) into 52 leaves, and every leaf finished within 400 s.

closecheck (`logs/closecheck.txt`):

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
