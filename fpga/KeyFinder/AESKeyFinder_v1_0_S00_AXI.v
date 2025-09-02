
`timescale 1 ns / 1 ps

	module AESKeyFinder_v1_0_S00_AXI #
    (
        // Users to add parameters here

        // User parameters ends
        // Do not modify the parameters beyond this line

        // Width of S_AXI data bus
        parameter integer C_S_AXI_DATA_WIDTH    = 32,
        // Width of S_AXI address bus
        parameter integer C_S_AXI_ADDR_WIDTH    = 32,
        //for output
        parameter integer C_M_AXI_DATA_WIDTH    = 128,
        parameter integer C_M_AXI_ADDR_WIDTH    = 40,
        parameter [C_M_AXI_ADDR_WIDTH - 1 : 0] C_AESKEYFINDER_SRC_ADDR = 40'h08_00000000,
		parameter [C_M_AXI_ADDR_WIDTH - 1 : 0] C_AESKEYFINDER_DST_ADDR = 40'h00_a0070000,
		parameter [C_S_AXI_DATA_WIDTH - 1 : 0] C_AESKEYFINDER_FIFO_BASE_ADDR = 32'ha0060000,
		parameter [C_S_AXI_DATA_WIDTH - 1 : 0] C_AESKEYFINDER_READ_PAGES = 32'h00080000,
		parameter C_AUTO_RUN = 0,
		parameter C_INFINITE_LOOP =  1,
		parameter C_DST_IS_FIFO =  1,
		parameter C_AESKEYFINDER_PCIE_ENABLE = 1,
		parameter [C_S_AXI_DATA_WIDTH - 1 : 0] C_AESKEYFINDER_PCIE_BAR0ADDR = 32'hC0000200,
		parameter [C_S_AXI_DATA_WIDTH - 1 : 0] C_AESKEYFINDER_PCIE_BAR0RANGE = 32'h00000108,
		parameter [C_S_AXI_DATA_WIDTH - 1 : 0] C_AESKEYFINDER_PCIE_BAR0HI_LIMIT_PAGE = 32'h0005DF34
    )
    (
        //stream
        output wire [127 : 0] HEADER,
        output wire [63 : 0] TIME,
        output wire FIFO_MODE,
        output wire INFINITE_MODE,
        output wire POLL_ETH_EN,
        output wire [C_S_AXI_DATA_WIDTH-1:0] FIFO_BASE,
//        output wire [C_S_AXI_DATA_WIDTH-1:0] ETH_BASE,
        //stream
        // Users to add ports here
        output wire [C_M_AXI_ADDR_WIDTH-1 : 0] TARGET_READ_ADDR,
        output wire [C_M_AXI_ADDR_WIDTH-1 : 0] TARGET_WRITE_ADDR,
        output wire [C_S_AXI_DATA_WIDTH-1:0] READ_PAGES,
        //input wire [31 : 0] PAGE_READ_COUNT,
        input wire [1:0] XRESP,
        output wire [7:0] AXPROT,
        output wire TXN_BEGIN,
        input wire TXN_LAST,
        input wire [3:0]IP_STATE,
        input wire [C_S_AXI_DATA_WIDTH-1:0] HIT_COUNTER,
        input wire [C_S_AXI_DATA_WIDTH-1:0] LAPS_COUNTER,
        output wire [C_S_AXI_DATA_WIDTH - 1 : 0] PCIE_BAR0ADDR,
        output wire [3:0] BAR0L,
        output wire [3:0] BAR0H,
        input wire [3:0] BAR0TARGET,
//        output wire BAR_SWITCH,

        // User ports ends
        // Do not modify the ports beyond this line

        // Global Clock Signal
        input wire  S_AXI_ACLK,
        // Global Reset Signal. This Signal is Active LOW
        input wire  S_AXI_ARESETN,
        // Write address (issued by master, acceped by Slave)
        input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
        // Write channel Protection type. This signal indicates the
            // privilege and security level of the transaction, and whether
            // the transaction is a data access or an instruction access.
        input wire [2 : 0] S_AXI_AWPROT,
        // Write address valid. This signal indicates that the master signaling
            // valid write address and control information.
        input wire  S_AXI_AWVALID,
        // Write address ready. This signal indicates that the slave is ready
            // to accept an address and associated control signals.
        output wire  S_AXI_AWREADY,
        // Write data (issued by master, acceped by Slave) 
        input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
        // Write strobes. This signal indicates which byte lanes hold
            // valid data. There is one write strobe bit for each eight
            // bits of the write data bus.    
        input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
        // Write valid. This signal indicates that valid write
            // data and strobes are available.
        input wire  S_AXI_WVALID,
        // Write ready. This signal indicates that the slave
            // can accept the write data.
        output wire  S_AXI_WREADY,
        // Write response. This signal indicates the status
            // of the write transaction.
        output wire [1 : 0] S_AXI_BRESP,
        // Write response valid. This signal indicates that the channel
            // is signaling a valid write response.
        output wire  S_AXI_BVALID,
        // Response ready. This signal indicates that the master
            // can accept a write response.
        input wire  S_AXI_BREADY,
        // Read address (issued by master, acceped by Slave)
        input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
        // Protection type. This signal indicates the privilege
            // and security level of the transaction, and whether the
            // transaction is a data access or an instruction access.
        input wire [2 : 0] S_AXI_ARPROT,
        // Read address valid. This signal indicates that the channel
            // is signaling valid read address and control information.
        input wire  S_AXI_ARVALID,
        // Read address ready. This signal indicates that the slave is
            // ready to accept an address and associated control signals.
        output wire  S_AXI_ARREADY,
        // Read data (issued by slave)
        output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
        // Read response. This signal indicates the status of the
            // read transfer.
        output wire [1 : 0] S_AXI_RRESP,
        // Read valid. This signal indicates that the channel is
            // signaling the required read data.
        output wire  S_AXI_RVALID,
        // Read ready. This signal indicates that the master can
            // accept the read data and response information.
        input wire  S_AXI_RREADY
    );

    // AXI4LITE signals
    reg [C_S_AXI_ADDR_WIDTH-1 : 0]     axi_awaddr;
    reg      axi_awready;
    reg      axi_wready;
    reg [1 : 0]     axi_bresp;
    reg      axi_bvalid;
    reg [C_S_AXI_ADDR_WIDTH-1 : 0]     axi_araddr;
    reg      axi_arready;
    reg [C_S_AXI_DATA_WIDTH-1 : 0]     axi_rdata;
    reg [1 : 0]     axi_rresp;
    reg      axi_rvalid;

    // Example-specific design signals
    // local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
    // ADDR_LSB is used for addressing 32/64 bit registers/memories
    // ADDR_LSB = 2 for 32 bits (n downto 2)
    // ADDR_LSB = 3 for 64 bits (n downto 3)
    localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
    localparam integer OPT_MEM_ADDR_BITS = 4;
    
    // function called clogb2 that returns an integer which has the
    //value of the ceiling of the log base 2

      // function called clogb2 that returns an integer which has the 
      // value of the ceiling of the log base 2.                      
      function integer clogb2 (input integer bit_depth);              
      begin                                                           
        for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
          bit_depth = bit_depth >> 1;                                 
        end                                                           
      endfunction     
    
    
    //user state machine parameter 
    localparam integer TXN_IN_PAGE = 9 - clogb2(C_M_AXI_DATA_WIDTH);
    
    //----------------------------------------------
    //-- Signals for user logic register space example
    //------------------------------------------------
    //-- Number of Slave Registers 32
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg0_src_addr_hi;//I src addr
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg1_src_addr_lo;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg2_dst_addr_hi;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg3_dst_addr_lo;
    
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg4_read_pages;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg5_axprot;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg6_rresp_00;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg7_rresp_01;
    
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg8_rresp_10;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg9_rresp_11;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg10_clk_ctr_hi;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg11_clk_ctr_lo;
    
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg12_txn_counter;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg13_hit_counter;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg14_send_bytes;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg15_laps_counter;
    
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg16_eth_header0;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg17_eth_header1;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg18_eth_header2;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg19_eth_header3;
    
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg20_fifo_base;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg21_eth_base;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg22_time_hi;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg23_time_lo;
//    generate
//        if(C_AESKEYFINDER_PCIE_ENABLE)
//        begin: bar0reg
            reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg24_bar0addr;
//        end
//    endgenerate
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg25_bar0range;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg26_bar0hi_limit_page;
    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg27_bar0_target;
    
//    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg28;
//    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg29;
//    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg30;
//    reg [C_S_AXI_DATA_WIDTH-1:0]    slv_reg31;
    wire     slv_reg_rden;
    wire     slv_reg_wren;
    reg [C_S_AXI_DATA_WIDTH-1:0]     reg_data_out;
    integer     byte_index;
    reg     aw_en;
    reg [7:0] auto_run_counter;
 
    reg [23:0] bar0_read_pages;
     //user 
    reg txn_begin;   
    assign TARGET_READ_ADDR = {slv_reg0_src_addr_hi, slv_reg1_src_addr_lo};
    assign TARGET_WRITE_ADDR = {slv_reg2_dst_addr_hi, slv_reg3_dst_addr_lo};
    assign TXN_BEGIN = txn_begin;
    
    assign READ_PAGES = {8'h00,bar0_read_pages};
    
    assign AXPROT = slv_reg5_axprot[7:0];
    assign HEADER={slv_reg16_eth_header0,slv_reg17_eth_header1,slv_reg18_eth_header2,slv_reg19_eth_header3};
    assign FIFO_MODE = slv_reg5_axprot[C_S_AXI_DATA_WIDTH-1];
    assign INFINITE_MODE = slv_reg5_axprot[C_S_AXI_DATA_WIDTH-2];//-3 for aut_run
    assign POLL_ETH_EN = slv_reg5_axprot[C_S_AXI_DATA_WIDTH-4];
    assign FIFO_BASE = slv_reg20_fifo_base;
//    assign ETH_BASE = slv_reg21_eth_base;
    assign TIME = {slv_reg22_time_hi,slv_reg23_time_lo};
    assign BAR0L[3:0] = slv_reg25_bar0range[11:8];
    assign BAR0H[3:0] = slv_reg25_bar0range[3:0];
//    assign PCIE_BAR0ADDR = slv_reg24_bar0addr;
    // I/O Connections assignments

    assign S_AXI_AWREADY    = axi_awready;
    assign S_AXI_WREADY    = axi_wready;
    assign S_AXI_BRESP    = axi_bresp;
    assign S_AXI_BVALID    = axi_bvalid;
    assign S_AXI_ARREADY    = axi_arready;
    assign S_AXI_RDATA    = axi_rdata;
    assign S_AXI_RRESP    = axi_rresp;
    assign S_AXI_RVALID    = axi_rvalid;






    wire s_aclk;
    BUFG BUFG_S_AXI (
     .O(s_aclk), // 1-bit output: Clock output
     .I(S_AXI_ACLK) // 1-bit input: Clock input
    );





    // Implement axi_awready generation
    // axi_awready is asserted for one S_AXI_ACLK clock cycle when both
    // S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
    // de-asserted when reset is low.

    always @( posedge s_aclk )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_awready <= 1'b0;
          aw_en <= 1'b1;
        end 
      else
        begin    
          if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
            begin
              // slave is ready to accept write address when 
              // there is a valid write address and write data
              // on the write address and data bus. This design 
              // expects no outstanding transactions. 
              axi_awready <= 1'b1;
              aw_en <= 1'b0;
            end
            else if (S_AXI_BREADY && axi_bvalid)
                begin
                  aw_en <= 1'b1;
                  axi_awready <= 1'b0;
                end
          else           
            begin
              axi_awready <= 1'b0;
            end
        end 
    end       

    // Implement axi_awaddr latching
    // This process is used to latch the address when both 
    // S_AXI_AWVALID and S_AXI_WVALID are valid. 

    always @( posedge s_aclk )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_awaddr <= 0;
        end 
      else
        begin    
          if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
            begin
              // Write Address latching 
              axi_awaddr <= S_AXI_AWADDR;
            end
        end 
    end       

    // Implement axi_wready generation
    // axi_wready is asserted for one s_aclk clock cycle when both
    // S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
    // de-asserted when reset is low. 

    always @( posedge s_aclk )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_wready <= 1'b0;
        end 
      else
        begin    
          if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en )
            begin
              // slave is ready to accept write data when 
              // there is a valid write address and write data
              // on the write address and data bus. This design 
              // expects no outstanding transactions. 
              axi_wready <= 1'b1;
            end
          else
            begin
              axi_wready <= 1'b0;
            end
        end 
    end       
    

    always @(posedge s_aclk)
    begin
        if ( S_AXI_ARESETN == 1'b0 )
        begin
            auto_run_counter <= 'd0;
        end
        else if(C_AUTO_RUN && ~auto_run_counter[7])
        begin
            auto_run_counter <= auto_run_counter + 'd1; 
        end
                
    end
    
    
    // Implement memory mapped register select and write logic generation
    // The write data is accepted and written to memory mapped registers when
    // axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
    // select byte enables of slave registers while writing.
    // These registers are cleared when reset (active low) is applied.
    // Slave register write enable is asserted when valid address and data are available
    // and the slave is ready to accept the write address and write data.
    assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

    always @( posedge s_aclk )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          slv_reg0_src_addr_hi <= {{(64 - C_M_AXI_ADDR_WIDTH){1'b0}}, C_AESKEYFINDER_SRC_ADDR[C_M_AXI_ADDR_WIDTH-1:32]};
          slv_reg1_src_addr_lo <= C_AESKEYFINDER_SRC_ADDR[31:0];                 
          slv_reg2_dst_addr_hi <= {{(64 - C_M_AXI_ADDR_WIDTH){1'b0}}, C_AESKEYFINDER_DST_ADDR[C_M_AXI_ADDR_WIDTH-1:32]};
          slv_reg3_dst_addr_lo <= C_AESKEYFINDER_DST_ADDR[31:0];          
          slv_reg4_read_pages <= C_AESKEYFINDER_READ_PAGES[31:0];
          
          slv_reg5_axprot[31] <= C_DST_IS_FIFO;
          slv_reg5_axprot[30] <= C_INFINITE_LOOP;
          slv_reg5_axprot[29] <= C_AUTO_RUN;
          slv_reg5_axprot[28:0] <= 29'd0;
          
          slv_reg14_send_bytes <= 0;
//          slv_reg15_laps_counter <= 0;
          slv_reg16_eth_header0 <= 32'h20702070;
          slv_reg17_eth_header1 <= 32'h30363203;
          slv_reg18_eth_header2 <= 32'h5D00FFFF;
          slv_reg19_eth_header3 <= 32'hFFFFFFFF;
          
          slv_reg20_fifo_base <= C_AESKEYFINDER_FIFO_BASE_ADDR;
          slv_reg21_eth_base <= 0;
//          slv_reg22_time_hi <= 0;
//          slv_reg23_time_lo <= 0;
          slv_reg24_bar0addr <= C_AESKEYFINDER_PCIE_BAR0ADDR;
          slv_reg25_bar0range <= C_AESKEYFINDER_PCIE_BAR0RANGE;
          slv_reg26_bar0hi_limit_page <= C_AESKEYFINDER_PCIE_BAR0HI_LIMIT_PAGE;
//          slv_reg27_bar0_target <= 0;
//          slv_reg28 <= 0;
//          slv_reg29 <= 0;
//          slv_reg30 <= 0;
//          slv_reg31 <= 0;
                    
        end 
      else begin
      
        if(txn_begin)
        begin
         txn_begin=1'b0;
        end
        else if(C_AUTO_RUN && auto_run_counter == 'h7f)
          txn_begin=1'b1;
        else
          txn_begin=1'b0;


        
        if (slv_reg_wren)
          begin
            case ( axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
              5'h00:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 0
                    slv_reg0_src_addr_hi[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              5'h01:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 1
                    slv_reg1_src_addr_lo[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              5'h02:                
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 2
                    slv_reg2_dst_addr_hi[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
              5'h03:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 3
                    slv_reg3_dst_addr_lo[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              5'h04:
              begin
                if(slv_reg5_axprot[29] == 1'b0)
                begin
                    txn_begin = 1'b1;
                end                    
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 3
                    slv_reg4_read_pages[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
              end                        
              5'h05:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 3
                    slv_reg5_axprot[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end                          

              5'h0E:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 14
                    slv_reg14_send_bytes[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  

              5'h10:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 16
                    slv_reg16_eth_header0[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              5'h11:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 17
                    slv_reg17_eth_header1[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              5'h12:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 18
                    slv_reg18_eth_header2[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              5'h13:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 19
                    slv_reg19_eth_header3[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              5'h14:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 20
                    slv_reg20_fifo_base[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              5'h15:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 21
                    slv_reg21_eth_base[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
//書き込む必要がない。RO
//              5'h18:
//                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//                    // Respective byte enables are asserted as per write strobes 
//                    // Slave register 24
//                    slv_reg24_bar0addr[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//                  end  
              5'h19:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 25
                    slv_reg25_bar0range[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
              5'h1A:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes 
                    // Slave register 26
                    slv_reg26_bar0hi_limit_page[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end  
//              5'h1B:
//                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//                    // Respective byte enables are asserted as per write strobes 
//                    // Slave register 27
//                    slv_reg27_bar0_target[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//                  end  
//              5'h1C:
//                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//                    // Respective byte enables are asserted as per write strobes 
//                    // Slave register 28
//                    slv_reg28[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//                  end  
//              5'h1D:
//                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//                    // Respective byte enables are asserted as per write strobes 
//                    // Slave register 29
//                    slv_reg29[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//                  end  
//              5'h1E:
//                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//                    // Respective byte enables are asserted as per write strobes 
//                    // Slave register 30
//                    slv_reg30[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//                  end  
//              5'h1F:
//                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
//                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
//                    // Respective byte enables are asserted as per write strobes 
//                    // Slave register 31
//                    slv_reg31[(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
//                  end  
              default : begin
                          txn_begin=1'b0;              
                          slv_reg0_src_addr_hi <= slv_reg0_src_addr_hi;
                          slv_reg1_src_addr_lo <= slv_reg1_src_addr_lo;                                                    
                          slv_reg2_dst_addr_hi <= slv_reg2_dst_addr_hi;
                          slv_reg3_dst_addr_lo <= slv_reg3_dst_addr_lo;
                          slv_reg4_read_pages <= slv_reg4_read_pages;
                          slv_reg5_axprot <= slv_reg5_axprot;
                          slv_reg14_send_bytes <= slv_reg14_send_bytes;
//                          slv_reg15_laps_counter <= slv_reg15_laps_counter;
                          slv_reg16_eth_header0 <= slv_reg16_eth_header0;
                          slv_reg17_eth_header1 <= slv_reg17_eth_header1;
                          slv_reg18_eth_header2 <= slv_reg18_eth_header2;
                          slv_reg19_eth_header3 <= slv_reg19_eth_header3;
                          slv_reg20_fifo_base <= slv_reg20_fifo_base;
                          slv_reg21_eth_base <= slv_reg21_eth_base;
                                                
                          slv_reg24_bar0addr <= slv_reg24_bar0addr;
                          slv_reg25_bar0range <= slv_reg25_bar0range;
                          slv_reg26_bar0hi_limit_page <= slv_reg26_bar0hi_limit_page;
//                          slv_reg27_bar0_target <= slv_reg27_bar0_target;
//                          slv_reg28 <= slv_reg28;
//                          slv_reg29 <= slv_reg29;
//                          slv_reg30 <= slv_reg30;
//                          slv_reg31 <= slv_reg31;
                        end
            endcase
          end
      end
    end
    

    
    //rresp counter    
    always @( posedge s_aclk )
    begin
      if ( S_AXI_ARESETN == 1'b0 || txn_begin)
        begin          
          slv_reg6_rresp_00 <= 0;
          slv_reg7_rresp_01 <= 0;
          slv_reg8_rresp_10 <= 0;
          slv_reg9_rresp_11 <= 0;
          slv_reg12_txn_counter <= 0;
        end
      else if(TXN_LAST)
        begin
            slv_reg12_txn_counter <= slv_reg12_txn_counter + 32'd1; //txn counter
            case(XRESP)
              2'b00:
              begin
                  slv_reg6_rresp_00 <= slv_reg6_rresp_00 + 32'd1; //O RRESP00 OKAY
              end
              2'b01:
              begin
                  slv_reg7_rresp_01 <= slv_reg7_rresp_01 + 32'd1; //O RRESP01 EXOKAY
              end
              2'b10:
              begin
                  slv_reg8_rresp_10 <= slv_reg8_rresp_10 + 32'd1; //O RRESP10 SLVERR                        
              end
              2'b11:
              begin
                  slv_reg9_rresp_11 <= slv_reg9_rresp_11 + 32'd1; //O RRESP11 DECERR
              end
            endcase                                   
        end
    end    

        
    always @( posedge s_aclk )
    begin
      if ( S_AXI_ARESETN == 1'b0)
        begin          
          slv_reg10_clk_ctr_hi <= 0;
          slv_reg11_clk_ctr_lo <= 0;
        end 
      else
        begin
            {slv_reg10_clk_ctr_hi,slv_reg11_clk_ctr_lo} <= {slv_reg10_clk_ctr_hi,slv_reg11_clk_ctr_lo} + 64'd1;
        end
    end
    
    always @( posedge s_aclk )
    begin
      if ( S_AXI_ARESETN == 1'b0 || txn_begin)
        begin          
          slv_reg13_hit_counter <= 0;
          slv_reg15_laps_counter  <= 0;
        end
      else
        begin
          slv_reg13_hit_counter <= HIT_COUNTER;
          slv_reg15_laps_counter  <= LAPS_COUNTER;           
        end
    end      
    
    always @( posedge s_aclk )
    begin
      if ( S_AXI_ARESETN == 1'b0  || txn_begin)
        begin
          slv_reg22_time_hi <= 0;
          slv_reg23_time_lo <= 0;
        end 
      else begin
          {slv_reg22_time_hi,slv_reg23_time_lo} <= {slv_reg22_time_hi,slv_reg23_time_lo} + 64'd1;    
        end        
    end    
    


    always @( posedge s_aclk )
    begin
      if ( S_AXI_ARESETN == 1'b0)
      begin
        bar0_read_pages <= 0;
      end 
      else if(BAR0TARGET == BAR0H)
      begin
        bar0_read_pages[23:0] <= slv_reg26_bar0hi_limit_page[23:0];
      end
      else
      begin
        bar0_read_pages[23:0] <= slv_reg4_read_pages[23:0];
      end        
    end    





    always @( posedge s_aclk )
    begin
      if ( S_AXI_ARESETN == 1'b0)
        begin
          slv_reg27_bar0_target <= 0;
        end 
      else begin
          slv_reg27_bar0_target[3:0] <= BAR0TARGET[3:0];
        end        
    end    
    



    always @( posedge s_aclk )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_bvalid  <= 0;
          axi_bresp   <= 2'b0;
        end 
      else
        begin    
          if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
            begin
              // indicates a valid write response is available
              axi_bvalid <= 1'b1;
              axi_bresp  <= 2'b0; // 'OKAY' response 
            end                   // work error responses in future
          else
            begin
              if (S_AXI_BREADY && axi_bvalid) 
                //check if bready is asserted while bvalid is high) 
                //(there is a possibility that bready is always asserted high)   
                begin
                  axi_bvalid <= 1'b0; 
                end  
            end
        end
    end   



    always @( posedge s_aclk )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_arready <= 1'b0;
          axi_araddr  <= 32'b0;
        end 
      else
        begin    
          if (~axi_arready && S_AXI_ARVALID)
            begin
              // indicates that the slave has acceped the valid read address
              axi_arready <= 1'b1;
              // Read address latching
              axi_araddr  <= S_AXI_ARADDR;
            end
          else
            begin
              axi_arready <= 1'b0;
            end
        end 
    end       


    always @( posedge s_aclk )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_rvalid <= 0;
          axi_rresp  <= 0;
        end 
      else
        begin    
          if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
            begin
              // Valid read data is available at the read data bus
              axi_rvalid <= 1'b1;
              axi_rresp  <= 2'b0; // 'OKAY' response
            end   
          else if (axi_rvalid && S_AXI_RREADY)
            begin
              // Read data is accepted by the master
              axi_rvalid <= 1'b0;
            end                
        end
    end    



    assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
    always @(*)
    begin
          // Address decoding for reading registers
          case ( axi_araddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB] )
            5'h00   : reg_data_out <= slv_reg0_src_addr_hi;
            5'h01   : reg_data_out <= slv_reg1_src_addr_lo;
            5'h02   : reg_data_out <= slv_reg2_dst_addr_hi;
            5'h03   : reg_data_out <= slv_reg3_dst_addr_lo;
            5'h04   : reg_data_out <= slv_reg4_read_pages;
            5'h05   : reg_data_out <= slv_reg5_axprot;
            5'h06   : reg_data_out <= slv_reg6_rresp_00;
            5'h07   : reg_data_out <= slv_reg7_rresp_01;
            5'h08   : reg_data_out <= slv_reg8_rresp_10;
            5'h09   : reg_data_out <= slv_reg9_rresp_11;
            5'h0A   : reg_data_out <= slv_reg10_clk_ctr_hi;
            5'h0B   : reg_data_out <= slv_reg11_clk_ctr_lo;
            5'h0C   : reg_data_out <= slv_reg12_txn_counter;
            5'h0D   : reg_data_out <= slv_reg13_hit_counter;
            5'h0E   : reg_data_out <= slv_reg14_send_bytes;
            5'h0F   : reg_data_out <= slv_reg15_laps_counter;
            5'h10   : reg_data_out <= slv_reg16_eth_header0;
            5'h11   : reg_data_out <= slv_reg17_eth_header1;
            5'h12   : reg_data_out <= slv_reg18_eth_header2;
            5'h13   : reg_data_out <= slv_reg19_eth_header3;
            5'h14   : reg_data_out <= slv_reg20_fifo_base;
            5'h15   : reg_data_out <= slv_reg21_eth_base;
            5'h16   : reg_data_out <= slv_reg22_time_hi;
            5'h17   : reg_data_out <= slv_reg23_time_lo;
            5'h18   : reg_data_out <= slv_reg24_bar0addr;
            5'h19   : reg_data_out <= slv_reg25_bar0range;
            5'h1A   : reg_data_out <= slv_reg26_bar0hi_limit_page;
            5'h1B   : reg_data_out <= slv_reg27_bar0_target;
//            5'h1C   : reg_data_out <= slv_reg28;
//            5'h1D   : reg_data_out <= slv_reg29;
//            5'h1E   : reg_data_out <= slv_reg30;
//            5'h1F   : reg_data_out <= slv_reg31;
            default : reg_data_out <= 0;
          endcase
    end

    // Output register or memory read data
    always @( posedge s_aclk )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_rdata  <= 0;
        end 
      else
        begin     
          if (slv_reg_rden)
            begin
              axi_rdata <= reg_data_out;     // register read data
            end   
        end
    end    



    endmodule