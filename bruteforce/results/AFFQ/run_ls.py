"""Run the C local search ls on (beta, p); verify result; save runs/ls_<beta>_<p>.json.
usage: run_ls.py beta p iters seeds [init.json]"""
import sys, json, subprocess, os, time
from model import build, edges_of
from check_simple import check, affine_to_graph
beta, p, iters, seeds = sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), int(sys.argv[4])
init = sys.argv[5] if len(sys.argv) > 5 else None
B, simp, cyc = build(p, beta)
nv = (p - 1) * p
os.makedirs('tmp', exist_ok=True)
cf = 'tmp/cl_%s_%d.txt' % (beta, p)
with open(cf, 'w') as f:
    f.write('%d %d\n' % (nv, len(simp) + len(cyc)))
    for c in list(simp) + list(cyc):
        f.write('%d %s\n' % (len(c), ' '.join(map(str, c))))
out = 'runs/ls_%s_%d.json' % (beta, p)
bestm, bestsol = -1, None
if os.path.exists(out):
    old = json.load(open(out)); bestm, bestsol = old['m'], old['sol']
initf = '-'
if init:
    initf = 'tmp/init_%s_%d.txt' % (beta, p)
    open(initf, 'w').write('\n'.join(map(str, json.load(open(init))['sol'])) + '\n')
t0 = time.time()
for s in range(seeds):
    of = 'tmp/out_%s_%d_%d.txt' % (beta, p, s)
    subprocess.run(['./ls', str(s + int(time.time())), str(iters), of, initf], stdin=open(cf), check=True, stdout=subprocess.DEVNULL)
    sol = [int(l) for l in open(of)]
    if len(sol) > bestm:
        bestm, bestsol = len(sol), sol
n, G = affine_to_graph(p, edges_of(bestsol, p, B))
ok, info = check(n, G)
assert ok, info
json.dump(dict(beta=beta, p=p, m=bestm, sol=bestsol, iters=iters, seeds=seeds), open(out, 'w'))
print(json.dumps(dict(beta=beta, p=p, m=bestm, time=time.time() - t0, check=info)), flush=True)
