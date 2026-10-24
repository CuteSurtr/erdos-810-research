#!/usr/bin/env python3
"""symrun.py n e m j T [seed]: sigma = floor(n/m) m-cycles on 0..rm-1 (rest fixed),
tau = j m-cycles on colours 0..jm-1 (rest fixed). Builds the CNF, runs kissat for T s,
decodes and checks a model into out/sym_m{m}j{j}_n{n}_e{e}.txt."""
import sys, subprocess, os
from check import check
n, e, m, j, T = map(int, sys.argv[1:6]); seed = sys.argv[6] if len(sys.argv) > 6 else '0'
r = n // m
cyc = lambda cnt: ';'.join(','.join(str(i * m + t) for t in range(m)) for i in range(cnt))
sig, tau = cyc(r), cyc(j)
name = f'sym_m{m}j{j}s{seed}_n{n}_e{e}'
cnf = f'cnf/{name}.cnf'
subprocess.run(['python3', 'symenc.py', str(n), str(e), cnf, '--sigma', sig, '--tau', tau], check=True)
with open(f'cnf/{name}.log', 'w') as lf:
    p = subprocess.run(['./kissat', '-q', f'--time={T}', f'--seed={seed}', cnf], stdout=lf)
st = {10: 'SAT', 20: 'UNSAT'}.get(p.returncode, 'UNKNOWN')
if st == 'SAT':
    subprocess.run(['python3', 'decode.py', cnf, f'cnf/{name}.log', f'out/{name}.txt'], check=True)
    c = [list(map(int, l.split())) for l in open(f'out/{name}.txt')]
    st += ' check=' + str(check(n, c))
print(f'RESULT n={n} e={e} m={m} j={j} seed={seed} {st}', flush=True)
os.remove(cnf)
