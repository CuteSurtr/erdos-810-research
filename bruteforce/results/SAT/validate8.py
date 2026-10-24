import time
from pysat.solvers import Solver
from enc import build, decode
from check import check
n,M=8,17
res={}
for e in (M,M+1):
    cnf,pool,x,y,edges=build(n,e,'degcol'); t=time.time()
    with Solver(name='cadical195',bootstrap_with=cnf.clauses) as s:
        r=s.solve(); ok=None
        if r: cert=decode(s.get_model(),pool,x,y,edges,n); ok=check(n,cert) and len(cert)>=e
        res[e]=(r,ok,round(time.time()-t,2))
print(n,'degcol',M,res,'MATCH' if res[M][0] and res[M][1] and not res[M+1][0] else 'MISMATCH')
