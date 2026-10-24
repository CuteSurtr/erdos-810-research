import sys, json, time
from model import solve
p = int(sys.argv[1]); T = float(sys.argv[2]); W = int(sys.argv[3]) if len(sys.argv) > 3 else 4
st, obj, bd, beta, D, wt = solve(p, time=T, workers=W, log=True)
print("RESULT", json.dumps(dict(p=p, status=st, obj=obj, bound=bd, beta=beta, D=D, wall=wt)), flush=True)
