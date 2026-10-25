#!/usr/bin/env python3
"""mktree.py n k base.cnf out.json log1.jsonl [log2.jsonl ...]: build tree.json for (n, k) from leaf logs.
Generalisation of PUSH/N48's mktree.py (n = 48, k = 12 hard-coded there); H = ceil(n/2) - 1.
Top level (presence bits): {-1} and {1, ±2, ±3, ±4}: 9 cubes that partition all assignments.
A cube whose best logged result is UNKNOWN (or PRESPLIT) is split by tree.py's rule (value split on g(d)
of the smallest present orbit d > 1 with unfixed offset, else presence split on the smallest orbit not
mentioned).  A mirror child d:a that is not closed is reported as COVERED by the u = -1 symmetry when its
representative d:(d-1-a) is closed.  Later log lines never override an earlier final (non-UNKNOWN) result."""
import json, sys, collections, hashlib
n, k = int(sys.argv[1]), int(sys.argv[2]); base, outp = sys.argv[3], sys.argv[4]
H = (n + 1) // 2 - 1
res = {}
for path in sys.argv[5:]:
    for l in open(path):
        o = json.loads(l)
        if "note" in o and "secs" not in o: o = {"cube": o["cube"], "res": "UNKNOWN"}
        if o["res"] == "PRESPLIT": o["res"] = "UNKNOWN"; o["presplit"] = True
        if o["res"] == "ERROR": continue
        c = tuple(str(t) for t in o["cube"])
        if c not in res or res[c]["res"] == "UNKNOWN": res[c] = o
def children(c):
    pres = [int(t) for t in c if ":" not in t and int(t) > 1]
    valfixed = {int(t.split(":")[0]) for t in c if ":" in t}
    free = [d for d in sorted(pres) if d not in valfixed]
    if free:
        d = free[0]; return "g(%d)" % d, [list(c) + [f"{d}:{g}"] for g in range(n)], (d if "1" in c and not valfixed else None)
    fixed = {abs(int(t)) for t in c if ":" not in t}
    e = next(e for e in range(1, H + 1) if e not in fixed)
    return "p(%d)" % e, [list(c) + [str(e)], list(c) + [str(-e)]], None
def closed(nd):
    if "children" in nd: return all(closed(x) for x in nd["children"])
    return nd["result"] == "UNSAT" and nd.get("checker_verdict") == "s VERIFIED UNSAT"
def node(c):
    c = list(c); t = tuple(c); o = res.get(t)
    nd = {"cube": c}
    if o is None:
        nd["result"] = "PENDING"; return nd
    nd["result"] = o["res"]; nd["secs"] = o.get("secs")
    if o.get("presplit"): nd["result"] = "PRESPLIT (not run)"
    if o["res"] == "UNSAT":
        nd.update({"cnf_sha256": o["cnf_sha256"], "solver": o["solver"], "proof": "binary LRAT streamed to cake_lpr",
                   "proof_bytes": o.get("proof_bytes"), "checker_verdict": o.get("check")})
    if o["res"] == "SAT": nd.update({"Dg": o["Dg"], "check": o["check"]})
    if o["res"] != "UNKNOWN": return nd
    how, ch, md = children(t)
    nd["split_on"] = how
    kids = [node(x) for x in ch]
    if md is not None:
        for g, k_ in enumerate(kids):
            m = (md - 1 - g) % n
            if not closed(k_) and closed(kids[m]):
                k_["covered_by"] = "u=-1 mirror of " + ",".join(kids[m]["cube"])
                k_["result"] = "COVERED" if k_["result"] == "PENDING" else "COVERED (direct run in progress)"
    nd["children"] = kids
    return nd
roots = [["-1"]] + [["1", a, b, c] for a in ("2", "-2") for b in ("3", "-3") for c in ("4", "-4")]
tree = [node(r) for r in roots]
def collect(nd, out):
    if "covered_by" in nd: out.append({"result": "COVERED"}); return
    if "children" in nd: [collect(x, out) for x in nd["children"]]
    else: out.append(nd)
leaves = []; [collect(r, leaves) for r in tree]
cnt = collections.Counter(x["result"] + ("" if x["result"] != "UNSAT" else (" checked" if x.get("checker_verdict") == "s VERIFIED UNSAT" else " UNCHECKED")) for x in leaves)
summary = {"n": n, "k": k, "encoding": f"CYC/C1 cycenc sym=3 (translation fix + lex-leader over Z_{n}^x/±1)",
           "base_cnf_sha256": hashlib.sha256(open(base, "rb").read()).hexdigest(),
           "leaf_counts": dict(cnt), "n_leaves": len(leaves)}
json.dump({"summary": summary, "tree": tree}, open(outp, "w"), indent=1)
print(json.dumps(summary))
