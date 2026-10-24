"""Fits of best m/p^2 against p (p >= 11, heuristic lower bounds for p >= 11)."""
import json, math
import numpy as np
cfg = json.load(open("configs.json"))
P = np.array([int(p) for p in cfg if int(p) >= 11], float); P.sort()
R = np.array([cfg[str(int(p))]["m"] / p ** 2 for p in P])
out = {}
# power law r = c p^-alpha
A = np.vstack([np.ones_like(P), np.log(P)]).T
c, s = np.linalg.lstsq(A, np.log(R), rcond=None)[0]
out["power"] = dict(c=math.exp(c), alpha=-s, rms=float(np.sqrt(np.mean((np.exp(A @ [c, s]) - R) ** 2))))
for name, f in [("a+b/sqrt(p)", lambda p: p ** -0.5), ("a+b/log(p)", lambda p: 1 / np.log(p)), ("a+b/p", lambda p: 1 / p)]:
    A2 = np.vstack([np.ones_like(P), f(P)]).T
    a, b = np.linalg.lstsq(A2, R, rcond=None)[0]
    out[name] = dict(a=a, b=b, rms=float(np.sqrt(np.mean((A2 @ [a, b] - R) ** 2))))
for k, v in out.items():
    print(k, {kk: round(float(vv), 4) for kk, vv in v.items()})
json.dump({k: {kk: float(vv) for kk, vv in v.items()} for k, v in out.items()}, open("fit.json", "w"), indent=1)
