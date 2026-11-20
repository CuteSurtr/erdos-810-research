"""Confirm that two particular edges must share a color in an optimal graph."""
from itertools import combinations
import json
from pathlib import Path

w = json.loads((Path(__file__).parent / "data/forced-repeat.json").read_text())
k, n = w["k"], w["n"]
colors = {(u, v): c for u, v, c in w["edges"]}
assert len(colors) == len(w["edges"]) == 47 and (n, k) == (13, 13)
assert all(0 <= u < v < n and 0 <= c < k for (u, v), c in colors.items())
witness = list(map(tuple, w["conflict_clique"]))
assert len(set(witness)) == len(witness) == k + 1 and set(witness) <= colors.keys()
together = set()
for a, b, c, d in combinations(range(n), 4):
    for i, j, h, l in ((a,b,c,d), (a,b,d,c), (a,c,b,d)):
        square = [tuple(sorted(pair)) for pair in ((i,j), (j,h), (h,l), (l,i))]
        if all(e in colors for e in square):
            assert len({colors[e] for e in square}) == 4
            together.update(frozenset(pair) for pair in combinations(square, 2))
missing = {frozenset(pair) for pair in combinations(witness, 2)} - together
forced = frozenset(map(tuple, w["forced_equal"]))
assert len(forced) == 2 and missing == {forced}
a, b = forced
assert set(a) & set(b) and colors[a] == colors[b]
print(f"{len(witness)} edges, {len(witness)*(len(witness)-1)//2-1} conflicting pairs, one forced equality")
