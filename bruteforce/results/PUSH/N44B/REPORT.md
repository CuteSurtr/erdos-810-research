# PUSH/N44B: n = 44, k = 11, open cube {1, 2, 3, 4} of CYC/C1, p5 = 0 half

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

All computation ran in this cloud container, 2026-10-25, 10:35 to about 12:15 UTC.

## 2. Results

| item | status |
|---|---|
| All 8 sub-cubes {1, 2, 3, 4, ¬5, ±6, ±7, ±8} UNSAT | **proved** (with this encoding): each has a CaDiCaL LRAT proof checked by **cake_lpr** (`s VERIFIED UNSAT`), and an independent second run with a DRAT proof checked by **drat-trim** (`s VERIFIED`) |
| Cover of the p5 = 0 half | trivial presence-bit split, checked by `src/mktree.py` |
| No deeper split needed | the slowest leaf took 394 s |
| k = 10 sanity: the cube {1, 2, 3, 4, ¬5, ¬6, ¬7, 8} is SAT at k = 10 | *certificate-verified* (440 edges, 17644 rainbow 4-cycles) |
| Cross-check of N44A's 8 p5 = 1 leaves with this pipeline | see §6 |

**Outcome.** Together with PUSH/N44A (p5 = 1 half all UNSAT, plus cake_lpr re-proofs of C1's 8 other cubes,
including the two that C1 had as solver only), every leaf of the n = 44, k = 11 tree is UNSAT with a checked proof. So
**k_max(44) = 10 < n/4 = 11 in the cyclic orbit family, with C1's encoding** (`cycenc 44 11 3`). Soundness also rests on C1's
translation-fix and lex-leader argument (C1 REPORT §4), which the ¬p1 cube needs. The k = 10 lower bound is C1's certificate.

### Leaf table (n = 44, k = 11; base = C1 CNF + unit clauses p1, p2, p3, p4, ¬p5)

| p6, p7, p8 | result | solve s (LRAT run) | LRAT bytes | cake_lpr | solve s (DRAT run) | DRAT bytes | drat-trim | drat-trim s | CNF sha256 (prefix) |
|---|---|---|---|---|---|---|---|---|---|
| +6, +7, +8 | UNSAT | 16.7 | 56 MB | s VERIFIED UNSAT | 6.5 | 13 MB | s VERIFIED | 9.1 | 3c594ff3c5380b92 |
| +6, +7, ¬8 | UNSAT | 220.3 | 1076 MB | s VERIFIED UNSAT | 102.8 | 188 MB | s VERIFIED | 364.5 | 94ba452bd51dde5b |
| +6, ¬7, +8 | UNSAT | 173.0 | 839 MB | s VERIFIED UNSAT | 78.0 | 144 MB | s VERIFIED | 260.6 | 3933f9e2dd9e66e5 |
| +6, ¬7, ¬8 | UNSAT | 248.2 | 1578 MB | s VERIFIED UNSAT | 153.7 | 274 MB | s VERIFIED | 586.7 | 09584bd02a44c3c7 |
| ¬6, +7, +8 | UNSAT | 173.0 | 1082 MB | s VERIFIED UNSAT | 109.6 | 188 MB | s VERIFIED | 369.1 | 9b06bc66d3dc7847 |
| ¬6, +7, ¬8 | UNSAT | 168.1 | 1463 MB | s VERIFIED UNSAT | 139.4 | 252 MB | s VERIFIED | 568.4 | a17d6ebd82c30245 |
| ¬6, ¬7, +8 | UNSAT | 393.7 | 1686 MB | s VERIFIED UNSAT | 160.2 | 281 MB | s VERIFIED | 670.8 | 502a19ef6ba6b7f4 |
| ¬6, ¬7, ¬8 | UNSAT | 349.6 | 1397 MB | s VERIFIED UNSAT | 124.4 | 246 MB | s VERIFIED | 527.1 | eefe177707af113d |

The full CNF sha256 of every leaf is in `tree.json` and `logs/leaves.jsonl`. The DRAT run regenerated the same CNF, and
its hash matched in all 8 cases. Base CNF (`cycenc 44 11 3`): 11459 variables, 427847 clauses, sha256
`7895911c5d80939f6480db2480634797f636607fd9624954213a90a46bb8324e`. This is identical to N44A's base hash.
The solve times of the LRAT runs are inflated, because the checker shared the 4 cores and up to 4 jobs ran at once.

## 3. Certificates

`certs.json` holds one certificate, `{"44": [[u, v, c], ...]}`: the k = 10 sanity model (D, g) =
`[[1,0],[2,5],[3,24],[4,38],[8,35],[10,20],[13,11],[16,32],[19,12],[20,26]]`. It is 440 edges, re-checked by
`src/certcheck.py`, which enumerates every 4-cycle on the raw edge list (`44 440 edges 17644 4-cycles OK`). It is not a new
bound, since C1 already has |D| = 10 at n = 44.

## 4. Method

