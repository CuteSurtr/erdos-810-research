"""Count the pair-graph cut in two ways for a proper rainbow-four-cycle graph."""
import argparse
from collections import defaultdict
from fractions import Fraction
from itertools import combinations
import json
from math import comb, sqrt
from pathlib import Path


def pair(i, j):
    return (i, j) if i < j else (j, i)


def calculate(n, edges, materialize=False):
    classes = defaultdict(list)
    support = set()
    for u, v, c in edges:
        assert 0 <= u < n and 0 <= v < n and u != v
        p = pair(u, v)
        assert p not in support
        support.add(p)
        classes[c].append(p)
    volume = inside_volume = 0
    cross_sizes = [0, 0, 0]
    links = set()
    for matching in classes.values():
        ends = {u for edge in matching for u in edge}
        k = len(matching)
        assert len(ends) == 2*k
        volume += 2*k*(k-1)
        inside_volume += sum(pair(u,v) in support for u,v in combinations(ends,2)) - k
        for (a,b), (c,d) in combinations(matching,2):
            first = int(pair(a,c) in support) + int(pair(b,d) in support)
            second = int(pair(a,d) in support) + int(pair(b,c) in support)
            assert first <= 1 and second <= 1
            cross_sizes[first+second] += 1
            assert (first-second)**2 == int(first+second == 1)
            if materialize:
                for u,v in [(pair(a,c),pair(b,d)), (pair(a,d),pair(b,c))]:
                    link = pair(u,v)
                    assert link not in links and not (u in support and v in support)
                    links.add(link)
    if materialize:
        assert 2*len(links) == volume
        assert sum(int(u in support) + int(v in support) for u,v in links) == inside_volume
    n0,n1,n2 = cross_sizes
    assert volume == 4*(n0+n1+n2)
    assert inside_volume == n1+2*n2
    assert volume//2-inside_volume == 2*n0+n1
    return volume, inside_volume, cross_sizes


if __name__ == "__main__":
    parser = argparse.ArgumentParser(__doc__)
    parser.add_argument("catalog", type=Path)
    parser.add_argument("n", type=int)
    parser.add_argument("--explicit", action="store_true", help="also construct every pair-graph edge")
    args = parser.parse_args()
    edges = json.loads(args.catalog.read_text())[str(args.n)]
    vol, w, counts = calculate(args.n, edges, args.explicit)
    print("Volume, volume on original edges, counts by crossing size:", vol, w, counts)
    if w:
        nonedges = comb(args.n,2)-len(edges)
        tail = (vol-2*w)/nonedges
        ordinary = (tail-sqrt(tail**2+4*w**2/(len(edges)*nonedges)))/2
        print("Normalized least eigenvalue is at most", -Fraction(w, vol-w))
        print(f"Ordinary least eigenvalue is at most {ordinary:.8f} (rounded).")
