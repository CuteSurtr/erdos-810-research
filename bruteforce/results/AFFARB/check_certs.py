"""Second, format-level checker for certs.json ({"n": [[u, v, c], ...]}): no loops, no repeated
edges, colours in 0..n-1, proper colouring, every 4-cycle rainbow (all 4-cycles enumerated as
v0-v1-v2-v3 with v1, v3 common neighbours of v0, v2).  Does not use the affine description."""
import json, itertools, sys
certs = json.load(open(sys.argv[1] if len(sys.argv) > 1 else "certs.json"))
for n, edges in sorted(certs.items(), key=lambda kv: int(kv[0])):
    n = int(n); col = {}
    for u, v, c in edges:
        assert u != v and 0 <= u < n and 0 <= v < n and 0 <= c < n
        key = (min(u, v), max(u, v)); assert key not in col, "repeated edge"
        col[key] = c
    adj = [set() for _ in range(n)]
    for u, v in col:
        adj[u].add(v); adj[v].add(u)
    C = lambda u, v: col[(min(u, v), max(u, v))]
    for v in range(n):
        cs = [C(v, w) for w in adj[v]]; assert len(cs) == len(set(cs)), "improper"
    cyc = 0
    for v0 in range(n):
        for v2 in range(v0 + 1, n):
            for v1, v3 in itertools.combinations(sorted(adj[v0] & adj[v2]), 2):
                cyc += 1
                assert len({C(v0, v1), C(v1, v2), C(v2, v3), C(v3, v0)}) == 4, (n, v0, v1, v2, v3)
    print(f"n={n}: {len(col)} edges, {cyc // 2} 4-cycles, all rainbow, colours used {len(set(col.values()))} <= n")
