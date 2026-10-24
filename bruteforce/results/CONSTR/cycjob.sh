#!/bin/bash
cd "$(dirname "$0")"
./cyc $1 $2 $3 runs/cyc/c$1_s$2.txt ${4:-1} > logs/cyc$1_s$2.out 2> logs/cyc$1_s$2.log
