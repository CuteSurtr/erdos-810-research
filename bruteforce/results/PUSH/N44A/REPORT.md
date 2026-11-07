# PUSH/N44A: n = 44, k = 11, open cube of CYC/C1, p5 = 1 half, and re-proofs

## 1. Placement

```
Linux vm 6.18.44-fc-v153 #1 SMP PREEMPT_DYNAMIC @0 x86_64 x86_64 x86_64 GNU/Linux
4
               total        used        free      shared  buff/cache   available
Mem:              15           0          15           0           0          15
Swap:              0           0           0
```

All computation ran in this cloud container. Session: 2026-10-25, 10:35 to 14:10 UTC.

## 2. Results

Instance: the cyclic orbit family at n = 44 with |D| ≥ k = 11 (= n/4). It is encoded by C1's `cycenc 44 11 3`, which applies the translation fix and lex-leader breaking over Z_44^×/±1. The base CNF has sha256 `7895911c5d80939f6480db2480634797f636607fd9624954213a90a46bb8324e`, with 11459 variables and 427847 clauses. Each leaf is the base CNF plus one unit clause per cube literal. The presence variable of orbit d is p(d) = 21·44 + d.

**Headline.**

- **Every leaf in N44A's scope is UNSAT.** For each one, a binary LRAT proof was checked by **cake_lpr** with verdict `s VERIFIED UNSAT`. Status: *proved*, given the encoding and C1's symmetry-breaking soundness argument (C1 REPORT §4).
- **The p5 = 1 half of the open cube {1, 2, 3, 4}:** all 8 sub-cubes {1, 2, 3, 4, 5, ±6, ±7, ±8} are UNSAT, the slowest in 393 s. No deeper split was needed.
- **C1's two solver-only cubes** (1, 2, ¬3, 4) and (1, 2, 3, ¬4) are re-proved with checked LRAT, in 1113 s and 2185 s.
- **C1's six LRAT cubes** (¬1 and the five others) were regenerated with a different solver version and checked by a standard checker (cake_lpr), not C1's own lratcheck.
- **Second pipeline.** All 24 leaves (the 7 C1 leaves outside the open cube and the 16 sub-cubes on p5..p8) were also re-solved with kissat 4.0.4, writing a DRAT proof, and every proof was verified by **drat-trim**. This covers N44B's p5 = 0 half. See §4.3.
- **Combined with PUSH/N44B.** N44B's `logs/leaves.jsonl` (commit 66d0711) reports all 8 p5 = 0 sub-cubes UNSAT with cake_lpr verdict `s VERIFIED UNSAT`. I did not audit N44B's run, but my independent kissat + drat-trim run (§4.3) re-solves those 8 leaves, and drat-trim verified every proof. With that, every leaf of the tree is UNSAT with a checked proof, so **k_max(44) = 10 < n/4 = 11 in the cyclic family, with this encoding**. The k = 10 lower bound is C1's certificate-verified solution.

| cube (orbit presence) | result | CaDiCaL 3.0.1 wall (s) | binary LRAT size (MB) | cake_lpr verdict | status |
|---|---|---|---|---|---|
| ¬1 | UNSAT | 0.2 | 0.1 | s VERIFIED UNSAT | proved |
| 1, ¬2, ¬3, ¬4 | UNSAT | 7.7 | 2.0 | s VERIFIED UNSAT | proved |
| 1, ¬2, 3, ¬4 | UNSAT | 18.2 | 20.9 | s VERIFIED UNSAT | proved |
| 1, ¬2, ¬3, 4 | UNSAT | 18.4 | 21.0 | s VERIFIED UNSAT | proved |
| 1, ¬2, 3, 4 | UNSAT | 195.5 | 501.7 | s VERIFIED UNSAT | proved |
| 1, 2, ¬3, ¬4 | UNSAT | 259.1 | 645.2 | s VERIFIED UNSAT | proved |
| 1, 2, ¬3, 4 (C1: solver only) | UNSAT | 1113.1 | 2717.4 | s VERIFIED UNSAT | proved |
| 1, 2, 3, ¬4 (C1: solver only) | UNSAT | 2184.5 | 6123.9 | s VERIFIED UNSAT | proved |
| 1, 2, 3, 4, 5, 6, 7, 8 | UNSAT | 2.4 | 5.0 | s VERIFIED UNSAT | proved |
| 1, 2, 3, 4, 5, 6, 7, ¬8 | UNSAT | 4.9 | 11.2 | s VERIFIED UNSAT | proved |
| 1, 2, 3, 4, 5, 6, ¬7, 8 | UNSAT | 15.9 | 30.0 | s VERIFIED UNSAT | proved |
| 1, 2, 3, 4, 5, 6, ¬7, ¬8 | UNSAT | 319.9 | 858.7 | s VERIFIED UNSAT | proved |
| 1, 2, 3, 4, 5, ¬6, 7, 8 | UNSAT | 22.6 | 49.3 | s VERIFIED UNSAT | proved |
| 1, 2, 3, 4, 5, ¬6, 7, ¬8 | UNSAT | 219.8 | 613.1 | s VERIFIED UNSAT | proved |
| 1, 2, 3, 4, 5, ¬6, ¬7, 8 | UNSAT | 258.0 | 753.9 | s VERIFIED UNSAT | proved |
| 1, 2, 3, 4, 5, ¬6, ¬7, ¬8 | UNSAT | 393.4 | 1231.6 | s VERIFIED UNSAT | proved |
| 1, 2, 3, 4, ¬5, ±6, ±7, ±8 (8 leaves) | UNSAT (N44B) | – | – | s VERIFIED UNSAT (N44B log) | N44B; also kissat + drat-trim verified here, §4.3 |

