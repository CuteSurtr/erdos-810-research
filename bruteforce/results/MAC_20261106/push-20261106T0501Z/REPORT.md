# Erdős 810: additional two-hour Mac push

Final checkpoint. Updated 2026-11-06T06:50:16.745589+00:00.

Continued from the completed resumed Mac run (42 additional improved sizes). This run
counts only gains beyond that final verified checkpoint. Earlier results,
including the certified 43-vertex cyclic optimum, are preserved unchanged.

**24 newly improved sizes**, all verified by independent C four-set
and Python common-neighbor cycle enumerations with identical counts.
Certificates and immutable source snapshots are in [verified/](verified/).

| Vertices | Previous bound | New bound | Gain |
|---:|---:|---:|---:|
| 34 | 282 | 283 | +1 |
| 48 | 539 | 541 | +2 |
| 49 | 555 | 556 | +1 |
| 68 | 1024 | 1026 | +2 |
| 69 | 1025 | 1027 | +2 |
| 74 | 1132 | 1133 | +1 |
| 78 | 1257 | 1258 | +1 |
| 79 | 1279 | 1280 | +1 |
| 80 | 1294 | 1301 | +7 |
| 81 | 1316 | 1318 | +2 |
| 85 | 1456 | 1457 | +1 |
| 86 | 1479 | 1480 | +1 |
| 87 | 1497 | 1500 | +3 |
| 88 | 1499 | 1501 | +2 |
| 94 | 1708 | 1710 | +2 |
| 102 | 1968 | 1971 | +3 |
| 103 | 1993 | 1996 | +3 |
| 104 | 2007 | 2010 | +3 |
| 105 | 2014 | 2017 | +3 |
| 106 | 2018 | 2021 | +3 |
| 111 | 2184 | 2187 | +3 |
| 115 | 2320 | 2323 | +3 |
| 116 | 2322 | 2325 | +3 |
| 123 | 2613 | 2615 | +2 |

## Search changes

- One-vertex SAT search now caches exhausted identical neighborhoods and
  explores valid equal-edge-count rearrangements to escape local optima.
- Deletion/recoloring retains equal-count intermediate graphs in private
  search chains. Only strict independently checked gains are published.
- The 56-vertex cyclic search begins with 4,430 checked leaves. The five
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
total CPU and resumes below 88%; the cyclic guard pauses above 93% and
resumes below 86%. Recoloring uses a 90%/85% guard. This targets high
utilization with less disruption than pausing whole pools. Prior checked proof archives remain
referenced in place; no completed search is restarted from scratch. Other applications prevent
a strict instantaneous system-wide CPU cap.

Search cutoff: **6 November 2026, 15:45 KST / 06:45 UTC**.
Final consolidation: **15:50 KST**, with verification capped at five minutes.
The cyclic and recoloring audits have a **15:55 KST / 06:55 UTC** deadline.
This is within the additional two-hour budget beginning about 14:01 KST.

Stop early with `python3 stop.py` in this directory. Final reports are
written automatically without another model session. No recurring schedule
or publication is configured.
