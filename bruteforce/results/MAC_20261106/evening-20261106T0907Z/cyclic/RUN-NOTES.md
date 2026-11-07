# Evening cyclic continuation, 6 November 2026

Resumed from **8,327 verified leaves** and the prior coverage checkpoint's
468 open branches. Existing reports, logs and proof archives remain in
place. Cached CNF-prefix hashes validate reused cases; old proof archives
are not rehashed at startup. Fresh SAT and proof-checked UNSAT controls
passed before launch.

Nine single-threaded solver/checker workers are balanced round-robin across
the five open top-level roots. Previously proved cases are skipped.
Explicit checker timeouts and controlled deadline interruptions remain
UNKNOWN. Terminal UNKNOWN cases are recorded as unresolved. Invalid proof
verification remains fatal; independent coverage checking cannot promote
an uncovered branch to a closed one.

The CPU guard pauses one child at a time at 93% sampled total usage and
resumes one below 90%, ignoring unchanged CPU counters. Pause selection
rotates across workers; paused PID state is cleaned when processes finish. The aggregate archive/work
budget is 80 GB; 259 GiB were free when checked. No accepted proof is deleted
for space.

Search stops by **10:20 UTC / 19:20 KST**. The automatic audit verifies the
hashes of every newly accepted compressed proof and writes its report by
**10:28 UTC / 19:28 KST**, before the user's 19:30 KST deadline. The report
distinguishes verified coverage from unresolved cases and historical inputs.

Live files are `logs/background-status.json`, `logs/cpu-status.json` and
`logs/frontier-status.json`. This directory's `STOP`, or the parent shared
run's `STOP`, requests a graceful checkpoint.

The known lower bound remains 13 orbits and 728 edges. No completed cyclic
optimum or unrestricted Erdős #810 solution is currently claimed.

## Individual-child guard restart

The original whole-pool guard was checkpointed after 420 new checked leaves.
All 420 retained proof hashes passed the checkpoint audit. The replacement
uses individual child pausing instead of stopping the whole pool. Its
process-signal controls and independent source audit passed; all 8,747
verified cases were reused without replay. Sources and the completed
checkpoint report are preserved under
`logs/checkpoint-individual-guard-20261106T0919Z/`.
