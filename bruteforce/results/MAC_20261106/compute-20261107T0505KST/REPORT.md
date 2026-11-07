# Erdős 810: autonomous Mac continuation

Final checkpoint. Updated 2026-11-06T23:57:19.775234+00:00.

Continued from the completed evening Mac run (17 additional improved sizes). This run
counts only gains beyond that final verified checkpoint. Earlier results,
including the certified 43-vertex cyclic optimum, are preserved unchanged.

**31 newly improved sizes**, with a total edge-count gain of **265** over the prior bounds, all verified by independent C four-set
and Python common-neighbor cycle enumerations with identical counts.
Certificates and immutable source snapshots are in [verified/](verified/).

| Vertices | Previous bound | New bound | Gain |
|---:|---:|---:|---:|
| 66 | 997 | 998 | +1 |
| 67 | 1015 | 1019 | +4 |
| 68 | 1028 | 1037 | +9 |
| 69 | 1029 | 1055 | +26 |
| 70 | 1050 | 1072 | +22 |
| 71 | 1069 | 1092 | +23 |
| 72 | 1090 | 1112 | +22 |
| 73 | 1111 | 1130 | +19 |
| 74 | 1133 | 1138 | +5 |
| 80 | 1301 | 1303 | +2 |
| 81 | 1321 | 1325 | +4 |
| 85 | 1457 | 1458 | +1 |
| 86 | 1480 | 1481 | +1 |
| 87 | 1502 | 1505 | +3 |
| 88 | 1503 | 1509 | +6 |
| 93 | 1687 | 1688 | +1 |
| 94 | 1712 | 1713 | +1 |
| 95 | 1736 | 1739 | +3 |
| 100 | 1919 | 1921 | +2 |
| 101 | 1946 | 1948 | +2 |
| 102 | 1972 | 1974 | +2 |
| 103 | 1998 | 2000 | +2 |
| 104 | 2012 | 2019 | +7 |
| 105 | 2019 | 2026 | +7 |
| 106 | 2024 | 2031 | +7 |
| 111 | 2189 | 2197 | +8 |
| 115 | 2325 | 2341 | +16 |
| 116 | 2328 | 2370 | +42 |
| 117 | 2361 | 2369 | +8 |
| 123 | 2617 | 2625 | +8 |
| 126 | 2749 | 2750 | +1 |

## Final cyclic result

The n=56, k=14 search added **7,733 checked UNSAT leaves**, bringing the
combined history to **18,191 checked leaves**. Coverage still has **578 open
branches**; the increase from 430 reflects subdivision, not a completed proof.
All 7,733 retained new proof hashes passed the final audit, with no checker errors
or unverified UNSAT records. The known 13-orbit, 728-edge witness remains valid.
See [coverage](cyclic/logs/final-closecheck.txt) and
[audit](cyclic/logs/final-audit.json).

New compressed proof archives occupy **43,212,025,174 bytes** and remain on the
local Mac under `cyclic/proofs/`. They are excluded from Git. The published logs
and hashes record the completed checks; replaying them requires those archives
and the earlier retained evidence. A Git clone alone does not contain the proof
archives. Graph certificates and both graph checker outputs are included.

## Search changes

- One-vertex SAT search now caches exhausted identical neighborhoods and
  explores valid equal-edge-count rearrangements to escape local optima.
- Deletion/recoloring retains equal-count intermediate graphs in private
  search chains. Only strict independently checked gains are published.
- The 56-vertex cyclic search begins with 10,458 checked leaves and 430 unresolved branches. The five
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

Search cutoff: **7 November 2026, 08:55 KST / 6 November 23:55 UTC**.
Final consolidation: **08:57 KST**, with verification capped at five minutes.
The cyclic audit ends by **09:03 KST**. All final work ends by **09:05 KST**.

This bounded batch uses fresh random seeds, resumes cached exhausted
neighborhoods and saved equal-size graphs, and focuses the four constructor
workers on sizes 57–128 where recent strict gains occurred.

The search stopped at 08:55 KST and final audits completed at 08:57 KST.
Sampled total CPU averaged 87.14% in the cyclic monitor; the sampled peak
was 100%, so the 95% target was not a strict instantaneous cap. The last CPU
sample lists five active children before shutdown and is not a live process count.
This is a completed run with no recurring schedule. Source files retain their
executed bytes and historical deadlines for provenance.

## Continue on another computer

- Start from this committed, frozen run: sources, graph certificates, checker
  outputs, cyclic logs, and saved search states are included. Create a new run
  directory so this evidence remains unchanged.
- Build the new graph baseline by merging `constructions/baseline.json` with
  `verified/certs.json`, retaining the larger certificate for each size. Resume
  the constructor states in `constructions/worker*/plateau-n*.json` and the
  `unsat-neighborhoods.json` caches; merge the caches if repartitioning workers.
- Resume cyclic coverage from **18,191 checked leaves and 578 open branches**,
  using the recorded history and new-leaf logs. The latest **43,212,025,174 bytes**
  of compressed proofs remain on this Mac in `cyclic/proofs/`; transfer these
  and the prior proof archives if you want to replay all recorded proof checks.
  The committed logs and hashes alone do not contain those proofs.
- Native binaries are excluded. Compile the required search/checker binaries
  on the destination and adapt executable paths, data paths, and CPU monitoring
  to that machine. The saved supervisors contain absolute Mac paths and expired
  deadlines: prepare a fresh bounded run with new deadlines and resource limits
  before launching it.

## Included earlier Erdős #810 work

This handoff branch also includes the earlier SAT checkpoint records under
`bruteforce/results/RESUME_20261106/` and the saved Claude-era source, notes,
formalization snapshots, and small verification logs under
[`research/local-progress/`](../../../../research/local-progress/).
The archive's 249 manifest-listed files were checked against the local originals;
all SHA-256 values match. See the archive's
[manifest](../../../../research/MANIFEST.json) and
[index](../../../../research/README.md). Archived draft claims retain their
original status and are not newly certified by this publication.
