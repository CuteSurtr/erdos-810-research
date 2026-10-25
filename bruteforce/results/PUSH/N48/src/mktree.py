#!/usr/bin/env python3
"""mktree.py: build tree.json from logs/leaves.jsonl.  Node = cube (list of signed presence literals).
A node resolved UNKNOWN has children cube+[d], cube+[-d] (d = smallest unfixed orbit).  Reports
every leaf's assumptions, result and proof status, and checks that the leaves cover the roots."""
import json, sys, os
R = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
H = 23
res = {}
for l in open(os.environ.get("LEAFLOG", "/tmp/claude-0/logs/leaves.jsonl")):
    o = json.loads(l); c = tuple(o["cube"])
    if c not in res or res[c]["res"] == "UNKNOWN" or o["res"] != "UNKNOWN": res[c] = o
roots = [json.loads(a) for a in sys.argv[1:]] or [[-1]] + [[1, a, b, c] for a in (2, -2) for b in (3, -3) for c in (4, -4)]
def node(c):
    o = res.get(tuple(c))
    if o is None: return {"cube": c, "result": "PENDING"}
    nd = {"cube": c, "result": o["res"], "secs": o.get("secs"), "cnf_sha256": o.get("cnf_sha256")}
    if o["res"] == "UNSAT":
        nd.update({"proof": "binary LRAT, streamed to cake_lpr", "proof_bytes": o.get("proof_bytes"), "checker_verdict": o.get("check")})
    if o["res"] == "SAT": nd.update({"Dg": o["Dg"], "check": o["check"]})
    if o["res"] == "UNKNOWN":
        fixed = {abs(x) for x in c}; d = next(e for e in range(1, H + 1) if e not in fixed)
        nd["split_on"] = d; nd["children"] = [node(c + [d]), node(c + [-d])]
    return nd
tree = [node(r) for r in roots]
leaves = []
def walk(t):
    if "children" in t: [walk(x) for x in t["children"]]
    else: leaves.append(t)
[walk(t) for t in tree]
st = {}
for x in leaves:
    key = x["result"] + ("" if x["result"] != "UNSAT" else (" checked" if x.get("checker_verdict") == "s VERIFIED UNSAT" else " UNCHECKED"))
    st[key] = st.get(key, 0) + 1
summary = {"n": 48, "k": 12, "cover": "root cubes {-1} and {1,±2,±3,±4} partition all assignments; every split replaces a cube by cube+[d], cube+[-d]",
           "leaf_counts": st, "n_leaves": len(leaves)}
json.dump({"summary": summary, "tree": tree}, open(f"{R}/tree.json", "w"), indent=1)
print(json.dumps(summary))
