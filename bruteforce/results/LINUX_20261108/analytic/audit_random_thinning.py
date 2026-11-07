#!/usr/bin/env python3
"""Exact potential-collision and thinning checks for the quadratic-residue family."""
import collections, datetime, fractions, hashlib, itertools, json, pathlib, random, time

def base(p):
    A=sorted({a*a%p for a in range(1,p)})
    leg=lambda x:0 if x%p==0 else 1 if x%p in A else -1
    J=sorted(y for y in range(1,p) if leg(y)==-leg(-1))
    E={(((y-a*a)*pow(a,-1,p))%p,y):a for a in A for y in J}
    assert len(E)==len(A)*len(J)
    return A,J,E

def direct_cycles(p,E):
    n3=0
    rows={x:set() for x in range(p)}
    for x,y in E:rows[x].add(y)
    for x,z in itertools.combinations(range(p),2):
        for y,w in itertools.combinations(rows[x]&rows[z],2):
            n3+=len({E[x,y],E[x,w],E[z,y],E[z,w]})==3
    return n3

def ratio_count(p,A):
    leg=[0]+[1 if x in A else -1 for x in range(1,p)]
    inv=[0]+[pow(x,-1,p) for x in range(1,p)]
    eps=-leg[-1];count=0
    for q in A:
        if q==1:continue
        for r in A:
            if r in (1,q) or q*r%p==1:continue
            den=(1-q*r)%p
            Y=r*(q*q-q+r-1)*inv[den]%p
            W=q*(r*r-r+q-1)*inv[den]%p
            f2=(r+q*q-q-1)*den%p
            f3=(r*r-r+q-1)*den%p
            assert leg[Y]==leg[f2] and leg[W]==leg[f3]
            count+=leg[Y]==eps and leg[W]==eps
    assert len(A)*count%2==0
    return len(A)*count//2

def audit(p):
    A,J,E=base(p);d=len(A);cycles=[];hist=collections.Counter()
    adjacent=opposite=0
    for a in A:
        aedges=[(x,y) for (x,y),b in E.items() if b==a]
        inva=pow(a,-1,p)
        for (x,y),(z,w) in itertools.combinations(aedges,2):
            if (x,w) not in E or (z,y) not in E:continue
            b,c=E[x,w],E[z,y]
            if b==c:continue
            assert len({a,b,c})==3
            assert b*c%p!=a*a%p
            pots=(a*y%p,a*w%p,b*w%p,c*y%p)
            adjacent_here=pots[0]==pots[2] or pots[1]==pots[3]
            opposite_here=pots[2]==pots[3]
            if pots[0]==pots[2]:
                assert (a+b)%p and ((a+b)*x+a*a+a*b+b*b)%p==0
            if pots[1]==pots[3]:
                assert (a+c)%p and ((a+c)*z+a*a+a*c+c*c)%p==0
            q=b*inva%p;r=c*inva%p
            assert opposite_here==((q*q+r*r-q-r)%p==0)
            assert (len(set(pots))<4)==(adjacent_here or opposite_here)
            adjacent+=adjacent_here;opposite+=opposite_here
            hist[len(set(pots))]+=1;cycles.append(frozenset(pots))
    assert adjacent<=d*(d-1)
    assert opposite<=2*d*(d-1)
    assert sum(v for k,v in hist.items() if k<4)<=3*d*(d-1)
    assert not any(k<3 for k in hist)
    direct_ratio_n3=ratio_count(p,A)
    assert direct_ratio_n3==len(cycles)
    max_codegrees={}
    if p<=101:
        bounds={1:p*p,2:108*p,3:216,4:72}
        for j in range(1,5):
            counts=collections.Counter(S for C in cycles if len(C)==4
                for S in itertools.combinations(sorted(C),j))
            max_codegrees[j]=max(counts.values(),default=0)
            assert max_codegrees[j]<=bounds[j]
    if p<=61:assert direct_cycles(p,E)==len(cycles)
    exhaustive=0
    if p<=17:
        eta=fractions.Fraction(1,3);mean=fractions.Fraction()
        for bits in itertools.product([0,1],repeat=len(J)):
            H={j for j,b in zip(J,bits) if b}
            n=sum(C<=H for C in cycles)
            sub={e:a for e,a in E.items() if a*e[1]%p in H}
            assert direct_cycles(p,sub)==n
            mean+=n*eta**len(H)*(1-eta)**(len(J)-len(H))
            exhaustive+=1
        assert mean==sum(v*eta**k for k,v in hist.items())
    rng=random.Random(810+p);random_cases=0
    for eta in [0.25,0.5,0.75]:
        for _ in range(4):
            H={j for j in J if rng.random()<eta}
            count=sum(C<=H for C in cycles)
            if p<=61:
                sub={e:a for e,a in E.items() if a*e[1]%p in H}
                assert len(sub)==d*len(H)
                assert direct_cycles(p,sub)==count
            random_cases+=1
    return {'p':p,'n3':len(cycles),'distinct_potential_histogram':dict(sorted(hist.items())),
        'adjacent_row_collision_cycles':adjacent,'opposite_collision_cycles':opposite,
        'degenerate_bound':3*d*(d-1),'exhaustive_masks_checked':exhaustive,
        'random_masks_checked':random_cases,'direct_cycle_check':p<=61,
        'four_potential_max_codegrees':max_codegrees,
        'independent_color_ratio_n3':direct_ratio_n3}

def main():
    start=time.monotonic();path=pathlib.Path(__file__).resolve()
    result={'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),
        'rows':[audit(p) for p in [5,7,13,17,31,61,101,251]],
        'scope':'exact finite algebra and counting checks; not a proof of the asymptotic or concentration theorem',
        'script_sha256':hashlib.sha256(path.read_bytes()).hexdigest(),
        'seconds':round(time.monotonic()-start,3)}
    path.with_name('random-thinning-audit.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result))

if __name__=='__main__':main()
