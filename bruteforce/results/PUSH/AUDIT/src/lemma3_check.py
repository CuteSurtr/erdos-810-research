"""Audit of Lemma 3 on CYCPAT's listed optimal solutions: for every unit u, the image
(with the +e correction) must be valid (explicit-graph check); the variant without +e is
also tested.  Also recomputes orbit counts from the listed normal forms."""
import json, math, sys
from cycgroup import explicit_ok, image, normal, orbit
RES = "../../../CYCPAT/solutions/"
for n in map(int, sys.argv[1:]):
    import glob
    f = glob.glob(RES + f"enum_n{n}_k*.json")[0]
    d = json.load(open(f))
    nfs = [tuple(map(tuple, x if isinstance(x[0], list) else x)) for x in
           [nf["Dg"] if isinstance(nf, dict) else nf for nf in d["normal_forms"]]]
    units = [u for u in range(1, n) if math.gcd(u, n) == 1]
    good = bad = 0; drop_fail_units = set(); drop_ok_units = set()
    allsols = set()
    for s in nfs:
        assert explicit_ok(n, s), (n, s)
        for u in units:
            im = image(n, s, u)
            if explicit_ok(n, im): good += 1
            else: bad += 1
            if u != 1:
                if explicit_ok(n, image(n, s, u, drop_e=True)): drop_ok_units.add(u)
                else: drop_fail_units.add(u)
        allsols |= orbit(n, s)
    norb = len({min(orbit(n, s)) for s in nfs})
    print(f"n={n}: {len(nfs)} listed normal forms (file n_orbits={d['n_orbits']}), distinct orbits recomputed={norb}, "
          f"solutions g(minD)=0 = {len(allsols)}; images under all {len(units)} units: {good} valid, {bad} invalid; "
          f"drop-e variant: units with some failure {len(drop_fail_units)}/{len(units)-1}, "
          f"units where all images still valid: {sorted(drop_ok_units - drop_fail_units)}")
