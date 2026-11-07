#!/usr/bin/env python3
"""Freeze graph gains and audit this run's retained cyclic proofs."""
import datetime,gzip,hashlib,json,os,pathlib,subprocess,sys,time
R=pathlib.Path(__file__).resolve().parents[1];REPO=R.parents[2]
C=json.loads((R/'config.json').read_text())
controller_status=json.loads((R/'logs/status.json').read_text())
deadline=datetime.datetime.fromisoformat(C['audit_deadline_utc']).timestamp()
os.sched_setaffinity(0,{30})
sys.path.insert(0,str(R/'cyclic/src'))
import resume_native as native
base=json.loads((R/'constructions/baseline.json').read_text());best={};sources={}
for p in sorted((R/'constructions/best').glob('*.json')):
    for n,E in json.loads(p.read_text()).items():
        if len(E)>len(base.get(n,[])) and len(E)>len(best.get(n,[])):
            best[n]=E;sources[n]={'path':str(p.relative_to(R)),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()}
checks=[]
for n,E in sorted(best.items(),key=lambda x:int(x[0])):
    data=f'{n} {len(E)}\n'+''.join(f'{a} {b} {c}\n' for a,b,c in E)
    result=subprocess.run([str(R/'constructions/fourset_check')],input=data,text=True,capture_output=True,check=True)
    checks.append(result.stdout.strip())
(R/'verified/certs.json').write_text(json.dumps(best)+'\n')
(R/'verified/fourset-check.txt').write_text('\n'.join(checks)+('\n' if checks else ''))
(R/'verified/sources.json').write_text(json.dumps(sources,indent=2)+'\n')
with (R/'verified/independent-check.txt').open('w') as log:
    subprocess.run(['taskset','-c','31',sys.executable,str(R/'constructions/src/certcheck.py'),str(R/'verified/certs.json')],
        stdout=log,check=True,timeout=max(1,min(180,deadline-time.time())))
assert (R/'verified/fourset-check.txt').read_text()==(R/'verified/independent-check.txt').read_text()
updates=[{'n':int(n),'before':len(base[n]),'after':len(E),'gain':len(E)-len(base[n])} for n,E in sorted(best.items(),key=lambda x:int(x[0]))]
(R/'verified/improvements.json').write_text(json.dumps(updates,indent=2)+'\n')
log=R/'cyclic/logs/new-leaves.jsonl';log.touch(exist_ok=True)
rows=[json.loads(l) for l in log.read_text().splitlines() if l.strip()]
verified=[r for r in rows if r.get('res')=='UNSAT' and r.get('check')=='s VERIFIED UNSAT']
checked=0;errors=[];proof_budget_exhausted=False
# Reserve time for coverage and reporting even if the retained archives
# exceed the time available for a full hash pass.
proof_deadline=deadline-90
for rec in verified:
    if time.time()>=proof_deadline:proof_budget_exhausted=True;break
    try:
        assert native.cnf_digest(tuple(rec['cube']))==rec['cnf_sha256']
        assert rec['solver_returncode']==20 and rec['checker_returncode']==0
        h=hashlib.sha256();size=0
        with gzip.open(R/'cyclic'/rec['proof_gzip'],'rb') as f:
            while chunk:=f.read(1024*1024):
                if time.time()>=proof_deadline:raise TimeoutError('proof audit time budget')
                h.update(chunk);size+=len(chunk)
        assert size==rec['proof_bytes'] and h.hexdigest()==rec['proof_sha256']
        checked+=1
    except TimeoutError:proof_budget_exhausted=True;break
    except Exception as exc:errors.append({'cube':rec['cube'],'error':repr(exc)})
cmd=[sys.executable,str(R/'cyclic/src/closecheck.py'),'56','14',str(native.BASE),'--roots']
cmd +=[','.join(c) for c in native.ROOTS]+['--logs']+[str(p) for p in native.history_paths()]+[str(log)]
coverage=subprocess.run(cmd,text=True,capture_output=True,timeout=max(1,min(60,deadline-time.time()-5)))
(R/'cyclic/logs/final-closecheck.txt').write_text(coverage.stdout+coverage.stderr)
summary={'finished_utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'improved_sizes':len(best),
    'worker_exit_status':controller_status.get('jobs',{}),
    'total_edge_gain':sum(x['gain'] for x in updates),'new_verified_leaves':len(verified),'proof_hashes_checked':checked,
    'proof_hash_audit_budget_exhausted':proof_budget_exhausted,
    'proof_errors':errors,'coverage_exit':coverage.returncode,'historical_proofs_replayed_here':False,
    'new_compressed_proof_bytes':sum(x.get('proof_gzip_bytes',0) for x in verified),
    'sat_records':[r for r in rows if r.get('res')=='SAT'],
    'errors_or_unverified_unsat':[r for r in rows if r.get('res')=='ERROR' or (r.get('res')=='UNSAT' and r.get('check')!='s VERIFIED UNSAT')]}
(R/'logs/final-summary.json').write_text(json.dumps(summary,indent=2)+'\n')
table='\n'.join(f"| {u['n']} | {u['before']} | {u['after']} | +{u['gain']} |" for u in updates)
report=f'''# Linux computation checkpoint, 8 November 2026

Finished {summary['finished_utc']}. Searches are stopped.

{len(best)} strict construction improvements, totaling {summary['total_edge_gain']} edges
across the table, passed both independent graph checkers. These are lower
bounds relative to the merged November 7 baseline including pendant padding.
No published-record or exact-value claim is made.

| n | Previous bound | New bound | Gain |
|---|---:|---:|---:|
{table}

The n=56 cyclic continuation added {len(verified)} checked UNSAT leaves.
Retained-proof hash audit: {checked} of {len(verified)} checked, {len(errors)} errors.
Hash-audit time budget exhausted: {proof_budget_exhausted}.
Combined coverage exit: {coverage.returncode}; zero means complete coverage.
New SAT records: {len(summary['sat_records'])}; their witness checks are retained
in the summary and must be inspected before using a positive result.
Earlier Mac proof archives were not copied or replayed here. Their recorded
verdicts are trusted only after matching leaf CNF hashes. Full proof replay
requires those earlier archives in addition to this run's local proofs.

The source of truth is `logs/final-summary.json`, with the coverage report
in `cyclic/logs/final-closecheck.txt`. No unrestricted #810 solution is claimed.
Worker exit codes are retained in the summary; -15 can be the planned
SIGTERM at the search cutoff. Other unexpected exits require inspecting
the worker logs even when all saved certificates pass verification.
'''
(R/'FINAL-COMPUTE-REPORT.md').write_text(report)
print(json.dumps(summary),flush=True)
if errors or checked!=len(verified) or summary['errors_or_unverified_unsat']:raise SystemExit(1)
