
`timescale 1 ns / 1 ps

	module AESKeyFinder_v1_0 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 32,

		// Parameters of Axi Master Bus Interface M00_AXI
//		parameter  C_M00_AXI_TARGET_SLAVE_BASE_ADDR	= 32'h40000000,
		parameter integer C_M00_AXI_BURST_LEN	= 256,
		parameter integer C_M00_AXI_ID_WIDTH	= 4,		
		parameter integer C_M00_AXI_ADDR_WIDTH	= 40,
		parameter integer C_M00_AXI_DATA_WIDTH	= 128,		
		parameter integer C_M00_AXI_AWUSER_WIDTH	= 0,
		parameter integer C_M00_AXI_ARUSER_WIDTH	= 0,
		parameter integer C_M00_AXI_WUSER_WIDTH	= C_M00_AXI_DATA_WIDTH/8,		
		parameter integer C_M00_AXI_RUSER_WIDTH	= C_M00_AXI_DATA_WIDTH/8,
		parameter integer C_M00_AXI_BUSER_WIDTH	= 0,		
		parameter [C_M00_AXI_ADDR_WIDTH - 1 : 0] C_AESKEYFINDER_SRC_ADDR = 40'h08_00000000,
		parameter [C_M00_AXI_ADDR_WIDTH - 1 : 0] C_AESKEYFINDER_DST_ADDR = 40'h00_a0070000,
		parameter [C_S00_AXI_DATA_WIDTH - 1 : 0] C_AESKEYFINDER_FIFO_BASE_ADDR = 32'ha0060000,
		parameter [C_S00_AXI_DATA_WIDTH - 1 : 0] C_AESKEYFINDER_READ_PAGES = 32'h00080000,
		parameter C_AESKEYFINDER_AUTO_RUN = 1,
		parameter C_AESKEYFINDER_INFINITE_LOOP = 1,
		parameter C_AESKEYFINDER_DST_IS_FIFO = 1,
		parameter C_AESKEYFINDER_PCIE_ENABLE = 1,
		parameter [C_S00_AXI_DATA_WIDTH - 1 : 0] C_AESKEYFINDER_PCIE_BAR0ADDR = 32'hC0000200
	)
	(

		// Do not modify the ports beyond this output

        output wire [2:0] exec_read_state_wire,
        output wire [2:0] exec_write_state_wire,
        output wire aeskeyfinder_active,      
		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  axi_aclk,
		input wire  axi_aresetn,
		
		input wire interrput_in,

		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready,

		// Ports of Axi Master Bus Interface M00_AXI

		output wire [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_awid,
		output wire [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_awaddr,
		output wire [7 : 0] m00_axi_awlen,
		output wire [2 : 0] m00_axi_awsize,
		output wire [1 : 0] m00_axi_awburst,
		output wire  m00_axi_awlock,
		output wire [3 : 0] m00_axi_awcache,
		output wire [2 : 0] m00_axi_awprot,
		output wire [3 : 0] m00_axi_awqos,
		output wire [C_M00_AXI_AWUSER_WIDTH-1 : 0] m00_axi_awuser,
		output wire  m00_axi_awvalid,
		input wire  m00_axi_awready,
		output wire [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_wid,
		output wire [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_wdata,
		output wire [C_M00_AXI_DATA_WIDTH/8-1 : 0] m00_axi_wstrb,
		output wire  m00_axi_wlast,
		output wire [C_M00_AXI_WUSER_WIDTH-1 : 0] m00_axi_wuser,
		output wire  m00_axi_wvalid,
		input wire  m00_axi_wready,
		input wire [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_bid,
		input wire [1 : 0] m00_axi_bresp,
		input wire [C_M00_AXI_BUSER_WIDTH-1 : 0] m00_axi_buser,
		input wire  m00_axi_bvalid,
		output wire  m00_axi_bready,
		output wire [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_arid,
		output wire [C_M00_AXI_ADDR_WIDTH-1 : 0] m00_axi_araddr,
		output wire [7 : 0] m00_axi_arlen,
		output wire [2 : 0] m00_axi_arsize,
		output wire [1 : 0] m00_axi_arburst,
		output wire  m00_axi_arlock,
		output wire [3 : 0] m00_axi_arcache,
		output wire [2 : 0] m00_axi_arprot,
		output wire [3 : 0] m00_axi_arqos,
		output wire [C_M00_AXI_ARUSER_WIDTH-1 : 0] m00_axi_aruser,
		output wire  m00_axi_arvalid,
		input wire  m00_axi_arready,
		input wire [C_M00_AXI_ID_WIDTH-1 : 0] m00_axi_rid,
		input wire [C_M00_AXI_DATA_WIDTH-1 : 0] m00_axi_rdata,
		input wire [1 : 0] m00_axi_rresp,
		input wire  m00_axi_rlast,
		input wire [C_M00_AXI_RUSER_WIDTH-1 : 0] m00_axi_ruser,
		input wire  m00_axi_rvalid,
		output wire  m00_axi_rready
	);
	
        
	
        wire [C_M00_AXI_ADDR_WIDTH-1:0] target_read_addr;
        wire [C_M00_AXI_ADDR_WIDTH-1:0] target_write_addr;
        //wire [31:0] txn_counter;
        wire txn_begin;
        wire [C_S00_AXI_DATA_WIDTH-1:0] read_pages;       
        wire [3:0] ip_state;        
        wire [7:0] axprot;
        wire [C_S00_AXI_DATA_WIDTH-1:0] hit_counter;    
    	
	    wire [127:0] header;
	    wire [63:0] timer;
        wire [C_S00_AXI_DATA_WIDTH-1:0] laps_counter;	    
	    wire fifo_mode;
	    wire infinite_mode;
	    wire poll_eth_en;
	    wire [C_S00_AXI_DATA_WIDTH-1 : 0] fifo_base;
	    wire [C_S00_AXI_DATA_WIDTH-1 : 0] eth_base;
	    wire [1 : 0] keyhit;

        wire bar_switch;
        wire [3:0] bar0l;
        wire [3:0] bar0h;
        wire [3:0] bar0target;

        wire clk1,clk2;
//    BUFG BUFG_inst1 (
//     .O(clk1), // 1-bit output: Clock output
//     .I(axi_aclk) // 1-bit input: Clock input
//    );
//    BUFG BUFG_inst2 (
//     .O(clk2), // 1-bit output: Clock output
//     .I(axi_aclk) // 1-bit input: Clock input
//    );        
    assign clk1 = axi_aclk;
    assign clk2 = axi_aclk;
	
// Instantiation of Axi Bus Interface S00_AXI
	AESKeyFinder_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH),
		.C_M_AXI_DATA_WIDTH(C_M00_AXI_DATA_WIDTH),
		.C_M_AXI_ADDR_WIDTH(C_M00_AXI_ADDR_WIDTH),
		.C_AESKEYFINDER_SRC_ADDR(C_AESKEYFINDER_SRC_ADDR),
        .C_AESKEYFINDER_DST_ADDR(C_AESKEYFINDER_DST_ADDR),
		.C_AESKEYFINDER_FIFO_BASE_ADDR(C_AESKEYFINDER_FIFO_BASE_ADDR),
		.C_AESKEYFINDER_READ_PAGES(C_AESKEYFINDER_READ_PAGES),
		.C_AUTO_RUN(C_AESKEYFINDER_AUTO_RUN),
		.C_INFINITE_LOOP(C_AESKEYFINDER_INFINITE_LOOP),
        .C_DST_IS_FIFO(C_AESKEYFINDER_DST_IS_FIFO)				
	) AESKeyFinder_v1_0_S00_AXI_inst (

        .HEADER(header),
        .TIME(timer),
        .LAPS_COUNTER(laps_counter),        
        .FIFO_MODE(fifo_mode),
        .INFINITE_MODE(infinite_mode),
        .POLL_ETH_EN(poll_eth_en),
        .FIFO_BASE(fifo_base),
//        .ETH_BASE(eth_base),
	 	.TARGET_READ_ADDR(target_read_addr),
        .TARGET_WRITE_ADDR(target_write_addr),
        
        .READ_PAGES(read_pages),
        //.PAGE_READ_COUNT(txn_counter),
        .XRESP(m00_axi_rresp),
        .AXPROT(axprot),
        .TXN_LAST(m00_axi_rlast && m00_axi_rvalid && m00_axi_rready),
        .TXN_BEGIN(txn_begin),
        .IP_STATE(ip_state),
        .HIT_COUNTER(hit_counter),
        .BAR0L(bar0l),
        .BAR0H(bar0h),
        .BAR0TARGET(bar0target),

		.S_AXI_ACLK(clk1),
		.S_AXI_ARESETN(axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready)
	);
	
	
    

// Instantiation of Axi Bus Interface M00_AXI
	AESKeyFinder_v1_0_M00_AXI # ( 
		.C_M_AXI_BURST_LEN(C_M00_AXI_BURST_LEN),
		.C_M_AXI_ID_WIDTH(C_M00_AXI_ID_WIDTH),
		.C_M_AXI_ADDR_WIDTH(C_M00_AXI_ADDR_WIDTH),
		.C_M_AXI_DATA_WIDTH(C_M00_AXI_DATA_WIDTH),
		.C_M_AXI_AWUSER_WIDTH(C_M00_AXI_AWUSER_WIDTH),
		.C_M_AXI_ARUSER_WIDTH(C_M00_AXI_ARUSER_WIDTH),
		.C_M_AXI_WUSER_WIDTH(C_M00_AXI_WUSER_WIDTH),
		.C_M_AXI_RUSER_WIDTH(C_M00_AXI_RUSER_WIDTH),
		.C_M_AXI_BUSER_WIDTH(C_M00_AXI_BUSER_WIDTH),
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_AESKEYFINDER_PCIE_ENABLE(C_AESKEYFINDER_PCIE_ENABLE)
	) AESKeyFinder_v1_0_M00_AXI_inst (
	
	    .HEADER(header),
	    .TIME(timer),
	    .FIFO_MODE(fifo_mode),
	    .INFINITE_MODE(infinite_mode),
	    .POLL_ETH_EN(poll_eth_en),
	    .FIFO_BASE(fifo_base),
//	    .ETH_BASE(eth_base),	    
        .LAPS_COUNTER(laps_counter),	    
	    .TARGET_READ_ADDR(target_read_addr),
        .TARGET_WRITE_ADDR(target_write_addr),
        //.TXN_COUNTER(txn_counter),
        .READ_PAGES(read_pages),
        //.IP_STATE(ip_state),
        .AxPROT(axprot),
        .BAR_SWITCH(C_AESKEYFINDER_PCIE_ENABLE),
        .BAR0L(bar0l),
        .BAR0H(bar0h),
        .BAR0TARGET(bar0target),        	        	
        .HIT_COUNTER(hit_counter),
		.INIT_AXI_TXN(txn_begin),
		.TXN_DONE(m00_axi_txn_done),

		.exec_read_state_wire(exec_read_state_wire),
		.exec_write_state_wire(exec_write_state_wire),
//		.AESKEYFINDER_ACTIVE(aeskeyfinder_active),
		
		.ERROR(m00_axi_error),
		.M_AXI_ACLK(clk2),
		.M_AXI_ARESETN(axi_aresetn),
//		.M_INTERRPT_IN(interrput_in),
		.M_AXI_AWID(m00_axi_awid),
		.M_AXI_AWADDR(m00_axi_awaddr),
		.M_AXI_AWLEN(m00_axi_awlen),
		.M_AXI_AWSIZE(m00_axi_awsize),
		.M_AXI_AWBURST(m00_axi_awburst),
		.M_AXI_AWLOCK(m00_axi_awlock),
		.M_AXI_AWCACHE(m00_axi_awcache),
		.M_AXI_AWPROT(m00_axi_awprot),
		.M_AXI_AWQOS(m00_axi_awqos),
		.M_AXI_AWUSER(m00_axi_awuser),
		.M_AXI_AWVALID(m00_axi_awvalid),
		.M_AXI_AWREADY(m00_axi_awready),

//		.M_AXI_WID(m00_axi_wid),
		.M_AXI_WDATA(m00_axi_wdata),
		.M_AXI_WSTRB(m00_axi_wstrb),
		.M_AXI_WLAST(m00_axi_wlast),
		.M_AXI_WUSER(m00_axi_wuser),
		.M_AXI_WVALID(m00_axi_wvalid),
		.M_AXI_WREADY(m00_axi_wready),
		
		.M_AXI_BID(m00_axi_bid),
		.M_AXI_BRESP(m00_axi_bresp),
		.M_AXI_BUSER(m00_axi_buser),
		.M_AXI_BVALID(m00_axi_bvalid),
		.M_AXI_BREADY(m00_axi_bready),
		
		.M_AXI_ARID(m00_axi_arid),
		.M_AXI_ARADDR(m00_axi_araddr),
		.M_AXI_ARLEN(m00_axi_arlen),
		.M_AXI_ARSIZE(m00_axi_arsize),
		.M_AXI_ARBURST(m00_axi_arburst),
		.M_AXI_ARLOCK(m00_axi_arlock),
		.M_AXI_ARCACHE(m00_axi_arcache),
		.M_AXI_ARPROT(m00_axi_arprot),
		.M_AXI_ARQOS(m00_axi_arqos),
		.M_AXI_ARUSER(m00_axi_aruser),
		.M_AXI_ARVALID(m00_axi_arvalid),
		.M_AXI_ARREADY(m00_axi_arready),
		
		.M_AXI_RID(m00_axi_rid),
		.M_AXI_RDATA(m00_axi_rdata),
		.M_AXI_RRESP(m00_axi_rresp),
		.M_AXI_RLAST(m00_axi_rlast),
		.M_AXI_RUSER(m00_axi_ruser),
		.M_AXI_RVALID(m00_axi_rvalid),
		.M_AXI_RREADY(m00_axi_rready)
	);

	// Add user logic here
    
	// User logic ends

	endmodule