# PUSH2 (2026-10-25): work in progress

Checkpoint file; the final report replaces this. Logs in `*/logs/*_snapshot.jsonl` are copies of the
running logs taken at checkpoint time.

- N48M: mirror queue of N48 running (`tree.py 48 12 400 4 ...`, LEAFLOG seeded with N48's logs).
- N52: k = 12 positive control SAT and checked (`N52/control/`); generalised `mktree.py` / `covercheck.py`
  in `N52/src/` reproduce N48's tree and `COVER OK {'unsat': 5075, 'covered': 57, 'internal': 109}`.
