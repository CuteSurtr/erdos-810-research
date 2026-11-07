# Erdős #810 search resumed, 6 November 2026 (Korea time)

Session began 2026-11-05 18:02 UTC, with a two-hour budget.
**Stopped at the user's request at 19:00 UTC, after about 58 minutes.**
All search and proof-checking jobs were stopped; no search is left running.
Final certificate verification and checkpointing followed the stop.
Starting branch: `bruteforce-2026-10`, commit
`445837e53b2fc8b0541e18d1a2f8b77b0775a227`.
The upper-bound searches concern the cyclic orbit family. The new explicit
constructions below give lower bounds for unrestricted M(n). Neither gives
a solution of the asymptotic Erdős #810 problem.

## Placement and resource limit

Local Linux desktop, 32 logical CPUs and 59 GiB RAM; see `placement.txt`.
The initial run used 16 workers. At 18:08 UTC the user asked to conserve PC
resources; the extra solvers were terminated and their partial work is marked
UNKNOWN. The resumed run uses two workers, CPU affinity 30–31, niceness 19,
and idle I/O priority. Each proof checker has a 1000 MB heap and 64 MB stack.
The run stops accepting new jobs at 19:52 UTC; leaf cap is 400 seconds.
From 18:16 UTC, one worker on CPU 31 continues n = 56 and one on CPU 30
tests the previously unresolved full n = 43, k = 11 formula (4200-second
cap). CPU and I/O priorities remain unchanged. These are at most two
logical CPUs in total, including proof checking.
The n = 56 driver was stopped gracefully at 18:39 UTC and CPU 31 reassigned
to construction searches. The n = 43 full-formula checker exhausted its
1000 MB heap; this attempt is UNKNOWN, not a proof. At 18:52 it was stopped
and the runner repaired to detect failed proof checkers and enforce an
external wall-clock deadline. At 18:53, CPU 30 began smaller n = 43 cubes
with 90-second caps and the same memory limit. No memory increase was made.

## Results

| Claim | Status |
|---|---|
| Cyclic `k_max(52) = 12`, hence maximum 624 edges in this family | **Proof-checked historical result; consolidated coverage verified in this session.** Both closure checkers accept all 10,872 leaves, with zero missing branches or symmetry-covered leaves. |
| Cyclic `k = 13` at `n = 56`, 728 edges | **Certificate-verified again in this session**, by both independent graph checkers. |
| Cyclic `k = 14` at `n = 56`, 784 edges | **Unfinished; checkpointed.** 115 new verified UNSAT leaves; four of nine top-level roots closed including historical work. |
| Cyclic `k = 10` at `n = 43`, 430 edges | **Certificate-verified again**, using both checkers; 16,813 rainbow four-cycles. |
| Cyclic `k = 11` at `n = 43`, 473 edges | **Unfinished; stopped and checkpointed.** Five of nine top-level roots closed. The full attempt exhausted the checker heap. |

## New certificate lower bounds

The final checkpoint contains **50 improved lower bounds** compared
with `paper/data/best_lower_bounds.json`, including the old table's implicit
pendant padding at omitted sizes. Every candidate passed two different
cycle enumerations: `src/fourset_check.c` visits the three cycles on each
four-set, while `src/certcheck.py` uses common-neighbor walks. Their cycle
counts agree. Explicit edges and colors are in `certs.json`; the complete
comparison is in `lower-bound-updates.json` and `.csv`, with certificate
source paths and hashes in `certificate-sources.json`. Final checker outputs
are `logs/final-fourset-check.txt` and `logs/final-independent-check.txt`.
The 18:54 checkpoint had 38 improvements; subsequent completed searches
and the full source catalog raised this to 50 before the user stopped work.

Selected improvements:

| n | Previous repository bound | New verified bound |
|---|---:|---:|
| 26 | 169 | 170 |
| 28 | 196 | 198 |
| 34 | 274 | 281 |
| 35 | 288 | 298 |
| 39 | 351 | 371 |
| 43 | 430 | 434 |
| 44 | 440 | 463 |
| 52 | 624 | 651 |
| 54 | 690 | 702 |
| 55 | 691 | 717 |
| 60 | 780 | 871 |
| 65 | 919 | 976 |
| 67 | 938 | 1011 |
| 106 | 1941 | 2015 |
| 118 | 2282 | 2404 |
| 120 | 2284 (implicit padding) | 2512 |

These are improvements to this repository's table, not claims of published
records or exact M(n) values. In particular, the 651-edge construction at
n = 52 is outside the cyclic family and is consistent with its 624-edge
family optimum.

