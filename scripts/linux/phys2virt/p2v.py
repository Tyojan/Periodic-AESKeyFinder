
#!/usr/bin/env python3
import os
import sys
import struct

FLAGS = {
    0: "LOCKED", 1: "ERROR", 2: "REFERENCED",
    3: "UPTODATE", 4: "DIRTY", 5: "LRU",
    6: "ACTIVE", 7: "SLAB", 8: "WRITEBACK",
    9: "RECLAIM", 10: "BUDDY", 11: "MMAP",
    12: "ANON", 13: "SWAPCACHE", 14: "SWAPBACKED",
    15: "COMPOUND_HEAD", 16: "COMPOUND_TAIL",
    17: "HUGE", 18: "UNEVICTABLE", 19: "HWPOISON",
    20: "NOPAGE", 21: "KSM", 22: "THP",
    23: "BALLOON", 24: "ZERO_PAGE", 25: "IDLE",
    26: "PGTABLE",
}

def read_u64(path, index):
    with open(path, "rb") as f:
        f.seek(index * 8)
        data = f.read(8)
    if len(data) != 8:
        raise OSError("Short read: " + path)
    return struct.unpack("<Q", data)[0]

def search_pid(pid, target_pfn, page_offset, page_size):
    results = []
    with open(f"/proc/{pid}/maps") as maps, \
         open(f"/proc/{pid}/pagemap", "rb") as pm:
        with open(f"/proc/{pid}/comm") as f:
            comm = f.read().strip()

        for line in maps:
            a, b = line.split()[0].split("-")
            start, end = int(a, 16), int(b, 16)
            start_page = start // page_size
            end_page = (end + page_size - 1) // page_size

            for base in range(start_page, end_page, 65536):
                count = min(65536, end_page - base)
                pm.seek(base * 8)
                data = pm.read(count * 8)

                for i in range(len(data) // 8):
                    entry = struct.unpack_from("<Q", data, i * 8)[0]
                    if (entry >> 63) & 1 and \
                       (entry & ((1 << 55) - 1)) == target_pfn:
                        va = (base + i) * page_size + page_offset
                        results.append((pid, comm, va, line.strip()))
    return results

def classify(names):
    s = set(names)
    if "SLAB" in s:
        return "Kernel SLAB/SLUB page (cache name unknown)"
    if "PGTABLE" in s:
        return "Kernel page-table page"
    if "BUDDY" in s:
        return "Buddy allocator free block (head)"
    if "ANON" in s:
        return "Anonymous memory (process mapping possible)"
    if "MMAP" in s:
        return "Mapped memory (process mapping possible)"
    if "ZERO_PAGE" in s:
        return "Shared zero page"
    if "NOPAGE" in s:
        return "No normal physical page"
    return "Unknown / kernel or other memory"

def main():
    if len(sys.argv) == 2:
        pa = int(sys.argv[1], 0)
        pids = sorted(int(p) for p in os.listdir("/proc")
                      if p.isdigit())
    elif len(sys.argv) == 3:
        pids = [int(sys.argv[1])]
        pa = int(sys.argv[2], 0)
    else:
        sys.exit("Usage: sudo python3 p2v.py [PID] PA")

    page_size = os.sysconf("SC_PAGE_SIZE")
    target_pfn = pa // page_size
    page_offset = pa % page_size

    print(f"PA:  {pa:#x}")
    print(f"PFN: {target_pfn:#x}")
    print()

    found = False
    for pid in pids:
        try:
            for pid, comm, va, mapping in search_pid(
                    pid, target_pfn, page_offset, page_size):
                found = True
                print(f"PID: {pid} ({comm})")
                print(f"VA:  {va:#x}")
                print(f"MAP: {mapping}\n")
        except (OSError, ValueError, struct.error):
            continue

    if not found:
        print("No matching userspace mapping found.\n")

    try:
        flags = read_u64("/proc/kpageflags", target_pfn)
        count = read_u64("/proc/kpagecount", target_pfn)
        names = [name for bit, name in FLAGS.items()
                 if flags & (1 << bit)]
        print("[Physical page information]")
        print(f"Flags:    {names}")
        print(f"Raw:      {flags:#x}")
        print(f"Mapcount: {count}")
        print(f"Type:     {classify(names)}")
    except OSError as e:
        print(f"Kernel page information unavailable: {e}")

if __name__ == "__main__":
    main()
  
