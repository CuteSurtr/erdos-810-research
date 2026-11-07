#!/usr/bin/env python3
"""Exact modular checks of Fourier blocks, plus independent finite counts.

Weil sums are also evaluated numerically for small primes as a consistency
check; this does not prove the general Weil bound or the operator theorem.
"""
import cmath,datetime,hashlib,itertools,json,math,pathlib,time

def primitive_log(p):
    for g in range(2,p):
        vals=[pow(g,j,p) for j in range(p-1)]
        if len(set(vals))==p-1:return g,{a:j for j,a in enumerate(vals)}
    raise AssertionError(p)

def blocks():
    character_cases=0;phase_cases=0;axis_cases=0;max_weil_ratio=0
    for p in [3,5,7,11,13,17,19,23,29,31]:
        _,logs=primitive_log(p);inv=[0]+[pow(a,-1,p) for a in range(1,p)]
        for xi,eta in itertools.product(range(p),repeat=2):
            if xi==eta==0:continue
            right=-logs[eta] if eta else logs[xi]
            for a in range(1,p):
                outx=a*eta%p;outy=xi*inv[a]%p
                left=logs[outx] if outx else -logs[outy]
                assert (left+right-logs[a])%(p-1)==0
                character_cases+=1
        for alpha,b,c in [(1,0,0),(1,2,3),(2,1,p-1),(p-1,3,1)]:
            beta=lambda a:(alpha*a*a+b*a+c)%p
            for r,s in itertools.product(range(1,p),repeat=2):
                assert (-s*beta(r*inv[s]%p)+alpha*r*r*inv[s]+b*r+c*s)%p==0
                assert (r*beta(s*inv[r]%p)-alpha*s*s*inv[r]-b*s-c*r)%p==0
                axis_cases+=2
            assert max(sum(r*r%p==v for r in range(1,p)) for v in range(p))==2
            if p==3:continue
            for t in range(1,p):
                inv3t=pow(3*t,-1,p)
                q=lambda r:(alpha*r**3*inv3t+b*r-c*t*inv[r])%p
                for r,s in itertools.product(range(1,p),repeat=2):
                    a=r*s*inv[t]%p
                    lhs=(r-s)*beta(a)*inv[a]%p
                    rhs=(q(r)-q(s)-alpha*(r-s)**3*inv3t)%p
                    assert lhs==rhs
                    phase_cases+=1
        if p>3:
            e=[cmath.exp(2j*math.pi*x/p) for x in range(p)]
            for cubic in range(1,p):
                for linear in range(p):
                    s=sum(e[(cubic*u**3+linear*u)%p] for u in range(p))
                    ratio=abs(s)/math.sqrt(p)
                    assert ratio<=2+1e-10
                    max_weil_ratio=max(max_weil_ratio,ratio)
    return {'character_separation_exact_cases':character_cases,'cubic_phase_exact_cases':phase_cases,
        'axis_phase_exact_cases':axis_cases,'small_prime_weil_max_over_sqrt_p':max_weil_ratio}

def dense(p):
    squares={a*a%p for a in range(1,p)}
    leg=lambda x:0 if x%p==0 else 1 if x%p in squares else -1
    eps=-leg(-1);H={y for y in range(1,p) if leg(y)==eps};d=len(squares)
    E={(((y-a*a)*pow(a,-1,p))%p,y):a for a in squares for y in H}
    m=d*len(H);assert len(E)==m
    r=sum(((y-1)%p,(x+1)%p) in E for x,y in E)
    n2=0
    for a in squares:
        b=(-a)%p
        if b not in squares or a>=b:continue
        for x in range(p):
            z=(-x)%p
            if x>=z:continue
            y=(a*x+a*a)%p;w=(a*z+a*a)%p
            if y in H and w in H:n2+=1
    formula_n2=(p-1)*(p-3+2*leg(2))//32 if leg(-1)==1 else 0
    assert n2==formula_n2
    n3twice=d*r-m-4*n2;assert n3twice>=0 and n3twice%2==0
    n3=n3twice//2;independent=None
    if p<=61:
        c2=c3=0
        for x,z in itertools.combinations(range(p),2):
            common=[y for y in H if (x,y) in E and (z,y) in E]
            for y,w in itertools.combinations(common,2):
                colors={E[x,y],E[x,w],E[z,y],E[z,w]}
                c2+=len(colors)==2;c3+=len(colors)==3
        assert (n2,n3)==(c2,c3);independent=c3
    if p<=31:
        tf=sum((((y-a*a)*pow(a,-1,p))%p,(a*x+a*a)%p) in E for a in squares for x,y in E)
        assert tf==d*r
    return {'p':p,'edges':m,'n2':n2,'n3':n3,'independent_n3':independent,
        'n3_over_p_cubed':n3/p**3,'limiting_coefficient':1/64}

def main():
    start=time.monotonic();out=pathlib.Path(__file__).resolve().parent
    result={'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),**blocks(),
        'dense_example':[dense(p) for p in [5,7,13,17,31,61,127,251,509,1009]],
        'scope':'exact finite identities and counts; small-prime character sums are floating-point consistency checks',
        'script_sha256':hashlib.sha256(pathlib.Path(__file__).read_bytes()).hexdigest(),
        'seconds':round(time.monotonic()-start,3)}
    (out/'quadratic-character-audit.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps(result))

if __name__=='__main__':main()