Two methods are used:

1. **One-vertex SAT extensions.** Keep every old edge and color and attach
   a new vertex using a palette of n+1 colors. For each pair of attachment
   vertices a,d and each old common neighbor b, impose that the cycle
   new-a-b-d-new is rainbow. `extend_vertex.py` also enforces one color per
   selected edge and a cardinality target. Every returned SAT assignment
   satisfies every CNF clause, and its graph is independently checked.
   The 54-vertex certificate adds 13 edges to the old 53-vertex graph;
   the 55-vertex certificate adds 15 more. Logs and bases are in `extensions/`.
   UNSATs here are restricted-extension answers only; they are not used as
   mathematical upper bounds. Timeouts are UNKNOWN, never optimality.
2. **Deletion and pendant closure.** Given an n-vertex certificate, delete
   a vertex v and every edge of color c, then relabel to n-1 vertices/colors.
   The retained edge count is
   `e - degree(v) - color_size(c) + incident_count(v,c)`.
   All pairs (v,c) are tried; the best certificate is retained. Iterate this
   and pendant padding across the size table. `shrink_certificates.py` records
   the complete operation chain and source hash for each improvement.

The second method is an elementary consequence of heredity, not a claimed
new theorem. It exposes useful lower bounds already implicit in the larger
recorded constructions. All extension searches are now stopped. Interrupted
targets are recorded as UNKNOWN in `logs/user-stop.json`.

The completed n = 61 to 67 extension chain gives 928, 943, 959, 976,
993 and 1011 edges at n = 62 through 67. A separate short batch improved
n = 26, 28, 32, 33, 34, 37 and 38. The final table keeps whichever checked
certificate is best; losing candidates remain in the per-attempt folders.

`catalog/` normalizes the existing paper loader's sources, including cyclic
offset-only files that the first deletion pass did not include. Every one
of its 112 selected certificates was checked. Its source hashes refer to
the repository state at checkpoint `e05b493`; in particular its copy of
this task's then-current `certs.json` predates the final replacement.
`closure_catalog/` records the completed additional deletion pass from
that catalog, yielding 434 and 463 edges at n = 43 and 44.

To verify the final lower bounds from the repository root:

```
python3 bruteforce/results/RESUME_20261106/src/certcheck.py \
  bruteforce/results/RESUME_20261106/certs.json
```

For the second checker, compile `src/fourset_check.c` with `gcc -O2` and
feed each certificate as `n m` followed by its m `u v color` lines.
The final verification used CPU affinity and low priority as above.

## Publication assessment of existing results

The strongest near-term paper candidate is the existing computational
package: exact M(n) for n <= 12, independently checked lower-bound
certificates, and cyclic-family optima including the break of the n/4
pattern. `paper/main.tex` already develops this package. This session's
bound improvements and n = 52 consolidation strengthen it. Publication
priority and journal acceptance are not established by these checks.

The separate main-branch affine results and the archived 0.298444... density
bound are analytic proofs with recorded audits, not Lean results. Their
novelty and external review remain pending; they should not be merged into
a claim that #810 is solved.