The CNF sha256 of every leaf is in `logs/leaves.jsonl` and in `tree.json`. The wall time includes streaming the proof to the checker, which runs concurrently.

**Cover.** The tree is {¬p1} ∪ {p1} × {±p2} × {±p3} × {±p4}. Inside it, {1, 2, 3, 4} is split on ±p5, and {1, 2, 3, 4, 5} is split on ±p6 × ±p7 × ±p8. Every split on a Boolean variable into v and ¬v covers trivially, so the leaves cover all assignments. The full tree is in `tree.json`, with each leaf's assumptions, result, CNF hash, proof size and verdict. The p5 = 0 subtree is marked as delegated to N44B.

## 3. Certificates

There are no SAT results, so there is nothing to decode. `certs.json` is `{}`. The k = 10 lower bound at n = 44 is C1's (`results/CYC/C1/certs.json`).

## 4. Method

### 4.1 Encoder

C1's `cycenc.c` (copied unchanged into `src/`) is built with `gcc -O2`. `cycenc 44 11 3` reproduces the base CNF above. The clause count is 427847: C1's REPORT says "about 0.9M", which is an approximation. The C1 encoder is unchanged since commit d2bce0e. The cube literals use the same variable mapping as C1's `cube.py` and `cubeproof.py`: +d ↦ unit p(d) = 924 + d, and −d ↦ unit ¬p(d).

### 4.2 Solver and checker (main proofs)

- **Solver.** CaDiCaL 3.0.1, built from GitHub `arminbiere/cadical` at commit c607304, run as `cadical -q -t T --lrat=true --binary=true leaf.cnf FIFO`.
- **Checker.** cake_lpr, built from GitHub `tanyongkiam/cake_lpr` at commit a36874a: the verified CakeML LRAT/LPR checker, which reads binary LRAT natively. It runs as `cake_lpr --CML_HEAP_SIZE=3000 --CML_STACK_SIZE=500 leaf.cnf /dev/stdin`.
- **Streaming.** The proof is streamed through a named pipe straight into cake_lpr, so no proof is stored. The two hardest cubes produce 2.7 GB and 6.1 GB of binary LRAT. A `tee | wc -c` stage records the proof size.
- **Accepted output.** Only the exact line `s VERIFIED UNSAT` is accepted.
- **Script.** `src/leaf.sh`, driven by `src/drive.py`, which runs a 4-worker queue and would split on the next presence bit after 2400 s. No split was triggered.

**Checker negative tests** (§4.2 of `logs/negtests.txt`):

- A correct proof against the CNF without the cube unit is rejected ("clause index unavailable").
- A truncated proof is rejected.
- With 20 random single-bit flips in a proof, 17 were rejected. The 3 accepted flips are consistent with flips landing in deletion steps, which do not affect soundness.

### 4.3 Independent cross-check: kissat + drat-trim

As a second, independent pipeline, each leaf is also run with kissat 4.0.4 (GitHub `arminbiere/kissat`, commit 8af8e56) writing binary DRAT. That proof is checked by drat-trim (GitHub `marijnheule/drat-trim`, commit 2e3b2dc), using backward checking with a time limit. The script is `src/dratleaf.sh`, and results are in `logs/drat.jsonl`. This is an additional check. The proved status above rests on the cake_lpr checks.

