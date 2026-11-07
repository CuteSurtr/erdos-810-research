#!/bin/bash
# simple job queue: each line of the file is a command; runs them one after another
while read -r line; do [ -n "$line" ] && eval "$line"; done < "$1"
