"""Emit a Lean kernel proof for graph witnesses stored as colored edges."""
import argparse
import json
from pathlib import Path


def certificate(n, edges):
    width = n.bit_length()
    rows = [0]*n
    for u,v,c in edges:
        a,b = sorted((u,v))
        if not (0 <= a < b < n and 0 <= c < n):
            raise ValueError("invalid edge or label")
        offset = width*b
        if rows[a] >> offset & ((1<<width)-1):
            raise ValueError("duplicate edge")
        rows[a] |= (c+1) << offset
    data = ",\n  ".join(map(str,rows))
    return f"""/-- A {len(edges)}-edge witness on {n} vertices in packed upper-triangular rows. -/
private def rows{n} : Array ℕ := #[
  {data}]

set_option maxRecDepth 20000 in
set_option maxHeartbeats 0 in
theorem matrix_lower_bound_{n} : {len(edges)} ≤ maxRainbowC4Edges {n} := by
  apply MatrixCertificate.lower_bound_fast rows{n} {width}
  · decide +kernel
  · intro a
    fin_cases a <;> decide +kernel
"""


def emit_many(entries, imports=()):
    header = "\n".join("import " + name for name in ("MatrixCertificate", *imports))
    body = "\n".join(certificate(n, edges) for n, edges in entries)
    checks = "\n".join("#assert_no_sorry Erdos810.matrix_lower_bound_" + str(n) for n, _ in entries)
    return f"{header}\n\nnamespace Erdos810\n\n{body}\nend Erdos810\n\n{checks}\n"


def emit(n, edges):
    return emit_many([(n, edges)])


if __name__ == "__main__":
    parser = argparse.ArgumentParser(__doc__)
    parser.add_argument("input", type=Path)
    parser.add_argument("vertices", help="One order or an inclusive range such as 13-36.")
    parser.add_argument("output", type=Path)
    parser.add_argument("--existing", type=int, nargs="*", default=[],
                        help="Import individual CertificateN modules already checked in the range.")
    args = parser.parse_args()
    endpoints = [int(x) for x in args.vertices.split("-")]
    if len(endpoints) not in (1, 2) or endpoints[-1] < endpoints[0]:
        parser.error("expected an increasing range of orders")
    graphs = json.loads(args.input.read_text())
    orders = range(endpoints[0], endpoints[-1] + 1)
    if any(n not in orders for n in args.existing):
        parser.error("existing modules must belong to the requested range")
    entries = [(n, graphs[str(n)]) for n in orders if n not in args.existing]
    args.output.write_text(emit_many(entries, ["Certificate" + str(n) for n in args.existing]))
