#!/usr/bin/env python3
"""Reorder queue.txt: locked (taken) lines first, unchanged; then the untaken pre: lines of n=44 by
(-e, prefix), so a started subtree (larger e first, then larger f: the easy subtrees close first) is finished before the next one opens."""
import os
L = [l for l in open('queue.txt') if l.strip()]
taken = lambda l: os.path.isdir('locks/n%s_%s' % (l.split()[0], l.split()[2].replace(':', '_')))
a = [l for l in L if taken(l)]; b = [l for l in L if not taken(l)]
def key(l):
    c = l.split()[2]
    if not c.startswith('pre:'): return (0, [])
    P = [int(t) for t in c[4:].split('.')]
    return (-P[1], -P[2] if len(P) > 2 else 0, P)
seen = set(); bb = []
for l in sorted(b, key=key):
    if l not in seen: seen.add(l); bb.append(l)
open('queue.tmp', 'w').write(''.join(a + bb)); os.replace('queue.tmp', 'queue.txt')
print(len(a), 'taken;', len(bb), 'untaken; next:', [l.split()[2] for l in bb[:5]])
