#!/usr/bin/env python3
"""report_stats.py [tree.json]: per-root statistics from tree.json (for REPORT.md)."""
import json, os, sys
R = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
t = json.load(open(sys.argv[1] if len(sys.argv) > 1 else f"{R}/tree.json"))
def walk(nd, acc):
    if "covered_by" in nd: acc["COVERED"] = acc.get("COVERED", 0) + 1; return
    if "children" in nd:
        acc["internal"] += 1
        for x in nd["children"]: walk(x, acc)
        return
    r = nd["result"]; acc[r] = acc.get(r, 0) + 1
    if r == "UNSAT":
        acc["secs"] += nd["secs"] or 0; acc["bytes"] += nd.get("proof_bytes") or 0
        acc["verified"] += nd.get("checker_verdict") == "s VERIFIED UNSAT"
        acc["max"] = max(acc["max"], nd["secs"] or 0)
print("| root cube | split | checked UNSAT leaves | covered by u=-1 mirror | pending | solver time (s) | max leaf (s) | LRAT streamed (GB) |")
print("|---|---|---|---|---|---|---|---|")
tot = {"UNSAT": 0, "COVERED": 0, "PENDING": 0, "secs": 0, "bytes": 0}
for r in t["tree"]:
    acc = {"internal": 0, "secs": 0.0, "bytes": 0, "verified": 0, "max": 0}
    walk(r, acc)
    sp = r.get("split_on", "-")
    if "children" in r and any("split_on" in c for c in r["children"]): sp += " then " + next(c["split_on"] for c in r["children"] if "split_on" in c)
    print(f"| ({', '.join(r['cube'])}) | {sp} | {acc['verified']} | {acc.get('COVERED', 0)} | {acc.get('PENDING', 0)} | {acc['secs']:.0f} | {acc['max']:.0f} | {acc['bytes']/1e9:.2f} |")
    for k in ("COVERED", "PENDING", "secs", "bytes"): tot[k] += acc.get(k, 0)
    tot["UNSAT"] += acc["verified"]
print(f"| **total** | | {tot['UNSAT']} | {tot['COVERED']} | {tot['PENDING']} | {tot['secs']:.0f} | | {tot['bytes']/1e9:.2f} |")
