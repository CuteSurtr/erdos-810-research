"""Analyze an unlabeled graph6 catalog, using nauty labelg to identify deletion cards."""
import argparse
import collections
import json
from pathlib import Path
import subprocess
import tempfile


def decode(record):
    n = record[0] - 63
    pairs = [(u, v) for v in range(n) for u in range(v)]
    if not 1 <= n <= 62 or len(record) != 1 + (len(pairs) + 5) // 6:
        raise ValueError("expected a short graph6 record")
    rows = [0] * n
    edges = []
    for i, (u, v) in enumerate(pairs):
        if (record[1 + i // 6] - 63) & (32 >> (i % 6)):
            rows[u] |= 1 << v
            rows[v] |= 1 << u
            edges.append((i, u, v))
    return rows, edges


def remove_vertex(rows, skip):
    vertices = [i for i in range(len(rows)) if i != skip]
    pairs = len(vertices) * (len(vertices) - 1) // 2
    result = bytearray([63] * (1 + (pairs + 5) // 6))
    result[0] += len(vertices)
    i = 0
    for j, v in enumerate(vertices):
        for u in vertices[:j]:
            if rows[u] & (1 << v):
                result[1 + i // 6] += 32 >> (i % 6)
            i += 1
    return result


def write_cards(stream, records, kind):
    for record in records:
        rows, edges = decode(record)
        if kind == "vertex":
            for v in range(len(rows)):
                stream.write(remove_vertex(rows, v) + b'\n')
        else:
            for pos, _, _ in edges:
                card = bytearray(record)
                card[1 + pos // 6] -= 32 >> (pos % 6)
                stream.write(card + b'\n')


def exchange(records, labelg, directory, kind, per_graph):
    cards = directory / "cards.g6"
    canonical = directory / "canonical.g6"
    with cards.open("wb") as stream:
        write_cards(stream, records, kind)
    subprocess.run([labelg, "-qt", cards, canonical], check=True)
    owners = collections.defaultdict(list)
    parent = list(range(len(records)))

    def root(i):
        while i != parent[i]:
            parent[i] = parent[parent[i]]
            i = parent[i]
        return i

    with canonical.open("rb") as stream:
        for i in range(len(records)):
            for card in set(stream.readline() for _ in range(per_graph)):
                if not card:
                    raise ValueError("truncated canonical output")
                bucket = owners[card]
                if bucket:
                    parent[root(i)] = root(bucket[0])
                bucket.append(i)
        if stream.read(1):
            raise ValueError("extra canonical output")
    sizes = collections.Counter(root(i) for i in range(len(records)))
    degrees = []
    with canonical.open("rb") as stream:
        for i in range(len(records)):
            neighbors = set()
            for card in set(stream.readline() for _ in range(per_graph)):
                neighbors.update(owners[card])
            neighbors.remove(i)
            degrees.append(len(neighbors))
    assert sum(degrees) % 2 == 0
    return dict(distinct_cards=len(owners), components=len(sizes),
                component_sizes=dict(sorted(collections.Counter(sizes.values()).items())),
                adjacent_pairs=sum(degrees) // 2, isolated=degrees.count(0),
                minimum_neighbors=min(degrees), maximum_neighbors=max(degrees))


def profile(records):
    hist = collections.defaultdict(collections.Counter)
    sequences = collections.Counter()
    for record in records:
        rows, edges = decode(record)
        degrees = tuple(sorted(r.bit_count() for r in rows))
        sequences[degrees] += 1
        hist["minimum_degree"][degrees[0]] += 1
        hist["maximum_degree"][degrees[-1]] += 1
        triangles = sum((rows[u] & rows[v]).bit_count() for _, u, v in edges)
        cycles = wedges = 0
        for v, row in enumerate(rows):
            for u in range(v):
                common = (row & rows[u]).bit_count()
                cycles += common * (common - 1) // 2
                wedges += (common == 1)
        assert cycles % 2 == 0 and triangles % 3 == 0
        hist["four_cycles"][cycles // 2] += 1
        hist["triangles"][triangles // 3] += 1
        hist["incident_pairs_on_no_four_cycle"][wedges] += 1
    return dict(degree_sequences={" ".join(map(str, d)): count
                                  for d, count in sorted(sequences.items())},
                **{key: dict(sorted(counts.items())) for key, counts in hist.items()})


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("catalog", type=Path)
    parser.add_argument("labelg")
    options = parser.parse_args()
    records = options.catalog.read_bytes().splitlines()
    if not records or len(set(records)) != len(records):
        raise ValueError("empty input or duplicate labeled records")
    rows, edges = decode(records[0])
    for record in records[1:]:
        r, e = decode(record)
        if len(r) != len(rows) or len(e) != len(edges):
            raise ValueError("catalog must have a fixed order and size")
    result = dict(vertices=len(rows), edges=len(edges), supports=len(records), **profile(records))
    with tempfile.TemporaryDirectory() as scratch:
        for kind, count in (("edge", len(edges)), ("vertex", len(rows))):
            result[kind + "_exchange"] = exchange(records, options.labelg, Path(scratch), kind, count)
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
