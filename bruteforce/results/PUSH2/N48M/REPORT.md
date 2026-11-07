# PUSH2/N48M: the 57 mirror branches of N48, run directly

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

All computation in this cloud container, 2026-10-25, 16:37 to 18:15 UTC.

## 2. Result

| claim | status |
|---|---|
| all 57 branches left COVERED by N48 are UNSAT, each with cake_lpr-checked LRAT proofs | **proved** |
| each mirror branch agrees with its representative (both UNSAT) | 57 / 57 agree (`logs/mirror_agreement.md`) |
| k = 12 is UNSAT at n = 48 in C1's sym = 3 encoding, **without the u = −1 mirror lemma** | **proved**: `COVER OK {'unsat': 7811, 'covered': 0, 'internal': 166}` |
| hence k_max(48) = 11 < n/4 | **proved**, resting on the encoder (C1 §4), the trivial cover checked by `covercheck.py`, and 7811 cake_lpr verdicts `s VERIFIED UNSAT` |

## 3. Method

- Tools rebuilt at N48's commits: CaDiCaL 3.0.1 (c60730422e75), cake_lpr (a36874a8b750, built from the shipped
  `cake_lpr.S`), `cycenc.c` from N48 `src/` unchanged. Base CNF `cycenc 48 12 3`: sha256
  `8b9bc39b6244b093ed6850b45ccca8ea809ff015eb61141b14e583960fff6cbf`, as required.
- `src/` is a copy of `PUSH/N48/src/`, unchanged.
- LEAFLOG seeded with `PUSH/N48/logs/leaves_wave1.jsonl` + `logs/leaves2.jsonl` (5221 lines), then N48's
  reproduce command:
  `LEAFLOG=/tmp/claude-0/logs/n48m.jsonl python3 src/tree.py 48 12 400 4 -1 1,2,3,4 1,2,3,-4 1,2,-3,4 1,2,-3,-4 1,-2,3,4 1,-2,3,-4 1,-2,-3,4 1,-2,-3,-4`.
  Check on the first cubes taken: the first new line was `PRESPLIT (1,2,3,4,2:1)` (2:1 is the mirror of 2:0),
  followed by its g(3) grandchildren; a script confirmed that every one of the 2762 new lines is in a mirror
  branch (first value-split literal d:a with a > (d−1−a) mod 48). No representative was re-run.
- Mirror children were pre-split on the next offset (tree.py's rule), exactly as their representatives:
  56 new PRESPLIT lines (the 57th mirror branch had already been pre-split during N48, and 30 of its 48
  grandchildren had already been run there) and 2706 new leaves.
- `tree.json` built by N48's `src/mktree.py` (inputs: N48's `leaves_wave1.jsonl` and `logs/leaves_n48m_final.jsonl`,
  which holds the seed lines plus the new ones). Checked by N48's `src/covercheck.py`, and by the generalised
  `../N52/src/covercheck.py 48 12`, with identical output (`logs/covercheck*.txt`).

## 4. Counts and timings

New leaves in this run: 2706, all UNSAT with `s VERIFIED UNSAT`; 22689 s CaDiCaL wall time on 4 parallel jobs
(1 h 38 min wall), max leaf 40 s, 36.9 GB binary LRAT streamed into cake_lpr. Whole tree (`logs/stats.md`):

| root cube | split | checked UNSAT leaves | covered | pending | solver time (s) | max leaf (s) | LRAT streamed (GB) |
|---|---|---|---|---|---|---|---|
| (-1) | - | 1 | 0 | 0 | 16 | 16 | 0.01 |
| (1, 2, 3, 4) | g(2) then g(3) | 2304 | 0 | 0 | 26848 | 40 | 44.94 |
| (1, 2, 3, -4) | g(2) then g(3) | 2022 | 0 | 0 | 21062 | 374 | 38.74 |
| (1, 2, -3, 4) | g(2) then g(4) | 1129 | 0 | 0 | 11407 | 289 | 21.35 |
| (1, 2, -3, -4) | g(2) | 48 | 0 | 0 | 3651 | 193 | 8.87 |
| (1, -2, 3, 4) | g(3) then g(4) | 2304 | 0 | 0 | 10688 | 15 | 16.07 |
| (1, -2, 3, -4) | - | 1 | 0 | 0 | 358 | 358 | 1.01 |
| (1, -2, -3, 4) | - | 1 | 0 | 0 | 136 | 136 | 0.36 |
| (1, -2, -3, -4) | - | 1 | 0 | 0 | 14 | 14 | 0.02 |
| **total** | | 7811 | 0 | 0 | 74179 | | 131.36 |

Per-branch table (57 rows: branch, representative, leaves, time, both results): `logs/mirror_agreement.md`.
All 57 agree with their representative: UNSAT.

## 5. Files

| path | content |
|---|---|
| `src/` | copy of `PUSH/N48/src/` (cycenc.c, leaf.py, tree.py, mktree.py, covercheck.py, check.py, certcheck.py, ...) |
| `tree.json` | full tree: 7811 leaves, every one UNSAT with CNF sha256, proof bytes and cake_lpr verdict |
| `logs/leaves_n48m_final.jsonl` | the LEAFLOG after the run (5221 seed lines from N48 + 2762 new lines), copied after the run ended |
| `logs/covercheck.txt`, `logs/covercheck_generalised.txt` | checker outputs |
| `logs/stats.md`, `logs/mirror_agreement.md` | tables above |

## 6. Notes

The estimate of N48 §6.3 (about 2 h) was right: 1 h 38 min. The mirror subtrees cost about the same as their
representatives (23057 s total for the 57 mirror branches), which is what the symmetry predicts.
