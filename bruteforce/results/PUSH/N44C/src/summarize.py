#!/usr/bin/env python3
"""Walk tree.json (written by tree.py) and list the leaves that close it: leaves.tsv + totals.
usage: summarize.py [tree.json] [leaves.tsv]"""
import json, sys
t = json.load(open(sys.argv[1] if len(sys.argv) > 1 else 'tree.json'))
out = sys.argv[2] if len(sys.argv) > 2 else 'leaves.tsv'
rows = []; vac = 0
def walk(x, label):
    global vac
    b = x.get('by')
    if isinstance(b, str): vac += 1; return
    if b: rows.append((label, b)); return
    for c in x.get('children', []): walk(c, '.'.join(map(str, c['prefix'])))
if isinstance(t['nounit'].get('by'), dict): rows.append(('nounit', t['nounit']['by']))
for c in t['unit']['children']: walk(c, '.'.join(map(str, c['prefix'])))
with open(out, 'w') as f:
    f.write('node\tcase\tresult\tproof_check\tcnf_sha256\tsolve_s\tlrat_bytes\tcheck_s\n')
    for lab, b in rows:
        f.write(f"{lab}\t{b['case']}\t{b['result']}\t{b['proof']}\t{b['cnf_sha256']}\t{b['solve_s']}\t{b['proof_bytes']}\t{b['check_s']}\n")
v = sum(1 for _, b in rows if b['proof'] == 's VERIFIED UNSAT')
print(json.dumps({"closed": t['closed'], "closing_leaves": len(rows), "verified": v, "vacuous_nodes": vac,
                  "solve_s": round(sum(b['solve_s'] for _, b in rows)), "check_s": round(sum(b['check_s'] for _, b in rows)),
                  "max_lrat_GB": round(max(b['proof_bytes'] for _, b in rows) / 1e9, 2),
                  "total_lrat_GB": round(sum(b['proof_bytes'] for _, b in rows) / 1e9, 1),
                  "max_solve": max((b['solve_s'], b['case']) for _, b in rows)}))
