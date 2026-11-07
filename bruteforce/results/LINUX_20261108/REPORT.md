# Bounded Linux continuation, 8 November 2026

Starting revision: `26b47d3dbbb621d223ab5348ee5919517882af6c`, branch
`research-2026-11-07`. The user authorized local computation until approximately
06:00 Korea time, with low resource use. This run uses CPUs 30 and 31 only,
niceness 19 and idle I/O priority. There is one cyclic proof worker and one
construction worker. Search stops at 05:50 KST; final verification ends by
05:58; a separate watchdog enforces the 06:00 hard stop (7 November 21:00 UTC).
No model session is needed for shutdown or the final scoped Git checkpoint.

The cyclic task continues n=56, k=14 from 18,191 checked leaves and 578 open
branches in the merged history. Four of nine root cases were closed before
this run. The exact cyclic n=43 result is already finished on the Mac and is
not repeated. Earlier proof archives remain on the other computer; recorded
historical verdicts are accepted here only after regenerating matching CNF
hashes. New proofs are checked locally by native drat-trim and retained in
`cyclic/proofs`, outside Git, with a 20 GB run quota. Solvers have a 3 GiB
address-space limit and a 2 GiB per-file limit.

The constructor searches n=26 through 128 using the merged November 7 lower
bounds, explicit pendant padding, 45 saved search states and 18,262 distinct
restricted-neighborhood UNSAT cache keys. Its address-space limit is 1 GiB.
These cache entries only describe restricted moves, not global upper bounds.
All 168 baseline/search-state certificates passed the C four-set checker;
positive SAT and negative checked-UNSAT controls passed before launch.

Run configuration, input hashes and native tool provenance are recorded in
`config.json`, `source-manifest.json` and `tools/manifest.json`. The controller
is `src/run.py`; its independent watchdog uses `--watchdog`. Creating a file
named `STOP` in this directory requests an orderly stop and final checks.
Current status is in `logs/status.json`. New lower bounds must pass both the
C four-set checker and the independent Python common-neighbor checker before
appearing in the final verified table.

At shutdown, `FINAL-COMPUTE-REPORT.md`, `logs/final-summary.json`,
`verified/improvements.json` and `cyclic/logs/final-closecheck.txt` record the
outcome. The controller attempts a commit and push scoped to this directory;
`logs/git-checkpoint.log` records success or failure locally. A partial cyclic
search is not an upper-bound proof. No unrestricted solution, published-record
claim, or historical-priority claim is made.

Analytic work for this session belongs under `analytic/`. Its mathematical
assumptions and literature comparisons must be stated separately from these
finite computational certificates.
