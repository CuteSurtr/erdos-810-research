#!/usr/bin/env python3
"""mktree.py : build tree.json from logs/leaves.jsonl (+ logs/drat.jsonl) and check that the leaves
cover the N44B region {p1, p2, p3, p4 present, p5 absent} exactly once (all 2^3 sign patterns on p6..p8)."""
import json, os, itertools
R = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
leaves = [json.loads(l) for l in open(f"{R}/logs/leaves.jsonl")]
drat = {}
if os.path.exists(f"{R}/logs/drat.jsonl"):
    for l in open(f"{R}/logs/drat.jsonl"): d = json.loads(l); drat[tuple(d["cube"])] = d
prefix = [1, 2, 3, 4, -5]
want = {tuple(prefix + [s6 * 6, s7 * 7, s8 * 8]) for s6, s7, s8 in itertools.product((1, -1), repeat=3)}
got = [tuple(l["cube"]) for l in leaves]
assert len(got) == len(set(got)) == 8 and set(got) == want, "cover check failed"
def leaf(l):
    d = drat.get(tuple(l["cube"]), {})
    return {"assumptions": l["cube"], "result": l["res"], "cnf_sha256": l["cnf_sha256"], "solver": l["solver"],
            "solve_secs": l["solve_secs"], "proof": "LRAT (text), streamed to checker, not stored",
            "proof_bytes": l.get("proof_bytes"), "checker": l.get("checker"), "checker_verdict": l.get("checker_verdict"),
            "proof_status": l.get("proof"),
            "second_check": ({"solver": d["solver"], "cnf_sha256_match": d["cnf_sha256"] == l["cnf_sha256"],
                              "proof_bytes": d["proof_bytes"], "checker": d["checker"],
                              "checker_verdict": d["checker_verdict"], "check_secs": d["check_secs"]} if d else None)}
tree = {"instance": "n = 44, k = 11, C1 encoder cycenc 44 11 3 (translation fix + lex-leader over Z_44^x / +-1)",
        "base_cnf_sha256": "7895911c5d80939f6480db2480634797f636607fd9624954213a90a46bb8324e",
        "literal_convention": "+d: orbit d present (unit clause p(d) = 21*44 + d), -d: absent",
        "cover": "C1: {-1} u {1} x {+-2} x {+-3} x {+-4} (9 cubes). Open cube {1,2,3,4} split on p5..p8 (16 sub-cubes): "
                 "p5 = 1 -> PUSH/N44A, p5 = 0 -> PUSH/N44B (this tree). Each node's children are the two signs of one "
                 "presence variable, so the leaves partition the parent; checked by src/mktree.py.",
        "root": {"assumptions": prefix, "owner": "PUSH/N44B", "split_on": [6, 7, 8],
                 "children": [leaf(l) for l in sorted(leaves, key=lambda l: [-x for x in l["cube"]])]},
        "sibling": {"assumptions": [1, 2, 3, 4, 5], "owner": "PUSH/N44A", "status": "see results/PUSH/N44A"}}
json.dump(tree, open(f"{R}/tree.json", "w"), indent=1)
print("cover OK:", len(got), "leaves;", sum(l["proof"] == "checked" for l in leaves), "checked by cake_lpr;",
      sum(1 for d in drat.values() if d["checker_verdict"] == "s VERIFIED"), "re-checked by drat-trim")
