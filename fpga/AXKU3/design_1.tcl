
################################################################
# This is a generated script based on design: design_1
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2023.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source design_1_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# AESKeyFinder_v1_0

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcku3p-ffvb676-2-i
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name design_1

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:xdma:4.1\
xilinx.com:ip:axi_ethernet:7.2\
xilinx.com:ip:axi_fifo_mm_s:4.3\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:system_ila:1.1\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:jtag_axi:1.2\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
AESKeyFinder_v1_0\
"

   set list_mods_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2020 -severity "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2021 -severity "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_gid_msg -ssname BD::TCL -id 2022 -severity "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set mdio_rtl_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio_rtl_0 ]

  set rgmii_rtl_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 rgmii_rtl_0 ]

  set CLK_IN1_D_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN1_D_0 ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $CLK_IN1_D_0

  set PCIE_CLK [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 PCIE_CLK ]

  set pcie_7x_mgt_rtl_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_7x_mgt_rtl_0 ]


  # Create ports
  set reset_rtl_0 [ create_bd_port -dir O -from 0 -to 0 -type rst reset_rtl_0 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $reset_rtl_0
  set FPGA_PCIE_PERST_N [ create_bd_port -dir I -type rst FPGA_PCIE_PERST_N ]
  set user_lnk_up_0 [ create_bd_port -dir O user_lnk_up_0 ]
  set dout_0 [ create_bd_port -dir O -from 0 -to 0 dout_0 ]
  set interrupt_out_0 [ create_bd_port -dir O -type intr interrupt_out_0 ]
  set aeskeyfinder_active_0 [ create_bd_port -dir O aeskeyfinder_active_0 ]

  # Create instance: xdma_0, and set properties
  set xdma_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma_0 ]
  set_property -dict [list \
    CONFIG.PF0_DEVICE_ID_mqdma {9038} \
    CONFIG.PF0_SRIOV_VF_DEVICE_ID {A038} \
    CONFIG.PF2_DEVICE_ID_mqdma {9238} \
    CONFIG.PF3_DEVICE_ID_mqdma {9338} \
    CONFIG.aspm_support {L1_Supported} \
    CONFIG.axi_addr_width {48} \
    CONFIG.axi_data_width {256_bit} \
    CONFIG.axibar2pciebar_0 {0x0000000100000000} \
    CONFIG.axibar2pciebar_1 {0x0000000200000000} \
    CONFIG.axibar2pciebar_2 {0x0000000400000000} \
    CONFIG.axibar2pciebar_3 {0x0000000800000000} \
    CONFIG.axibar2pciebar_4 {0x0000001000000000} \
    CONFIG.axibar2pciebar_5 {0x0000002000000000} \
    CONFIG.axibar_num {6} \
    CONFIG.axisten_freq {250} \
    CONFIG.bridge_burst {true} \
    CONFIG.dedicate_perst {true} \
    CONFIG.dma_reset_source_sel {User_Reset} \
    CONFIG.en_ext_ch_gt_drp {false} \
    CONFIG.en_gt_selection {true} \
    CONFIG.en_pcie_drp {false} \
    CONFIG.en_transceiver_status_ports {false} \
    CONFIG.enable_jtag_dbg {true} \
    CONFIG.enable_ltssm_dbg {true} \
    CONFIG.enable_mark_debug {false} \
    CONFIG.enable_pcie_debug_ports {True} \
    CONFIG.functional_mode {AXI_Bridge} \
    CONFIG.mcap_enablement {Tandem_PROM} \
    CONFIG.mode_selection {Advanced} \
    CONFIG.pcie_blk_locn {X0Y0} \
    CONFIG.pciebar2axibar_0 {0x00000000c0000000} \
    CONFIG.performance {true} \
    CONFIG.pf0_bar0_64bit {false} \
    CONFIG.pf0_bar0_scale {Kilobytes} \
    CONFIG.pf0_bar0_size {128} \
    CONFIG.pf0_base_class_menu {Processing_accelerators} \
    CONFIG.pf0_device_id {9038} \
    CONFIG.pf0_interrupt_pin {NONE} \
    CONFIG.pf0_link_status_slot_clock_config {true} \
    CONFIG.pf0_msi_enabled {false} \
    CONFIG.pipe_sim {false} \
    CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} \
    CONFIG.pl_link_cap_max_link_width {X8} \
    CONFIG.plltype {QPLL1} \
    CONFIG.select_quad {GTY_Quad_225} \
  ] $xdma_0


  # Create instance: axi_ethernet_0, and set properties
  set axi_ethernet_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_ethernet:7.2 axi_ethernet_0 ]
  set_property -dict [list \
    CONFIG.PHY_TYPE {RGMII} \
    CONFIG.SupportLevel {1} \
    CONFIG.axiliteclkrate {250} \
    CONFIG.axisclkrate {250} \
  ] $axi_ethernet_0


  # Create instance: axi_ethernet_0_fifo, and set properties
  set axi_ethernet_0_fifo [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_fifo_mm_s:4.3 axi_ethernet_0_fifo ]
  set_property -dict [list \
    CONFIG.C_DATA_INTERFACE_TYPE {1} \
    CONFIG.C_HAS_AXIS_TKEEP {true} \
    CONFIG.C_RX_FIFO_DEPTH {2048} \
    CONFIG.C_RX_FIFO_PE_THRESHOLD {10} \
    CONFIG.C_RX_FIFO_PF_THRESHOLD {2043} \
    CONFIG.C_TX_FIFO_DEPTH {4096} \
    CONFIG.C_TX_FIFO_PE_THRESHOLD {10} \
    CONFIG.C_TX_FIFO_PF_THRESHOLD {4000} \
    CONFIG.C_USE_TX_CUT_THROUGH {1} \
  ] $axi_ethernet_0_fifo


  # Create instance: axi_ethernet_0_refclk, and set properties
  set axi_ethernet_0_refclk [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 axi_ethernet_0_refclk ]
  set_property -dict [list \
    CONFIG.CLKIN1_JITTER_PS {50.0} \
    CONFIG.CLKOUT1_DRIVES {BUFG} \
    CONFIG.CLKOUT1_JITTER {82.461} \
    CONFIG.CLKOUT1_MATCHED_ROUTING {true} \
    CONFIG.CLKOUT1_PHASE_ERROR {80.662} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {333.33333} \
    CONFIG.CLKOUT2_DRIVES {BUFG} \
    CONFIG.CLKOUT2_JITTER {99.538} \
    CONFIG.CLKOUT2_MATCHED_ROUTING {true} \
    CONFIG.CLKOUT2_PHASE_ERROR {80.662} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {125} \
    CONFIG.CLKOUT2_USED {true} \
    CONFIG.CLKOUT3_DRIVES {BUFG} \
    CONFIG.CLKOUT3_JITTER {87.134} \
    CONFIG.CLKOUT3_MATCHED_ROUTING {true} \
    CONFIG.CLKOUT3_PHASE_ERROR {80.662} \
    CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {250.000} \
    CONFIG.CLKOUT3_USED {true} \
    CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {6.250} \
    CONFIG.MMCM_CLKIN1_PERIOD {5.000} \
    CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {3.750} \
    CONFIG.MMCM_CLKOUT1_DIVIDE {10} \
    CONFIG.MMCM_CLKOUT2_DIVIDE {5} \
    CONFIG.NUM_OUT_CLKS {3} \
    CONFIG.OPTIMIZE_CLOCKING_STRUCTURE_EN {true} \
    CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
    CONFIG.USE_LOCKED {false} \
    CONFIG.USE_RESET {false} \
  ] $axi_ethernet_0_refclk


  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [list \
    CONFIG.ADVANCED_PROPERTIES { __view__ { functional { S01_Buffer { R_SIZE 512 } M00_Buffer { R_SIZE 512 } } }} \
    CONFIG.NUM_CLKS {2} \
    CONFIG.NUM_MI {6} \
    CONFIG.NUM_SI {3} \
  ] $smartconnect_0


  # Create instance: proc_sys_reset_0, and set properties
  set proc_sys_reset_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_0 ]

  # Create instance: proc_sys_reset_1, and set properties
  set proc_sys_reset_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 proc_sys_reset_1 ]

  # Create instance: util_ds_buf_1, and set properties
  set util_ds_buf_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_1 ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $util_ds_buf_1


  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [list \
    CONFIG.ALL_PROBE_SAME_MU_CNT {2} \
    CONFIG.C_ADV_TRIGGER {true} \
    CONFIG.C_DATA_DEPTH {4096} \
    CONFIG.C_EN_STRG_QUAL {1} \
    CONFIG.C_INPUT_PIPE_STAGES {4} \
    CONFIG.C_MON_TYPE {MIX} \
    CONFIG.C_NUM_MONITOR_SLOTS {1} \
    CONFIG.C_NUM_OF_PROBES {3} \
    CONFIG.C_PROBE0_MU_CNT {2} \
    CONFIG.C_PROBE1_MU_CNT {2} \
    CONFIG.C_PROBE2_MU_CNT {2} \
    CONFIG.C_SLOT {0} \
    CONFIG.C_SLOT_0_MAX_RD_BURSTS {8} \
    CONFIG.C_SLOT_0_MAX_WR_BURSTS {8} \
    CONFIG.C_TRIGOUT_EN {true} \
  ] $system_ila_0


  # Create instance: xlconstant_0, and set properties
  set xlconstant_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_0 ]
  set_property CONFIG.CONST_VAL {0} $xlconstant_0


  # Create instance: xlconstant_1, and set properties
  set xlconstant_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 xlconstant_1 ]

  # Create instance: system_ila_1, and set properties
  set system_ila_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_1 ]
  set_property -dict [list \
    CONFIG.C_ADV_TRIGGER {true} \
    CONFIG.C_DATA_DEPTH {4096} \
    CONFIG.C_EN_STRG_QUAL {1} \
    CONFIG.C_INPUT_PIPE_STAGES {3} \
    CONFIG.C_MON_TYPE {INTERFACE} \
    CONFIG.C_NUM_MONITOR_SLOTS {1} \
    CONFIG.C_SLOT_0_APC_EN {1} \
    CONFIG.C_SLOT_0_AXI_AR_SEL_DATA {1} \
    CONFIG.C_SLOT_0_AXI_AR_SEL_TRIG {1} \
    CONFIG.C_SLOT_0_AXI_AW_SEL_DATA {1} \
    CONFIG.C_SLOT_0_AXI_AW_SEL_TRIG {1} \
    CONFIG.C_SLOT_0_AXI_B_SEL_DATA {1} \
    CONFIG.C_SLOT_0_AXI_B_SEL_TRIG {1} \
    CONFIG.C_SLOT_0_AXI_R_SEL_DATA {1} \
    CONFIG.C_SLOT_0_AXI_R_SEL_TRIG {1} \
    CONFIG.C_SLOT_0_AXI_W_SEL_DATA {1} \
    CONFIG.C_SLOT_0_AXI_W_SEL_TRIG {1} \
    CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:aximm_rtl:1.0} \
    CONFIG.C_SLOT_0_MAX_RD_BURSTS {8} \
    CONFIG.C_SLOT_0_MAX_WR_BURSTS {8} \
    CONFIG.C_TRIGIN_EN {true} \
  ] $system_ila_1


  # Create instance: jtag_axi_0, and set properties
  set jtag_axi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi:1.2 jtag_axi_0 ]
  set_property -dict [list \
    CONFIG.M_AXI_ADDR_WIDTH {64} \
    CONFIG.M_AXI_DATA_WIDTH {32} \
    CONFIG.PROTOCOL {2} \
    CONFIG.RD_TXN_QUEUE_LENGTH {8} \
    CONFIG.WR_TXN_QUEUE_LENGTH {8} \
  ] $jtag_axi_0


  # Create instance: AESKeyFinder_v1_0_0, and set properties
  set block_name AESKeyFinder_v1_0
  set block_cell_name AESKeyFinder_v1_0_0
  if { [catch {set AESKeyFinder_v1_0_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2095 -severity "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $AESKeyFinder_v1_0_0 eq "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2096 -severity "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
    set_property -dict [list \
    CONFIG.C_AESKEYFINDER_AUTO_RUN {0} \
    CONFIG.C_AESKEYFINDER_PCIE_ENABLE {0} \
  ] $AESKeyFinder_v1_0_0


  # Create instance: system_ila_2, and set properties
  set system_ila_2 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_2 ]
  set_property -dict [list \
    CONFIG.C_ADV_TRIGGER {true} \
    CONFIG.C_DATA_DEPTH {2048} \
    CONFIG.C_EN_STRG_QUAL {1} \
    CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:display_xdma:pcie_debug_rtl:1.0} \
  ] $system_ila_2


  # Create interface connections
  connect_bd_intf_net -intf_net AESKeyFinder_v1_0_0_m00_axi [get_bd_intf_pins AESKeyFinder_v1_0_0/m00_axi] [get_bd_intf_pins smartconnect_0/S01_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets AESKeyFinder_v1_0_0_m00_axi] [get_bd_intf_pins AESKeyFinder_v1_0_0/m00_axi] [get_bd_intf_pins system_ila_0/SLOT_0_AXI]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets AESKeyFinder_v1_0_0_m00_axi]
  connect_bd_intf_net -intf_net CLK_IN1_D_0_1 [get_bd_intf_ports CLK_IN1_D_0] [get_bd_intf_pins axi_ethernet_0_refclk/CLK_IN1_D]
  connect_bd_intf_net -intf_net CLK_IN_D_0_1 [get_bd_intf_ports PCIE_CLK] [get_bd_intf_pins util_ds_buf_1/CLK_IN_D]
