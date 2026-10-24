"""Fit the decay of m/p^2 (best found) for each beta, over p >= 11.
Models: power law  m/p^2 = C p^-g ;  log model m/p^2 = A - B ln p."""
import math, csv
rows = list(csv.DictReader(open('table.tsv'), delimiter='\t'))
out = []
for beta in ['a2', 'a3', 'inv', 'zero']:
    R = [(int(r['p']), float(r['m/p^2'])) for r in rows if r['beta'] == beta and int(r['p']) >= 11]
    if len(R) < 3:
        continue
    X = [math.log(p) for p, _ in R]
    Y = [math.log(d) for _, d in R]
    n = len(R); mx = sum(X) / n; my = sum(Y) / n
    sxx = sum((x - mx) ** 2 for x in X)
    g = -sum((x - mx) * (y - my) for x, y in zip(X, Y)) / sxx
    C = math.exp(my + g * mx)
    D = [d for _, d in R]; md = sum(D) / n
    B = -sum((x - mx) * (d - md) for x, d in zip(X, D)) / sxx
    A = md + B * mx
    res_pow = max(abs(C * p ** -g - d) for p, d in R)
    res_log = max(abs(A - B * math.log(p) - d) for p, d in R)
    out.append('%s: m/p^2 ~ %.3f p^-%.3f (max resid %.4f);  ~ %.3f - %.4f ln p (max resid %.4f); p range %d..%d'
               % (beta, C, g, res_pow, A, B, res_log, R[0][0], R[-1][0]))
print('\n'.join(out))
open('fit.txt', 'w').write('\n'.join(out) + '\n')
