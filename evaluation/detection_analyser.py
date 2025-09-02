import pyshark
import re
import argparse
import matplotlib.pyplot as plt
import numpy as np

def parse_log_file(log_file):
    """ログファイルを解析し、鍵本体と対応する実行時間を取得"""
    key_time_data = {}

    def reverse_byte_order(key):
        """8バイトごとにリトルエンディアンのバイトオーダーを入れ替える"""
        # 16文字（8バイト）ずつ分割
        segments = [key[i:i+16] for i in range(0, len(key), 16)]

        # 各セグメントで8バイト単位の順序を逆転
        reversed_segments = [
            ''.join([segment[i+14:i+16] + segment[i+12:i+14] + segment[i+10:i+12] + segment[i+8:i+10] +
                     segment[i+6:i+8] + segment[i+4:i+6] + segment[i+2:i+4] + segment[i:i+2] for i in range(0, len(segment), 16)])
            for segment in segments
        ]

        # 再結合して返す
        return ''.join(reversed_segments)

    with open(log_file, "r") as f:
        current_key = None
        times = {"real": [], "user": [], "sys": []}

        for line in f:
            line = line.strip()

            # 鍵本体のパターンを検出
            if re.match(r"454b383231534541[0-9A-Fa-f]{4}000000000059", line):
                current_key = reverse_byte_order(line[:32])
                times = {"real": [], "user": [], "sys": []}  # 初期化

            # 実行時間のデータを解析
            elif line.startswith("real") or line.startswith("user") or line.startswith("sys"):
                time_type, time_value = line.split("\t")
                time_value = time_value.replace("m", "").replace("s", "")
                total_seconds = float(time_value)
                times[time_type].append(total_seconds)

            # diff.retvalで1クール終了
            elif line.startswith("diff.retval"):
                if current_key is not None and all(times.values()):
                    key_time_data[current_key] = {
                        key: sum(vals) / len(vals) for key, vals in times.items()
                    }
                current_key = None

    return key_time_data

def parse_pcap_file(pcap_file):
    """PCAPファイルを解析して、ユニークな鍵本体とアドレスのセットを作成する関数"""
    unique_keys = set()  # ユニークな鍵セット
    pattern = re.compile(r"4145533132384b45590000000000[0-9A-Fa-f]{4}")  # 特定パターン

    capture = pyshark.FileCapture(pcap_file)
    for packet in capture:
        # if "AESKEYFINDER" in packet:
        if "KeyFinder" in packet:            
            try:
                # aeskeyfinder.keysizeが128であることを確認
                # print(packet.aes)
                # keysize = int(packet.keyfinder.PacketSize)
                # if keysize != 128:
                if int(packet.keyfinder.pktsize) != 64:
                    continue

                # keyrawとkeyaddrを取得
                # keyraw = re.sub("[^0-9A-Fa-f]", "", str(packet.aeskeyfinder.keyraw))
                # keyaddr = re.sub("[^0-9A-Fa-f]", "", str(packet.aeskeyfinder.keyaddr))
                
                keyraw = re.sub("[^0-9A-Fa-f]", "", str(packet.keyfinder.keyraw))
                keyaddr = re.sub("[^0-9A-Fa-f]", "", str(packet.keyfinder.keyaddr))

                # パターンに一致するか確認
                if pattern.match(keyraw):
                    # アドレスと鍵本体を結合してユニークセットに追加
                    unique_keys.add(f"{keyaddr}_{keyraw}")

            except AttributeError:
                # パケットに期待するフィールドがない場合はスキップ
                continue
    capture.close()

    return unique_keys

def main():
    # 引数の解析
    parser = argparse.ArgumentParser(description="複数のPCAPファイルを解析")
    parser.add_argument("--trendline", action="store_true", help="傾向線を表示")
    parser.add_argument("pcap_files", nargs='+', help="解析対象のPCAPNGファイルのリスト")
    args = parser.parse_args()

    # 特定パターンに一致するkeyrawのカウント
    matching_keyraw_count = 0
    unique_keys_per_file = {}  # 各ファイルごとのユニークな鍵セット

    avg_real_times = []
    detection_rates = []

    # 各PCAPファイルの解析
    for pcap_file in args.pcap_files:
        print(f"現在解析中のファイル: {pcap_file}")
        unique_keys = parse_pcap_file(pcap_file)
        unique_keys_per_file[pcap_file] = unique_keys.copy()

    # 結果を表示
    for pcap_file, unique_keys in unique_keys_per_file.items():
        print(f"ファイル: {pcap_file}")
        print(f"検出されたユニークなAES鍵の数: {len(unique_keys)}")

        # 実行時間の平均計算
        total_real_time = 0
        total_user_time = 0
        total_sys_time = 0
        time_count = 0

        log_file = pcap_file.replace(".pcapng", ".txt")
        key_time_data = parse_log_file(log_file)

        # 総検出対象の鍵の数を計算
        total_keys = len(key_time_data) * 2  # 暗号化と復号の2回を考慮

        if total_keys == 0:
            print(f"ファイル: {pcap_file} のログファイルに検出対象の鍵がありません。")
            continue

        for unique_key in unique_keys:
            keyaddr, keyraw = unique_key.split("_")
            if keyraw in key_time_data:
                times = key_time_data[keyraw]
                total_real_time += times['real']
                total_user_time += times['user']
                total_sys_time += times['sys']
                time_count += 1

        if time_count > 0:
            avg_real = total_real_time / time_count
            avg_user = total_user_time / time_count
            avg_sys = total_sys_time / time_count
            avg_real_times.append(avg_real)
            print(f"ファイル: {pcap_file} の平均実行時間: real: {avg_real:.3f}s, user: {avg_user:.3f}s, sys: {avg_sys:.3f}s")

        # 検出率計算
        detection_rate = len(unique_keys) / total_keys * 100
        detection_rates.append(detection_rate)
        print(f"ファイル: {pcap_file} の検出率: {detection_rate:.2f}%")
        print("=======================================")

    # 折れ線グラフの作成
    plt.figure(figsize=(9, 5))
    plt.scatter(avg_real_times, detection_rates, marker='o')

    # 傾向線（線形回帰）の計算と描画
    if args.trendline and len(avg_real_times) > 1:
        # 線形回帰の計算
        coeff = np.polyfit(avg_real_times, detection_rates, 1)
        trendline = np.poly1d(coeff)

        # 傾向線のプロット
        x_vals = np.linspace(min(avg_real_times), max(avg_real_times), 100)
        plt.plot(x_vals, trendline(x_vals), color='black', linestyle=':', linewidth=1, label='Trendline')
        plt.legend()
    # plt.title("Average Execution Time vs Detection Rate", fontsize=14)
    plt.xlabel("Average Execution Time (real) [s]", fontsize=14)
    plt.ylabel("Detection Rate [%]", fontsize=14)
    plt.grid(True)
    plt.savefig('execution_time_vs_detection_rate.pdf')
    plt.show()

if __name__ == "__main__":
    main()
