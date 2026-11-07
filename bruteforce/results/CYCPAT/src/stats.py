import json,sys,collections
from math import gcd
for n in map(int, sys.argv[1:]):
    k={12:3,16:4,20:5,24:6,28:7,32:8,36:9}.get(n)
    import glob
    f=glob.glob(f'runs/enum_n{n}_k*.json'); f=[x for x in f if json.load(open(x))['n_orbits']>0][0]
    d=json.load(open(f))
    C=collections.Counter(); G=collections.Counter(); M2=collections.Counter()
    for o in d['orbits']:
        D=[x for x,_ in o['canon']]
        C[tuple(sorted(collections.Counter(x%4 for x in D).items()))]+=1
        G[tuple(sorted(collections.Counter(gcd(x,n) for x in D).items()))]+=1
        # g mod 2 pattern / parity of g - d
        M2[tuple(sorted(collections.Counter(((g)%2, x%2) for x,g in o['canon']).items()))]+=1
    print(n, len(d['orbits']))
    print('  D mod4:', C.most_common(6))
    print('  gcd:', G.most_common(6))
    print('  (g%2,d%2):', M2.most_common(6))
