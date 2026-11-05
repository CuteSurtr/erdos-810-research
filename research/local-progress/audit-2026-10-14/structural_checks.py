#!/usr/bin/env python3
"""Independent finite stress tests for the audit's written structural proofs.

Standard library only. These checks supplement, rather than replace, the proofs.
"""
from collections import Counter
from fractions import Fraction
from itertools import combinations, product
import json
from pathlib import Path
import random


def free74(edges):
    return all(len(set().union(*four)) >= 8 for four in combinations(edges, 4))


def overlap_components(edges):
    unseen = set(range(len(edges)))
    components = []
    while unseen:
        stack = [unseen.pop()]
        component = []
        while stack:
            i = stack.pop()
            component.append(i)
            nxt = {j for j in unseen if len(edges[i] & edges[j]) == 2}
            unseen -= nxt
            stack.extend(nxt)
        components.append(component)
    return components


def loss_bound(N):
    if N <= 3:
        return 0
    if N == 4:
        return 2
    return 2 * (N // 5) + (N % 5 == 4)


def check_linearization(N, edges):
    assert free74(edges)
    components = overlap_components(edges)
    assert all(len(c) <= 3 for c in components)
    supports = [set().union(*(edges[i] for i in c)) for c in components if len(c) > 1]
    assert all(not (a & b) for a, b in combinations(supports, 2))
    # A size-three path in the overlap graph need not be a clique. Keeping one
    # per component is a sufficient deletion algorithm, not always optimal.
    deletion = sum(len(c) - 1 for c in components)
    assert deletion <= loss_bound(N), (N, edges, deletion)
    linear = [edges[c[0]] for c in components]
    assert all(len(a & b) <= 1 for a, b in combinations(linear, 2))
    return deletion


def projection_stats(N, edges):
    assert N % 2 == 0 and N >= 6
    n = N // 2
    counts = []
    for selected in combinations(range(N), n):
        S = set(selected)
        # Keep one color per graph edge; the representative can be arbitrary.
        graph = {}
        for e in edges:
            pair = e & S
            if len(pair) == 2:
                graph.setdefault(tuple(sorted(pair)), next(iter(e - S)))
        for a, b, c, d in combinations(selected, 4):
            for cycle in ((a,b,c,d), (a,b,d,c), (a,c,b,d)):
                pairs = [tuple(sorted((cycle[i], cycle[(i+1) % 4]))) for i in range(4)]
                if all(p in graph for p in pairs):
                    assert len({graph[p] for p in pairs}) == 4
        counts.append(len(graph))
    avg = Fraction(sum(counts), len(counts))
    p = Fraction(3*n, 4*(2*n-1))
    q = Fraction(n*(n-1), 4*(2*n-1)*(2*n-3))
    degrees = Counter(pair for e in edges for pair in combinations(sorted(e), 2))
    assert max(degrees.values(), default=0) <= 3
    a2 = sum(d == 2 for d in degrees.values())
    a3 = sum(d == 3 for d in degrees.values())
    assert avg == p*len(edges) - q*(a2 + Fraction(5,2)*a3)
    assert a2 + Fraction(5,2)*a3 <= n
    assert avg >= p*len(edges) - n*q
    if all(d == 1 for d in degrees.values()):
        assert avg == p*len(edges)
    return len(counts)


def sharp_gadget(N):
    edges = []
    if N == 4:
        return [frozenset(e) for e in ((0,1,2),(0,1,3),(0,2,3))]
    for j in range(N // 5):
        b = 5*j
        edges += [frozenset((b,b+1,b+k)) for k in (2,3,4)]
    if N % 5 == 4:
        b = 5*(N // 5)
        edges += [frozenset((b,b+1,b+2)), frozenset((b,b+1,b+3))]
    return edges


def color_partitions(k):
    def rec(xs):
        if len(xs) == k:
            yield tuple(xs)
        else:
            for c in range(max(xs, default=-1)+2):
                yield from rec(xs+[c])
    yield from rec([])


def bipartite(N, edges):
    labels = {}
    for v in range(N):
        if v in labels:
            continue
        labels[v] = 0
        stack = [v]
        while stack:
            u = stack.pop()
            for e in edges:
                if u not in e:
                    continue
                w = next(iter(e - {u}))
                if w in labels:
                    if labels[w] == labels[u]:
                        return False
                else:
                    labels[w] = 1-labels[u]
                    stack.append(w)
    return True


def check_obstruction_classification():
    stats = Counter()
    partitions = list(color_partitions(4))
    for N in range(4,9):
        for es in combinations(combinations(range(N),2),4):
            edges = tuple(map(frozenset,es))
            if len(set().union(*edges)) != N or not bipartite(N,edges):
                continue
            deg = Counter(v for e in edges for v in e)
            for colors in partitions:
                if any(edges[i]&edges[j] and colors[i]==colors[j]
                       for i,j in combinations(range(4),2)):
                    continue
                t = len(set(colors))
                small_span = N+t <= 7
                nonrainbow_cycle = N == 4 and all(d == 2 for d in deg.values()) and t < 4
                alternating_path = N == 5 and sorted(deg.values()) == [1,1,2,2,2] and t == 2
                assert small_span == (nonrainbow_cycle or alternating_path)
                stats['proper_bipartite_four_edge_colorings'] += 1
                stats['nonrainbow_C4'] += int(nonrainbow_cycle)
                stats['alternating_P5'] += int(alternating_path)
    return dict(stats)


def main():
    stats = Counter()
    # For N<=7, (7,4)-free is exactly "at most three triples".
    for N in range(3,8):
        triples = list(map(frozenset, combinations(range(N),3)))
        for m in range(4):
            for edges in combinations(triples,m):
                check_linearization(N,edges)
                stats['exhaustive_small_hypergraphs'] += 1
                if N == 6:
                    stats['projection_partitions'] += projection_stats(N,edges)
    # Exhaust all four-triple configurations on eight vertices.
    triples = list(map(frozenset,combinations(range(8),3)))
    for edges in combinations(triples,4):
        if free74(edges):
            check_linearization(8,edges)
            stats['eight_vertex_four_triple_systems'] += 1
    rng = random.Random(810)
    for N in (8,10,12):
        triples = list(map(frozenset,combinations(range(N),3)))
        for _ in range(80):
            rng.shuffle(triples)
            edges = []
            for e in triples:
                if all(len(e | a | b | c) >= 8 for a,b,c in combinations(edges,3)):
                    edges.append(e)
            check_linearization(N,edges)
            stats['projection_partitions'] += projection_stats(N,edges)
            stats['random_greedy_hypergraphs'] += 1
    for N in range(3,61):
        edges = sharp_gadget(N)
        assert check_linearization(N,edges) == loss_bound(N)
        # Every gadget is an overlap clique, so at most one edge can be kept
        # per component. Thus the bound is attained, not just by our algorithm.
        for component in overlap_components(edges):
            assert all(len(edges[i]&edges[j]) == 2 for i,j in combinations(component,2))
        stats['sharp_linearization_examples'] += 1
    stats.update(check_obstruction_classification())
    result = dict(stats)
    print(json.dumps(result,indent=2))
    Path(__file__).with_name('structural-check-results.json').write_text(json.dumps(result,indent=2)+'\n')


if __name__ == '__main__':
    main()
