# PUSH/N44C: finishing CYCPAT's independent split of n = 44, k = 11

Task: `bruteforce/tasks/PUSH.md` §N44C (committed at 4443afa). Family: `tasks/CYC.md`. Base split and
encoding: `results/CYCPAT/REPORT.md` §4 and §10, `results/CYCPAT/src/cycenum.py`.
All computation ran in this cloud container, 2026-10-25, 10:35–16:00 UTC.

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
nproc: 4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

## 2. Results

| # | Result | Status |
|---|--------|--------|
| R1 | **CYCPAT's split of n = 44, k = 11 is closed under CYCPAT's own (plain) encoding.** It is refined only by further presence splits on the smallest orbits, with no added symmetry breaking. Every leaf is UNSAT, and every leaf has an LRAT proof that cake_lpr verified (`s VERIFIED UNSAT`). So the cyclic orbit family has **no valid (D, g) with \|D\| = 11 at n = 44**: **k_max(44) ≤ 10 < n/4 = 11**. Tree: `tree.json`, 476 closing leaves, all verified, plus vacuous nodes. Leaf table: `leaves.tsv`. | *proved*, given the soundness of CYCPAT's encoding and of its nounit/unit reduction (re-derived and validated by CYCPAT, validated again here, §5). Every UNSAT step is checked by a standard checker (cake_lpr). |
| R2 | **A second, independent closing of the same split**, with symmetry breaking added in the e = 2..7 leaves (§4.3; paper proof plus the checks in §5). This tree closed first, at 12:09 UTC. Tree: `tree_sb.json`, 177 closing leaves, all cake_lpr-verified. Leaf table: `leaves_sb.tsv`. | *proved* (as R1, plus §4.3) |
| R3 | CYCPAT's two unfinished cases, **e = 2 and e = 3, are finished** in both trees. In the plain tree, e = 3 and e = 2 were split by the 3rd, 4th and 5th orbits, and down to the 6th orbit in the dense corner 1, 2, 3, 4/5. CYCPAT's other cases (nounit, e = 4..21) are re-proved with checked proofs. nounit and e = 8..21 used CYCPAT's unsplit CNFs, each in ≤ 99 s; e = 4..7 were split by the 3rd/4th orbit. Note that e ≥ 13 is vacuous: an 11-element D whose two smallest orbits are 1 and e needs 21 − e ≥ 9. | *proved* |
| R4 | **k_max(44) = 10.** The k = 10 solution of CYC/C1 (`[[1,0],[2,17],[3,5],[4,22],[8,1],[11,6],[13,29],[16,25],[18,41],[19,7]]`) was re-checked here as an explicit graph: 440 edges, 17 567 4-cycles, all rainbow (`logs/n44_k10_C1_recheck.json`). | *proved* (upper bound) + *certificate-verified* (lower bound) |
| R5 | **Positive control at n = 40, k = 10** (4 known optimal orbits): the identical sb pipeline finds SAT in exactly the 3 leaves predicted from CYCPAT's enumeration. The decoded models are 3 different orbits; the 4th orbit lives in one of the same 3 leaves, which holds 2 orbits. The other 128 leaves are UNSAT with verified proofs. Every SAT model passes the explicit 4-cycle checker. | *certificate-verified* (control) |
| R6 | DRAT with drat-trim was not usable at this size. On the n = 40 e = 4 case, kissat solved in 420 s with a 774 MB DRAT, and drat-trim had no verdict after 1936 s. CaDiCaL LRAT on the same CNF (same sha256) took 475 s, and cake_lpr verified it in 173 s. So every proof here is LRAT checked by cake_lpr, which the task allows. | measured |

**Answer to step 3 of the task:** yes. CYCPAT's independent split gives **k_max(44) ≤ 10**, hence
k_max(44) = 10. The split is nounit + unit2:e, e = 2..21, refined by presence of the next-smallest orbits.
The result needs no symmetry breaking beyond CYCPAT's own: the multiplier normalisation 1 ∈ D and the colour
translation g(min D) = 0. n = 44 is the first multiple of 4 where k = n/4 fails in the cyclic family. This is
consistent with C1's presence-bit split, which N44A/N44B are finishing with a different encoder.

## 3. Certificates

There are no SAT certificates for n = 44, k = 11 (no solution exists), so `certs.json` is `{}`.
The UNSAT certificates are the LRAT proofs. They were too big to commit (85 GB in total for the plain tree, at
most 3.26 GB each) and were deleted after cake_lpr verified them. Each one can be regenerated:
- the CNF is deterministic, and its sha256 is recorded per leaf;
- CaDiCaL 3.0.1 is deterministic for a given CNF and options.

