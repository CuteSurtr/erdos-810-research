# Local research archive

Snapshot prepared on **6 November 2026** from the local `erdos-810-lean`
directory. The files in [`local-progress/`](local-progress/) preserve the
original sources, research notes, audits, search programs, and small recorded
results byte-for-byte, with their relative paths unchanged. This is an archival
commit; it does not report a new mathematical verification.

The [repository's main notes](../README.md) remain the public exposition.
The original [project README](local-progress/README.md) and
[research-status snapshot](local-progress/RESEARCH-STATUS.md) are historical
documents. Their descriptions of verification, novelty, and current progress
must be read with the later corrections and audits below. In particular, the
21 October repository audit supersedes the original README as an account of
the formalization's scope and limitations.

## Reading order and chronology

| Date | Record | Scope and status |
| --- | --- | --- |
| 14 October | [Initial adversarial audit](local-progress/audit-2026-10-14/AUDIT.md), [formal-check record](local-progress/audit-2026-10-14/formal-checks.md), and [subsequent research](local-progress/research-2026-10-14/RESEARCH.md) | Corrected the meaning of the original structural claims; recorded separate finite checks, reductions, and later provenance corrections. |
| 15 October | [Asymptotic results](local-progress/asymptotic-2026-10-15/RESULTS.md), [multicolor report](local-progress/multicolor-2026-10-15/REPORT.md), and [overnight index](local-progress/overnight-2026-10-15/README.md) | Restricted affine-support arguments, operator estimates, attempted extensions, and their audits. |
| 18 October | [Research report](local-progress/research-2026-10-18/REPORT.md) and [follow-up report](local-progress/research-2026-10-18-followup/REPORT.md) | Quadratic common-potential constructions, fixed-formula palette or support results, robustness extensions, and limitations of proposed unrestricted arguments. The follow-up also records publication of the fixed-formula note. |
| 21 October | [Repository and reduction audit](local-progress/research-2026-10-21/repo-and-reduction-audit.md) | Distinguishes the unverified standalone formalization from the older finite certificates, corrects the direction of a reduction, and records a written diamond-recoloring argument awaiting a second independent audit. |
| 24 October | [Finite-results reference](local-progress/search/bruteforce-2026-10-24.json) | A summary referencing the already-public [`bruteforce-2026-10` branch](https://github.com/CuteSurtr/erdos-810-research/tree/bruteforce-2026-10), commit `4de51ed`. It is not a replacement for that branch's proof evidence, and its searches were not rerun for this archive. |

Earlier reports can describe targets as open that later notes address. Original
claims and their corrections are both retained so their provenance remains
visible.

## Verification boundaries

- The 14 October record reports successful Lean 4.24.0 checks of
  `BruteForce.lean` and selected audit modules. The finite file uses
  **self-contained alternative definitions**: exact values through six
  vertices and construction lower bounds through twelve are its recorded
  results. Transferring those results to the standalone project's main
  definitions requires an equivalence proof.
- The [21 October source audit](local-progress/research-2026-10-21/repo-and-reduction-audit.md)
  describes the separate `lean-formalization` checkout at `1d40c5c` as
  **verification pending**. The main open problem and several literature
  statements have `sorry` bodies. A selected no-`sorryAx` audit is not a proof
  of all declarations or of the surrounding prose. The historical 4.24.0
  checks do not certify the separate 4.33.1 project configuration.
- Exhaustive finite computations and their small logs or JSON records are
  preserved with their original verification claims. They are distinct from
  Lean proofs. Later finite results referenced in the 24 October JSON belong
  to the separate public branch linked above.
- The asymptotic and finite-field extensions are **written analytic proofs
  with recorded audits**, not Lean-certified results. Historical novelty,
  record status, and external acceptance remain unestablished. The archive
  contains no solution of unrestricted Erdős problem #810; restricted
  palette/support results do not provide a reduction for arbitrary graphs.
- Archive preparation checked file integrity, JSON parsing, and Python syntax.
  It did not rerun Lean builds, graph enumerations, searches, or proof audits.

## Integrity and exclusions

[`MANIFEST.json`](MANIFEST.json) lists every copied file, its byte size, and
SHA-256 digest, along with the excluded files and reasons. All 249 included
files were checked against the source snapshot. The manifest covers the
faithful copies under `local-progress/`, not this new index or the manifest
itself.

Excluded material consists of Git/dependency/cache directories, compiled Lean
artifacts, native search executables, and the downloaded third-party snapshot
under `overnight-2026-10-15/reference-sources/`. Source programs and small
verification records are retained. No workflow was installed and no search is
started by these archival files.

For the excluded incidence-proof sources, use the retained
[source audit](local-progress/overnight-2026-10-15/pass3-lewko-incidence-source-audit.md),
the [upstream repository at the audited revision](https://github.com/mrklwk/szemeredi-trotter-lean/tree/844228bc6c042e59373888d1b69f4e215d1c00e4),
and the [cited paper version](https://arxiv.org/html/2609.27023v3).
Historical links into the omitted local `reference-sources/` directory remain
in the original files and intentionally do not resolve in this archive.
