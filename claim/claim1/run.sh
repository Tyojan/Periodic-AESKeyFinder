#!/bin/bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: $0 <target>"
  echo "  target: KR260 | AXKU062 | AXKU3"
  exit 1
fi

TARGET="$1"

case "$TARGET" in
  KR260)
    cd ../../fpga/KR260
    ;;
  AXKU062)
    cd ../../fpga/AXKU062
    ;;
  AXKU3)
    cd ../../fpga/AXKU3
    ;;
  *)
    echo "Error: Unknown target '$TARGET'"
    echo "Valid targets: KR260, AXKU062, AXKU3"
    exit 1
    ;;
esac

vivado -mode batch -source build.tcl
