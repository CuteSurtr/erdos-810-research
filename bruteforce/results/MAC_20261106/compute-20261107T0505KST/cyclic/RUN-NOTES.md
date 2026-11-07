# Autonomous Mac batch, 7 November 2026

Resumed from **10,458 verified leaves** and 430 open branches. Prior logs,
reports and proof archives remain in place. Cached CNF hashes validate the
reused cases without rehashing old proofs. Fresh SAT and proof-checked UNSAT
controls passed.

Nine single-thread workers are balanced across the five open roots. The
individual-child CPU guard pauses one process at 93% sampled total usage
and resumes one below 90%. Timeouts and controlled interruptions remain
UNKNOWN; terminal UNKNOWN cases remain unresolved. Invalid proofs are fatal.

Search stops at **08:55 KST**, automatic proof-hash audit/report at
**09:03 KST**, with the shared hard stop at **09:05 KST** on 7 November.
These deadlines keep the batch within four hours of its 05:05 KST start.
The archive/work limit is 140 GB; 244 GiB were free at setup. Accepted
proofs are retained, and no Git commit or push is performed.

Live status: `logs/background-status.json`; CPU: `logs/cpu-status.json`;
root distribution: `logs/frontier-status.json`. Create this directory's
`STOP`, or the parent shared run's `STOP`, for a graceful checkpoint.

No complete cyclic n = 56 optimum or unrestricted Erdős #810 solution is
currently claimed. Final coverage and new proof hashes are checked
automatically before the final report is written.