- **Encoder.** C1's `cycenc.c`, copied unchanged into `src/` (sha256 `866a463c…` matches C1's). It is built with `gcc -O2`
  and run as `cycenc 44 11 3`: translation fix plus lex-leader over Z_44^×/±1.
- **Leaf CNF.** The base CNF plus one unit clause per cube literal, `±p(d)` with p(d) = 21·44 + d, which is C1's variable
  map. A comment line `c cube …` is added.
- **Proof pipeline (`src/leaf.py`).**
  - CaDiCaL writes text LRAT into a FIFO.
  - `src/cnt` (a 16 MB-buffer pass-through that counts bytes) feeds a second FIFO, which cake_lpr reads. The proof is
    checked online, as it is produced, and never stored. That matters with 30 GB of disk.
  - cake_lpr runs with `--CML_HEAP_SIZE=1024`. That was enough for a 1.69 GB proof, and a larger heap only added
    page-fault time.
  - The checker kept up with the solver: it gave its verdict within 0.1 s of the solver's `s UNSATISFIABLE`.
- **Second check (`src/drat_leaf.py`).** A fresh CaDiCaL run writes binary DRAT to disk. drat-trim then checks it in
  default backward mode, and the proof is deleted afterwards.
- **Tools.** All built from GitHub in this container:
  - CaDiCaL 3.0.1 (git c607304);
  - drat-trim (git 2e3b2dc);
  - cake_lpr (git a36874a). `cake_lpr.S` matches the repository's `cake_lpr.sha256`. `basis_ffi.c` does not match that
    file, because the sha file is stale upstream. Build: `gcc -O2 basis_ffi.c cake_lpr.S -o cake_lpr_def -std=c99`.
- **Validation.**
  1. C1's cube (1, 2, ¬3, ¬4) was re-proved through the same pipeline: UNSAT, 1.45 GB LRAT, cake_lpr
     `s VERIFIED UNSAT` (`logs/validation.jsonl`). C1 also had it UNSAT, with LRAT.
  2. cake_lpr rejected two tampered copies of a 48 MB proof (C1's cube (1, ¬2, 3, ¬4)), at the tampered line. In one,
     a hint was removed; in the other, a literal was dropped from a lemma.
  3. The k = 10 sanity check (`src/sanity10.py`) applies a p5 = 0 cube with the same literal map to `cycenc 44 10 3`. It
     is SAT, and the decoded model passes C1's `check.py`. So the cube literals do not over-constrain the CNF, and the
     variable map is right.
- **Cover.** At the root, (1, 2, 3, 4, ¬5) is split on p6, p7, p8, giving 8 leaves, one for each sign pattern.
  `src/mktree.py` asserts that the leaves are exactly the 8 sign patterns, each appearing once. Above the root, the cover is
  C1's 9 cubes, with the open cube split on p5: p5 = 1 went to N44A, and p5 = 0 is this task.
- **Wall time.** About 25 min for all 8 LRAT leaves (3–4 in parallel), plus about 30 min for the 8 drat-trim re-checks.

## 5. Code (`src/`)

| file | purpose |
|---|---|
| `cycenc.c`, `check.py`, `certcheck.py`, `cube.py`, `cubeproof.py`, `cubes44.sh` | copied unchanged from `CYC/C1/src` |
| `leaf.py` | `leaf.py timeout lits`: leaf CNF, CaDiCaL LRAT streamed to cake_lpr, one JSON line to `logs/leaves.jsonl` (or `$LOG`) |
| `cnt.c` | byte-counting pass-through used between the two FIFOs |
| `drat_leaf.py` | second check: CaDiCaL binary DRAT, then drat-trim; writes to `logs/drat.jsonl` |
| `mktree.py` | builds `tree.json` and checks the cover |
| `sanity10.py` | k = 10 SAT sanity check of the cube literals |

Paths assume `/tmp/w/{cycenc,cnt,c_44_11_3.cnf}` and `/tmp/w/tools/{cadical,drat-trim,cake_lpr}`.

## 6. Cross-check of N44A's p5 = 1 leaves, and notes

CROSSCHECK_PLACEHOLDER

**Surprises.**
1. The open cube was much easier than C1's numbers suggested. C1 had (1, 2, 3, 4, ¬5) UNKNOWN after 840 s. Fixing
   p6..p8 as well makes every leaf fall in at most 394 s.
2. With streaming, proof size stops being the bottleneck that C1 reported. cake_lpr kept up with CaDiCaL's text-LRAT stream online,
   up to 6.3 MB/s (1.08 GB in 173 s), with a 1 GB heap.
3. A `git pull --rebase --autostash` during a checkpoint briefly removed `src/leaf.py` from the working tree, and one
   queued leaf failed to start. That is the same failure class as C1's log loss. The leaf was re-run, and all later
   jobs use absolute script paths. No result was lost.

**Next steps.** The same pipeline (cube on presence bits, then streamed LRAT into cake_lpr) should apply to N48
(n = 48, k = 12) and to n = 76, k = 19.
