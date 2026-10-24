"""Isomorphism between the beta = 1/a and beta = a^2 families (rows <-> columns):
the map (x, y) -> (X, Y) = (y, -x) sends the line y = a x + 1/a onto
Y = A X + A^2 with A = -1/a. So inv incidence (a, x) <-> a2 incidence
(A, X) = (-1/a, a x + 1/a)."""
from model import var, unvar


def inv_to_a2(sol, p):
    out = []
    for v in sol:
        a, x = unvar(v, p)
        ai = pow(a, p - 2, p)
        out.append(var((-ai) % p, (a * x + ai) % p, p))
    return out


def a2_to_inv(sol, p):
    out = []
    for v in sol:
        A, X = unvar(v, p)
        Y = (A * X + A * A) % p
        a = (-pow(A, p - 2, p)) % p
        out.append(var(a, (-Y) % p, p))
    return out