For every run, `results.jsonl` records: case, CNF sha256, solver and version, solve time, LRAT size in bytes,
the cake_lpr verdict line, check time and solver exit code (from 13:05 on). `leaves.tsv` and `leaves_sb.tsv`
list the closing leaves of each tree.

The n = 40 control models (explicit (D, g), re-verified) are in `sat_models.jsonl`.

## 4. Method

### 4.1 Encoding and CNF export

`src/cnfexport.py` builds the clause set of CYCPAT's `cycenum.py`, which it imports for the 4-cycle keys:

- the same variables in the same pool order;
- the same y-auxiliaries, at-most-one constraints (sequential counter) and Σp = k (totalizer);
- the same translation fix g(min D) = 0.

It writes DIMACS. The enumeration loop of `cycenum.py` only adds blocking clauses on top of this formula, so
"case has no solution" ⇔ "case CNF is UNSAT".

Cases:
- `nounit`: D contains no unit;
- `unit2:e` (exactly as CYCPAT);
- `pre:P`: 1 ∈ D, g(1) = 0, and the |P| smallest orbits of D are exactly P;
- `sb:P`: `pre:P` plus the symmetry breaking of §4.3.

`pre:1.e` ≡ `unit2:e` and `pre:1.e.f` ≡ `unit3:e:f`; both identities were checked clause for clause.

### 4.2 Cover argument

- **nounit ∪ unit.** If D contains a unit u, the multiplier u⁻¹ maps orbit u to orbit 1. Colour translation then gives g(1) = 0. Both are in the symmetry group G (CYCPAT §4).
- **unit = ∪_{e=2..21} unit2:e.** e is the second-smallest orbit, which exists since k ≥ 2.
- **pre:P = ∪_{x = max P + 1..H} pre:P+[x]** for |P| < k. The next orbit exists since |D| = k > |P|.
- **Vacuous nodes.** A prefix P with |P| + (H − max P) < k contains no D, since there are not enough orbits above max P. These nodes are closed without a solver; many were also run, and are UNSAT.
- `src/tree.py n k mode out.json` rebuilds the whole tree from `results.jsonl`. It checks that every internal node has all of its children, and that every leaf is either vacuous or a verified UNSAT case. Mode `plain` accepts only `unit2:e`, `pre:P` and `nounit`; mode `sb` accepts `sb:P`, `unit2:e` and `nounit`.
- Output for n = 44, k = 11: `{"closed": true, "open": [], "n_open": 0}`, in both `plain` mode (`tree.json`) and `sb` mode (`tree_sb.json`).

### 4.3 Symmetry breaking in the `sb:P` leaves (soundness)

Let S = (D, g) be a valid solution with a unit in D. For each unit d ∈ D, the multiplier d⁻¹ followed by
re-translation gives another valid solution S_d whose orbit set is D_d = {rep(x·d⁻¹) : x ∈ D}, with 1 ∈ D_d.
This is the action of G (CYCPAT §4, CYC.md).

Let T be the S_d whose sorted orbit sequence is **lexicographically least**. T lies in exactly one leaf,
whatever that leaf's depth m: the one given by its first m orbits. The leaf `sb:P` adds two rules.

- **(a) Unit lex rule.** Forbid every unit d ∈ D whose D_d has its first m orbits lex-smaller than P.
  - The condition is a disjunction over j of: d ∈ D; rep(P_i·d) ∈ D for i < j; no y ∈ D with rep(y·d⁻¹) in a gap below P_{j−1}; and some x ∈ D with P_{j−1} < rep(x·d⁻¹) < P_j.
  - Each disjunct becomes one clause over the p-variables.
  - T satisfies (a): T_d is again some S_{d′}, and if T_d's first m orbits were lex-smaller than P, then T_d's whole sequence would be lex-smaller than T's.
  - Because the argument compares whole sequences, it is sound even though leaves have different depths m (3, 4, 5, 6).
- **(b) The multiplier −1.** −1 maps every orbit d to itself with sign −1, so g′(d) = d − g(d). Re-translating so that g′(1) = 0 gives g″(d) = d − 1 − g(d).
  - It fixes D, hence it fixes the leaf and preserves (a).
  - With e = P_2, the leaf forbids g(e) = a whenever (e − 1 − a) mod n < a.
  - Either T or its −1 image satisfies (b).

So every G-orbit of solutions with a unit has a representative satisfying its leaf's sb clauses.
Plain leaves (`unit2:e`, `pre:P`, `nounit`) carry no extra clauses.

### 4.4 Solver and checker

