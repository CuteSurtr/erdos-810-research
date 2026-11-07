#!/usr/bin/env python3
"""Consolidate independently checked improvements; optionally wait for shutdown.

No solver verdict is promoted to an unrestricted upper bound. Source graph
certificates are validated by two independent full C4 enumerations.
"""
import argparse, datetime, hashlib, json, os, pathlib, subprocess, sys, time
ROOT=pathlib.Path(__file__).resolve().parent

def main():
    ap=argparse.ArgumentParser();ap.add_argument('--wait-until',type=float)
    args=ap.parse_args()
    if args.wait_until:
        while time.time()<args.wait_until and not (ROOT/'STOP_ALL').exists():time.sleep(5)
        if (ROOT/'STOP_ALL').exists():time.sleep(90)
    verification_deadline=time.time()+300
    baseline=json.loads((ROOT/'constructions/baseline.json').read_text())
    best={};sources={};source_bytes={}
    for pattern in ('constructions/best/*.json','recolor/best/*.json'):
        for p in ROOT.glob(pattern):
            raw=p.read_bytes()
            for k,E in json.loads(raw).items():
                if not k.isdigit() or not 13<=int(k)<=128:continue
                if len(E)>len(best.get(k,baseline.get(k,[]))):
                    sha=hashlib.sha256(raw).hexdigest()
                    best[k]=E;source_bytes[sha]=raw
                    sources[k]={'path':str(p.relative_to(ROOT)),'sha256':sha,'snapshot':f'sources/{sha}.json'}
    out=ROOT/'verified';out.mkdir(exist_ok=True)
    (out/'sources').mkdir(exist_ok=True)
    for sha,raw in source_bytes.items():(out/'sources'/f'{sha}.json').write_bytes(raw)
    temp=out/f'pending-certs-{os.getpid()}.json';temp.write_text(json.dumps(best)+'\n')
    c_lines=[]
    for k,E in sorted(best.items(),key=lambda z:int(z[0])):
        data=f'{k} {len(E)}\n'+''.join(f'{a} {b} {c}\n' for a,b,c in E)
        assert time.time()<verification_deadline, 'verification deadline reached'
        r=subprocess.run([str(ROOT/'constructions/fourset_check')],input=data,text=True,capture_output=True,timeout=max(1,min(30,verification_deadline-time.time())),check=True)
        c_lines.append(r.stdout.strip())
    r=subprocess.run([sys.executable,str(ROOT/'constructions/src/certcheck.py'),str(temp)],capture_output=True,text=True,timeout=max(1,verification_deadline-time.time()),check=True)
    assert c_lines==r.stdout.strip().splitlines(), 'independent cycle counts disagree'
    temp.replace(out/'certs.json')
    (out/'fourset-check.txt').write_text('\n'.join(c_lines)+'\n')
    (out/'independent-check.txt').write_text(r.stdout)
    (out/'sources.json').write_text(json.dumps(sources,indent=2)+'\n')
    rows=[{'n':int(k),'previous':len(baseline[k]),'edges':len(E),'gain':len(E)-len(baseline[k])}
          for k,E in sorted(best.items(),key=lambda z:int(z[0]))]
    (out/'improvements.json').write_text(json.dumps(rows,indent=2)+'\n')
    (out/'improvements.csv').write_text('n,previous,edges,gain\n'+''.join(f"{r['n']},{r['previous']},{r['edges']},{r['gain']}\n" for r in rows))
    state='Final scheduled checkpoint' if args.wait_until else 'Verified checkpoint; searches may still be running'
    now=datetime.datetime.now(datetime.timezone.utc).isoformat()
    text=f'''# Erdős 810 continuation — 6 November 2026

{state}. Updated {now}.

Continued from GitHub `CuteSurtr/erdos-810-research`, latest computational
checkpoint `afac4895bdb646789a051d2227a766a05756609f`. The local worktree's
Git base is older (`445837e`); required latest sources and certificates were
fetched through the GitHub connector. The `MAC_20261106` folder
contains this session's new work. Existing archive files were not revised.

## Verified constructions

**{len(rows)} sizes improved** relative to the latest checkpoint plus the
repository's other saved constructions and implicit pendant padding.
Every certificate in [verified/certs.json](verified/certs.json) passed both
the C four-set checker and the Python common-neighbor checker, with identical
cycle counts. These are lower bounds for unrestricted M(n), not exact values
or claims of published records.

Methods: one-vertex reinsertion/extension with SAT, and deletion followed by
safe recoloring of one color class. Every accepted SAT model satisfies all
encoded clauses; the independent graph checks are the certificate evidence.
Search timeouts and restricted UNSAT results imply no general upper bound.

| Vertices | Previous saved bound | New bound | Gain |
|---:|---:|---:|---:|
'''
    text+=''.join(f"| {r['n']} | {r['previous']} | {r['edges']} | +{r['gain']} |\n" for r in rows)
    text+='''
## Cyclic family

The cyclic-family optimum at **43 vertices is 10 orbits, or 430 edges**.
All 3,705 UNSAT leaves were freshly proof checked, retained, and hash-audited;
independent coverage found zero missing branches. The 430-edge witness has
16,813 four-cycles, all rainbow. This includes replay of the inherited leaves.

The [cyclic directory](cyclic/) records the resumed 43-vertex proof search,
fresh proof replay, coverage checks, and the subsequent 56-vertex search.
Its report distinguishes complete coverage from partial closed cases.
Family upper bounds do not bound unrestricted M(n).

## Written analytic results

- [Low-rank support theorem](analytic/low-rank-supports.md): in the specified
  fixed-degree polynomial affine model, a bounded real rank-r approximation
  with entrywise error R gives
  `m ≤ C_D p^(47/24) r^(1/3) + C p^(3/2) R^(1/4)`.
  Consequently `r=o(p^(1/8))` and `R=o(p²)` imply `m=o(p²)`.
  [Independent audit](analytic/low-rank-supports-audit.md).
- [Hypergraph transfer](analytic/reduction-audit.md): safe attachment of
  isolated blocks removes the old reliance on extremal replacement lemmas
  in `M(n) ≥ 3g(n;7,4) − floor(n/4)`, for n≥7. The stronger per-input
  construction and finite stress checks are included.

These are written proofs with independent hand audits, not Lean certificates.
Historical novelty is unestablished. Unrestricted Erdős 810 remains unresolved
by this work.

## Runtime and stopping

Up to seven single-thread search workers: three construction, three cyclic,
one recoloring. Load monitors pause work above 70% sampled machine CPU and
resume below 55%. The initial nine-worker phase recorded a brief 100% total
CPU sample during concurrent verification; concurrency and thresholds were
then reduced. These controls limit our workload; other applications prevent
a strict guarantee on instantaneous system-wide CPU utilization.
Search cutoff: **6 November 08:25 Korea time (5 November 23:25 UTC)**.
Automatic final consolidation: **08:30 Korea time**. Both precede the user's
four-hour deadline of approximately 08:41 Korea time. No scheduled recurrence,
publication, or GitHub push was installed.

To stop this session's jobs and consolidate early, run `python3 stop.py`
from this directory. Runtime controls and PIDs are in each subdirectory's logs.
'''
    (ROOT/'REPORT.md').write_text(text)
    (out/'summary.json').write_text(json.dumps({'time_utc':now,'state':state,'improved_sizes':len(rows),'total_gain':sum(r['gain'] for r in rows),'certificate_sha256':hashlib.sha256((out/'certs.json').read_bytes()).hexdigest()},indent=2)+'\n')
    print(json.dumps({'improved_sizes':len(rows),'total_gain':sum(r['gain'] for r in rows),'verification':'both passed'}),flush=True)

if __name__=='__main__':main()
