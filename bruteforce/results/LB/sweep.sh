#!/bin/bash
# sweep.sh TAG SECONDS n1 n2 ... : one ls810 run per n (seed = n + 1000*TAG), 4 in parallel
tag=$1; t=$2; shift 2
mkdir -p out logs
printf '%s\n' "$@" | xargs -P4 -I{} sh -c "./ls810 {} 1 \$(( {} + 1000*$tag )) $t out/r$tag > logs/r${tag}_n{}.log 2>&1"
