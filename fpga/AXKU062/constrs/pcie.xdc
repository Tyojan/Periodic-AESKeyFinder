set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 8 [current_design]
set_property CONFIG_MODE SPIx8 [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 50 [current_design]
set_property BITSTREAM.CONFIG.PERSIST Yes [current_design]
#set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
#set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup [current_design]


#set_property LOC GTHE3_CHANNEL_X1Y0 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[24].*gen_gthe3_channel_inst[0].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin AP1 [get_ports gthrxn_in[0]]
#set_property package_pin AP2 [get_ports gthrxp_in[0]]
#set_property package_pin AN3 [get_ports gthtxn_out[0]]
#set_property package_pin AN4 [get_ports gthtxp_out[0]]

# Commands for enabled transceiver GTHE3_CHANNEL_X1Y1
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
#set_property LOC GTHE3_CHANNEL_X1Y1 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[24].*gen_gthe3_channel_inst[1].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin AM1 [get_ports gthrxn_in[1]]
#set_property package_pin AM2 [get_ports gthrxp_in[1]]
#set_property package_pin AM5 [get_ports gthtxn_out[1]]
#set_property package_pin AM6 [get_ports gthtxp_out[1]]

# Commands for enabled transceiver GTHE3_CHANNEL_X1Y2
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
#set_property LOC GTHE3_CHANNEL_X1Y2 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[24].*gen_gthe3_channel_inst[2].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin AK1 [get_ports gthrxn_in[2]]
#set_property package_pin AK2 [get_ports gthrxp_in[2]]
#set_property package_pin AL3 [get_ports gthtxn_out[2]]
#set_property package_pin AL4 [get_ports gthtxp_out[2]]

# Commands for enabled transceiver GTHE3_CHANNEL_X1Y3
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
#set_property LOC GTHE3_CHANNEL_X1Y3 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[24].*gen_gthe3_channel_inst[3].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin AJ3 [get_ports gthrxn_in[3]]
#set_property package_pin AJ4 [get_ports gthrxp_in[3]]
#set_property package_pin AK5 [get_ports gthtxn_out[3]]
#set_property package_pin AK6 [get_ports gthtxp_out[3]]

# Commands for enabled transceiver GTHE3_CHANNEL_X1Y4
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
set_property LOC GTHE3_CHANNEL_X1Y4 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[25].*gen_gthe3_channel_inst[0].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin AH1 [get_ports gthrxn_in[4]]
#set_property package_pin AH2 [get_ports gthrxp_in[4]]
#set_property package_pin AH5 [get_ports gthtxn_out[4]]
#set_property package_pin AH6 [get_ports gthtxp_out[4]]

# Commands for enabled transceiver GTHE3_CHANNEL_X1Y5
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
#set_property LOC GTHE3_CHANNEL_X1Y5 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[25].*gen_gthe3_channel_inst[1].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin AF1 [get_ports gthrxn_in[5]]
#set_property package_pin AF2 [get_ports gthrxp_in[5]]
#set_property package_pin AG3 [get_ports gthtxn_out[5]]
#set_property package_pin AG4 [get_ports gthtxp_out[5]]

# Commands for enabled transceiver GTHE3_CHANNEL_X1Y6
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
#set_property LOC GTHE3_CHANNEL_X1Y6 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[25].*gen_gthe3_channel_inst[2].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin AD1 [get_ports gthrxn_in[6]]
#set_property package_pin AD2 [get_ports gthrxp_in[6]]
#set_property package_pin AE3 [get_ports gthtxn_out[6]]
#set_property package_pin AE4 [get_ports gthtxp_out[6]]

# Commands for enabled transceiver GTHE3_CHANNEL_X1Y7
# ----------------------------------------------------------------------------------------------------------------------

# Channel primitive location constraint
#set_property LOC GTHE3_CHANNEL_X1Y7 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[25].*gen_gthe3_channel_inst[3].GTHE3_CHANNEL_PRIM_INST}]

# Channel primitive serial data pin location constraints
# (Provided as comments for your reference. The channel primitive location constraint is sufficient.)
#set_property package_pin AB1 [get_ports gthrxn_in[7]]
#set_property package_pin AB2 [get_ports gthrxp_in[7]]
#set_property package_pin AC3 [get_ports gthtxn_out[7]]
#set_property package_pin AC4 [get_ports gthtxp_out[7]]

create_clock -period 10.000 -name {CLK_IN_D_0_clk_p[0]} -waveform {0.000 5.000} [get_ports {CLK_IN_D_0_clk_p[0]}]
set_property LOC GTHE3_COMMON_X1Y1 [get_cells {design_1_i/util_ds_buf_0/U0/USE_IBUFDS_GTE3.GEN_IBUFDS_GTE3[0].IBUFDS_GTE3_I}]
set_property PACKAGE_PIN AB5 [get_ports {CLK_IN_D_0_clk_n[0]}]
set_property PACKAGE_PIN AB6 [get_ports {CLK_IN_D_0_clk_p[0]}]


#create_clock -period 5.000 -name {clock_in0} -waveform {0.000 2.500} [get_ports {clock_in0}]
#create_clock -period 10.000 -name {clock_in0} -waveform {0.000 5.000} [get_ports {clock_in0}]
#set_property PACKAGE_PIN AK17 [get_ports {clock_in0}]
#set_property PACKAGE_PIN AK16 [get_ports {diff_clock_rtl_0_clk_n}]
#set_property LOC GTHE3_COMMON_X1Y0 [get_cells {design_1_i/util_ds_buf/U0/USE_IBUFDS_GTE3.GEN_IBUFDS_GTE3[0].IBUFDS_GTE3_I}]
#set_property LOC IBUFDS_GTE3_X0Y0 [get_cells {design_1_i/util_ds_buf/U0/USE_IBUFDS_GTE3.GEN_IBUFDS_GTE3[0].IBUFDS_GTE3_I}]




create_clock -period 5.000 -name clk_200MHz -waveform {0.000 2.500} [get_ports clk_200MHz_clk_p[0]]
set_property PACKAGE_PIN AK17 [get_ports clk_200MHz_clk_p[0]]
set_property PACKAGE_PIN AK16 [get_ports clk_200MHz_clk_n[0]]
set_property IOSTANDARD LVDS [get_ports clk_200MHz_clk_p[0]]
set_property IOSTANDARD LVDS [get_ports clk_200MHz_clk_n[0]]


#set_property PACKAGE_PIN N27 [get_ports reset_rtl_0]
set_property IOSTANDARD LVCMOS18 [get_ports reset_rtl_0]



##############LED define##################

set_property PACKAGE_PIN E12 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[0]}]
set_property PACKAGE_PIN F12 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[1]}]
set_property PACKAGE_PIN L9 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[2]}]
set_property PACKAGE_PIN H23 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[3]}]
set_false_path -to [get_ports led]

