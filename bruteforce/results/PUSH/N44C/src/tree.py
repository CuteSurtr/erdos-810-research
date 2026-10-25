#!/usr/bin/env python3
"""Build tree.json for n=44, k=11 from results.jsonl and check that it covers the whole search space.

Root = all (D, g) with |D| = 11 (up to G).  Children: 'nounit' and 'unit' (sound: CYCPAT REPORT §4).
'unit' -> unit2:e, e = 2..21 (e = second smallest orbit; exists since k >= 2).
A prefix node P = [1, e, f, ...] with |P| < k has children P + [x], x = max(P)+1..H (the next orbit exists).
A node is closed if its own case is verified UNSAT (cake_lpr), either as plain 'unit2:e' / 'pre:P' or with
symmetry breaking 'sb:P', or if all of its children are closed.  usage: tree.py [n k]"""
import json, re, sys
n, k = (int(sys.argv[1]), int(sys.argv[2])) if len(sys.argv) > 2 else (44, 11)
# mode 'any': leaves may be plain (unit2:e, pre:P) or symmetry-broken (sb:P); 'plain': plain leaves only
mode = sys.argv[3] if len(sys.argv) > 3 else 'any'
outfile = sys.argv[4] if len(sys.argv) > 4 else 'tree.json'
H = (n + 1) // 2 - 1
res = {}
for l in open('results.jsonl'):
    r = json.loads(re.sub(r":\.", ":0.", l))
    if r['n'] != n or r['k'] != k: continue
    if r['case'] in res and res[r['case']]['check'] == 's VERIFIED UNSAT': continue
    res[r['case']] = r
def ok(c): return (mode == 'any' or not c.startswith('sb:')) and c in res and res[c]['result'] == 'UNSATISFIABLE' and res[c]['check'] == 's VERIFIED UNSAT'
def leafinfo(c):
    r = res[c]; return {"case": c, "result": r['result'], "proof": r['check'], "cnf_sha256": r['cnf_sha256'],
                        "solver": r['solver'], "solve_s": round(r['solve_s'], 1), "proof_bytes": r['proof_bytes'],
                        "check_s": round(float(r['check_s'] or 0), 1)}
open_leaves = []
def node(P):
    name = 'pre:' + '.'.join(map(str, P))
    own = [c for c in ([f'unit2:{P[1]}'] if len(P) == 2 else []) + ['pre:' + name[4:], 'sb:' + name[4:]] if ok(c)]
    if own: return {"prefix": P, "closed": True, "by": leafinfo(own[0])}
    if len(P) >= k:
        open_leaves.append(name); return {"prefix": P, "closed": False}
    tried = [c for c in ([f'unit2:{P[1]}'] if len(P) == 2 else []) + ['pre:' + name[4:], 'sb:' + name[4:]] if c in res]
    kids = [node(P + [x]) for x in range(P[-1] + 1, H + 1)]
    # children beyond what was ever queued are open
    return {"prefix": P, "closed": all(c['closed'] for c in kids), "attempts": [leafinfo(c) for c in tried],
            "children": kids}
def shallow(P):
    """expand only nodes that were actually split (some descendant case exists), else mark open"""
    pref = '.'.join(map(str, P))
    split = any(c.split(':', 1)[1].startswith(pref + '.') for c in res
                if c.startswith(('pre:', 'sb:') if mode == 'any' else ('pre:',)))
    name = pref
    if len(P) + (H - P[-1]) < k:
        return {"prefix": P, "closed": True, "by": "vacuous: fewer than k orbits available (|P| + H - max P < k)"}
    own = [c for c in ([f'unit2:{P[1]}'] if len(P) == 2 else []) + ['pre:' + name, 'sb:' + name] if ok(c)]
    if own and not split: return {"prefix": P, "closed": True, "by": leafinfo(own[0])}
    tried = [leafinfo(c) for c in ([f'unit2:{P[1]}'] if len(P) == 2 else []) + ['pre:' + name, 'sb:' + name] if c in res]
    if not split:
        open_leaves.append(name); return {"prefix": P, "closed": False, "attempts": tried}
    if own:   # closed by its own proof; the deeper runs are extra
        return {"prefix": P, "closed": True, "by": leafinfo(own[0]),
                "extra_children_runs": [leafinfo(c) for c in sorted(res) if c.startswith(('pre:' + name + '.', 'sb:' + name + '.'))]}
    kids = [shallow(P + [x]) for x in range(P[-1] + 1, H + 1)]
    closed = all(c['closed'] for c in kids)
    d = {"prefix": P, "closed": closed, "attempts": tried, "children": kids}
    return d
unit = [shallow([1, e]) for e in range(2, H + 1)]
root = {"n": n, "k": k, "cover": "nounit + unit; unit = union of unit2:e (e=2..H); prefix P = union of P+[x] (x>max P)",
        "nounit": {"closed": ok('nounit'), **({"by": leafinfo('nounit')} if 'nounit' in res else {})},
        "unit": {"closed": all(u['closed'] for u in unit), "children": unit}}
root["closed"] = root["nounit"]["closed"] and root["unit"]["closed"]
if not root["nounit"]["closed"]: open_leaves.append('nounit')
root["mode"] = mode
json.dump(root, open(outfile, 'w'), indent=1)
def leaves(t):
    if 'children' in t and not ('by' in t and not any('children' in c for c in t['children'])):
        for c in t['children']: yield from leaves(c)
    elif 'by' in t: yield t
print(json.dumps({"closed": root["closed"], "open": open_leaves[:30], "n_open": len(open_leaves)}))
