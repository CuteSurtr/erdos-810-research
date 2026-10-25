#!/usr/bin/env python3
"""cover.py logs/proofs.jsonl PREFIX: coverage check for a presence-bit cube split.
Cubes are read from tags PREFIX<cube> (cube literals joined by '_', 'm' = negated).
Counts the assignments of all split variables that extend no cube with a drat-trim
"s VERIFIED" proof, and no cube at all.  Exit 0 iff the verified cubes cover everything."""
import sys, json, itertools
fn, pre = sys.argv[1], sys.argv[2]
cubes = {}
for l in open(fn):
    r = json.loads(l)
    if not r["tag"].startswith(pre): continue
    c = frozenset(-int(t[1:]) if t[0] == "m" else int(t) for t in r["tag"][len(pre):].split("_"))
    ok = r["result"] == "UNSATISFIABLE" and r["verdict"].strip() == "s VERIFIED"
    cubes[c] = cubes.get(c, False) or ok
V = sorted({abs(t) for c in cubes for t in c})
unc_ver = unc_any = 0
for bits in itertools.product([1, -1], repeat=len(V)):
    a = {s * v for s, v in zip(bits, V)}
    if not any(c <= a for c, ok in cubes.items() if ok): unc_ver += 1
    if not any(c <= a for c in cubes): unc_any += 1
print(f"split variables {V}; cubes {len(cubes)} ({sum(cubes.values())} with verified proof); "
      f"assignments not covered: by any cube {unc_any}, by verified cubes {unc_ver} (of {2 ** len(V)})")
sys.exit(0 if unc_ver == 0 else 1)
