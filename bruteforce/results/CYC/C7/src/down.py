#!/usr/bin/env python3
"""Certificate fallback: usage down.py n k_start cap_per_k.  If logs/main.jsonl has no SAT for n,
race kissat/CaDiCaL at k_start, k_start-1, ... (cap_per_k seconds each) until one is SAT."""
import sys, json, os, time
sys.argv = sys.argv  # noqa
here = os.path.dirname(os.path.abspath(__file__)); root = os.path.dirname(here)
sys.path.insert(0, here)
n, k, cap = int(sys.argv[1]), int(sys.argv[2]), float(sys.argv[3])
def have_sat():
    return any(json.loads(l)["n"] == n and json.loads(l)["res"] == "SAT" for l in open(f"{root}/logs/main.jsonl"))
import importlib.util
spec = importlib.util.spec_from_file_location("pern_race", f"{here}/race.py"); m = importlib.util.module_from_spec(spec); spec.loader.exec_module(m)
while not have_sat() and k > 0:
    r = m.race(n, k, cap); print(n, k, r["res"], flush=True)
    if r["res"] == "SAT": break
    k -= 1
