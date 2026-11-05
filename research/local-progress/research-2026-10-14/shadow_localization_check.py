#!/usr/bin/env python3
"""Independent finite checks supplementing the written shadow proof."""
from itertools import combinations
from pathlib import Path
import json
import random


def free74(H):
    return all(len(set.union(*F)) >= 8 for F in combinations(H, 4))


def shadow(H):
    G = {}
    source = {}
    for i, e in enumerate(H):
        for pair in combinations(sorted(e), 2):
            if pair not in G:
                G[pair] = next(iter(e - set(pair)))
                source[pair] = i
    return G, source


def bad_cycles(G):
    V = sorted(set().union(*(set(p) for p in G))) if G else []
    for a,b,c,d in combinations(V,4):
        for cyc in ((a,b,c,d),(a,b,d,c),(a,c,b,d)):
            edges = [tuple(sorted((cyc[i],cyc[(i+1)%4]))) for i in range(4)]
            if all(e in G for e in edges) and len({G[e] for e in edges}) < 4:
                yield edges


def verify(H):
    assert free74(H)
    G, source = shadow(H)
    bad = list(bad_cycles(G))
    linear = all(len(e&f)<=1 for e,f in combinations(H,2))
    if linear:
        assert not bad
        assert len(G)==3*len(H)
        for u in set().union(*H) if H else []:
            cols=[c for (a,b),c in G.items() if u in (a,b)]
            assert len(cols)==len(set(cols))
    for cyc in bad:
        ids={source[e] for e in cyc}
        assert len(ids) in (2,3)
        U=set.union(*(H[i] for i in ids))
        if len(ids)==2:
            assert len(U)==4
        else:
            assert len(U)<=5
            if len(U)==4:
                assert len(H)==3
            else:
                assert all(not(e&U) for i,e in enumerate(H) if i not in ids)
    return {'families':1,'linear_families':int(linear),'bad_cycles_localized':len(bad)}


def main():
    totals={'families':0,'linear_families':0,'bad_cycles_localized':0}
    def add(H):
        for k,v in verify(H).items():totals[k]+=v
    for n in range(3,8):
        triples=list(map(set,combinations(range(n),3)))
        for k in range(1,4):
            for H in combinations(triples,k):add(list(H))
    rng=random.Random(810140)
    for n in (8,9,10,12,15,18):
        for _ in range(20):
            candidates=list(map(set,combinations(range(n),3)))
            rng.shuffle(candidates)
            H=[]
            for e in candidates:
                if all(len(e|f|g|h)>=8 for f,g,h in combinations(H,3)):
                    H.append(e)
            add(H)
    totals['status']='all assertions passed'
    Path(__file__).with_name('shadow-localization-checks.json').write_text(json.dumps(totals,indent=2)+'\n')
    print(json.dumps(totals,indent=2))


if __name__=='__main__':main()
