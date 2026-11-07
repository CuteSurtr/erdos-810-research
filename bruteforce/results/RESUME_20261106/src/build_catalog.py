#!/usr/bin/env python3
"""Normalize the paper's certificate sources, including cyclic offset files.

Run from the repository root. Reuses only the paper's read-only loader;
never calls its table-writing main function. Checks every selected graph
with the independent C four-set checker before saving the catalog.
"""
import argparse
import hashlib
import importlib.util
import json
import pathlib
import subprocess
import sys

ap=argparse.ArgumentParser()
ap.add_argument('output');ap.add_argument('--checker',required=True)
args=ap.parse_args()
sys.dont_write_bytecode=True
spec=importlib.util.spec_from_file_location('paper_tables','paper/make_tables.py')
module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
best={}
for n,E,task,path in module.load_all():
    if n not in best or len(E)>len(best[n][0]):best[n]=(E,path)
certs={};sources={};checks=[]
for n,(E,path) in sorted(best.items()):
    data=f'{n} {len(E)}\n'+''.join(f'{a} {b} {c}\n' for a,b,c in E)
    run=subprocess.run([args.checker],input=data,text=True,capture_output=True,check=True)
    p=pathlib.Path('bruteforce/results')/path
    certs[str(n)]=E;sources[str(n)]={'file':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()}
    checks.append(run.stdout.strip())
out=pathlib.Path(args.output);out.mkdir(parents=True,exist_ok=True)
(out/'base-catalog.json').write_text(json.dumps(certs)+'\n')
(out/'base-catalog-sources.json').write_text(json.dumps(sources,indent=2)+'\n')
(out/'base-catalog-checks.txt').write_text('\n'.join(checks)+'\n')
print('Normalized and checked',len(certs),'sizes')
