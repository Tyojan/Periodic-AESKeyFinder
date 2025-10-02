#!/usr/bin/env bash
set -eu

ITER="${1:-2000}"


for val in $(seq 0.9 0.1 1.5); do
  echo "Running capture with sleep interval = $val sec"
  ./client_test.sh "$ITER" "$val"
done
