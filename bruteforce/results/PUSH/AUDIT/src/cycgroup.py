"""Audit: orbit counts of cyclic solutions under multipliers x colour translations
(Lemma 3), with every image re-checked as an explicit graph.  Independent code."""
import sys, math, itertools

def explicit_ok(n, Dg):
    """Explicit graph on Z_n, edge {i,i+d} colour i+g(d); check all 4-cycles."""
    col = {}
    for d, g in Dg:
        for i in range(n):
            e = frozenset((i, (i + d) % n))
            if e in col or len(e) < 2:
                return False
            col[e] = (i + g) % n
    adj = [set() for _ in range(n)]
    for e in col:
        a, b = tuple(e)
        adj[a].add(b); adj[b].add(a)
    for a in range(n):
        for c in range(a + 1, n):
            common = sorted(adj[a] & adj[c])
            for b, d in itertools.combinations(common, 2):
                cs = [col[frozenset((a, b))], col[frozenset((b, c))],
                      col[frozenset((c, d))], col[frozenset((d, a))]]
                if len(set(cs)) < 4:
                    return False
    return True

def image(n, Dg, u, t=0, drop_e=False):
    H = (n + 1) // 2 - 1
    out = []
    for d, g in Dg:
        x = (u * d) % n
        if 1 <= x <= H:
            e, gg = x, (u * g) % n
        else:
            e = n - x
            gg = (u * g + (0 if drop_e else e)) % n
        out.append((e, (gg + t) % n))
    return sorted(out)

def normal(n, Dg):
    """normal form: translate so g(min D)=0."""
    Dg = sorted(Dg)
    t = -Dg[0][1]
    return tuple((d, (g + t) % n) for d, g in Dg)

def orbit(n, Dg):
    units = [u for u in range(1, n) if math.gcd(u, n) == 1]
    return {normal(n, image(n, Dg, u)) for u in units}

def main(n, path, check_all_images=True):
    sols = []
    for line in open(path):
        line = line.split()
        if line:
            sols.append(tuple(tuple(map(int, x.split(':'))) for x in line))
    S = set(sols)
    seen = set(); orbits = 0; bad = 0; nimg = 0
    for s in sols:
        if s in seen:
            continue
        orb = orbit(n, s)
        orbits += 1
        for o in orb:
            nimg += 1
            if o not in S:
                bad += 1
            if check_all_images and not explicit_ok(n, o):
                bad += 1
        seen |= orb
    print(f"n={n}: {len(sols)} solutions (g(minD)=0), {orbits} orbits under G, "
          f"{nimg} images checked, {bad} failures, all-solutions-covered={seen==S}")

if __name__ == "__main__":
    main(int(sys.argv[1]), sys.argv[2], len(sys.argv) < 4)
