# Cyclic-family search resumed, 6 November 2026 (Korea time)

Session began 2026-11-05 18:02 UTC, with a two-hour budget.
Starting branch: `bruteforce-2026-10`, commit
`445837e53b2fc8b0541e18d1a2f8b77b0775a227`.
This report concerns the cyclic orbit family, not unrestricted Erdős #810.

## Placement and resource limit

Local Linux desktop, 32 logical CPUs and 59 GiB RAM; see `placement.txt`.
The initial run used 16 workers. At 18:08 UTC the user asked to conserve PC
resources; the extra solvers were terminated and their partial work is marked
UNKNOWN. The resumed run uses two workers, CPU affinity 30–31, niceness 19,
and idle I/O priority. Each proof checker has a 1000 MB heap and 64 MB stack.
The run stops accepting new jobs at 19:52 UTC; leaf cap is 400 seconds.

## Results

| Claim | Status |
|---|---|
| Cyclic `k_max(52) = 12`, hence maximum 624 edges in this family | **Proof-checked historical result; consolidated coverage verified in this session.** Both closure checkers accept all 10,872 leaves, with zero missing branches or symmetry-covered leaves. |
| Cyclic `k = 13` at `n = 56`, 728 edges | **Certificate-verified again in this session**, by both independent graph checkers. |
| Cyclic `k = 14` at `n = 56`, 784 edges | **Unfinished; search running.** Counts in `logs/n56-status.json`. |

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
