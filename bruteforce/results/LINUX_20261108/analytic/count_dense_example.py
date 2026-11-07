#!/usr/bin/env python3
"""Count three-color C4s in the dense rank-one quadratic example.

Exact field arithmetic. The O(d^3) color-triple count is cross-checked
against an independent row/common-neighbor enumeration for small primes.
"""
import datetime,hashlib,itertools,json,pathlib,time

def fast(p):
    d=p//8;s=p//4;A=range(1,d+1)
    inv=[0]+[pow(x,-1,p) for x in range(1,p)]
    count=0
    for a in A:
        aa=a*a;aaa=a*aa;ia=inv[a]
        for b in A:
            if b==a:continue
            bb=b*b
            for c in A:
                if c==a:continue
                denominator=(b*c-aa)%p
                numerator=(aaa-a*c*c-c*bb+c*aa)%p
                if not denominator:
                    # If b!=a, beta=a^2 makes the degenerate numerator
                    # zero only for b=-a, excluded by this palette.
                    assert numerator
                    continue
                x=(numerator*inv[denominator])%p
                if x>=s:continue
                z=((b*x+bb-aa)*ia)%p
                if z<s:
                    assert x!=z and b!=c
                    count+=1
    assert count%2==0
    return count//2

def independent(p):
    d=p//8;s=p//4
    E={(x,(a*x+a*a)%p):a for a in range(1,d+1) for x in range(s)}
    assert len(E)==d*s
    count=0
    for x,z in itertools.combinations(range(s),2):
        common=[y for y in range(p) if (x,y) in E and (z,y) in E]
        for y,w in itertools.combinations(common,2):
            colors={E[x,y],E[x,w],E[z,y],E[z,w]}
            assert len(colors)!=2
            count+=len(colors)==3
    return count

def main():
    start=time.monotonic();rows=[]
    for p in [31,61,127,251,509,1009]:
        n3=fast(p);other=independent(p) if p<=251 else None
        if other is not None:assert n3==other
        rows.append({'p':p,'palette':p//8,'rows':p//4,'edges':(p//8)*(p//4),
            'n3_exact':n3,'independent_n3':other,
            'normalized_n3':n3/p**3,'limiting_coefficient':1/16384})
    out=pathlib.Path(__file__).resolve().parent
    obj={'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'rows':rows,
        'seconds':round(time.monotonic()-start,3),
        'script_sha256':hashlib.sha256(pathlib.Path(__file__).read_bytes()).hexdigest(),
        'scope':'exact finite counts; the asymptotic formula requires the archived operator theorem'}
    (out/'dense-example-counts.json').write_text(json.dumps(obj,indent=2)+'\n');print(json.dumps(obj))

if __name__=='__main__':main()
