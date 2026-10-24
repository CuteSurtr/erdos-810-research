import sys
from model import solve
# experiment: joint CP-SAT with W workers, gcut/cuts flags (p=7 timings in REPORT.md)
p=int(sys.argv[1]); W=int(sys.argv[2]); g=sys.argv[3]=="1"; c=sys.argv[4]=="1"
r = solve(p, time=float(sys.argv[5]), workers=W, log=True, gcut=g, cuts=c)
print("RES", p, W, g, c, r[0], r[1], r[2], round(r[5],1), flush=True)
