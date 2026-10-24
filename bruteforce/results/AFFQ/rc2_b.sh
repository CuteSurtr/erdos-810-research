#!/bin/sh
for j in "a2 17" "a2 19" "a3 17"; do timeout 2400 python3 exact_rc2.py $j; done
