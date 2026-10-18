# Lean formalization of Erdős #810 (imported, verification pending)

This directory holds the Lean 4 sources of an earlier formalization of
[Erdős Problem #810](https://www.erdosproblems.com/810), imported
unchanged from a local archive so that they can be checked from a clean
build. No declaration here should be regarded as verified until this
file records the check.

## Contents

| Path | Role |
| --- | --- |
| `lean-toolchain`, `lakefile.toml`, `lake-manifest.json` | Lean `v4.33.1`, Mathlib `v4.33.1` (rev `0df444a`), formal-conjectures at `b3f2641` |
| `AntiRamsey.lean` | Rainbow labelings, the $C_4$-conflict graph, the maximal anti-Ramsey number $\chi_S(n,e,H)$, and lemmas about them |
| `Erdos810.lean` | The problem, its variants, the finite function $M(n)$, and equivalences between formulations |
| `Audit.lean` | Placeholder audit as imported |
| `legacy/` | Two self-contained files written for Lean `v4.24.0`; not build targets |

## Known status before verification

- `Erdos810.lean` states the open problem, its open variants, and several
  published results as theorems proved by `sorry`. The lakefile suppresses
  the corresponding warnings (`warn.sorry = false`). These statements are
  not proved here.
- `Audit.lean` checks a hand-written list of declarations for a
  dependence on `sorryAx` only.

Statements of open problems and cited results will be separated from
proved results before anything is reported as verified. The imported
files remain available in the history of this branch.

## Provenance and licence

The source headers carry Apache-2.0 notices naming The Formal Conjectures
Authors; they are preserved unchanged. The original upstream location of
these files has not been re-identified. The repository licence
(Apache-2.0) covers the rest of this directory.
