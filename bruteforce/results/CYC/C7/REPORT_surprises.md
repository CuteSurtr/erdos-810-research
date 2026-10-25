## 6. Surprises and next steps

1. **The solver configuration matters more than the cap.** With default settings, kissat and
   CaDiCaL found nothing at 89 (k = 18, 19), 99 (k = 19, 20) or 100 (k = 23) in 400–1500 s. With
   `--sat` (kissat: `--target=2 --restartint=50`), kissat found 89 at k = 17 in 22 s, 99 at
   k = 17, 18, 19 in 21 / 21 / 250 s and 100 at k = 18, 19 in 21 / 44 s, and CaDiCaL `--sat`
   found 68 at k = 14 in 3.6 s. Any further SAT-side search on this family should use `--sat`
   and several seeds.
2. **No n/4 at 68 or 100.** k = 17 at n = 68 and k = 25 at n = 100 were not found, and neither were
   k = 15 at 68 or k = 20+ at 100. The best found k/n drops from 0.239 (n = 46) to about 0.19
   (n = 89..100). This is only a search failure, not an UNSAT result: the hard instances near k/n
   ≈ 0.2 are beyond a 25-minute single-core SAT run at these sizes. The data is consistent with
   k_max(n)/n decreasing, but it proves nothing about it.
3. **D-invariance heuristics.** Forcing (D, g) to be invariant under a multiplier u up to a
   translation T (`cycenc ... U T`) was UNSAT at k = n/4 for n = 28, 32, 36 for every
   u of order ≤ 4 and every T class. Forcing only D to be invariant under u = n/2 − 1 (odd
   d ↦ n/2 − d, even d fixed) is SAT at k = n/4 for n = 28 and 36, but did not reach k = 10 at
   n = 40 within 300 s. It is not a shortcut.
4. **Constraint-level local search** (`src/cycls.c`, min-conflicts on the forbidden-coincidence
   keys) was weaker than SAT (k = 10 at n = 46 against SAT's 11) and was not used for any result.
5. **Process lesson.** A `git pull --rebase` replays your own commits and rewrites their files in
   the working tree. That broke append-mode logs twice here (§4.4). Keep live logs untracked and
   commit snapshots.

**Next steps (exact sharding plan for the open cases).** For each open (n, k), run
`CYCCONF=--sat python3 src/run.py n k 2 kissat <seed> <seconds>` with seeds 1..8 in parallel
(one core each). Encoding takes ≤ 3 s and ≤ 240 MB of DIMACS at n = 100, and kissat uses about
0.8 GB of RAM (CaDiCaL about 1.7 GB). The most informative targets are 46/k = 12 and 57/k = 14
(near the n/4 line, where an UNSAT proof could plausibly finish with `--unsat` given a few CPU-hours,
so add `/tmp/proof.drat` as 7th argument for a DRAT file), then 68/k = 15 and 100/k = 20.
