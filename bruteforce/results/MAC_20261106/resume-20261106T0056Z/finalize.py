#!/usr/bin/env python3
"""Verify and report only new gains relative to the completed first Mac run."""
import argparse,datetime,hashlib,json,os,pathlib,subprocess,sys,time
P=pathlib.Path(__file__).resolve().parent
def main():
    ap=argparse.ArgumentParser();ap.add_argument('--wait-until',type=float);ap.add_argument('--final',action='store_true');args=ap.parse_args()
    if args.wait_until:
        while time.time()<args.wait_until and not (P/'STOP').exists():time.sleep(5)
        if (P/'STOP').exists():time.sleep(90)
    end=time.time()+300
    base=json.loads((P/'constructions/baseline.json').read_text());best={};sources={};raws={}
    for pattern in ['constructions/best/*.json','recolor/best/*.json']:
        for f in P.glob(pattern):
            raw=f.read_bytes();sha=hashlib.sha256(raw).hexdigest()
            for n,E in json.loads(raw).items():
                if not 13<=int(n)<=128 or len(E)<=len(best.get(n,base.get(n,[]))):continue
                best[n]=E;raws[sha]=raw;sources[n]={'path':str(f.relative_to(P)),'sha256':sha,'snapshot':f'sources/{sha}.json'}
    out=P/'verified';out.mkdir(exist_ok=True);(out/'sources').mkdir(exist_ok=True)
    for sha,raw in raws.items():(out/'sources'/f'{sha}.json').write_bytes(raw)
    tmp=out/f'pending-{os.getpid()}.json';tmp.write_text(json.dumps(best)+'\n')
    native=[]
    for n,E in sorted(best.items(),key=lambda z:int(z[0])):
        assert time.time()<end,'verification deadline'
        data=f'{n} {len(E)}\n'+''.join(f'{u} {v} {c}\n' for u,v,c in E)
        r=subprocess.run([str(P/'constructions/fourset_check')],input=data,text=True,capture_output=True,check=True,timeout=max(1,min(30,end-time.time())))
        native.append(r.stdout.strip())
    r=subprocess.run([sys.executable,str(P/'constructions/src/certcheck.py'),str(tmp)],capture_output=True,text=True,check=True,timeout=max(1,end-time.time()))
    assert native==r.stdout.strip().splitlines(),'checker counts disagree'
    tmp.replace(out/'certs.json');(out/'fourset-check.txt').write_text('\n'.join(native)+'\n');(out/'independent-check.txt').write_text(r.stdout)
    (out/'sources.json').write_text(json.dumps(sources,indent=2)+'\n')
    rows=[{'n':int(n),'previous':len(base[n]),'edges':len(E),'gain':len(E)-len(base[n])} for n,E in sorted(best.items(),key=lambda z:int(z[0]))]
    (out/'improvements.json').write_text(json.dumps(rows,indent=2)+'\n')
    now=datetime.datetime.now(datetime.timezone.utc).isoformat();state='Final checkpoint' if args.final else 'Running; verified checkpoint'
    summary={'updated_utc':now,'state':state,'new_improved_sizes':len(rows),'total_gain':sum(r['gain'] for r in rows),'certificates_sha256':hashlib.sha256((out/'certs.json').read_bytes()).hexdigest()}
    (out/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    text=f'''# Erdős 810: resumed Mac search

{state}. Updated {now}.

Continued from the completed first Mac run (66 improved sizes). This run
counts only gains beyond that final verified checkpoint. Earlier results,
including the certified 43-vertex cyclic optimum, are preserved unchanged.

**{len(rows)} newly improved sizes**, all verified by independent C four-set
and Python common-neighbor cycle enumerations with identical counts.
Certificates and immutable source snapshots are in [verified/](verified/).

| Vertices | Previous bound | New bound | Gain |
|---:|---:|---:|---:|
'''
    text+=''.join(f"| {r['n']} | {r['previous']} | {r['edges']} | +{r['gain']} |\n" for r in rows)
    text+='''
## Search changes

- One-vertex SAT search now caches exhausted identical neighborhoods and
  explores valid equal-edge-count rearrangements to escape local optima.
- Deletion/recoloring retains equal-count intermediate graphs in private
  search chains. Only strict independently checked gains are published.
- The 56-vertex cyclic search resumes after 327 prior checked leaves.
  Explicit proof-checker timeouts are UNKNOWN and trigger subdivision;
  invalid proofs still halt. [Run notes](cyclic/RUN-NOTES.md),
  [live status](cyclic/boost-20261106T0339Z/logs/background-status.json),
  [automatic cyclic report](cyclic/boost-20261106T0339Z/REPORT.md).

These are construction lower bounds and restricted-family searches.
Unrestricted Erdős 810 remains unresolved by this work.

## Resource limits

Up to fourteen single-thread workers: four construction, nine cyclic,
and one recoloring. The construction controller pauses one worker at a time above 91% sampled
total CPU and resumes below 88%; the cyclic guard pauses above 93% and
resumes below 86%. Recoloring uses a 90%/85% guard. This targets high
utilization with less disruption than pausing whole pools. This expansion was requested at 12:32 KST. A disk
allowance that had stopped the cyclic search was raised, and explicit
coverage checks prevent silent early completion. Other applications prevent
a strict instantaneous system-wide CPU cap.

Search cutoff: **6 November 2026, 13:40 KST / 04:40 UTC**.
Final consolidation: **13:45 KST**, with verification capped at five minutes.
The cyclic and recoloring audits have a **13:50 KST / 04:50 UTC** deadline.
This is within the renewed four-hour compute budget from about 09:56 KST.

Stop early with `python3 stop.py` in this directory. Final reports are
written automatically without another model session. No recurring schedule
or publication is configured.
'''
    (P/'REPORT.md').write_text(text);print(json.dumps(summary),flush=True)
if __name__=='__main__':main()
