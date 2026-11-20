"""Write a sorted colored graph from a seed and successive vertex additions."""
import argparse
from array import array
import json
import lzma
from pathlib import Path
import sys


def open_text(path):
    if path.suffix == ".xz":
        return lzma.open(path, "rt", encoding="ascii")
    return path.open(encoding="ascii")


def rebuild(seed, start, target, extensions, output):
    if not 1 <= start <= target <= 8192:
        raise ValueError("expected 1 <= seed order <= target order <= 8192")
    rows = [array("I") for _ in range(target)]
    color_bits = 13
    color_mask = (1 << color_bits) - 1
    edges = 0

    def insert(u, v, color, order):
        nonlocal edges
        if u == v or not (0 <= u < order and 0 <= v < order and 0 <= color < order):
            raise ValueError(f"invalid edge {u} {v} {color} at order {order}")
        if v < u:
            u, v = v, u
        rows[u].append((v << color_bits) | color)
        edges += 1

    with open_text(seed) as source:
        if seed.suffix == ".json":
            for u, v, color in json.load(source)[str(start)]:
                insert(u, v, color, start)
        else:
            order, size = map(int, source.readline().split())
            if order != start or size < 0:
                raise ValueError("seed header disagrees with requested order")
            for line in source:
                u, v, color = map(int, line.split())
                insert(u, v, color, start)
            if edges != size:
                raise ValueError("incorrect number of seed edges")

    next_vertex = start
    for path in extensions:
        if next_vertex == target:
            break
        with open_text(path) as source:
            for line in source:
                vertex, degree, *pairs = map(int, line.split())
                if vertex != next_vertex or degree < 0 or len(pairs) != 2 * degree:
                    raise ValueError(f"invalid extension at vertex {next_vertex}")
                for i in range(0, len(pairs), 2):
                    u, color = pairs[i:i + 2]
                    if not 0 <= u < vertex:
                        raise ValueError(f"invalid earlier endpoint at vertex {vertex}")
                    insert(u, vertex, color, vertex + 1)
                next_vertex += 1
                if next_vertex == target:
                    break
    if next_vertex != target:
        raise ValueError(f"spoke records end at order {next_vertex}, requested {target}")

    output.write(f"{target} {edges}\n")
    for u, row in enumerate(rows):
        previous = -1
        for packed in sorted(row):
            v = packed >> color_bits
            if v == previous:
                raise ValueError(f"duplicate edge {u} {v}")
            output.write(f"{u} {v} {packed & color_mask}\n")
            previous = v


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("seed", type=Path, help="JSON archive or a colored text edge list")
    parser.add_argument("start", type=int)
    parser.add_argument("target", type=int)
    parser.add_argument("extensions", type=Path, nargs="*", help="ordered text or .xz spoke records")
    args = parser.parse_args()
    try:
        rebuild(args.seed, args.start, args.target, args.extensions, sys.stdout)
    except (ValueError, KeyError, OSError) as error:
        parser.exit(1, f"{error}\n")
