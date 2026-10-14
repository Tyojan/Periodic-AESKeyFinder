#!/usr/bin/env python3
import sys
import os
import struct

pid = int(sys.argv[1])
va = int(sys.argv[2], 0)

page_size = os.sysconf("SC_PAGE_SIZE")
offset = (va // page_size) * 8

with open(f"/proc/{pid}/pagemap", "rb") as f:
    f.seek(offset)
    data = f.read(8)

if len(data) != 8:
    sys.exit("pagemap read failed")

entry = struct.unpack("<Q", data)[0]

if not (entry & (1 << 63)):
    sys.exit("Page is not present")

pfn = entry & ((1 << 55) - 1)
pa = pfn * page_size + (va % page_size)

print(f"PID: {pid}")
print(f"VA:  {va:#x}")
print(f"PFN: {pfn:#x}")
print(f"PA:  {pa:#x}")
