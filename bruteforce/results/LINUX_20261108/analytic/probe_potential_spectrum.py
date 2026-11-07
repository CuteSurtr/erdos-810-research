#!/usr/bin/env python3
"""Bounded exploratory Lanczos estimates; NOT certified spectral bounds.

Try complicated common-potential masks inside one nontrivial cubic coset.
They are proper with the full quadratic palette. This probes an unresolved
uniform masked-operator estimate; finite observations cannot prove it.
"""
from array import array
import datetime,hashlib,json,math,os,pathlib,random,resource,time

R=pathlib.Path(__file__).resolve().parents[1]
resource.setrlimit(resource.RLIMIT_AS,(512*1024**2,512*1024**2))
LIMIT=time.monotonic()+120

def stop():
    if time.monotonic()>=LIMIT or (R/'STOP').exists():raise TimeoutError('bounded probe stopped')

def primitive(p):
    for g in range(2,p):
        if len({pow(g,k,p) for k in range(p-1)})==p-1:return g

def extremal_ritz(a,b):
    lower=min(x-(abs(b[i-1]) if i else 0)-(abs(b[i]) if i<len(b) else 0) for i,x in enumerate(a))-1
    upper=max(x+(abs(b[i-1]) if i else 0)+(abs(b[i]) if i<len(b) else 0) for i,x in enumerate(a))+1
    def count(x):
        q=a[0]-x;n=int(q<0)
        for i in range(1,len(a)):
            if abs(q)<1e-100:q=-1e-100
            q=a[i]-x-b[i-1]**2/q;n+=q<0
        return n
    ans=[]
    for target in [1,len(a)]:
        lo,hi=lower,upper
        for _ in range(60):
            mid=(lo+hi)/2
            if count(mid)>=target:hi=mid
            else:lo=mid
        ans.append((lo+hi)/2)
    return ans

def probe(p,mode):
    start=time.monotonic();g=primitive(p);n=(p-1)//3;rng=random.Random(20261108+p+mode)
    if mode==0:chosen=[j for j in range(n) if rng.randrange(2)]
    elif mode==1:chosen=list(range(n//2))
    else:chosen=[j for j in range(n) if (j*j%n)<n//2]
    H=[pow(g,3*j+1,p) for j in chosen];h=len(H);dim=p*p
    left=array('I');right=array('I');columns=[]
    seen=set()
    for a in range(1,p):
        ia=pow(a,-1,p);ys=[t*ia%p for t in H];xs=[(y*ia-a)%p for y in ys]
        columns.append(ys)
        for x,y in zip(xs,ys):
            key=x*p+y;assert key not in seen;seen.add(key)
        for x,y in zip(xs,ys):
            xp=x*p
            for z,w in zip(xs,ys):left.append(xp+w);right.append(z*p+y)
        stop()
    def apply(v):
        out=[0.0]*dim
        for x,y in zip(left,right):out[x]+=v[y]
        sums=[math.fsum(v[y::p]) for y in range(p)]
        q=[0.0]*p
        for ys in columns:
            z=sum(sums[y] for y in ys)/dim
            for y in ys:q[y]+=z
        for x in range(p):
            xp=x*p
            for y in range(p):out[xp+y]-=q[y]
        return out
    v=[rng.uniform(-1,1) for _ in range(dim)];norm=math.sqrt(math.fsum(x*x for x in v));v=[x/norm for x in v]
    prev=None;lastbeta=0;aa=[];bb=[]
    for it in range(24):
        stop();w=apply(v);a=math.fsum(x*y for x,y in zip(v,w));aa.append(a)
        if prev is None:w=[x-a*y for x,y in zip(w,v)]
        else:w=[x-a*y-lastbeta*z for x,y,z in zip(w,v,prev)]
        beta=math.sqrt(math.fsum(x*x for x in w))
        if beta<1e-12:break
        if it<23:bb.append(beta)
        prev,v=v,[x/beta for x in w];lastbeta=beta
    low,high=extremal_ritz(aa,bb)
    return {'p':p,'mode':['random-half','exponent-interval','quadratic-exponent'][mode],
        'support_size':h,'edges':len(seen),'transitions':len(left),'iterations':len(aa),
        'ritz_min':low,'ritz_max':high,'min_over_sqrt_p':low/math.sqrt(p),'max_over_sqrt_p':high/math.sqrt(p),
        'seconds':round(time.monotonic()-start,3)}

def main():
    rows=[]
    try:
        for p in [193,379]:
            for mode in range(3):
                x=probe(p,mode);rows.append(x);print(json.dumps(x),flush=True)
        status='completed'
    except TimeoutError as exc:status=str(exc)
    obj={'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'status':status,'rows':rows,
        'scope':'exploratory floating-point Ritz estimates, not certified extremal eigenvalues or an asymptotic theorem',
        'script_sha256':hashlib.sha256(pathlib.Path(__file__).read_bytes()).hexdigest()}
    (R/'analytic/potential-spectrum-probe.json').write_text(json.dumps(obj,indent=2)+'\n')

if __name__=='__main__':main()
