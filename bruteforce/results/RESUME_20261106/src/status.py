#!/usr/bin/env python3
"""Summarize this run's append-only leaf log without treating timeouts as proofs."""
import collections
import datetime
import json
import pathlib
import sys

rows = [json.loads(line) for line in pathlib.Path(sys.argv[1]).read_text().splitlines()]
new = rows[9:]  # nine historical seed records for (56,14)
verified = [r for r in new if r.get('res') == 'UNSAT' and r.get('check') == 's VERIFIED UNSAT']
roots = collections.Counter(','.join(map(str, r['cube'][:4])) for r in verified)
summary = {
    'checked_at_utc': datetime.datetime.now(datetime.timezone.utc).isoformat(),
    'new_records': len(new),
    'results': dict(collections.Counter(r['res'] for r in new)),
    'verified_unsat_records': len(verified),
    'verified_unsat_unique_cubes': len({tuple(map(str, r['cube'])) for r in verified}),
    'verified_by_top_level_root': dict(roots),
    'solver_wall_seconds_sum': round(sum(r.get('secs', 0) for r in new), 1),
    'verified_proof_bytes': sum(r.get('proof_bytes', 0) for r in verified),
    'interrupted_records': sum(r.get('solver_returncode', 0) < 0 for r in new),
    'errors_or_unverified_unsat': [r for r in new if r['res'] == 'ERROR' or
        (r['res'] == 'UNSAT' and r.get('check') != 's VERIFIED UNSAT')],
    'sat': [r for r in new if r['res'] == 'SAT'],
}
print(json.dumps(summary, indent=2))
