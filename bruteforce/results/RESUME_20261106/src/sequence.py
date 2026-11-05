#!/usr/bin/env python3
"""Complete one root at a time, including mirror branches, within the wall deadline."""
import os
import pathlib
import subprocess
import sys
import time

src = pathlib.Path(__file__).resolve().parent
roots = ['1,-2,-3,4', '1,-2,3,-4', '1,2,-3,-4', '1,2,-3,4',
         '1,-2,3,4', '1,2,3,-4', '1,2,3,4']
for root in roots:
    if (src.parent / 'STOP').exists() or time.time() >= float(os.environ['CYC_DEADLINE']):
        break
    print(time.strftime('%Y-%m-%d %H:%M:%S UTC', time.gmtime()), 'START', root, flush=True)
    proc = subprocess.run([sys.executable, str(src / 'tree.py'), '56', '14', '400', '2', root])
    if proc.returncode:
        raise SystemExit(proc.returncode)
    print(time.strftime('%Y-%m-%d %H:%M:%S UTC', time.gmtime()), 'FINISH', root, flush=True)
