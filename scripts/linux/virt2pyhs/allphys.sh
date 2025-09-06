#! /bin/bash

for pid in $(ps -e | awk '{print $1}' | grep -v PID); do
#    echo $pid | tee result
#    cat /proc/$pid/maps | grep 'rw'
    grep 'rw' "/proc/$pid/maps" | grep -oP '^[0-9a-f]+-[0-9a-f]+' | while read -r range;do
	# 範囲の開始アドレスと終了アドレスを抽出
	start_addr=$(echo $range | cut -d'-' -f1)
	end_addr=$(echo $range | cut -d'-' -f2)
	# 開始アドレスと終了アドレスの差（サイズ）を計算（16進数として計算）
	size=$(printf "0x%x" $((0x$end_addr - 0x$start_addr)))
	#echo "size =" $size
	# v2pコマンドを実行して仮想アドレスを物理アドレスに解決
	./src/v2p "$pid" "0x$start_addr" "$size" > v2p_intermidiate
	if cat v2p_intermidiate | grep -q -Ff addrs.txt;then
		ps -f $pid | tee -a result
		cat v2p_intermidiate | grep -Ff addrs.txt | tee -a result
	fi
    done
done
