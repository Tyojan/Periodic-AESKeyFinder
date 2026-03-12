# driver

Overview
--------

This directory contains scripts and configuration used to trigger the Periodic-AESKeyFinder hardware from the host. The primary script in this directory is `boot.cmd` which is intended for use with the Xilinx KR260 board.

Supported hardware
------------------

- Xilinx KR260: `boot.cmd` is configured to load and start the hardware on this platform.

Files
-----

- `boot.cmd` — Boot / launch script for KR260 (platform-specific).  
- `README.md` — This file.


Prepare micro SD card
---------------------

Download an Ubuntu filesystem image certified for the KR260 from:

https://ubuntu.com/certified/202202-29985

Expand the downloaded Ubuntu filesystem onto the micro SD card used to boot the KR260.

Build
-----

- Name the generated FPGA bitstream `system.bit`.
- Build `boot.cmd` into a U-Boot script image using the following command:

```
mkimage -c none -A arm -T script -d boot.cmd boot.scr.uimg
```

After building, copy the generated artifacts to the SD card's `/boot/firmware` directory:

- `system.bit` (FPGA bitstream)
- `boot.scr.uimg` (U-Boot script image produced by `mkimage`)
