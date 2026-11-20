#!/bin/sh
# Build against a configured nauty 2.8.9 tree. Optional argument 3 is CaDiCaL 2.1.3.
set -eu
nauty=$(cd "$1" && pwd)
here=$(cd "$(dirname "$0")" && pwd)
mkdir -p "$2"
out=$(cd "$2" && pwd)
cadical=
if [ -n "${3:-}" ]; then cadical=$(cd "$3" && pwd); fi
make -C "$nauty" geng nauty.a
cd "$out"
cc_bin=${CC:-cc}
cxx_bin=${CXX:-c++}
"$cc_bin" -O3 -DWORDSIZE=32 -DMAXN=WORDSIZE -DPRUNE=anchor_prune -DSUMMARY=anchor_summary \
    -I"$nauty" -c "$nauty/geng.c" -o anchor_geng.o
"$cc_bin" -O3 -DWORDSIZE=32 -DMAXN=WORDSIZE -I"$nauty" -c "$here/anchor_hook.c" -o anchor_hook.o
"$cxx_bin" -O3 -std=c++17 -c "$here/coloring.cpp" -o coloring.o
"$cxx_bin" -O3 anchor_geng.o anchor_hook.o coloring.o "$nauty/gtoolsW.o" \
    "$nauty/nautyW1.o" "$nauty/nautilW1.o" "$nauty/naugraphW1.o" \
    "$nauty/schreier.o" "$nauty/naurng.o" -o rainbow-cover
"$cxx_bin" -O3 -std=c++17 "$here/check_graphs.cpp" coloring.o -o check-cover
"$cxx_bin" -O3 -std=c++17 "$here/extend_catalog.cpp" coloring.o -o extend-catalog
"$cxx_bin" -O3 -std=c++17 "$here/classify_proper.cpp" coloring.o -o classify-proper
"$cxx_bin" -O3 -std=c++17 "$here/count_colorings.cpp" -o count-colorings
"$cxx_bin" -O3 -std=c++17 "$here/repair_distance.cpp" -o repair-distance
"$cxx_bin" -O3 -std=c++17 "$here/extend_colored.cpp" -o extend-colored
"$cxx_bin" -O3 -std=c++17 "$here/spoke_walk.cpp" -o spoke-walk
"$cc_bin" -O3 -I"$nauty" -c "$here/orbit_group.c" -o orbit_group.o
"$cxx_bin" -O3 -std=c++17 "$here/burnside_count.cpp" orbit_group.o "$nauty/nauty.a" -o burnside-count
if [ -n "$cadical" ]; then
    "$cxx_bin" -O3 -std=c++17 -I"$cadical/src" "$here/deletion_spectrum.cpp" \
        coloring.o "$cadical/build/libcadical.a" -o deletion-spectrum
    "$cxx_bin" -O3 -std=c++17 -I"$cadical/src" "$here/audit_proper_sat.cpp" \
        "$cadical/build/libcadical.a" -o audit-proper-sat
fi
