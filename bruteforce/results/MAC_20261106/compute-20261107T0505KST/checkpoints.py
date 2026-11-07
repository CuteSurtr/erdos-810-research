#!/usr/bin/env python3
"""Bounded local checkpoint schedule; no model or network calls."""
import datetime
import json
import pathlib
import subprocess
import sys
import time

P = pathlib.Path(__file__).resolve().parent
END = datetime.datetime(2026, 11, 7, 0, 5, tzinfo=datetime.timezone.utc).timestamp()
FINAL = datetime.datetime(2026, 11, 6, 23, 57, tzinfo=datetime.timezone.utc).timestamp()

def checkpoint(final=False):
    remaining = END - time.time()
    if remaining <= 0:
        return
    command = [sys.executable, str(P / 'finalize.py')]
    if final:
        command.append('--final')
    with (P / 'automatic-checkpoints.log').open('a', buffering=1) as log:
        log.write(json.dumps({'time': time.time(), 'final': final}) + '\n')
        try:
            result = subprocess.run(command, stdout=log, stderr=subprocess.STDOUT,
                                    timeout=min(310, remaining), check=False)
            record = {'time': time.time(), 'final': final, 'returncode': result.returncode}
        except subprocess.TimeoutExpired:
            record = {'time': time.time(), 'final': final, 'error': 'verification timeout'}
        (P / 'automatic-checkpoint-status.json').write_text(json.dumps(record) + '\n')

next_check = time.time() + 3600
while time.time() < FINAL and not (P / 'STOP').exists():
    if time.time() >= next_check:
        checkpoint()
        next_check += 3600
    time.sleep(min(5, max(0, FINAL - time.time())))
if (P / 'STOP').exists():
    for _ in range(18):
        if time.time() >= END:
            break
        time.sleep(min(5, max(0, END - time.time())))
checkpoint(final=True)
