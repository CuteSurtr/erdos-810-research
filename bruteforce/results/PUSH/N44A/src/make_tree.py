#!/usr/bin/env python3
"""make_tree.py: build tree.json for n=44, k=11 (sym=3) from logs/leaves.jsonl.
Cover: root -> {¬1} ∪ {1}×{±2}×{±3}×{±4}; cube (1,2,3,4) -> ±5; p5=0 belongs to N44B;
(1,2,3,4,5) -> ±6×±7×±8; any leaf that timed out -> ±(next bit), recursively."""
import json, os
R = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
res = {}
for l in open(f"{R}/logs/leaves.jsonl"):
    d = json.loads(l); key = tuple(d["cube"])
    if key not in res or res[key]["res"] == "UNKNOWN": res[key] = d
drat = {}
for l in open(f"{R}/logs/drat.jsonl"):
    d = json.loads(l)
    if d["verdict"] == "s VERIFIED": drat[tuple(d["cube"])] = d
def xc(n):
    d = drat.get(tuple(n["assumptions"]))
    if d: n["cross_check"] = {"solver": d["solver"], "checker": "drat-trim", "verdict": d["verdict"], "proof_bytes": d["proof_bytes"], "cnf_sha256": d["cnf_sha256"]}
    return n
def node(cube, children=None, note=None):
    n = {"assumptions": list(cube)}
    if note: n["note"] = note
    r = res.get(tuple(cube))
    if r and r["res"] != "UNKNOWN":
        n.update({"result": "UNSAT" if r["res"] == "UNSATISFIABLE" else r["res"],
                  "proof": "LRAT checked by cake_lpr" if r["verdict"] == "s VERIFIED UNSAT" else f"UNCHECKED ({r['verdict']})",
                  "solver": r["solver"], "solve_s": r["solve_s"], "cnf_sha256": r["cnf_sha256"],
                  "proof_bytes": r["proof_bytes"], "checker_verdict": r["verdict"]})
        return xc(n)
    if children is None and r:   # timed out: look for split children
        nxt = max(abs(x) for x in cube) + 1
        if tuple(cube + [nxt]) in res or tuple(cube + [-nxt]) in res:
            children = [node(cube + [nxt]), node(cube + [-nxt])]
            n["timed_out_s"] = r["solve_s"]
        else:
            n.update({"result": "UNKNOWN", "timed_out_s": r["solve_s"]}); return n
    if children is None:
        n["result"] = "NOT RUN"; return n
    n["split_on"] = f"p{max(abs(x) for x in children[0]['assumptions'])}"
    n["children"] = children
    sts = [c.get("result", "INTERNAL") for c in children]
    return n
def subtree5():
    return node([1, 2, 3, 4, 5], [node([1, 2, 3, 4, 5, a, b, c]) for a in (6, -6) for b in (7, -7) for c in (8, -8)])
c1234 = node([1, 2, 3, 4], [subtree5(), {"assumptions": [1, 2, 3, 4, -5], "result": "DELEGATED to PUSH/N44B", "note": "N44B logs all 8 sub-cubes ±6±7±8 UNSAT with cake_lpr; independently re-solved here (kissat + drat-trim)", "cross_checked_children": [xc({"assumptions": [1, 2, 3, 4, -5, a, b, c], "result": "UNSAT (N44B; cross-check here)"}) for a in (6, -6) for b in (7, -7) for c in (8, -8)]}])
root = node([], [node([-1])] + [node([1, a, b, c]) for a in (2, -2) for b in (3, -3) for c in (4, -4) if (a, b, c) != (2, 3, 4)] + [c1234])
def leaves(n):
    if "children" in n:
        for c in n["children"]: yield from leaves(c)
    else: yield n
L = list(leaves(root)); from collections import Counter
summ = Counter((x.get("result"), x.get("proof", "-")) for x in L)
out = {"instance": "n=44 k=11 cyclic family, C1 cycenc sym=3 (translation fix + lex-leader over units)",
       "base_cnf_sha256": "7895911c5d80939f6480db2480634797f636607fd9624954213a90a46bb8324e",
       "presence_var": "p(d) = 21*44 + d; a cube literal +d / -d is the unit clause p(d) / ¬p(d) appended to the base CNF",
       "cover": "each internal node splits on one presence bit p_j into {p_j} and {¬p_j}; the root split is {¬p1} ∪ {p1}×{±p2}×{±p3}×{±p4}",
       "leaf_summary": {f"{a} / {b}": v for (a, b), v in summ.items()}, "tree": root}
json.dump(out, open(f"{R}/tree.json", "w"), indent=1)
print(json.dumps(out["leaf_summary"]))
