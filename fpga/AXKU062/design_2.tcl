
################################################################
# This is a generated script based on design: design_2
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
# source design_2_script.tcl


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
set design_name design_2

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
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:axi_ethernet:7.2\
xilinx.com:ip:axi_fifo_mm_s:4.3\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:axi_vip:1.1\
xilinx.com:ip:smartconnect:1.0\
xilinx.com:ip:axi_clock_converter:2.1\
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

  set CLK_IN_D_0 [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 CLK_IN_D_0 ]


  # Create ports
  set reset_rtl_0 [ create_bd_port -dir I -type rst reset_rtl_0 ]
  set_property -dict [ list \
   CONFIG.POLARITY {ACTIVE_LOW} \
 ] $reset_rtl_0
  set led [ create_bd_port -dir O -from 3 -to 0 led ]
  set e_reset [ create_bd_port -dir O -from 0 -to 0 -type rst e_reset ]
  set clk_200MHz_p [ create_bd_port -dir I -type clk -freq_hz 200000000 clk_200MHz_p ]
  set clk_200MHz_n [ create_bd_port -dir I -type clk -freq_hz 200000000 clk_200MHz_n ]
  set aeskeyfinder_active_0 [ create_bd_port -dir O aeskeyfinder_active_0 ]

  # Create instance: rst_axi, and set properties
  set rst_axi [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 rst_axi ]

  # Create instance: axi_gpio_0, and set properties
  set axi_gpio_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 axi_gpio_0 ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_DOUT_DEFAULT {0x00000003} \
    CONFIG.C_GPIO_WIDTH {4} \
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
    CONFIG.axiliteclkrate {125} \
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
  ] $axi_ethernet_0_fifo


  # Create instance: axi_refclk, and set properties
  set axi_refclk [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 axi_refclk ]
  set_property -dict [list \
    CONFIG.AUTO_PRIMITIVE {MMCM} \
    CONFIG.CLKIN1_JITTER_PS {50.0} \
    CONFIG.CLKIN2_JITTER_PS {40.0} \
    CONFIG.CLKOUT1_DRIVES {BUFGCE} \
    CONFIG.CLKOUT1_JITTER {88.896} \
    CONFIG.CLKOUT1_MATCHED_ROUTING {false} \
    CONFIG.CLKOUT1_PHASE_ERROR {89.971} \
    CONFIG.CLKOUT1_REQUESTED_DUTY_CYCLE {50.0} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {333.33333} \
    CONFIG.CLKOUT1_USED {true} \
    CONFIG.CLKOUT2_DRIVES {BUFGCE} \
    CONFIG.CLKOUT2_JITTER {107.523} \
    CONFIG.CLKOUT2_MATCHED_ROUTING {false} \
    CONFIG.CLKOUT2_PHASE_ERROR {89.971} \
    CONFIG.CLKOUT2_REQUESTED_DUTY_CYCLE {50.0} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {125} \
    CONFIG.CLKOUT2_USED {true} \
    CONFIG.CLKOUT3_DRIVES {BUFGCE} \
    CONFIG.CLKOUT3_JITTER {93.990} \
    CONFIG.CLKOUT3_MATCHED_ROUTING {false} \
    CONFIG.CLKOUT3_PHASE_ERROR {89.971} \
    CONFIG.CLKOUT3_REQUESTED_DUTY_CYCLE {50.000} \
    CONFIG.CLKOUT3_REQUESTED_OUT_FREQ {250} \
    CONFIG.CLKOUT3_USED {true} \
    CONFIG.CLKOUT4_DRIVES {BUFGCE} \
    CONFIG.CLKOUT4_JITTER {111.894} \
    CONFIG.CLKOUT4_PHASE_ERROR {225.117} \
    CONFIG.CLKOUT4_REQUESTED_DUTY_CYCLE {50.000} \
    CONFIG.CLKOUT4_USED {false} \
    CONFIG.CLKOUT5_DRIVES {BUFGCE} \
    CONFIG.CLKOUT6_DRIVES {BUFGCE} \
    CONFIG.CLKOUT7_DRIVES {BUFGCE} \
    CONFIG.CLK_OUT1_PORT {clok_out_333} \
    CONFIG.CLK_OUT2_PORT {clk_out_125} \
    CONFIG.CLK_OUT3_PORT {clk_out_250} \
    CONFIG.ENABLE_CLOCK_MONITOR {false} \
    CONFIG.FEEDBACK_SOURCE {FDBK_AUTO} \
    CONFIG.JITTER_SEL {No_Jitter} \
    CONFIG.MMCM_BANDWIDTH {OPTIMIZED} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {5.000} \
    CONFIG.MMCM_CLKIN1_PERIOD {5.000} \
    CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {3.000} \
    CONFIG.MMCM_CLKOUT0_DUTY_CYCLE {0.500} \
    CONFIG.MMCM_CLKOUT1_DIVIDE {8} \
    CONFIG.MMCM_CLKOUT1_DUTY_CYCLE {0.500} \
    CONFIG.MMCM_CLKOUT2_DIVIDE {4} \
    CONFIG.MMCM_CLKOUT3_DIVIDE {1} \
    CONFIG.MMCM_COMPENSATION {AUTO} \
    CONFIG.NUM_OUT_CLKS {3} \
    CONFIG.OPTIMIZE_CLOCKING_STRUCTURE_EN {true} \
    CONFIG.OVERRIDE_MMCM {false} \
    CONFIG.PRIMITIVE {Auto} \
    CONFIG.PRIM_IN_FREQ {200.000} \
    CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
    CONFIG.RESET_PORT {reset} \
    CONFIG.RESET_TYPE {ACTIVE_HIGH} \
    CONFIG.SECONDARY_IN_FREQ {100.000} \
    CONFIG.SECONDARY_SOURCE {Single_ended_clock_capable_pin} \
    CONFIG.USE_DYN_PHASE_SHIFT {false} \
    CONFIG.USE_INCLK_SWITCHOVER {false} \
    CONFIG.USE_LOCKED {true} \
    CONFIG.USE_MIN_POWER {false} \
    CONFIG.USE_PHASE_ALIGNMENT {false} \
    CONFIG.USE_RESET {false} \
    CONFIG.USE_SAFE_CLOCK_STARTUP {true} \
    CONFIG.USE_SPREAD_SPECTRUM {false} \
  ] $axi_refclk


  # Create instance: reset_pci, and set properties
  set reset_pci [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 reset_pci ]

  # Create instance: clk_wiz_0, and set properties
  set clk_wiz_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clk_wiz_0 ]
  set_property -dict [list \
    CONFIG.CLKOUT1_JITTER {110.209} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {250.000} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {4.000} \
    CONFIG.PRIM_SOURCE {Differential_clock_capable_pin} \
    CONFIG.RESET_PORT {resetn} \
    CONFIG.RESET_TYPE {ACTIVE_LOW} \
  ] $clk_wiz_0


  # Create instance: axi_vip_0, and set properties
  set axi_vip_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_0 ]
  set_property -dict [list \
    CONFIG.ADDR_WIDTH {32} \
    CONFIG.DATA_WIDTH {32} \
    CONFIG.HAS_BRESP {1} \
    CONFIG.HAS_PROT {1} \
    CONFIG.HAS_RRESP {1} \
    CONFIG.HAS_WSTRB {1} \
    CONFIG.INTERFACE_MODE {MASTER} \
    CONFIG.PROTOCOL {AXI4LITE} \
    CONFIG.READ_WRITE_MODE {READ_WRITE} \
  ] $axi_vip_0


  # Create instance: axi_vip_1, and set properties
  set axi_vip_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_vip:1.1 axi_vip_1 ]
  set_property -dict [list \
    CONFIG.DATA_WIDTH {256} \
    CONFIG.INTERFACE_MODE {SLAVE} \
  ] $axi_vip_1


  # Create instance: smartconnect_0, and set properties
  set smartconnect_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:smartconnect:1.0 smartconnect_0 ]
  set_property -dict [list \
    CONFIG.ADVANCED_PROPERTIES {__experimental_features__ {enable_multithreaded_mi 1} __view__ {functional {SW0 {DATA_WIDTH 128} S01_Buffer {R_SIZE 2048} M05_Buffer {R_SIZE 256} M05_Exit {NUM_READ_THREADS\
16}}}} \
    CONFIG.NUM_CLKS {3} \
    CONFIG.NUM_MI {6} \
    CONFIG.NUM_SI {2} \
  ] $smartconnect_0


  # Create instance: axi_clock_converter_0, and set properties
  set axi_clock_converter_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_clock_converter:2.1 axi_clock_converter_0 ]

  # Create interface connections
  connect_bd_intf_net -intf_net AESKeyFinder_v1_0_0_m00_axi [get_bd_intf_pins AESKeyFinder_v1_0_0/m00_axi] [get_bd_intf_pins smartconnect_0/S01_AXI]
  set_property SIM_ATTRIBUTE.MARK_SIM "true" [get_bd_intf_nets /AESKeyFinder_v1_0_0_m00_axi]
  connect_bd_intf_net -intf_net CLK_IN_D_0_1 [get_bd_intf_ports CLK_IN_D_0] [get_bd_intf_pins clk_wiz_0/CLK_IN1_D]
  connect_bd_intf_net -intf_net axi_clock_converter_0_M_AXI [get_bd_intf_pins axi_clock_converter_0/M_AXI] [get_bd_intf_pins AESKeyFinder_v1_0_0/s00_axi]
  connect_bd_intf_net -intf_net axi_ethernet_0_fifo_AXI_STR_TXC [get_bd_intf_pins axi_ethernet_0_fifo/AXI_STR_TXC] [get_bd_intf_pins axi_ethernet_0/s_axis_txc]
  connect_bd_intf_net -intf_net axi_ethernet_0_fifo_AXI_STR_TXD [get_bd_intf_pins axi_ethernet_0_fifo/AXI_STR_TXD] [get_bd_intf_pins axi_ethernet_0/s_axis_txd]
  connect_bd_intf_net -intf_net axi_ethernet_0_m_axis_rxd [get_bd_intf_pins axi_ethernet_0_fifo/AXI_STR_RXD] [get_bd_intf_pins axi_ethernet_0/m_axis_rxd]
  connect_bd_intf_net -intf_net axi_ethernet_0_mdio [get_bd_intf_ports mdio_rtl_0] [get_bd_intf_pins axi_ethernet_0/mdio]
  connect_bd_intf_net -intf_net axi_ethernet_0_rgmii [get_bd_intf_ports rgmii_rtl_0] [get_bd_intf_pins axi_ethernet_0/rgmii]
  connect_bd_intf_net -intf_net axi_vip_0_M_AXI [get_bd_intf_pins axi_vip_0/M_AXI] [get_bd_intf_pins smartconnect_0/S00_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M00_AXI [get_bd_intf_pins smartconnect_0/M00_AXI] [get_bd_intf_pins axi_clock_converter_0/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M01_AXI [get_bd_intf_pins smartconnect_0/M01_AXI] [get_bd_intf_pins axi_ethernet_0_fifo/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M02_AXI [get_bd_intf_pins smartconnect_0/M02_AXI] [get_bd_intf_pins axi_ethernet_0_fifo/S_AXI_FULL]
  connect_bd_intf_net -intf_net smartconnect_0_M03_AXI [get_bd_intf_pins smartconnect_0/M03_AXI] [get_bd_intf_pins axi_ethernet_0/s_axi]
  connect_bd_intf_net -intf_net smartconnect_0_M04_AXI [get_bd_intf_pins smartconnect_0/M04_AXI] [get_bd_intf_pins axi_gpio_0/S_AXI]
  connect_bd_intf_net -intf_net smartconnect_0_M05_AXI [get_bd_intf_pins smartconnect_0/M05_AXI] [get_bd_intf_pins axi_vip_1/S_AXI]
  set_property SIM_ATTRIBUTE.MARK_SIM "true" [get_bd_intf_nets /smartconnect_0_M05_AXI]

  # Create port connections
  connect_bd_net -net AESKeyFinder_v1_0_0_aeskeyfinder_active [get_bd_pins AESKeyFinder_v1_0_0/aeskeyfinder_active] [get_bd_ports aeskeyfinder_active_0]
  connect_bd_net -net S00_ARESETN_1 [get_bd_pins reset_pci/peripheral_aresetn] [get_bd_pins axi_vip_0/aresetn] [get_bd_pins axi_vip_1/aresetn] [get_bd_pins rst_axi/ext_reset_in]
  connect_bd_net -net axi_ethernet_0_fifo_interrupt [get_bd_pins axi_ethernet_0_fifo/interrupt] [get_bd_pins AESKeyFinder_v1_0_0/interrput_in]
  connect_bd_net -net axi_ethernet_0_fifo_mm2s_cntrl_reset_out_n [get_bd_pins axi_ethernet_0_fifo/mm2s_cntrl_reset_out_n] [get_bd_pins axi_ethernet_0/axi_txc_arstn]
  connect_bd_net -net axi_ethernet_0_fifo_mm2s_prmry_reset_out_n [get_bd_pins axi_ethernet_0_fifo/mm2s_prmry_reset_out_n] [get_bd_pins axi_ethernet_0/axi_txd_arstn]
  connect_bd_net -net axi_ethernet_0_fifo_s2mm_prmry_reset_out_n [get_bd_pins axi_ethernet_0_fifo/s2mm_prmry_reset_out_n] [get_bd_pins axi_ethernet_0/axi_rxd_arstn] [get_bd_pins axi_ethernet_0/axi_rxs_arstn]
  connect_bd_net -net axi_ethernet_0_phy_rst_n [get_bd_pins axi_ethernet_0/phy_rst_n] [get_bd_ports e_reset]
  connect_bd_net -net axi_ethernet_0_refclk_clk_out_125 [get_bd_pins axi_refclk/clk_out_125] [get_bd_pins axi_ethernet_0/gtx_clk] [get_bd_pins axi_gpio_0/s_axi_aclk] [get_bd_pins axi_ethernet_0/s_axi_lite_clk] [get_bd_pins rst_axi/slowest_sync_clk] [get_bd_pins smartconnect_0/aclk1] [get_bd_pins axi_clock_converter_0/s_axi_aclk]
  connect_bd_net -net axi_ethernet_0_refclk_clk_out_250 [get_bd_pins axi_refclk/clk_out_250] [get_bd_pins axi_ethernet_0_fifo/s_axi_aclk] [get_bd_pins axi_ethernet_0/axis_clk] [get_bd_pins smartconnect_0/aclk] [get_bd_pins axi_clock_converter_0/m_axi_aclk] [get_bd_pins AESKeyFinder_v1_0_0/axi_aclk]
  connect_bd_net -net axi_ethernet_0_refclk_clok_out_333 [get_bd_pins axi_refclk/clok_out_333] [get_bd_pins axi_ethernet_0/ref_clk]
  connect_bd_net -net axi_ethernet_0_refclk_locked [get_bd_pins axi_refclk/locked] [get_bd_pins rst_axi/dcm_locked]
  connect_bd_net -net axi_gpio_0_gpio_io_o [get_bd_pins axi_gpio_0/gpio_io_o] [get_bd_ports led]
  connect_bd_net -net axi_pcie3_0_axi_aclk [get_bd_pins clk_wiz_0/clk_out1] [get_bd_pins reset_pci/slowest_sync_clk] [get_bd_pins axi_vip_0/aclk] [get_bd_pins axi_vip_1/aclk] [get_bd_pins smartconnect_0/aclk2]
  connect_bd_net -net clk_200MHz_n_1 [get_bd_ports clk_200MHz_n] [get_bd_pins axi_refclk/clk_in1_n]
  connect_bd_net -net clk_200MHz_p_1 [get_bd_ports clk_200MHz_p] [get_bd_pins axi_refclk/clk_in1_p]
  connect_bd_net -net clk_wiz_0_locked [get_bd_pins clk_wiz_0/locked] [get_bd_pins reset_pci/dcm_locked]
  connect_bd_net -net reset_pci_interconnect_aresetn [get_bd_pins reset_pci/interconnect_aresetn] [get_bd_pins smartconnect_0/aresetn]
  connect_bd_net -net reset_rtl_0_1 [get_bd_ports reset_rtl_0] [get_bd_pins reset_pci/ext_reset_in] [get_bd_pins clk_wiz_0/resetn]
  connect_bd_net -net rst_clk_wiz_100M_peripheral_aresetn [get_bd_pins rst_axi/peripheral_aresetn] [get_bd_pins axi_ethernet_0_fifo/s_axi_aresetn] [get_bd_pins axi_ethernet_0/s_axi_lite_resetn] [get_bd_pins axi_gpio_0/s_axi_aresetn] [get_bd_pins axi_clock_converter_0/s_axi_aresetn] [get_bd_pins axi_clock_converter_0/m_axi_aresetn] [get_bd_pins AESKeyFinder_v1_0_0/axi_aresetn]

  # Create address segments
  assign_bd_address -offset 0xC0001000 -range 0x00001000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs AESKeyFinder_v1_0_0/s00_axi/reg0] -force
  assign_bd_address -offset 0xC0003000 -range 0x00001000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs axi_ethernet_0/s_axi/Reg0] -force
  assign_bd_address -offset 0xC0004000 -range 0x00001000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs axi_ethernet_0_fifo/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs axi_ethernet_0_fifo/S_AXI_FULL/Mem1] -force
  assign_bd_address -offset 0x000100000000 -range 0x000100000000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs axi_vip_1/S_AXI/Reg] -force
  assign_bd_address -offset 0xC0001000 -range 0x00001000 -target_address_space [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs AESKeyFinder_v1_0_0/s00_axi/reg0] -force
  assign_bd_address -offset 0xC0003000 -range 0x00001000 -target_address_space [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs axi_ethernet_0/s_axi/Reg0] -force
  assign_bd_address -offset 0xC0004000 -range 0x00001000 -target_address_space [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs axi_ethernet_0_fifo/S_AXI/Mem0] -force
  assign_bd_address -offset 0xC0010000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs axi_ethernet_0_fifo/S_AXI_FULL/Mem1] -force
  assign_bd_address -offset 0xC0002000 -range 0x00001000 -target_address_space [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg] -force

  # Exclude Address Segments
  exclude_bd_addr_seg -offset 0xC0002000 -range 0x00001000 -target_address_space [get_bd_addr_spaces AESKeyFinder_v1_0_0/m00_axi] [get_bd_addr_segs axi_gpio_0/S_AXI/Reg]
  exclude_bd_addr_seg -offset 0x44A00000 -range 0x00010000 -target_address_space [get_bd_addr_spaces axi_vip_0/Master_AXI] [get_bd_addr_segs axi_vip_1/S_AXI/Reg]


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_gid_msg -ssname BD::TCL -id 2053 -severity "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

