#!/bin/bash
# Main run: shards r = 2 mod 4 of geng -q 12 41:41 r/512, 4 in parallel.
# Appends "r graphs bad_by_clique bad_by_search good wall_s" to shards.tsv.
G=/tmp/claude-0/nb/pynauty-2.8.8.1/src/nauty2_8_8/geng
cd "$(dirname "$0")"
[ -f shards.tsv ] || printf 'r\tgraphs\tbad_by_clique\tbad_by_search\tgood\twall_s\n' > shards.tsv
one() {
  r=$1
  grep -q "^$r	" shards.tsv && return 0
  s=$(date +%s.%N)
  $G -q 12 41:41 $r/512 | ./src/checker 12 > logs/good_$r.txt 2> logs/cnt_$r.txt
  st=("${PIPESTATUS[@]}")
  w=$(echo "$(date +%s.%N) - $s" | bc)
  read -r tag g a b c rest < logs/cnt_$r.txt
  if [ "${st[0]}" != 0 ] || [ "${st[1]}" != 0 ] || [ "$tag" != COUNTS ]; then echo "shard $r FAILED ${st[*]}" >> logs/errors.txt; return 1; fi
  flock shards.tsv -c "printf '%s\t%s\t%s\t%s\t%s\t%.1f\n' $r $g $a $b $c $w >> shards.tsv"
}
export -f one; export G
seq 2 4 510 | xargs -P 4 -I{} bash -c 'one {}'
echo DONE > logs/done
