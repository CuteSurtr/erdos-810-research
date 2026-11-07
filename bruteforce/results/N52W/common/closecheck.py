#!/usr/bin/env python3
"""closecheck.py n k base.cnf --roots R1 R2 ... --logs L1 L2 ...

Independent closure check for cube trees built by PUSH/N48's tree.py (cube tokens: +d, -d, d:g).
A cube is CLOSED if
  (1) some log line for exactly this cube is UNSAT with checker verdict "s VERIFIED UNSAT" and its cnf_sha256
      equals the sha256 recomputed here (base CNF with the clause count raised, plus one unit clause per cube
      literal, in cube order), or
  (2) all children of the cube are CLOSED, where the children are fixed by tree.py's own rule, not by the logs:
      (a) if some present orbit d > 1 has no fixed offset, the smallest such d gives the n children cube + [d:g],
          g = 0..n-1 (a cover because the base CNF contains -p(d) | x(d,0) | ... | x(d,n-1), checked below);
      (b) otherwise the smallest orbit e not mentioned gives cube + [e] and cube + [-e].
No symmetry is used: a branch that was never run is OPEN.  Prints one line per root and exits 0 iff every root is
CLOSED.  A SAT line anywhere in the logs is reported and makes the exit code 2."""
import sys, json, hashlib
from functools import lru_cache
a = sys.argv[1:]
n, k, basef = int(a[0]), int(a[1]), a[2]
roots = a[a.index("--roots") + 1:a.index("--logs")]; logs = a[a.index("--logs") + 1:]
H = (n + 1) // 2 - 1
P = lambda d: H * n + d; X = lambda d, g: 1 + (d - 1) * n + g
base = open(basef).read()
assert f"c map {n} {H}" in base, "base CNF is not for this n"
hdr = next(l for l in base.split("\n") if l.startswith("p cnf")); nv, nc = int(hdr.split()[2]), int(hdr.split()[3])
cls = set(base.split("\n"))
for d in range(1, H + 1):
    assert " ".join([str(-P(d))] + [str(X(d, g)) for g in range(n)] + ["0"]) in cls, ("offset clause missing", d)
@lru_cache(None)
def prefix(L):
    return hashlib.sha256(base.replace(hdr, f"p cnf {nv} {nc + L}", 1).encode())
def lit(t):
    if ":" in t:
        d, g = t.split(":"); return X(int(d), int(g))
    return P(int(t)) if int(t) > 0 else -P(-int(t))
def sha(c):
    h = prefix(len(c)).copy(); h.update("".join(f"{lit(t)} 0\n" for t in c).encode()); return h.hexdigest()
ok, sat, unver, seen = {}, [], 0, set()
for f in logs:
    for l in open(f):
        o = json.loads(l); c = tuple(str(t) for t in o["cube"])
        for i in range(len(c) + 1): seen.add(c[:i])
        if o.get("res") == "SAT": sat.append(c)
        if o.get("res") == "UNSAT":
            if o.get("check") == "s VERIFIED UNSAT": ok.setdefault(c, set()).add(o["cnf_sha256"])
            else: unver += 1
stat = {"leaves": 0, "internal": 0, "open": 0}
def children(c):
    pres = [int(t) for t in c if ":" not in t and int(t) > 1]
    fixed = {int(t.split(":")[0]) for t in c if ":" in t}
    free = [d for d in sorted(pres) if d not in fixed]
    if free: return [c + (f"{free[0]}:{g}",) for g in range(n)]
    ment = {abs(int(t)) for t in c if ":" not in t}
    e = next((e for e in range(1, H + 1) if e not in ment), None)
    return None if e is None else [c + (str(e),), c + (str(-e),)]
def closed(c):
    if c in ok and sha(c) in ok[c]:
        stat["leaves"] += 1; return True
    ch = children(c)
    if ch is None or c not in seen:      # nothing was run at or below c: an open branch, not expanded further
        stat["open"] += 1; return False
    stat["internal"] += 1
    return all([closed(x) for x in ch])  # list, not generator: count every open branch
allc = True
for r in roots:
    c = tuple(t for t in r.split(",") if t)
    res = closed(c); allc &= res
    print(("CLOSED " if res else "OPEN   ") + ",".join(c))
print(f"n={n} k={k}: verified leaves used {stat['leaves']}, internal {stat['internal']}, open branches {stat['open']}, "
      f"unverified UNSAT lines {unver}, SAT lines {len(sat)}")
if sat: print("SAT cubes:", [",".join(s) for s in sat[:10]]); sys.exit(2)
sys.exit(0 if allc else 1)
