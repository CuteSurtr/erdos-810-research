"""Exact algebra checks, not graph enumeration and not a Lean proof.

Run with Python's standard library. Checks the polynomial identity used in
profile-density-bound.txt and rigorous rational root brackets.
"""
from collections import defaultdict
from fractions import Fraction as F
import json
from math import comb
from pathlib import Path


def add(*polynomials):
    out = defaultdict(int)
    for polynomial in polynomials:
        for monomial, coefficient in polynomial.items():
            out[monomial] += coefficient
    return {k: v for k, v in out.items() if v}


def mul(a, b):
    out = defaultdict(int)
    for (i, j), x in a.items():
        for (k, ell), y in b.items():
            out[i + k, j + ell] += x * y
    return {k: v for k, v in out.items() if v}


def scale(a, scalar):
    return {k: v * scalar for k, v in a.items() if v * scalar}


one, c, s = {(0, 0): 1}, {(1, 0): 1}, {(0, 1): 1}
s2 = mul(s, s)
u = add(one, mul(c, s))
v = add(scale(one, 2), mul(add(c, one), s))
w = add(scale(one, 2), mul(c, s))
dn = add(scale(one, 4), mul(add(scale(c, 4), one), s),
         mul(add(c, one), s2))
bn = add(scale(one, 4), mul(add(scale(c, 4), scale(one, -1)), s),
         mul(add(one, scale(c, -1)), s2))
kn = {(3, 0): 19, (2, 0): 75, (1, 0): 93, (0, 0): 36}
kd = {(3, 0): 9, (2, 0): 51, (1, 0): 88, (0, 0): 48}
left = add(mul(add(kd, mul(kn, s)), mul(mul(bn, bn), v)),
           scale(mul(kd, add(mul(mul(dn, dn), w),
                             mul(s2, mul(bn, mul(u, v))))), -1))
q_coefficients = [
    [384, 1568, 1584, 464],
    [-384, 736, 3984, 3872, 1088],
    [-72, -438, 771, 3345, 2964, 784],
    [-36, -9, 34, 341, 822, 648, 160],
    [-36, -9, 142, 116, -78, -107, -28],
]
q = {(i, j): a for j, row in enumerate(q_coefficients)
     for i, a in enumerate(row) if a}
right = mul(mul(s, add(one, scale(s, -1))), q)
assert left == right, "Profile polynomial identity failed"

# An additional exact positivity certificate: expand each required polynomial
# at C=1+t. All its coefficients are positive, hence so is it for C>=1.
positive_polynomials = q_coefficients[:4] + [
    [x+y for x, y in zip(q_coefficients[3], q_coefficients[4])]
]
shifted_positive_coefficients = []
for polynomial in positive_polynomials:
    shifted = [sum(polynomial[i]*comb(i, j)
                   for i in range(j, len(polynomial)))
               for j in range(len(polynomial))]
    assert all(coefficient > 0 for coefficient in shifted)
    shifted_positive_coefficients.append(shifted)


def fixed_polynomial(x):
    return 9*x**4 + 32*x**3 + 13*x*x - 45*x - 36


def density_polynomial(r, C):
    # Positive (1+C) times the cubic in the theorem.
    return 4*(C+2)*r**3 - 2*(C+2)*r*r - 3*(C+1)*r + C+1


C_lo = F("1.18541655912282415")
C_hi = F("1.18541655912282417")
r_lo = F("0.29844403750999554")
r_hi = F("0.29844403750999556")
checks = {
    "C_lower_polynomial": fixed_polynomial(C_lo),
    "C_upper_polynomial": fixed_polynomial(C_hi),
    # The normalized cubic decreases as alpha increases, i.e. as C decreases.
    # Hence these are the conservative endpoint signs over the C interval.
    "rho_lower_conservative_polynomial": density_polynomial(r_lo, C_lo),
    "rho_upper_conservative_polynomial": density_polynomial(r_hi, C_hi),
}
assert checks["C_lower_polynomial"] < 0
assert checks["C_upper_polynomial"] > 0
assert checks["rho_lower_conservative_polynomial"] > 0
assert checks["rho_upper_conservative_polynomial"] < 0

report = {
    "status": "PASS",
    "scope": "Exact polynomial identity and rational root brackets only",
    "C_interval": [str(C_lo), str(C_hi)],
    "rho_interval": [str(r_lo), str(r_hi)],
    "decimal_C_interval": ["1.18541655912282415", "1.18541655912282417"],
    "decimal_rho_interval": ["0.29844403750999554", "0.29844403750999556"],
    "exact_sign_certificates": {
        key: {"numerator": value.numerator, "denominator": value.denominator}
        for key, value in checks.items()
    },
    "q_coefficients_in_ascending_C_powers": q_coefficients,
    "positive_coefficients_after_C_equals_1_plus_t": shifted_positive_coefficients,
}
output = Path(__file__).with_name("profile-polynomial-certificate.json")
output.write_text(json.dumps(report, indent=2) + "\n")
print(json.dumps({k: v for k, v in report.items()
                  if k not in {"exact_sign_certificates", "q_coefficients_in_ascending_C_powers",
                               "positive_coefficients_after_C_equals_1_plus_t"}},
                 indent=2))
