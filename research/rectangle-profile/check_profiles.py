"""Exact rational certificates for the rectangular endpoint iteration."""
from fractions import Fraction as Q
from math import comb


class Poly:
    """Polynomial in s and t, with exact rational coefficients."""
    def __init__(self, terms=0):
        if not isinstance(terms, dict):
            terms = {(0,0): Q(terms)}
        self.terms = {k:Q(v) for k,v in terms.items() if v}

    @staticmethod
    def lift(x):
        return x if isinstance(x,Poly) else Poly(x)

    def __add__(self,other):
        result = dict(self.terms)
        for k,v in self.lift(other).terms.items():
            result[k] = result.get(k,0)+v
        return Poly(result)

    __radd__ = __add__

    def __neg__(self):
        return Poly({k:-v for k,v in self.terms.items()})

    def __sub__(self,other):
        return self + -self.lift(other)

    def __rsub__(self,other):
        return self.lift(other) + -self

    def __mul__(self,other):
        result = {}
        for (i,j),a in self.terms.items():
            for (k,l),b in self.lift(other).terms.items():
                ix = (i+k,j+l)
                result[ix] = result.get(ix,0) + a*b
        return Poly(result)

    __rmul__ = __mul__

    def __pow__(self,n):
        z=Poly(1)
        for _ in range(n): z=z*self
        return z

    def degrees(self):
        return (max((k[0] for k in self.terms),default=0),
                max((k[1] for k in self.terms),default=0))


S,T = Poly({(1,0):1}), Poly({(0,1):1})


def horner(coeffs,x):
    v=0
    for c in reversed(coeffs): v=v*x+c
    return v


def bernstein(p):
    """Power to tensor-product Bernstein basis on [0,1] squared."""
    n,m = p.degrees()
    ax = [[Q(comb(i,k),comb(n,k)) for k in range(i+1)] for i in range(n+1)]
    ay = [[Q(comb(j,l),comb(m,l)) for l in range(j+1)] for j in range(m+1)]
    left = [[sum(p.terms.get((k,l),0)*r for k,r in enumerate(ax[i]))
             for l in range(m+1)] for i in range(n+1)]
    return [[sum(left[i][l]*r for l,r in enumerate(ay[j])) for j in range(m+1)] for i in range(n+1)]


def split_curve(row):
    """Both Bernstein coefficient lists after midpoint subdivision."""
    left,right=[row[0]],[row[-1]]
    while len(row)>1:
        row=[(a+b)/2 for a,b in zip(row,row[1:])]
        left.append(row[0]);right.append(row[-1])
    return left,right[::-1]


def transpose(table):
    return [list(row) for row in zip(*table)]


def prove_nonnegative(p):
    """Every accepted box has nonnegative exact Bernstein coefficients."""
    counts = [0,0]
    def check(b,depth,axis):
        if min(min(row) for row in b)>=0:
            counts[0]+=1;counts[1]=max(counts[1],depth)
            return
        if depth > 45 or min(b[0][0],b[0][-1],b[-1][0],b[-1][-1]) < 0:
            raise ValueError("negative coefficient at a corner or subdivision limit reached")
        if len(b[0])==1: axis=0
        if len(b)==1: axis=1
        lines=transpose(b) if axis==0 else b
        parts=[split_curve(row) for row in lines]
        for half in (0,1):
            child=[pair[half] for pair in parts]
            check(transpose(child) if axis==0 else child,depth+1,1-axis)
    check(bernstein(p),0,0)
    return counts


def profile_step(previous,following,imbalance=False,bonus=0):
    # a=s*x, b=s*y, with x+y=1 and a>=b by symmetry.
    x,y=(1+T)*Q(1,2),(1-T)*Q(1,2)
    a,b=S*x,S*y
    U,V=1+a*horner(previous,a),1+b*horner(previous,b)
    D=x*y
    J=1+S*D*(1+S*horner(previous,S))
    B=J-2*S*D
    z=S**2*D
    H=(x*V+y*U)*J**2+z*B*U*V
    R=B**2*U*V+bonus*H
    q=horner(following,S)
    C=1+S*D
    penalty=(4-3*S)*S*T**2*Q(1,5) if imbalance else 0
    return R-q*H-penalty*(C+z*q)*(C*H+z*R)


def cut_step(profile,p,q):
    # Return a new bound on the cut, as numerator and denominator polynomials.
    a,b=S,1-S
    U,V=1+a*horner(profile,a),1+b*horner(profile,b)
    A,B=a*q-p,b*q-p
    na,nb=A**2*U,B**2*V
    da,db=a*q**2+p*A*U,b*q**2+p*B*V
    z=a*b
    return z*da*db, da*db+z*(da*db+na*db+nb*da)


