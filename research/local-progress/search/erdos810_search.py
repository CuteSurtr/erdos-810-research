#!/usr/bin/env python3
"""
Brute-force and SAT verification for Erdős Problem #810.

Computes and verifies:
1. Explicit rainbow-C4 n-edge-coloring lower-bound certificates for 1 <= n <= 12.
2. Exhaustive stabilizer-reduced upper-bound verification proving M(n) for 4 <= n <= 9:
   M(1)=0, M(2)=1, M(3)=3, M(4)=5, M(5)=7, M(6)=11, M(7)=14, M(8)=17, M(9)=23,
   plus M(10) >= 30, M(11) >= 34, M(12) >= 40.
"""
import argparse
import itertools
import time

CERTIFICATES = {
    1: [],
    2: [((0, 1), 0)],
    3: [((0, 1), 0), ((0, 2), 0), ((1, 2), 0)],
    4: [((0, 1), 0), ((0, 2), 0), ((0, 3), 1), ((1, 2), 2), ((1, 3), 3)],
    5: [((0, 1), 4), ((0, 2), 3), ((0, 3), 2), ((0, 4), 0), ((1, 2), 1), ((1, 4), 4), ((2, 3), 0)],
    6: [((0, 1), 2), ((0, 2), 0), ((0, 3), 1), ((0, 5), 4), ((1, 2), 3), ((1, 3), 5),
        ((1, 4), 3), ((1, 5), 2), ((2, 3), 4), ((2, 4), 1), ((4, 5), 5)],
    7: [((0, 1), 6), ((0, 2), 0), ((0, 3), 6), ((0, 4), 1), ((0, 6), 4), ((1, 3), 0),
        ((1, 5), 3), ((1, 6), 5), ((2, 4), 5), ((2, 5), 1), ((2, 6), 2), ((3, 4), 2),
        ((4, 6), 3), ((5, 6), 2)],
    8: [((0, 1), 2), ((0, 2), 6), ((0, 3), 0), ((0, 4), 7), ((0, 5), 6), ((0, 6), 2),
        ((1, 4), 3), ((1, 5), 0), ((1, 6), 1), ((2, 3), 1), ((2, 5), 3), ((2, 6), 4),
        ((3, 4), 4), ((3, 6), 5), ((4, 5), 5), ((5, 7), 7), ((6, 7), 5)],
    9: [((0, 1), 0), ((0, 2), 6), ((0, 4), 7), ((0, 5), 5), ((0, 6), 2), ((0, 8), 0),
        ((1, 3), 1), ((1, 4), 8), ((1, 6), 6), ((1, 8), 3), ((2, 4), 1), ((2, 5), 2),
        ((2, 7), 3), ((2, 8), 4), ((3, 4), 4), ((3, 5), 6), ((3, 6), 3), ((3, 7), 0),
        ((4, 6), 5), ((5, 7), 1), ((5, 8), 8), ((6, 7), 8), ((7, 8), 7)],
    10: [((0, 3), 9), ((0, 4), 3), ((0, 5), 0), ((0, 6), 5), ((0, 7), 2), ((0, 9), 1),
         ((1, 2), 1), ((1, 3), 5), ((1, 5), 3), ((1, 7), 8), ((1, 8), 2), ((1, 9), 6),
         ((2, 5), 7), ((2, 6), 3), ((2, 7), 4), ((2, 8), 5), ((2, 9), 9), ((3, 4), 7),
         ((3, 5), 2), ((3, 6), 4), ((3, 9), 8), ((4, 5), 6), ((4, 6), 8), ((4, 7), 1),
         ((4, 8), 9), ((5, 9), 4), ((6, 7), 0), ((6, 8), 6), ((7, 8), 7), ((8, 9), 0)],
    11: [((0, 1), 2), ((0, 2), 10), ((0, 4), 6), ((0, 5), 8), ((0, 7), 5), ((0, 9), 0),
         ((1, 3), 9), ((1, 4), 4), ((1, 6), 3), ((1, 9), 5), ((1, 10), 10), ((2, 4), 1),
         ((2, 5), 2), ((2, 6), 8), ((2, 7), 10), ((2, 8), 0), ((2, 9), 9), ((3, 5), 1),
         ((3, 7), 7), ((3, 8), 8), ((3, 9), 3), ((3, 10), 0), ((4, 5), 3), ((4, 6), 9),
         ((4, 8), 7), ((5, 8), 4), ((5, 9), 7), ((6, 7), 4), ((6, 8), 6), ((6, 10), 2),
         ((7, 8), 3), ((7, 10), 1), ((8, 10), 5), ((9, 10), 6)],
    12: [((0, 1), 0), ((0, 3), 4), ((0, 5), 1), ((0, 6), 3), ((0, 9), 8), ((0, 10), 11),
         ((1, 2), 10), ((1, 3), 9), ((1, 4), 8), ((1, 6), 6), ((1, 8), 2), ((1, 9), 7),
         ((2, 4), 3), ((2, 6), 4), ((2, 7), 8), ((2, 9), 1), ((2, 11), 6), ((3, 4), 7),
         ((3, 6), 5), ((3, 7), 6), ((3, 8), 3), ((4, 5), 5), ((4, 6), 11), ((4, 8), 0),
         ((4, 11), 9), ((5, 7), 10), ((5, 9), 4), ((5, 10), 6), ((5, 11), 2), ((6, 9), 2),
         ((6, 10), 10), ((7, 8), 1), ((7, 9), 3), ((7, 10), 9), ((7, 11), 11), ((8, 10), 8),
         ((8, 11), 4), ((9, 10), 5), ((9, 11), 0), ((10, 11), 7)]
}

