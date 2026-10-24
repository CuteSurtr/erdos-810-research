#!/usr/bin/env python3
"""cert2g6.py N "[(u,v,c),...]" -> graph6 of the underlying graph"""
import sys, ast
n = int(sys.argv[1]); E = {frozenset((u, v)) for (u, v, c) in ast.literal_eval(sys.argv[2])}
bits = [1 if frozenset((i, j)) in E else 0 for j in range(1, n) for i in range(j)]
bits += [0] * (-len(bits) % 6)
print(chr(n + 63) + "".join(chr(63 + int("".join(map(str, bits[k:k + 6])), 2)) for k in range(0, len(bits), 6)))
