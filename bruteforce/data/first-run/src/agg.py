#!/usr/bin/env python3
"""Aggregate filt810 shard logs: agg.py DIR MOD"""
import sys, glob, re, os
d, mod = sys.argv[1], int(sys.argv[2])
tot = {}
done = 0
walls = []
for res in range(mod):
    tag = os.path.join(d, "s%d_%d" % (res, mod))
    if not os.path.exists(tag + ".done"):
        print("MISSING shard", res); continue
    done += 1
    for line in open(tag + ".log"):
        if line.startswith("wall="):
            walls.append(int(line.split("=")[1])); continue
        m = re.match(r"K=(\d+) total=(\d+) ([AB]):(.*)", line)
        if not m: continue
        meth = m.group(3)
        tot[meth + ".total"] = tot.get(meth + ".total", 0) + int(m.group(2))
        for k, v in re.findall(r"(\w+)=(\d+)", m.group(4)):
            key = meth + "." + k
            if k == "max":
                tot[key] = max(tot.get(key, 0), int(v))
            else:
                tot[key] = tot.get(key, 0) + int(v)
print("shards done %d/%d" % (done, mod))
for k in sorted(tot): print("  %s = %d" % (k, tot[k]))
if walls: print("  shard wall: min=%d max=%d sum=%d" % (min(walls), max(walls), sum(walls)))
