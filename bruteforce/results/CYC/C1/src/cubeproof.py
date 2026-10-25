#!/usr/bin/env python3
"""cubeproof.py d1 d2 ... : for n = 44, k = 11, add the orbit-presence cube to the sym=3 CNF,
run CaDiCaL with LRAT and check the proof with lratcheck.  Appends a line to logs/proofs_cubes.txt."""
import sys, os, subprocess
R = os.path.dirname(os.path.dirname(os.path.abspath(__file__))); W = "/tmp/claude-0/w"
n, H = 44, 21; cube = [int(x) for x in sys.argv[1:]]; tag = "_".join(sys.argv[1:]).replace("-", "m")
cnf, prf = f"{W}/cp_{tag}.cnf", f"{W}/cp_{tag}.lrat"
lines = [l for l in open(f"{W}/c_44_11_3.cnf") if l[0] not in "cp"]
with open(cnf, "w") as g:
    g.write(f"p cnf {n * H + 10**6} {len(lines) + len(cube)}\n".replace(str(n * H + 10**6), open(f"{W}/c_44_11_3.cnf").read(4096).split("p cnf ")[1].split()[0]))
    g.writelines(lines)
    for d in cube: g.write(f"{H * n + d if d > 0 else -(H * n - d)} 0\n")
r = subprocess.run(["cadical", "-q", "--lrat=true", "--binary=false", cnf, prf], capture_output=True, text=True).stdout.splitlines()[0]
v = subprocess.run([f"{R}/src/lratcheck", cnf, prf], capture_output=True, text=True)
sz = os.path.getsize(prf)
with open(f"{R}/logs/proofs_cubes.txt", "a") as f: f.write(f"44 11 cube[{' '.join(sys.argv[1:])}] {r} LRAT: {v.stdout.strip() or v.stderr.strip()} {sz/1e6:.0f}M\n")
os.remove(cnf); os.remove(prf)
