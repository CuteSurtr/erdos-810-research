# Two-hour cyclic continuation, 6 November 2026

This run starts from **4,430 verified UNSAT leaves** across the earlier
checkpoints. Original logs, reports and proof archives remain untouched.
Cached CNF-prefix hashing validates the reused leaf formulas without
rehashing the old proof archives at startup.

One checker was killed at the previous run's documented 04:40 UTC deadline.
Its solver had reported UNSAT, but its proof was not checked. The copied
history marks that record UNKNOWN. New process wrappers record their own
deadline, wall-time, or controlled-stop reason; interrupted proof checks
remain UNKNOWN and may be subdivided. An invalid proof still stops the run.
Fresh SAT and proof-checked UNSAT controls passed, as did an actual controlled
process-deadline test.

The scheduler balances nine workers across all five open top-level roots
using round-robin queues and per-root concurrency limits. This prevents the
hard `1,2,-3,-4` root from consuming the entire budget. Terminal UNKNOWN
cases are recorded explicitly as unresolved; independent coverage checking
cannot count them as completed proofs.

Each worker runs solver and checker sequentially. The total-CPU guard pauses
our child groups at 93% sampled usage and resumes below 86%; unchanged CPU
counters are ignored. The aggregate proof/work disk budget is 80 GB;
285 GiB were available when checked. No accepted proof is deleted for space.

Search ends by **06:45 UTC** and automatic audit/report by **06:55 UTC**,
within the user's additional two-hour allowance. Status is in
`logs/background-status.json`; distribution across roots is in
`logs/frontier-status.json`. This directory's `STOP`, or the parent shared
run's `STOP`, requests a graceful checkpoint.

The known lower bound remains 13 orbits and 728 edges. No exact n = 56
optimum or unrestricted Erdős #810 solution is claimed without completed
coverage and proof verification.
