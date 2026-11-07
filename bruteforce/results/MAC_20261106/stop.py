#!/usr/bin/env python3
"""Request graceful shutdown of only this session's bounded search jobs."""
import argparse,pathlib
p=argparse.ArgumentParser(description=__doc__);p.parse_args()
root=pathlib.Path(__file__).resolve().parent
for path in ('constructions/STOP','recolor/STOP','cyclic/STOP','cyclic/n56/STOP','STOP_ALL'):
    target=root/path;target.parent.mkdir(parents=True,exist_ok=True);target.touch()
print('Stop requested. The scheduled finalizer will refresh REPORT.md after shutdown.')
