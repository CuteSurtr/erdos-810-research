# CYC/C0: exact optima of the cyclic orbit family for n = 37, 40, 47, 58, 69, 72, 79, 90

## 1. Placement

```
$ uname -a; nproc; free -g
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

All computation ran in this cloud container (4 cores, 15 GB). Wall time was 05:13–10:05 UTC
on 2026-10-25.

## 2. Results

k_max(n) is the largest |D| for which some g makes every 4-cycle rainbow. The graph then has
n·|D| edges and uses n colours.

| n | n mod 4 | k_lo (found) | k_unsat (first UNSAT) | status | k_lo/n | edges n·k_lo |
|---|---|---|---|---|---|---|
| 37 | 1 | 9 | 10 | **k_max = 9, proved** (UNSAT at 10, DRAT verified) | 0.2432 | 333 |
| 40 | 0 | 10 | 11 | **k_max = 10 = n/4, proved** (UNSAT at 11, DRAT verified) | 0.2500 | 400 |
| 47 | 3 | 11 | N47KUNSAT | N47STATUS | 0.2340 | 517 |
| 58 | 2 | 13 | – | k_max ≥ 13 certificate-verified; 14 open (3 runs × 21–25 min) | 0.2241 | 754 |
| 69 | 1 | 14 | – | k_max ≥ 14 certificate-verified; 15 open (6 runs, up to 25 min) | 0.2029 | 966 |
| 72 | 0 | 15 | – | k_max ≥ 15 certificate-verified; 16 open (5 runs, up to 30 min); **k = n/4 = 18 not found** (25 min, unfinished) | 0.2083 | 1080 |
| 79 | 3 | 16 | – | k_max ≥ 16 certificate-verified; 17 open (25 min) | 0.2025 | 1264 |
| 90 | 2 | 17 | – | k_max ≥ 17 certificate-verified; 18 open (2 runs × 20–25 min); 20 far off (annealer stuck at 12 violations) | 0.1889 | 1530 |

**Labels.**
- *Proved:* SAT certificate at k, plus UNSAT at k+1 by kissat with a drat-trim-verified DRAT
  proof of the symmetry-broken CNF.
- *Certificate-verified:* explicit (D, g), re-checked by two independent simple checkers.
- *Open / unfinished:* the solver timed out. No claim is made either way.

**Answers to the central question.**
- k = n/4 holds at n = 40 and is optimal there (proved). This extends the CONSTR pattern
  k_max(28, 32, 36) = 7, 8, 9.
- At n = 72 the best found is 15 = n/4 − 3. k = 16, 17 and 18 were not found. SAT attempts
  at 16 (5 runs, up to 30 min, kissat/CaDiCaL/annealer) and at 18 (25 min) all timed out.
  This is heuristic evidence that n/4 breaks down by n = 72. It is *not* a proof: no UNSAT is
  known for n = 72 at any k ≤ 18.
- k_lo/n falls from 0.243–0.250 at n = 37–40 to 0.189 at n = 90:

| n | 37 | 40 | 47 | 58 | 69 | 72 | 79 | 90 |
|---|---|---|---|---|---|---|---|---|
| k_lo/n | 0.243 | 0.250 | 0.234 | 0.224 | 0.203 | 0.208 | 0.203 | 0.189 |

  The values for n ≥ 58 are lower bounds only. The SAT search clearly gets harder at the
  frontier, so the true ratio could be somewhat higher. The trend is still consistent with
  k_max(n)/n → 0 slowly, and not with k_max ≥ εn for a fixed ε ≈ 1/4.

**Relevance to M(n).** These are also lower bounds M(n) ≥ n·k_lo. They improve CONSTR's best
overall constructions at two values:
- n = 58: 754 > 702;
- n = 79: 1264 > 1214.

CONSTR had no entries for n = 69, 72 or 90. At n = 47 the cyclic optimum candidate (517) is
one edge below CONSTR's cyclic + local-search graph (518).

### Discrepancy with the task file (not with CONSTR)

The task file's summary table lists k_max = 4 for n = 14–17. CONSTR's own
`cyclic_family_status.json` gives `"14": {"unsat": 4}`, i.e. k_max(14) = 3. My runs agree
with the json:
- k = 4 is UNSAT at n = 14 under all three symmetry settings;
- an independent brute force over all (D, g) with |D| = 4 and g(min D) = 0, using only the
  explicit 4-cycle checker, finds 0 solutions, against 614 at |D| = 3.

So the "14–17: 4" cell in `tasks/CYC.md` should read "14: 3, 15–17: 4". Every other entry
matched.

## 3. Certificates

- `solutions.json`: {n: [[d, g], …]}, the best (D, g) for each n. Orbit d means edges
  {i, i+d mod n} with colour (i + g) mod n.
- `certs.json`: {n: [[u, v, c], …]}, the explicit edge lists, as in README.
- Both are re-verified by `src/check.py` (from (D, g)) and by `src/verify_certs.py`, an
  independent edge-list checker over all ordered 4-tuples. Output is in
  `logs/verify_certs.txt`; all 8 are OK and |E| = n·k_lo.

```
SOLUTIONS_JSON
```

### Validation (CONSTR table, n = 13..30, 32, 36)

SAT at k_max and UNSAT at k_max + 1 under three settings: lex + trans, trans only, and no
symmetry breaking at all. Every SAT model was re-checked explicitly.

VALIDATION_TABLE

"UNKNOWN" means the run was killed after about 230 s. Only the unbroken encoding was killed
(n = 29, 30 at k = 8) to free cores. The lex + trans and trans-only runs both prove UNSAT there.

The proved UNSAT results rely on the encoder. They are backed by the validation above, by
exact solution counts against brute force (§4.2), and by DRAT checks:
- n = 37, k = 10: 138 MB proof, `s VERIFIED` in 142 s;
- n = 40, k = 11: 568 MB proof, `s VERIFIED` in 709 s.

The drat-trim logs are `logs/drat_n37k10.txt` and `logs/drat_n40k11.txt`.
