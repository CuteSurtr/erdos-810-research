# Erdős 810: evening Mac continuation

Final checkpoint. Updated 2026-11-06T10:22:14.592455+00:00.

Continued from the completed afternoon Mac run (24 additional improved sizes). This run
counts only gains beyond that final verified checkpoint. Earlier results,
including the certified 43-vertex cyclic optimum, are preserved unchanged.

**17 newly improved sizes**, all verified by independent C four-set
and Python common-neighbor cycle enumerations with identical counts.
Certificates and immutable source snapshots are in [verified/](verified/).

| Vertices | Previous bound | New bound | Gain |
|---:|---:|---:|---:|
| 68 | 1026 | 1028 | +2 |
| 69 | 1027 | 1029 | +2 |
| 81 | 1318 | 1321 | +3 |
| 87 | 1500 | 1502 | +2 |
| 88 | 1501 | 1503 | +2 |
| 94 | 1710 | 1712 | +2 |
| 95 | 1735 | 1736 | +1 |
| 101 | 1945 | 1946 | +1 |
| 102 | 1971 | 1972 | +1 |
| 103 | 1996 | 1998 | +2 |
| 104 | 2010 | 2012 | +2 |
| 105 | 2017 | 2019 | +2 |
| 106 | 2021 | 2024 | +3 |
| 111 | 2187 | 2189 | +2 |
| 115 | 2323 | 2325 | +2 |
| 116 | 2325 | 2328 | +3 |
| 123 | 2615 | 2617 | +2 |

## Search changes

- Construction sizes were prioritized by the number of edges needed for the next extension.
- One-vertex SAT search caches exhausted identical neighborhoods and
  explores valid equal-edge-count rearrangements to escape local optima.
- Deletion/recoloring retains equal-count intermediate graphs in private
  search chains. Only strict independently checked gains are published.
- The 56-vertex cyclic search begins with 8,327 checked leaves and 468 unresolved branches. The five
  unfinished top-level cases share a round-robin queue to prevent starvation.
  Explicit proof-checker timeouts are UNKNOWN and trigger subdivision;
  invalid proofs still halt. [Run notes](cyclic/RUN-NOTES.md),
  [live status](cyclic/logs/background-status.json),
  [automatic cyclic report](cyclic/REPORT.md).

These are construction lower bounds and restricted-family searches.
Unrestricted Erdős 810 remains unresolved by this work.

## Resource limits

Up to fourteen single-thread workers: four construction, nine cyclic,
and one recoloring. The construction controller pauses one worker at a time above 91% sampled
total CPU and resumes below 88%; the cyclic guard pauses one child at a time above 93% and
resumes one below 90%. Recoloring uses a 90%/85% guard. This targets high
utilization with less disruption than pausing whole pools. Prior checked proof archives remain
referenced in place; no completed search is restarted from scratch. Other applications prevent
a strict instantaneous system-wide CPU cap.

Search cutoff: **6 November 2026, 19:20 KST / 10:20 UTC**.
Final consolidation: **19:22 KST**, with verification capped at five minutes.
The cyclic audit has a **19:28 KST / 10:28 UTC** deadline.
All work is bounded by the user’s **19:30 KST / 10:30 UTC** deadline.
Construction consolidation ends by 19:29 KST; recoloring checks end by 19:25 KST.

Stop early with `python3 stop.py` in this directory. Final reports are
written automatically without another model session. No recurring schedule
or publication is configured.

## Final cyclic audit

The new run retained **2,131 checked UNSAT proofs**, all of whose archive hashes
passed the final audit. Combined coverage uses **10,458 checked cases**, with
**430 open branches**, compared with 468 at the start. Four of nine top-level
cases are closed. The 56-vertex cyclic optimum remains unproved.

The independent final review confirmed graph certificate hashes, immutable source
snapshots, matching C/Python cycle counts, and the combined search coverage.
All search stopped at 19:20 KST; final consolidation completed at 19:22 KST.

After the cyclic controller changed to individual-worker pausing, sampled whole-machine
CPU averaged **87.87%**. Short sampled peaks reached **100%**: the requested 95%
target was not a strict instantaneous cap. See [resource-summary.json](resource-summary.json).
