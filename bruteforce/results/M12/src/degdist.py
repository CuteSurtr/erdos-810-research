#!/usr/bin/env python3
"""Max-degree distribution (and degree sequences) of graph6 files given on argv."""
import sys
from collections import Counter

def degs(s):
    n = ord(s[0]) - 63
    bits = []
    for ch in s[1:]:
        v = ord(ch) - 63
        bits.extend((v >> (5 - i)) & 1 for i in range(6))
    d = [0] * n
    k = 0
    for j in range(1, n):
        for i in range(j):
            if bits[k]:
                d[i] += 1; d[j] += 1
            k += 1
    return d

maxd = Counter(); seqs = Counter(); tot = 0
for f in sys.argv[1:]:
    for line in open(f):
        line = line.strip()
        if not line:
            continue
        d = degs(line)
        tot += 1
        maxd[max(d)] += 1
        seqs[tuple(sorted(d, reverse=True))] += 1
print("graphs", tot)
for k in sorted(maxd):
    print("maxdeg", k, maxd[k])
for s, c in seqs.most_common(15):
    print("degseq", "".join(map(lambda x: format(x, 'x'), s)), c)
