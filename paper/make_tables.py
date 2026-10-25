#!/usr/bin/env python3
"""Regenerate the tables of the note from the verified result files.

Every certificate under ../bruteforce/results is re-checked here with a deliberately
simple 4-cycle checker before it is used. Run from the paper/ directory:

    python3 make_tables.py

Outputs (overwritten):
    data/best_lower_bounds.json
    tables/lower_bounds.tex
    tables/cyclic.tex
"""
import glob
import json
import os

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "..", "bruteforce", "results")

# Edge counts reported by T. Tao on the erdosproblems.com #810 forum (11 Dec 2025),
# found with AlphaEvolve; lower bounds only.
ALPHAEVOLVE = {4: 5, 5: 7, 6: 11, 7: 14, 8: 17, 9: 23, 10: 30, 11: 34, 12: 40,
               13: 47, 14: 54, 15: 62, 16: 69, 17: 77, 18: 85, 19: 94, 20: 103,
               21: 112, 22: 123, 23: 133, 24: 143, 25: 155}

# Exact optima of the cyclic orbit family (number of orbits k_max(n)), with how the
# upper bound k_max(n) + 1 was excluded.  Sources: results/CONSTR (cyclic_family_status.json,
# first UNSAT k), results/CYCPAT (enumeration, brute force), results/CYC.
DRAT = "DRAT"
BF = "DRAT; brute force"
CAKE = r"LRAT (\texttt{cake\_lpr})"
CYCLIC_EXACT = {
    12: (3, "brute force"),
    **{n: (k, BF) for n, k in {
        13: 3, 14: 3, 15: 4, 16: 4, 17: 4, 18: 5, 19: 5, 20: 5, 21: 6, 22: 5,
        23: 6, 24: 6, 25: 6, 26: 6, 27: 7, 28: 7, 29: 7, 30: 7, 31: 8}.items()},
    **{n: (k, DRAT) for n, k in {32: 8, 33: 8, 34: 8, 36: 9, 37: 9, 39: 9, 40: 10, 41: 10}.items()},
    35: (8, "DRAT; LRAT, 2nd encoder"),
    38: (9, "DRAT; LRAT, 2nd encoder"),
    42: (10, CAKE),
    44: (10, CAKE + ", 24 leaves"),
    47: (11, CAKE + ", 29 cubes"),
}


def check(n, edges):
    """True iff edges = [(u, v, c)] is a simple graph on [n], colours in [n],
    and every 4-cycle gets 4 distinct colours."""
    col = {}
    for u, v, c in edges:
        if not (0 <= u < n and 0 <= v < n and u != v and 0 <= c < n):
            return False
        key = (min(u, v), max(u, v))
        if key in col:
            return False
        col[key] = c
    adj = [set() for _ in range(n)]
    for u, v in col:
        adj[u].add(v)
        adj[v].add(u)

    def colour(a, b):
        return col[(min(a, b), max(a, b))]

    for a in range(n):
        for b in adj[a]:
            for c in adj[b]:
                if c == a:
                    continue
                for d in (adj[a] & adj[c]) - {b}:
                    cols = {colour(a, b), colour(b, c), colour(c, d), colour(d, a)}
                    if len(cols) < 4:
                        return False
    return True


def is_cyclic(n, edges):
    """Rotation-equivariant: i -> i+1 maps edges to edges and colour c to c+1."""
    col = {(min(u, v), max(u, v)): c for u, v, c in edges}
    for (u, v), c in col.items():
        k = (min((u + 1) % n, (v + 1) % n), max((u + 1) % n, (v + 1) % n))
        if col.get(k) != (c + 1) % n:
            return False
    return True


def to_edges(n, v):
    if isinstance(v, dict):
        for key in ("Dg", "dg", "edges", "cert", "E"):
            if key in v:
                v = v[key]
                break
    if not v:
        return None
    if len(v[0]) == 2:  # cyclic (d, g) pairs
        return [(i, (i + d) % n, (i + g) % n) for d, g in v for i in range(n)]
    return [tuple(e) for e in v]


def load_all():
    files = sorted(glob.glob(os.path.join(RES, "*", "certs*.json"))
                   + glob.glob(os.path.join(RES, "CYC", "*", "certs.json"))
                   + glob.glob(os.path.join(RES, "CYC", "*", "solutions.json"))
                   + glob.glob(os.path.join(RES, "CYCPAT", "certs.json"))
                   + glob.glob(os.path.join(RES, "PUSH", "*", "certs.json")))
    out = []
    for path in sorted(glob.glob(os.path.join(RES, "CYCPAT", "solutions", "enum_n*_k*.json"))):
        try:
            data = json.load(open(path))
        except (OSError, ValueError):
            continue
        if data.get("normal_forms"):
            n = int(data["n"])
            out.append((n, to_edges(n, data["normal_forms"][0]), "CYCPAT",
                        os.path.relpath(path, RES)))
    for path in sorted(glob.glob(os.path.join(RES, "PUSH", "*", "logs", "*.jsonl"))):
        for line in open(path):
            try:
                rec = json.loads(line)
            except ValueError:
                continue
            if rec.get("res") == "SATISFIABLE" and rec.get("Dg") and "n" in rec:
                n = int(rec["n"])
                out.append((n, to_edges(n, rec["Dg"]), "PUSH", os.path.relpath(path, RES)))
    for path in files:
        try:
            data = json.load(open(path))
        except (OSError, ValueError):
            continue
        task = os.path.relpath(path, RES).split(os.sep)[0]
        for key, val in data.items():
            if not str(key).isdigit():
                continue
            n = int(key)
            edges = to_edges(n, val)
            if edges is None:
                continue
            out.append((n, edges, task, os.path.relpath(path, RES)))
    return out


