#!/usr/bin/env python3
"""Verify every saved positive witness and all claimed isomorphism maps."""
import itertools
import json
import re
from pathlib import Path

HERE = Path(__file__).resolve().parent


def verify_coloring(edges, colors):
    assert len(edges) == len(colors) == 30
    assert all(0 <= c < 10 for c in colors)
    labeling = dict(zip(edges,colors))
    count = 0
    for a,b,c,d in itertools.combinations(range(10),4):
        for vertices in ((a,b,c,d),(a,b,d,c),(a,c,b,d)):
            cycle = [tuple(sorted((vertices[i],vertices[(i+1)%4]))) for i in range(4)]
            if all(e in labeling for e in cycle):
                assert len({labeling[e] for e in cycle}) == 4
                count += 1
    assert count == 95


def main():
    data = json.loads((HERE/'n10_extremal_isomorphisms.json').read_text())
    raw = re.findall(r'COLORABLE graphmask=(\d+) colors=([0-9,]+)',
                     (HERE/'n10_extremal_classification.log').read_text())
    all_pairs = list(itertools.combinations(range(10),2))
    originals = {}
    for smask, palette in raw:
        mask = int(smask)
        assert mask not in originals
        edges = [e for i,e in enumerate(all_pairs) if mask >> i & 1]
        colors = [int(c) for c in palette.rstrip(',').split(',')]
        verify_coloring(edges, colors)
        originals[mask] = set(edges)
    assert len(originals) == len(data['graphs']) == 288
    for row in data['graphs']:
        mapping = {int(x):y for x,y in row['isomorphism'].items()}
        assert sorted(mapping) == sorted(mapping.values()) == list(range(10))
        target = {tuple(e) for e in data['representatives'][row['type']]['edges']}
        source = originals[row['graphmask']]
        assert {tuple(sorted((mapping[u],mapping[v]))) for u,v in source} == target
    first,second = data['representatives']
    for row in (first,second):
        verify_coloring([tuple(e) for e in row['edges']],row['coloring'])
    cycle1,cycle2 = first['complement_prism_cycles']
    prism = {tuple(sorted((cycle[i],cycle[(i+1)%5]))) for cycle in (cycle1,cycle2) for i in range(5)}
    prism |= {tuple(sorted((cycle1[i],cycle2[i]))) for i in range(5)}
    assert prism == set(all_pairs)-{tuple(e) for e in first['edges']}
    cycle = second['complement_Mobius_cycle']
    mobius = {tuple(sorted((cycle[i],cycle[(i+1)%10]))) for i in range(10)}
    mobius |= {tuple(sorted((cycle[i],cycle[(i+5)%10]))) for i in range(5)}
    assert mobius == set(all_pairs)-{tuple(e) for e in second['edges']}
    # The prism contains a C5; M10 is bipartite (cycle-index parity).
    assert all((cycle.index(u)-cycle.index(v))%2 for u,v in mobius)
    print('PASS: 288 independent coloring checks; exactly two certified graph types.')
    print('Types: complements of the pentagonal prism and the ten-vertex Mobius ladder.')


if __name__ == '__main__':
    main()
