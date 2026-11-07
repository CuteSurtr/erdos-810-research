# Linux computation checkpoint, 8 November 2026

Finished 2026-11-07T20:51:02.874641+00:00. Searches are stopped.

29 strict construction improvements, totaling 85 edges
across the table, passed both independent graph checkers. These are lower
bounds relative to the merged November 7 baseline including pendant padding.
No published-record or exact-value claim is made.

| n | Previous bound | New bound | Gain |
|---|---:|---:|---:|
| 68 | 1037 | 1038 | +1 |
| 69 | 1055 | 1057 | +2 |
| 70 | 1072 | 1076 | +4 |
| 71 | 1092 | 1096 | +4 |
| 72 | 1112 | 1116 | +4 |
| 73 | 1130 | 1135 | +5 |
| 74 | 1138 | 1143 | +5 |
| 77 | 1236 | 1237 | +1 |
| 81 | 1325 | 1327 | +2 |
| 88 | 1509 | 1514 | +5 |
| 89 | 1536 | 1539 | +3 |
| 93 | 1688 | 1689 | +1 |
| 94 | 1713 | 1714 | +1 |
| 95 | 1739 | 1740 | +1 |
| 99 | 1893 | 1894 | +1 |
| 102 | 1974 | 1976 | +2 |
| 103 | 2000 | 2004 | +4 |
| 104 | 2019 | 2024 | +5 |
| 105 | 2026 | 2031 | +5 |
| 106 | 2031 | 2036 | +5 |
| 107 | 2065 | 2066 | +1 |
| 108 | 2095 | 2096 | +1 |
| 111 | 2197 | 2198 | +1 |
| 112 | 2228 | 2229 | +1 |
| 116 | 2370 | 2372 | +2 |
| 117 | 2371 | 2376 | +5 |
| 123 | 2625 | 2633 | +8 |
| 124 | 2661 | 2665 | +4 |
| 126 | 2750 | 2751 | +1 |

The n=56 cyclic continuation added 1005 checked UNSAT leaves.
Retained-proof hash audit: 1005 of 1005 checked, 0 errors.
Hash-audit time budget exhausted: False.
Combined coverage exit: 1; zero means complete coverage.
New SAT records: 0; their witness checks are retained
in the summary and must be inspected before using a positive result.
Earlier Mac proof archives were not copied or replayed here. Their recorded
verdicts are trusted only after matching leaf CNF hashes. Full proof replay
requires those earlier archives in addition to this run's local proofs.

The source of truth is `logs/final-summary.json`, with the coverage report
in `cyclic/logs/final-closecheck.txt`. No unrestricted #810 solution is claimed.
Worker exit codes are retained in the summary; -15 can be the planned
SIGTERM at the search cutoff. Other unexpected exits require inspecting
the worker logs even when all saved certificates pass verification.
