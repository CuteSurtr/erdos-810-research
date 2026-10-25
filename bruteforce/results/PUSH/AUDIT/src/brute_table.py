"""Build the brute-force table of AUDIT.md §2.5 from logs/cycbrute_*.log and logs/cycgroup.log."""
import re, glob
rows = {}
for f in glob.glob('../logs/cycbrute_*.log'):
    s = open(f).read()
    m = re.search(r'n=(\d+) k=(\d+) solutions_with_g\(minD\)=0: (\d+)', s); w = re.search(r'wall (\d+) s', s)
    if m: rows[(int(m[1]), int(m[2]))] = (int(m[3]), w[1] if w else '')
orb = {}
for l in open('../logs/cycgroup.log'):
    m = re.match(r'n=(\d+): (\d+) solutions.*?, (\d+) orbits', l)
    if m: orb[int(m[1])] = int(m[3])
out = ["| n | k_max: solutions with g(min D)=0 | orbits under G (own code) | k_max+1: solutions | wall s (k_max / k_max+1) |",
       "|---|---|---|---|---|"]
for n in range(12, 40):
    ks = sorted(k for (nn, k) in rows if nn == n)
    if not ks: continue
    sat = [k for k in ks if rows[(n, k)][0] > 0]; uns = [k for k in ks if rows[(n, k)][0] == 0]
    km = max(sat) if sat else None
    a = f"k={km}: {rows[(n, km)][0]}" if km else "not run (certificate at k_max exists)"
    b = f"k={min(uns)}: {rows[(n, min(uns))][0]}" if uns else "not finished"
    out.append(f"| {n} | {a} | {orb.get(n, '—')} | {b} | {rows[(n, km)][1] if km else '—'} / {rows[(n, min(uns))][1] if uns else '—'} |")
t = "\n".join(out)
s = open('../AUDIT.md').read()
s = re.sub(r"\| n \| k(?: = k)?_max: solutions.*?\n(?=\nThe k_max\+1 column)", t + "\n", s, flags=re.S)
open('../AUDIT.md', 'w').write(s)
print(t)
