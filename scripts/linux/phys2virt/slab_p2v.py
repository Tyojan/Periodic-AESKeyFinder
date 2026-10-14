#!/usr/bin/env drgn

import sys
from drgn import Object, sizeof
from drgn.helpers.linux.mm import phys_to_virt
from drgn.helpers.linux.slab import slab_object_info
from drgn.helpers.common.type import member_at_offset

# キャッシュ名と構造体型の対応
KNOWN_TYPES = {
    "task_struct": "struct task_struct",
    "mm_struct": "struct mm_struct",
    "files_cache": "struct files_struct",
    "dentry": "struct dentry",
    "inode_cache": "struct inode",
}

def analyze_object(name, address, offset):
    type_name = KNOWN_TYPES.get(name)

    if type_name is None:
        print("Type:      Unknown")
        return

    try:
        typ = prog.type(type_name)
        size = sizeof(typ)

        print(f"Type:      {type_name}")
        print(f"Size:      {size:#x}")

        if offset >= size:
            print("Member:    Outside structure")
            return

        member = member_at_offset(typ, offset)
        print(f"Member:    {member}")

        obj = Object(prog, typ, address=address)

        if name == "task_struct":
            print(f"PID:       {obj.pid.value_()}")
            print(f"TGID:      {obj.tgid.value_()}")
            print(f"COMM:      {obj.comm.string_().decode()}")

    except (LookupError, TypeError, ValueError) as e:
        print(f"Analysis error: {e}")


def main():
    pa = int(sys.argv[1], 0)
    va = phys_to_virt(prog, pa)

    info = slab_object_info(prog, va)

    if info is None:
        print("Not a SLAB object")
        return

    name = info.slab_cache.name.string_().decode()
    offset = int(va) - info.address

    print(f"PA:        {pa:#x}")
    print(f"Kernel VA: {int(va):#x}")
    print(f"Cache:     {name}")
    print(f"Object VA: {info.address:#x}")
    print(f"Offset:    {offset:#x}")
    print(f"Allocated: {info.allocated}")

    if info.allocated is True:
        analyze_object(name, info.address, offset)
    else:
        print("Object is free or allocation state is unknown")


if __name__ == "__main__":
    main()
