"""Decision shard for exact maxima: is there a canonical configuration with m >= target and
beta(2..k+1) = given values?  usage: shard.py p target seconds workers b2 b3 ...
Shards: canonical form forces beta(1)=0 and (first nonzero among beta(2),beta(3),..) = 1, so
level-2 shards are (b2,b3) in {(0,0),(0,1)} U {(1,t): t in F_p}; level 3 appends b4 in F_p."""
import sys, json, time
from ortools.sat.python import cp_model
from model import build
p, target, T, W = int(sys.argv[1]), int(sys.argv[2]), float(sys.argv[3]), int(sys.argv[4])
vals = list(map(int, sys.argv[5:]))
fix = {a + 2: v for a, v in enumerate(vals)}
m, B, z, Wv = build(p, sym=True, symL=True, cuts=False, gcut=False, fix=fix, target=target)
s = cp_model.CpSolver(); s.parameters.num_workers = W; s.parameters.max_time_in_seconds = T
t = time.time(); st = s.Solve(m)
print("SHARD", json.dumps(dict(p=p, target=target, fix=vals, status=s.StatusName(st), wall=round(time.time() - t, 1))), flush=True)
