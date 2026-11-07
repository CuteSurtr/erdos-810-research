# Resumption at 00:56 UTC, 6 November 2026

The previous run retained and audited 327 new UNSAT proofs before stopping
on a checker timeout. For cube `1,2,-3,-4,2:5,-5,-6`, CaDiCaL reported UNSAT
after 48.4 seconds; drat-trim returned exit code 0 but printed `s TIMEOUT`
at its 180-second limit. That was an incomplete verification, not an invalid
proof or an established UNSAT leaf.

This isolated run preserves all previous sources, logs, reports and proof
archives. `logs/prior-run-normalized.jsonl` copies the previous leaf log,
changing only the explicit timeout record to UNKNOWN. The original file's
hash and the affected cube are recorded in `logs/history-normalization.json`.
The runner skips the 327 verified leaves and splits the failed cube into
its orbit-7 present/absent children.

New leaves use a 30-second solver limit and a 300-second checker limit.
Only an explicit, unambiguous `s TIMEOUT` checker status becomes UNKNOWN
and is subdivided. Missing or invalid verification remains fatal. Five
classification cases passed; the historical timeout's resumed children
were checked; fresh SAT and proof-checked UNSAT controls passed.

There are three workers. Each runs solver, checker and compression
sequentially. The CPU guard pauses our child groups at 70% sampled total
usage and resumes below 55%. Search stops by **04:40 UTC** and the automatic
final audit/report by **04:50 UTC**. The wrapper also has an external
deadline watchdog. Either this directory's `STOP` file or the parent run's
`STOP` requests a graceful checkpoint.

New checked proofs are retained under `proofs/`; their hashes and precise
CNF hashes are recorded with each leaf. The final coverage check separates
historical evidence from this run's fresh proofs. The known lower bound
remains 13 orbits, 728 edges. No complete n = 56 optimum is claimed unless
the final coverage and verification checks establish it. Nothing here
settles unrestricted Erdős #810.