connect_bd_intf_net -intf_net Conn [get_bd_intf_pins xdma_0/pcie_debug_ports] [get_bd_intf_pins system_ila_2/SLOT_0_PCIE_DEBUG]
  connect_bd_intf_net -intf_net axi_ethernet_0_fifo_AXI_STR_TXC [get_bd_intf_pins axi_ethernet_0_fifo/AXI_STR_TXC] [get_bd_intf_pins axi_ethernet_0/s_axis_txc]
  connect_bd_intf_net -intf_net axi_ethernet_0_fifo_AXI_STR_TXD [get_bd_intf_pins axi_ethernet_0_fifo/AXI_STR_TXD] [get_bd_intf_pins axi_ethernet_0/s_axis_txd]
  connect_bd_intf_net -intf_net axi_ethernet_0_m_axis_rxd [get_bd_intf_pins axi_ethernet_0_fifo/AXI_STR_RXD] [get_bd_intf_pins axi_ethernet_0/m_axis_rxd]
  connect_bd_intf_net -intf_net axi_ethernet_0_mdio [get_bd_intf_ports mdio_rtl_0] [get_bd_intf_pins axi_ethernet_0/mdio]
  connect_bd_intf_net -intf_net axi_ethernet_0_rgmii [get_bd_intf_ports rgmii_rtl_0] [get_bd_intf_pins axi_ethernet_0/rgmii]
  connect_bd_intf_net -intf_net jtag_axi_0_M_AXI [get_bd_intf_pins smartconnect_0/S02_AXI] [get_bd_intf_pins jtag_axi_0/M_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins xdma_0/S_AXI_B]
