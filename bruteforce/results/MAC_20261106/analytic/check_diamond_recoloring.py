#!/usr/bin/env python3
"""Finite stress checks, not a proof of the general transfer theorem."""
from itertools import combinations
from pathlib import Path
import json
import random


def free74(edges):
    return all(len(set.union(*part)) >= 8 for part in combinations(edges, 4))


def build(n, edges):
    # Three triples on four points are an explicitly excluded exceptional case.
    if len(edges) == 3 and len(set.union(*edges)) == 4:
        return None
    blocks = []
    covered = set()
    for ids in combinations(range(len(edges)), 3):
        support = set.union(*(edges[i] for i in ids))
        if len(support) == 5:
            if any(i in covered for i in ids):
                assert set(ids) <= covered
                continue
            assert all(not (edge & support) for i, edge in enumerate(edges) if i not in ids)
            blocks.append((ids, support))
            covered.update(ids)
    diamonds = []
    for i, j in combinations(range(len(edges)), 2):
        if i in covered or j in covered or len(edges[i] & edges[j]) != 2:
            continue
        support = edges[i] | edges[j]
        assert all(len(edge & support) <= 1 for k, edge in enumerate(edges) if k not in (i, j))
        diamonds.append((i, j, support))
    assert all(not (a[2] & b[2]) for a, b in combinations(diamonds, 2))
    graph = {}
    for i, edge in enumerate(edges):
        if i not in covered:
            for pair in combinations(sorted(edge), 2):
                graph.setdefault(pair, next(iter(edge - set(pair))))
    for i, j, support in diamonds:
        a, b = sorted(edges[i] & edges[j])
        c = next(iter(edges[i] - edges[j]))
        d = next(iter(edges[j] - edges[i]))
        assignment = [(a,b,a),(a,c,a),(a,d,b),(b,c,c),(b,d,d)]
        for u, v, color in assignment:
            graph[tuple(sorted((u, v)))] = color
    template = [(0,1,4),(0,2,3),(0,3,2),(0,4,0),(1,2,1),(1,4,4),(2,3,0)]
    for ids, support in blocks:
        vertices = sorted(support)
        for u, v, c in template:
            graph[(vertices[u], vertices[v])] = vertices[c]
    assert len(graph) == 3*len(edges)-len(diamonds)-2*len(blocks)
    remainder = set().union(*(edge for i,edge in enumerate(edges) if i not in covered)) if len(covered)<len(edges) else set()
    attach = blocks
    if not remainder and blocks:
        remainder = blocks[0][1]
        attach = blocks[1:]
    if attach:
        u,v = sorted(remainder)[:2]
        for ids,support in attach:
            vertices=sorted(support)
            # Template vertices 1 and 3 are nonadjacent.
            graph[tuple(sorted((u,vertices[1])))] = 0
            graph[tuple(sorted((v,vertices[3])))] = 0
    assert len(graph) == 3*len(edges)-len(diamonds)-2*len(blocks)+2*len(attach)
    assert all(0 <= c < n for c in graph.values())
    checked = 0
    for a,b,c,d in combinations(range(n), 4):
        for cycle in ((a,b,c,d),(a,b,d,c),(a,c,b,d)):
            pairs = [tuple(sorted((cycle[i],cycle[(i+1)%4]))) for i in range(4)]
            if all(pair in graph for pair in pairs):
                checked += 1
                assert len({graph[pair] for pair in pairs}) == 4, (n, edges, cycle, graph)
    return len(diamonds), len(blocks), checked, 2*len(attach)


def main():
    total = dict(families=0, exceptional_skipped=0, diamonds=0, blocks=0, cycles=0, attachment_edges=0)
    def check(n, edges):
        assert free74(edges)
        result = build(n, edges)
        if result is None:
            total['exceptional_skipped'] += 1
            return
        total['families'] += 1
        for key, value in zip(('diamonds','blocks','cycles','attachment_edges'), result):
            total[key] += value
    for n in range(3, 8):
        triples = list(map(set, combinations(range(n), 3)))
        for size in range(1, 4):
            for family in combinations(triples, size):
                check(n, list(family))
    rng = random.Random(81020261106)
    for n in (8,9,10,12,15,18):
        for run in range(20):
            candidates = list(map(set, combinations(range(n), 3)))
            rng.shuffle(candidates)
            family = []
            if run % 2 == 0:
                family = [{0,1,2}, {0,1,3}]
            for edge in candidates:
                if edge not in family and all(len(edge|a|b|c)>=8 for a,b,c in combinations(family,3)):
                    family.append(edge)
            check(n, family)
    for a in range(1,4):
        for b in range(3):
            for singleton in (0,1):
                family=[]
                offset=0
                for _ in range(a):
                    family += [{offset+i for i in part} for part in ((0,1,2),(0,1,3),(0,3,4))]
                    offset+=5
                for _ in range(b):
                    family += [{offset+i for i in part} for part in ((0,1,2),(0,1,3))]
                    offset+=4
                if singleton:
                    family.append(set(range(offset,offset+3)))
                    offset+=3
                check(offset,family)
    total['status'] = 'all assertions passed'
    total['seed'] = 81020261106
    total['scope'] = 'all 1-3 triple families on 3-7 vertices, 120 greedy samples, 18 disjoint-block attachment cases'
    Path(__file__).with_name('diamond-recoloring-checks.json').write_text(json.dumps(total,indent=2)+'\n')
    print(json.dumps(total,indent=2))


if __name__ == '__main__':
    main()
