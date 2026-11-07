#!/usr/bin/env python3
"""leaf.py n k timeout cube [proof [solver-opts]]: solve the sym=3 CNF of (n, k) (C1's cycenc) under a cube of
orbit-presence literals (+d present, -d absent; comma-separated, may be empty) with CaDiCaL.
proof=drat: CaDiCaL writes a binary DRAT file, checked by drat-trim after an UNSAT answer.
proof=lrat (or 1): CaDiCaL streams a binary LRAT proof through a fifo into cake_lpr, which checks it
on the fly (no proof file on disk; the byte count is taken by a tee in between).
SAT models are decoded and re-checked with check.py.  Prints one JSON line on stdout."""
import sys, os, json, subprocess, time, hashlib, signal
SRC = os.path.dirname(os.path.abspath(__file__)); sys.path.insert(0, SRC)
from check import check
WORK = os.environ["CYCWORK"]; B = os.environ["CYC_TOOLS"]
CAD, DT = f"{B}/cadical/build/cadical", f"{B}/drat-trim/drat-trim"
n, k, tl = int(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3])
# cube tokens: +d / -d (orbit d present / absent), d:g (x(d,g): orbit d present with offset g), -d:g (not x(d,g))
def tok(t):
    if ":" in t:
        d, g = t.split(":"); s = -1 if d.startswith("-") else 1; return s * (1 + (abs(int(d)) - 1) * n + int(g))
    return P(int(t)) if int(t) > 0 else -P(-int(t))
cube = [t for t in sys.argv[4].split(",") if t]; pm = sys.argv[5] if len(sys.argv) > 5 else "0"
pm = "lrat" if pm == "1" else pm; proof = pm in ("drat", "lrat")
CAKE = f"{B}/cake_lpr/cake_lpr"
extra = sys.argv[6].split() if len(sys.argv) > 6 else []
H = (n + 1) // 2 - 1; P = lambda d: H * n + d
base = f"{WORK}/c_{n}_{k}_3.cnf"
if not os.path.exists(base): subprocess.run([f"{SRC}/cycenc", str(n), str(k), "3", base], check=True, stderr=subprocess.DEVNULL)
tag = ("_".join(c.replace(":", "x") for c in cube).replace("-", "m") or "root") + f"_{os.getpid()}"
cnf, prf = f"{WORK}/cube_{n}_{k}_{tag}.cnf", f"{WORK}/cube_{n}_{k}_{tag}.drat"
h = hashlib.sha256()
with open(base) as f, open(cnf, "w") as g:
    for line in f:
        if line.startswith("p cnf"):
            _, _, v, c = line.split(); line = f"p cnf {v} {int(c) + len(cube)}\n"
        g.write(line); h.update(line.encode())
    for c in cube:
        line = f"{tok(c)} 0\n"; g.write(line); h.update(line.encode())
out = {"n": n, "k": k, "cube": [t if ":" in t else int(t) for t in cube], "res": "UNKNOWN", "cnf_sha256": h.hexdigest(), "solver": "cadical " +
       subprocess.run([CAD, "--version"], capture_output=True, text=True).stdout.strip(), "opts": extra}
t0 = time.time()
if pm == "lrat":
    fa, fb, szf, ckf = prf + ".a", prf + ".b", prf + ".sz", prf + ".ck"
    os.mkfifo(fa); os.mkfifo(fb)
    # Keep a writer open while CaDiCaL opens/reopens the proof path, so the
    # relay cannot mistake the interval between opens for end-of-file.
    fifo_guard = os.open(fa, os.O_RDWR)
    with open(ckf, "w") as checker_log:
        ck = subprocess.Popen([CAKE, "--CML_HEAP_SIZE=1000", "--CML_STACK_SIZE=64", cnf, fb],
                              stdout=checker_log, stderr=subprocess.STDOUT, start_new_session=True)
    tp = subprocess.Popen(f"set -o pipefail; cat {fa} | tee {fb} | wc -c > {szf}",
                          shell=True, executable="/bin/bash", start_new_session=True)
    cmd = [CAD, "-q", "-t", str(tl), "--lrat"] + extra + [cnf, fa]
else:
    cmd = [CAD, "-q", "-t", str(tl)] + extra + [cnf] + ([prf] if proof else [])
r = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True,
                     start_new_session=True)
while True:
    try:
        stdout, stderr = r.communicate(timeout=1)
        break
    except subprocess.TimeoutExpired:
        reason = None
        if pm == "lrat" and ck.poll() not in (None, 0):
            reason = "proof checker failed"
        elif pm == "lrat" and tp.poll() not in (None, 0):
            reason = "proof relay failed"
        elif time.time() - t0 > tl + 10:
            reason = "external wall-clock deadline"
        if reason:
            out["abort_reason"] = reason
            # A solver blocked on a dead proof pipe can catch SIGTERM and stay
            # blocked in its handler. SIGKILL guarantees bounded cleanup.
            r.kill()
            stdout, stderr = r.communicate()
            break
lines = stdout.splitlines()
out["solver_returncode"] = r.returncode
if stderr.strip(): out["solver_stderr"] = stderr.strip()[-1000:]
if pm == "lrat":
    os.close(fifo_guard)
    for proc in (tp, ck):
        try: proc.wait(timeout=30)
        except subprocess.TimeoutExpired:
            os.killpg(proc.pid, signal.SIGKILL)
            proc.wait()
            out["abort_reason"] = "proof cleanup deadline"
    t1 = time.time()
    ckout = open(ckf).read()
    sizes = open(szf).read().split()
    out["proof_bytes"] = int(sizes[0]) if sizes else None
    out["checker_returncode"] = ck.returncode
    out["checker_output"] = ckout.strip()
    out["stream_returncode"] = tp.returncode
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
        out["check"] = sl[-1] if sl and ck.returncode == 0 and tp.returncode == 0 and not out.get("abort_reason") else "no successful verdict: " + ckout[-200:]
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
