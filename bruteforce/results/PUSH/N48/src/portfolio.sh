#!/bin/sh
# 30-min portfolio on the full n=48, k=12 sym=3 CNF (no cube)
W=/tmp/claude-0/w; B=/tmp/claude-0/b; L=$(dirname "$0")/../logs; T=1800
python3 $(dirname "$0")/leaf.py 48 12 $T "" 1 > $L/portfolio_cadical_drat.jsonl &
python3 $(dirname "$0")/leaf.py 48 12 $T "" 0 "--unsat --seed=2" > $L/portfolio_cadical_unsat.jsonl &
( timeout $T $B/kissat/build/kissat -q $W/c_48_12_3.cnf; echo "kissat default exit $?" ) > $L/portfolio_kissat.txt 2>&1 &
( timeout $T $B/kissat/build/kissat -q --sat --seed=1 $W/c_48_12_3.cnf; echo "kissat --sat exit $?" ) > $L/portfolio_kissat_sat.txt 2>&1 &
wait