set_property PACKAGE_PIN E13 [get_ports user_link_up_0]
set_property IOSTANDARD LVCMOS18 [get_ports user_link_up_0]
set_property PACKAGE_PIN F13 [get_ports aeskeyfinder_active_0]
set_property IOSTANDARD LVCMOS18 [get_ports aeskeyfinder_active_0]

#set_property HD.TANDEM_IP_PBLOCK Stage1_Config_IO [get_ports user_link_up_0]
#set_property HD.TANDEM_IP_PBLOCK Stage1_Config_IO [get_ports {led[0]}]
#set_property HD.TANDEM_IP_PBLOCK Stage1_Config_IO [get_ports {led[1]}]
#set_property HD.TANDEM_IP_PBLOCK Stage1_Config_IO [get_ports {led[2]}]
#set_property HD.TANDEM_IP_PBLOCK Stage1_Config_IO [get_ports {led[3]}]


#########Ethernet####################################
set_property PACKAGE_PIN AB34 [get_ports {rgmii_rtl_0_rd[3]}]
set_property PACKAGE_PIN AA34 [get_ports {rgmii_rtl_0_rd[2]}]
set_property PACKAGE_PIN AD34 [get_ports {rgmii_rtl_0_rd[1]}]
set_property PACKAGE_PIN AC34 [get_ports {rgmii_rtl_0_rd[0]}]
set_property PACKAGE_PIN U34 [get_ports {rgmii_rtl_0_td[3]}]
set_property PACKAGE_PIN V34 [get_ports {rgmii_rtl_0_td[2]}]
set_property PACKAGE_PIN AC33 [get_ports {rgmii_rtl_0_td[1]}]
set_property PACKAGE_PIN AD33 [get_ports {rgmii_rtl_0_td[0]}]

