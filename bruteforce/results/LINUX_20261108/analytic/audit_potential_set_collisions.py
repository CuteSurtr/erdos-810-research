#!/usr/bin/env python3
"""Exact integer-polynomial certificates and independent small-field cycle checks."""
import collections
import datetime
import hashlib
import itertools
import json
import math
import pathlib
import time


def add(a, b, sign=1):
    out = dict(a)
    for monomial, coefficient in b.items():
        out[monomial] = out.get(monomial, 0) + sign * coefficient
    return {m: c for m, c in out.items() if c}


def sub(a, b):
    return add(a, b, -1)


def mul(a, b):
    out = {}
    for (i, j), x in a.items():
        for (k, ell), y in b.items():
            m = (i + k, j + ell)
            out[m] = out.get(m, 0) + x * y
    return {m: c for m, c in out.items() if c}


def polynomial_relation(t):
    h, k, u, v = t
    return sub(
        mul(mul(k, sub(mul(k, k), mul(u, h))), mul(v, sub(v, h))),
        mul(mul(h, sub(mul(h, h), mul(v, k))), mul(u, sub(u, k))),
    )


def relation(t):
    h, k, u, v = t
    return k * (k*k-u*h) * v * (v-h) - h * (h*h-v*k) * u * (u-k)


def numerator_tuple(q, r):
    h = r * (q*q-q+r-1)
    k = q * (r*r-r+q-1)
    return h, k, q*k, r*h


def evaluate(poly, q, r):
    return sum(c * q**i * r**j for (i, j), c in poly.items())


PERMUTATIONS = list(itertools.permutations(range(4)))
SYMMETRIES = {(0, 1, 2, 3), (1, 0, 3, 2)}


def polynomial_certificates():
    one, q, r = {(0, 0): 1}, {(1, 0): 1}, {(0, 1): 1}
    h = mul(r, sub(add(sub(mul(q, q), q), r), one))
    k = mul(q, sub(add(sub(mul(r, r), r), q), one))
    t = h, k, mul(q, k), mul(r, h)
    rows = []
    polynomials = {}
    for sigma in PERMUTATIONS:
        name = ''.join('hkuv'[i] for i in sigma)
        poly = polynomial_relation(tuple(t[i] for i in sigma))
        polynomials[sigma] = poly
        assert bool(poly) == (sigma not in SYMMETRIES)
        unit = None
        if poly:
            degree = max(sum(m) for m in poly)
            assert degree <= 20
            content = math.gcd(*poly.values())
            assert content == 1
            # A displayed coefficient +/-1 certifies nonvanishing in EVERY field.
            units = [(i, j, c) for (i, j), c in poly.items() if abs(c) == 1]
            assert units
            unit = max(units)
        else:
            degree, content = -1, 0
        for q0, r0 in [(0, 0), (1, 1), (2, 4), (-2, 3), (5, 7)]:
            vals = numerator_tuple(q0, r0)
            assert evaluate(poly, q0, r0) == relation(tuple(vals[i] for i in sigma))
        rows.append({
            'slots': name, 'permutation': sigma, 'zero_polynomial': not poly,
            'total_degree': degree, 'content': content, 'unit_coefficient': unit,
            'evaluation_at_2_4': evaluate(poly, 2, 4),
            'coefficients_q_i_r_j': [[i, j, c] for (i, j), c in sorted(poly.items())],
        })
    # Reversing both repeated/opposite pairs changes the sign of F.
    for sigma, poly in polynomials.items():
        reverse = sigma[1], sigma[0], sigma[3], sigma[2]
        assert add(poly, polynomials[reverse]) == {}
    return rows


