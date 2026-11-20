"""Enumerate admissible supports within a bounded number of edge exchanges from one seed."""
import argparse
import json
from pathlib import Path
import subprocess
import sys


def edits(graph, remove):
    n = graph[0] - 63
    for i in range(n * (n - 1) // 2):
        block, bit = 1 + i // 6, 32 >> (i % 6)
        if bool((graph[block] - 63) & bit) == remove:
            edited = bytearray(graph)
            edited[block] += -bit if remove else bit
            yield bytes(edited)


def encode(graphs):
    return b"".join(graph + b"\n" for graph in graphs)


def canonical(graphs, program):
    answer = subprocess.run([program, "-tq"], input=encode(graphs),
                            capture_output=True, check=True).stdout.splitlines()
    if len(answer) != len(graphs):
        raise ValueError("canonical labeling lost a graph")
    return sorted(set(answer))


def feasible(graphs, options):
    raw = encode(graphs)
    result = subprocess.run([options.cover, str(options.palette)], input=raw,
                            capture_output=True, check=True)
    accepted = set(result.stdout.splitlines())
    if not accepted.issubset(graphs):
        raise ValueError("checker returned an unrecognized input")
    if options.check_independent:
        result = subprocess.run([options.check_independent, str(options.palette)], input=raw,
                                capture_output=True, check=True)
        other = set()
        for line in result.stdout.splitlines():
            tag, graph, *_ = line.split()
            if tag != b"GOOD":
                raise ValueError("unexpected independent checker output")
            other.add(graph)
        if other != accepted:
            raise ValueError("the two native coloring decisions disagree")
    return sorted(accepted)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("seed", type=Path, help="one graph6 support")
    parser.add_argument("palette", type=int)
    parser.add_argument("depth", type=int)
    parser.add_argument("--labelg", required=True)
    parser.add_argument("--cover", required=True)
    parser.add_argument("--check-independent", help="optional V2 C checker for up to 64 edges")
    options = parser.parse_args()
    records = options.seed.read_bytes().splitlines()
    if len(records) != 1 or not records[0] or not 1 <= records[0][0] - 63 <= 16:
        parser.error("expected one graph6 support on at most 16 vertices")
    n = records[0][0] - 63
    if len(records[0]) != 1 + (n*(n-1)//2+5)//6:
        parser.error("invalid graph6 support")
    layer = canonical(records, options.labelg)
    m = sum(1 for _ in edits(layer[0], True))
    if not 1 <= options.depth <= m:
        parser.error("the deletion depth must be positive and fit the seed")
    if feasible(layer, options) != layer:
        raise ValueError("seed is infeasible")
    for remove in (True, False):
        for _ in range(options.depth):
            candidates = [g for graph in layer for g in edits(graph, remove)]
            distinct = canonical(candidates, options.labelg)
            layer = distinct if remove else feasible(distinct, options)
            m += -1 if remove else 1
            print(json.dumps(dict(edges=m, labeled=len(candidates), distinct=len(distinct),
                                  feasible=len(layer))), file=sys.stderr, flush=True)
    sys.stdout.buffer.write(encode(layer))


if __name__ == "__main__":
    main()
