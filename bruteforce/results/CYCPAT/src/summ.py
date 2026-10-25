import json,glob
for f in sorted(glob.glob('runs/enum_*.json'), key=lambda f:(int(f.split('_n')[1].split('_')[0]), f)):
    try:
        d=json.load(open(f)); print(d['n'],d['k'],d['status'],d['n_orbits'],d['n_solutions_gmin0'],d['secs'])
    except Exception: print(f,'running')
