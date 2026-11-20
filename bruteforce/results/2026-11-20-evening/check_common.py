"""Check stored witnesses by counting cycles through pairs of opposite vertices."""
from itertools import combinations
import json
from math import comb
from pathlib import Path
import sys


def check(n, edges):
    rows = [{} for _ in range(n)]
    for u, v, color in edges:
        assert 0 <= u < n and 0 <= v < n and u != v
        assert v not in rows[u] and 0 <= color < n
        rows[u][v] = rows[v][u] = color
    double_count = 0
    for first, second in combinations(rows, 2):
        common = first.keys() & second.keys()
        if len(common) < 2:
            continue
        # Any two edges between the two rows and these neighbors share a C4.
        colors = {row[w] for row in (first, second) for w in common}
        assert len(colors) == 2 * len(common)
        double_count += comb(len(common), 2)
    assert double_count % 2 == 0
    return f"{n} {len(edges)} edges {double_count // 2} 4-cycles OK"


if __name__ == "__main__":
    graphs = json.loads(Path(sys.argv[1]).read_text())
    for n in sorted(map(int, graphs)):
        print(check(n, graphs[str(n)]))
