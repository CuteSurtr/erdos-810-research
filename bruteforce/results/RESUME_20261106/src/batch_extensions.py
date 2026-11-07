#!/usr/bin/env python3
"""Try record-improving one-vertex extensions of existing certificates."""
import argparse
import json
import pathlib
import subprocess
import sys
import time

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument('output')
    ap.add_argument('--input',action='append',required=True)
    ap.add_argument('--minimum',type=int,default=12)
    ap.add_argument('--maximum',type=int,default=60)
    ap.add_argument('--cap',type=int,default=5)
    ap.add_argument('--per-size',type=int,default=15)
    args=ap.parse_args()
    best={}
    for pattern in args.input:
        for p in sorted(pathlib.Path('.').glob(pattern)):
            for key,E in json.loads(p.read_text()).items():
                if not key.isdigit() or not isinstance(E,list) or not E: continue
                if not all(isinstance(e,list) and len(e)==3 for e in E):continue
                n=int(key)
                if n not in best or len(E)>len(best[n][0]):best[n]=(E,str(p))
    output=pathlib.Path(args.output);output.mkdir(parents=True,exist_ok=True)
    log=output/'summary.jsonl'
    for n in range(args.minimum,args.maximum):
        if n not in best or n+1 not in best:continue
        E,source=best[n];old=len(best[n+1][0]);target=max(2,old+1-len(E))
        if target>n:continue
        dest=output/f'n{n+1}';dest.mkdir(exist_ok=True)
        base=dest/'input.json';base.write_text(json.dumps({str(n):E})+'\n')
        (dest/'source.txt').write_text(source+'\n')
        subprocess.run([sys.executable,str(pathlib.Path(__file__).with_name('extend_vertex.py')),
            str(base),str(n),str(dest),'--start',str(target),'--budget',str(args.per_size),
            '--cap',str(args.cap)],check=True)
        candidate=json.loads((dest/'certs.json').read_text())[str(n+1)]
        improved=len(candidate)>old
        if improved:best[n+1]=(candidate,str(dest/'certs.json'))
        rec={'n':n+1,'base_edges':len(E),'prior_best':old,'edges':len(candidate),
             'improved':improved,'time_utc':time.strftime('%H:%M:%S',time.gmtime())}
        with log.open('a') as f:f.write(json.dumps(rec)+'\n')
        print('SUMMARY',json.dumps(rec),flush=True)

if __name__=='__main__':main()
