#!/bin/bash
cd "$(dirname "$0")/.."
while pgrep -f "src/probe.sh" >/dev/null; do sleep 5; done
CAP=1200 src/probe.sh
