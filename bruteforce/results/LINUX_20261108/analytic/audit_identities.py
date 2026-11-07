#!/usr/bin/env python3
"""Exact finite checks of the new counting/robustness identities.

This does not verify the asymptotic weighted-operator theorem or external
factorization theorems. No numeric packages or floating-point eigensolvers.
"""
from collections import Counter
from fractions import Fraction as Q
from itertools import combinations
import datetime, hashlib, json, pathlib, random, time

OUT=pathlib.Path(__file__).resolve().parent
SEED=20261108
rng=random.Random(SEED)

def graph_case(p,mode,keep):
    A=[a for a in range(1,p) if rng.randrange(5)!=0]
    if not A:A=[1]
    beta={a:(a*a if mode==0 else a**3+2*a if mode==1 else rng.randrange(p))%p for a in A}
    candidates={}
    for a in A:
        for x in range(p):candidates.setdefault((x,(a*x+beta[a])%p),[]).append(a)
    E={e:rng.choice(colors) for e,colors in candidates.items() if rng.randrange(4)<keep}
    F={a:[int(E.get((x,(a*x+beta[a])%p))==a) for x in range(p)] for a in A}
    rho=[sum(x==u for u,v in E) for x in range(p)]
    assert rho==[sum(F[a][x] for a in A) for x in range(p)]
    assert sum(map(sum,F.values()))==len(E)
    cycle_counts=Counter();incidence=Counter()
    for x,z in combinations(range(p),2):
        ys=[y for y in range(p) if (x,y) in E and (z,y) in E]
        for y,w in combinations(ys,2):
            es=[(x,y),(x,w),(z,y),(z,w)];c=[E[e] for e in es]
            assert c[0]!=c[1] and c[2]!=c[3] and c[0]!=c[2] and c[1]!=c[3]
            j=len(set(c));assert 2<=j<=4;cycle_counts[j]+=1
            if j<4:incidence.update(es)
            if j==2:assert (c[0]+c[1])%p==0
    n2,n3=cycle_counts[2],cycle_counts[3]
    assert n2<=(len(A)//2)*((p-1)//2)
    assert all(v<=p+len(A)-2 for v in incidence.values())
    B={a:[Q(rng.randrange(5),4) for x in range(p)] for a in A}
    tf=0;tb=Q(0)
    for a in A:
        inv=pow(a,-1,p)
        for x,y in E:
            z=((y-beta[a])*inv)%p;w=(a*x+beta[a])%p
            if (z,w) in E:
                tf+=F[a][x]*F[a][z]
                tb+=B[a][x]*B[a][z]
    assert tf==len(E)+2*n3+4*n2,(p,mode,E,tf,cycle_counts)
    qf_num=sum(sum(F[a][x]*rho[x] for x in range(p))**2 for a in A)
    assert qf_num*len(A)*p*p>=len(E)**4
    weighted_error=sum(rho[x]*abs(F[a][x]-B[a][x]) for a in A for x in range(p))
    assert abs(tf-tb)<=2*weighted_error
    qb=sum(sum(B[a][x]*rho[x] for x in range(p))**2 for a in A)/(p*p)
    lower=max(Q(0),Q(len(E)**2,p)-weighted_error)**2/(len(A)*p*p)
    assert qb>=lower
    assert lower<=tf+2*weighted_error+abs(tb-qb)
    return {'p':p,'mode':mode,'palette':len(A),'edges':len(E),'n2':n2,'n3':n3,'n4':cycle_counts[4]}

def blocks(bits):
    n=len(bits);N=1<<(n-1).bit_length()
    chosen=[]
    def visit(start,size):
        if start>=n:return
        if start+size<=n and all(bits[start:start+size]):chosen.append((start,size));return
        if size>1:visit(start,size//2);visit(start+size//2,size//2)
    visit(0,N)
    return chosen

def dyadic_audit():
    count=0
    for n in range(1,13):
        L=1+(n-1).bit_length()
        for mask in range(1<<n):
            b=[(mask>>x)&1 for x in range(n)]
            k=sum(t and (x==0 or not b[x-1]) for x,t in enumerate(b))
            ds=blocks(b);sizes=Counter(s for a,s in ds)
            assert all(v<=2*k for v in sizes.values())
            assert len(ds)<=2*k*L
            for x in range(n):assert sum(a<=x<a+s for a,s in ds)==b[x]
            count+=1
    return count

def rank(rows):
    a=[[Q(x) for x in row] for row in rows];i=0
    for j in range(len(a[0])):
        pivot=next((k for k in range(i,len(a)) if a[k][j]),None)
        if pivot is None:continue
        a[i],a[pivot]=a[pivot],a[i]
        scale=a[i][j];a[i]=[v/scale for v in a[i]]
        for k in range(i+1,len(a)):
            if a[k][j]:
                scale=a[k][j];a[k]=[x-scale*y for x,y in zip(a[k],a[i])]
        i+=1
        if i==len(a):break
    return i

def row_type_audit():
    for mask in range(1<<12):
        a=[tuple((mask>>(4*i+j))&1 for j in range(4)) for i in range(3)]
        assert len(set(a))<=2**rank(a)
    return 1<<12

def main():
    start=time.monotonic();cases=[]
    for p in [3,5,7,11,13]:
        for mode in range(3):
            for keep in [1,2,4]:
                for _ in range(8):cases.append(graph_case(p,mode,keep))
    assert any(c['n2'] for c in cases) and any(c['n3'] for c in cases)
    assert (Q(5)+Q(7,8))/3==Q(47,24)
    assert (3*Q(47,24)+2)/5==Q(63,40)
    assert Q(63,40)+Q(2,5)==Q(79,40)
    assert (2-Q(79,40))*Q(5,2)==Q(1,16)
    result={'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'seed':SEED,
        'graph_cases':len(cases),'two_color_cycles_counted':sum(c['n2'] for c in cases),
        'three_color_cycles_counted':sum(c['n3'] for c in cases),
        'dyadic_binary_rows':dyadic_audit(),'binary_matrices_rank_checked':row_type_audit(),
        'checks':'exact integer/rational counting, charging, positivity and exponent checks passed',
        'not_verified':'asymptotic operator theorem, external literature theorems, historical novelty',
        'script_sha256':hashlib.sha256(pathlib.Path(__file__).read_bytes()).hexdigest(),
        'seconds':round(time.monotonic()-start,3)}
    (OUT/'identity-audit.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result))

if __name__=='__main__':main()
