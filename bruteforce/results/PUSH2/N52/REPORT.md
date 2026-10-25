# PUSH2/N52: n = 52, k = 13 (= n/4) in the cyclic orbit family

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

Tree run 18:21 to 22:38 UTC: 4 workers until 21:00, then 2 workers (the other 2 cores went to N56); 22:14 to
22:38 a second tree.py on 2 cores ran the mirror half of (1,2,¬3,¬4).

## 2. Results

| claim | status |
|---|---|
| k = 12 achievable at n = 52 (624 edges): positive control, `cycenc 52 12 3` solved from scratch | **certificate-verified** (SAT in 88.5 s; `check.py` and `certcheck.py`: `52 624 edges 36088 4-cycles OK`; `control/`) |
| u = −1 mirror map sends the n = 52, k = 12 model to a valid colouring | numerically confirmed (`check.py`: valid, 624 edges) |
| level-1 cubes ¬p1, (1,¬2,3,¬4), (1,¬2,¬3,4), (1,¬2,¬3,¬4) UNSAT | **proved** (single leaves, cake_lpr `s VERIFIED UNSAT`) |
| level-1 cube (1,2,¬3,¬4) UNSAT | **proved**: all 52 g(2) children run directly (26 representatives + 26 mirrors), all `s VERIFIED UNSAT`; no symmetry used |
| level-1 cube (1,2,3,4) | **open**: 858 of its leaves verified UNSAT (g(2) ∈ {0, 2..16} closed, 2:17 half done); 16 mirror children would be COVERED by the lemma; 504 representative leaves and the mirror half still to run |
| level-1 cubes (1,2,3,¬4), (1,2,¬3,4), (1,¬2,3,4) | **open**: split, but only 9 sample leaves each run (all UNSAT) |
| k = 13 at n = 52 | **open**. No SAT model found in any cube |

`covercheck.py 52 13` on the current tree fails as expected at the first pending leaf
(`AssertionError: (['1', '2', '3', '4', '2:17', '3:26'], 'PENDING')`, `logs/covercheck.txt`).

Leaf counts in `tree.json` (`mktree.py`): 941 UNSAT checked, 16 COVERED, 4662 PENDING (an unsplit mirror
g-child counts as one pending node, so the mirror halves of the three unexpanded roots add about 3 × 1300 more leaves).

## 3. Generalised scripts (task step 1)

`src/mktree.py n k base.cnf out.json logs...` and `src/covercheck.py n k tree.json base.cnf` take n and k, with
H = ⌈n/2⌉ − 1 (25 here). `covercheck.py` also checks that the base CNF header is `c map n H` and that the tree
summary is for (n, k). Validation:

- on N48's `tree.json`: `COVER OK {'unsat': 5075, 'covered': 57, 'internal': 109}`, identical to N48's output;
  the generalised `mktree.py` rebuilt from N48's logs gives the same tree as N48's `tree.json` (compared node by
  node, ignoring the free-text `note` and `secs`);
- on the N48M tree: `COVER OK {'unsat': 7811, 'covered': 0, 'internal': 166}`, identical to N48's script.

`src/report_stats.py` now takes the tree path as an argument. `tree.py`, `leaf.py`, `cycenc.c`, `check.py`,
`certcheck.py` are N48's, unchanged.

## 4. Method and counts

- Base CNF `cycenc 52 13 3`: 18741 variables, 846389 clauses, sha256
  `f0bba6f2545c2658065ae1a75bbcdd0bf8c0192d8532bb89a13c716a148620c6`. k = 12 CNF sha256
  `749a98afdf3233b3baad609a8f5ae94bff725fbd6c38079f9e50c14e82f6e8dc`.
- Command: `LEAFLOG=/tmp/claude-0/logs/n52.jsonl python3 src/tree.py 52 13 400 4 -1 1,2,3,4 1,2,3,-4 1,2,-3,4 1,2,-3,-4 1,-2,3,4 1,-2,3,-4 1,-2,-3,4 1,-2,-3,-4`
  (restarted with 2 workers at 21:05 through the `STOP` file, same LEAFLOG). Mirror half of (1,2,¬3,¬4):
  `tree.py 52 13 400 2 1,2,-3,-4` with a separate LEAFLOG seeded from a copy of the main one.
- Solver CaDiCaL 3.0.1, LRAT streamed into cake_lpr a36874a; every UNSAT line in all logs has
  `s VERIFIED UNSAT`. Per-leaf CNF sha256, time, proof bytes and verdict are in `tree.json` and the logs.

Level-1 cubes (400 s cap):

| cube | result | s | LRAT bytes | leaf CNF sha256 |
|---|---|---|---|---|
| (−1) | UNSAT verified | 10.1 | 145980 | ed6d44175dc5954ac5697c9f66d8fa381f1b781d1a004c2fc58ce74baf0420d1 |
| (1,¬2,¬3,¬4) | UNSAT verified | 7.5 | 6147634 | 0cc2e2bfca8b894aaecdb9874d9e6dcead8f97b875a7311488c7a164f28c4c6d |
| (1,¬2,¬3,4) | UNSAT verified | 37.4 | 87361970 | 39525256b2a509e3698087272a600b0b4cb6b73f3c07cc086dae3121236906e4 |
| (1,¬2,3,¬4) | UNSAT verified | 111.1 | 261436619 | 43092681fbb2c9ea122ca09fe30c78dd0d75caaefdd8a068d8fe30288bce1153 |
| (1,2,3,4), (1,2,3,¬4), (1,2,¬3,4), (1,2,¬3,¬4), (1,¬2,3,4) | UNKNOWN at 400 s, split | | | |