def main():
    os.makedirs(os.path.join(HERE, "data"), exist_ok=True)
    os.makedirs(os.path.join(HERE, "tables"), exist_ok=True)
    certs = load_all()
    lb_sources = {}
    try:
        lb_sources = json.load(open(os.path.join(RES, "LB", "sources.json")))
    except (OSError, ValueError):
        pass
    rank = {"cyclic": 2, "symmetric": 1, "search": 0, "padded": -1}
    best = {}
    best_cyc = {}
    rejected = []
    for n, edges, task, path in certs:
        if not check(n, edges):
            rejected.append((n, path))
            continue
        m = len(edges)
        if is_cyclic(n, edges):
            kind = "cyclic"
        elif task == "LB" and "sym" in str(lb_sources.get(str(n), "")):
            kind = "symmetric"
        else:
            kind = "search"
        old = best.get(n)
        if old is None or m > old[0] or (m == old[0] and rank[kind] > rank[old[3]]):
            best[n] = (m, task, path, kind)
        if kind == "cyclic" and m // n > best_cyc.get(n, 0):
            best_cyc[n] = m // n
    if rejected:
        raise SystemExit(f"certificate check failed: {rejected}")

    # Padding: M(n) >= M(m) + (n - m) for m < n (add pendant vertices joined to vertex 0
    # with colour 0; a pendant edge lies on no 4-cycle).  Build and re-check the padded
    # certificate whenever it beats the direct one.
    cert_of = {}
    for n, edges, task, path in certs:
        if best.get(n) and best[n][2] == path and len(edges) == best[n][0]:
            cert_of.setdefault(n, edges)
    padded = {}
    for n in sorted(best):
        cands = [(best[m][0] + (n - m), m) for m in best if m < n and m >= 2]
        if not cands:
            continue
        val, m = max(cands)
        if val > best[n][0]:
            base = cert_of[m] if m not in padded else padded[m]
            edges = list(base) + [(0, v, 0) for v in range(m, n)]
            if not check(n, edges) or len(edges) != val:
                raise SystemExit(f"padding failed at n={n} from m={m}")
            padded[n] = edges
            best[n] = (val, "padded", f"padded from n={m}", "padded")
            cert_of[n] = edges
    if padded:
        json.dump({str(n): e for n, e in sorted(padded.items())},
                  open(os.path.join(HERE, "data", "padded_certs.json"), "w"))

    json.dump({str(n): {"edges": b[0], "task": b[1], "file": b[2], "type": b[3]}
               for n, b in sorted(best.items())},
              open(os.path.join(HERE, "data", "best_lower_bounds.json"), "w"), indent=1)

    # Lower-bound table, n = 13..128.
    rows = []
    for n in sorted(best):
        if n < 13:
            continue
        m, task, _path, kind = best[n]
        ae = ALPHAEVOLVE.get(n)
        rows.append(f"{n} & {ae if ae else '--'} & {m} & {m / n / n:.3f} & {kind} \\\\")
    with open(os.path.join(HERE, "tables", "lower_bounds.tex"), "w") as fh:
        fh.write("% generated by make_tables.py -- do not edit\n")
        fh.write("\n".join(rows) + "\n")

    # Cyclic family table: exact values, then best known lower bounds.
    crows = []
    for n in range(12, 101):
        if n in CYCLIC_EXACT:
            k, how = CYCLIC_EXACT[n]
            found = best_cyc.get(n)
            if found is not None and found > k:
                raise SystemExit(f"cyclic certificate at n={n} beats claimed k_max={k}")
            crows.append(f"{n} & {k} & {k / n:.3f} & exact ({how}) \\\\")
        elif n in best_cyc:
            k = best_cyc[n]
            crows.append(f"{n} & $\\ge {k}$ & {k / n:.3f} & lower bound \\\\")
    with open(os.path.join(HERE, "tables", "cyclic.tex"), "w") as fh:
        fh.write("% generated by make_tables.py -- do not edit\n")
        fh.write("\n".join(crows) + "\n")

    print(f"verified {len(certs)} certificates; "
          f"best bounds for {len(best)} values of n; cyclic data for {len(best_cyc)}")


if __name__ == "__main__":
    main()
