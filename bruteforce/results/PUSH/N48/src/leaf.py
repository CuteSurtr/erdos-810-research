#!/usr/bin/env python3
"""leaf.py n k timeout cube [proof [solver-opts]]: solve the sym=3 CNF of (n, k) (C1's cycenc) under a cube of
orbit-presence literals (+d present, -d absent; comma-separated, may be empty) with CaDiCaL.
proof=drat: CaDiCaL writes a binary DRAT file, checked by drat-trim after an UNSAT answer.
proof=lrat (or 1): CaDiCaL streams a binary LRAT proof through a fifo into cake_lpr, which checks it
on the fly (no proof file on disk; the byte count is taken by a tee in between).
SAT models are decoded and re-checked with check.py.  Prints one JSON line on stdout."""
import sys, os, json, subprocess, time, hashlib
SRC = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, SRC)
from check import check
WORK = os.environ.get("CYCWORK", "/tmp/claude-0/w"); B = "/tmp/claude-0/b"
CAD, DT = f"{B}/cadical/build/cadical", f"{B}/drat-trim/drat-trim"
n, k, tl = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3])
cube = [int(t) for t in sys.argv[4].split(",") if t]; pm = sys.argv[5] if len(sys.argv) > 5 else "0"
pm = "lrat" if pm == "1" else pm; proof = pm in ("drat", "lrat")
CAKE = f"{B}/cake_lpr/cake_lpr"
extra = sys.argv[6].split() if len(sys.argv) > 6 else []
H = (n + 1) // 2 - 1; P = lambda d: H * n + d
base = f"{WORK}/c_{n}_{k}_3.cnf"
if not os.path.exists(base): subprocess.run([f"{SRC}/cycenc", str(n), str(k), "3", base], check=True, stderr=subprocess.DEVNULL)
tag = ("_".join(str(c) for c in cube).replace("-", "m") or "root") + f"_{os.getpid()}"
cnf, prf = f"{WORK}/cube_{n}_{k}_{tag}.cnf", f"{WORK}/cube_{n}_{k}_{tag}.drat"
h = hashlib.sha256()
with open(base) as f, open(cnf, "w") as g:
    for line in f:
        if line.startswith("p cnf"):
            _, _, v, c = line.split(); line = f"p cnf {v} {int(c) + len(cube)}\n"
        g.write(line); h.update(line.encode())
    for c in cube:
        line = f"{P(c) if c > 0 else -P(-c)} 0\n"; g.write(line); h.update(line.encode())
out = {"n": n, "k": k, "cube": cube, "res": "UNKNOWN", "cnf_sha256": h.hexdigest(), "solver": "cadical " +
       subprocess.run([CAD, "--version"], capture_output=True, text=True).stdout.strip(), "opts": extra}
t0 = time.time()
if pm == "lrat":
    fa, fb, szf, ckf = prf + ".a", prf + ".b", prf + ".sz", prf + ".ck"
    os.mkfifo(fa); os.mkfifo(fb)
    ck = subprocess.Popen(f"{CAKE} --CML_HEAP_SIZE=3000 --CML_STACK_SIZE=1000 {cnf} {fb} > {ckf} 2>&1", shell=True)
    tp = subprocess.Popen(f"cat {fa} | tee {fb} | wc -c > {szf}", shell=True)
    cmd = [CAD, "-q", "-t", str(tl), "--lrat"] + extra + [cnf, fa]
else:
    cmd = [CAD, "-q", "-t", str(tl)] + extra + [cnf] + ([prf] if proof else [])
r = subprocess.run(cmd, capture_output=True, text=True); lines = r.stdout.splitlines()
if pm == "lrat":
    tp.wait(); t1 = time.time(); ck.wait()
    ckout = open(ckf).read(); out["proof_bytes"] = int(open(szf).read().split()[0])
    for f in (fa, fb, szf, ckf): os.remove(f)
out["secs"] = round(time.time() - t0, 1)
if any(l.startswith("s SATISFIABLE") for l in lines):
    m = set()
    for l in lines:
        if l.startswith("v "): m |= {int(t) for t in l[2:].split() if int(t) > 0}
    Dg = [[d, gg] for d in range(1, H + 1) for gg in range(n) if 1 + (d - 1) * n + gg in m]
    ok, E, info = check(n, Dg); out.update({"res": "SAT", "Dg": Dg, "size": len(Dg), "check": "OK" if ok else f"FAIL {info}"})
elif any(l.startswith("s UNSATISFIABLE") for l in lines):
    out["res"] = "UNSAT"
    if pm == "lrat":
        sl = [l for l in ckout.splitlines() if l.startswith("s ")]
        out["check"] = sl[-1] if sl else "no verdict: " + ckout[-200:]
        out["check_extra_secs"] = round(time.time() - t1, 1); out["checker"] = "cake_lpr a36874a (streamed binary LRAT)"
    if pm == "drat":
        out["proof_bytes"] = os.path.getsize(prf); t1 = time.time()
        v = subprocess.run([DT, cnf, prf, "-t", "50000"], capture_output=True, text=True)
        sl = [l for l in v.stdout.splitlines() if l.startswith("s ")]
        out["check"] = sl[-1] if sl else "no verdict: " + v.stdout[-200:]
        out["check_secs"] = round(time.time() - t1, 1); out["checker"] = "drat-trim 2e3b2dc"
for f in (cnf, prf):
    if os.path.exists(f): os.remove(f)
print(json.dumps(out), flush=True)
