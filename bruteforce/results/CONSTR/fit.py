#!/usr/bin/env python3
"""Fit growth models to best lower bounds (log-space least squares) and report RSS / AIC.
Data: n = 13..25 from data/results-2026-10-14.json (plus our improvements) and trend.tsv.
Models (all fitted as linear regressions of log LB):
  A: c n^2                       log LB - 2 log n = log c
  B: c n^2 / log n               log LB - 2 log n + log log n = log c
  C: c n^(2-delta)               log LB = log c + (2-delta) log n
  D: c n^2 exp(-a sqrt(log n))   log LB - 2 log n = log c - a sqrt(log n)
usage: fit.py [nmin]   writes fits.txt"""
import json, math, os, sys
os.chdir(os.path.dirname(os.path.abspath(__file__)))
nmin = int(sys.argv[1]) if len(sys.argv) > 1 else 13
nmax = int(sys.argv[2]) if len(sys.argv) > 2 else 10**9
data = {}
old = json.load(open('../../data/results-2026-10-14.json'))['lower_bounds']
for k, v in old.items():
    if int(k) >= 13: data[int(k)] = v['lower_bound']
if os.path.exists('small_best_counts.json'):   # best verified of (this task, LB task @d6dc4e1), n=13..25
    for k, v in json.load(open('small_best_counts.json')).items(): data[int(k)] = max(data.get(int(k), 0), v)
for l in open('trend.tsv').readlines()[1:]:
    f = l.split('\t'); data[int(f[0])] = max(data.get(int(f[0]), 0), int(f[1]))
pts = sorted((n, e) for n, e in data.items() if nmin <= n <= nmax)

def linfit(xs, ys):
    """least squares y = a + b x (xs None -> constant)"""
    m = len(ys)
    if xs is None:
        a = sum(ys) / m; return (a,), sum((y - a) ** 2 for y in ys)
    mx, my = sum(xs) / m, sum(ys) / m
    b = sum((x - mx) * (y - my) for x, y in zip(xs, ys)) / sum((x - mx) ** 2 for x in xs)
    a = my - b * mx
    return (a, b), sum((y - a - b * x) ** 2 for x, y in zip(xs, ys))

L = [math.log(n) for n, _ in pts]; Y = [math.log(e) for _, e in pts]; m = len(pts)
out = []
def rep(name, k, params, rss, pred):
    aic = m * math.log(rss / m) + 2 * k
    ext = ', '.join('n=%d: %.4g n^2' % (N, pred(N) / N / N) for N in (100, 10 ** 3, 10 ** 6))
    out.append('%-32s k=%d RSS=%.5f AIC=%.2f params=%s\n    extrapolated LB/n^2 -> %s' % (name, k, rss, aic, params, ext))
(a,), r = linfit(None, [y - 2 * l for y, l in zip(Y, L)])
rep('A: c n^2', 1, 'c=%.4f' % math.exp(a), r, lambda N: math.exp(a) * N * N)
(a,), r = linfit(None, [y - 2 * l + math.log(l) for y, l in zip(Y, L)])
rep('B: c n^2/log n', 1, 'c=%.4f' % math.exp(a), r, lambda N: math.exp(a) * N * N / math.log(N))
(a, b), r = linfit(L, Y)
rep('C: c n^(2-delta)', 2, 'c=%.4f delta=%.4f' % (math.exp(a), 2 - b), r, lambda N: math.exp(a) * N ** b)
(a, b), r = linfit([math.sqrt(l) for l in L], [y - 2 * l for y, l in zip(Y, L)])
rep('D: c n^2 exp(-a sqrt(log n))', 2, 'c=%.4f a=%.4f' % (math.exp(a), -b), r,
    lambda N: math.exp(a) * N * N * math.exp(b * math.sqrt(math.log(N))))
# also a free c n^2 + d n^1.5 model, linear in (c,d) on LB/n^2 = c + d n^-1/2
xs = [n ** -0.5 for n, _ in pts]; ys = [e / n / n for n, e in pts]
(a, b), r = linfit(xs, ys)
out.append('%-32s (fit on LB/n^2) c=%.4f d=%.4f RSS(ratio)=%.6f' % ("E: c n^2 + d n^1.5", a, b, r))
txt = 'points: %d (n=%d..%d)\n' % (m, pts[0][0], pts[-1][0]) + '\n'.join(out) + '\n'
open('fits_n%d-%d.txt' % (nmin, min(nmax, pts[-1][0])), 'w').write(txt); print(txt)
