#!/usr/bin/env bash
set -eu

ITER="${1:-100}"       # 1番目の引数: 繰り返し回数 (デフォルト100)
SLEEP_SEC="${2:-0.1}"  # 2番目の引数: インターバル (デフォルト0.1)
IFACE1="${3:-eno1}"    # 3番目の引数: 最初のキャプチャIF (デフォルトeth0)
IFACE2="${4:-enp25s0}"   # 4番目の引数: 2つ目のキャプチャIF (デフォルトwlan0)
SERVER='10.14.149.160:4433'
CIPHER='ECDHE-RSA-AES128-GCM-SHA256'

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTFILE1="key_capture_${IFACE1}_${ITER}iter_${SLEEP_SEC}s_${TIMESTAMP}.pcapng"
OUTFILE2="tls_capture_${IFACE2}_${ITER}iter_${SLEEP_SEC}s_${TIMESTAMP}.pcapng"

echo "Capturing on $IFACE1 -> $OUTFILE1"
echo "Capturing on $IFACE2 -> $OUTFILE2"

# 並列で2つのインターフェイスをキャプチャ開始
tshark -i "$IFACE1" -w "$OUTFILE1" > /dev/null 2>&1 &
PID1=$!
echo $PID1
tshark -i "$IFACE2" -w "$OUTFILE2" > /dev/null 2>&1 &
PID2=$!
echo $PID2

sleep 1

# TLS接続をITER回実行
for i in $(seq 1 "$ITER"); do
  (sleep "$SLEEP_SEC"; echo) | \
    openssl s_client -connect "$SERVER" -cipher "$CIPHER" -tls1_2 \
    >/dev/null 2>&1 || true

  sleep "$SLEEP_SEC"
done

# キャプチャ停止
kill $PID1 $PID2
wait $PID1 $PID2 2>/dev/null || true

echo "Done. Files saved: $OUTFILE1, $OUTFILE2"
