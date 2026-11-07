#!/usr/bin/env python3
"""Bounded unattended continuation; writes its own final evidence report."""
import collections, datetime, gzip, hashlib, json, os, pathlib, signal, subprocess, sys, time

os.environ['CYC_N']='56'
os.environ['CYC_DEADLINE']=str(datetime.datetime(2026,11,6,10,20,tzinfo=datetime.timezone.utc).timestamp())
import resume_native as native
R=native.R; SRC=pathlib.Path(__file__).resolve().parent; START=time.time()
AUDIT_DEADLINE=datetime.datetime(2026,11,6,10,28,tzinfo=datetime.timezone.utc).timestamp()
STATUS=R/'logs/background-status.json'

def utc(): return datetime.datetime.now(datetime.timezone.utc).isoformat()
def read_rows(path):
    if not path.exists(): return []
    out=[]
    for line in path.read_text().splitlines():
        if line.strip():
            try: out.append(json.loads(line))
            except json.JSONDecodeError: pass # unfinished append; retried next heartbeat
    return out

def status(phase,**extra):
    rows=read_rows(R/'logs/new-leaves.jsonl')
    result={'updated_utc':utc(),'phase':phase,'pid':os.getpid(),'started_epoch':START,'compute_deadline_utc':'2026-11-06T10:20:00+00:00','audit_deadline_utc':'2026-11-06T10:28:00+00:00','new_records':len(rows),'results':dict(collections.Counter(r['res'] for r in rows)),'new_verified_leaves':sum(r.get('res')=='UNSAT' and r.get('check')=='s VERIFIED UNSAT' for r in rows),'stop_file':str(R/'STOP'),**extra}
    temp=STATUS.with_suffix('.tmp');temp.write_text(json.dumps(result,indent=2)+'\n');temp.replace(STATUS)

def stop(signum,frame): (R/'STOP').touch()
signal.signal(signal.SIGTERM,stop); signal.signal(signal.SIGINT,stop)

def phase(name,args):
    with (R/f'logs/{name}.log').open('a') as log:
        proc=subprocess.Popen([sys.executable,str(SRC/'resume_native.py')]+args,stdout=log,stderr=subprocess.STDOUT,env=os.environ.copy())
        termination_sent=False
        while proc.poll() is None:
            status(name,runner_pid=proc.pid)
            if time.time()>native.DEADLINE+10:
                (R/'STOP').touch()
                if not termination_sent: proc.terminate();termination_sent=True
            if time.time()>native.DEADLINE+30:
                proc.kill();proc.wait(timeout=10);break
            time.sleep(5)
        status(name+'_finished',returncode=proc.returncode)
        return proc.returncode

def coverage(include_history=True):
    historical=[]
    for path in native.history_paths():
        historical.extend(r for r in read_rows(path) if r.get('n',56)==56 and r.get('k',14)==14)
    snapshot=R/'logs/historical-seed.jsonl'
    snapshot.write_text(''.join(json.dumps(r)+'\n' for r in historical))
    logs=([str(snapshot)] if include_history else [])+[str(R/'logs/new-leaves.jsonl')]
    if not (R/'logs/new-leaves.jsonl').exists(): (R/'logs/new-leaves.jsonl').touch()
    command=[sys.executable,str(SRC/'closecheck.py'),'56','14',str(native.BASE),'--roots']+[','.join(c) for c in native.ROOTS]+['--logs']+logs
    result=subprocess.run(command,capture_output=True,text=True,timeout=30)
    name='final-closecheck.txt' if include_history else 'fresh-only-closecheck.txt'
    (R/'logs'/name).write_text(result.stdout+result.stderr)
    return result

