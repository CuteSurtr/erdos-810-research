"""Independent re-check of checker output lines 'g6 u-v:c ...': decodes graph6
itself, checks the edge list equals the graph, colours in 0..K-1, and that every
4-cycle (all ordered 4-tuples of distinct vertices) has 4 distinct colours."""
import sys, itertools
def g6(s):
    n = ord(s[0]) - 63; bits = []
    for ch in s[1:]:
        v = ord(ch) - 63; bits += [(v >> (5 - i)) & 1 for i in range(6)]
    E = set(); k = 0
    for j in range(1, n):
        for i in range(j):
            if bits[k]: E.add((i, j))
            k += 1
    return n, E
K = int(sys.argv[1]); ok = bad = 0
for line in sys.stdin:
    parts = line.split()
    if not parts: continue
    n, E = g6(parts[0]); col = {}
    for t in parts[1:]:
        uv, c = t.split(':'); u, v = map(int, uv.split('-'))
        col[(min(u, v), max(u, v))] = int(c)
    good = set(col) == E and all(0 <= c < K for c in col.values())
    C = lambda a, b: col[(min(a, b), max(a, b))]
    for a, b, c, d in itertools.permutations(range(n), 4):
        if good and all((min(x, y), max(x, y)) in E for x, y in ((a, b), (b, c), (c, d), (d, a))):
            if len({C(a, b), C(b, c), C(c, d), C(d, a)}) != 4: good = False
    ok += good; bad += not good
print(f"verified {ok}, failed {bad}")
