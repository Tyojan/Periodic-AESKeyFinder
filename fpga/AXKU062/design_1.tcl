
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
   create_project project_1 myproj -part xcku060-ffva1156-2-i
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
xilinx.com:ip:axi_pcie3:3.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:axi_ethernet:7.2\
xilinx.com:ip:axi_fifo_mm_s:4.3\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:system_ila:1.1\
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
  set pcie_7x_mgt_rtl_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_7x_mgt_rtl_0 ]

  set mdio_rtl_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:mdio_rtl:1.0 mdio_rtl_0 ]

  set rgmii_rtl_0 [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:rgmii_rtl:1.0 rgmii_rtl_0 ]

  set CLK_IN_D_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN_D_0 ]

  set clk_200MHz [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 clk_200MHz ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {200000000} \
   ] $clk_200MHz


  # Create ports
  set reset_rtl_0 [ create_bd_port -dir I -type rst reset_rtl_0 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $reset_rtl_0
  set user_link_up_0 [ create_bd_port -dir O user_link_up_0 ]
  set led [ create_bd_port -dir O -from 3 -to 0 led ]
  set e_reset [ create_bd_port -dir O -from 0 -to 0 -type rst e_reset ]
  set aeskeyfinder_active_0 [ create_bd_port -dir O aeskeyfinder_active_0 ]

  # Create instance: axi_pcie3_0, and set properties
  set axi_pcie3_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_pcie3:3.0 axi_pcie3_0 ]
  set_property -dict [list \
    CONFIG.AXIBAR_NUM {1} \
    CONFIG.axi_addr_width {40} \
    CONFIG.axi_data_width {256_bit} \
    CONFIG.axibar2pciebar_0 {0x0000000100000000} \
    CONFIG.axisten_freq {250} \
    CONFIG.c_s_axi_supports_narrow_burst {true} \
    CONFIG.dedicate_perst {true} \
    CONFIG.device_port_type {PCI_Express_Endpoint_device} \
    CONFIG.en_debug_ports {true} \
    CONFIG.en_ext_ch_gt_drp {false} \
    CONFIG.en_gt_selection {false} \
    CONFIG.en_pcie_drp {false} \
    CONFIG.en_transceiver_status_ports {false} \
    CONFIG.enable_ibert {false} \
    CONFIG.enable_jtag_dbg {true} \
    CONFIG.gt_drp_clk_src {Internal} \
    CONFIG.mcap_enablement {Tandem} \
    CONFIG.mode_selection {Advanced} \
    CONFIG.pciebar2axibar_0 {0xC0000000} \
    CONFIG.pf0_bar0_64bit {true} \
    CONFIG.pf0_bar0_size {64} \
    CONFIG.pipe_sim {false} \
    CONFIG.pl_link_cap_max_link_speed {8.0_GT/s} \
    CONFIG.pl_link_cap_max_link_width {X8} \
    CONFIG.ref_clk_freq {100_MHz} \
  ] $axi_pcie3_0


  # Create instance: rst_axi, and set properties
  set rst_axi [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_axi ]

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_DOUT_DEFAULT {0x00000007} \
    CONFIG.C_GPIO_WIDTH {4} \
    CONFIG.C_INTERRUPT_PRESENT {0} \
  ] $axi_gpio_0


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
    CONFIG.C_AESKEYFINDER_DST_ADDR {0x00C0010000} \
    CONFIG.C_AESKEYFINDER_FIFO_BASE_ADDR {0xC0004000} \
    CONFIG.C_AESKEYFINDER_READ_PAGES {0x00100000} \
    CONFIG.C_AESKEYFINDER_SRC_ADDR {0x0100000000} \
  ] $AESKeyFinder_v1_0_0


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
    CONFIG.C_AXIS_TUSER_WIDTH {4} \
    CONFIG.C_DATA_INTERFACE_TYPE {1} \
    CONFIG.C_HAS_AXIS_TDEST {false} \
    CONFIG.C_HAS_AXIS_TKEEP {true} \
    CONFIG.C_HAS_AXIS_TSTRB {true} \
    CONFIG.C_RX_FIFO_DEPTH {4096} \
    CONFIG.C_RX_FIFO_PE_THRESHOLD {10} \
    CONFIG.C_RX_FIFO_PF_THRESHOLD {4000} \
    CONFIG.C_S_AXI4_DATA_WIDTH {32} \
    CONFIG.C_TX_FIFO_DEPTH {4096} \
    CONFIG.C_TX_FIFO_PE_THRESHOLD {10} \
    CONFIG.C_TX_FIFO_PF_THRESHOLD {4000} \
    CONFIG.C_USE_TX_CUT_THROUGH {1} \
    CONFIG.TX_ENABLE_ECC {0} \
  ] $axi_ethernet_0_fifo


  # Create instance: axi_refclk, and set properties
  set axi_refclk [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 axi_refclk ]
  set_property -dict [list \
    CONFIG.AUTO_PRIMITIVE {PLL} \
    CONFIG.CLKIN1_JITTER_PS {50.0} \
    CONFIG.CLKIN2_JITTER_PS {40.0} \
    CONFIG.CLKOUT1_DRIVES {BUFG} \
    CONFIG.CLKOUT1_JITTER {93.990} \
    CONFIG.CLKOUT1_MATCHED_ROUTING {true} \
    CONFIG.CLKOUT1_PHASE_ERROR {89.971} \
    CONFIG.CLKOUT1_REQUESTED_DUTY_CYCLE {50.0} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {250} \
    CONFIG.CLKOUT1_USED {true} \
    CONFIG.CLKOUT2_DRIVES {Buffer} \
    CONFIG.CLKOUT2_JITTER {151.366} \
    CONFIG.CLKOUT2_MATCHED_ROUTING {false} \
    CONFIG.CLKOUT2_PHASE_ERROR {132.063} \
    CONFIG.CLKOUT2_REQUESTED_DUTY_CYCLE {50.0} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {200.000} \
    CONFIG.CLKOUT2_USED {false} \
    CONFIG.CLKOUT3_DRIVES {Buffer} \
    CONFIG.CLKOUT3_JITTER {151.366} \
    CONFIG.CLKOUT3_MATCHED_ROUTING {false} \
    CONFIG.CLKOUT3_PHASE_ERROR {132.063} \
    CONFIG.CLKOUT3_REQUESTED_DUTY_CYCLE {50.000} \
    CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {200.000} \
    CONFIG.CLKOUT3_USED {false} \
    CONFIG.CLKOUT4_DRIVES {Buffer} \
    CONFIG.CLKOUT4_JITTER {111.894} \
    CONFIG.CLKOUT4_PHASE_ERROR {225.117} \
    CONFIG.CLKOUT4_REQUESTED_DUTY_CYCLE {50.000} \
    CONFIG.CLKOUT4_REQUESTED_OUT_FREQ {200.000} \
    CONFIG.CLKOUT4_USED {false} \
    CONFIG.CLKOUT5_DRIVES {Buffer} \
    CONFIG.CLKOUT5_REQUESTED_OUT_FREQ {200.000} \
    CONFIG.CLKOUT6_DRIVES {Buffer} \
    CONFIG.CLKOUT6_REQUESTED_OUT_FREQ {200.000} \
    CONFIG.CLKOUT7_DRIVES {Buffer} \
    CONFIG.CLKOUT7_REQUESTED_OUT_FREQ {200.000} \
    CONFIG.CLK_OUT1_PORT {clok_out_250} \
    CONFIG.CLK_OUT2_PORT {clk_out_125} \
    CONFIG.CLK_OUT3_PORT {clk_out_250} \
    CONFIG.ENABLE_CLOCK_MONITOR {false} \
    CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
    CONFIG.JITTER_SEL {No_Jitter} \
    CONFIG.MMCM_BANDWIDTH {OPTIMIZED} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {5} \
    CONFIG.MMCM_CLKIN1_PERIOD {5.000} \
    CONFIG.MMCM_CLKIN2_PERIOD {4.000} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {4} \
    CONFIG.MMCM_CLKOUT0_DUTY_CYCLE {0.500} \
    CONFIG.MMCM_CLKOUT1_DIVIDE {1} \
    CONFIG.MMCM_CLKOUT1_DUTY_CYCLE {0.500} \
    CONFIG.MMCM_CLKOUT2_DIVIDE {1} \
    CONFIG.MMCM_CLKOUT3_DIVIDE {1} \
    CONFIG.MMCM_COMPENSATION {AUTO} \
    CONFIG.MMCM_DIVCLK_DIVIDE {1} \
    CONFIG.NUM_OUT_CLKS {1} \
    CONFIG.OPTIMIZE_CLOCKING_STRUCTURE_EN {true} \
    CONFIG.OVERRIDE_MMCM {false} \
    CONFIG.PHASESHIFT_MODE {WAVEFORM} \
    CONFIG.PRIMITIVE {Auto} \
    CONFIG.PRIM_IN_FREQ {200.000} \
    CONFIG.PRIM_SOURCE {Global_buffer} \
    CONFIG.RESET_PORT {resetn} \
    CONFIG.RESET_TYPE {ACTIVE_LOW} \
    CONFIG.SECONDARY_IN_FREQ {250.000} \
    CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
    CONFIG.USE_DYN_PHASE_SHIFT {false} \
    CONFIG.USE_FREQ_SYNTH {true} \
    CONFIG.USE_INCLK_SWITCHOVER {false} \
    CONFIG.USE_LOCKED {true} \
    CONFIG.USE_MIN_POWER {false} \
    CONFIG.USE_PHASE_ALIGNMENT {false} \
    CONFIG.USE_RESET {false} \
    CONFIG.USE_SAFE_CLOCK_STARTUP {false} \
    CONFIG.USE_SPREAD_SPECTRUM {false} \
  ] $axi_refclk


  # Create instance: util_ds_buf_0, and set properties
  set util_ds_buf_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 util_ds_buf_0 ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $util_ds_buf_0


  # Create instance: reset_pci, and set properties
  set reset_pci [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_pci ]

  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [list \
    CONFIG.ADVANCED_PROPERTIES { __view__ { functional { S01_Buffer { R_SIZE 512 } M06_Buffer { R_SIZE 1024 } } }} \
    CONFIG.NUM_CLKS {3} \
    CONFIG.NUM_MI {7} \
    CONFIG.NUM_SI {3} \
  ] $smartconnect_0


  # Create instance: eth_clk, and set properties
  set eth_clk [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 eth_clk ]
  set_property -dict [list \
    CONFIG.AUTO_PRIMITIVE {PLL} \
    CONFIG.AXI_DRP {false} \
    CONFIG.CLKIN1_JITTER_PS {50.0} \
    CONFIG.CLKOUT1_DRIVES {Buffer} \
    CONFIG.CLKOUT1_JITTER {88.896} \
    CONFIG.CLKOUT1_PHASE_ERROR {89.971} \
    CONFIG.CLKOUT1_REQUESTED_DUTY_CYCLE {50.0} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {333.33333} \
    CONFIG.CLKOUT2_DRIVES {Buffer} \
    CONFIG.CLKOUT2_JITTER {107.523} \
    CONFIG.CLKOUT2_PHASE_ERROR {89.971} \
    CONFIG.CLKOUT2_REQUESTED_DUTY_CYCLE {50.0} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {125.000} \
    CONFIG.CLKOUT2_USED {true} \
    CONFIG.CLKOUT3_DRIVES {Buffer} \
    CONFIG.CLKOUT3_JITTER {129.208} \
    CONFIG.CLKOUT3_PHASE_ERROR {312.872} \
    CONFIG.CLKOUT3_REQUESTED_DUTY_CYCLE {50.000} \
    CONFIG.CLKOUT3_USED {false} \
    CONFIG.CLKOUT4_DRIVES {Buffer} \
    CONFIG.CLKOUT4_JITTER {129.208} \
    CONFIG.CLKOUT4_PHASE_ERROR {312.872} \
    CONFIG.CLKOUT4_REQUESTED_DUTY_CYCLE {50.000} \
    CONFIG.CLKOUT4_USED {false} \
    CONFIG.CLKOUT5_DRIVES {Buffer} \
    CONFIG.CLKOUT6_DRIVES {Buffer} \
    CONFIG.CLKOUT7_DRIVES {Buffer} \
    CONFIG.CLK_OUT1_PORT {clk_out333} \
    CONFIG.CLK_OUT2_PORT {clk_out125} \
    CONFIG.ENABLE_CDDC {false} \
    CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
    CONFIG.JITTER_SEL {No_Jitter} \
    CONFIG.MMCM_BANDWIDTH {OPTIMIZED} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {5} \
    CONFIG.MMCM_CLKIN1_PERIOD {5.000} \
    CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {3} \
    CONFIG.MMCM_CLKOUT0_DUTY_CYCLE {0.500} \
    CONFIG.MMCM_CLKOUT1_DIVIDE {8} \
    CONFIG.MMCM_CLKOUT1_DUTY_CYCLE {0.500} \
    CONFIG.MMCM_CLKOUT2_DIVIDE {1} \
    CONFIG.MMCM_CLKOUT3_DIVIDE {1} \
    CONFIG.MMCM_COMPENSATION {AUTO} \
    CONFIG.MMCM_DIVCLK_DIVIDE {1} \
    CONFIG.NUM_OUT_CLKS {2} \
    CONFIG.OPTIMIZE_CLOCKING_STRUCTURE_EN {true} \
    CONFIG.PHASE_DUTY_CONFIG {false} \
    CONFIG.PRIMITIVE {Auto} \
    CONFIG.PRIM_IN_FREQ {200.000} \
    CONFIG.PRIM_SOURCE {Global_buffer} \
    CONFIG.USE_DYN_PHASE_SHIFT {false} \
    CONFIG.USE_DYN_RECONFIG {false} \
    CONFIG.USE_LOCKED {false} \
    CONFIG.USE_MIN_POWER {false} \
    CONFIG.USE_RESET {false} \
    CONFIG.USE_SAFE_CLOCK_STARTUP {false} \
    CONFIG.USE_SPREAD_SPECTRUM {false} \
  ] $eth_clk


  # Create instance: clk_200MHz, and set properties
  set clk_200MHz [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 clk_200MHz ]

  # Create instance: system_ila_0, and set properties
  set system_ila_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_0 ]
  set_property -dict [list \
    CONFIG.ALL_PROBE_SAME_MU {true} \
    CONFIG.ALL_PROBE_SAME_MU_CNT {2} \
    CONFIG.C_ADV_TRIGGER {true} \
    CONFIG.C_DATA_DEPTH {4096} \
    CONFIG.C_EN_STRG_QUAL {1} \
    CONFIG.C_INPUT_PIPE_STAGES {4} \
    CONFIG.C_MON_TYPE {MIX} \
    CONFIG.C_NUM_MONITOR_SLOTS {1} \
    CONFIG.C_NUM_OF_PROBES {3} \
    CONFIG.C_SLOT {0} \
    CONFIG.C_SLOT_0_APC_EN {0} \
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
    CONFIG.C_SLOT_1_APC_EN {1} \
    CONFIG.C_SLOT_1_AXI_AR_SEL_DATA {1} \
    CONFIG.C_SLOT_1_AXI_AR_SEL_TRIG {1} \
    CONFIG.C_SLOT_1_AXI_AW_SEL_DATA {1} \
    CONFIG.C_SLOT_1_AXI_AW_SEL_TRIG {1} \
    CONFIG.C_SLOT_1_AXI_B_SEL_DATA {1} \
    CONFIG.C_SLOT_1_AXI_B_SEL_TRIG {1} \
    CONFIG.C_SLOT_1_AXI_R_SEL_DATA {1} \
    CONFIG.C_SLOT_1_AXI_R_SEL_TRIG {1} \
    CONFIG.C_SLOT_1_AXI_W_SEL_DATA {1} \
    CONFIG.C_SLOT_1_AXI_W_SEL_TRIG {1} \
    CONFIG.C_SLOT_1_INTF_TYPE {xilinx.com:interface:aximm_rtl:1.0} \
    CONFIG.C_SLOT_1_MAX_RD_BURSTS {8} \
    CONFIG.C_SLOT_1_MAX_WR_BURSTS {8} \
    CONFIG.C_SLOT_1_TYPE {0} \
    CONFIG.C_SLOT_2_APC_EN {0} \
    CONFIG.C_SLOT_2_AXI_AR_SEL_DATA {1} \
    CONFIG.C_SLOT_2_AXI_AR_SEL_TRIG {1} \
    CONFIG.C_SLOT_2_AXI_AW_SEL_DATA {1} \
    CONFIG.C_SLOT_2_AXI_AW_SEL_TRIG {1} \
    CONFIG.C_SLOT_2_AXI_B_SEL_DATA {1} \
    CONFIG.C_SLOT_2_AXI_B_SEL_TRIG {1} \
    CONFIG.C_SLOT_2_AXI_R_SEL_DATA {1} \
    CONFIG.C_SLOT_2_AXI_R_SEL_TRIG {1} \
    CONFIG.C_SLOT_2_AXI_W_SEL_DATA {1} \
    CONFIG.C_SLOT_2_AXI_W_SEL_TRIG {1} \
    CONFIG.C_SLOT_2_INTF_TYPE {xilinx.com:interface:aximm_rtl:1.0} \
    CONFIG.C_SLOT_2_MAX_RD_BURSTS {4} \
    CONFIG.C_SLOT_2_MAX_WR_BURSTS {4} \
    CONFIG.C_TRIGOUT_EN {true} \
  ] $system_ila_0


  # Create instance: system_ila_1, and set properties
  set system_ila_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_1 ]
  set_property -dict [list \
    CONFIG.C_DATA_DEPTH {4096} \
    CONFIG.C_EN_STRG_QUAL {0} \
    CONFIG.C_INPUT_PIPE_STAGES {4} \
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
    CONFIG.C_TRIGIN_EN {true} \
  ] $system_ila_1


  # Create instance: jtag_axi_0, and set properties
  set jtag_axi_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:jtag_axi:1.2 jtag_axi_0 ]
  set_property -dict [list \
    CONFIG.M_AXI_ADDR_WIDTH {32} \
    CONFIG.PROTOCOL {2} \
    CONFIG.RD_TXN_QUEUE_LENGTH {8} \
    CONFIG.WR_TXN_QUEUE_LENGTH {8} \
  ] $jtag_axi_0


  # Create interface connections
  connect_bd_intf_net -intf_net AESKeyFinder_v1_0_0_m00_axi [get_bd_intf_pins AESKeyFinder_v1_0_0/m00_axi] [get_bd_intf_pins smartconnect_0/S01_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets AESKeyFinder_v1_0_0_m00_axi] [get_bd_intf_pins AESKeyFinder_v1_0_0/m00_axi] [get_bd_intf_pins system_ila_0/SLOT_0_AXI]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets AESKeyFinder_v1_0_0_m00_axi]
  connect_bd_intf_net -intf_net CLK_IN_D_0_1 [get_bd_intf_ports CLK_IN_D_0] [get_bd_intf_pins util_ds_buf_0/CLK_IN_D]
  connect_bd_intf_net -intf_net CLK_IN_D_1_1 [get_bd_intf_ports clk_200MHz] [get_bd_intf_pins clk_200MHz/CLK_IN_D]
  connect_bd_intf_net -intf_net axi_ethernet_0_fifo_AXI_STR_TXC [get_bd_intf_pins axi_ethernet_0_fifo/AXI_STR_TXC] [get_bd_intf_pins axi_ethernet_0/s_axis_txc]
  connect_bd_intf_net -intf_net axi_ethernet_0_fifo_AXI_STR_TXD [get_bd_intf_pins axi_ethernet_0_fifo/AXI_STR_TXD] [get_bd_intf_pins axi_ethernet_0/s_axis_txd]
  connect_bd_intf_net -intf_net axi_ethernet_0_m_axis_rxd [get_bd_intf_pins axi_ethernet_0_fifo/AXI_STR_RXD] [get_bd_intf_pins axi_ethernet_0/m_axis_rxd]
  connect_bd_intf_net -intf_net axi_ethernet_0_mdio [get_bd_intf_ports mdio_rtl_0] [get_bd_intf_pins axi_ethernet_0/mdio]
  connect_bd_intf_net -intf_net axi_ethernet_0_rgmii [get_bd_intf_ports rgmii_rtl_0] [get_bd_intf_pins axi_ethernet_0/rgmii]
  connect_bd_intf_net -intf_net axi_interconnect_M02_AXI [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins AESKeyFinder_v1_0_0/s00_axi]
  connect_bd_intf_net -intf_net axi_pcie3_0_M_AXI [get_bd_intf_pins axi_pcie3_0/M_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net axi_pcie3_0_pcie_7x_mgt [get_bd_intf_ports pcie_7x_mgt_rtl_0] [get_bd_intf_pins axi_pcie3_0/pcie_7x_mgt]
  connect_bd_intf_net -intf_net jtag_axi_0_M_AXI [get_bd_intf_pins jtag_axi_0/M_AXI] [get_bd_intf_pins smartconnect_0/S02_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins smartconnect_0/M01_AXI] [get_bd_intf_pins axi_ethernet_0_fifo/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins smartconnect_0/M02_AXI] [get_bd_intf_pins axi_ethernet_0_fifo/S_AXI_FULL]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins axi_ethernet_0/s_axi] [get_bd_intf_pins smartconnect_0/M03_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M04_AXI [get_bd_intf_pins smartconnect_0/M04_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M05_AXI [get_bd_intf_pins smartconnect_0/M05_AXI] [get_bd_intf_pins axi_pcie3_0/S_AXI_CTL]
  connect_bd_intf_net -intf_net smartconnect_0_M06_AXI [get_bd_intf_pins smartconnect_0/M06_AXI] [get_bd_intf_pins axi_pcie3_0/S_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets smartconnect_0_M06_AXI] [get_bd_intf_pins smartconnect_0/M06_AXI] [get_bd_intf_pins system_ila_1/SLOT_0_AXI]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets smartconnect_0_M06_AXI]
  connect_bd_intf_net -intf_net system_ila_0_TRIG_OUT [get_bd_intf_pins system_ila_1/TRIG_IN] [get_bd_intf_pins system_ila_0/TRIG_OUT]

  # Create port connections
  connect_bd_net -net AESKeyFinder_v1_0_0_aeskeyfinder_active [get_bd_pins AESKeyFinder_v1_0_0/aeskeyfinder_active] [get_bd_ports aeskeyfinder_active_0]
  connect_bd_net -net AESKeyFinder_v1_0_0_exec_read_state_wire [get_bd_pins AESKeyFinder_v1_0_0/exec_read_state_wire] [get_bd_pins system_ila_0/probe0]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets AESKeyFinder_v1_0_0_exec_read_state_wire]
  connect_bd_net -net AESKeyFinder_v1_0_0_exec_write_state_wire [get_bd_pins AESKeyFinder_v1_0_0/exec_write_state_wire] [get_bd_pins system_ila_0/probe1]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_nets AESKeyFinder_v1_0_0_exec_write_state_wire]
  connect_bd_net -net axi_ethernet_0_fifo_interrupt [get_bd_pins axi_ethernet_0_fifo/interrupt] [get_bd_pins system_ila_0/probe2]
  connect_bd_net -net axi_ethernet_0_fifo_mm2s_cntrl_reset_out_n [get_bd_pins axi_ethernet_0_fifo/mm2s_cntrl_reset_out_n] [get_bd_pins axi_ethernet_0/axi_txc_arstn]
  connect_bd_net -net axi_ethernet_0_fifo_mm2s_prmry_reset_out_n [get_bd_pins axi_ethernet_0_fifo/mm2s_prmry_reset_out_n] [get_bd_pins axi_ethernet_0/axi_txd_arstn]
  connect_bd_net -net axi_ethernet_0_fifo_s2mm_prmry_reset_out_n [get_bd_pins axi_ethernet_0_fifo/s2mm_prmry_reset_out_n] [get_bd_pins axi_ethernet_0/axi_rxd_arstn] [get_bd_pins axi_ethernet_0/axi_rxs_arstn]
  connect_bd_net -net axi_ethernet_0_phy_rst_n [get_bd_pins axi_ethernet_0/phy_rst_n] [get_bd_ports e_reset]
  connect_bd_net -net axi_ethernet_0_refclk_clk_out_125 [get_bd_pins eth_clk/clk_out125] [get_bd_pins axi_ethernet_0/gtx_clk] [get_bd_pins smartconnect_0/aclk1]
  connect_bd_net -net axi_ethernet_0_refclk_clk_out_250 [get_bd_pins axi_refclk/clok_out_250] [get_bd_pins axi_ethernet_0_fifo/s_axi_aclk] [get_bd_pins axi_ethernet_0/axis_clk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins rst_axi/slowest_sync_clk] [get_bd_pins axi_ethernet_0/s_axi_lite_clk] [get_bd_pins system_ila_0/clk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins jtag_axi_0/aclk] [get_bd_pins AESKeyFinder_v1_0_0/axi_aclk]
  connect_bd_net -net axi_ethernet_0_refclk_locked [get_bd_pins axi_refclk/locked] [get_bd_pins rst_axi/dcm_locked]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_ports led]
  connect_bd_net -net axi_pcie3_0_axi_aclk [get_bd_pins axi_pcie3_0/axi_aclk] [get_bd_pins reset_pci/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk2] [get_bd_pins system_ila_1/clk]
  connect_bd_net -net axi_pcie3_0_axi_aresetn [get_bd_pins axi_pcie3_0/axi_aresetn] [get_bd_pins reset_pci/ext_reset_in] [get_bd_pins system_ila_1/resetn]
  connect_bd_net -net axi_pcie3_0_user_link_up [get_bd_pins axi_pcie3_0/user_link_up] [get_bd_ports user_link_up_0]
  connect_bd_net -net clk_200MHz_IBUF_OUT [get_bd_pins clk_200MHz/IBUF_OUT] [get_bd_pins axi_refclk/clk_in1] [get_bd_pins eth_clk/clk_in1]
  connect_bd_net -net eth_clk_clk_out333 [get_bd_pins eth_clk/clk_out333] [get_bd_pins axi_ethernet_0/ref_clk]
  connect_bd_net -net reset_pci_peripheral_aresetn [get_bd_pins reset_pci/peripheral_aresetn] [get_bd_pins rst_axi/ext_reset_in]
  connect_bd_net -net reset_rtl_0_1 [get_bd_ports reset_rtl_0] [get_bd_pins axi_pcie3_0/sys_rst_n]
  connect_bd_net -net rst_clk_wiz_100M_peripheral_aresetn [get_bd_pins rst_axi/peripheral_aresetn] [get_bd_pins axi_ethernet_0_fifo/s_axi_aresetn] [get_bd_pins axi_ethernet_0/s_axi_lite_resetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins smartconnect_0/aresetn] [get_bd_pins system_ila_0/resetn] [get_bd_pins jtag_axi_0/aresetn] [get_bd_pins AESKeyFinder_v1_0_0/axi_aresetn]
  connect_bd_net -net util_ds_buf_0_IBUF_DS_ODIV2 [get_bd_pins util_ds_buf_0/IBUF_DS_ODIV2] [get_bd_pins axi_pcie3_0/refclk]
  connect_bd_net -net util_ds_buf_0_IBUF_OUT [get_bd_pins util_ds_buf_0/IBUF_OUT] [get_bd_pins axi_pcie3_0/sys_clk_gt]

  # Create address segments
  assign_bd_address -offset 0xC0001000 -range 0x00001000 -target_address_space [get_bd_addr_spaces axi_pcie3_0/M_AXI] [get_bd_addr_segs AESKeyFinder_v1_0_0/s00_axi/reg0] -force
  assign_bd_address -offset 0xC0003000 -range 0x00001000 -target_address_space [get_bd_addr_spaces axi_pcie3_0/M_AXI] [get_bd_addr_segs axi_ethernet_0/s_axi/Reg0] -force
  assign_bd_address -offset 0xC0004000 -range 0x00001000 -target_address_space [get_bd_addr_spaces axi_pcie3_0/M_AXI] [get_bd_addr_segs axi_ethernet_0_fifo/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0002000 -range 0x00001000 -target_address_space [get_bd_addr_spaces axi_pcie3_0/M_AXI] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0x000100000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces axi_pcie3_0/M_AXI] [get_bd_addr_segs axi_pcie3_0/S_AXI/BAR0] -force
  assign_bd_address -offset 0xC0000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces axi_pcie3_0/M_AXI] [get_bd_addr_segs axi_pcie3_0/S_AXI_CTL/CTL0] -force
  assign_bd_address -offset 0xC0003000 -range 0x00001000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs axi_ethernet_0/s_axi/Reg0] -force
  assign_bd_address -offset 0xC0004000 -range 0x00001000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs axi_ethernet_0_fifo/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs axi_ethernet_0_fifo/S_AXI_FULL/Mem1] -force
  assign_bd_address -offset 0x000100000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs axi_pcie3_0/S_AXI/BAR0] -force
  assign_bd_address -offset 0xC0000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs axi_pcie3_0/S_AXI_CTL/CTL0] -force
  assign_bd_address -offset 0xC0001000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs AESKeyFinder_v1_0_0/s00_axi/reg0] -force
  assign_bd_address -offset 0xC0003000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_ethernet_0/s_axi/Reg0] -force
  assign_bd_address -offset 0xC0004000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_ethernet_0_fifo/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0010000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_ethernet_0_fifo/S_AXI_FULL/Mem1] -force
  assign_bd_address -offset 0xC0002000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force
  assign_bd_address -offset 0xC0000000 -range 0x00001000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_pcie3_0/S_AXI_CTL/CTL0] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -offset 0xC0001000 -range 0x00001000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs AESKeyFinder_v1_0_0/s00_axi/reg0]
  exclude_bd_addr_seg -offset 0xC0002000 -range 0x00001000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg]
  exclude_bd_addr_seg -offset 0xC0005000 -range 0x00001000 -target_address_space [get_bd_addr_spaces axi_pcie3_0/M_AXI] [get_bd_addr_segs axi_ethernet_0_fifo/S_AXI_FULL/Mem1]
  exclude_bd_addr_seg -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_pcie3_0/S_AXI/BAR0]


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


