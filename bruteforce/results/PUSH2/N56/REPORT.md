# PUSH2/N56: n = 56, k = 14 (= n/4), positive control and level-1 cubes only

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

Job 2 (N52) was still running at 21:00 UTC, so by the task's rule only the positive control and the 9 level-1
cubes ran, with a 600 s cap, 21:00 to 22:10 UTC on 2 cores (N52 continued on the other 2).

## 2. Results

| claim | status |
|---|---|
| k = 13 is achievable at n = 56 (728 edges): CYC/C4's colouring satisfies the `cycenc 56 13 3` CNF | **certificate-verified** (CNF + 13 offset units SAT in 1.0 s, model decoded and re-checked by `check.py` and `certcheck.py`: `56 728 edges 50960 4-cycles OK`) |
| free solve of `cycenc 56 13 3` | UNKNOWN at 3600 s (no claim) |
| k = 14 level-1 cubes ¬p1 and (1,¬2,¬3,¬4) | **UNSAT, proved** (cake_lpr `s VERIFIED UNSAT`) |
| k = 14 level-1 cubes (1,2,3,4), (1,2,3,¬4), (1,2,¬3,4), (1,2,¬3,¬4), (1,¬2,3,4), (1,¬2,3,¬4), (1,¬2,¬3,4) | UNKNOWN at 600 s: **open** |
| k = 14 at n = 56 | **open** |

No SAT model was found for k = 14.

## 3. Details

- Base CNFs (`src/cycenc`, same `cycenc.c` as N48): `cycenc 56 14 3`: 23272 variables, 1144581 clauses, sha256
  `7a96db2d27407c3b3f971800021e1d2f7c97ec58614e558820ce6256270b09ad`; `cycenc 56 13 3`: sha256
  `e1447cfbbd2678268043655b05df0ff6aa8a3a1fd893c17a82a3e27296910e31`. H = 27.
- Positive control. The free k = 13 solve did not finish in 3600 s, so the known solution was used: CYC/C4's
  (D, g) was mapped through all 24 units u of Z_56 (edge i~i+d → ui~ui+ud, colour c → uc, then translated so
  g(1) = 0). All 24 images are valid, and u = 1 is already the lex-leader, so the CNF must accept it unchanged.
  With the 13 offsets given as unit clauses the solver says SAT in 1.0 s and the decoded model checks
  (`control/`). This confirms the encoder's completeness direction on a known n = 56 solution.
- Level-1 cubes (`logs/leaves_n56.jsonl`, via `src/leaf.py 56 14 600 <cube> lrat`):

| cube | result | s | LRAT bytes | leaf CNF sha256 |
|---|---|---|---|---|
| (−1) | UNSAT, s VERIFIED UNSAT | 3.1 | 3922320 | 72df075b059e80cc758f05b2536b5b91deadbec5604d0442fa796a2713f7bb67 |
| (1,2,3,4) | UNKNOWN | 600.8 | | e7828427262e74f4b8c081f0e7cc3d597ac329df461aa6577bcb000075e1c9b4 |
| (1,2,3,−4) | UNKNOWN | 600.7 | | f85c631cbfa80a006959d2731a91dac75815b75f4a80d01236ec1764cdccf168 |
| (1,2,−3,4) | UNKNOWN | 600.6 | | d7fdd2886be0e17a9d823014f0e127f723949d898b4750596cf2a355523019dc |
| (1,2,−3,−4) | UNKNOWN | 601.4 | | 2234c781aca6210b2db269950e498be7c5924c47fa8ce6647d4baaf5f47183ea |
| (1,−2,3,4) | UNKNOWN | 601.1 | | fe2d3886fac8b299e29f8d7871312e74c2b836bf947d8c3b92ead1cdbcd2277f |
| (1,−2,3,−4) | UNKNOWN | 602.1 | | 9eb7ed765618b88e74b7a39c1ad4374d015f51f346794b540cfb5389af8b355c |
| (1,−2,−3,4) | UNKNOWN | 602.2 | | 21b8d224f2c944880758157943ca9515798f2b13fd98c2a91a733b535a79d7c3 |
| (1,−2,−3,−4) | UNSAT, s VERIFIED UNSAT | 30.4 | 90075748 | 975a55c8ccd4e14a9db80a7adf6f43d9ca608b3f9c31463bf1519687889a32cb |

Compared with n = 52 (where (1,¬2,3,¬4) and (1,¬2,¬3,4) closed at level 1 in 111 s and 37 s), n = 56 is harder:
7 of 9 cubes are open at 600 s.

## 4. Next steps (sharding plan)

The tree is the same as N52's. Continue with
`LEAFLOG=<log> python3 src/tree.py 56 14 400 4 -1 1,2,3,4 1,2,3,-4 1,2,-3,4 1,2,-3,-4 1,-2,3,4 1,-2,3,-4 1,-2,-3,4 1,-2,-3,-4`,
seeding the log with `logs/leaves_n56.jsonl` (its UNKNOWN lines make tree.py split those cubes straight away, so
the 600 s runs are not repeated). It can be sharded by level-1 cube: one tree.py per open root, each with its own
LEAFLOG seeded with that root's line, and the logs merged by `src/mktree.py 56 14 base.cnf tree.json <logs...>`
(then `src/covercheck.py 56 14 tree.json base.cnf`). Going by n = 52, expect several times N52's cost.

## 5. Files

`src/` (copy of N52's generalised scripts), `control/` (k = 13 solution, certificate, SAT line),
`logs/leaves_n56.jsonl` (all 10 result lines).
