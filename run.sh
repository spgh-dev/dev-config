#!/usr/bin/bash

# This script executes all the executable scripts located in the runs directory.
# pass --dry to check which will be run.
# also a "skip" pattern may be given.

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

grep=""
dry_run="0"

while [[ $# -gt 0 ]]; do
  echo "ARG: \"$1\""
  if [[ "$1" == "--dry" ]]; then
    dry_run="1"
  else
    grep="$1"
  fi
  shift
done

log() {
  if [[ $dry_run == "1" ]]; then
    echo "[DRY_RUN]: $1"
  else
    echo "$1"
  fi
}

log "RUN: env: $env -- grep: $grep"

runs_dir=$(find $script_dir/runs -mindepth 1 -maxdepth 1 -executable | sort)

for s in $runs_dir; do
  if echo "$s" | grep -vq "$grep"; then
    log "grep \"$grep\" filtered out $s"
    continue
  fi

  log "running script: $s"

  if [[ $dry_run == "0" ]]; then
    $s
  fi
done
