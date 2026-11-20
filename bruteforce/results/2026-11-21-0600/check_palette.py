"""Verify small rainbow four-cycle witnesses with an arbitrary palette size."""
from itertools import combinations
import json
from pathlib import Path
import sys


def check(witness):
    n, k, edges = witness["n"], witness["k"], witness["edges"]
    graph = [{} for _ in range(n)]
    used = set()
    for u, v, color in edges:
        if not 0 <= u < v < n or not 0 <= color < k or v in graph[u]:
            raise ValueError(f"invalid edge {(u, v, color)}")
        graph[u][v] = graph[v][u] = color
        used.add(color)
    cycles = 0
    for a, b, c, d in combinations(range(n), 4):
        for u, v, w, x in ((a, b, c, d), (a, c, b, d), (a, b, d, c)):
            labels = (graph[u].get(v), graph[v].get(w), graph[w].get(x), graph[x].get(u))
            if None in labels:
                continue
            if len(set(labels)) != 4:
                raise ValueError(f"repeated color on cycle {(u, v, w, x)}")
            cycles += 1
    if cycles != witness["cycles"]:
        raise ValueError(f"expected {witness['cycles']} cycles and counted {cycles}")
    return n, k, len(edges), len(used), cycles


if __name__ == "__main__":
    for item in json.loads(Path(sys.argv[1]).read_text()):
        print(*check(item))
