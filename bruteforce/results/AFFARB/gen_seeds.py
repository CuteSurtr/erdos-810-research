"""Seed intercept functions: Sidon/exponential-type and AP-free-structured beta."""
import sys
def prim(p):
    for g in range(2, p):
        if all(pow(g, (p-1)//q, p) != 1 for q in range(2, p) if (p-1) % q == 0 and all(q % r for r in range(2, q))):
            return g
for p in map(int, sys.argv[1:]):
    g = prim(p); log = {pow(g, i, p): i for i in range(p-1)}
    # exponential: beta(a) = g^a ; discrete log: beta(a) = log_g(a) (graph of a Sidon-type map)
    seeds = {"exp": [pow(g, a, p) for a in range(1, p)], "dlog": [log[a] % p for a in range(1, p)]}
    # AP-free: greedy 3AP-free subset A of Z_{p-1} (in log coordinates); beta = 0 on g^A, a^2 elsewhere
    A = []
    for i in range(p-1):
        if all((2*j - i) % (p-1) not in A and (i + j) % 2 or ((i + j)//2) not in A for j in A) and \
           all((2*j - i) % (p-1) not in A for j in A) and all((2*i - j) % (p-1) not in A for j in A):
            A.append(i)
    S = {pow(g, i, p) for i in A}
    seeds["apfree"] = [0 if a in S else a*a % p for a in range(1, p)]
    for k, v in seeds.items():
        open(f"seeds/{k}_{p}.txt", "w").write(" ".join(map(str, v)) + "\n")
