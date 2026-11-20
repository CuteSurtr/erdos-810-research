"""Check the shadow-count identities on explicit systems and the final constants exactly."""
from fractions import Fraction as Q
from itertools import combinations
import json
from pathlib import Path


def check_constants():
    minimum_order = 10**6
    density = Q(7384, 100000)
    low = 3*density
    high = Q(2, 9) + Q(1, 3*minimum_order)
    delta = high*(Q(2, 3) + Q(1, minimum_order) - 3*low)
    total = Q(1, 3) + delta/low
    product = (Q(1, 9) - (1-4*low)**2 - 8*delta/(3*low))/4
    slope = Q(1, 16)
    cuts = (2*slope-slope**2)*product - slope**2*total - Q(1, minimum_order)
    assert 0 < low <= high < Q(1,4)
    assert 0 < delta < Q(469, 10**6)
    assert product > Q(231, 10000) and total < Q(336, 1000)
    lower, upper = low*cuts, 2*delta/3
    assert lower > upper
    return lower, upper


def check_refined_constants():
    h = Q(1, 10**6)
    r0, r1 = 3*Q(7360, 100000), Q(2, 9) + h/3
    budget = r1*(Q(2, 3) + h - 3*r0)
    a, t = Q(5, 17), Q(9, 100)
    assert (Q(4, 3) + 1/(9*a))*Q(23, 136) <= a
    gaps = []
    for index in range(24):
        lo, hi = budget*index/72, budget*(index+1)/72
        defect = budget-3*lo
        total = Q(1, 3)+defect/r0
        common = (total+4*r1-1+4*hi/r0)/2
        product = (Q(1, 9)-(1-4*r0)**2-8*hi/r0)/4
        cut = (2*t-2*t*t)*product-2*t*t*common-h/2
        upper = min(2*defect/3, Q(3, 2)*(a*budget+h*defect))
        assert cut > 0 and r0*cut > upper
        gaps.append(r0*cut-upper)
    assert min(gaps) == Q(8050469057694247,459000000000000000000)
    return min(gaps)


def check_verified_threshold():
    h = Q(1, 10**6)
    low, high = 3*Q(7354, 100000), Q(2, 9) + h/3
    budget = high*(Q(2, 3) + h - 3*low)
    t, a = Q(93, 1000), Q(5, 17)
    k = 2*t-t*t
    w = (2*k+t*t)/2
    assert 0 < w < 1 and low < high < Q(1,4)
    lower = k*low*(Q(1,9)-(1-4*low)**2)/4-t*t*(high*(4*high-Q(2,3))+budget)-high*h/2
    upper = (2*w/3+(1-w)*Q(3,2)*(a+h))*budget
    assert lower-upper == Q(358996108322838523369,1836000000000000000000000000)
    return lower-upper


