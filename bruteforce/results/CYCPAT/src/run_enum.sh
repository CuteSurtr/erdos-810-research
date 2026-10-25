#!/bin/bash
# usage: run_enum.sh n k maxorbits timeout   -> runs/enum_n<n>_k<k>.json (+ .log)
cd "$(dirname "$0")/.."
python3 src/cycenum.py $1 $2 $3 $4 > runs/enum_n$1_k$2.json 2> runs/enum_n$1_k$2.log
