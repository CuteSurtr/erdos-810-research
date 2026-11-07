"""Joint CP-SAT optimisation (canonical form) with log; usage: run_exact.py p seconds workers cuts gcut"""
import sys, json
from model import solve
p = int(sys.argv[1]); T = float(sys.argv[2]); W = int(sys.argv[3])
cuts = sys.argv[4] == "1" if len(sys.argv) > 4 else True
gcut = sys.argv[5] == "1" if len(sys.argv) > 5 else True
st, obj, bd, beta, D, wt = solve(p, time=T, workers=W, log=True, cuts=cuts, gcut=gcut)
print("RESULT", json.dumps(dict(p=p, status=st, obj=obj, bound=bd, beta=beta, D=D, wall=wt, cuts=cuts, gcut=gcut)), flush=True)
