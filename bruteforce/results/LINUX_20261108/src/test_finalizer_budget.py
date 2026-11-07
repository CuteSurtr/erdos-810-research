#!/usr/bin/env python3
"""Isolated finalizer control-flow test; synthetic proofs are NOT proof evidence."""
import datetime,gzip,hashlib,json,pathlib,shutil,subprocess,sys,tempfile
R=pathlib.Path(__file__).resolve().parents[1]
base=json.loads((R/'constructions/baseline.json').read_text())
n=min(base,key=int);edges=base[n]
results=[]
for label,seconds,expected_hashes,expected_rc in [('full',240,2,0),('exhausted',60,0,1)]:
    with tempfile.TemporaryDirectory(prefix='erdos810-finalizer-test-') as tmp:
        root=pathlib.Path(tmp)/'repo/bruteforce/results/CONTROL'
        for d in ['src','logs','verified','constructions/best','constructions/src',
                  'cyclic/src','cyclic/logs','cyclic/proofs']:
            (root/d).mkdir(parents=True,exist_ok=True)
        shutil.copy2(R/'src/finalize.py',root/'src/finalize.py')
        shutil.copy2(R/'constructions/fourset_check',root/'constructions/fourset_check')
        shutil.copy2(R/'constructions/src/certcheck.py',root/'constructions/src/certcheck.py')
        deadline=datetime.datetime.now(datetime.timezone.utc)+datetime.timedelta(seconds=seconds)
        (root/'config.json').write_text(json.dumps({'audit_deadline_utc':deadline.isoformat()}))
        (root/'logs/status.json').write_text(json.dumps({'jobs':{'synthetic':{'returncode':0}}}))
        (root/'constructions/baseline.json').write_text(json.dumps({n:edges[:-1]}))
        (root/f'constructions/best/{n}.json').write_text(json.dumps({n:edges}))
        (root/'cyclic/src/resume_native.py').write_text(
            "BASE='synthetic.cnf'\nROOTS=[()]\ndef history_paths():return []\n"
            "def cnf_digest(cube):return 'synthetic-cnfh'\n")
        (root/'cyclic/src/closecheck.py').write_text("print('SYNTHETIC coverage control only')\n")
        records=[]
        for k in range(2):
            data=f'synthetic proof {k}\n'.encode();proof=f'proofs/{k}.gz'
            with gzip.open(root/'cyclic'/proof,'wb') as f:f.write(data)
            records.append({'res':'UNSAT','check':'s VERIFIED UNSAT','cube':[str(k+1)],
                'cnf_sha256':'synthetic-cnfh','solver_returncode':20,'checker_returncode':0,
                'proof_gzip':proof,'proof_bytes':len(data),'proof_sha256':hashlib.sha256(data).hexdigest()})
        (root/'cyclic/logs/new-leaves.jsonl').write_text(''.join(json.dumps(x)+'\n' for x in records))
        z=subprocess.run([sys.executable,str(root/'src/finalize.py')],capture_output=True,text=True,timeout=30)
        if z.returncode!=expected_rc:raise AssertionError((label,z.returncode,z.stderr,z.stdout))
        summary=json.loads((root/'logs/final-summary.json').read_text())
        assert summary['proof_hashes_checked']==expected_hashes
        assert summary['proof_hash_audit_budget_exhausted']==(label=='exhausted')
        assert not summary['proof_errors'] and summary['improved_sizes']==1
        assert (root/'FINAL-COMPUTE-REPORT.md').is_file()
        assert (root/'cyclic/logs/final-closecheck.txt').is_file()
        results.append({'case':label,'returncode':z.returncode,'proof_hashes_checked':expected_hashes,
            'report_and_coverage_saved':True,'live_searches_affected':False})
out={'utc':datetime.datetime.now(datetime.timezone.utc).isoformat(),'status':'PASS','cases':results,
     'scope':'isolated synthetic proof-budget control flow; real graph checkers; no SAT proof assertion',
     'finalizer_sha256':hashlib.sha256((R/'src/finalize.py').read_bytes()).hexdigest()}
(R/'logs/finalizer-control.json').write_text(json.dumps(out,indent=2)+'\n')
print(json.dumps(out))
