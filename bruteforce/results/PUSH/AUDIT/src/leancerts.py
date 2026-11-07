"""Audit: extract cert4..cert12 from BruteForce.lean (lean-formalization branch) and re-check
them with the independent checker of certcheck.py (colours must lie in 0..n-1)."""
import re, sys, itertools
src = open(sys.argv[1]).read()
for m in re.finditer(r"def cert(\d+)\b[^\[]*(\[[^\]]*(?:\][^\]]*)*?\])\s*\n", src):
    pass
for n in range(4, 13):
    mm = re.search(r"def cert%d\b(.*?)(?=\ndef |\ntheorem |\nset_option|\n/-)" % n, src, re.S)
    body = mm.group(1)
    E = [tuple(map(int, t)) for t in re.findall(r"\(\((\d+),\s*(\d+)\),\s*(\d+)\)", body)]
    col = {}
    ok = True
    for u, v, c in E:
        if not (0 <= u < n and 0 <= v < n and u != v and 0 <= c < n): ok = False
        col[frozenset((u, v))] = c
    adj = [set() for _ in range(n)]
    for k in col:
        a, b = tuple(k); adj[a].add(b); adj[b].add(a)
    for a, c in itertools.combinations(range(n), 2):
        for b, d in itertools.combinations(sorted(adj[a] & adj[c]), 2):
            if len({col[frozenset(p)] for p in ((a, b), (b, c), (c, d), (d, a))}) < 4: ok = False
    print(f"lean cert{n}: {len(col)} edges ({len(E)} entries), valid={ok}")