connect_bd_intf_net -intf_net [get_bd_intf_nets smartconnect_0_M00_AXI] [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins system_ila_1/SLOT_0_AXI]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets smartconnect_0_M00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins smartconnect_0/M01_AXI] [get_bd_intf_pins xdma_0/S_AXI_LITE]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins smartconnect_0/M02_AXI] [get_bd_intf_pins axi_ethernet_0/s_axi]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins smartconnect_0/M03_AXI] [get_bd_intf_pins axi_ethernet_0_fifo/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M04_AXI [get_bd_intf_pins axi_ethernet_0_fifo/S_AXI_FULL] [get_bd_intf_pins smartconnect_0/M04_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M05_AXI [get_bd_intf_pins AESKeyFinder_v1_0_0/s00_axi] [get_bd_intf_pins smartconnect_0/M05_AXI]
  connect_bd_intf_net -intf_net system_ila_0_TRIG_OUT [get_bd_intf_pins system_ila_0/TRIG_OUT] [get_bd_intf_pins system_ila_1/TRIG_IN]
  connect_bd_intf_net -intf_net xdma_0_M_AXI_B [get_bd_intf_pins xdma_0/M_AXI_B] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net xdma_0_pcie_mgt [get_bd_intf_ports pcie_7x_mgt_rtl_0] [get_bd_intf_pins xdma_0/pcie_mgt]

  # Create port connections
  connect_bd_net -net AESKeyFinder_v1_0_0_aeskeyfinder_active [get_bd_pins AESKeyFinder_v1_0_0/aeskeyfinder_active] [get_bd_ports aeskeyfinder_active_0]
  connect_bd_net -net AESKeyFinder_v1_0_0_exec_read_state_wire [get_bd_pins AESKeyFinder_v1_0_0/exec_read_state_wire] [get_bd_pins system_ila_0/probe0]
  connect_bd_net -net AESKeyFinder_v1_0_0_exec_write_state_wire [get_bd_pins AESKeyFinder_v1_0_0/exec_write_state_wire] [get_bd_pins system_ila_0/probe1]
  connect_bd_net -net axi_ethernet_0_fifo_interrupt [get_bd_pins axi_ethernet_0_fifo/interrupt] [get_bd_pins system_ila_0/probe2]
  connect_bd_net -net axi_ethernet_0_fifo_mm2s_cntrl_reset_out_n [get_bd_pins axi_ethernet_0_fifo/mm2s_cntrl_reset_out_n] [get_bd_pins axi_ethernet_0/axi_txc_arstn]
  connect_bd_net -net axi_ethernet_0_fifo_mm2s_prmry_reset_out_n [get_bd_pins axi_ethernet_0_fifo/mm2s_prmry_reset_out_n] [get_bd_pins axi_ethernet_0/axi_txd_arstn]
  connect_bd_net -net axi_ethernet_0_fifo_s2mm_prmry_reset_out_n [get_bd_pins axi_ethernet_0_fifo/s2mm_prmry_reset_out_n] [get_bd_pins axi_ethernet_0/axi_rxd_arstn] [get_bd_pins axi_ethernet_0/axi_rxs_arstn]
  connect_bd_net -net axi_ethernet_0_phy_rst_n [get_bd_pins axi_ethernet_0/phy_rst_n] [get_bd_ports reset_rtl_0]
  connect_bd_net -net axi_ethernet_0_refclk_clk_out1 [get_bd_pins axi_ethernet_0_refclk/clk_out1] [get_bd_pins axi_ethernet_0/ref_clk] [get_bd_pins system_ila_2/clk]
  connect_bd_net -net axi_ethernet_0_refclk_clk_out2 [get_bd_pins axi_ethernet_0_refclk/clk_out2] [get_bd_pins axi_ethernet_0/gtx_clk]
  connect_bd_net -net clk_wiz_0_clk_out1 [get_bd_pins axi_ethernet_0_refclk/clk_out3] [get_bd_pins axi_ethernet_0/s_axi_lite_clk] [get_bd_pins axi_ethernet_0/axis_clk] [get_bd_pins axi_ethernet_0_fifo/s_axi_aclk] [get_bd_pins proc_sys_reset_1/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk1] [get_bd_pins system_ila_0/clk] [get_bd_pins jtag_axi_0/aclk] [get_bd_pins AESKeyFinder_v1_0_0/axi_aclk]
  connect_bd_net -net proc_sys_reset_0_interconnect_aresetn [get_bd_pins proc_sys_reset_0/interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net proc_sys_reset_0_peripheral_aresetn [get_bd_pins proc_sys_reset_0/peripheral_aresetn] [get_bd_pins proc_sys_reset_1/ext_reset_in]
  connect_bd_net -net proc_sys_reset_1_peripheral_aresetn [get_bd_pins proc_sys_reset_1/peripheral_aresetn] [get_bd_pins axi_ethernet_0/s_axi_lite_resetn] [get_bd_pins axi_ethernet_0_fifo/s_axi_aresetn] [get_bd_pins system_ila_0/resetn] [get_bd_pins jtag_axi_0/aresetn] [get_bd_pins AESKeyFinder_v1_0_0/axi_aresetn]
  connect_bd_net -net sys_rst_n_0_1 [get_bd_ports FPGA_PCIE_PERST_N] [get_bd_pins xdma_0/sys_rst_n]
  connect_bd_net -net util_ds_buf_1_IBUF_DS_ODIV2 [get_bd_pins util_ds_buf_1/IBUF_DS_ODIV2] [get_bd_pins xdma_0/sys_clk]
  connect_bd_net -net util_ds_buf_1_IBUF_OUT [get_bd_pins util_ds_buf_1/IBUF_OUT] [get_bd_pins xdma_0/sys_clk_gt]
  connect_bd_net -net xdma_0_axi_aclk [get_bd_pins xdma_0/axi_aclk] [get_bd_pins proc_sys_reset_0/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins system_ila_1/clk]
  connect_bd_net -net xdma_0_axi_aresetn [get_bd_pins xdma_0/axi_aresetn] [get_bd_pins proc_sys_reset_0/ext_reset_in] [get_bd_pins system_ila_1/resetn]
  connect_bd_net -net xdma_0_axi_ctl_aresetn [get_bd_pins xdma_0/axi_ctl_aresetn] [get_bd_pins proc_sys_reset_0/aux_reset_in]
  connect_bd_net -net xdma_0_interrupt_out [get_bd_pins xdma_0/interrupt_out] [get_bd_ports interrupt_out_0]
  connect_bd_net -net xdma_0_user_lnk_up [get_bd_pins xdma_0/user_lnk_up] [get_bd_ports user_lnk_up_0]
  connect_bd_net -net xlconstant_0_dout [get_bd_pins xlconstant_0/dout] [get_bd_pins AESKeyFinder_v1_0_0/interrput_in]
  connect_bd_net -net xlconstant_1_dout [get_bd_pins xlconstant_1/dout] [get_bd_ports dout_0]

  # Create address segments
  assign_bd_address -offset 0xC0001000 -range 0x00001000 -target_address_space [get_bd_addr_spaces xdma_0/M_AXI_B] [get_bd_addr_segs AESKeyFinder_v1_0_0/s00_axi/reg0] -force
  assign_bd_address -offset 0xC0003000 -range 0x00001000 -target_address_space [get_bd_addr_spaces xdma_0/M_AXI_B] [get_bd_addr_segs axi_ethernet_0/s_axi/Reg0] -force
  assign_bd_address -offset 0xC0004000 -range 0x00001000 -target_address_space [get_bd_addr_spaces xdma_0/M_AXI_B] [get_bd_addr_segs axi_ethernet_0_fifo/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces xdma_0/M_AXI_B] [get_bd_addr_segs xdma_0/S_AXI_LITE/CTL0] -force
  assign_bd_address -offset 0xC0001000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs AESKeyFinder_v1_0_0/s00_axi/reg0] -force
  assign_bd_address -offset 0xC0003000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_ethernet_0/s_axi/Reg0] -force
  assign_bd_address -offset 0xC0004000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_ethernet_0_fifo/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_ethernet_0_fifo/S_AXI_FULL/Mem1] -force
  assign_bd_address -offset 0xC0000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs xdma_0/S_AXI_LITE/CTL0] -force
  assign_bd_address -offset 0xC0001000 -range 0x00001000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs AESKeyFinder_v1_0_0/s00_axi/reg0] -force
  assign_bd_address -offset 0xC0003000 -range 0x00001000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs axi_ethernet_0/s_axi/Reg0] -force
  assign_bd_address -offset 0xC0004000 -range 0x00001000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs axi_ethernet_0_fifo/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs axi_ethernet_0_fifo/S_AXI_FULL/Mem1] -force
  assign_bd_address -offset 0x000100000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs xdma_0/S_AXI_B/BAR0] -force
  assign_bd_address -offset 0x000200000000 -range 0x000200000000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs xdma_0/S_AXI_B/BAR1] -force
  assign_bd_address -offset 0x000400000000 -range 0x000400000000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs xdma_0/S_AXI_B/BAR2] -force
  assign_bd_address -offset 0x000800000000 -range 0x000800000000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs xdma_0/S_AXI_B/BAR3] -force
  assign_bd_address -offset 0x001000000000 -range 0x001000000000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs xdma_0/S_AXI_B/BAR4] -force
  assign_bd_address -offset 0x002000000000 -range 0x002000000000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs xdma_0/S_AXI_B/BAR5] -force
  assign_bd_address -offset 0xC0000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs xdma_0/S_AXI_LITE/CTL0] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -offset 0x001000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs xdma_0/S_AXI_B/BAR0]
  exclude_bd_addr_seg -offset 0x002000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs xdma_0/S_AXI_B/BAR1]
  exclude_bd_addr_seg -offset 0x003000000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs xdma_0/S_AXI_B/BAR2]
  exclude_bd_addr_seg -offset 0x004000000000 -range 0x000F00000000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs xdma_0/S_AXI_B/BAR3]
  exclude_bd_addr_seg -offset 0x001000000000 -range 0x001000000000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs xdma_0/S_AXI_B/BAR4]
  exclude_bd_addr_seg -offset 0x002000000000 -range 0x002000000000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs xdma_0/S_AXI_B/BAR5]
  exclude_bd_addr_seg -offset 0xC0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces xdma_0/M_AXI_B] [get_bd_addr_segs axi_ethernet_0_fifo/S_AXI_FULL/Mem1]
  exclude_bd_addr_seg -offset 0x000100000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces xdma_0/M_AXI_B] [get_bd_addr_segs xdma_0/S_AXI_B/BAR0]
  exclude_bd_addr_seg -offset 0x000300000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces xdma_0/M_AXI_B] [get_bd_addr_segs xdma_0/S_AXI_B/BAR1]
  exclude_bd_addr_seg -offset 0x000400000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces xdma_0/M_AXI_B] [get_bd_addr_segs xdma_0/S_AXI_B/BAR2]
  exclude_bd_addr_seg -offset 0x000100000000 -range 0x000F00000000 -target_address_space [get_bd_addr_spaces xdma_0/M_AXI_B] [get_bd_addr_segs xdma_0/S_AXI_B/BAR3]
  exclude_bd_addr_seg -offset 0x001000000000 -range 0x001000000000 -target_address_space [get_bd_addr_spaces xdma_0/M_AXI_B] [get_bd_addr_segs xdma_0/S_AXI_B/BAR4]
  exclude_bd_addr_seg -offset 0x002000000000 -range 0x002000000000 -target_address_space [get_bd_addr_spaces xdma_0/M_AXI_B] [get_bd_addr_segs xdma_0/S_AXI_B/BAR5]


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


