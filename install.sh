#!/bin/bash
set -e


# Vivado
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

# ========== Wireshark / tshark check ==========
if command -v tshark >/dev/null 2>&1; then
  tshark -v | head -n1
  WIRESHARK_OK=1
elif command -v wireshark >/dev/null 2>&1; then
  wireshark -v | head -n1
  WIRESHARK_OK=1
else
  WIRESHARK_OK=0
fi

if [ "$WIRESHARK_OK" -ne 1 ]; then
  echo
  echo "[WARN] 'tshark'/'wireshark' not found on this system."
  echo -n "Install wireshark & tshark now via apt? [y/N] "
  read -r ans || ans="N"
  ans="${ans:-N}"
  if [[ "$ans" =~ ^[Yy]$ ]]; then
    if [ "$(id -u)" -ne 0 ]; then
      echo "[*] Using sudo to install packages..."
      SUDO="sudo"
    else
      SUDO=""
    fi

    echo "[*] Preconfiguring wireshark to allow non-root capture (best-effort)..."
    echo "wireshark-common wireshark-common/install-setuid boolean true" | $SUDO debconf-set-selections 2>/dev/null || true

    echo "[*] apt-get update..."
    $SUDO apt-get update -y || { echo "[ERROR] apt-get update failed"; exit 1; }

    echo "[*] Installing wireshark and tshark..."
    DEBIAN_FRONTEND=noninteractive $SUDO apt-get install -y --no-install-recommends wireshark tshark || {
      echo "[WARN] apt install failed or was interrupted. You can install manually: sudo apt update && sudo apt install wireshark tshark"
    }

    # setcap on dumpcap (best-effort)
    if command -v dumpcap >/dev/null 2>&1 && command -v setcap >/dev/null 2>&1; then
      DUMPCAP="$(command -v dumpcap)"
      echo "[*] Setting capabilities on dumpcap to allow non-root capture..."
      $SUDO setcap 'CAP_NET_RAW+eip CAP_NET_ADMIN+eip' "$DUMPCAP" || echo "[WARN] setcap failed (continuing)"
    fi

    # add user to wireshark group if it exists
    CUR_USER="${SUDO_USER:-$USER}"
    if getent group wireshark >/dev/null 2>&1; then
      echo "[*] Adding user '$CUR_USER' to 'wireshark' group (re-login required)..."
      $SUDO usermod -aG wireshark "$CUR_USER" || echo "[WARN] usermod failed (you may need to add user manually)"
    fi

    echo "[*] Wireshark/tshark installation step completed (if errors occurred, please install manually)."
  else
    echo "[*] Skipping wireshark installation. If you need packet capture, install 'wireshark'/'tshark' manually."
  fi
fi

echo "[*] Setup completed."
