import pyshark
from IPython import embed
import re
from collections import Counter
import sys


def parse_keyfinder_pretty(text: str):
    # それぞれのフィールドを全部抜き出す
    lengths = re.findall(r"^\s*AES Key Length:\s*(\d+)", text, re.MULTILINE)
    bitmaps = re.findall(r"^\s*KeySchedule Bitmap:\s*([0-9a-fA-F]+)", text, re.MULTILINE)
    addrs   = re.findall(r"^\s*Physical Address:\s*([0-9a-fA-F]+)", text, re.MULTILINE)
    raws    = re.findall(r"^\s*Raw Key:\s*([0-9a-fA-F]+)", text, re.MULTILINE)

    # 各リストをインデックス順にまとめる
    n = max(len(lengths), len(bitmaps), len(addrs), len(raws))
    # print(lengths, bitmaps, addrs, raws)
    keys = []
    for i in range(n):
        keys.append({
            "length": lengths[i] if i < len(lengths) else None,
            "bitmap": bitmaps[i] if i < len(bitmaps) else None,
            "address": addrs[i] if i < len(addrs) else None,
            "raw_key": raws[i] if i < len(raws) else None,
        })

    # print(text)
    # print(keys)
    return keys

def strip_ansi(text: str) -> str:
    ansi_escape = re.compile(r'\x1B\[[0-?]*[ -/]*[@-~]')
    return ansi_escape.sub('', text)

def parse_keyfinder(packet):
    try:
        kf = packet.keyfinder  # dissector 名に対応
    except AttributeError:
        return None
    text=str(kf)
    keys = parse_keyfinder_pretty(strip_ansi(text))

    return keys


if len(sys.argv) < 2:
    print(f"Usage: {sys.argv[0]} <capture.pcapng>")
    sys.exit(1)
    
pcap_file = sys.argv[1]
capture = pyshark.FileCapture(pcap_file, display_filter="keyfinder")

all_keys = []
for packet in capture:
    keys = parse_keyfinder(packet)
    if keys:
        all_keys.extend(keys)

# 整形して出力
# for idx, k in enumerate(all_keys, 1):
#     print(f"[Key {idx}]")
#     print(f"  Length : {k['length']}")
#     print(f"  Addr   : {k['address']}")
#     print(f"  Bitmap : {k['bitmap']}")
#     print(f"  RawKey : {k['raw_key']}")
#     print()


# # 出現回数を数える
# counter = Counter(
#     (k["address"], k["raw_key"], k["bitmap"], k["length"])
#     for k in all_keys
#     if k["address"] and k["raw_key"] and k["bitmap"] and k["length"]
# )

# # 出力
# for (addr, raw, bitmap, length), count in counter.items():
#     if length == '128':
#         print(f"Addr={addr}  RawKey={raw}  Bitmap={bitmap}  Length={length}  Count={count}")



# 出現回数を数える
counter = Counter(
    (k["address"], k["raw_key"], k["length"])
    for k in all_keys
    if k["address"] and k["raw_key"] and k["length"]
)

# 出力
for (addr, raw, length), count in counter.items():
    if length == '128':
        print(f"Addr={addr}  RawKey={raw}  Length={length}  Count={count}")