def finite_audit(p):
    # Build actual edges from the potential model, then enumerate rectangles
    # through common neighbors; this does not enumerate algebraic ratio solutions.
    A = {a*a % p for a in range(1, p)}
    J = {h for h in range(1, p) if (h in A) != (p-1 in A)}
    edges = {}
    for a in A:
        inva = pow(a, -1, p)
        for h in J:
            e = ((h*inva*inva-a) % p, h*inva % p)
            assert e not in edges
            edges[e] = a
    rows = [set() for _ in range(p)]
    for x, y in edges:
        rows[x].add(y)
    groups = collections.defaultdict(list)
    n3 = degenerate = n2 = 0
    for x, z in itertools.combinations(range(p), 2):
        for y0, w0 in itertools.combinations(sorted(rows[x] & rows[z]), 2):
            colors = [edges[x, y0], edges[x, w0], edges[z, y0], edges[z, w0]]
            distinct = len(set(colors))
            if distinct == 2:
                n2 += 1
            if distinct != 3:
                continue
            n3 += 1
            y, w = (y0, w0) if colors[0] == colors[3] else (w0, y0)
            a, b, c = edges[x, y], edges[x, w], edges[z, y]
            assert edges[z, w] == a and len({a, b, c}) == 3
            h, k, u, v = (a*y % p, a*w % p, b*w % p, c*y % p)
            if len({h, k, u, v}) != 4:
                assert len({h, k, u, v}) == 3
                degenerate += 1
                continue
            q, r = b*pow(a, -1, p) % p, c*pow(a, -1, p) % p
            assert q*r % p != 1
            scale = pow(a, 3, p) * pow(1-q*r, -1, p) % p
            assert tuple(scale*t % p for t in numerator_tuple(q, r)) == (h, k, u, v)
            zero_perms = {s for s in PERMUTATIONS
                          if relation(tuple((h, k, u, v)[i] for i in s)) % p == 0}
            assert SYMMETRIES <= zero_perms
            generic = zero_perms == SYMMETRIES
            key = tuple(sorted([(x, y), (x, w), (z, y), (z, w)]))
            groups[tuple(sorted((h, k, u, v)))].append((key, a, generic))
    g = math.gcd(3, p-1)
    roots = [w for w in range(1, p) if pow(w, 3, p) == 1]
    assert len(roots) == g and all(w in A for w in roots)
    bad_cycles = generic_sets = 0
    for potential_set, records in groups.items():
        assert len(records) % g == 0
        generic_flags = {record[2] for record in records}
        assert len(generic_flags) == 1
        if True in generic_flags:
            assert len(records) == g
            generic_sets += 1
        else:
            bad_cycles += len(records)
        actual = {(key, a) for key, a, _ in records}
        for key, a, _ in records:
            images = set()
            for w in roots:
                transformed = tuple(sorted((w*x % p, w*w*y % p) for x, y in key))
                image = transformed, w*a % p
                assert image in actual
                images.add(image)
            assert len(images) == g
    n4 = sum(map(len, groups.values()))
    assert n4 + degenerate == n3
    gap = n4//g - len(groups)
    assert 0 <= gap <= bad_cycles//g
    assert bad_cycles <= 220*p*p
    # Cross-check saved C enumeration where available; do not modify those data.
    data = pathlib.Path(__file__).with_name('potential-quadruple-counts.jsonl')
    c_match = False
    for line in data.read_text().splitlines():
        row = json.loads(line)
        if row['p'] == p:
            assert (row['n3'], row['four_potential_cycles'], row['distinct_quadruples'], row['n2']) == (n3, n4, len(groups), n2)
            c_match = True
    return {'p': p, 'cube_root_group_size': g, 'n3': n3,
            'four_potential_cycles': n4, 'distinct_sets': len(groups),
            'generic_sets': generic_sets, 'nongeneric_cycles': bad_cycles,
            'orbit_count_minus_set_count': gap, 'n2': n2,
            'multiplicity_histogram': dict(sorted(collections.Counter(map(len, groups.values())).items())),
            'matched_previous_c_enumeration': c_match}


def main():
    start = time.monotonic()
    path = pathlib.Path(__file__).resolve()
    certificates = polynomial_certificates()
    field_checks = [finite_audit(p) for p in [13, 23, 31, 61, 101]]
    result = {
        'utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
        'scope': 'exact integer-polynomial certificate; finite checks do not replace the written counting proof',
        'script_sha256': hashlib.sha256(path.read_bytes()).hexdigest(),
        'polynomial_certificates': certificates, 'finite_field_checks': field_checks,
        'seconds': round(time.monotonic()-start, 3),
    }
    path.with_name('potential-set-collision-audit.json').write_text(json.dumps(result, indent=2)+'\n')
    table = [{k: row[k] for k in ['slots', 'total_degree', 'unit_coefficient']}
             for row in certificates if not row['zero_polynomial']]
    print(json.dumps({'certificate_summary': table, 'finite_checks': field_checks,
                      'seconds': result['seconds']}))


if __name__ == '__main__':
    main()
