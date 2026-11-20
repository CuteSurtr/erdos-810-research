"""Exhaust the small configurations that can support a four-cycle through a new hub."""

from collections import Counter, defaultdict
from itertools import combinations, product


def check(diamonds):
    # Two path edges can involve at most one common neighbor and two omitted colors
    # beyond the marked supports. Unused points allow smaller configurations too.
    n = 4 * diamonds + 3
    supports = [set(range(4 * i, 4 * i + 4)) for i in range(diamonds)]
    sides, paint, spokes = [], {}, {}
    for support in supports:
        a, b, c, d = sorted(support)
        sides.extend((frozenset((a, b, c)), frozenset((a, b, d))))
        paint.update({(a, b): a, (a, c): a, (a, d): b, (b, c): c, (b, d): d})
        spokes.update({a: d, c: b})

    candidates = [frozenset(t) for t in combinations(range(n), 3)
                  if all(len(s.intersection(t)) <= 1 for s in supports)]
    counts = Counter()
    for count in range(3):
        for external in combinations(candidates, count):
            triples = sides + list(external)
            if any(len(frozenset.union(*four)) <= 7 for four in combinations(triples, 4)):
                continue
            counts["families"] += 1
            colors = defaultdict(set)
            for t in triples:
                for u, v in combinations(sorted(t), 2):
                    colors[u, v].update(t - {u, v})
            for pair, color in paint.items():
                colors[pair] = {color}
            for u, v in combinations(spokes, 2):
                for x in range(n):
                    left = colors.get(tuple(sorted((u, x))), ())
                    right = colors.get(tuple(sorted((x, v))), ())
                    for p, q in product(left, right):
                        labels = (spokes[u], p, q, spokes[v])
                        if len(set(labels)) != 4:
                            raise ValueError((diamonds, external, u, x, v, labels))
                        same = u // 4 == v // 4
                        where = "inside" if any(x in s for s in supports) else "outside"
                        counts[("same" if same else "different") + "-" + where] += 1
    return dict(sorted(counts.items()))


if __name__ == "__main__":
    for count in (1, 2):
        print(count, check(count))
