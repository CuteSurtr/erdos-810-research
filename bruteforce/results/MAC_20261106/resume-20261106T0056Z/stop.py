#!/usr/bin/env python3
"""Request shutdown of only the resumed Mac search, then automatic reporting."""
import argparse,pathlib
argparse.ArgumentParser(description=__doc__).parse_args()
p=pathlib.Path(__file__).resolve().parent
for name in ['STOP','constructions/STOP','recolor/STOP','cyclic/STOP']:
    f=p/name;f.parent.mkdir(parents=True,exist_ok=True);f.touch()
print('Stop requested. The automatic finalizer will report after shutdown.')
