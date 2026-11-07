"""race(n, k, tl): run kissat (seed 1) and CaDiCaL (seed 2) via run.py on (n, k), sym 2; first definite
answer wins, the other is killed.  All finished run.py lines are appended to logs/main.jsonl."""
import subprocess, time, json, os
here = os.path.dirname(os.path.abspath(__file__)); root = os.path.dirname(here)
def race(n, kk, tl):
    cfgs = [("kissat", 1), ("cadical", 2)]
    ps = [subprocess.Popen(["python3", f"{here}/run.py", str(n), str(kk), "2", s, str(seed), str(int(tl))],
                           stdout=subprocess.PIPE, text=True) for s, seed in cfgs]
    res = None
    while res is None:
        time.sleep(2)
        alive = 0
        for p in ps:
            if p.poll() is None: alive += 1; continue
            if p.returncode == 0 and not getattr(p, "_logged", False):
                p._logged = True
                r = json.loads(p.stdout.read())
                with open(f"{root}/logs/main.jsonl", "a") as f: f.write(json.dumps(r) + "\n")
                if r["res"] in ("SAT", "UNSAT", "BADMODEL"): res = r; break
        if res is None and alive == 0: res = {"res": "UNKNOWN", "n": n, "k": kk}
    for p in ps:
        if p.poll() is None:
            subprocess.run(["pkill", "-f", f"n{n}_k{kk}_s2_"]); p.wait()
    return res
