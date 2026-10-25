#!/bin/bash
# Restart of pass 1 for n = 84, 94 from certifiable k (pass1.sh had k_lo = floor(n/4) - 2 uncertified).
cd "$(dirname "$0")/.."
python3 src/drive.py 84 16 1500 > logs/drive84.out 2>&1
python3 src/drive.py 94 18 1500 > logs/drive94.out 2>&1
echo PASS1-DONE > logs/pass1.done
