#!/usr/bin/env python3
"""Check all labeled 15-edge graphs on seven vertices, without symmetry pruning."""
import itertools
import json
import time
from pathlib import Path


def clique(candidates, needed, adjacency):
    if not needed:
        return True
    while candidates.bit_count() >= needed:
        bit = candidates & -candidates
        candidates ^= bit
        if clique(candidates & adjacency[bit.bit_length()-1], needed-1, adjacency):
            return True
    return False


def main():
    n, m = 7, 15
    edges = list(itertools.combinations(range(n), 2))
    stats = dict(graphs=0, conflict_K8=0, alpha_at_most_2=0, both_obstructions=0,
                 K8_free_alpha_at_most_2=0,
                 K8_free_with_independent_triple=0)
    start = time.time()
    for indices in itertools.combinations(range(21), 15):
        present = [edges[i] for i in indices]
        adjacency = [0]*n
        for a, b in present:
            adjacency[a] |= 1 << b
            adjacency[b] |= 1 << a
        conflict = [0]*m
        for i, (a,b) in enumerate(present):
            for j in range(i):
                c,d = present[j]
                common = set((a,b)) & set((c,d))
                if common:
                    v = next(iter(common))
                    x = next(x for x in (a,b) if x != v)
                    y = next(x for x in (c,d) if x != v)
                    adjacent = bool(adjacency[x] & adjacency[y] & ~(1 << v))
                else:
                    adjacent = bool(((adjacency[a] >> c & 1) and (adjacency[b] >> d & 1)) or
                                    ((adjacency[a] >> d & 1) and (adjacency[b] >> c & 1)))
                if adjacent:
                    conflict[i] |= 1 << j
                    conflict[j] |= 1 << i
        stats['graphs'] += 1
        independent = any(not(conflict[a] >> b & 1) and
                          not((conflict[a] | conflict[b]) >> c & 1)
                          for a,b,c in itertools.combinations(range(m),3))
        has_clique = clique((1 << m)-1, 8, conflict)
        if not independent:
            stats['alpha_at_most_2'] += 1
        if has_clique:
            stats['conflict_K8'] += 1
            if not independent:
                stats['both_obstructions'] += 1
        else:
            key = ('K8_free_with_independent_triple' if independent else
                   'K8_free_alpha_at_most_2')
            stats[key] += 1
    stats['elapsed_seconds'] = time.time()-start
    Path(__file__).with_name('n7_labeled_counts.json').write_text(json.dumps(stats,indent=2)+'\n')
    print(stats)


if __name__ == '__main__':
    main()
