#!/usr/bin/env python3
"""Check retained proof hashes, logged CNF hashes, and independent cube coverage.

Every proof used by the final coverage check must be in the fresh local
log and retained as a gzip artifact. Historical leaves are first replayed.
Each proof was checked by drat-trim before its record was accepted.
"""
import gzip, hashlib, json, pathlib, subprocess, sys
from resume_native import R, SOURCE, ROOTS, BASE, cnf, check, REPO

rows=[json.loads(x) for x in (R/'logs/new-leaves.jsonl').read_text().splitlines() if x.strip()]
verified=[r for r in rows if r['res']=='UNSAT' and r.get('check')=='s VERIFIED UNSAT']
for r in verified:
    cube=tuple(map(str,r['cube']))
    assert hashlib.sha256(cnf(cube).encode()).hexdigest()==r['cnf_sha256']
    path=R/r['proof_gzip']; h=hashlib.sha256(); size=0
    with gzip.open(path,'rb') as f:
        while chunk:=f.read(1024*1024): h.update(chunk); size+=len(chunk)
    assert h.hexdigest()==r['proof_sha256'],path
    assert size==r['proof_bytes'],path
    assert path.stat().st_size==r['proof_gzip_bytes'],path
dg=json.loads((REPO/'bruteforce/results/CYC/C5/solutions.json').read_text())['43']
ok,edges,cycles=check(43,dg)
assert ok and len(dg)==10 and edges==430
(R/'logs/n43-lower-bound.json').write_text(json.dumps({'n':43,'orbits':dg,'orbit_count':10,'edges':edges,'rainbow_four_cycles':cycles},indent=2)+'\n')
command=[sys.executable,str(R/'src/closecheck.py'),'43','11',str(BASE),'--roots']+[','.join(c) for c in ROOTS]+['--logs',str(R/'logs/new-leaves.jsonl')]
out=subprocess.run(command,capture_output=True,text=True)
(R/'logs/final-closecheck.txt').write_text(out.stdout+out.stderr)
summary={'new_verified_leaves':len(verified),'new_records':len(rows),'raw_proof_bytes':sum(r['proof_bytes'] for r in verified),'compressed_proof_bytes':sum(r['proof_gzip_bytes'] for r in verified),'retained_proof_hashes_ok':True,'lower_bound_edges':edges,'lower_bound_four_cycles':cycles,'coverage_exit':out.returncode,'errors':[r for r in rows if r['res']=='ERROR' or (r['res']=='UNSAT' and r.get('check')!='s VERIFIED UNSAT')]}
(R/'logs/final-audit.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps(summary,indent=2)); print(out.stdout)
sys.exit(out.returncode)
