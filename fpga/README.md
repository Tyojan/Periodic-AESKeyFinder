# Source Code of Periodic-AESKeyFinder

The `KeyFinder` directory contains the Verilog source code that constitutes the IP core of the Periodic-AESKeyFinder.  
The `KR260`, `AXKU062`, and `AXKU3` directories each contain projects corresponding to the FPGA boards we tested.  

The projects are described using Tcl scripts prefixed with **“mkproj”**.  
These codes are compatible with **Vivado v2023.2.2**.  

---

## Generate Project 
The following command generates a project for the KR260 and opens the Vivado GUI:

```bash
cd ./KR260
vivado -source mkproj_KR260_Periodic-AESKeyFinder.tcl


---



## Build

If the project is already open, please run *Run Implementation* from the IMPLEMENTATION menu in the Flow Navigator.

We also provide a script that performs both project generation and implementation in one step.  
The following command generates the KR260 project and runs FPGA implementation:

```bash
cd ./KR260
vivado -source build.tcl

The build process takes approximately 1–2 hours on our development environment (Core i9-9990X, 128GB RAM).
To generate the FPGA bitstream, a license for the Ethernet IP core is required.
For licensing details, please refer to the Vivado Design Suite User Guide: Release Notes, Installation, and Licensing (UG973).

