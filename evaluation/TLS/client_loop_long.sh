#!/usr/bin/env bash
set -eu

# SERVER=127.0.0.1:4433
SERVER=10.14.149.160:4433
# SERVER=10.14.149.199:4433
CIPHER='ECDHE-RSA-AES128-GCM-SHA256'
# CIPHER='TLS_ECDHE_RSA_WITH_AES_128_CCM'
ITER=20000
# DURATION=2

for i in $(seq 1 $ITER); do
  # (sleep "$DURATION"; echo) | openssl s_client -connect "$SERVER" -cipher "$CIPHER" -tls1_2  </dev/null >/dev/null 2>&1 || true


  # openssl s_client -connect "$SERVER" -cipher "$CIPHER" -tls1_2  </dev/null
  
  # echo -e "GET / HTTP/1.0\r\n\r\n"   | openssl s_client -connect $SERVER -cipher $CIPHER -tls1_2

  (sleep 0.1; echo) | openssl s_client -connect $SERVER -cipher 'ECDHE-RSA-AES128-GCM-SHA256' -tls1_2
  
  sleep 0.1
done
