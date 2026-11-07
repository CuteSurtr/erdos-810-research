#!/bin/bash
# job.sh label n allowed seed seconds [start]   -> runs/gen/<label>.txt, logs/<label>.log
cd "$(dirname "$0")"
./ls $2 $3 $4 $5 runs/gen/$1.txt $6 > logs/$1.out 2> logs/$1.log
