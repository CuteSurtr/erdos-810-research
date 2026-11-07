#!/usr/bin/env python3
"""Independent Burnside count of unlabeled n-vertex, m-edge simple graphs.

For each cycle type in S_n, enumerate its induced cycles on unordered vertex
pairs. A fixed graph is a union of those edge cycles. Its generating function
is the product of (1+x^length). Average the selected coefficient over S_n.
This counts all hosts, not rainbow-colorable hosts.
"""
import collections
import itertools
import json
import math
import sys


def partitions(n, minimum=1):
    if n == 0:
        yield ()
    for first in range(minimum, n + 1):
        for rest in partitions(n - first, first):
            yield (first,) + rest


def count(n, m):
    numerator = 0
    records = []
    for shape in partitions(n):
        perm = []
        for length in shape:
            start = len(perm)
            perm.extend(list(range(start + 1, start + length)) + [start])
        remaining = set(itertools.combinations(range(n), 2))
        edge_cycles = []
        while remaining:
            edge = min(remaining)
            length = 0
            while edge in remaining:
                remaining.remove(edge)
                length += 1
                edge = tuple(sorted((perm[edge[0]], perm[edge[1]])))
            edge_cycles.append(length)
        assert sum(edge_cycles) == math.comb(n, 2)
        coefficients = [1] + [0] * m
        for length in edge_cycles:
            for degree in range(m, length - 1, -1):
                coefficients[degree] += coefficients[degree - length]
        centralizer = math.prod(length ** multiplicity * math.factorial(multiplicity)
                                for length, multiplicity in collections.Counter(shape).items())
        class_size = math.factorial(n) // centralizer
        fixed = coefficients[m]
        numerator += class_size * fixed
        records.append({'vertex_cycle_type': shape, 'edge_cycle_lengths': edge_cycles,
                        'class_size': class_size, 'fixed_graphs': fixed})
    assert sum(r['class_size'] for r in records) == math.factorial(n)
    assert numerator % math.factorial(n) == 0
    return {'n': n, 'm': m, 'unlabeled_graphs': numerator // math.factorial(n),
            'burnside_numerator': numerator, 'group_order': math.factorial(n),
            'cycle_types': records}


if __name__ == '__main__':
    n, m = map(int, sys.argv[1:])
    assert 0 <= m <= math.comb(n, 2)
    print(json.dumps(count(n, m), indent=2))
