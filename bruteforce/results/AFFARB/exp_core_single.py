import sys, time
from ortools.sat.python import cp_model
from model import build
p=int(sys.argv[1]); g=sys.argv[2]=="1"; c=sys.argv[3]=="1"; T=float(sys.argv[4])
m,B,z,W = build(p, gcut=g, cuts=c)
s=cp_model.CpSolver(); s.parameters.num_workers=1; s.parameters.optimize_with_core=True; s.parameters.max_time_in_seconds=T
st=s.Solve(m); print("RES",p,g,c,s.StatusName(st),s.ObjectiveValue(),s.BestObjectiveBound(),round(s.WallTime(),1),flush=True)
