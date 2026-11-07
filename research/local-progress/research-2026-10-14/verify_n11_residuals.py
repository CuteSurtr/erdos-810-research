#!/usr/bin/env python3
"""Independent cycle-based verification of the order-11 residual certificates."""
import itertools
import json
import re
from pathlib import Path

HERE = Path(__file__).resolve().parent


def verify():
    masks = [int(x) for x in re.findall(r'graphmask=(\d+)',
                                      (HERE/'n11_residuals.log').read_text())]
    assert len(masks) == 36 and len(set(masks)) == 36
    records = []
    for mask in masks:
        edges = [e for i,e in enumerate(itertools.combinations(range(11),2)) if mask >> i & 1]
        assert len(edges) == 35
        indices = {e:i for i,e in enumerate(edges)}
        conflict = [set() for _ in edges]
        cycles = 0
        for a,b,c,d in itertools.combinations(range(11),4):
            for vertices in ((a,b,c,d),(a,b,d,c),(a,c,b,d)):
                cycle = [tuple(sorted((vertices[i],vertices[(i+1)%4]))) for i in range(4)]
                if all(e in indices for e in cycle):
                    cycles += 1
                    active = {indices[e] for e in cycle}
                    for i in active:
                        conflict[i].update(active-{i})
        # A direct exhaustive check of all C(35,4)=52,360 four-edge sets.
        assert all(any(j in conflict[i] for i,j in itertools.combinations(subset,2))
                   for subset in itertools.combinations(range(35),4))
        independent_three = next(subset for subset in itertools.combinations(range(35),3)
                                 if all(j not in conflict[i]
                                        for i,j in itertools.combinations(subset,2)))
        adjacency = [set() for _ in range(11)]
        for u,v in edges:
            adjacency[u].add(v)
            adjacency[v].add(u)
        degree = [len(s) for s in adjacency]
        assert sorted(degree) == [5]+[6]*5+[7]*5
        z = degree.index(5)
        A = adjacency[z]
        B = set(range(11))-A-{z}
        assert len(A) == len(B) == 5
        assert all(len(adjacency[v]&A) == 2 for v in A)
        assert all(len(adjacency[v]&B) == 2 for v in B)
        assert all(len(adjacency[v]&B) == 4 for v in A)
        assert all(len(adjacency[v]&A) == 4 for v in B)
        records.append({'graphmask':mask, 'edges':edges, 'degree_sequence':sorted(degree,reverse=True),
                        'C4s':cycles, 'alpha_exact':3,
                        'independent_triple':[edges[i] for i in independent_three],
                        'family_A':sorted(A), 'family_B':sorted(B), 'family_z':z})
    isomorphisms = json.loads((HERE/'n11_residual_isomorphisms.json').read_text())
    by_mask = {r['graphmask']:r for r in records}
    for entry in isomorphisms['graphs']:
        source = by_mask[entry['graphmask']]
        target = {tuple(e) for e in isomorphisms['representatives'][str(entry['type_C4s'])]}
        mapping = {int(x):y for x,y in entry['isomorphism_to_type_representative'].items()}
        assert sorted(mapping) == sorted(mapping.values()) == list(range(11))
        assert {tuple(sorted((mapping[u],mapping[v]))) for u,v in source['edges']} == target
        assert source['C4s'] == entry['type_C4s']
    assert len(isomorphisms['graphs']) == 36
    # Distinct C4 counts prove that the two representatives are not isomorphic.
    assert {r['C4s'] for r in records} == {128,130}
    (HERE/'n11_residual_certificate.json').write_text(json.dumps(records,indent=2)+'\n')
    print('PASS: 36 residuals, exactly two isomorphism types, all alpha(Q)=3.')
    print('PASS: all residuals belong to the crown-plus-two-C5-plus-star family.')


if __name__ == '__main__':
    verify()
