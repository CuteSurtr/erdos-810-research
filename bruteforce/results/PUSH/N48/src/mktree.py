#!/usr/bin/env python3
"""mktree.py wave1.jsonl leaves2.jsonl: build tree.json for n = 48, k = 12.
Top level (wave 1, presence bits): {-1} and {1, ±2, ±3, ±4}: 9 cubes that partition all assignments.
Open wave-1 cubes are split by tree.py's rule (value split on g(d) of the smallest present orbit
d > 1 with unfixed offset, else presence split).  A mirror child d:a that was never run is reported
as covered by the u = -1 symmetry of its representative d:(d-1-a)."""
import json, sys, os, collections
R = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.argv += [] ; w1, w2 = sys.argv[1], sys.argv[2]
n, H = 48, 23
res = {}
for path in (w1, w2):
    for l in open(path):
        o = json.loads(l)
        if "note" in o: continue
        c = tuple(str(t) for t in o["cube"])
        if c not in res or res[c]["res"] == "UNKNOWN": res[c] = o
open_w1 = {("1","2","-3","-4"), ("1","2","-3","4"), ("1","2","3","-4"), ("1","2","3","4"), ("1","-2","3","4")}
def children(c):
    pres = [int(t) for t in c if ":" not in t and int(t) > 1]
    valfixed = {int(t.split(":")[0]) for t in c if ":" in t}
    free = [d for d in sorted(pres) if d not in valfixed]
    if free:
        d = free[0]; return "g(%d)" % d, [list(c) + [f"{d}:{g}"] for g in range(n)], (d if "1" in c and not valfixed else None)
    fixed = {abs(int(t)) for t in c if ":" not in t}
    e = next(e for e in range(1, H + 1) if e not in fixed)
    return "p(%d)" % e, [list(c) + [str(e)], list(c) + [str(-e)]], None
leaves = []
def node(c, depth=0):
    c = list(c); t = tuple(c); o = res.get(t)
    nd = {"cube": c}
    if t in open_w1: o = {"res": "UNKNOWN", "secs": res[t]["secs"] if t in res else None}
    if o is None:
        nd["result"] = "PENDING"; leaves.append(nd); return nd
    nd["result"] = o["res"]; nd["secs"] = o.get("secs")
    if o["res"] == "UNSAT":
        nd.update({"cnf_sha256": o["cnf_sha256"], "solver": o["solver"], "proof": "binary LRAT streamed to cake_lpr",
                   "proof_bytes": o.get("proof_bytes"), "checker_verdict": o.get("check")})
    if o["res"] == "SAT": nd.update({"Dg": o["Dg"], "check": o["check"]})
    if o["res"] != "UNKNOWN": leaves.append(nd); return nd
    if t in open_w1 or t[-1] != "5" or True:
        how, ch, md = children(t)
        if t == ("1","2","3","4") and ("1","2","3","4","5") in res:
            nd["note"] = "an earlier p(5) split attempt: child (1,2,3,4,5) UNKNOWN at 600 s; superseded by the g(2) split"
        nd["split_on"] = how; kids = []
        for x in ch:
            k_ = node(x)
            if md is not None and k_["result"] == "PENDING":
                a = int(x[-1].split(":")[1]); m = (md - 1 - a) % n
                rep = tuple(list(t) + [f"{md}:{m}"])
                if rep in res and res[rep]["res"] == "UNSAT":
                    k_["result"] = "COVERED"; k_["covered_by"] = "u=-1 mirror of " + ",".join(rep)
            kids.append(k_)
        nd["children"] = kids
    return nd
roots = [["-1"]] + [["1", a, b, c] for a in ("2", "-2") for b in ("3", "-3") for c in ("4", "-4")]
tree = [node(r) for r in roots]
cnt = collections.Counter(x["result"] + ("" if x["result"] != "UNSAT" else (" checked" if x.get("checker_verdict") == "s VERIFIED UNSAT" else " UNCHECKED")) for x in leaves)
summary = {"n": 48, "k": 12, "encoding": "CYC/C1 cycenc sym=3 (translation fix + lex-leader over Z_48^x/±1)",
           "base_cnf_sha256": "8b9bc39b6244b093ed6850b45ccca8ea809ff015eb61141b14e583960fff6cbf",
           "leaf_counts": dict(cnt), "n_leaves": len(leaves)}
json.dump({"summary": summary, "tree": tree}, open(f"{R}/tree.json", "w"), indent=1)
print(json.dumps(summary))