def verify_certificate(n, cert):
    edge_color = {}
    for (u, v), c in cert:
        assert 0 <= u < v < n and 0 <= c < n and (u, v) not in edge_color
        edge_color[(u, v)] = c
    c4_count = 0
    for a in range(n):
        for b in range(a + 1, n):
            for c in range(a + 1, n):
                if c == b:
                    continue
                for d in range(b + 1, n):
                    if d == c:
                        continue
                    e1, e2 = (min(a, b), max(a, b)), (min(b, c), max(b, c))
                    e3, e4 = (min(c, d), max(c, d)), (min(d, a), max(d, a))
                    if e1 in edge_color and e2 in edge_color and e3 in edge_color and e4 in edge_color:
                        c4_count += 1
                        cols = [edge_color[e1], edge_color[e2], edge_color[e3], edge_color[e4]]
                        assert len(set(cols)) == 4
    return len(cert), c4_count

def verify_upper_bound(n, m_edges):
    t0 = time.time()
    pairs = [(u, v) for u in range(n) for v in range(u + 1, n)]
    E = len(pairs)
    pair_idx = {p: i for i, p in enumerate(pairs)}
    c4s = []
    for a in range(n):
        for b in range(a + 1, n):
            for c in range(a + 1, n):
                if c == b:
                    continue
                for d in range(b + 1, n):
                    if d == c:
                        continue
                    e1, e2 = pair_idx[(min(a, b), max(a, b))], pair_idx[(min(b, c), max(b, c))]
                    e3, e4 = pair_idx[(min(c, d), max(c, d))], pair_idx[(min(d, a), max(d, a))]
                    c4s.append(((1 << e1) | (1 << e2) | (1 << e3) | (1 << e4), (e1, e2, e3, e4)))

    results = []
    for d0 in range((2 * m_edges + n - 1) // n, n):
        if d0 > m_edges:
            break
        base_mask = sum(1 << pair_idx[(0, v)] for v in range(1, d0 + 1))
        for k1_in in range(d0):
            for k1_out in range(n - d0):
                d1 = 1 + k1_in + k1_out
                if d1 > d0:
                    continue
                m1 = base_mask
                deg = [0] * n
                deg[0] = d0
                for v in range(1, d0 + 1):
                    deg[v] = 1
                deg[1] = d1
                for v in range(2, 2 + k1_in):
                    m1 |= (1 << pair_idx[(1, v)])
                    deg[v] += 1
                for v in range(d0 + 1, d0 + 1 + k1_out):
                    m1 |= (1 << pair_idx[(1, v)])
                    deg[v] += 1
                rem1 = m_edges - d0 - (d1 - 1)
                if rem1 < 0:
                    continue
                block_starts = {2, 2 + k1_in, d0 + 1, d0 + 1 + k1_out}

                def gen_v(u, rem_edges, cur_mask):
                    if u == n - 1:
                        if rem_edges == 0 and (u in block_starts or deg[u] <= deg[u - 1]):
                            results.append(cur_mask)
                        return
                    max_u_cap = d1 if u <= d0 else d0
                    max_du = max_u_cap if u in block_starts else deg[u - 1]
                    rem_pairs = (n - 1 - u) * (n - 2 - u) // 2
                    min_k = max(0, rem_edges - rem_pairs)
                    max_k = min(n - 1 - u, rem_edges, max_du - deg[u])
                    if min_k > max_k:
                        return
                    cands = [v for v in range(u + 1, n) if deg[v] < (d1 if v <= d0 else d0)]
                    for k in range(min_k, min(max_k, len(cands)) + 1):
                        du = deg[u] + k
                        for chosen in itertools.combinations(cands, k):
                            m2 = cur_mask
                            for v in chosen:
                                deg[v] += 1
                                m2 |= (1 << pair_idx[(u, v)])
                            deg[u] = du
                            gen_v(u + 1, rem_edges - k, m2)
                            for v in chosen:
                                deg[v] -= 1
                            deg[u] -= k

                gen_v(2, rem1, m1)

    clique_obs = alpha_obs = dsatur_obs = 0
    for gmask in results:
        sub = [e for e in range(E) if (gmask >> e) & 1]
        e_to_i = {e: i for i, e in enumerate(sub)}
        cadj = [0] * m_edges
        for cmask, (e1, e2, e3, e4) in c4s:
            if (gmask & cmask) == cmask:
                i1, i2, i3, i4 = e_to_i[e1], e_to_i[e2], e_to_i[e3], e_to_i[e4]
                m4 = (1 << i1) | (1 << i2) | (1 << i3) | (1 << i4)
                for idx in (i1, i2, i3, i4):
                    cadj[idx] |= m4 ^ (1 << idx)

        def has_clique(idx, cur, sz):
            if sz == n + 1:
                return True
            if m_edges - idx < (n + 1) - sz:
                return False
            for i in range(idx, m_edges):
                if (cur & cadj[i]) == cur and has_clique(i + 1, cur | (1 << i), sz + 1):
                    return True
            return False

        if has_clique(0, 0, 0):
            clique_obs += 1
            continue

        if m_edges > 2 * n:
            has_ind3 = any(
                not ((cadj[i] >> j) & 1) and not (((cadj[i] | cadj[j]) >> k) & 1)
                for i in range(m_edges)
                for j in range(i + 1, m_edges)
                for k in range(j + 1, m_edges)
            )
            if not has_ind3:
                alpha_obs += 1
                continue

        colors = [-1] * m_edges
        sat_mask = [0] * m_edges
        deg_c = [bin(a).count("1") for a in cadj]

        def can_col(colored, max_c):
            if colored == m_edges:
                return True
            v = max(
                (u for u in range(m_edges) if colors[u] == -1),
                key=lambda u: (bin(sat_mask[u]).count("1"), deg_c[u]),
            )
            forb = sat_mask[v]
            for c in range(min(n, max_c + 2)):
                if not ((forb >> c) & 1):
                    colors[v] = c
                    changed = []
                    nb = cadj[v]
                    while nb:
                        lsb = nb & -nb
                        u = lsb.bit_length() - 1
                        nb ^= lsb
                        if colors[u] == -1 and not ((sat_mask[u] >> c) & 1):
                            sat_mask[u] |= (1 << c)
                            changed.append(u)
                    if can_col(colored + 1, max(max_c, c)):
                        return True
                    for u in changed:
                        sat_mask[u] &= ~(1 << c)
                    colors[v] = -1
            return False

        assert not can_col(0, -1)
        dsatur_obs += 1

    return len(results), clique_obs, alpha_obs, dsatur_obs, time.time() - t0

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--max-n", type=int, default=8, help="Max n for exhaustive upper bound (4..9)")
    args = parser.parse_args()
    for n, cert in sorted(CERTIFICATES.items()):
        edges, c4s = verify_certificate(n, cert)
        print(f"[CERT] n={n:2d}: verified {edges:2d} edges, {c4s:2d} rainbow C4s")
    targets = [(4, 6), (5, 8), (6, 12), (7, 15), (8, 18), (9, 24)]
    for n, m_plus_1 in targets:
        if n <= args.max_n:
            tot, clq, alp, dsat, dt = verify_upper_bound(n, m_plus_1)
            print(f"[UNSAT] n={n}, m+1={m_plus_1}: checked {tot} graphs "
                  f"(K_{n+1}={clq}, alpha<=2={alp}, dsatur={dsat}) in {dt:.2f}s")

if __name__ == "__main__":
    main()
