"""Full automorphism group of the clause hypergraph (vars + clauses as a
vertex-coloured bipartite graph) via nauty's dreadnaut. Prints group order and
writes generators (as permutations of vars) to runs/aut_<beta>_<p>.json."""
import sys, subprocess, json, re
from model import build
beta, p = sys.argv[1], int(sys.argv[2])
B, simp, cyc = build(p, beta)
cls = [tuple(c) for c in simp] + [tuple(c) for c in cyc]
nv = (p - 1) * p
N = nv + len(cls)
adj = [[] for _ in range(N)]
for i, c in enumerate(cls):
    for v in c:
        adj[v].append(nv + i)
cells = {}
for i, c in enumerate(cls):
    cells.setdefault(len(c), []).append(nv + i)
lines = ['n=%d g' % N]
for v in range(N):
    lines.append(' '.join(map(str, adj[v])) + (';' if v < N - 1 else '.'))
part = '[0:%d' % (nv - 1) + ''.join(' | ' + ','.join(map(str, cells[k])) for k in sorted(cells)) + ']'
inp = '\n'.join(lines) + '\nf=' + part + '\n+a x\nq\n'
out = subprocess.run(['dreadnaut'], input=inp, capture_output=True, text=True).stdout
grp = re.search(r'grpsize=([0-9.e+]+)', out)
perms, cur = [], None
for l in out.split('\n'):
    if l.startswith('('):
        if cur is not None:
            perms.append(cur)
        cur = l.strip()
    elif l.startswith('   ') and cur is not None:
        cur += ' ' + l.strip()
    else:
        if cur is not None:
            perms.append(cur)
        cur = None
gens = []
for t in perms:
    pm = list(range(nv))
    for cyc_ in re.findall(r'\(([^)]*)\)', t):
        el = list(map(int, cyc_.split()))
        for i, e in enumerate(el):
            if e < nv:
                pm[e] = el[(i + 1) % len(el)]
    if pm != list(range(nv)):
        gens.append(pm)
print(beta, p, 'group size', grp.group(1), 'gens', len(gens))
json.dump(dict(grpsize=grp.group(1), gens=gens), open('runs/aut_%s_%d.json' % (beta, p), 'w'))