def check_family(n, blocks):
    family = [frozenset(e) for e in blocks]
    assert len(set(family)) == len(family) and all(len(e) == 3 for e in family)
    assert all(len(a | b | c | d) >= 8 for a,b,c,d in combinations(family,4))
    if any(len(a & b) > 1 for a,b in combinations(family,2)):
        return False
    vertices = set(range(n))
    graph = [set() for _ in vertices]
    degree = [0]*n
    colors = {}
    for e in family:
        for x,y in combinations(e,2):
            colors[frozenset((x,y))], = e-{x,y}
        for x in e:
            graph[x].update(e-{x})
            degree[x] += 1
    assert all(len(graph[x]) == 2*degree[x] for x in vertices)
    defects = 0
    isolated = 0
    distance_sum = 0
    missing = 0
    monochrome = 0
    positive_weight = 0
    products = 0
    totals = 0
    graph_triangles = {t for t in combinations(range(n),3)
                       if t[1] in graph[t[0]] and t[2] in graph[t[0]] & graph[t[1]]}
    assert 6*len(graph_triangles) <= sum(d*(d+1) for d in degree)
    for tri in graph_triangles:
        monochrome += sum(all(u in graph[v] for v in tri) or all(u not in graph[v] for v in tri)
                          for u in vertices)
    for e in family:
        outside = vertices-e
        neighbors = [(next(iter(e & b)), b-e) for b in family if b != e and e & b]
        single = {x:0 for x in e}
        paths = {pair:0 for pair in combinations(sorted(e),2)}
        covered = set()
        for index,(source,pair) in enumerate(neighbors):
            covered.update(pair)
            partners = [(label,other) for k,(label,other) in enumerate(neighbors)
                        if k != index and pair & other]
            assert len(partners) <= 1
            if partners:
                label,other = partners[0]
                assert label != source and len(pair & other) == 1
                if label > source:
                    paths[source,label] += 1
            else:
                single[source] += 1
        unused = len(outside-covered)
        singles = sum(single.values())
        defect = singles + 2*unused
        assert defect == 2*n+3-3*sum(degree[x] for x in e)
        defects += defect
        isolated += unused
        positive = 0
        weighted = 0
        for x,y in combinations(sorted(e),2):
            z, = e-{x,y}
            common = graph[x] & graph[y]
            neither = vertices-(graph[x] | graph[y])
            distance = len(graph[x] ^ graph[y])
            c,b = len(common),len(neither)
            assert c==1+paths[x,y] and 3*c<=n
            q=Q(2*n,3)-distance
            assert q==Q(defect,3)-singles+2*single[z]
            positive += max(q,0)
            positive_weight += c*q
            weighted += c*q
            distance_sum += distance
            local_missing = sum(len(neither-graph[v]) for v in common)
            missing += local_missing
            assert (2*n+b)*(c*b-local_missing) <= b*n*(2*c+1)
            sizes = [0]*n
            for z in common:
                for w in neither & graph[z]:
                    sizes[colors[frozenset((z,w))]] += 1
            assert sum(k*(k-1)//2 for k in sizes) <= c*local_missing
            assert (n*(c+b)+c*b)*local_missing >= c*b*(c*b-n)
            assert 4*c*b == (n-distance)**2-(2*degree[x]+2*degree[y]-n)**2
            products += c*b
            totals += c+b
        assert 3*positive <= 4*defect
        mean = Q(sum(degree[x] for x in e), 3)
        scatter = sum((degree[x]-mean)**2 for x in e)
        a = Q(5, 17)
        assert weighted <= (a*n+1)*defect + 6*a*scatter
        assert weighted <= (Q(28141,100000)*n+1)*defect + Q(1217,1000)*scatter
    m=len(family)
    assert defects==(2*n+3)*m-3*sum(d*d for d in degree)
    assert distance_sum==2*n*m-2*isolated
    assert positive_weight==2*monochrome
    assert missing<=3*monochrome and 3*missing<=2*n*defects
    if m:
        r = Q(3*m,n*n)
        var = sum((Q(d,n)-r)**2 for d in degree)/n
        D = Q(defects,n**3)
        assert D+3*var==r*(Q(2,3)+Q(1,n)-3*r)
        A = Q(totals,3*m*n)
        P = Q(products,3*m*n*n)
        t = Q(1,16)
        assert Q(missing,n**4)>=r*((2*t-t*t)*P-t*t*A-Q(1,n))
        if r <= Q(1,4):
            assert 4*P >= Q(1,9)-(1-4*r)**2-8*var/r
    return True


def check_affine_plane():
    """Enumerate every admissible subfamily of the twelve lines of AG(2,3)."""
    lines = [frozenset(3*x+y for y in range(3)) for x in range(3)]
    lines += [frozenset(3*x+(a*x+b)%3 for x in range(3))
              for a in range(3) for b in range(3)]
    forbidden = [sum(1 << i for i in indices) for indices in combinations(range(12), 4)
                 if len(frozenset.union(*(lines[i] for i in indices))) <= 7]
    checked = 0
    for mask in range(1 << 12):
        if any(mask & bad == bad for bad in forbidden):
            continue
        check_family(9, [line for i,line in enumerate(lines) if mask & (1 << i)])
        checked += 1
    return checked


def check_width_threshold():
    alpha, beta = Q(28141,100000), Q(1217,1000)
    slope, intercept = Q(36849,208849), Q(243,208849)
    assert (2+2*beta-9*alpha/2)**2 <= 4*beta*(beta+3*alpha)
    assert 3*(beta/2-3*alpha)/2 <= -2*slope
    # Ascending coefficients of the univariate tangent certificate.
    left = [intercept,intercept/2,-intercept/12-slope/4,(1-slope)/8,-(1-slope)/48]
    square = [Q(9,100),Q(-3,5),Q(1)]
    factor = [Q(c,626547) for c in [8100,58050,-10750]]
    assert left == [sum(square[i]*factor[k-i] for i in range(3) if 0<=k-i<3) for k in range(5)]
    h, error = Q(1,10**6), Q(1,10**7)
    lo, hi = 3*Q(73272,10**6), Q(2,9)+h/3
    budget = hi*(Q(2,3)+h-3*lo)
    lower = slope*lo*(Q(1,9)-(1-4*lo)**2)/4-(intercept+error)*hi
    gap = lower-Q(3,2)*(alpha+h)*budget
    assert gap == Q(223245434762836703,1253094000000000000000000)
    return gap


def main():
    root = Path(__file__).resolve().parents[2]
    examples = root / 'bruteforce/results/2026-11-20/triple-constructions.json'
    witnesses = json.loads(examples.read_text())
    checked = [int(n) for n,row in witnesses.items() if check_family(int(n),row['triples'])]
    for n in range(7, 15):
        check_family(n, [])
        check_family(n, [[0,1,2],[0,3,4],[1,3,5]])
        check_family(n, [[0,1,2],[0,3,4],[0,5,6]])
    print("Width-contraction 0.073272 contradiction gap", check_width_threshold())
    print("Verified 0.07354 rational contradiction gap", check_verified_threshold())
    print("Refined rational contradiction gap", check_refined_constants())
    affine = check_affine_plane()
    lower, upper = check_constants()
    print("Linear constructions checked at orders", checked)
    print("Admissible subfamilies of AG(2,3) checked:", affine)
    print("Normalized missing-edge bounds under the contrary assumption")
    print("lower", lower, "upper", upper, "positive gap", lower-upper)


if __name__ == '__main__':
    main()