def on_interval(p, left, right):
    if p.degrees()[1]:
        raise ValueError("a univariate polynomial is required")
    coeffs=[p.terms.get((degree,0),0) for degree in range(p.degrees()[0]+1)]
    return horner(coeffs,left+(right-left)*S)


def fixed_point_test(profile,width,slope,imbalance=False):
    cap=width**2+slope*(S-width)-S**2*Q(1,2)
    z=S*(1-S)
    p,q=cut_step(profile,cap,Poly(1))
    criterion=cap*q-p
    if imbalance:
        b=1-S
        scaled_extra=(b*(4-3*S)*(S-cap)**2*(S-2*cap)**2
                      + S*(4-3*b)*(b-cap)**2*(b-2*cap)**2)*Q(1,5)
        criterion=z*criterion+cap*scaled_extra*p
    # Outside the central interval the elementary cut mass bound suffices.
    for left,right in [(Q(0),Q(1,16)),(Q(15,16),Q(1))]:
        prove_nonnegative(on_interval(cap-z,left,right))
    boxes,depth=prove_nonnegative(on_interval(criterion,Q(1,16),Q(15,16)))
    print("fixed point",criterion.degrees(),boxes,depth,"density",width/2,flush=True)
    assert 0 < slope < 2*width


def directional_test(profile):
    """The single-side matching inequality on the three terminal intervals."""
    width = Q(59031, 100000)
    slope = Q(43423, 100000)
    a, b = S, 1-S
    z = a*b
    h = width**2+slope*(a-width)-a**2*Q(1,2)
    criterion = (2-a)*h*(b+(1+b*horner(profile,b))*h*(b-h))-2*z*(b-h)
    for name, poly, left, right in (
            ("short row", h*(1+z)-z, Q(0), Q(1,4)),
            ("row inequality", criterion, Q(1,4), Q(15,16)),
            ("short column", h-z, Q(15,16), Q(1))):
        boxes, depth = prove_nonnegative(on_interval(poly,left,right))
        print(name, poly.degrees(), boxes, depth, "density", width/2, flush=True)


def profiles():
    rows = [
        [999982,-1000908,260051,211655,-207088,57719],
        [999976,-500632,-497000,802099,-489786,121804],
        [999973,-499097,-390702,667511,-414504,102855],
        [999972,-499094,-390068,676897,-418799,102409],
        [999973,-499129,-389683,675471,-415911,101306],
        [999973,-499133,-389642,675359,-415825,101377],
    ]
    return [[Q(0)]]+[[Q(c,1000000) for c in row] for row in rows]


def main():
    stages=profiles()
    for j,(old,new) in enumerate(zip(stages,stages[1:]),1):
        value=horner(new,S)
        for title,polynomial in (("lower",value),("upper",1-value),("step",profile_step(old,new))):
            boxes,depth=prove_nonnegative(polynomial)
            print(j,title,polynomial.degrees(),boxes,depth,flush=True)
    profile=stages[-1]
    z=S*(1-S)
    p,q=z,1+z*(1+sum(profile))
    # The first application bounds the cut for the second and final application.
    p,q=cut_step(profile,p,q)
    p,q=cut_step(profile,p,q)
    w=Q(5951,10000)
    slope=Q(4756,10000)
    cap=w*w+slope*(S-w)-S**2*Q(1,2)
    polynomial=cap*q-p
    boxes,depth=prove_nonnegative(polynomial)
    print("terminal",polynomial.degrees(),boxes,depth,"density",w/2,flush=True)
    assert 0 < slope < 2*w
    fixed_point_test(profile,Q(1190169,2000000),Q(4754683,10000000))
    strengthened=profile_step(stages[-2],stages[-1],imbalance=True)
    print("imbalance",strengthened.degrees(),*prove_nonnegative(strengthened),flush=True)
    fixed_point_test(profile,Q(148677,250000),Q(14777,31250),imbalance=True)
    gain=S**2*(4-3*S)**3*(4-S)**2*(9-4*S)*Q(1,62500)
    for stage,row in enumerate((
        [999866,-496052,-274156,340952,-93166,-4677],
        [999874,-496301,-271699,348470,-109475,2786],
    ),7):
        following=[Q(c,1000000) for c in row]
        value=horner(following,S)
        for name,polynomial in (("lower",value),("upper",1-value),
                ("step",profile_step(profile,following,imbalance=True,bonus=gain))):
            print(stage,name,polynomial.degrees(),*prove_nonnegative(polynomial),flush=True)
        profile=following
    fixed_point_test(profile,Q(297331,500000),Q(472899,1000000),imbalance=True)
    directional_test(profile)


if __name__ == "__main__":
    main()
