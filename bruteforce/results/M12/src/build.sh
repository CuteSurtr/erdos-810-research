#!/bin/sh
# NAUTY = nauty 2.8.8 source dir (taken from the pynauty-2.8.8.1 sdist on PyPI), already ./configure'd and 'make geng' run
NAUTY=${NAUTY:-/tmp/claude-0/-home-user-erdos-810-research/ee2935bc-ec46-5a29-b298-d5d3825fe750/scratchpad/nauty/pynauty-2.8.8.1/src/nauty2_8_8}
set -e
cd "$(dirname "$0")"
gcc -O3 -march=native -o filt filt.c
gcc -O3 -march=native -I$NAUTY -o geng_prune -DMAXN=WORDSIZE -DWORDSIZE=32 -DPRUNE=qprune -DSUMMARY=qsummary \
   $NAUTY/geng.c prune810m.c $NAUTY/gtoolsW.o $NAUTY/nautyW1.o $NAUTY/nautilW1.o $NAUTY/naugraphW1.o $NAUTY/schreier.o $NAUTY/naurng.o
cp $NAUTY/geng ./geng_plain
gcc -O3 -march=native -I$NAUTY -o geng_pruneb -DMAXN=WORDSIZE -DWORDSIZE=32 -DPRUNE=qpruneb -DSUMMARY=qsummaryb $NAUTY/geng.c prune810b.c $NAUTY/gtoolsW.o $NAUTY/nautyW1.o $NAUTY/nautilW1.o $NAUTY/naugraphW1.o $NAUTY/schreier.o $NAUTY/naurng.o
