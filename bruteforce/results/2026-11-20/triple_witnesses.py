"""Combine and verify triple constructions, or render them as Lean kernel certificates."""
import argparse
import json
from pathlib import Path

from audit_triples import read_witness


def encode(family):
    return [sum(1<<x for x in triple) for triple in family]


def collect(scratch):
    census = json.loads(Path(__file__).with_name("triples.json").read_text())
    result = {}
    for n in range(13,31):
        sources = []
        if str(n) in census["witnesses"]:
            sources.append(("census",census["witnesses"][str(n)]))
        for source in ("triple-local","triple-neighborhood","triple-orbits"):
            path = scratch/source/f"n{n}.json"
            if path.exists():
                sources.append((source,json.loads(path.read_text())))
        if not sources:
            continue
        name,family = max(sources,key=lambda item:len(item[1]))
        triples=read_witness(n,len(family),encode(family))
        result[str(n)]={"lower_bound":len(triples),"source":name,"triples":triples}
    return result


def verify(rows):
    for n, info in rows.items():
        size=info["lower_bound"]
        family=info["triples"]
        if size!=len(family) or read_witness(int(n),size,encode(family))!=family:
            raise ValueError(f"bad triple certificate at order {n}")


def lean(rows, orders):
    parts=["import TripleCertificate", "", "namespace Erdos810", "",
           "set_option maxRecDepth 20000", "set_option maxHeartbeats 0", ""]
    for n in orders:
        row=rows[str(n)]
        masks=sorted(encode(row["triples"]))
        # High-degree points occur throughout the order, so many partial unions
        # already have size eight before the last member is considered.
        parts.extend([f"private def triples{n} : List ℕ := {masks}", "",
                      f"theorem triple_lower_bound_{n} : {len(masks)} ≤ sevenFourNumber {n} := by",
                      f"  apply TripleCertificate.lower_bound {n} {len(masks)} triples{n}",
                      "  · decide +kernel", "  · decide +kernel", "  · decide +kernel", ""])
    parts.extend(["end Erdos810",""])
    parts.extend(f"#assert_no_sorry Erdos810.triple_lower_bound_{n}" for n in orders)
    return "\n".join(parts)+"\n"


if __name__=="__main__":
    parser=argparse.ArgumentParser(__doc__)
    parser.add_argument("input",type=Path,help="Scratch folder to collect, or witness JSON to verify or render.")
    parser.add_argument("--output",type=Path,help="Write verified constructions to this file.")
    parser.add_argument("--lean",type=Path,help="Write a Lean source file for the selected orders.")
    parser.add_argument("--orders",nargs=2,type=int,help="First and last graph orders to render.")
    args=parser.parse_args()
    rows=collect(args.input) if args.input.is_dir() else json.loads(args.input.read_text())
    verify(rows)
    if args.output:
        args.output.write_text(json.dumps(rows,separators=(",",":"))+"\n")
    if args.lean:
        if not args.orders:
            parser.error("--lean requires an order range")
        args.lean.write_text(lean(rows,range(args.orders[0],args.orders[1]+1)))
    print(" ".join(f"{n}/{v['lower_bound']}" for n,v in rows.items()),flush=True)
