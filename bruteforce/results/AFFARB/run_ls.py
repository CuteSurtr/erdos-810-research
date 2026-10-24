"""Driver: run ./ls for primes/seeds/inits in parallel, verify with check.py, keep best in best/<p>.json."""
import sys, json, os, subprocess, itertools
from concurrent.futures import ProcessPoolExecutor
from check import check

def parse(out):
    L = out.strip().splitlines()
    p, m = map(int, L[0].split())
    beta = list(map(int, L[1].split()))
    D = {}
    for line in L[2:]:
        v = list(map(int, line.split()))
        D[v[0]] = v[1:]
    return p, m, beta, D

def job(args):
    p, seed, iters, init, fixb, lam = args
    out = subprocess.run(["./ls", str(p), str(seed), str(iters), init, str(fixb), str(lam)], capture_output=True, text=True).stdout
    return args, parse(out)

def save(p, m, beta, D, src):
    fn = f"best/{p}.json"
    old = json.load(open(fn))["m"] if os.path.exists(fn) else -1
    ok, msg = check(p, beta, D)
    assert ok and sum(len(v) for v in D.values()) == m, msg
    if m > old:
        json.dump(dict(p=p, m=m, beta=beta, D={str(a): v for a, v in D.items()}, source=src, check=msg), open(fn, "w"))
        return True
    return False

if __name__ == "__main__":
    ps = list(map(int, sys.argv[1].split(",")))
    seeds = range(int(sys.argv[2]))
    itf = float(sys.argv[3])          # iterations = itf * p^3
    inits = sys.argv[4].split(",")
    nproc = int(sys.argv[5]) if len(sys.argv) > 5 else 4
    lam = sys.argv[6] if len(sys.argv) > 6 else "1.5"
    fixb = int(sys.argv[7]) if len(sys.argv) > 7 else 0
    jobs = [(p, s, int(itf * p ** 3), init, fixb, lam) for p in ps for init in inits for s in seeds]
    with ProcessPoolExecutor(nproc) as ex:
        for args, (p, m, beta, D) in ex.map(job, jobs):
            new = save(p, m, beta, D, f"ls seed={args[1]} iters={args[2]} init={args[3]} fixb={args[4]} lam={args[5]}")
            print(args, m, "NEW" if new else "", flush=True)
