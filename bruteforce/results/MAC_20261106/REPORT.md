# Erdős 810 continuation — 6 November 2026

Final scheduled checkpoint. Updated 2026-11-05T23:30:32.707998+00:00.

Continued from GitHub `CuteSurtr/erdos-810-research`, latest computational
checkpoint `afac4895bdb646789a051d2227a766a05756609f`. The local worktree's
Git base is older (`445837e`); required latest sources and certificates were
fetched through the GitHub connector. The `MAC_20261106` folder
contains this session's new work. Existing archive files were not revised.

## Verified constructions

**66 sizes improved** relative to the latest checkpoint plus the
repository's other saved constructions and implicit pendant padding.
Every certificate in [verified/certs.json](verified/certs.json) passed both
the C four-set checker and the Python common-neighbor checker, with identical
cycle counts. These are lower bounds for unrestricted M(n), not exact values
or claims of published records.

Methods: one-vertex reinsertion/extension with SAT, and deletion followed by
safe recoloring of one color class. Every accepted SAT model satisfies all
encoded clauses; the independent graph checks are the certificate evidence.
Search timeouts and restricted UNSAT results imply no general upper bound.

| Vertices | Previous saved bound | New bound | Gain |
|---:|---:|---:|---:|
| 32 | 258 | 259 | +1 |
| 33 | 269 | 271 | +2 |
| 34 | 281 | 282 | +1 |
| 35 | 298 | 299 | +1 |
| 38 | 348 | 351 | +3 |
| 41 | 410 | 412 | +2 |
| 42 | 420 | 425 | +5 |
| 43 | 434 | 440 | +6 |
| 46 | 506 | 509 | +3 |
| 47 | 518 | 524 | +6 |
| 48 | 528 | 536 | +8 |
| 49 | 554 | 555 | +1 |
| 50 | 584 | 585 | +1 |
| 51 | 616 | 617 | +1 |
| 54 | 702 | 703 | +1 |
| 55 | 717 | 718 | +1 |
| 56 | 728 | 733 | +5 |
| 62 | 928 | 930 | +2 |
| 63 | 943 | 945 | +2 |
| 64 | 959 | 962 | +3 |
| 65 | 976 | 979 | +3 |
| 66 | 993 | 997 | +4 |
| 67 | 1011 | 1015 | +4 |
| 68 | 1012 | 1019 | +7 |
| 69 | 1013 | 1020 | +7 |
| 71 | 1065 | 1069 | +4 |
| 72 | 1080 | 1088 | +8 |
| 73 | 1095 | 1105 | +10 |
| 74 | 1125 | 1127 | +2 |
| 75 | 1169 | 1170 | +1 |
| 77 | 1217 | 1223 | +6 |
| 79 | 1264 | 1270 | +6 |
| 80 | 1280 | 1290 | +10 |
| 81 | 1314 | 1315 | +1 |
| 84 | 1428 | 1433 | +5 |
| 85 | 1445 | 1451 | +6 |
| 86 | 1462 | 1467 | +5 |
| 87 | 1463 | 1468 | +5 |
| 89 | 1535 | 1536 | +1 |
| 92 | 1656 | 1662 | +6 |
| 93 | 1674 | 1683 | +9 |
| 94 | 1692 | 1702 | +10 |
| 95 | 1734 | 1735 | +1 |
| 98 | 1844 | 1852 | +8 |
| 100 | 1900 | 1907 | +7 |
| 101 | 1901 | 1908 | +7 |
| 102 | 1902 | 1909 | +7 |
| 104 | 1939 | 1968 | +29 |
| 105 | 1965 | 1975 | +10 |
| 106 | 2015 | 2017 | +2 |
| 108 | 2086 | 2093 | +7 |
| 110 | 2137 | 2144 | +7 |
| 111 | 2172 | 2178 | +6 |
| 112 | 2224 | 2228 | +4 |
| 114 | 2278 | 2309 | +31 |
| 115 | 2279 | 2313 | +34 |
| 116 | 2298 | 2315 | +17 |
| 117 | 2350 | 2360 | +10 |
| 118 | 2404 | 2410 | +6 |
| 119 | 2458 | 2462 | +4 |
| 120 | 2512 | 2515 | +3 |
| 122 | 2569 | 2601 | +32 |
| 123 | 2602 | 2608 | +6 |
| 124 | 2659 | 2661 | +2 |
| 126 | 2741 | 2748 | +7 |
| 128 | 2831 | 2832 | +1 |

## Cyclic family

The cyclic-family optimum at **43 vertices is 10 orbits, or 430 edges**.
All 3,705 UNSAT leaves were freshly proof checked, retained, and hash-audited;
independent coverage found zero missing branches. The 430-edge witness has
16,813 four-cycles, all rainbow. This includes replay of the inherited leaves.

The [cyclic directory](cyclic/) records the resumed 43-vertex proof search,
fresh proof replay, coverage checks, and the subsequent 56-vertex search.
Its report distinguishes complete coverage from partial closed cases.
Family upper bounds do not bound unrestricted M(n).

## Written analytic results

- [Low-rank support theorem](analytic/low-rank-supports.md): in the specified
  fixed-degree polynomial affine model, a bounded real rank-r approximation
  with entrywise error R gives
  `m ≤ C_D p^(47/24) r^(1/3) + C p^(3/2) R^(1/4)`.
  Consequently `r=o(p^(1/8))` and `R=o(p²)` imply `m=o(p²)`.
  [Independent audit](analytic/low-rank-supports-audit.md).
- [Hypergraph transfer](analytic/reduction-audit.md): safe attachment of
  isolated blocks removes the old reliance on extremal replacement lemmas
  in `M(n) ≥ 3g(n;7,4) − floor(n/4)`, for n≥7. The stronger per-input
  construction and finite stress checks are included.

These are written proofs with independent hand audits, not Lean certificates.
Historical novelty is unestablished. Unrestricted Erdős 810 remains unresolved
by this work.

## Runtime and stopping

Up to seven single-thread search workers: three construction, three cyclic,
one recoloring. Load monitors pause work above 70% sampled machine CPU and
resume below 55%. The initial nine-worker phase recorded a brief 100% total
CPU sample during concurrent verification; concurrency and thresholds were
then reduced. These controls limit our workload; other applications prevent
a strict guarantee on instantaneous system-wide CPU utilization.
Search cutoff: **6 November 08:25 Korea time (5 November 23:25 UTC)**.
Automatic final consolidation: **08:30 Korea time**. Both precede the user's
four-hour deadline of approximately 08:41 Korea time. No scheduled recurrence,
publication, or GitHub push was installed.

To stop this session's jobs and consolidate early, run `python3 stop.py`
from this directory. Runtime controls and PIDs are in each subdirectory's logs.
