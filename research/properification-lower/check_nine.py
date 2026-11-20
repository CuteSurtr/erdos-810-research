"""Check the nine-vertex obstruction by four-subset enumeration and maximum matchings."""
from collections import Counter
from functools import lru_cache
from itertools import combinations
import json
from pathlib import Path
import sys


def check(record):
    n, k = record["vertices"], record["colors"]
    original = {tuple(sorted((u, v))): c for u, v, c in record["original"]}
    recolored = {tuple(sorted((u, v))): c for u, v, c in record["proper_recoloring"]}
    edges = sorted(original)
    if len(edges) != len(record["original"]) or len(recolored) != len(record["proper_recoloring"]):
        raise ValueError("duplicate edge")
    if set(recolored) != set(edges) - {tuple(record["recolor_delete"])}:
        raise ValueError("incorrect one-edge deletion")
    for graph in (original, recolored):
        if any(not 0 <= u < v < n or not 0 <= c < k for (u, v), c in graph.items()):
            raise ValueError("invalid vertex or color")
    index = {e: i for i, e in enumerate(edges)}
    conflict = [0] * len(edges)
    totals = [0, 0]
    for a, b, c, d in combinations(range(n), 4):
        for cycle in ((a,b,c,d), (a,c,b,d), (a,b,d,c)):
            boundary = [tuple(sorted((u,v))) for u, v in zip(cycle, cycle[1:] + cycle[:1])]
            for i, graph in enumerate((original, recolored)):
                if not all(e in graph for e in boundary):
                    continue
                if len({graph[e] for e in boundary}) != 4:
                    raise ValueError("nonrainbow cycle")
                totals[i] += 1
                if i == 0:
                    for x, y in combinations(map(index.get, boundary), 2):
                        conflict[x] |= 1 << y
                        conflict[y] |= 1 << x
    if totals != [record["original_cycles"], record["punctured_cycles"]]:
        raise ValueError("cycle counts disagree")
    deleted = set(map(tuple, record["kept_labels_delete"]))
    if len(deleted) != 5 or not deleted <= original.keys():
        raise ValueError("invalid five-edge certificate")
    kept = {e: c for e, c in original.items() if e not in deleted}
    for graph in (kept, recolored):
        used = [(u, c) for e, c in graph.items() for u in e]
        if len(set(used)) != len(used):
            raise ValueError("improper restriction or recoloring")

    adjacent = [sum(1 << j for j, f in enumerate(edges) if set(e).intersection(f)) for e in edges]

    @lru_cache(None)
    def matching(mask):
        if not mask:
            return 0
        edge = (mask & -mask).bit_length() - 1
        return max(matching(mask ^ (1 << edge)), 1 + matching(mask & ~adjacent[edge]))

    order = sorted(range(len(edges)), key=lambda i: -bin(conflict[i]).count("1"))
    histogram = Counter()

    def enumerate_partitions(pos, classes):
        if pos == len(order):
            histogram[len(edges) - sum(matching(c) for c in classes)] += 1
            return
        e = order[pos]
        for j, block in enumerate(classes):
            if not block & conflict[e]:
                classes[j] |= 1 << e
                enumerate_partitions(pos + 1, classes)
                classes[j] ^= 1 << e
        if len(classes) < k:
            classes.append(1 << e)
            enumerate_partitions(pos + 1, classes)
            classes.pop()

    enumerate_partitions(0, [])
    if histogram != {5: 64}:
        raise ValueError(f"unexpected inherited costs {histogram}")
    return dict(vertices=n, edges=len(edges), original_cycles=totals[0], punctured_cycles=totals[1],
                partitions=sum(histogram.values()), minimum_inherited=5, minimum_recolored=1)


if __name__ == "__main__":
    print(json.dumps(check(json.loads(Path(sys.argv[1]).read_text())), sort_keys=True))
