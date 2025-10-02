#!/usr/bin/env python3
import sys
import subprocess

if len(sys.argv) < 2:
    print(f"Usage: {sys.argv[0]} <capture.pcapng>")
    sys.exit(1)

pcap_file = sys.argv[1]

cmd = [
    "tshark", "-r", pcap_file,
    "-Y", "(ip.addr==10.14.149.160 && tcp) && (tls.handshake.type or tcp.flags.fin==1 or tls.record.content_type==21)",
    "-T", "fields",
    "-e", "frame.time_relative",
    "-e", "tcp.stream",
    "-e", "tls.handshake.type",
    "-e", "tls.record.content_type",
    "-e", "tcp.flags.fin"
]

result = subprocess.run(cmd, capture_output=True, text=True)
lines = result.stdout.strip().split("\n")

sessions = {}
durations = []

for line in lines:
    if not line.strip():
        continue
    parts = line.split("\t")
    if len(parts) < 5:
        continue

    time, stream, hs_type, content_type, fin_flag = parts
    time = float(time)

    if hs_type == "16":  # ClientKeyExchange
        sessions[stream] = {"start": time}
    if fin_flag == "1" or content_type == "21":  # FIN or Alert
        if stream in sessions:
            sessions[stream]["end"] = time

for stream, data in sessions.items():
    if "start" in data and "end" in data:
        duration = data["end"] - data["start"]
        durations.append(duration)
        print(f"Stream {stream}: TLS1.2 key lifetime = {duration:.3f} sec "
              f"(start={data['start']:.3f}, end={data['end']:.3f})")
    elif "start" in data:
        print(f"Stream {stream}: incomplete (only start found)")

if durations:
    avg = sum(durations) / len(durations)
    print(f"\nAverage TLS1.2 key lifetime across {len(durations)} sessions = {avg:.5f} sec")
