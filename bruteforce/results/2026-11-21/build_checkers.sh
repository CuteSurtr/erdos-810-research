#!/bin/sh
# Usage: sh build_checkers.sh /path/to/configured/nauty2_8_9 /path/to/output
set -eu
nauty=$(cd "$1" && pwd)
here=$(cd "$(dirname "$0")" && pwd)
mkdir -p "$2"
out=$(cd "$2" && pwd)
make -C "$nauty" geng

build() {
    "${CC:-cc}" -O3 -I"$nauty" -DMAXN=WORDSIZE -DWORDSIZE=32 \
        -DPRUNE=complement_prune "-DBASE_PRUNE=$2" "-DSUMMARY=$3" \
        "$nauty/geng.c" "$here/complement_prune.c" "$here/../M12/src/$4.c" \
        "$nauty/gtoolsW.o" "$nauty/nautyW1.o" "$nauty/nautilW1.o" \
        "$nauty/naugraphW1.o" "$nauty/schreier.o" "$nauty/naurng.o" -o "$out/$1"
}

build rainbow-a qprune qsummary prune810m
build rainbow-b qpruneb qsummaryb prune810b
