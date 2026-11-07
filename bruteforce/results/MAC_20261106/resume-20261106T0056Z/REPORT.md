# Erdős 810: resumed Mac search

Final checkpoint. Updated 2026-11-06T04:45:22.575957+00:00.

Continued from the completed first Mac run (66 improved sizes). This run
counts only gains beyond that final verified checkpoint. Earlier results,
including the certified 43-vertex cyclic optimum, are preserved unchanged.

**42 newly improved sizes**, all verified by independent C four-set
and Python common-neighbor cycle enumerations with identical counts.
Certificates and immutable source snapshots are in [verified/](verified/).

| Vertices | Previous bound | New bound | Gain |
|---:|---:|---:|---:|
| 37 | 336 | 337 | +1 |
| 43 | 440 | 441 | +1 |
| 47 | 524 | 525 | +1 |
| 48 | 536 | 539 | +3 |
| 56 | 733 | 734 | +1 |
| 57 | 755 | 756 | +1 |
| 58 | 791 | 792 | +1 |
| 68 | 1019 | 1024 | +5 |
| 69 | 1020 | 1025 | +5 |
| 72 | 1088 | 1090 | +2 |
| 73 | 1105 | 1111 | +6 |
| 74 | 1127 | 1132 | +5 |
| 77 | 1223 | 1236 | +13 |
| 78 | 1248 | 1257 | +9 |
| 79 | 1270 | 1279 | +9 |
| 80 | 1290 | 1294 | +4 |
| 81 | 1315 | 1316 | +1 |
| 84 | 1433 | 1434 | +1 |
| 85 | 1451 | 1456 | +5 |
| 86 | 1467 | 1479 | +12 |
| 87 | 1468 | 1497 | +29 |
| 88 | 1496 | 1499 | +3 |
| 92 | 1662 | 1663 | +1 |
| 93 | 1683 | 1687 | +4 |
| 94 | 1702 | 1708 | +6 |
| 98 | 1852 | 1868 | +16 |
| 99 | 1881 | 1893 | +12 |
| 100 | 1907 | 1919 | +12 |
| 101 | 1908 | 1945 | +37 |
| 102 | 1909 | 1968 | +59 |
| 103 | 1938 | 1993 | +55 |
| 104 | 1968 | 2007 | +39 |
| 105 | 1975 | 2014 | +39 |
| 106 | 2017 | 2018 | +1 |
| 108 | 2093 | 2095 | +2 |
| 110 | 2144 | 2167 | +23 |
| 111 | 2178 | 2184 | +6 |
| 115 | 2313 | 2320 | +7 |
| 116 | 2315 | 2322 | +7 |
| 117 | 2360 | 2361 | +1 |
| 123 | 2608 | 2613 | +5 |
| 126 | 2748 | 2749 | +1 |

## Search changes

- One-vertex SAT search now caches exhausted identical neighborhoods and
  explores valid equal-edge-count rearrangements to escape local optima.
- Deletion/recoloring retains equal-count intermediate graphs in private
  search chains. Only strict independently checked gains are published.
- The 56-vertex cyclic search resumes after 327 prior checked leaves.
  Explicit proof-checker timeouts are UNKNOWN and trigger subdivision;
  invalid proofs still halt. [Run notes](cyclic/RUN-NOTES.md),
  [live status](cyclic/boost-20261106T0339Z/logs/background-status.json),
  [automatic cyclic report](cyclic/boost-20261106T0339Z/REPORT.md).

These are construction lower bounds and restricted-family searches.
Unrestricted Erdős 810 remains unresolved by this work.

## Resource limits

Up to fourteen single-thread workers: four construction, nine cyclic,
and one recoloring. The construction controller pauses one worker at a time above 91% sampled
total CPU and resumes below 88%; the cyclic guard pauses above 93% and
resumes below 86%. Recoloring uses a 90%/85% guard. This targets high
utilization with less disruption than pausing whole pools. This expansion was requested at 12:32 KST. A disk
allowance that had stopped the cyclic search was raised, and explicit
coverage checks prevent silent early completion. Other applications prevent
a strict instantaneous system-wide CPU cap.

Search cutoff: **6 November 2026, 13:40 KST / 04:40 UTC**.
Final consolidation: **13:45 KST**, with verification capped at five minutes.
The cyclic and recoloring audits have a **13:50 KST / 04:50 UTC** deadline.
This is within the renewed four-hour compute budget from about 09:56 KST.

Stop early with `python3 stop.py` in this directory. Final reports are
written automatically without another model session. No recurring schedule
or publication is configured.
