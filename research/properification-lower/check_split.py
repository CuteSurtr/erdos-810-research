"""Audit the three stages of an edge insertion using complete colored edge lists."""
import argparse
from collections import Counter, defaultdict
from pathlib import Path
import subprocess


def load(path, auditor):
    with path.open("rb") as source:
        result = subprocess.run([auditor, "--cycles"], stdin=source, text=True,
                                capture_output=True, check=True)
    words = result.stdout.split()
    if words[1::2] != ["vertices", "edges", "colors", "four-cycles"]:
        raise ValueError("unrecognized C audit result")
    order, size, used, cycles = map(int, words[::2])
    with path.open() as source:
        if list(map(int, next(source).split())) != [order, size]:
            raise ValueError("header disagrees with C audit")
        graph = {}
        for row in source:
            u, v, color = map(int, row.split())
            edge = tuple(sorted((u, v)))
            if edge in graph or not 0 <= u < order or not 0 <= v < order or u == v or not 0 <= color < order:
                raise ValueError(f"invalid edge {edge}")
            graph[edge] = color
    if len(graph) != size or len(set(graph.values())) != used:
        raise ValueError("edge or palette count disagrees")
    return order, graph, cycles


def incident_pairs(graph):
    classes = defaultdict(list)
    for edge, c in graph.items():
        for v in edge:
            classes[v, c].append(edge)
    return [edges for edges in classes.values() if len(edges) > 1]


def check(paths, auditor):
    before, after, restored = [load(p, auditor) for p in paths]
    n, original, full_cycles = before
    if after[0] != n or restored[0] != n:
        raise ValueError("different orders")
    old, final = after[1], restored[1]
    inserted = (0, 1)
    if original.keys() - old.keys() != {inserted} or old.keys() - original.keys():
        raise ValueError("the punctured graph must remove exactly the distinguished edge")
    if incident_pairs(old) or incident_pairs(final):
        raise ValueError("both punctured and restored colorings must be proper")
    repeats = incident_pairs(original)
    if any(len(group) != 2 for group in repeats) or any(
            count != 1 for count in Counter(edge for pair in repeats for edge in pair).values()):
        raise ValueError("original inherited deletion certificate uses overlapping pairs")

    first = {label: v for (u, v), label in old.items() if u == 0}
    second = {label: v for (u, v), label in old.items() if u == 1}
    paths_through_edge = []
    for color in first.keys() & second.keys():
        a, b = first[color], second[color]
        middle = tuple(sorted((a, b)))
        if middle in old:
            paths_through_edge.append({(0, a), middle, (1, b)})
    if sum(map(len, paths_through_edge)) != len(set().union(*paths_through_edge)):
        raise ValueError("two conflicting cycles share an old edge")
    deleted = old.keys() - final.keys()
    if final.keys() - old.keys() != {inserted} or len(deleted) != len(paths_through_edge):
        raise ValueError("wrong support for a minimum-cost restoration")
    if any(len(deleted & path) != 1 for path in paths_through_edge):
        raise ValueError("a conflicting cycle was not hit exactly once")
    if any(final[e] != old[e] for e in old.keys() & final.keys()):
        raise ValueError("a surviving old edge changed its color")
    return n, len(original), len(repeats), len(deleted), full_cycles, after[2], restored[2]


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("auditor", help="compiled large/audit.c")
    parser.add_argument("graphs", type=Path, nargs=3, metavar="GRAPH")
    args = parser.parse_args()
    print(*check(args.graphs, args.auditor), sep="\t")