set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_rtl_0_rd[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_rtl_0_rd[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_rtl_0_rd[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_rtl_0_rd[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_rtl_0_td[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_rtl_0_td[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_rtl_0_td[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_rtl_0_td[0]}]


#set_property PACKAGE_PIN AB34 [get_ports {rgmii_rd[3]}]
#set_property PACKAGE_PIN AA34 [get_ports {rgmii_rd[2]}]
#set_property PACKAGE_PIN AD34 [get_ports {rgmii_rd[1]}]
#set_property PACKAGE_PIN AC34 [get_ports {rgmii_rd[0]}]
#set_property PACKAGE_PIN U34 [get_ports {rgmii_td[3]}]
#set_property PACKAGE_PIN V34 [get_ports {rgmii_td[2]}]
#set_property PACKAGE_PIN AC33 [get_ports {rgmii_td[1]}]

#set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_rd[3]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_rd[2]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_rd[1]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_rd[0]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_td[3]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_td[2]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_td[1]}]
#set_property IOSTANDARD LVCMOS18 [get_ports {rgmii_td[0]}]
#set_property PACKAGE_PIN AD33 [get_ports {rgmii_td[0]}]



set_property PACKAGE_PIN AA33 [get_ports mdio_rtl_0_mdc]
set_property PACKAGE_PIN AE31 [get_ports mdio_rtl_0_mdio_io]

set_property IOSTANDARD LVCMOS18 [get_ports mdio_rtl_0_mdio_io]
set_property IOSTANDARD LVCMOS18 [get_ports mdio_rtl_0_mdc]


set_property PACKAGE_PIN V32 [get_ports {e_reset[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {e_reset[0]}]


set_property PACKAGE_PIN AC31 [get_ports rgmii_rtl_0_rxc]
set_property PACKAGE_PIN AC32 [get_ports rgmii_rtl_0_rx_ctl]
set_property PACKAGE_PIN W34 [get_ports rgmii_rtl_0_txc]
set_property PACKAGE_PIN V33 [get_ports rgmii_rtl_0_tx_ctl]

set_property IOSTANDARD LVCMOS18 [get_ports rgmii_rtl_0_rxc]
set_property IOSTANDARD LVCMOS18 [get_ports rgmii_rtl_0_rx_ctl]
set_property IOSTANDARD LVCMOS18 [get_ports rgmii_rtl_0_txc]
set_property IOSTANDARD LVCMOS18 [get_ports rgmii_rtl_0_tx_ctl]



#set_property PACKAGE_PIN AA33 [get_ports mdio_mdc]
#set_property PACKAGE_PIN AE31 [get_ports mdio_t]
#set_property PACKAGE_PIN V32 [get_ports e_reset]

#set_property PACKAGE_PIN AC31 [get_ports rgmii_rxc]
#set_property PACKAGE_PIN AC32 [get_ports rgmii_rx_ctl]
#set_property PACKAGE_PIN W34 [get_ports rgmii_txc]
#set_property PACKAGE_PIN V33 [get_ports rgmii_tx_ctl]

#set_property PACKAGE_PIN AK17 [get_ports sys_clk_p]
#set_property IOSTANDARD DIFF_SSTL12 [get_ports sys_clk_p]


#set_property PACKAGE_PIN AK11 [get_ports fan]
#set_property IOSTANDARD LVCMOS18 [get_ports fan]

#set_clock_groups -asynchronous -group [get_clocks pipe_clk] -group [get_clocks {CLK_IN_D_0_clk_p[0]}]

set_false_path -from [get_clocks -of_objects [get_pins design_1_i/axi_pcie3_0/inst/pcie3_ip_i/inst/design_1_axi_pcie3_0_0_pcie3_ip_gt_top_i/phy_clk_i/bufg_gt_userclk/O]] -to [get_clocks -of_objects [get_pins design_1_i/axi_ethernet_0_refclk/inst/mmcme3_adv_inst/CLKOUT1]]

set_false_path -from [get_clocks -of_objects [get_pins design_1_i/axi_pcie3_0/inst/pcie3_ip_i/inst/design_1_axi_pcie3_0_0_pcie3_ip_gt_top_i/phy_clk_i/bufg_gt_userclk/O]] -to [get_clocks -of_objects [get_pins design_1_i/axi_ethernet_0_refclk/inst/mmcme3_adv_inst/CLKOUT2]]
set_false_path -from [get_clocks -of_objects [get_pins design_1_i/axi_pcie3_0/inst/pcie3_ip_i/inst/design_1_axi_pcie3_0_0_pcie3_ip_gt_top_i/phy_clk_i/bufg_gt_userclk/O]] -to [get_clocks -of_objects [get_pins design_1_i/axi_ethernet_0_refclk/inst/mmcme3_adv_inst/CLKOUT0]]
set_false_path -from [get_clocks -of_objects [get_pins design_1_i/axi_pcie3_0/inst/pcie3_ip_i/inst/design_1_axi_pcie3_0_0_pcie3_ip_gt_top_i/phy_clk_i/bufg_gt_pclk/O]] -to [get_clocks {CLK_IN_D_0_clk_p[0]}]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk]
