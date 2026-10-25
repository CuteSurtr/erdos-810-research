# Task PUSH2 (2026-10-25): remove the mirror lemma at n = 48, then n = 52 and 56 at k = n/4

One routine does three jobs in priority order. Results go in `bruteforce/results/PUSH2/<JOB>/`, with
JOB one of `N48M`, `N52`, `N56`, and the summary goes in `bruteforce/results/PUSH2/REPORT.md`.
Wrap up by **23:00 UTC on 2026-10-25**.

**Background.** Read these first:
- `results/PUSH/N48/REPORT.md` (method, tree, mirror lemma §4.3, reproduce command §5, next steps §6);
- `results/PUSH/N48/src/` (`tree.py`, `leaf.py`, `mktree.py`, `covercheck.py`, `cycenc.c`, `check.py`,
  `certcheck.py`);
- `results/CYC/C1/REPORT.md` §4 (encoder and lex-leader soundness);
- `tasks/CYC.md` (the family).

## Rules

The README rules apply:
- git identity CuteSurtr, plain commits with no AI trailers, push to `bruteforce-2026-10` with rebase retries;
- checkpoint at least every 45 min;
- do not end your turn while jobs run.

**Proofs.** Every UNSAT claim needs a proof checked by a standard checker. Use CaDiCaL LRAT streamed into
cake_lpr, exactly as N48 did, and accept only the verdict line `s VERIFIED UNSAT`. Build CaDiCaL, cake_lpr and
`cycenc` from the same commits as N48 (N48 REPORT §4.1). Record per leaf: the CNF sha256, solver and version,
time, LRAT bytes streamed, and the verdict.

**Logs.** Keep running logs (`LEAFLOG`) outside the repository, and copy them into the results folder only at
checkpoints. Never commit a file that a running process writes. N48 and N44C both lost output that way.

**SAT results.** Decode every SAT model and check it with both `check.py` and `certcheck.py`. Commit it
immediately as `certs.json` and `solutions.json` in the job folder.

## Job 1: N48M, run the 57 mirror branches of N48 (do this first)

N48 left 57 branches COVERED by the u = −1 mirror lemma (N48 REPORT §4.3 and §6.3):
- 24 in (1,2,3,4);
- 10 in (1,2,3,¬4);
- 23 in (1,¬2,3,4).

**Steps.**
1. Rebuild the tools and the base CNF `cycenc 48 12 3`. Its sha256 must be `8b9bc39b…6cbf` (N48 §4.1).
2. Seed `LEAFLOG` with `results/PUSH/N48/logs/leaves_wave1.jsonl` and `logs/leaves2.jsonl`, then re-run N48's
   reproduce command. `tree.py` skips resolved cubes, so only the mirror queue should run. Check this on the
   first few cubes it takes.
3. Mirror children are pre-split on the next offset, exactly as their representatives were.

**Outcome.** Build `tree.json` with `mktree.py` (copy N48's `src/` into `PUSH2/N48M/src/`). The new
`covercheck.py` run must report **`'covered': 0`**. Then k_max(48) = 11 rests only on the encoder and the
trivial cover, with no symmetry lemma.

Also report, for every mirror branch, whether its result agrees with its representative's. Every one is
expected to be UNSAT.

## Job 2: N52, n = 52 and k = 13 (= n/4)

The best known solution has k = 12 (624 edges, `CONSTR/certs.json`), so k = 13 is open.

1. **Generalise the scripts.** Make `mktree.py` and `covercheck.py` take n and k as arguments; H = ⌈n/2⌉ − 1
   (25 here). Re-run the generalised `covercheck.py` on N48's tree, and on the N48M tree, to show it gives the
   same output as before.
2. **Positive control.**
   - Build `cycenc 52 12 3`, solve it, and check the model.
   - Run the k = 13 base CNF `cycenc 52 13 3` through the 9 level-1 cubes with `tree.py 52 13 400 4 …`.
   - The roots are the same as N48's: {¬1} and {1, ±2, ±3, ±4}.
   - The ¬p1 cube is the case "D = the 13 non-units in 1..25", a single solve.
3. **Mirror branches** go to the low-priority queue as in N48. Run them only after all representatives are
   closed, and report any left COVERED.
4. **If a leaf is SAT,** k_max(52) = 13 = n/4.
   - Stop the n = 52 tree (`STOP` file).
   - Verify and commit the certificate.
   - Report it prominently and move on to Job 3.

## Job 3: N56, n = 56 and k = 14 (= n/4), only after Job 2 closes or finds SAT

The best known solution has k = 13 (728 edges, `CYC/C4/certs.json`). Repeat Job 2 with n = 56, k = 14, H = 27.
- If Job 2 is still running at 21:00 UTC, run only the n = 56 positive control and the 9 level-1 cubes with a
  600 s cap, on the cores that Job 2 does not need. Report what closed.

## Report

`results/PUSH2/REPORT.md`, plus one `REPORT.md` per job folder. Include:
- for each n: the tree shape, leaf counts (UNSAT verified / COVERED / open) and the `covercheck.py` output;
- solver and check time, and LRAT volume;
- any SAT certificates;
- for an unfinished tree: the open cubes, and an estimate of the remaining cost.

State each claim's status: *proved* (every leaf verified, cover checked), *proved modulo the mirror lemma*,
or *open*.
