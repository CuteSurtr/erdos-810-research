# Cyclic n = 43: exact optimum 10 orbits

Completed 6 November 2026 (Korea time), continuing GitHub revision
`afac4895bdb646789a051d2227a766a05756609f` and its `RESUME_20261106` checkpoint.

For the cyclic orbit family on `Z_43`, the exact optimum is **10 orbits,
430 edges**. An orbit of difference `d` contains the edges `{i,i+d}`;
its colors are `i+g(d)` modulo 43. This result concerns that family,
not unrestricted `M(43)` or the asymptotic Erdős #810 question.

## Evidence

- The unchanged encoder reproduces the `(43,11,sym=3)` CNF SHA-256
  `67c8465bc7bb834875a8f5fc599579e3e30c3f1946f0a82f5190990faa74b33e`.
- All nine top-level cubes, `-1` and `1,±2,±3,±4`, are closed.
  The independent recursive coverage check uses **3,705 freshly checked
  UNSAT leaves**, 88 internal nodes, and zero open branches. Every branch
  runs; no mirror branch is omitted.
- The prior 399 checked leaves were **all replayed locally**, with new
  retained DRAT proofs. The final coverage check reads only this run's new
  log, so it does not trust historical unretained LRAT streams.
- CaDiCaL 3.0.1 generated the proofs; the native `drat-trim` executable
  checked every proof before its leaf was accepted. Solver/checker exit
  codes, exact leaf-CNF hashes, proof hashes and checker output are recorded.
- All 3,705 compressed proof artifacts were decompressed and hashed again.
  Total raw proof bytes: **8,229,106,486**. Compressed bytes:
  **3,878,812,436**. Hash checks passed; no error or unverified UNSAT record
  appears in the final audit.
- The known ten-orbit witness from `CYC/C5/solutions.json` was checked by
  directly enumerating its four-cycles: **430 edges, 16,813 four-cycles,
  all rainbow**. A representative transformed to satisfy the encoder's
  multiplier and color-translation symmetry constraints also passed a
  fresh SAT control. The negative control was freshly proof checked.

The conclusion still relies on the documented correctness of the existing
`cycenc.c` encoding and its symmetry reduction, and on the executable proof
checker. It is not a Lean-certified result. Historical novelty has not been
established.

## Artifacts and reproduction

`logs/final-audit.json`, `logs/final-closecheck.txt`, and
`logs/n43-lower-bound.json` contain the numerical results. Every leaf record
is in `logs/new-leaves.jsonl`. Local compressed proofs are under `proofs/`;
they are intentionally ignored by Git. `logs/source-tool-manifest.json`
records the source and executable hashes. CaDiCaL's local checkout is at
`c60730422e758ef1cebe7aeddf2dda31c996bf04`.

`src/resume_native.py` regenerates each leaf formula from its recorded cube.
`src/audit_native.py` rechecks all retained uncompressed proof hashes, leaf
formula hashes, the lower-bound witness and fresh-only coverage. Run it
from this repository with `python3 .../cyclic/src/audit_native.py`.
Proofs can additionally be replayed with the recorded native `drat-trim`
against the regenerated formula after gzip decompression.

Four workers executed solver, checker and compression sequentially. The
CPU guard sampled total machine usage every 0.5 seconds, pausing this
runner's active groups at 85% and resuming below 80%; its observed peak
during the main search was approximately 91.7%. The original 5 GB artifact
limit was increased to 20 GB for the combined n = 43 and n = 56 work.

One early file-size scan raced with a completed worker deleting a temporary
formula. The scan was fixed, the run resumed, and all accepted proof hashes
were checked at the end. Its diagnostic remains in `logs/run.log`.

## Bounded n = 56 continuation

`src/background_n56.py` continues the latest `(56,14)` checkpoint with three
workers and a more conservative CPU guard (pause at 70%, resume below
55%). It stops solver work by **23:25 UTC on
5 November** (08:25 KST on 6 November), with a watchdog and final automatic
audit/report by 23:35 UTC (08:35 KST). These are within the user's four-hour
compute allowance. Status is written to `n56/logs/background-status.json`;
the eventual result is `n56/REPORT.md`. It makes no complete upper-bound
claim unless coverage and retained-proof checks succeed.

Create `n56/STOP` to request a graceful checkpoint. No further model session
is required to stop the computation or write its final report.
