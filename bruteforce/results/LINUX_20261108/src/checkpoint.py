#!/usr/bin/env python3
"""Immutable live snapshot; does not stop either search or claim completion."""
import argparse,datetime,gzip,hashlib,json,os,pathlib,subprocess,sys,time

R=pathlib.Path(__file__).resolve().parents[1]
C=json.loads((R/'config.json').read_text())
os.sched_setaffinity(0,{30})
os.environ.update(ERDOS_CADICAL=C['cadical'],CYC_N='56',
 CYC_DEADLINE=str(datetime.datetime.fromisoformat(C['compute_deadline_utc']).timestamp()))
sys.path.insert(0,str(R/'cyclic/src'))
import resume_native as native

def main():
    ap=argparse.ArgumentParser();ap.add_argument('label');ap.add_argument('--hash-proofs',action='store_true');args=ap.parse_args()
    if not args.label.replace('-','').isalnum():raise ValueError('use an alphanumeric label')
    dest=R/'verified'/args.label;dest.mkdir(exist_ok=False)
    base=json.loads((R/'constructions/baseline.json').read_text());best={}
    for p in sorted((R/'constructions/best').glob('*.json')):
        for n,E in json.loads(p.read_text()).items():
            if len(E)>len(base[n]) and len(E)>len(best.get(n,[])):best[n]=E
    (dest/'certs.json').write_text(json.dumps(best)+'\n')
    checks=[]
    for n,E in sorted(best.items(),key=lambda x:int(x[0])):
        data=f'{n} {len(E)}\n'+''.join(f'{a} {b} {c}\n' for a,b,c in E)
        z=subprocess.run([str(R/'constructions/fourset_check')],input=data,text=True,capture_output=True,check=True)
        checks.append(z.stdout.strip())
    (dest/'fourset-check.txt').write_text('\n'.join(checks)+('\n' if checks else ''))
    with (dest/'independent-check.txt').open('w') as f:
        subprocess.run(['taskset','-c','31',sys.executable,str(R/'constructions/src/certcheck.py'),str(dest/'certs.json')],stdout=f,check=True,timeout=60)
    assert (dest/'fourset-check.txt').read_bytes()==(dest/'independent-check.txt').read_bytes()
    raw=(R/'cyclic/logs/new-leaves.jsonl').read_bytes()
    # A concurrently appended final record may be incomplete; leave it for the
    # next snapshot. Preserve all complete lines byte-for-byte.
    raw=raw[:raw.rfind(b'\n')+1]
    (dest/'new-leaves.jsonl').write_bytes(raw)
    rows=[json.loads(l) for l in raw.splitlines() if l.strip()]
    verified=[x for x in rows if x.get('check')=='s VERIFIED UNSAT']
    hashed=0
    for x in verified:
        assert x['res']=='UNSAT' and x['solver_returncode']==20 and x['checker_returncode']==0
        assert native.cnf_digest(tuple(x['cube']))==x['cnf_sha256']
        if args.hash_proofs:
            h=hashlib.sha256();size=0
            with gzip.open(R/'cyclic'/x['proof_gzip'],'rb') as f:
                while b:=f.read(1024*1024):h.update(b);size+=len(b)
            assert h.hexdigest()==x['proof_sha256'] and size==x['proof_bytes'];hashed+=1
    cmd=[sys.executable,str(R/'cyclic/src/closecheck.py'),'56','14',str(native.BASE),'--roots']
    cmd +=[','.join(c) for c in native.ROOTS]+['--logs']+[str(p) for p in native.history_paths()]+[str(dest/'new-leaves.jsonl')]
    z=subprocess.run(cmd,text=True,capture_output=True,timeout=60)
    (dest/'closecheck.txt').write_text(z.stdout+z.stderr)
    updates=[{'n':int(n),'before':len(base[n]),'after':len(E),'gain':len(E)-len(base[n])} for n,E in sorted(best.items(),key=lambda x:int(x[0]))]
    summary={'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'phase':'live_snapshot',
        'improvements':updates,'total_edge_gain':sum(x['gain'] for x in updates),
        'new_verified_leaves':len(verified),'proof_hashes_checked':hashed,'coverage_exit':z.returncode,
        'new_log_sha256':hashlib.sha256(raw).hexdigest(),'certs_sha256':hashlib.sha256((dest/'certs.json').read_bytes()).hexdigest(),
        'historical_proofs_replayed_here':False,'searches_still_authorized_until':C['compute_deadline_utc']}
    (dest/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
    print(json.dumps(summary));print(z.stdout)

if __name__=='__main__':main()
