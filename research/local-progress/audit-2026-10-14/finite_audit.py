#!/usr/bin/env python3
"""Independent finite certificate audit; standard library only.

Enumerates all three undirected Hamilton cycles on each four-vertex set.
Does not call any checker from the original search code.
"""
import ast
import itertools
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def load_certificates():
    tree = ast.parse((ROOT / 'search/erdos810_search.py').read_text())
    certs = next(ast.literal_eval(t.value) for t in tree.body
                 if isinstance(t, ast.Assign) and any(
                     isinstance(v, ast.Name) and v.id == 'CERTIFICATES'
                     for v in t.targets))
    result = {n: [(u, v, c) for (u, v), c in es] for n, es in certs.items()}
    data = json.loads((ROOT / 'search/results.json').read_text())
    for n, rec in data['lower_bounds'].items():
        if 'edges' in rec:
            assert len(rec['edges']) == rec['lower_bound']
            result[int(n)] = rec['edges']
    return result


def cycles(n):
    for a, b, c, d in itertools.combinations(range(n), 4):
        for order in ((a,b,c,d), (a,b,d,c), (a,c,b,d)):
            yield tuple(tuple(sorted((order[i], order[(i+1)%4]))) for i in range(4))


def verify(n, triples):
    edgecolors = {}
    for u, v, color in triples:
        assert 0 <= u < v < n and 0 <= color < n
        assert (u,v) not in edgecolors
        edgecolors[(u,v)] = color
    count = 0
    for cycle in cycles(n):
        if all(edge in edgecolors for edge in cycle):
            assert len({edgecolors[edge] for edge in cycle}) == 4, (n, cycle)
            count += 1
    degrees = [sum(v in e for e in edgecolors) for v in range(n)]
    return {'vertices': n, 'edges': len(triples), 'colors_used': len(set(edgecolors.values())),
            'C4_count': count, 'degree_sequence': sorted(degrees, reverse=True)}


def fixed_coloring_extensions(n, triples):
    """Return edges addable without recoloring, using only the n permitted colors."""
    edgecolors = {(u,v): c for u,v,c in triples}
    candidates = {}
    for e in itertools.combinations(range(n),2):
        if e not in edgecolors:
            candidates[e] = set(range(n))
    for cycle in cycles(n):
        absent = [e for e in cycle if e not in edgecolors]
        if len(absent) == 1:
            colors = [edgecolors[e] for e in cycle if e in edgecolors]
            if len(set(colors)) != 3:
                candidates[absent[0]].clear()
            else:
                candidates[absent[0]].difference_update(colors)
    return [(u,v,c) for (u,v), colors in candidates.items() for c in sorted(colors)]


def main():
    records = []
    for n, triples in sorted(load_certificates().items()):
        row = verify(n, triples)
        row['fixed_coloring_extensions'] = fixed_coloring_extensions(n, triples)
        records.append(row)
        print(json.dumps(row))
    (Path(__file__).parent / 'finite_certificate_audit.json').write_text(json.dumps(records, indent=2)+'\n')


if __name__ == '__main__':
    main()