- **Solver:** CaDiCaL 3.0.1 (GitHub `arminbiere/cadical` @ c607304), `-q --lrat=true`, with binary LRAT output.
- **Checker:** cake_lpr (GitHub `tanyongkiam/cake_lpr` @ a36874a, built from the shipped `cake_lpr.S` with gcc).
  - Heap: initially the default 4 GB. From 13:20 it was set to 2.5 × the proof size, clamped to 1.5–6.5 GB, with one retry at 6.5 GB, and at most 2 checkers at once.
  - Only the verdict line `s VERIFIED UNSAT` counts.
  - The largest verified proof is 3.26 GB (`pre:1.2.3.4.6`).
- **Also built:** kissat 4.0.4 (@ 8af8e56) and drat-trim (@ 2e3b2dc), used only in the trials of R6.
- **Pipeline:** `src/run_case.sh` exports the CNF, records its sha256, then solves. The cap was 2400 s for the sb tree and 900 s for the plain tree. It then checks the proof (UNSAT), or decodes the model and checks it explicitly (SAT), and appends one JSON line to `results.jsonl`.
- **Workers:** `src/worker.sh` takes lines of `queue.txt` under mkdir locks; 3–4 workers ran.
  - When a prefix case ends without a verified verdict, the worker queues all of that case's children automatically.
  - Whatever happens to a run, the tree stays a complete cover.
  - `src/reorder.py` keeps the queue ordered so that subtrees close one at a time.
- **Further splits in the sb tree:**
  - `sb:1.2.3.4` hit the cap (UNKNOWN at 2400 s, 6.1 GB of LRAT).
  - Its child `sb:1.2.3.4.5` solved in 873 s, but cake_lpr was killed by the memory cgroup on the 2.5 GB proof. So it was closed by its own children `sb:1.2.3.4.5.x`, which all verified.
- **Operational problems (all fail-safe, none can produce a false "verified"):**
  1. **Memory.** The 15 GB memory cgroup OOM-killed cake_lpr 3 times when several large checks overlapped. Those leaves were re-split.
  2. **Lost solver output.** Between 12:16 and 13:40, I committed checkpoints containing in-progress solver logs. The rebase during push then replaced those files with new inodes, and cadical's final `s UNSATISFIABLE` line went to the unlinked file. Those runs were recorded as UNKNOWN (two show `solver_rc: 20`) and re-split, so this only cost time.
     - Fix: running logs now live in the git-ignored `cnf/`, appends to `results.jsonl` take a lock, and `src/checkpoint.sh` commits under that lock.
     - I checked afterwards that every taken case has a result line, except the 3 runs I killed by hand at 12:29, whose subtrees were covered by the auto-split.

### 4.5 Totals

| tree | closing leaves (all `s VERIFIED UNSAT`) | solve s (closing leaves) | check s | max LRAT | LRAT written (closing leaves) |
|---|---|---|---|---|---|
| plain (`tree.json`, R1) | 476 | 18 932 | 12 434 | 3.26 GB | 85.1 GB |
| sb (`tree_sb.json`, R2) | 177 | 3 286 | 1 459 | 1.89 GB | 10.9 GB |

All n = 44 runs together: 943 runs, 927 verified UNSAT. The remainder are 12 UNKNOWN (caps, killed or
lost-output runs, all re-split) and 4 UNSAT runs without a verdict (checker OOM or a stale kissat trial, all
superseded). Total solve time was 31 882 s and total check time 17 034 s, on 4 cores, 11:20–15:20 UTC.
No n = 44 case was ever SAT.

## 5. Validation

1. **Cover test at n = 40** (`src/validate_cover.py`): checks every one of the 64 G-images of CYCPAT's 4 optimal orbits.
   - Each image with 1 ∈ D is SAT in its own `unit2:e` and `unit3:e:f` CNF under assumptions fixing (D, g).
   - Each such image is UNSAT in every other `unit2:e` CNF.
   - Every orbit has an image inside some case.
   - Result: 0 failures.
2. **Soundness of the sb rules** (`src/validate_sb.py`): for each complete enumeration, it tests every unit-normalised image against its `sb:P` leaf. Every orbit must keep at least one surviving image.

   | n, k | depth | orbits | unit-normalised images | survive sb | orbits lost |
   |---|---|---|---|---|---|
   | 28, 7 | 2 / 3 / 4 | 285 | 1758 | 551 / 387 / 317 | 0 |
   | 32, 8 | 4 | 128 | 1050 | 138 | 0 |
   | 36, 9 | 4 | 59 | 346 | 67 | 0 |
   | 40, 10 | 2 / 3 | 4 | 30 | 10 / 5 | 0 |

