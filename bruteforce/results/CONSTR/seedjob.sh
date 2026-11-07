#!/bin/bash
# seedjob.sh n mode seed secs
cd "$(dirname "$0")"
python3 seed.py $1 $2 runs/start_${2}$1.txt > /dev/null || exit
case $2 in add) L=v;; del) L=w;; best) L=b;; esac
./ls $1 ALL $3 $4 runs/gen/${L}$1_s$3.txt runs/start_${2}$1.txt > logs/${L}$1_s$3.out 2> logs/${L}$1_s$3.log
