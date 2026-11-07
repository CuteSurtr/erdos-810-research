#!/usr/bin/env python3
"""Find certificate lower bounds by attaching one vertex to a fixed coloring.

All old edges/colors are retained. A new C4 is precisely new-a-b-d-new.
For each pair of selected attachment vertices a,d, forbid repeated colors
on the two old path edges, exclude their colors on both new edges, and
require the two new colors to differ. No upper bound on general graphs
is inferred from UNSAT of this restricted extension problem.
"""
import argparse
import hashlib
import itertools
import json
import os
import pathlib
import subprocess
import time


def encode(n, edges, target):
    colors = n + 1
    nv = n * colors + n
    clauses = []
    X = lambda v, c: 1 + v * colors + c
    P = lambda v: n * colors + v + 1

    def fresh():
        nonlocal nv
        nv += 1
        return nv

    for v in range(n):
        clauses.append([-P(v)] + [X(v, c) for c in range(colors)])
        prev = None
        for c in range(colors):
            x = X(v, c)
            clauses.append([-x, P(v)])
            if c < colors - 1:
                s = fresh()
                clauses.append([-x, s])
                if prev:
                    clauses.extend([[-prev, s], [-prev, -x]])
                prev = s
            elif prev:
                clauses.append([-prev, -x])
    col = {tuple(sorted((a, b))): c for a, b, c in edges}
    assert len(col) == len(edges)
    adj = [set() for _ in range(n)]
    for a, b, c in edges:
        assert 0 <= a < n and 0 <= b < n and a != b and 0 <= c < n
        adj[a].add(b)
        adj[b].add(a)
    for a, d in itertools.combinations(range(n), 2):
        common = adj[a] & adj[d]
        if not common:
            continue
        pairs = [(col[tuple(sorted((a, b)))], col[tuple(sorted((d, b)))])
                 for b in common]
        if any(c == e for c, e in pairs):
            clauses.append([-P(a), -P(d)])
            continue
        forbidden = {c for pair in pairs for c in pair}
        for c in sorted(forbidden):
            clauses.extend([[-X(a, c), -P(d)], [-P(a), -X(d, c)]])
        for c in range(colors):
            clauses.append([-X(a, c), -X(d, c)])
    # At least target present vertices: at most n-target absent ones (Sinz).
    m = n - target
    if m < 0:
        clauses.append([])
    elif m == 0:
        clauses.extend([[P(v)] for v in range(n)])
    else:
        prev = None
        for v in range(n):
            s = [fresh() for _ in range(m)]
            clauses.append([P(v), s[0]])
            if prev:
                clauses.extend([[-prev[j], s[j]] for j in range(m)])
                clauses.extend([[P(v), -prev[j - 1], s[j]] for j in range(1, m)])
                clauses.append([P(v), -prev[-1]])
            prev = s
    return nv, clauses


def verify(n, edges):
    """Enumerate each four-set's three cycles, independently of the encoding."""
    checker = os.environ.get('FOURSET_CHECKER')
    if checker:
        data = f'{n} {len(edges)}\n' + ''.join(f'{a} {b} {c}\n' for a,b,c in edges)
        run = subprocess.run([checker], input=data, text=True, capture_output=True, check=True)
        return int(run.stdout.split()[3])
    col = {tuple(sorted((a, b))): c for a, b, c in edges}
    assert len(col) == len(edges)
    assert all(0 <= a < n and 0 <= b < n and a != b and 0 <= c < n
               for a, b, c in edges)
    cycles = 0
    for a, b, c, d in itertools.combinations(range(n), 4):
        for cycle in [(a,b,c,d), (a,b,d,c), (a,c,b,d)]:
            cs = [col.get(tuple(sorted((cycle[i], cycle[(i+1) % 4])))) for i in range(4)]
            if None not in cs:
                assert len(set(cs)) == 4, (cycle, cs)
                cycles += 1
    return cycles


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('certs')
    ap.add_argument('n', type=int)
    ap.add_argument('output')
    ap.add_argument('--start', type=int, default=2)
    ap.add_argument('--budget', type=int, default=180)
    ap.add_argument('--cap', type=int, default=30)
    args = ap.parse_args()
    n = args.n
    E = json.loads(pathlib.Path(args.certs).read_text())[str(n)]
    verify(n, E)
    output = pathlib.Path(args.output)
    output.mkdir(parents=True, exist_ok=True)
    (output / 'base.json').write_text(json.dumps({str(n): E}) + '\n')
    deadline = time.monotonic() + args.budget
    target = args.start
    best = 1
    if not (output / 'certs.json').exists():
        # A pendant edge is a guaranteed valid starting certificate.
        pendant = E + [[0, n, n]]
        verify(n+1, pendant)
        (output / 'certs.json').write_text(json.dumps({str(n+1): pendant})+'\n')
    if (output / 'certs.json').exists():
        previous = json.loads((output / 'certs.json').read_text())[str(n+1)]
        assert previous[:len(E)] == E, 'existing candidate uses a different base'
        verify(n+1, previous)
        best = len(previous) - len(E)
        target = max(target, best+1)
    upper = n + 1
    cad = str(pathlib.Path(os.environ['CYC_TOOLS']) / 'cadical/build/cadical')
    while target < upper and time.monotonic() < deadline:
        nv, clauses = encode(n, E, target)
        data = f'p cnf {nv} {len(clauses)}\n' + ''.join(' '.join(map(str, c)) + ' 0\n' for c in clauses)
        cnf = output / f'target-{target}.cnf'
        cnf.write_text(data)
        cap = max(1, min(args.cap, int(deadline - time.monotonic())))
        start = time.monotonic()
        run = subprocess.run([cad, '-q', '-t', str(cap), '--sat', str(cnf)],
                             capture_output=True, text=True)
        (output / f'target-{target}.solver.txt').write_text(run.stdout + run.stderr)
        rec = {'base_n': n, 'base_edges': len(E), 'target_degree': target,
               'cnf_sha256': hashlib.sha256(data.encode()).hexdigest(),
               'solver_returncode': run.returncode, 'seconds': round(time.monotonic()-start, 3)}
        if run.returncode == 10:
            model = {int(t) for line in run.stdout.splitlines() if line.startswith('v ')
                     for t in line[2:].split() if int(t) > 0}
            assert all(any((lit in model) if lit > 0 else (-lit not in model) for lit in c) for c in clauses)
            extra = [[v, n, c] for v in range(n) for c in range(n+1) if 1+v*(n+1)+c in model]
            assert len({v for v, _, _ in extra}) == len(extra) >= target
            candidate = E + extra
            cycles = verify(n+1, candidate)
            best = max(best, len(extra))
            (output / 'certs.json').write_text(json.dumps({str(n+1): candidate})+'\n')
            rec.update(result='SAT', edges=len(candidate), degree=len(extra), checked_cycles=cycles)
            target = min(n, max(best+1, best*2)) if upper == n+1 else (best+upper)//2
            if best == n:
                upper = n+1
                target = upper
        elif run.returncode == 20:
            rec['result'] = 'UNSAT (restricted extension; proof not checked)'
            upper = target
            target = (best+upper)//2 if best else 0
        else:
            rec['result'] = 'UNKNOWN'
            # This is a search bracket only, never a mathematical upper bound.
            # Try an easier intermediate target if the doubling jump timed out.
            upper = target
            target = (best+upper)//2 if best else 0
        with (output / 'attempts.jsonl').open('a') as f:
            f.write(json.dumps(rec)+'\n')
        print(json.dumps(rec), flush=True)
        if target <= best or target == 0:
            break


if __name__ == '__main__':
    main()
