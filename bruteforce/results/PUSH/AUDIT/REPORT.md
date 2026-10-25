# PUSH/AUDIT — independent referee audit of `paper/main.tex`

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

All computation ran in this cloud container on 2026-10-25. Nothing under `paper/` was edited.

## 2. Results

The deliverable is **`AUDIT.md`**: the mathematics line by line, numbers, references and overclaims,
each with exact replacement wording. The table below lists the independent computations that support it.

| check | result | status |
|---|---|---|
| `paper/make_tables.py` re-run in a scratch copy | all 3 outputs byte-identical (sha256 in AUDIT §2.1) | verified |
| all 100 certificates cited in `data/best_lower_bounds.json`, re-checked by an independent checker | 100/100 valid, edge counts match | certificate-verified |
| Lean `cert4`..`cert12` (lean-formalization, read only), re-checked | 9/9 valid | certificate-verified (Lean itself not compiled) |
| Pólya counts (10,31), (11,34), (11,35), (12,41), (13,48) | reproduced by own cycle-index code | proved (exact computation) |
| 6-good classes on 6 vertices = 127; M(6) = 11; M(7) = 14 with 5 extremal classes | reproduced by own explicit-C4 backtracking | proved (exhaustive, own code) |
| cyclic family: k_max(n) and the counts at k_max, n = 12..29 (and k_max+1 empty for n = 12..31), by own brute force | all equal CYCPAT/CONSTR | proved (exhaustive, own code) |
| Lemma 3 on all CYCPAT optimal solutions, n = 20..40 (9 values of n) | all images valid; 9886 distinct images as claimed; the "no +e" variant fails for every u ≠ 1 | verified numerically |
| Proposition 4 (random instances, only g(d1), g(d3) prescribed) | 3286 instances, 0 valid | consistent with the proof |
| n = 47 cube coverage (C0) | 29 cubes cover 512/512 | verified |
| Table 2 monotonicity | **10 rows below the trivial padding bound** | finding [A] |

## 3. Certificates

None are produced; this is an audit. `certs.json` is `{}`.

## 4. Method

See `AUDIT.md`. Every program in `src/` was written for this audit and does not import repo code. The
one exception is `lemma3_check.py`, which reads CYCPAT's solution lists as input data.

## 5. Files

- `AUDIT.md`: the audit.
- `src/`:
  - `cycbrute.c`: cyclic brute force.
  - `cycgroup.py`: explicit checker and multiplier orbits.
  - `lemma3_check.py`, `prop4_check.py`, `certcheck.py`, `leancerts.py`, `polya.py`, `smallgood.py`.
- `logs/`: the outputs of all of the above.

## 6. Surprises

- Table 2 rows at n = 106, 118 and 122 hold about 0.086 n², below half of what the pendant-edge
  padding gives.
- The status column of Table 3 is hard-coded in `make_tables.py`.
