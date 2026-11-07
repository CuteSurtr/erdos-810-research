Portfolio, 10:39:30-11:09:30 UTC, full sym=3 CNF for n=48, k=12 (sha256 8b9bc39b...cbf), 1800 s each:
cadical 3.0.1 + DRAT, cadical --unsat --seed=2, kissat 4.0.4 default, kissat --sat --seed=1.
Outcome lines LOST: the (empty) log files were committed at 10:43, and the git pull --rebase in the push
replaced them, so the running jobs wrote to unlinked inodes. No process output survived. No SAT model was
recorded anywhere. Treat the portfolio as giving no information. (CYC/C2 had already run a 1500 s
portfolio plus 4671 s of kissat --sat on k = 12 without a result.) From then on all live logs are kept
in /tmp and copied into the repo at checkpoints.
