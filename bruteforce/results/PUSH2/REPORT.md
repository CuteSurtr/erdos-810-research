# PUSH2 (2026-10-25): N48 mirror branches, then n = 52 and 56 at k = n/4

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

All computation in this cloud container, 16:36 to 22:40 UTC. Tools rebuilt at N48's commits: CaDiCaL 3.0.1
(c60730422e75), cake_lpr (a36874a8b750, from the shipped `cake_lpr.S`), `cycenc.c` from N48 unchanged
(base CNF `cycenc 48 12 3` sha256 `8b9bc39b…6cbf`, matching N48 §4.1). Every UNSAT claim rests on CaDiCaL
binary LRAT streamed into cake_lpr with verdict `s VERIFIED UNSAT`.

## 2. Results

| job | claim | status |
|---|---|---|
| N48M | the 57 mirror branches of N48 are all UNSAT (2706 new leaves, 36.9 GB LRAT, all verified); each agrees with its representative | **proved**, 57 / 57 agree |
| N48M | `covercheck.py`: `COVER OK {'unsat': 7811, 'covered': 0, 'internal': 166}` | so **k_max(48) = 11** (k = 12 = n/4 UNSAT in the sym = 3 encoding) is **proved without the mirror lemma**, resting only on the encoder (C1 §4) and the trivial cover |
| N52 | k = 12 positive control: `cycenc 52 12 3` SAT in 88.5 s, model checked by both checkers (624 edges) | **certificate-verified** |
| N52 | generalised `mktree.py` / `covercheck.py` (n, k arguments) reproduce N48's tree and both cover-check outputs exactly | done |
| N52 | k = 13: ¬p1, (1,¬2,3,¬4), (1,¬2,¬3,4), (1,¬2,¬3,¬4) and (1,2,¬3,¬4) (the last with all 52 g(2) children, no symmetry) | **proved** UNSAT |
| N52 | k = 13: (1,2,3,4) (858 leaves verified, g(2) ∈ {0, 2..16} closed), (1,2,3,¬4), (1,2,¬3,4), (1,¬2,3,4) | **open** |
| N52 | k = 13 at n = 52 overall | **open**; no SAT leaf. 941 verified leaves, 49 087 s solver time, 88.9 GB LRAT |
| N56 | k = 13 positive control: CYC/C4's colouring satisfies `cycenc 56 13 3` (SAT with its offsets as units, model checked; free solve UNKNOWN at 3600 s) | **certificate-verified** |
| N56 | k = 14 level-1 cubes ¬p1 (3 s) and (1,¬2,¬3,¬4) (30 s) | **proved** UNSAT |
| N56 | the other 7 level-1 cubes: UNKNOWN at 600 s | **open** |

No SAT model was found for any k = n/4 instance. No certificates beyond the positive controls
(`N52/control/`, `N56/control/`; edge lists in `certs_k*.json`, orbit form in `solutions_k*.json`).

## 3. Per job

- `N48M/REPORT.md`: method, the check that only mirror cubes ran, full stats table, per-branch agreement table
  (`N48M/logs/mirror_agreement.md`), `tree.json`.
- `N52/REPORT.md`: tree shape, level-1 table, stats, cost profile, **remaining-cost estimate (≈ 64 core-hours,
  ≈ 32 with the mirror lemma) and an exact sharding plan**.
- `N56/REPORT.md`: control and level-1 table, how to continue.

## 4. Timeline (UTC)

16:37 to 18:15 N48M mirror queue (4 cores) · 18:21 N52 tree start (4 cores) · 21:00 N56 control and level-1 on
2 cores, N52 on 2 · 22:10 N56 done · 22:14 to 22:38 (1,2,¬3,¬4) mirror half on 2 cores · 22:38 N52 stopped
through `STOP`, logs copied after the processes had exited.

## 5. Surprises and next steps

1. At n = 52 the cost within a level-1 cube is very uneven. In (1,2,3,4), g(2) ∈ {0, 2, 3, 4} cost about 150 s
   each, while g(2) ≥ 5 cost 1800 to 4500 s each. The other roots' sampled leaves are 5 to 10 times cheaper than
   (1,2,3,4)'s.
2. n = 56 is clearly harder at level 1 (7 of 9 cubes open at 600 s, against 5 of 9 at 400 s for n = 52).
3. Next: run the N52 shards (N52 REPORT §5). With 4 cores, that is about 16 h without the lemma, or about 8 h
   with it. Then run the N56 tree with the same commands (`N56/REPORT.md` §4).
4. Process note: `pgrep -f '<pattern>'` inside a `bash -c` wait loop matches the loop's own command line. That
   delayed the N52 start by a few minutes. Use a bracketed pattern (`[s]rc/tree.py`) and keep it out of the
   rest of the command.