Primary literature located in this session includes the accessible
[Sárközy–Selkow preprint](https://ftp.cs.wpi.edu/pub/techreports/pdf/04-02.pdf),
the related [2023 B-coloring paper](https://www.renyi.hu/~gyarfas/Cikkek/204_studia.pdf),
and [Gyárfás–Sárközy–Wagner (2026)](https://doi.org/10.1016/j.disc.2026.115005).
The latter two address proper colorings and restricted families. They must
be compared carefully before asserting novelty of cyclic or affine results.
Finding these sources is not a completed historical-priority audit.

At 18:21 UTC, the formerly open n = 56 root `(1,-2,-3,4)` closed by 56
new checked leaves. The independent closure check reports zero open
branches, zero unverified UNSAT lines and no SAT witness. Other roots
remain open; this partial closure does not establish the family optimum.
At 18:26 UTC, root `(1,-2,3,-4)` also closed by 56 new checked leaves.
Together with the two previously closed roots, four of nine top-level
roots are now closed. These roots are not equally costly; this is not a
percentage estimate for remaining runtime.

The final n = 43 checkpoint has **399 verified UNSAT leaves** and five
closed top-level roots. Independent recursive coverage checking recomputed
their CNF hashes; four top-level roots remain open. See
`logs/n43-final-closecheck.txt` and `logs/n43-status.json`. The 399 leaves
account for 522,150,784 checked streamed proof bytes. No complete n = 43
upper bound or new cyclic optimum is claimed.

## Independent census-total check

`src/burnside_graph_count.py` independently recomputes the number of
unlabeled 12-vertex, 41-edge simple graphs. It enumerates the 77 conjugacy
classes of S_12, their induced edge cycles, and fixed-size invariant edge
subsets, then applies Burnside's lemma with exact integer arithmetic.
The result is **2,411,961,516**, matching the total reported by the V12
enumeration. The full class-by-class data are in
`logs/n12e41-burnside-count.json`. This validates the reference total,
not the individual coloring tests, uniqueness of generated hosts, or
historical novelty of M(12).

### Completed n = 52 consolidation

The unchanged C encoder reproduces the archived base CNF SHA-256:
`f0bba6f2545c2658065ae1a75bbcdd0bf8c0192d8532bb89a13c716a148620c6`.
All nine roots `-1` and `1,±2,±3,±4` form a partition of the assignments.
Using all PUSH2/N52 and N52W shard logs, the independent recursive closure
check gives 10,872 verified leaves, 213 internal nodes, and zero open branches.
The explicit-tree coverage checker independently reports:

```
COVER OK {'unsat': 10872, 'covered': 0, 'internal': 213}
```

The known 12-orbit construction was independently rechecked: 624 edges,
36,088 four-cycles, all rainbow. Its source certificates are in
`../PUSH2/N52/control/`.

**Trust boundary:** these coverage checks recompute leaf CNF hashes and trust
the historical cake_lpr verdicts in the archived logs. The historical binary
LRAT streams were not retained; this session does not replay all 10,872
proofs. The result also depends on the documented correctness and symmetry
reduction of CYC/C1's `cycenc` encoding. This is not a Lean certificate or an
upper bound on unrestricted `M(52)`.

### n = 56 continuation

The base CNF SHA-256 also matches the prior run:
`7a96db2d27407c3b3f971800021e1d2f7c97ec58614e558820ce6256270b09ad`.
The old `-1` cube was freshly replayed through CaDiCaL and cake_lpr, with
the same leaf hash and 3,922,320 proof bytes; verdict `s VERIFIED UNSAT`.
The known 13-orbit construction has 728 edges and 50,960 rainbow four-cycles.

Tools were built from the original pinned sources:

- CaDiCaL `c60730422e758ef1cebe7aeddf2dda31c996bf04` (3.0.1).
- cake_lpr `a36874a8b750b43fe4b385b8ddbf5b033e46a3fa`.
- Encoder SHA-256 `866a463c7f84472a3faa80672d49d91e095b7809a96f9edc26ba9c0d42b0ffb0`.

New LRAT proofs are streamed to cake_lpr; only verified verdicts are accepted
as closures. Proof bytes are counted, but full streams are not retained.
New leaf logs include solver/checker exit codes and checker output. Every
SAT model is decoded and directly checked for rainbow four-cycles.

## Source changes and interruptions

`src/` copies PUSH2/N56's source, with these execution changes:

- Tool/work paths are supplied by environment variables.
- The driver honors a deadline, stops on SAT or failed verification, and
  ignores interrupted leaves when resuming.
- `sequence.py` completes one top-level root at a time, including mirror
  branches, to produce useful partial closures with two workers.
- The explicit coverage checker caches identical SHA-256 prefixes. It
  computes exactly the same leaf hashes without repeatedly hashing the
  multi-megabyte base formula for every leaf.
- One initial proof stream ended early (solver SIGPIPE; no UNSAT claim).
  The FIFO runner now holds a writer open until CaDiCaL exits, preventing
  transient proof-file reopenings from appearing as EOF. Interrupted and
  failed streams are never treated as checked UNSAT.

`input-manifest.json` hashes the historical inputs. New result logs are
snapshots of an append-only live log kept outside the checkout.

## Resuming

Use `src/sequence.py` with `CYCWORK`, `CYC_TOOLS`, `LEAFLOG`, and
`CYC_DEADLINE` set. Compile `src/cycenc.c` to `src/cycenc`, and put the pinned
tools under `$CYC_TOOLS/cadical/build/cadical` and
`$CYC_TOOLS/cake_lpr/cake_lpr`. Seed the live log with the nine `(56,14)`
records from PUSH2/N56, followed by `logs/n56-new.jsonl`. Do not include the
old `(56,13)` free-solve record. Run at low priority and within two logical
CPUs as requested by the user. Preserve every new leaf record.