| cube | kissat wall (s) | DRAT size (MB) | drat-trim wall (s) | verdict |
|---|---|---|---|---|
| ¬1 | 0.1 | 0 | 0.4 | s VERIFIED |
| 1, ¬2, 3, 4 | 128.2 | 223 | 589.6 | s VERIFIED |
| 1, ¬2, 3, ¬4 | 8.1 | 18 | 63.7 | s VERIFIED |
| 1, ¬2, ¬3, 4 | 8.6 | 17 | 66.1 | s VERIFIED |
| 1, ¬2, ¬3, ¬4 | 1.9 | 5 | 14.1 | s VERIFIED |
| 1, 2, 3, ¬4 | 1567.4 | 2384 | 8568.4 | s VERIFIED |
| 1, 2, ¬3, 4 | 654.8 | 1023 | 3481.4 | s VERIFIED |
| 1, 2, ¬3, ¬4 | 180.4 | 316 | 918.8 | s VERIFIED |
| 1, 2, 3, 4, 5, 6, 7, 8 | 3.0 | 8 | 15.9 | s VERIFIED |
| 1, 2, 3, 4, 5, 6, 7, ¬8 | 11.6 | 16 | 39.6 | s VERIFIED |
| 1, 2, 3, 4, 5, 6, ¬7, 8 | 9.7 | 21 | 108.5 | s VERIFIED |
| 1, 2, 3, 4, 5, 6, ¬7, ¬8 | 219.9 | 362 | 827.9 | s VERIFIED |
| 1, 2, 3, 4, 5, ¬6, 7, 8 | 20.8 | 36 | 161.7 | s VERIFIED |
| 1, 2, 3, 4, 5, ¬6, 7, ¬8 | 152.2 | 266 | 585.5 | s VERIFIED |
| 1, 2, 3, 4, 5, ¬6, ¬7, 8 | 172.9 | 297 | 672.9 | s VERIFIED |
| 1, 2, 3, 4, 5, ¬6, ¬7, ¬8 | 302.5 | 469 | 1149.9 | s VERIFIED |
| 1, 2, 3, 4, ¬5, 6, 7, 8 | 9.9 | 20 | 125.0 | s VERIFIED |
| 1, 2, 3, 4, ¬5, 6, 7, ¬8 | 143.3 | 234 | 526.6 | s VERIFIED |
| 1, 2, 3, 4, ¬5, 6, ¬7, 8 | 103.2 | 175 | 415.3 | s VERIFIED |
| 1, 2, 3, 4, ¬5, 6, ¬7, ¬8 | 170.7 | 279 | 738.3 | s VERIFIED |
| 1, 2, 3, 4, ¬5, ¬6, 7, 8 | 139.6 | 221 | 575.9 | s VERIFIED |
| 1, 2, 3, 4, ¬5, ¬6, 7, ¬8 | 155.0 | 266 | 697.1 | s VERIFIED |
| 1, 2, 3, 4, ¬5, ¬6, ¬7, 8 | 200.0 | 317 | 837.1 | s VERIFIED |
| 1, 2, 3, 4, ¬5, ¬6, ¬7, ¬8 | 167.4 | 274 | 668.4 | s VERIFIED |

**24 of 24 leaves** (the 7 C1 leaves outside the open cube, plus the 16 sub-cubes on p5..p8, N44B's p5 = 0 half included) are UNSAT with a kissat DRAT proof verified by drat-trim. The two CNF hashes for each leaf agree between the two pipelines (see logs). Some leaves have an earlier log line with an empty verdict. That was a parse bug: drat-trim prints `\r` before its result lines. Those leaves were re-run and verified.

## 5. Code

| file | purpose |
|---|---|
| `src/cycenc.c` | C1's encoder, unchanged |
| `src/check.py`, `src/certcheck.py` | C1's SAT checkers (copied; no SAT result occurred) |
| `src/leaf.sh` | one leaf: build the cube CNF, then CaDiCaL 3.0.1 binary LRAT → FIFO → cake_lpr; logs to `logs/leaves.jsonl` |
| `src/drive.py` | 4-worker queue with automatic splitting on the next presence bit after a timeout |
| `src/dratleaf.sh` | cross-check of one leaf: kissat DRAT, then drat-trim; logs to `logs/drat.jsonl` |
| `src/rest.sh` | queue of the cross-check runs |
| `src/make_tree.py` | builds `tree.json` from the logs |

**Rebuild.** Clone the three GitHub repositories above, then:

1. In cadical, run `./configure && make`.
2. In kissat, run `./configure && make`.
3. In drat-trim and in cake_lpr, run `make`.
4. Build the encoder with `gcc -O2 -o cycenc src/cycenc.c`.
5. Run `./cycenc 44 11 3 base.cnf` and put `base.cnf` in `$W` (default `/tmp/claude-0/w44a`).

To run one leaf: `src/leaf.sh <timeout> 1,2,3,4,5,-6,7,8`.

## 6. Surprises and next steps

- **The open cube was easier than expected.** C1's open cube {1, 2, 3, 4} looked hard: 33 min, plus 14 min on each of its ±5 children, all UNKNOWN. Once split on p6..p8, every p5 = 1 piece fell within 7 min. CaDiCaL 3.0.1 is also faster than the Debian 1.7.3 build on these cubes: C1's (1, 2, ¬3, 4) took 775 s on 1.7.3 without a proof, against 1113 s here with a streamed proof.
- **drat-trim on the hardest cube.** The (1, 2, 3, ¬4) DRAT proof is 2.4 GB and needed 8568 s in drat-trim, just under the 9000 s limit. Backward DRAT checking is the bottleneck. Forward LRAT checking with cake_lpr kept pace with the solver.
- **Proof bytes are the real cost.** At about 2.8 MB/s of binary LRAT, streaming into cake_lpr avoids the disk limit entirely, and the checker keeps up with the solver.
- **Next steps.**
  - The same pipeline (presence-bit cubes, streamed LRAT, cake_lpr) should apply directly to n = 48, k = 12.
  - The paper can now cite k_max(44) = 10 as proved within the cyclic family, with checked proofs for every leaf. That depends on N44B's p5 = 0 leaves, which N44B reports as checked by cake_lpr, and which this task re-solved with kissat, with every proof verified by drat-trim.
