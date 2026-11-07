# Independent Lean verification

All checks below completed successfully on 2026-10-14 with exit code **0**. The original files were not edited.

The installed compiler is **Lean 4.24.0**, commit `797c613eb9b6d4ec95db23e3e00af9ac6657f24b`, with the workspace's Mathlib 4.24.0. The separate `erdos-810-lean/lean-toolchain` and Lake configuration specify **4.33.1**. That version is not installed and was not tested. These checks use the workspace's working 4.24.0 environment, matching the original standalone modules' documented compatibility.

| Source | Result | Axiom evidence |
| --- | --- | --- |
| `../HypergraphReduction.lean` | Compiles | All five printed main declarations have empty axiom sets. |
| `../BruteForce.lean` | Compiles | Its internal `#assert_no_sorry` checks accept the exact values through n=6, lower bounds through n=12, and listed structural equivalences. |
| `SemanticAudit.lean` | Compiles | Printed declarations use only `propext`. |
| `ProperBipartiteLift.lean` | Compiles | Printed declarations use only `propext`, `Classical.choice`, and `Quot.sound`. |
| `BipartiteHypergraphExtraction.lean` | Compiles | All three printed main declarations use only `propext`, `Classical.choice`, and `Quot.sound`. |

There is no `sorryAx` or `native_decide` dependency in the checked new declarations. Ordinary `decide` is used for the finite counterexamples. Standard foundational axioms are distinguished above from the original module's empty axiom sets.

The `BruteForce.lean` SHA-256 at verification was:

```text
aa3ef0db275ec10a1ac1640c17bad35d19ed8e79111a7f23ee31641815323de3
```

`formal-kernel-summary.json` records source hashes, observed exit statuses, compiler version, and log names. `bruteforce-kernel-check.txt` is empty because the compiler emitted no diagnostics; its observed completed exit status was 0. The other logs contain printed axiom sets.

## What the new files establish

- `SemanticAudit.lean`: Gemini's cycle-local span hypothesis is exactly equivalent to rainbow-C4 for symmetric colorings. A monochromatic star separates that hypothesis from actual global (7,4)-freeness.
- `ProperBipartiteLift.lean`: an alternating two-color path on five vertices is properly colored and bipartite, is rainbow-C4, and has an exact 3-uniform linear lift consisting of four triples whose union has seven points. Thus adding properness, bipartiteness, and linearity does not repair the claimed equivalence.
- `BipartiteHypergraphExtraction.lean`: actual global (7,4)-freeness implies rainbow rectangles in a bipartite graph extracted from the family. It also rules out alternating four-edge paths on five vertices. The global hypothesis quantifies over all four-element subfamilies, not merely cycle-shaped ones.
- `lift-classification.txt` supplies the full mathematical classification for proper bipartite colorings: global (7,4)-freeness is equivalent to rainbow-C4 plus absence of alternating two-color four-edge paths. Its general converse is **not** claimed to be formalized.

The successful original compilation does not validate claims made only in prose. In particular, `HypergraphReduction.lean` contains neither the full extremal BEGS reduction nor a certificate for the 37,569 enumerated graph cases. It is also absent from the project's default Lake targets and its `Audit.lean` imports.

## Reproduction

Run from the workspace root, preserving the trailing space in its directory name:

```bash
cd '/Users/jiho/Desktop/lean 4 '
audit_lean='.elan/toolchains/leanprover--lean4---v4.24.0/bin/lean'
audit_dir='erdos-810-lean/audit-2026-10-14'

"$audit_lean" --version
"$audit_lean" -o "$audit_dir/HypergraphReduction.olean" \
  erdos-810-lean/HypergraphReduction.lean

LEAN_PATH="$audit_dir" "$audit_lean" "$audit_dir/SemanticAudit.lean"

ELAN_HOME="$PWD/.elan" LEAN_PATH="$PWD/$audit_dir" .elan/bin/lake env lean \
  "$audit_dir/ProperBipartiteLift.lean"

ELAN_HOME="$PWD/.elan" LEAN_PATH="$PWD/$audit_dir" .elan/bin/lake env lean \
  "$audit_dir/BipartiteHypergraphExtraction.lean"

ELAN_HOME="$PWD/.elan" .elan/bin/lake env lean erdos-810-lean/BruteForce.lean
```

The generated `HypergraphReduction.olean` in the audit directory supplies the exact original module to the new audit files. The commands invoking `lake` must run from the workspace root so that they use the installed 4.24.0 project and dependency tree.
