## 2. Results

| claim | status |
|---|---|
| k = 11 is achievable at n = 48 (528 edges, 48 colours) | **certificate-verified** (§3; known from CYC/C2, re-found and re-checked here) |
| k = 12 = n/4 is UNSAT at n = 48 in C1's sym = 3 encoding | **proved**, modulo one stated symmetry lemma (§4.3): every leaf of the cube tree that was run is UNSAT with a cake_lpr-checked LRAT proof; the remaining branches are mirror images, under the u = −1 symmetry, of closed branches |
| hence **k_max(48) = 11 < n/4 = 12** | proved, as above |

So n = 48 is the first multiple of 4 at which k = n/4 is shown impossible in the cyclic family:
k_max(28, 32, 36, 40) = n/4, and k_max(48) = n/4 − 1. M(48) ≥ 48·11 = 528 from this family.

**What the proof rests on.**
1. Correctness of C1's encoder `cycenc.c` with sym = 3 (re-derivation, soundness and symmetry-breaking
   argument in `results/CYC/C1/REPORT.md` §4; validated there on n = 13..36 and here on n = 36 and 48, §4.5).
2. The cover: presence-bit splits plus offset splits, checked by `src/covercheck.py` (§4.2).
3. 3347+ leaf proofs (see the table in §4.4 for the final count), each checked by cake_lpr.
4. For the branches marked COVERED: the u = −1 symmetry lemma (§4.3). This is a two-line argument,
   numerically confirmed, and for the branches that were also run directly the mirrors came out
   UNSAT as predicted. A run of the remaining mirror sub-cubes (§6) would make the cover purely
   trivial.

No SAT model was found in any sub-cube.

## 3. Certificates

`certs.json` (`{"48": [[u, v, c], ...]}`) and `solutions.json` (`{"48": [[d, g], ...]}`) hold the k = 11 colouring:
`[[1, 0], [2, 3], [5, 7], [7, 4], [9, 34], [16, 5], [17, 10], [19, 30], [20, 35], [21, 43], [22, 40]]`
(found by CaDiCaL 3.0.1 on the k = 11 CNF in 0.9 s). Checked by C1's two independent checkers:
`src/check.py` (orbit form, walks every 4-cycle) and `src/certcheck.py` (raw edge list):
`48 528 edges 25176 4-cycles OK`.

The UNSAT side has no certificate in this sense; its evidence is `tree.json` plus the checker verdicts.

## 4. Method

### 4.1 Encoding and tools

- **Encoder.** C1's `cycenc.c` (copied unchanged to `src/`), `cycenc 48 12 3`: translation fix plus lex-leader
  p ≥_lex p∘u for all 8 units of Z_48^×/±1. Base CNF: 14718 variables, 610329 clauses,
  sha256 `8b9bc39b6244b093ed6850b45ccca8ea809ff015eb61141b14e583960fff6cbf`.
  Variables: x(d,g) = 1 + 48(d−1) + g, p(d) = 23·48 + d.
- **Solver.** CaDiCaL 3.0.1, built from github.com/arminbiere/cadical (commit c60730422e75).
  kissat 4.0.4 (commit 8af8e56f174b) was used only in the portfolio.
- **Proofs.** Every leaf runs `cadical -q -t <cap> --lrat <cube.cnf> <fifo>`. The binary LRAT stream goes
  through `tee` (which counts the bytes) into **cake_lpr** (github.com/tanyongkiam/cake_lpr, commit
  a36874a8b750, built from the shipped `cake_lpr.S`), which checks it as it arrives. Nothing is
  written to disk. The verdict line of every UNSAT leaf is `s VERIFIED UNSAT`.
  - drat-trim (commit 2e3b2dc0ecf9) was built too and used once in validation. On the 51 MB DRAT of
    n = 36, k = 10 it took 76 s, against about 16 s CPU for cake_lpr on the LRAT, so the tree used cake_lpr.
  - Negative test: cake_lpr rejects the LRAT proof of (CNF + unit p1) when it is given the CNF
    without the unit (`logs/validation.jsonl`).
- **Leaf CNF.** Base CNF + one unit clause per cube literal, with the clause count in the header raised.
  The sha256 of each leaf CNF is recorded and recomputed independently by `covercheck.py`.

### 4.2 The tree

**Level 1 (presence bits, as in C1).** The 9 cubes {¬p1} and {p1} × {±p2} × {±p3} × {±p4} partition
all assignments. Each was run with a 600 s cap (`logs/leaves_wave1.jsonl`).