The ¬p1 cube is the case "D = the 13 non-units in 1..25", solved directly (UNSAT in 10 s).

Whole tree (`logs/stats.md`):

| root cube | split | checked UNSAT leaves | covered by u=-1 mirror | pending | solver time (s) | max leaf (s) | LRAT streamed (GB) |
|---|---|---|---|---|---|---|---|
| (-1) | - | 1 | 0 | 0 | 10 | 10 | 0.00 |
| (1, 2, 3, 4) | g(2) then g(3) | 858 | 16 | 504 | 42654 | 182 | 74.88 |
| (1, 2, 3, -4) | g(2) then g(3) | 9 | 0 | 1369 | 267 | 50 | 0.48 |
| (1, 2, -3, 4) | g(2) then g(4) | 9 | 0 | 1369 | 74 | 21 | 0.11 |
| (1, 2, -3, -4) | g(2) | 52 | 0 | 0 | 5871 | 298 | 13.00 |
| (1, -2, 3, 4) | g(3) then g(4) | 9 | 0 | 1420 | 56 | 10 | 0.07 |
| (1, -2, 3, -4) | - | 1 | 0 | 0 | 111 | 111 | 0.26 |
| (1, -2, -3, 4) | - | 1 | 0 | 0 | 37 | 37 | 0.09 |
| (1, -2, -3, -4) | - | 1 | 0 | 0 | 8 | 8 | 0.01 |
| **total** | | 941 | 16 | 4662 | 49087 | | 88.91 |

(In the three unexpanded roots, "pending" counts the representative leaves (1343, 1343 and 1395 at depth 6,
i.e. 26 × 52 − 9, 26 × 52 − 9 and 27 × 52 − 9) plus each not-yet-split mirror g-child as one node (26, 26, 25).) Per g(·)-child status: `logs/level2_status.md`.

**Cost profile in (1,2,3,4).** The g(2) children differ a lot: 2:0, 2:2, 2:3, 2:4 cost about 150 s each
(52 leaves of about 3 s), while 2:5 to 2:16 cost 1800 to 4500 s each (leaves of 35 to 180 s). The 9-leaf samples
in the other roots averaged 29.6 s (1,2,3,¬4), 8.3 s (1,2,¬3,4) and 6.2 s (1,¬2,3,4) per leaf.

## 5. Remaining cost and sharding plan

Estimate (CaDiCaL core-seconds, LRAT checking included since it runs alongside):

| part | leaves left | estimate |
|---|---|---|
| (1,2,3,4) representatives 2:17 (26 leaves left) to 2:26 | ≈ 494 | ≈ 33 000 s |
| (1,2,3,4) mirrors 2:1, 2:27..2:51 (if the lemma is to be avoided) | 1352 | ≈ 76 000 s (same as the representatives) |
| (1,2,3,¬4) both halves | 2695 | ≈ 80 000 s (from a 9-leaf sample) |
| (1,2,¬3,4) both halves | 2695 | ≈ 22 000 s |
| (1,¬2,3,4) both halves | 2695 | ≈ 17 000 s |
| **total** | | ≈ 230 000 s ≈ 64 core-hours (≈ 16 h on 4 cores); ≈ 116 000 s with the mirror lemma |

The samples are small, so treat the last three rows as order-of-magnitude figures.

Shards (each independent, with its own LEAFLOG; `src/` from this folder, tools at the N48 commits, base CNF
`cycenc 52 13 3` with the sha256 above):

1. `(1,2,3,4)` by g(2) child: for each G in 17..26 (representatives) and then G in {1, 27..51} (mirrors):
   `LEAFLOG=<log_G> python3 src/tree.py 52 13 400 4 1,2,3,4,2:G`. tree.py pre-splits it on g(3) (52 leaves).
   Seed every log with `logs/leaves_n52.jsonl` so done leaves (2:17 has 26) are skipped.
2. `(1,2,3,-4)`, `(1,2,-3,4)`, `(1,-2,3,4)`: one shard per root,
   `LEAFLOG=<log> python3 src/tree.py 52 13 400 4 <root>`, seeded with `logs/leaves_n52.jsonl` and
   `logs/leaves_n52_sample.jsonl` (the root's UNKNOWN line makes it split at once; representatives first,
   mirrors last). They can be split further by g-child as in 1.
3. Merge: `python3 src/mktree.py 52 13 c_52_13_3.cnf tree.json logs/*.jsonl <shard logs>` and then
   `python3 src/covercheck.py 52 13 tree.json c_52_13_3.cnf`. The target is `covered: 0`.

If any leaf is SAT, k_max(52) = 13 = n/4: decode with `check.py`/`certcheck.py` (leaf.py already checks it).

## 6. Files

| path | content |
|---|---|
| `src/` | N48's scripts plus generalised `mktree.py`, `covercheck.py`, `report_stats.py` |
| `control/` | k = 12 solution (`solutions_k12.json`, orbit form) and certificate (`certs_k12.json`, edge list) |
| `tree.json` | current tree (941 verified leaves, pending nodes marked) |
| `logs/leaves_n52.jsonl` | main LEAFLOG, copied after the run stopped |
| `logs/leaves_n52_mirrors_1_2_m3_m4.jsonl` | LEAFLOG of the (1,2,¬3,¬4) mirror run (starts with a copy of the main log as of 22:14) |
| `logs/leaves_n52_sample.jsonl` | 27 sample leaves in the three unexpanded roots, all UNSAT verified |
| `logs/covercheck.txt`, `logs/stats.md`, `logs/level2_status.md`, `logs/tree_stdout.txt` | outputs |