3. **End-to-end positive control at n = 40, k = 10** (R5; `logs/control40.json`, `tree_n40_control.json`).
   - It ran the same tree shape: e = 2, 3 at depth 4; e = 4..7 at depth 3; e ≥ 8 and nounit plain.
   - Predicted SAT leaves: {`sb:1.2.3.5`: orbit 0, `sb:1.2.5.6`: orbit 1, `sb:1.2.3.4`: orbits 2, 3}. Found SAT: exactly these 3.
   - The decoded models are orbits 0, 1, 2. Each passes `src/decode_check.py`, which builds the explicit graph and checks every 4-cycle by brute force over vertex 4-tuples: 400 edges, about 17 000 4-cycles, 0 bad.
   - The other 128 leaves are UNSAT with cake_lpr-verified proofs.
4. **Pipeline check:** the n = 40 e = 4 case is UNSAT, as CYCPAT found, with a verified LRAT (R6).

## 6. Timeline

- **10:38–11:20: plain depth-3 leaves with kissat/DRAT.** Too slow to check, so abandoned (`logs/aborted_plain_leaves.jsonl`, `logs/kissat_drat_trials.jsonl`).
- **11:20–12:09: sb tree.** Depth 4 for e = 2, 3, depth 3 for e = 4..7, plain for e ≥ 8 and nounit. Closed at 12:09.
- **12:10–12:15: n = 40 positive control.** Matched the prediction.
- **12:15–15:20: plain re-proof.** Closed, in the order e = 7, 6, 5 (12:40–12:50), e = 4 (13:30), e = 3 (13:58), then e = 2 (f ≥ 5 by 14:30, f = 4 by 14:53, f = 3 by 15:20).
  - The dense corner needed depth 6: prefixes 1, 2, 3, 4, 5 and 1, 2, 3, 5, 6 were split once more.
  - The slowest plain leaves took 890–900 s (`pre:1.2.3.4.6`, `pre:1.4.5.6` at the cap).

## 7. Code (`src/`)

| file | purpose |
|---|---|
| `cnfexport.py` | CNF export of any case (imports CYCPAT's `cycenum.py`); `sb_clauses` = §4.3 |
| `run_case.sh`, `worker.sh` | solve → check pipeline and queue worker |
| `recheck.sh` | re-check a kept proof with a larger cake_lpr heap |
| `decode_check.py` | model decoding + simple explicit 4-cycle checker |
| `tree.py`, `summarize.py`, `status.py`, `plainprog.sh` | tree/cover construction, closing-leaf table, progress |
| `reorder.py`, `checkpoint.sh` | queue ordering; commit under the results lock |
| `validate_cover.py`, `validate_sb.py`, `control40.py` | validations of §5 |

Data:
- `results.jsonl`: every run.
- `queue.txt`: every queued case.
- `tree.json` / `leaves.tsv`: the plain tree (R1).
- `tree_sb.json` / `leaves_sb.tsv`: the sb tree (R2).
- `tree_any.json`: both kinds of leaf mixed.
- `tree_n40_control.json`: the n = 40 control. It is "not closed" because 3 of its leaves are SAT, as expected.
- `logs/`: per-run solver and checker logs, validation outputs, the kissat/drat-trim trials and the aborted early runs.

CNFs, proofs and locks are git-ignored.

## 8. Surprises and next steps

- **Splitting on the smallest orbits works very well.** The hardness sits in the densest prefixes (1, 2, 3, 4, 5, …). Leaves whose small orbits are spread out finish in seconds. One extra split level costs little and makes the proofs checkable.
- **Symmetry breaking is a big speed-up, but not needed for the result.** The unit lex rule plus −1 made the sb tree about 6× cheaper than the plain tree: 3.3k vs 18.9k solve-seconds over the closing leaves. The plain tree still closed in about 3 h on 4 cores, which removes any dependence on §4.3.
- **Checkers.** drat-trim does not scale to these proofs, while cake_lpr on CaDiCaL LRAT is fast (≈ 0.3–0.7 × the solve time). Memory is the limit: cake_lpr touches its whole heap and needs about 2.5 × the proof size. Keep proofs ≲ 2.5 GB, i.e. ≲ 10–12 min of solving, by splitting before that.
- **Process lesson.** Never commit files that a running process is writing, when the push path can rebase (§4.4).
- **n = 48 (task N48).** The same machinery should apply directly: `cnfexport.py 48 12 ...`, the auto-splitting worker and `tree.py 48 12 plain`. Start with depth-4 leaves for e = 2, 3, a 900 s cap, and 4 workers.