- ¬p1: UNSAT in 16 s. Under the lex-leader constraint, p1 = 0 forces every present orbit to be a non-unit
  (a present unit u would make p∘u⁻¹ lex-larger). This is already enforced by the CNF, so the cube is just
  solved, not argued. There are 15 non-unit orbits, and at least 12 of them would be needed.
- (1,¬2,¬3,¬4), (1,¬2,¬3,4), (1,¬2,3,¬4): UNSAT in 14, 136 and 358 s.
- (1,2,3,4), (1,2,3,¬4), (1,2,¬3,4), (1,2,¬3,¬4), (1,¬2,3,4): UNKNOWN at 600 s.
  (1,2,3,4,5) was also UNKNOWN at 600 s; that p5 split was abandoned in favour of the following.

**Deeper levels (offset splits).** Splitting further on presence bits barely helped at n = 44 (C1:
the ±p5 sub-cubes of the open cube were UNKNOWN at 840 s). So an open cube is split on the *offset*
of its smallest present orbit d > 1:

- children cube ∧ x(d, g) for g = 0..47;
- cover: the base CNF contains the clause ¬p(d) ∨ x(d,0) ∨ … ∨ x(d,47), which `covercheck.py` checks;
- orbit 1 is never offset-split, since it is the smallest present orbit and the translation fix forces g(1) = 0.

Splitting on g(2) alone cut (1,2,¬3,±4) to 2 to 290 s per child. For the cubes with two present
orbits above 1, each g(2) (or g(3)) child was split again straight away on the next offset ("pre-split").
That gives 48 × 48 grandchildren of 2 to 31 s each. A g-child that already ended UNKNOWN at the 400 s cap
was split by the same rule. The final shape:

| level-1 cube | split |
|---|---|
| (1,2,¬3,¬4) | g(2) |
| (1,2,¬3,4) | g(2) (one mirror branch run directly, then g(4)) |
| (1,2,3,¬4) | g(2) then g(3) |
| (1,2,3,4) | g(2) then g(3) |
| (1,¬2,3,4) | g(3) then g(4) |

The rule and the bookkeeping live in `src/tree.py`. `src/mktree.py` turns the logs into `tree.json`, and
`src/covercheck.py` re-checks the whole cover from `tree.json` and the base CNF, re-hashing every leaf
CNF:

```
COVER_LINE
```

### 4.3 The u = −1 symmetry (mirror branches)

**Lemma.** Let (D, g) satisfy every constraint of the sym = 3 CNF with 1 ∈ D (so g(1) = 0). Define
g′(e) = e − 1 − g(e) mod 48 for e ∈ D. Then (D, g′) satisfies them too.

*Proof.* Take the multiplier u = −1 from C1 §4. For every e, u·e ≡ −e, so σ = −1, the orbit is unchanged,
and g ↦ e + u·g(e) = e − g(e). It is a graph automorphism combined with a colour bijection, so validity is
preserved. Then translate colours by −1, which also preserves validity. The presence vector is unchanged, so
the cardinality and lex-leader clauses (which mention only p) still hold. The translation fix holds because
g′(1) = 1 − 1 − 0 = 0 and 1 is still the smallest present orbit. ∎

So, at a g(d) split of a cube that fixes only presence bits and contains orbit 1, child x(d, a) is SAT
iff child x(d, d−1−a) is. The map is an involution on the children, and the literals of the parent cube are
invariant. In each such split, `tree.py` queued one representative of each pair {a, d−1−a} first; the other
children ("mirrors") went to a low-priority queue that ran once all representatives were done.

- **Numerical confirmation.** The map turns valid colourings into valid ones on the known solutions for
  n = 36 (k = 9), 44 (k = 10) and 48 (k = 11), checked with `check.py`.
- **Direct confirmation.** The mirror branches that were run directly came out UNSAT, as predicted.
- **Remaining branches.** Those never run are marked `COVERED` in `tree.json`, with `covered_by` naming
  the representative. `covercheck.py` checks that the representative subtree is closed.

This needs the encoder to be correct in both directions, as C1 argued: a CNF model decodes to a valid
(D, g) that satisfies the breaking, and every such (D, g) extends to a CNF model.

### 4.4 Counts and timings

STATS_TABLE

Times are CaDiCaL wall times with LRAT streaming on 4 parallel jobs. "LRAT streamed" is the total size of the
binary LRAT checked by cake_lpr. The cake_lpr check finished within 0.1 s of the solver in every leaf.

