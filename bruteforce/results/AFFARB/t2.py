from model import solve
for p in (3,5,7):
    for kw in (dict(cuts=False), dict(cuts=True, symL=False), dict(cuts=True)):
        r = solve(p, time=600, **kw)
        print(p, kw, r[0], r[1], r[2], r[3], round(r[5],1), flush=True)
