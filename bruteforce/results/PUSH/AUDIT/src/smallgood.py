"""Audit: k-goodness of small graphs by explicit 4-cycle enumeration + backtracking.
Counts good isomorphism classes on n vertices (labelled enumeration + canonical form)."""
import itertools, sys

def conflicts(n, E):
    Es = set(E); idx = {e: i for i, e in enumerate(E)}
    def ed(a, b): return (a, b) if a < b else (b, a)
    conf = [set() for _ in E]
    for quad in itertools.combinations(range(n), 4):
        a, b, c, d = quad
        for cyc in ((a, b, c, d), (a, b, d, c), (a, c, b, d)):
            es = [ed(cyc[i], cyc[(i + 1) % 4]) for i in range(4)]
            if all(e in Es for e in es):
                ids = [idx[e] for e in es]
                for x in ids:
                    for y in ids:
                        if x != y: conf[x].add(y)
    return conf

def colourable(conf, k):
    m = len(conf); col = [-1] * m
    order = sorted(range(m), key=lambda i: -len(conf[i]))
    def rec(pos, used):
        if pos == m: return True
        # most constrained uncoloured
        best = None; bs = -1
        for i in range(m):
            if col[i] < 0:
                s = len({col[j] for j in conf[i] if col[j] >= 0})
                if s > bs: bs, best = s, i
        i = best
        forb = {col[j] for j in conf[i] if col[j] >= 0}
        for c in range(min(used + 1, k)):
            if c not in forb:
                col[i] = c
                if rec(pos + 1, max(used, c + 1)): return True
                col[i] = -1
        return False
    return rec(0, 0)

def canon(n, E):
    best = None
    for p in itertools.permutations(range(n)):
        f = tuple(sorted(tuple(sorted((p[a], p[b]))) for a, b in E))
        if best is None or f < best: best = f
    return best

def run(n, e_values, k):
    pairs = list(itertools.combinations(range(n), 2))
    for e in e_values:
        good = set(); nlab = 0
        for E in itertools.combinations(pairs, e):
            if colourable(conflicts(n, E), k):
                nlab += 1
                good.add(canon(n, E) if n <= 6 else E)
        if n > 6:
            seen = set(); classes = 0
            for E in good:
                if E in seen: continue
                classes += 1
                for p in itertools.permutations(range(n)):
                    seen.add(tuple(sorted(tuple(sorted((p[a], p[b]))) for a, b in E)))
            good = range(classes)
        print(f"n={n} e={e} k={k}: good labelled {nlab}, good classes {len(good)}", flush=True)
        yield len(good)

if __name__ == "__main__":
    n = int(sys.argv[1]); es = list(map(int, sys.argv[2].split(',')))
    tot = sum(run(n, es, n))
    print("total good classes over e in", es, "=", tot)
