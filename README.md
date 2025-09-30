# Periodic-AESKeyFinder

This repository contains the source code of Periodic-AESKeyFinder along with auxiliary scripts for analysis.
The FPGA source code can be found under the fpga directory.
The scripts used for investigating key zeroization are located under the scripts directory.


# Project Structure

```plaintext
Periodic-AESKeyFinder/
├── README.md
├── artifacts
├── claim
│   └── claim1
├── evaluation
│   ├── AESKeyFinder_vs_Periodic-AESKeyFinder
│   ├── TLS
├── fpga    # FPGA files
│   ├── AXKU062     # Project file for AXKU062 FPGA board
│   ├── AXKU3       # Project file for AXKU3 FPGA board
│   ├── KR260       # Project file for KR260 FPGA board
│   ├── KeyFinder   # Periodic-AESKeyFinder source code
│   └── README.md
├── install.sh      # 
└── scripts
    ├── aeskeyfinder.lua    # Wireshark Lua script to interpret Periodic-AESKeyFinder output
    ├── linux
    └── windows
```





## Project Requirements

### Hardware
- **FPGA board**: Xilinx KR260


### Software
**Ubuntu 22.04**

**Xilinx Vivado 2023.2.2**

visit [Xilinx Vivado 2023.2.2 download page](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive.html).
Follow the instructions for downloading and installing Vivado on your system.



### License
"A license for LogiCORE Tri-Mode Ethernet MAC is required. Please refer to UG973, and access https://account.amd.com/ja/forms/license/license-form.html
 and follow the instructions."

