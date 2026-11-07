"""Fill report_template.md -> REPORT.md."""
import csv, subprocess
T = open('report_template.md').read()
pl = subprocess.run('uname -a; nproc; free -g', shell=True, capture_output=True, text=True).stdout.strip()
rows = list(csv.DictReader(open('table.tsv'), delimiter='\t'))
readme_M = {10: '30*', 14: '≥ 53', 18: '≥ 85', 22: '≥ 121'}
def short(s):
    if s.startswith('heuristic'):
        return 'H (UB: ' + s.split('UB from ')[1] + ')'
    return s
lines = ['| β | p | m best | upper bound | status | m/p² | n = 2p | README M(n) |', '|---|---|---|---|---|---|---|---|']
for r in rows:
    n = 2 * int(r['p'])
    lines.append('| %s | %s | %s | %s | %s | %s | %d | %s |' % (r['beta'], r['p'], r['m (best)'], r['upper bound'], short(r['status']), r['m/p^2'], n, readme_M.get(n, '—')))
T = T.replace('{{PLACEMENT}}', pl).replace('{{TABLE}}', '\n'.join(lines))
for k in ['HEADLINES', 'EXTRA', 'SURPRISES']:
    T = T.replace('{{%s}}' % k, open('report_%s.md' % k.lower()).read().strip())
T = T.replace('{{FIT}}', open('fit.txt').read().strip())
open('REPORT.md', 'w').write(T)