def audit():
    rows=read_rows(R/'logs/new-leaves.jsonl');verified=[r for r in rows if r.get('res')=='UNSAT' and r.get('check')=='s VERIFIED UNSAT']
    checked=0; failed=[]
    for r in verified:
        if time.time()>AUDIT_DEADLINE: break
        try:
            assert r['solver_returncode']==20 and r['checker_returncode']==0
            assert native.cnf_digest(tuple(r['cube']))==r['cnf_sha256']
            h=hashlib.sha256();size=0
            with gzip.open(R/r['proof_gzip'],'rb') as f:
                while chunk:=f.read(1024*1024):
                    if time.time()>AUDIT_DEADLINE: raise TimeoutError('audit deadline')
                    h.update(chunk);size+=len(chunk)
            assert h.hexdigest()==r['proof_sha256'] and size==r['proof_bytes']
            assert (R/r['proof_gzip']).stat().st_size==r['proof_gzip_bytes']
            checked+=1
        except Exception as exc: failed.append({'cube':r['cube'],'error':repr(exc)})
    dg=json.loads((native.REPO/'bruteforce/results/CYC/C4/solutions.json').read_text())['56']
    ok,edges,cycles=native.check(56,dg);assert ok and edges==728
    cover=coverage(True);fresh=coverage(False)
    summary={'finished_utc':utc(),'new_verified_leaves':len(verified),'proof_hashes_checked':checked,'proof_hash_failures':failed,'all_new_proof_hashes_ok':checked==len(verified) and not failed,'mixed_history_coverage_exit':cover.returncode,'fresh_only_coverage_exit':fresh.returncode,'lower_bound_orbits':13,'lower_bound_edges':edges,'lower_bound_rainbow_four_cycles':cycles,'raw_proof_bytes':sum(r.get('proof_bytes',0) for r in verified),'compressed_proof_bytes':sum(r.get('proof_gzip_bytes',0) for r in verified),'sat_records':[r for r in rows if r['res']=='SAT'],'errors_or_unverified_unsat':[r for r in rows if r['res']=='ERROR' or (r['res']=='UNSAT' and r.get('check')!='s VERIFIED UNSAT')]}
    (R/'logs/final-audit.json').write_text(json.dumps(summary,indent=2)+'\n')
    conclusion='The cyclic-family optimum is 13 (728 edges), with fresh retained checked proofs for the complete upper bound.' if fresh.returncode==0 and summary['all_new_proof_hashes_ok'] else 'This is a partial continuation; no complete new cyclic-family optimum is claimed.'
    report=f'''# Cyclic n = 56 continuation\n\nFinished {summary['finished_utc']}.\n\n{conclusion}\n\nThe known 13-orbit lower-bound certificate was checked directly: {edges} edges and {cycles} rainbow four-cycles. New verified UNSAT leaves: {len(verified)}. Retained proof archives: {summary['compressed_proof_bytes']} compressed bytes. Hash audits completed for {checked} proofs; failures: {len(failed)}.\n\nFull coverage including historical logs exits {cover.returncode}; fresh-only coverage exits {fresh.returncode}. Historical verdicts are trusted only in the former check; the prior local327 proofs were retained and audited in the previous run. See logs/final-closecheck.txt, logs/fresh-only-closecheck.txt, and logs/final-audit.json.\n\nNine workers run solvers/checkers sequentially, balanced across all open top-level roots. Sampling every 0.25 seconds pauses these process groups at 93% total CPU and resumes below 86%. The compute deadline was 10:20 UTC; final audit deadline 10:28 UTC, both within the user's 19:30 KST final deadline. A STOP file requests a graceful checkpoint. Proofs remain local under proofs/ and are not committed to Git.\n\nNo unrestricted Erdős #810 solution or upper bound on M(56) is claimed.\n'''
    (R/'REPORT.md').write_text(report)
    status('finished',summary=summary)

try:
    status('starting')
    if phase('controls',['--controls'])!=0: raise RuntimeError('controls failed')
    while True:
        before=len(read_rows(R/'logs/new-leaves.jsonl'))
        phase('search',[])
        mixed=coverage(True)
        after=len(read_rows(R/'logs/new-leaves.jsonl'))
        if (R/'logs/search-exit.json').exists() and json.loads((R/'logs/search-exit.json').read_text()).get('reason')=='unresolved_terminal': break
        if mixed.returncode!=1 or time.time()>=native.DEADLINE-15 or native.stop_requested() or native.disk_bytes()>=native.DISK_LIMIT-500_000_000: break
        if after==before: raise RuntimeError('incomplete coverage with no search progress; checkpoint preserved')
        status('continuing_incomplete_coverage')
    if mixed.returncode==0 and time.time()<native.DEADLINE-600 and not native.stop_requested(): phase('historical-replay',['--replay-history'])
    status('auditing');audit()
except Exception as exc:
    (R/'STOP').touch();status('error',error=repr(exc))
    (R/'REPORT.md').write_text(f'# Cyclic n = 56 continuation\n\nInterrupted with {exc!r} at {utc()}. No new complete upper bound is claimed. Inspect logs/ for retained checkpoint records.\n')
    raise
