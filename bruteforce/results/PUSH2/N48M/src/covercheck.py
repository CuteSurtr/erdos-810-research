#!/usr/bin/env python3
"""covercheck.py tree.json base.cnf: independent check that the leaves of tree.json cover the whole
n = 48, k = 12 instance.
 - roots must be exactly {-1} and {1, ±2, ±3, ±4} (a partition of all assignments by p1..p4);
 - an internal node split on p(e) must have exactly the children cube+[e], cube+[-e];
 - an internal node split on g(d) must have orbit d present (+d in the cube) and exactly the n
   children cube+[d:0..n-1] (the base CNF contains the clause -p(d) | x(d,0) | ... | x(d,n-1); this is
   checked below);
 - every leaf is UNSAT with checker verdict "s VERIFIED UNSAT" and a CNF sha256 equal to the hash of
   (base CNF with the clause count raised) + one unit clause per cube literal, recomputed here, or is
   COVERED: a child d:a of a g(d) split of a cube with orbit 1 present and no offset fixed, whose
   sibling d:(d-1-a) is closed (u = -1 symmetry, REPORT section 4)."""
import sys, json, hashlib
n, H = 48, 23
t = json.load(open(sys.argv[1]))["tree"]; base = open(sys.argv[2]).read()
hdr = next(l for l in base.split("\n") if l.startswith("p cnf")); nv, nc = int(hdr.split()[2]), int(hdr.split()[3])
cls = set(base.split("\n"))
P = lambda d: H * n + d; X = lambda d, g: 1 + (d - 1) * n + g
for d in range(1, H + 1):
    assert " ".join([str(-P(d))] + [str(X(d, g)) for g in range(n)] + ["0"]) in cls, d
def lit(tk):
    if ":" in tk:
        d, g = tk.split(":"); s = -1 if d.startswith("-") else 1; return s * X(abs(int(d)), int(g))
    return P(int(tk)) if int(tk) > 0 else -P(-int(tk))
def sha(c):
    s = base.replace(hdr, f"p cnf {nv} {nc + len(c)}", 1) + "".join(f"{lit(x)} 0\n" for x in c)
    return hashlib.sha256(s.encode()).hexdigest()
roots = [["-1"]] + [["1", a, b, c] for a in ("2", "-2") for b in ("3", "-3") for c in ("4", "-4")]
assert [r["cube"] for r in t] == roots, "roots"
stat = {"unsat": 0, "covered": 0, "internal": 0}
def closed(nd):
    if "children" in nd: return all(closed(x) for x in nd["children"])
    return nd["result"] == "UNSAT" and nd.get("checker_verdict") == "s VERIFIED UNSAT"
def walk(nd):
    c = nd["cube"]
    if "children" in nd:
        stat["internal"] += 1; how = nd["split_on"]; ch = [x["cube"] for x in nd["children"]]
        e = int(how[2:-1])
        if how.startswith("p("):
            assert e not in {abs(int(x)) for x in c if ":" not in x} and ch == [c + [str(e)], c + [str(-e)]], c
        else:
            assert str(e) in c and ch == [c + [f"{e}:{g}"] for g in range(n)], c
            for g, x in enumerate(nd["children"]):
                if "covered_by" in x:
                    assert "1" in c and not any(":" in y for y in c), c
                    assert closed(nd["children"][(e - 1 - g) % n]), x["cube"]
        for x in nd["children"]:
            if "covered_by" in x: stat["covered"] += 1
            else: walk(x)
        return
    assert nd["result"] == "UNSAT" and nd["checker_verdict"] == "s VERIFIED UNSAT", c
    assert nd["cnf_sha256"] == sha(c), ("sha", c)
    stat["unsat"] += 1
for r in t: walk(r)
print("COVER OK", stat)
