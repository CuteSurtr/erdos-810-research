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
| R1 | **CYCPAT's split of n = 44, k = 11 is closed.** Every leaf is UNSAT, and every UNSAT leaf has an LRAT proof that cake_lpr verified (`s VERIFIED UNSAT`). So the cyclic orbit family has **no valid (D, g) with \|D\| = 11 at n = 44**, i.e. **k_max(44) ≤ 10 < n/4 = 11**. Tree: `tree.json`; closing leaves: `leaves.tsv`. | *proved*, conditional on (a) the soundness of CYCPAT's encoding (re-derived and validated by CYCPAT; validated again here) and (b) the soundness of the symmetry breaking added in the e = 2..7 leaves (§4.3, a paper proof, plus the empirical checks in §5) |
| R2 | e = 2 and e = 3 (CYCPAT's two unfinished cases) are finished: split by the 3rd and 4th orbit (and the 5th/6th under the prefix 1, 2, 3, 4), with symmetry breaking. All leaves UNSAT, cake_lpr-verified. | *proved* (as R1) |
| R3 | CYCPAT's cases nounit and e = 8..21, re-run under CYCPAT's **plain encoding** (no extra symmetry breaking): all UNSAT, cake_lpr-verified. e ≥ 13 is also vacuous: an 11-element D with 1 and e as its two smallest orbits needs 21 − e ≥ 9. e = 4..7 were re-proved with symmetry-broken depth-3 leaves, all cake_lpr-verified. | *proved* |
| R4 | Plain-encoding re-proof of e = 2..7 (no added symmetry breaking, so R1 does not depend on §4.3): see §6 for how far it got. | see §6 |
| R5 | **Positive control at n = 40, k = 10** (4 known optimal orbits): the identical pipeline (same exporter, same symmetry breaking, same leaf shapes, CaDiCaL + cake_lpr) finds SAT in exactly the 3 leaves predicted from CYCPAT's enumeration. The decoded models are 3 of the 4 orbits; the leaf predicted to hold the remaining orbit is one of the 3 SAT leaves (it holds 2 orbits). All 128 other leaves are UNSAT with verified proofs. Each SAT model passes the explicit 4-cycle checker. | *certificate-verified* (control) |
| R6 | DRAT with drat-trim was not usable at this size. On the n = 40 e = 4 case, kissat solved in 420 s with a 774 MB DRAT, and drat-trim had no verdict after 1936 s. CaDiCaL LRAT on the same CNF (same sha256) took 475 s, and cake_lpr verified it in 173 s. So every proof here is LRAT checked by cake_lpr, which the task allows. | measured |

**Answer to step 3 of the task:** yes. CYCPAT's independent split (nounit + unit2:e, e = 2..21), refined as
described, gives **k_max(44) ≤ 10**. With the k = 10 solutions known from CYC/C1, **k_max(44) = 10**. That
makes n = 44 the first multiple of 4 where k = n/4 fails in the cyclic family. This agrees with C1's
independent presence-bit split, which N44A/N44B are finishing with a different encoder.

## 3. Certificates

There are no SAT certificates for n = 44, k = 11 (no solution exists), so `certs.json` is `{}`.
The UNSAT certificates are the LRAT proofs. They are too big to commit (11 GB in total, at most 1.9 GB each)
and were deleted after cake_lpr verified them. Each one can be regenerated exactly: the CNF is deterministic
(sha256 recorded per leaf), and CaDiCaL 3.0.1 is deterministic. For every leaf, `results.jsonl` and
`leaves.tsv` record:
case, CNF sha256, solver and version, solve time, LRAT size in bytes, the cake_lpr verdict line, and check time.

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
- **Vacuous nodes.** A prefix P with |P| + (H − max P) < k contains no D, since there are not enough orbits above max P. These nodes are closed without a solver (215 such nodes in the tree; most were also run, and are UNSAT).
- `src/tree.py` rebuilds the whole tree from `results.jsonl`. It checks that every internal node has all of its children, and that every leaf is either vacuous or a verified UNSAT case. The script's output: `{"closed": true, "open": [], "n_open": 0}`.

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
- **Checker:** cake_lpr (GitHub `tanyongkiam/cake_lpr` @ a36874a, built from the shipped `cake_lpr.S` with gcc), run as `cake_lpr --CML_HEAP_SIZE=6000 --CML_STACK_SIZE=3000 f.cnf f.lrat`. Only the verdict line `s VERIFIED UNSAT` counts.
- **Also built:** kissat 4.0.4 (@ 8af8e56) and drat-trim (@ 2e3b2dc), used only in the trials of R6.
- **Pipeline:** `src/run_case.sh` exports the CNF, records its sha256, solves (40 min cap), then checks the proof (UNSAT) or decodes the model and checks it explicitly (SAT). It appends one JSON line to `results.jsonl`.
- **Workers:** `src/worker.sh` takes lines of `queue.txt` under mkdir locks; there were 4 workers.
- **Further splits:** a leaf that hit the cap (only `sb:1.2.3.4`: UNKNOWN at 2400 s with 6.1 GB of LRAT) was split one level deeper. Its child `sb:1.2.3.4.5` was solved in 873 s. cake_lpr was then killed by the container's memory cgroup on its 2.5 GB proof (4.2 GB RSS, and 9.2 GB on a retry with a larger heap). That child was therefore closed by its own children `sb:1.2.3.4.5.x`, which all verified. `sb:1.2.3.5` (688 s) verified directly, and its depth-5 children are extra.

### 4.5 Totals for the closing tree (`leaves.tsv`, R1)

The symmetry-broken tree, as closed at 12:09 UTC, was 452 CaDiCaL runs on n = 44 (sb leaves, plus nounit
and unit2:8..21):
- 448 verified UNSAT;
- 3 runs without a verdict, all superseded:
  - `sb:1.2.3.4`: hit the cap, then split;
  - `sb:1.2.3.4.5`: cake_lpr was OOM-killed twice, then split;
  - one stale kissat run of `sb:1.2.3.5` from the drat-trim trial (the CaDiCaL run of that leaf is verified).
- Totals: solving 8423 s, checking 4514 s, wall time about 50 min on 4 cores. The largest verified LRAT was 1.89 GB, and 24.9 GB of LRAT was written in all (each proof deleted after checking).

`tree.json` uses the smallest closing set of cases. `src/summarize.py` reports it as follows.
- Closing leaves: plain leaves where they are now verified (§6), sb leaves elsewhere.
- Vacuous nodes: 215.
- Every closing leaf is `s VERIFIED UNSAT`.

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

## 6. Plain-encoding re-proof of e = 2..7 (no added symmetry breaking)

FILL_PLAIN

## 7. Code (`src/`)

| file | purpose |
|---|---|
| `cnfexport.py` | CNF export of any case (imports CYCPAT's `cycenum.py`); `sb_clauses` = §4.3 |
| `run_case.sh`, `worker.sh` | solve → check pipeline and queue worker |
| `recheck.sh` | re-check a kept proof with a larger cake_lpr heap |
| `decode_check.py` | model decoding + simple explicit 4-cycle checker |
| `tree.py`, `summarize.py`, `status.py` | tree/cover construction, closing-leaf table, progress |
| `validate_cover.py`, `validate_sb.py`, `control40.py` | validations of §5 |

Data:
- `results.jsonl`: every run.
- `queue.txt`: every queued case.
- `tree.json`: the closing tree. Its mode is `any`, meaning plain or sb leaves.
- `tree_plain.json`: the plain-only tree.
- `tree_n40_control.json`: the n = 40 control tree.
- `leaves.tsv`.
- `logs/`: validation outputs, the kissat/drat-trim trials and the aborted early runs.

CNFs, proofs and locks are git-ignored.

## 8. Surprises and next steps

- **Where the hardness is.** It sits in the densest prefixes: 1, 2, 3, 4 and then 1, 2, 3, 4, 5. Leaves whose small orbits are spread out finish in seconds. Splitting on the smallest orbits works very well here: 448 leaves took about 2 CPU-hours in total.
- **Checkers.** drat-trim does not scale to these proofs, while cake_lpr on CaDiCaL LRAT is fast (≈ 0.4–0.5 × the solve time). Memory is the limit. The 15 GB cgroup killed cake_lpr on a 2.5 GB LRAT, so leaves should stay below about 2 GB of proof, roughly 10 min of solve time. Split before that.
- **n = 48 (task N48).** The same tree, with sb leaves and dense prefixes split to depth 5–6, should be within reach. The script is `src/tree.py 48 12` after queueing the cases.
