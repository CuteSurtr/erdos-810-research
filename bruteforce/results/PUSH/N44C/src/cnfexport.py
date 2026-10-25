#!/usr/bin/env python3
"""Export one case of CYCPAT's split of (n, k) as a DIMACS CNF.

The clause set is exactly the one built by results/CYCPAT/src/cycenum.py (same variables in the
same pool order, same keys, same cardinality and translation clauses); cycenum.py is imported
directly so the encoding is not re-typed.  The CNF is satisfiable iff the case has a solution
(cycenum's enumeration loop only adds blocking clauses on top of this formula).

Cases (as in cycenum.py, plus a third-orbit refinement):
  nounit            D contains no unit
  unit2:e           1 in D, g(1) = 0, e = min(D minus {1})
  unit3:e:f         unit2:e and f = min(D minus {1, e})      (f = e+1..H covers unit2:e when k >= 3)
  pre:1.e.f.h...    the smallest |P| elements of D are exactly P, g(1) = 0 (pre:1.e.f == unit3:e:f)
  none              no case restriction
usage: cnfexport.py n k case out.cnf [map.json]"""
import sys, os, json
sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), '../../../CYCPAT/src'))
from math import gcd
from pysat.card import CardEnc, EncType
from pysat.formula import IDPool, CNF
import cycenum

def build(n, k, case):
    H = (n + 1) // 2 - 1
    pool = IDPool()
    X = lambda d, g: pool.id(('x', d, g)); P = lambda d: pool.id(('p', d))
    Y = lambda a, b, t: pool.id(('y', a, b, t))
    cl = []
    for d in range(1, H + 1):
        cl.append([-P(d)] + [X(d, g) for g in range(n)])
        for g in range(n): cl.append([-X(d, g), P(d)])
        cl += CardEnc.atmost([X(d, g) for g in range(n)], 1, vpool=pool, encoding=EncType.seqcounter).clauses
    ks = cycenum.keys(n, H)
    ys = set()
    for da, db, delta, others in sorted(ks):
        cl.append([-Y(da, db, delta)] + [-P(o) for o in others])
        ys.add((da, db, delta))
    for da, db, delta in sorted(ys):
        for t in range(n):
            cl.append([-X(da, t), -X(db, (t - delta) % n), Y(da, db, delta)])
    cl += CardEnc.equals([P(d) for d in range(1, H + 1)], k, vpool=pool, encoding=EncType.totalizer).clauses
    for d in range(1, H + 1):
        cl.append([-P(d)] + [P(e) for e in range(1, d)] + [X(d, 0)])
    if case == 'unit':
        cl.append([P(1)]); cl.append([X(1, 0)])
    elif case.startswith('unit2:'):
        e = int(case.split(':')[1])
        cl.append([P(1)]); cl.append([X(1, 0)]); cl.append([P(e)])
        cl += [[-P(d)] for d in range(2, e)]
    elif case.startswith('unit3:'):
        _, e, f = case.split(':'); e, f = int(e), int(f)
        assert 2 <= e < f <= H
        cl.append([P(1)]); cl.append([X(1, 0)]); cl.append([P(e)]); cl.append([P(f)])
        cl += [[-P(d)] for d in range(2, e)]
        cl += [[-P(d)] for d in range(e + 1, f)]
    elif case.startswith('pre:'):
        # prefix case: the smallest elements of D are exactly P = [1, e, f, ...] (strictly increasing), g(1) = 0.
        # For |P| < k, the cases pre:P+[x] for x = max(P)+1..H cover pre:P.
        Pl = [int(t) for t in case[4:].split('.')]
        assert Pl[0] == 1 and all(a < b for a, b in zip(Pl, Pl[1:])) and Pl[-1] <= H
        cl.append([X(1, 0)])
        cl += [[P(d)] for d in Pl]
        cl += [[-P(d)] for d in range(1, Pl[-1]) if d not in Pl]
    elif case.startswith('sb:'):
        # prefix case pre:P plus symmetry breaking (see sb_clauses), sound by the argument in REPORT.md
        Pl = [int(t) for t in case[3:].split('.')]
        cl += build(n, k, 'pre:' + case[3:])[0][len(cl):]
        cl += sb_clauses(n, H, Pl, P, X)
    elif case == 'nounit':
        cl += [[-P(d)] for d in range(1, H + 1) if gcd(d, n) == 1]
    else:
        assert case == 'none'
    xmap = {f"{d},{g}": X(d, g) for d in range(1, H + 1) for g in range(n)}
    return cl, xmap

def sb_clauses(n, H, Pl, P, X):
    """Extra clauses for leaf pre:Pl (1 in D, g(1) = 0, smallest |Pl| elements of D are Pl).
    (a) Unit lex rule: for a unit d in D, D_d = {rep(x/d) : x in D} is the orbit set of the multiplier image
        by 1/d (it contains 1).  Forbid every unit d in D whose D_d has its first |Pl| elements
        lexicographically smaller than Pl.  'D_d starts with Pl[:j] and its (j+1)-th element is < Pl[j]'
        is: d in D, rep(Pl[i] d) in D for 1 <= i < j, no y in D with rep(y/d) in a gap below Pl[j-1]
        (other than the Pl[i]), and some x in D with Pl[j-1] < rep(x/d) < Pl[j].
    (b) The multiplier -1 fixes every orbit and maps g to d - g(d) - 1 after re-translating g(1) = 0;
        with e = Pl[1] forbid g(e) = a whenever (e - 1 - a) mod n < a."""
    from math import gcd
    rep = lambda x: min(x % n, (-x) % n)
    out = []
    m = len(Pl)
    for d in range(2, H + 1):
        if gcd(d, n) != 1: continue
        di = pow(d, -1, n)
        q = lambda x: rep(x * di)      # position of orbit x inside D_d
        for j in range(1, m):
            base = [-P(d)] + [-P(rep(Pl[i] * d)) for i in range(1, j)]
            gaps = [y for y in range(1, H + 1) if q(y) < Pl[j - 1] and q(y) not in Pl[:j]]
            base += [P(y) for y in gaps]
            for x in range(1, H + 1):
                if Pl[j - 1] < q(x) < Pl[j]:
                    out.append(base + [-P(x)])
    if m >= 2:
        e = Pl[1]
        out += [[-X(e, a)] for a in range(n) if (e - 1 - a) % n < a]
    return out

if __name__ == '__main__':
    n, k, case, out = int(sys.argv[1]), int(sys.argv[2]), sys.argv[3], sys.argv[4]
    cl, xmap = build(n, k, case)
    CNF(from_clauses=cl).to_file(out, comments=[f'c CYCPAT cyclic orbit family n={n} k={k} case={case}'])
    if len(sys.argv) > 5:
        json.dump(xmap, open(sys.argv[5], 'w'))
