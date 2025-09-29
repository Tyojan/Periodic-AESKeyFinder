#!/bin/bash
set -e

REQUIRED_VERSION="v2023.2.2"

echo "[*] Checking Vivado installation..."

if ! command -v vivado &> /dev/null; then
    echo "[ERROR] Vivado is not installed or not in PATH."
    echo "Please install Vivado $REQUIRED_VERSION or later before running this artifact."
    exit 1
fi

VIVADO_VERSION=$(vivado -version | head -n 1 | awk '{print $2}')

echo "[*] Found Vivado version: $VIVADO_VERSION"

if [ "$VIVADO_VERSION" != "$REQUIRED_VERSION" ]; then
    echo "[WARNING] Expected Vivado $REQUIRED_VERSION, but found $VIVADO_VERSION."
    echo "The artifact may not work correctly with this version."
else
    echo "[OK] Vivado version is correct ($VIVADO_VERSION)."
fi

echo "[*] Environment check completed."

echo "[*] Setting up additional tools..."

# Ensure target directory exists
mkdir -p scripts/linux

# Clone virt2phys if not already present
if [ ! -d scripts/linux/virt2phys ]; then
    echo "[*] Cloning virt2phys into scripts/linux/"
    git clone https://github.com/katsuster/virt2phys scripts/linux/virt2phys
else
    echo "[*] virt2phys already exists, skipping clone."
fi

echo "[*] Setup completed."