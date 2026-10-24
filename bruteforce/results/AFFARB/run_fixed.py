"""SA with beta held fixed (fixb=1) for fixed formulas / random beta; verified; appends to fixed.jsonl"""
import sys, json
from concurrent.futures import ProcessPoolExecutor
from run_ls import job
from check import check
ps = list(map(int, sys.argv[1].split(","))); seeds = range(int(sys.argv[2])); itf = float(sys.argv[3])
inits = sys.argv[4].split(","); nproc = int(sys.argv[5]); fixb = int(sys.argv[6]) if len(sys.argv) > 6 else 1
jobs = [(p, s, int(itf * p ** 3), init, fixb, "1.5") for p in ps for init in inits for s in seeds]
with ProcessPoolExecutor(nproc) as ex, open("fixed.jsonl", "a") as f:
    for args, (p, m, beta, D) in ex.map(job, jobs):
        ok, msg = check(p, beta, D)
        assert ok, msg
        f.write(json.dumps(dict(p=p, init=args[3], seed=args[1], iters=args[2], fixb=fixb, m=m, beta=beta, D=D)) + "\n"); f.flush()
        print(args, m, flush=True)
