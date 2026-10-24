"""Describe supports D_a of a configuration (list of incidence vars)."""
import itertools
from model import unvar


def supports(sol, p):
    D = {a: set() for a in range(1, p)}
    for v in sol:
        a, x = unvar(v, p)
        D[a].add(x)
    return D


def is_ap(S, p):
    """S is a (cyclic) arithmetic progression in F_p, i.e. a dilate of an interval."""
    S = set(S)
    k = len(S)
    if k <= 2 or k >= p - 1:
        return True
    x0 = min(S)
    for d in range(1, p):
        # S is an AP with difference d iff exactly one element s has s - d not in S
        starts = [s for s in S if (s - d) % p not in S]
        if len(starts) == 1:
            return True
    return False


def coset_like(S, p):
    """S \\ {0} is a coset t H of a proper multiplicative subgroup H (|H| > 1)."""
    T = sorted(x for x in S if x)
    if len(T) < 2 or (p - 1) % len(T):
        return False
    t = T[0]
    ti = pow(t, p - 2, p)
    H = {x * ti % p for x in T}
    return all((h1 * h2) % p in H for h1 in H for h2 in H)


def three_aps(S, p):
    S = set(S)
    return sum(1 for x in S for d in range(1, (p + 1) // 2) if (x + d) % p in S and (x + 2 * d) % p in S)


def describe(sol, p):
    D = supports(sol, p)
    sizes = [len(D[a]) for a in range(1, p)]
    nap = sum(1 for a in D if is_ap(D[a], p) and 3 <= len(D[a]) <= p - 2)
    ncos = sum(1 for a in D if coset_like(D[a], p))
    # 3-AP count relative to a random set of the same size: k(k-1)/2 * (k-2)/(p-2) roughly
    rel = []
    for a in D:
        k = len(D[a])
        if k >= 3:
            exp = k * (k - 1) / 2 * (k - 2) / (p - 2)
            rel.append(three_aps(D[a], p) / exp)
    return dict(sizes=sizes, min=min(sizes), max=max(sizes), mean=sum(sizes) / len(sizes),
                n_nontrivial_AP=nap, n_coset=ncos,
                ap3_ratio_vs_random=round(sum(rel) / len(rel), 3) if rel else None,
                contains0=sum(1 for a in D if 0 in D[a]))
