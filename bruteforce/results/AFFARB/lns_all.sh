#!/bin/bash
# LNS polish over primes, k=3 free slopes, 20s steps
for p in "$@"; do python3 lns.py $p 240 20 3 1; done
