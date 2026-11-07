#!/bin/bash
cd "$(dirname "$0")"
./ls $1 ALL $2 $3 runs/small/s$1_s$2.txt runs/small/start$1.txt > logs/small$1_s$2.out 2> logs/small$1_s$2.log
