# Compute boost, 6 November 2026

The earlier search reached 2,084 new verified leaves but stopped because its
20 GB aggregate disk limit counted earlier proof archives and temporary
raw solver proofs. Queued unresolved branches were abandoned at that
threshold; after temporary-file cleanup the driver advanced to later roots,
then finished with incomplete coverage.

The limit is now 50 GB; 301 GiB were free when checked. The driver records
its stopping reason. The supervisor rechecks coverage and resumes an
incomplete search when resources and time remain, while fatal proof errors
still stop the run. No accepted proof has been deleted or copied.

An initial eight-worker restart added 116 checked leaves, reaching 2,200.
Its native workers then stopped cleanly at 03:38:40 UTC to load a CPU-monitor
correction: unchanged macOS CPU counters are ignored, rather than interpreted
as zero usage. Its audit continues independently in the parent directory.

This isolated boost reuses all verified checkpoints through those 2,200
leaves, plus earlier history. CNF hashes are checked with cached SHA-256
prefixes; accepted proof archives are not rehashed at startup. Historical
input paths and hashes are in `logs/history-inputs.json`.

The pool has nine workers, temporarily scheduling eight until the preceding
audit finishes. Each worker runs its solver and checker sequentially.
Sampling every 0.25 seconds pauses our active process groups at 93% total
CPU usage and resumes below 86%. The original deadlines remain 04:40 UTC
for search and 04:50 UTC for the automatic final audit/report.

`logs/background-status.json` and `logs/cpu-status.json` show live progress.
Create this directory's `STOP`, or the shared run directory's `STOP`, to
request a graceful checkpoint. The old parent directory's existing `STOP`
belongs only to its completed search and does not stop this boost.