Timeline (UTC): portfolio 10:39 to 11:09; level-1 cubes 11:16 to 11:37; g(2) tests 11:37; offset tree
11:39 to 14:30 (all representatives closed at about 14:30); mirror sub-cubes from 14:30 until wrap-up.

**Portfolio (rule 1, 30 min).** CaDiCaL + DRAT, CaDiCaL `--unsat`, kissat and kissat `--sat` ran on the full
CNF for 1800 s. **Their outcome lines were lost** (`logs/portfolio_NOTE.md`): I committed the empty log
files, and the `git pull --rebase` during the push replaced them under the running jobs. Nothing is
claimed from the portfolio. CYC/C2 had already run 1500 s of portfolio plus 4671 s of kissat `--sat`
without a result.

### 4.5 Validation of the pipeline

- n = 36: k = 9 SAT (model re-checked); k = 10 UNSAT, DRAT 51 MB `s VERIFIED` by drat-trim and LRAT
  `s VERIFIED UNSAT` by cake_lpr, both as a full instance and with the cube {1,2,3}. This matches
  CONSTR's k_max(36) = 9.
- n = 48: k = 11 SAT in 0.9 s, model re-checked (§3).
- cake_lpr negative test (§4.1).
- Each leaf SAT model would be decoded and checked by `check.py`; none occurred.

## 5. Files

| path | content |
|---|---|
| `src/cycenc.c` | C1's encoder, unchanged (`gcc -O2 -o src/cycenc src/cycenc.c`) |
| `src/leaf.py` | one cube: builds the leaf CNF, runs CaDiCaL with streamed LRAT into cake_lpr, prints JSON |
| `src/tree.py` | cube-and-conquer driver (split rules, mirror queue, pre-split) |
| `src/mktree.py` | logs → `tree.json` |
| `src/covercheck.py` | independent cover and hash check of `tree.json` |
| `src/report_stats.py` | per-cube table above |
| `src/check.py`, `src/certcheck.py` | C1's simple 4-cycle checkers |
| `tree.json` | full tree: every node's cube, result, time, CNF sha256, proof size and checker verdict |
| `logs/leaves_wave1.jsonl`, `logs/leaves2.jsonl` | raw per-leaf result lines (leaves2 starts with 5 seed lines for the open level-1 cubes) |
| `logs/exp_g2split.jsonl`, `logs/probe_g3.jsonl` | the split-strategy probes, also UNSAT and checked; not part of the tree |
| `logs/validation.jsonl`, `logs/portfolio_NOTE.md` | validation and the lost portfolio |

To reproduce: build cadical, cake_lpr and cycenc as above, set the paths at the top of `leaf.py`, then run
`LEAFLOG=/tmp/l.jsonl python3 src/tree.py 48 12 400 4 -1 1,2,3,4 1,2,3,-4 1,2,-3,4 1,2,-3,-4 1,-2,3,4 1,-2,3,-4 1,-2,-3,4 1,-2,-3,-4`.
This is about 2.5 h on 4 cores, since the five hard level-1 cubes need about 10 min each before they split.

## 6. Surprises and next steps

1. **Offset splits beat presence splits by a wide margin.** The level-1 cubes did not finish in 600 s, but
   their g(2)-children took seconds to minutes and their (g(2), g(3)) grandchildren 2 to 31 s. The whole
   n = 48, k = 12 refutation took about 10.5 core-hours of CaDiCaL. The same split should settle
   **N44** (the {1,2,3,4} cube of C1) quickly, and likely n = 52, 56 at k = n/4 too.
2. **Streaming LRAT into cake_lpr through a fifo** makes proof checking essentially free: there is no disk
   use and no extra wall time. That allowed 3000+ separately checked leaves with about 70 GB of proof in total.
3. **To remove the symmetry lemma from the trust base,** run the remaining COVERED mirror branches. They
   are the low-priority queue of `tree.py`: re-run the reproduce command with the same `LEAFLOG`, and it
   continues from where this run stopped. Estimate: 93 branches × about 48 leaves × about 10 s / 4 cores ≈ 3 h.
4. **k_max(48) = 11 = n/4 − 1.** This is the first multiple of 4 where k = n/4 is *proved* impossible. n = 44
   (k = 11) is the one still open below it, and is being worked on by PUSH/N44A–C. With this result, the
   observation "k_max = n/4 for n ≡ 0 mod 4" (28, 32, 36, 40) stops at 48 at the latest.
