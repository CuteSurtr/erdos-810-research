#!/bin/bash
grep -h FOUND logs/*.log 2>/dev/null | sed -E 's/.*n=([0-9]+) e=([0-9]+).*/\1 \2/' | sort -n -k1,1 -k2,2 | awk '{m[$1]=$2} END{for(k in m)print k,m[k]}' | sort -n | tr '\n' ' '; echo
