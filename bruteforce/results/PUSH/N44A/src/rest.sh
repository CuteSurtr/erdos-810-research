#!/bin/bash
while kill -0 3616 2>/dev/null; do sleep 10; done
(printf "1,2,3,4,5,6,7,8\n1,2,3,4,5,6,-7,8\n1,2,3,4,5,6,-7,-8\n"; for a in 6 -6; do for b in 7 -7; do for c in 8 -8; do echo "1,2,3,4,-5,$a,$b,$c"; done; done; done; printf -- "-1\n1,-2,3,4\n1,-2,3,-4\n1,-2,-3,4\n1,-2,-3,-4\n1,2,-3,-4\n") | xargs -P2 -I{} src/dratleaf.sh {}
