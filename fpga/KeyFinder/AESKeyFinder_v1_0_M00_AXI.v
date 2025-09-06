
`timescale 1 ns / 1 ps

    
	module AESKeyFinder_v1_0_M00_AXI #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line

		// Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
		parameter integer C_M_AXI_BURST_LEN	= 256,
		// Thread ID Width
		//parameter integer C_M_AXI_ID_WIDTH	= 1,
		parameter integer C_M_AXI_ID_WIDTH	= 4,
		// Width of Address Bus
		parameter integer C_M_AXI_ADDR_WIDTH	= 40,
		// Width of Data Bus
		parameter integer C_M_AXI_DATA_WIDTH	= 128,
		// Width of User Write Address Bus
		parameter integer C_M_AXI_AWUSER_WIDTH	= 0,
		// Width of User Read Address Bus
		parameter integer C_M_AXI_ARUSER_WIDTH	= 0,
		// Width of User Write Data Bus
		parameter integer C_M_AXI_WUSER_WIDTH	=C_M_AXI_DATA_WIDTH/8,
		// Width of User Read Data Bus
		parameter integer C_M_AXI_RUSER_WIDTH	= C_M_AXI_DATA_WIDTH/8,
		// Width of User Response Bus
		parameter integer C_M_AXI_BUSER_WIDTH	= 0,
		
		parameter integer C_S_AXI_DATA_WIDTH	= 32,
		parameter C_AESKEYFINDER_PCIE_ENABLE = 0,
		parameter [C_S_AXI_DATA_WIDTH - 1 : 0] C_AESKEYFINDER_PCIE_BAR0ADDR = 32'hC0000200,
		parameter C_AESKEYFINDER_ALIGN64_ENABLE = 0
	)
	(
		// Users to add ports here
        //stream
        input wire [127 : 0] HEADER,
        input wire [63 : 0] TIME,
        output wire [C_S_AXI_DATA_WIDTH-1:0] LAPS_COUNTER,
        input wire FIFO_MODE,
        input wire INFINITE_MODE, 
        input wire POLL_ETH_EN,
        input wire [C_S_AXI_DATA_WIDTH-1 : 0] FIFO_BASE,
        output wire [1 : 0] KEYHIT,
        input wire [C_M_AXI_ADDR_WIDTH-1 : 0] TARGET_READ_ADDR,
        input wire [C_M_AXI_ADDR_WIDTH-1 : 0] TARGET_WRITE_ADDR,
        //output wire [31:0] TXN_COUNTER,
        input wire [C_S_AXI_DATA_WIDTH-1:0] READ_PAGES,         
        input wire [7:0] AxPROT,
        output wire [C_S_AXI_DATA_WIDTH-1:0] HIT_COUNTER,
        input wire BAR_SWITCH,
        input wire [3:0] BAR0L,
        input wire [3:0] BAR0H,
        output wire [3:0] BAR0TARGET,
        
        output wire [2:0] exec_read_state_wire,
        output wire [2:0] exec_write_state_wire,                  
        
        
//        input wire M_INTERRPT_IN,
		// User ports ends
		// Do not modify the ports beyond this line

		// Initiate AXI transactions
		input wire  INIT_AXI_TXN,
		// Asserts when transaction is complete
		output wire  TXN_DONE,
		// Asserts when ERROR is detected
		output reg  ERROR,
		// Global Clock Signal.
		input wire  M_AXI_ACLK,
		// Global Reset Singal. This Signal is Active Low
		input wire  M_AXI_ARESETN,
		
    //AXI AW channel		
		// Master Interface Write Address ID
		output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_AWID,
		// Master Interface Write Address
		output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_AWADDR,
		// Burst length. The burst length gives the exact number of transfers in a burst
		output wire [7 : 0] M_AXI_AWLEN,
		// Burst size. This signal indicates the size of each transfer in the burst
		output wire [2 : 0] M_AXI_AWSIZE,
		// Burst type. The burst type and the size information, 
        // determine how the address for each transfer within the burst is calculated.
		output wire [1 : 0] M_AXI_AWBURST,
		// Lock type. Provides additional information about the
        // atomic characteristics of the transfer.
		output wire  M_AXI_AWLOCK,
		// Memory type. This signal indicates how transactions
        // are required to progress through a system.
		output wire [3 : 0] M_AXI_AWCACHE,
		// Protection type. This signal indicates the privilege
        // and security level of the transaction, and whether
        // the transaction is a data access or an instruction access.
		output wire [2 : 0] M_AXI_AWPROT,
		// Quality of Service, QoS identifier sent for each write transaction.
		output wire [3 : 0] M_AXI_AWQOS,
		// Optional User-defined signal in the write address channel.
		output wire [C_M_AXI_AWUSER_WIDTH-1 : 0] M_AXI_AWUSER,
		// Write address valid. This signal indicates that
        // the channel is signaling valid write address and control information.
		output wire  M_AXI_AWVALID,
		// Write address ready. This signal indicates that
        // the slave is ready to accept an address and associated control signals
		input wire  M_AXI_AWREADY,
				
    //AXI W channel
		// Master Interface Write Data.
		output wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_WDATA,
		// Write strobes. This signal indicates which byte
        // lanes hold valid data. There is one write strobe
        // bit for each eight bits of the write data bus.
		output wire [C_M_AXI_DATA_WIDTH/8-1 : 0] M_AXI_WSTRB,
		// Write last. This signal indicates the last transfer in a write burst.
		output wire  M_AXI_WLAST,
		// Optional User-defined signal in the write data channel.
		output wire [C_M_AXI_WUSER_WIDTH-1 : 0] M_AXI_WUSER,
		// Write valid. This signal indicates that valid write
        // data and strobes are available
		output wire  M_AXI_WVALID,
		// Write ready. This signal indicates that the slave
        // can accept the write data.
		input wire  M_AXI_WREADY,
		
    //AXI B channel		
		// Master Interface Write Response.
		input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_BID,
		// Write response. This signal indicates the status of the write transaction.
		input wire [1 : 0] M_AXI_BRESP,
		// Optional User-defined signal in the write response channel
		input wire [C_M_AXI_BUSER_WIDTH-1 : 0] M_AXI_BUSER,
		// Write response valid. This signal indicates that the
        // channel is signaling a valid write response.
		input wire  M_AXI_BVALID,
		// Response ready. This signal indicates that the master
        // can accept a write response.
		output wire  M_AXI_BREADY,
		
    //AXI AR channel		
		// Master Interface Read Address.
		output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_ARID,
		// Read address. This signal indicates the initial
        // address of a read burst transaction.
		output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_ARADDR,
		// Burst length. The burst length gives the exact number of transfers in a burst
		output wire [7 : 0] M_AXI_ARLEN,
		// Burst size. This signal indicates the size of each transfer in the burst
		output wire [2 : 0] M_AXI_ARSIZE,
		// Burst type. The burst type and the size information, 
        // determine how the address for each transfer within the burst is calculated.
		output wire [1 : 0] M_AXI_ARBURST,
		// Lock type. Provides additional information about the
        // atomic characteristics of the transfer.
		output wire  M_AXI_ARLOCK,
		// Memory type. This signal indicates how transactions
        // are required to progress through a system.
		output wire [3 : 0] M_AXI_ARCACHE,
		// Protection type. This signal indicates the privilege
        // and security level of the transaction, and whether
        // the transaction is a data access or an instruction access.
		output wire [2 : 0] M_AXI_ARPROT,
		// Quality of Service, QoS identifier sent for each read transaction
		output wire [3 : 0] M_AXI_ARQOS,
		// Optional User-defined signal in the read address channel.
		output wire [C_M_AXI_ARUSER_WIDTH-1 : 0] M_AXI_ARUSER,
		// Write address valid. This signal indicates that
        // the channel is signaling valid read address and control information
		output wire  M_AXI_ARVALID,
		// Read address ready. This signal indicates that
        // the slave is ready to accept an address and associated control signals
		input wire  M_AXI_ARREADY,

    //AXI R channel		
		// Read ID tag. This signal is the identification tag
        // for the read data group of signals generated by the slave.
		input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_RID,
		// Master Read Data
		input wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_RDATA,
		// Read response. This signal indicates the status of the read transfer
		input wire [1 : 0] M_AXI_RRESP,
		// Read last. This signal indicates the last transfer in a read burst
		input wire  M_AXI_RLAST,
		// Optional User-defined signal in the read address channel.
		input wire [C_M_AXI_RUSER_WIDTH-1 : 0] M_AXI_RUSER,
		// Read valid. This signal indicates that the channel
        // is signaling the required read data.
		input wire  M_AXI_RVALID,
		// Read ready. This signal indicates that the master can
        // accept the read data and response information.
		output wire  M_AXI_RREADY
	);

    `include "aes_key_expansion.sv"
//    `include "compare_128bit_parallel.sv"
    
	// function called clogb2 that returns an integer which has the
	//value of the ceiling of the log base 2
	  function integer clogb2 (input integer bit_depth);              
	  begin                                                           
	    for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
	      bit_depth = bit_depth >> 1;                                 
	    end                                                           
	  endfunction                                                     

	  function integer power2 (input integer bit_depth);              
	  begin                                                           
	    for(power2 = 1; bit_depth > 0; power2 = power2 * 2)                   
	      bit_depth = bit_depth - 1;                               
	    end                                                           
	  endfunction                                                     


	// C_TRANSACTIONS_NUM is the width of the index counter for 
	// number of write or read transaction.
	 localparam integer C_TRANSACTIONS_NUM = clogb2(C_M_AXI_BURST_LEN-1);

	// Burst length for transactions, in C_M_AXI_DATA_WIDTHs.
	// Non-2^n lengths will eventually cause bursts across 4K address boundaries.
	 localparam integer C_MASTER_LENGTH	= 12;




	//AXI4 signals
	//AXI4 internal temp signals
	reg [C_M_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
	reg  	axi_awvalid;
	
	reg [C_M_AXI_DATA_WIDTH-1 : 0] 	axi_wdata;
	reg  	axi_wlast;
	reg  	axi_wvalid;
	reg [(C_M_AXI_DATA_WIDTH/8)-1:0] axi_wstrb;
	
	reg  	axi_bready;
	
	reg [C_M_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr_offset;
	reg  	axi_arvalid;
	reg  	axi_rready;
	
	wire axi_read_next;
	wire axi_read_done;
	
	reg [C_M_AXI_ID_WIDTH-1 : 0] axi_arid;
	reg [C_M_AXI_ID_WIDTH-1 : 0] axi_awid;

	reg [power2(C_M_AXI_ID_WIDTH)-1 : 0] rid_flags;
	reg [power2(C_M_AXI_ID_WIDTH)-1 : 0] wid_flags;
	
	
	//write beat count in a burst
	reg [C_TRANSACTIONS_NUM : 0] 	write_index;
	//read beat count in a burst
	reg [C_TRANSACTIONS_NUM : 0] 	read_index;

	
	wire [C_MASTER_LENGTH : 0] 	burst_size_bytes;

	reg  	start_single_burst_write;
	reg  	start_single_burst_read;
	reg  	start_overlap_read_address_negotiation;


	//Interface response error flags
	wire  	wnext;

	reg  	init_txn_ff;
	reg  	init_txn_ff2;
	reg  	init_txn_edge;
	wire  	init_txn_pulse;

    //user def reg
    reg [7:0] awlen;
    reg [C_M_AXI_ADDR_WIDTH-1:0] key_addr;
    reg [C_S_AXI_DATA_WIDTH-1:0] hit_ctr;

    integer i;
    integer j;

    (* KEEP = "true" *) reg [127:0] read_qword_stage [15:0];
    (* KEEP = "true" *) reg [127:0] read_qword_stage_cmp [16:0];
    
    wire [127:0] aes128_key_sche [9:0]; 
    wire [127:0] aes256_key_sche [12:0];    
    reg [127:0] aes128_key_sche_stage_cmp [9:0]; 
    reg [127:0] aes256_key_sche_stage_cmp [12:0];

    wire [127:0] aes128_64align_key_sche [9:0];     
    reg [127:0] aes128_64align_key_sche_stage_cmp [9:0]; 
    wire [127:0] aes256_64align_key_sche [12:0];    
    reg [127:0] aes256_64align_key_sche_stage_cmp [12:0];

                 
    reg [15:0]  key_round_bitmap;
    reg [9:0]   round_key_bitmap128;
    reg [12:0]  round_key_bitmap256;
    reg [9:0]   round_key_bitmap128_64align;
    reg [12:0]  round_key_bitmap256_64align;    


    wire key_hit_128;
    wire key_hit_256;
//    wire key_hit_pulse;
    wire key_hit_128align;
    wire key_hit_64align;    

    wire key_hit_rsa_128align;
    wire key_hit_rsa_64align;

    wire key_hit_ecdsa_128align;
    wire key_hit_ecdsa_64align;
        
    wire key_hit_pkcs8_128align;
    wire key_hit_pkcs8_64align;

    reg [127:0] cand_key_hold_stage [2:0];
    reg [127:0] key_output_stage [1:0];
    
    reg [C_S_AXI_DATA_WIDTH-1:0] laps_ctr;
    reg [2:0]key_hit;
    reg key_hit_en;
    reg [9:0]packet_words;
    
 
    reg [C_S_AXI_DATA_WIDTH-1:0] read_page_counter;
    reg key_in_page;
    reg [15:0] packet_no;

    wire m128_aclk,m256_aclk;
    
    reg [3:0] bar0adjust;
    assign BAR0TARGET = bar0adjust;
     
    //reg [3:0] mst_exec_state;
    reg [2:0] exec_read_state;
    reg [2:0] exec_write_state;                                                                                              
    assign exec_read_state_wire = exec_read_state;
    assign exec_write_state_wire = exec_write_state;
    
	localparam [2:0] 
	    W_IDLE = 3'h0, // This state initiates AXI4 
		W_ETH_HEADER   = 3'h1,
		W_KEY_OUTPUT = 3'h2,
        W_EPILOGUE_TIME = 3'h3,
		W_EPILOGUE_TDR = 3'h4,
		W_EPILOGUE_TLR = 3'h5,
		W_CHANGE_BAR = 3'h6;


	localparam [2:0] 
	    R_IDLE = 4'h0,
	    R_POLL_ETH = 4'h1,	     
        R_NEGO_ARADDR_AND_READ = 4'h2,
		R_READING = 4'h3,
		R_WAIT_WRITE_TX = 4'h4,
		R_WAIT_WRITE_BAR = 4'h5,	
		R_EPILOGUE = 4'h6;
			

`ifdef FORMAL_VERIFICATION
    assign m128_aclk = M_AXI_ACLK;
    assign m256_aclk = M_AXI_ACLK;
`else
    BUFG BUFG_M128_AXI (
     .O(m128_aclk), // 1-bit output: Clock output
     .I(M_AXI_ACLK) // 1-bit input: Clock input
    );
    BUFG BUFG_M256_AXI (
     .O(m256_aclk), // 1-bit output: Clock output
     .I(M_AXI_ACLK) // 1-bit input: Clock input
    );    
`endif       

	assign axi_read_next = M_AXI_RVALID & axi_rready;
	assign axi_read_done = M_AXI_RVALID & axi_rready & M_AXI_RLAST;
    
    assign key_hit_128 = ((round_key_bitmap128 != 'd0) ^ (round_key_bitmap128_64align != 'd0)) && ~(round_key_bitmap256 != 'd0 || round_key_bitmap256_64align != 'd0);
    assign key_hit_256 = ((round_key_bitmap256 != 'd0) ^ (round_key_bitmap256_64align != 'd0)) && ~(round_key_bitmap128 != 'd0 || round_key_bitmap128_64align != 'd0);
    assign key_hit_128align = (round_key_bitmap128 != 'd0) ^ (round_key_bitmap256 != 'd0);
    assign key_hit_64align = (round_key_bitmap128_64align != 'd0) ^ (round_key_bitmap256_64align != 'd0);    
	// I/O Connections assignments

	//I/O Connections. Write Address (AW)
	assign M_AXI_AWID	= axi_awid;
	//The AXI address is a concatenation of the target base address + active offset range
	assign M_AXI_AWADDR	= axi_awaddr;	
	//Burst LENgth is number of transaction beats, minus 1
	assign M_AXI_AWLEN	= awlen;
	//Size should be C_M_AXI_DATA_WIDTH, in 2^SIZE bytes, otherwise narrow bursts are used
	assign M_AXI_AWSIZE	= clogb2((C_M_AXI_DATA_WIDTH/8)-1);
	//INCR burst type is usually used, except for keyhole bursts
	assign M_AXI_AWBURST	= 2'b01;
	assign M_AXI_AWLOCK	= 1'b0;
 
	assign M_AXI_AWCACHE	= 4'b0010;
	assign M_AXI_AWPROT	= AxPROT[2:0];
	assign M_AXI_AWQOS	= 4'h0;
	assign M_AXI_AWUSER	= 'd0;
	assign M_AXI_AWVALID	= axi_awvalid;

	//Write Data(W)
//	assign M_AXI_WID	= axi_wid;
	assign M_AXI_WDATA	= (FIFO_MODE && (exec_write_state == W_KEY_OUTPUT || exec_write_state == W_EPILOGUE_TIME))? little2net(axi_wdata) : axi_wdata;
	//All bursts are complete and aligned in this example
	assign M_AXI_WSTRB	= axi_wstrb;
	assign M_AXI_WLAST	= axi_wlast;
	assign M_AXI_WUSER	= 'd0;
	assign M_AXI_WVALID	= axi_wvalid;
	//Write Response (B)
	assign M_AXI_BREADY	= axi_bready;

	//Read Address (AR)
	assign M_AXI_ARID	= axi_arid;	
	assign M_AXI_ARADDR	= (exec_read_state == R_POLL_ETH) ? 40'h00a0080000 : TARGET_READ_ADDR + axi_araddr_offset;
	//Burst LENgth is number of transaction beats, minus 1
	assign M_AXI_ARLEN	= (exec_read_state == R_POLL_ETH) ? 0 : C_M_AXI_BURST_LEN - 1;
	//Size should be C_M_AXI_DATA_WIDTH, in 2^n bytes, otherwise narrow bursts are used
	assign M_AXI_ARSIZE	= clogb2((C_M_AXI_DATA_WIDTH/8)-1);
	//INCR burst type is usually used, except for keyhole bursts
	assign M_AXI_ARBURST	= 2'b01;
	assign M_AXI_ARLOCK	= 1'b0;
	 
	assign M_AXI_ARCACHE	= 4'b0010;
	assign M_AXI_ARPROT	= AxPROT[6:4];
	assign M_AXI_ARQOS	= 4'h0;
	assign M_AXI_ARUSER	= 'd0;
	assign M_AXI_ARVALID	= axi_arvalid;
	//Read and Read Response (R)
	assign M_AXI_RREADY	= axi_rready;

	//Example design I/O
	assign TXN_DONE	= 0;//compare_done;
	//Burst size in bytes
	assign burst_size_bytes	= C_M_AXI_BURST_LEN * C_M_AXI_DATA_WIDTH/8;
	assign init_txn_pulse	= (!init_txn_ff2) && init_txn_ff;
    assign LAPS_COUNTER = laps_ctr;
    assign HIT_COUNTER = hit_ctr;
    assign KEYHIT = key_hit;
	//Generate a pulse to PROLOGUEiate AXI transaction.
	always @(posedge m128_aclk)										      
	  begin                                                                        
	    // PROLOGUEiates AXI transaction delay    
	    if (M_AXI_ARESETN == 0 )                                                   
	      begin                                                                    
	        init_txn_ff <= 1'b0;                                                   
	        init_txn_ff2 <= 1'b0;                                                   
	      end                                                                               
	    else                                                                       
	      begin  
	        init_txn_ff <= INIT_AXI_TXN;
	        init_txn_ff2 <= init_txn_ff;                                                                 
	      end                                                                      
	  end     


	//--------------------
	//Write Address Channel
	//--------------------

	// The purpose of the write address channel is to request the address and 
	// command information for the entire transaction.  It is a single beat
	// of information.

	// The AXI4 Write address channel in this example will continue to PROLOGUEiate
	// write commands as fast as it is allowed by the slave/interconnect.
	// The address will be incremented on each accepted address transaction,
	// by burst_size_byte to point to the next address. 





	  always @(posedge m128_aclk)                                   
	  begin                                                                
	                                                                       
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 )                                           
	      begin                                                            
	        axi_awvalid <= 1'b0;                                           
	      end                                                              
	    // If previously not valid , start next transaction                
	    else if (~axi_awvalid && start_single_burst_write)                 
	      begin                                                            
	        axi_awvalid <= 1'b1;                                           
	      end                                                              
	    /* Once asserted, VALIDs cannot be deasserted, so axi_awvalid      
	    must wait until transaction is accepted */                         
	    else if (M_AXI_AWREADY && axi_awvalid)                             
	      begin                                                            
	        axi_awvalid <= 1'b0;                                           
	      end                                                              
	    else                                                               
	      axi_awvalid <= axi_awvalid;                                      
	    end                                                                
	                                                                       
	                                                                       
	// Next address after AWREADY indicates previous address acceptance    
	  always @(posedge m128_aclk)                                         
	  begin                                                                
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1)                                            
	      begin                                                            
	        axi_awaddr <= TARGET_WRITE_ADDR;                                             
	      end                                                              
	    else if (M_AXI_AWREADY && axi_awvalid && C_M_AXI_DATA_WIDTH == 128 && ~FIFO_MODE)                             
	      begin
	            case(key_hit)
                2'd1:
                    axi_awaddr <= axi_awaddr + 32;  
                2'd2:
                   axi_awaddr <= axi_awaddr + 32;  
                2'd3:
                   axi_awaddr <= axi_awaddr + 48;  
                default:
                   axi_awaddr <= axi_awaddr + 32;  
                endcase                                                        	                         
	      end

	    else if (exec_write_state == W_KEY_OUTPUT && FIFO_MODE)                             
            begin
                axi_awaddr <= TARGET_WRITE_ADDR;                                                                                     
            end
	    else if (exec_write_state == W_ETH_HEADER && FIFO_MODE)                             
            begin
                axi_awaddr <= TARGET_WRITE_ADDR;                                                                                     
            end
               	      	     	                                                                    
	    else if (exec_write_state == W_EPILOGUE_TDR && C_M_AXI_DATA_WIDTH == 128)                             
            begin
                axi_awaddr[C_S_AXI_DATA_WIDTH-1:0] <= FIFO_BASE + 'h20;                                                                                     
            end
	    else if (exec_write_state == W_EPILOGUE_TLR)                             
            begin
                axi_awaddr[C_S_AXI_DATA_WIDTH-1:0] <= FIFO_BASE + 'h10;                                                                                     
            end                	      	     	                                                                    
	    else if (exec_write_state == W_CHANGE_BAR)                             
            begin
                axi_awaddr[C_S_AXI_DATA_WIDTH-1:0] <= C_AESKEYFINDER_PCIE_BAR0ADDR;                                                                                     
            end
	    else 	                                                                   
	      axi_awaddr <= axi_awaddr;                                        
	    end                                                                


	//--------------------
	//Write Data Channel
	//--------------------

	//The write data will continually try to push write data across the interface.

	//The amount of data accepted will depend on the AXI slave and the AXI
	//Interconnect settings, such as if there are FIFOs enabled in interconnect.

	//Note that there is no explicit timing relationship to the write address channel.
	//The write channel has its own throttling flag, separate from the AW channel.

	//Synchronization between the channels must be determined by the user.

	//The simpliest but lowest performance would be to only issue one address write
	//and write data burst at a time.

	//In this example they are kept in sync by using the same address increment
	//and burst sizes. Then the AW and W channels have their transactions measured
	//with threshold counters as part of the user logic, to make sure neither 
	//channel gets too far ahead of each other.

	//Forward movement occurs when the write channel is valid and ready

	  assign wnext = M_AXI_WREADY & axi_wvalid;                                   
	                                                                                    
	// WVALID logic, similar to the axi_awvalid always block above                      
	  always @(posedge m128_aclk)                                                      
	  begin                                                                             
	    if (M_AXI_ARESETN == 0)                                                        
	      begin                                                                         
	        axi_wvalid <= 1'b0;                                                         
	      end                                                                           
	    // If previously not valid, start next transaction                                                             
        else if(M_AXI_AWREADY & axi_awvalid)
	      begin                                                                         
	        axi_wvalid <= 1'b1;                                                         
	      end                                                                           
	    /* If WREADY and too many writes, throttle WVALID                               
	    Once asserted, VALIDs cannot be deasserted, so WVALID                           
	    must wait until burst is complete with WLAST */                                 
	    else if (M_AXI_WREADY & axi_wvalid & axi_wlast)                                                    
	      axi_wvalid <= 1'b0;                                                           
	    else                                                                            
	      axi_wvalid <= axi_wvalid;                                                     
	  end                                                                               
	                                                                                    
	                                                                                    
	//WLAST generation on the MSB of a counter underflow                                
	// WVALID logic, similar to the axi_awvalid always block above                      
	  always @(posedge m128_aclk)                                                      
	  begin                                                                             
	    if (awlen != 0 && M_AXI_AWREADY && axi_awvalid)                                                        
	      begin                                                                         
	        axi_wlast <= 1'b0;                                                          
	      end                                                                           
	    // axi_wlast is asserted when the write index                                   
	    // count reaches the penultimate count to synchronize                           
	    // with the last write data when write_index is b1111                           
	    else if (((write_index == awlen - 8'd1 && awlen != 0) && M_AXI_WREADY && axi_wvalid))
	      begin                                                                         
	        axi_wlast <= 1'b1;                                                          
	      end
	    else if (awlen == 0 && M_AXI_AWREADY && axi_awvalid)
            begin                                                                         
              axi_wlast <= 1'b1;                                                          
            end  	                                                                                 
	    // Deassrt axi_wlast when the last write data has been                          
	    // accepted by the slave with a valid response                                  
	    else if (axi_wlast && M_AXI_WREADY && axi_wvalid)                                                                 
	      axi_wlast <= 1'b0;                                                                                                                        
	    else                                                                            
	      axi_wlast <= axi_wlast;                                                       
	  end                                                                               
	                                                                                    
	                                                                                    
	/* Burst length counter. Uses extra counter register bit to indicate terminal       
	 count to reduce decode logic */                                                    
	  always @(posedge m128_aclk)                                                      
	  begin                                                                             

	    if (start_single_burst_write == 1'b1)    
	      begin                                                                         
	        write_index <= 0;                                                           
	      end                                                                           
	    else if (M_AXI_WREADY && axi_wvalid && write_index != awlen)                         
	      begin                                                                         
	        write_index <= write_index + 1;                                             
	      end
        else                                                                            
	      write_index <= write_index;                                                   
	  end                                                                               
//AXI WSTRB        	                                                                                    
      always @(posedge m128_aclk)begin                                                                             
        case(exec_write_state)
            W_EPILOGUE_TDR:
                axi_wstrb[(C_M_AXI_DATA_WIDTH/8)-1:0] <= 16'hF000;
            W_EPILOGUE_TLR:
                axi_wstrb[(C_M_AXI_DATA_WIDTH/8)-1:0] <= 16'h00F0;
            W_CHANGE_BAR:
                axi_wstrb[(C_M_AXI_DATA_WIDTH/8)-1:0] <= 16'h0F00;
            default:
                axi_wstrb[(C_M_AXI_DATA_WIDTH/8)-1:0] <= {(C_M_AXI_DATA_WIDTH/8){1'b1}};
        endcase                                     
      end	                                                                                    


//AXI WDATA
      always @(posedge m128_aclk)                                                      
	  begin                                                                             

        if(start_single_burst_write && exec_write_state == W_ETH_HEADER)
        begin
            axi_wdata[C_M_AXI_DATA_WIDTH-1:0] <= {packet_no[7:0],packet_no[15:8],HEADER[111-:C_M_AXI_DATA_WIDTH-16]};                     
        end
               
        else if(start_single_burst_write && exec_write_state == W_EPILOGUE_TIME)
        begin
            axi_wdata[C_M_AXI_DATA_WIDTH-1-:64] <= TIME[63:0];
            axi_wdata[63:12] <= {laps_ctr[C_S_AXI_DATA_WIDTH-1:0],20'h0E0F0};
            axi_wdata[11:0] <= {(packet_words[9:0]+'d4),2'h0};                     
        end

        else if(start_single_burst_write && exec_write_state == W_EPILOGUE_TDR)
        begin
            axi_wdata[C_M_AXI_DATA_WIDTH-1:0] <= 128'h0000000100000001_0000000100000001;                     
        end
        else if(start_single_burst_write && exec_write_state == W_EPILOGUE_TLR)
        begin
            axi_wdata[C_M_AXI_DATA_WIDTH-1:0] = 'd0;
            axi_wdata[C_M_AXI_DATA_WIDTH/4+:12] = {packet_words[9:0],2'h0};                     
        end
        else if(start_single_burst_write && exec_write_state == W_CHANGE_BAR)
        begin
//            axi_wdata[C_M_AXI_DATA_WIDTH-1:0] <= 128'h00000002_00000000_00000002_00000000;
            axi_wdata[C_M_AXI_DATA_WIDTH-1-:32] <= {32'h0000000C};//0x0C
            axi_wdata[C_M_AXI_DATA_WIDTH-33-:32] <= {28'h0000000,bar0adjust[3:0]};//0x08
            axi_wdata[C_M_AXI_DATA_WIDTH/2-1-:32] <= {32'h00000004};//0x04
            axi_wdata[C_M_AXI_DATA_WIDTH/4-1-:32] <= {32'h0000000F};//0x00
                                 
        end
        else if(M_AXI_AWREADY && axi_awvalid && exec_write_state == W_KEY_OUTPUT)
        //key type header, phys address, bitmap        
        begin
            if(FIFO_MODE)
            begin          
                case(key_hit)
                    'd1:
                         axi_wdata[C_M_AXI_DATA_WIDTH-1-:16] <= 16'ha128;//[127:112]
                    'd2:
                         axi_wdata[C_M_AXI_DATA_WIDTH-1-:16] <= 16'ha192;
                    'd3:
                         axi_wdata[C_M_AXI_DATA_WIDTH-1-:16] <= 16'ha256;
                    'd4:
                         axi_wdata[C_M_AXI_DATA_WIDTH-1-:16] <= 16'h8017;//RSA PKCS#1
                    'd5:
                         axi_wdata[C_M_AXI_DATA_WIDTH-1-:16] <= 16'h5915;//ECDSA
                    'd6:
                         axi_wdata[C_M_AXI_DATA_WIDTH-1-:16] <= 16'h5958;//RFC 5958 PKCS#8
                    default:
                         axi_wdata[C_M_AXI_DATA_WIDTH-1-:16] <= 16'ha222;
                endcase
            end                
            else
            begin          
                case(key_hit)
                    'd1:
                         axi_wdata[C_M_AXI_DATA_WIDTH/2-1-:16] <= 16'ha128;//[63:48]
                    'd2:
                         axi_wdata[C_M_AXI_DATA_WIDTH/2-1-:16] <= 16'ha192;
                    'd3:
                         axi_wdata[C_M_AXI_DATA_WIDTH/2-1-:16] <= 16'ha256;
                    'd4:
                         axi_wdata[C_M_AXI_DATA_WIDTH-1-:16] <= 16'h8017;
                    'd5:
                         axi_wdata[C_M_AXI_DATA_WIDTH-1-:16] <= 16'h5915;
                    'd6:
                         axi_wdata[C_M_AXI_DATA_WIDTH-1-:16] <= 16'h5958;
                    default:
                         axi_wdata[C_M_AXI_DATA_WIDTH/2-1-:16] <= 16'ha222;
                endcase
            end 
            if(FIFO_MODE)
            begin
                axi_wdata[C_M_AXI_DATA_WIDTH - 17 : C_M_AXI_DATA_WIDTH/2] <= {key_round_bitmap,hit_ctr[31:0]};//[111:64]                                    
                axi_wdata[C_M_AXI_DATA_WIDTH/2-1 : C_M_AXI_ADDR_WIDTH] <= 'd0;//[63:40]
                if(C_AESKEYFINDER_PCIE_ENABLE)
                begin
                    axi_wdata[C_M_AXI_ADDR_WIDTH - 1 : 0] <= {4'h0,bar0adjust[3:0],key_addr[31:0]};//[39:0]
                end
                else
                begin 
                    axi_wdata[C_M_AXI_ADDR_WIDTH - 1 : 0] <= key_addr;//[39:0]
                end
            end                                                       
            else
            begin  
                axi_wdata[C_M_AXI_DATA_WIDTH/2 - 17 : 0] <= {key_round_bitmap,hit_ctr[31:0]};//[47:0]
                axi_wdata[C_M_AXI_DATA_WIDTH-1 : C_M_AXI_DATA_WIDTH/2 + C_M_AXI_ADDR_WIDTH] <= 24'd0;//[127:104]
                axi_wdata[C_M_AXI_DATA_WIDTH/2 + C_M_AXI_ADDR_WIDTH - 1 : C_M_AXI_DATA_WIDTH/2] <= key_addr;//[103:64]
            end                                                       
                  
        end
	    else if(wnext && exec_write_state == W_KEY_OUTPUT)
	    begin    
	       case (write_index+'d1)
	         8'd1:begin
	           axi_wdata <= key_output_stage[0];
	           end 
	         8'd2:begin
	           axi_wdata <= key_output_stage[1];
	           end
             default:
               axi_wdata <= axi_wdata;                      
	       endcase	       
	    end                                                                                                                                                                
      end 

	//----------------------------
	//Write Response (B) Channel
	//----------------------------


	  always @(posedge m128_aclk)                                     
	  begin                                                                 
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 )                                            
	      begin                                                             
	        axi_bready <= 1'b0;                                             
	      end                                                                                     
	    else if (M_AXI_BVALID && ~axi_bready)                               
	      begin                                                             
	        axi_bready <= 1'b1;                                             
	      end                                                               
	    else if (axi_bready)                                                
	      begin                                                             
	        axi_bready <= 1'b0;                                             
	      end                                                               
	    else                                                                
	      axi_bready <= axi_bready;                                         
	  end                                                                   


	  always @(posedge m128_aclk)                                 
	  begin                                                              	                                                                     
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 )                                         
	      begin                                                          
	        wid_flags <= 'd0;                                         
	      end
        else if (M_AXI_AWREADY && axi_awvalid && M_AXI_BVALID && axi_bready)
          begin
            if(axi_awid != M_AXI_BID)
              begin
                wid_flags[axi_awid] <= 1'b1;
                wid_flags[M_AXI_BID] <= 1'b0;
              end
            else
              wid_flags[axi_awid] <= 1'b0;
          end
	    else if (M_AXI_AWREADY && axi_awvalid)
	      begin
            wid_flags[axi_awid] <= 1'b1;	      
	      end                                                                                                              
	    else if (M_AXI_BVALID && axi_bready)                           
	      begin                       
            wid_flags[M_AXI_BID] <= 1'b0;                                                     	                                                 
	      end                                                            
	    else                                                             
	      wid_flags <= wid_flags;                                    
	  end

	  always @(posedge m128_aclk)                                 
	  begin                                                              	                                                                     
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 )                                         
	      begin                                                          
	        axi_awid <= 1'b0;                                         
	      end                                                                                                              
	    else if (start_single_burst_write)
	      case(exec_write_state)
	        W_ETH_HEADER:
	          axi_awid[C_M_AXI_ID_WIDTH - 1 : 0] <= {read_page_counter[0], 3'h0};
            W_EPILOGUE_TIME:
              axi_awid[C_M_AXI_ID_WIDTH - 1 : 0] <= {axi_awid[C_M_AXI_ID_WIDTH - 1], 3'h1};
            W_EPILOGUE_TDR:
              axi_awid[C_M_AXI_ID_WIDTH - 1 : 0] <= {axi_awid[C_M_AXI_ID_WIDTH - 1], 3'h2};
            W_EPILOGUE_TLR:
              axi_awid[C_M_AXI_ID_WIDTH - 1 : 0] <= {axi_awid[C_M_AXI_ID_WIDTH - 1], 3'h3};
            W_KEY_OUTPUT:
              axi_awid[C_M_AXI_ID_WIDTH - 1 : 0] <= {axi_awid[C_M_AXI_ID_WIDTH - 1], 1'b1, 2'h0};
            W_CHANGE_BAR:
              axi_awid[C_M_AXI_ID_WIDTH - 1 : 0] <= {(C_M_AXI_ID_WIDTH){1'b1}};              
          endcase                           
	    else                                                             
	      axi_awid <= axi_awid;                                    
	  end




    // トランザクションフラグ管理
    always @(posedge m128_aclk)                                 
    begin                                                              	                                                                     
      if (!M_AXI_ARESETN || init_txn_pulse )                                         
        begin                                                          
          rid_flags <= 'd0;                                         
        end
      else if (M_AXI_ARREADY && axi_arvalid)
        begin
          rid_flags[axi_arid] <= 1'b1; // 現在のIDをアクティブに設定
        end                                                                                                              
      else if (axi_read_done)                           
        begin
          rid_flags[M_AXI_RID] <= 1'b0; // 読み取り完了時にIDを解放
        end                                                            
      else                                                             
        rid_flags <= rid_flags;                                    
    end	                                                                        
    
    // Read Address Channel
    always @(posedge m128_aclk)                                 
    begin                                                              	                                                                     
      if (!M_AXI_ARESETN || init_txn_pulse )                                         
        begin                                                          
          axi_arid <= 'd0;                                         
        end                                                                                                              
      else if (start_single_burst_read || start_overlap_read_address_negotiation)                           
        begin
          // 利用可能な最小のIDを選択
          if (!rid_flags[0]) begin
            axi_arid <= 2'd0;
          end
          else if (!rid_flags[1]) begin
            axi_arid <= 2'd1;
          end
          else if (!rid_flags[2]) begin
            axi_arid <= 2'd2;
          end
          else if (!rid_flags[3]) begin
            axi_arid <= 2'd3;
          end
          else begin
            axi_arid <= axi_arid; // すべてのIDが使用中の場合は保持
          end
        end                                                            
      else                                                             
        axi_arid <= axi_arid;                                    
    end
    
	//----------------------------
	//Read Address Channel
	//----------------------------
//	  always @(posedge m128_aclk)                                 
//	  begin                                                              	                                                                     
//	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 )                                         
//	      begin                                                          
//	        axi_arid <= 'd0;                                         
//	      end                                                                                                              
//	    else if (start_single_burst_read || start_overlap_read_address_negotiation)                           
//	      begin
//	       axi_arid[0] <= rid_flags[0];//最小のIDを選択している                                                              	                                                 
//	      end                                                            
//	    else                                                             
//	      axi_arid <= axi_arid;                                    
//	  end

	  always @(posedge m128_aclk)                                 
	  begin                                                              
	                                                                     
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 )                                         
	      begin                                                          
	        axi_arvalid <= 1'b0;                                         
	      end                                                            
	    // If previously not valid , start next transaction              
	    else if (~axi_arvalid && start_single_burst_read)                
	      begin                                                          
	        axi_arvalid <= 1'b1;                                         
	      end
	    else if (~axi_arvalid && start_overlap_read_address_negotiation)                
	      begin                                                          
	        axi_arvalid <= 1'b1;                                         
	      end	                                                          
	    else if (M_AXI_ARREADY && axi_arvalid)                           
	      begin                                                          
	        axi_arvalid <= 1'b0;                                         
	      end                                                            
	    else                                                             
	      axi_arvalid <= axi_arvalid;                                    
	  end                                                                
	                                                                     
	                                                                     
	// Next address after ARREADY indicates previous address acceptance  
	  always @(posedge m128_aclk)                                       
	  begin                                                              
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 || axi_araddr_offset[C_M_AXI_ADDR_WIDTH-1:12] == READ_PAGES[C_M_AXI_ADDR_WIDTH-13:0])                                          
	      begin                                                          
	        axi_araddr_offset <= 'b0;                                           
	      end                                                            
	    else if (M_AXI_ARREADY && axi_arvalid && exec_read_state != R_POLL_ETH)                           
	      begin                                                          
	        axi_araddr_offset <= axi_araddr_offset + burst_size_bytes;                 
	      end                                                            
	    else                                                             
	      axi_araddr_offset <= axi_araddr_offset;                                      
	  end                                                                


	//--------------------------------
	//Read Data (and Response) Channel
	//--------------------------------

	 // Forward movement occurs when the channel is valid and ready   
//	  assign rnext = M_AXI_RVALID && axi_rready;                            
	                                                                        
	                                                                        
	// Burst length counter. Uses extra counter register bit to indicate    
	// terminal count to reduce decode logic                                
	  always @(posedge m128_aclk)                                          
	  begin                                                                 
//	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1)
	    if (M_AXI_ARESETN == 0)                  
	      begin                                                             
	        read_index <= 'd0;                                                
	      end                                                               
//	    else if (M_AXI_RVALID && axi_rready && (read_index != C_M_AXI_BURST_LEN-1))
	    else if (axi_read_next && (read_index != C_M_AXI_BURST_LEN-1))              
	      begin                                                             
	        read_index <= read_index + 1;                                   
	      end
//	    else if (M_AXI_RVALID && axi_rready && M_AXI_RLAST)
	    else if(axi_read_done)              
	      begin                                                             
	        read_index <= 'd0;                                   
	      end                                                               	                                                                     
	    else                                                                
	      read_index <= read_index;                                         
	  end                                                                   
	                                                                        
	                                                                        
	/*                                                                      
	 The Read Data channel returns the results of the read request          
	                                                                        
	 In this example the data checker is always able to accept              
	 more data, so no need to throttle the RREADY signal                    
	 */                                                                     
	  always @(posedge m128_aclk)                                          
	  begin                                                                 
//	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1 )
	    if (M_AXI_ARESETN == 0)                  
	      begin                                                             
	        axi_rready <= 1'b0;                                             
	      end                                                               
	    // accept/acknowledge rdata/rresp with axi_rready by the master     
	    // when M_AXI_RVALID is asserted by slave                           
	    else if (M_AXI_RVALID)                                                       
          axi_rready <= 1'b1;                 
	    else
	      axi_rready <= 1'b0;                                        
	    // retain the previous value                 
	  end                                            







    wire rk_128_0align_hit = (round_key_bitmap128 != 'd0);
    wire rk_128_64align_hit = (round_key_bitmap128_64align != 'd0);
    wire rk_256_0align_hit = (round_key_bitmap256 != 'd0);
    wire rk_256_64align_hit = (round_key_bitmap256_64align != 'd0);       
    
    //同時ヒットを除外
//    wire key_hit_pulse = ((rk_128_0align_hit & ~rk_128_64align_hit & ~rk_256_0align_hit & ~rk_256_64align_hit & ~key_hit_rsa_128align  & ~key_hit_rsa_64align)|
//                            (~rk_128_0align_hit & rk_128_64align_hit & ~rk_256_0align_hit & ~rk_256_64align_hit & ~key_hit_rsa_128align  & ~key_hit_rsa_64align)|
//                            (~rk_128_0align_hit & ~rk_128_64align_hit & rk_256_0align_hit & ~rk_256_64align_hit & ~key_hit_rsa_128align  & ~key_hit_rsa_64align)|
//                            (~rk_128_0align_hit & ~rk_128_64align_hit & ~rk_256_0align_hit & rk_256_64align_hit & ~key_hit_rsa_128align  & ~key_hit_rsa_64align)|
//                            (~rk_128_0align_hit & ~rk_128_64align_hit & ~rk_256_0align_hit & ~rk_256_64align_hit & key_hit_rsa_128align  & ~key_hit_rsa_64align)|
//                            (~rk_128_0align_hit & ~rk_128_64align_hit & ~rk_256_0align_hit & ~rk_256_64align_hit & ~key_hit_rsa_128align  & key_hit_rsa_64align));

    // 同時ヒットを除外
    wire key_hit_pulse = ((rk_128_0align_hit + rk_128_64align_hit + rk_256_0align_hit + rk_256_64align_hit + key_hit_rsa_128align + key_hit_rsa_64align + key_hit_ecdsa_128align + key_hit_ecdsa_64align + key_hit_pkcs8_128align + key_hit_pkcs8_64align) == 1);
    
                            
    wire no_hit = ~(rk_128_0align_hit | rk_128_64align_hit | rk_256_0align_hit | rk_256_64align_hit | key_hit_rsa_128align | key_hit_rsa_64align | key_hit_ecdsa_128align + key_hit_ecdsa_64align + key_hit_pkcs8_128align + key_hit_pkcs8_64align);                            
    wire dup_hit = ((rk_128_0align_hit + rk_128_64align_hit + rk_256_0align_hit + rk_256_64align_hit + key_hit_rsa_128align + key_hit_rsa_64align + key_hit_ecdsa_128align + key_hit_ecdsa_64align + key_hit_pkcs8_128align + key_hit_pkcs8_64align) > 1);




                                                             
    	                                                                                                            
	  //implement master state machine                                                        
	                                                                                                            
	  always @ ( posedge m128_aclk)                                                                            
	  begin                                                                                                     
	    if (M_AXI_ARESETN == 1'b0 )                                                                             
	      begin                                                                                                 
	        // reset condition                                                                                                                  
	        exec_read_state      <= R_IDLE;                                                                	                                                                            
	        start_single_burst_read  <= 1'b0;                                                                   
            read_page_counter <= 'd0;                                                                   
	        ERROR <= 1'b0;
	        start_overlap_read_address_negotiation <= 1'b0;
	      end                                                                                                   
	    else                                                                                                    
	      begin                                                                                                 
	                                                                                                            
	        // state transition                                                                                 
	        case (exec_read_state)                                                                               
	                                                                                                            
	          R_IDLE:                                                                                                                                               
	            if ( init_txn_pulse == 1'b1 && FIFO_MODE && POLL_ETH_EN)                                                      
	              begin                                                                     
	                exec_read_state  <= R_POLL_ETH;
	                start_single_burst_read  <= 1'b1;
	                read_page_counter <= 'd0;                                                              
	              end                                                                                           
	            else if ( init_txn_pulse == 1'b1 && FIFO_MODE)                                                      
	              begin                                                                     
	                exec_read_state  <= R_READING;
	                read_page_counter <= 'd0;                                                              
	              end
	            else if ( init_txn_pulse == 1'b1 && ~FIFO_MODE)                                                      
	              begin                                                                     
	                exec_read_state  <= R_READING;
	                read_page_counter <= 'd0;                                                              
	              end
	            else                                                                                            
	              begin                                                                                         
	                exec_read_state  <= R_IDLE;                                                            
	              end                                                                                                                                                                                    
              R_POLL_ETH:
                begin
	              if (axi_read_done && M_AXI_RDATA[127:103] == 25'h0000003)                                                      
	              begin                                                                     
	                exec_read_state  <= R_READING;
	                start_single_burst_read  <= 1'b0;                                                              
	              end           
	              else if(axi_read_done && M_AXI_RDATA[127:103] != 25'h0000003)                
	              begin                                                                     
	                exec_read_state  <= R_POLL_ETH;
	                start_single_burst_read  <= 1'b1;                                                      
	              end
	              else
	              begin
	                start_single_burst_read  <= 1'b0;
	              end                
                end
	          R_NEGO_ARADDR_AND_READ:
	            if(M_AXI_ARREADY && axi_arvalid)
	            begin
	               exec_read_state <= R_READING;
	               start_overlap_read_address_negotiation <= 1'b0;
	            end	            
	            else
	            begin
	              exec_read_state <= exec_read_state;
                  start_overlap_read_address_negotiation <= 1'b0;            
	            end	                                                                                                            
	          R_READING:	                                                                                                                                                                             
                //全頁を読み終えたときに次の状態に遷移する
	            if (axi_read_done && (read_page_counter == READ_PAGES - 'd1))
	            begin
                    if(INFINITE_MODE & BAR_SWITCH)
                    begin
                        exec_read_state <= R_WAIT_WRITE_BAR;
                        read_page_counter <= 'd0;
                    end
                    else if(INFINITE_MODE)
                    begin
                        exec_read_state <= R_READING;
                        read_page_counter <= 'd0;
                    end
                    else                                                                                 
                      begin                                                                                         
                        exec_read_state <= R_IDLE;                                                             
                      end 
                end                                                                                           
	            else if(axi_read_done && (read_page_counter != READ_PAGES - 'd1))
	            begin
	                read_page_counter <= read_page_counter + 'd1;
	                exec_read_state  <= R_READING;
	            end
	            else if(rid_flags[3:0] != 4'b1111 && axi_read_next && ~M_AXI_RLAST && ~(~INFINITE_MODE && axi_araddr_offset == 'd0))
	            begin
	                exec_read_state  <= R_NEGO_ARADDR_AND_READ;
	                start_overlap_read_address_negotiation <= 1'b1;
	            end	            
	            else                                                                                            
	              begin                                                                                         
	                exec_read_state  <= R_READING;                                                               	                                                                                                            
	                if (~axi_arvalid && ~M_AXI_RVALID && ~start_single_burst_read && rid_flags[3:0] == 4'b0000)                         
	                  begin                                                                                     
	                    start_single_burst_read <= 1'b1;                                                        
	                  end                                                                                       
	               else                                                                                         
	                 begin                                                                                      
	                   start_single_burst_read <= 1'b0; //Negate to generate a pulse                            
	                 end                                                                                        
	              end
            R_WAIT_WRITE_BAR:
              if(M_AXI_BID == {(C_M_AXI_ID_WIDTH){1'b1}} && M_AXI_BVALID && axi_bready)
              begin
	           exec_read_state  <= R_READING;
	          end                                                                                                                                                                                                                                                                                                       
              default :                                                                                         
	            begin
	              start_overlap_read_address_negotiation <= 1'b0;	                                                                                                       
	              exec_read_state  <= R_IDLE;                                                               
	            end                                                                                             
	        endcase                                                                                             
	      end                                                                                                   
	  end //exec_read_state                                                                               


      reg [1:0] prepare_output_ctr;
      reg [1:0] dedup_hit_ctr;
	  always @ ( posedge m128_aclk)                                                                            
	  begin                                                                                                     
	    if (M_AXI_ARESETN == 1'b0 )                                                                             
	      begin                                                                                                 
	        // reset condition                                                                                                                  
            prepare_output_ctr <= 'd0;
	      end                                                                                                   
	    else                                                                                                    
	      begin                                                                                                                                                                                                                                                        
            if(dedup_hit_ctr != 'd0)
            begin
                prepare_output_ctr <= 'd0;
            end
            else if(prepare_output_ctr != 'd0 && (rk_128_0align_hit | rk_128_64align_hit | rk_256_0align_hit | rk_256_64align_hit))
            begin
                prepare_output_ctr <= 'd0;
            end 
            else if(prepare_output_ctr != 'd0)
            begin
                prepare_output_ctr <= prepare_output_ctr + 'd1;
            end
            else if(prepare_output_ctr == 'd0 && key_hit_pulse)
            begin
                prepare_output_ctr <= 2'b01;
            end                                                                                                                                                                                                                                                                                                                                                                                         
	      end                                                                                                   
	  end       

	  always @ ( posedge m128_aclk)                                                                            
	  begin                                                                                                     
	    if (M_AXI_ARESETN == 1'b0 )                                                                             
	      begin                                                                                                 
            dedup_hit_ctr <= 'd0;   
	      end                                                                                                   
	    else                                                                                                    
	      begin                                                                                                                                                                                                                                                                        
            if(prepare_output_ctr !='d0 && (rk_128_0align_hit | rk_128_64align_hit | rk_256_0align_hit | rk_256_64align_hit))
            begin
                dedup_hit_ctr <= 'd1;
            end
            else if(dup_hit)
            begin
                dedup_hit_ctr <= 'd1;
            end
            else if(dedup_hit_ctr != 'd0)
            begin
                dedup_hit_ctr <= dedup_hit_ctr + 'd1;
            end                                                                                                                                                                                                                                                                                                                                                                                        
	      end                                                                                                   
	  end    
	  
	                                                           
	  always @ ( posedge m128_aclk)                                                                            
	  begin                                                                                                     
	    if (M_AXI_ARESETN == 1'b0 )                                                                             
	      begin                                                                                                 
	        // reset condition                                                                                                                  
	        exec_write_state <= W_IDLE;                                                                	                                                                                                                                               
	        packet_no <= 'd0;
	        start_single_burst_write <= 1'b0;
	        bar0adjust <= BAR0L;   
	      end                                                                                                   
	    else                                                                                                    
	      begin                                                                                                 
	        // state transition                                                                                 
	        case (exec_write_state)                                                                                                                                                                          
	          W_IDLE:
	          begin                                                                                                                                                           
	            if ( init_txn_pulse == 1'b1 && FIFO_MODE && ~POLL_ETH_EN)                                                                      
                begin                                                                                        
                    exec_write_state  <= W_ETH_HEADER;
                    start_single_burst_write <= 1'b1;
                end
                else if(FIFO_MODE && exec_read_state == R_POLL_ETH && axi_read_done && M_AXI_RDATA[127:103] == 25'h0000003)
                begin                                                                                        
                    exec_write_state  <= W_ETH_HEADER;
                    start_single_burst_write <= 1'b1;
                end
	            else if(prepare_output_ctr == 2'b11 && no_hit)
	            begin
	                exec_write_state  <= W_KEY_OUTPUT;
	                start_single_burst_write <= 1'b1;
	            end            
	            else if(key_in_page != 'd0 && axi_read_done)
	            begin
	                exec_write_state  <= W_EPILOGUE_TIME;
	                start_single_burst_write <= 1'b1;
	            end
	            else if(exec_read_state == R_WAIT_WRITE_BAR && BAR_SWITCH)
	            begin
	                exec_write_state  <= W_CHANGE_BAR;
	                bar0adjust <= (bar0adjust == BAR0H) ? BAR0L : bar0adjust + 'd1;
	                start_single_burst_write <= 1'b1;
	            end 	                           
	            else
	            begin
	                exec_write_state  <= exec_write_state;
	                start_single_burst_write <= 1'b0;
	            end
	          end                                                                                                                                                                                                                                                                             
              W_ETH_HEADER:
              begin
                if(key_hit != 2'd0 && M_AXI_WREADY && axi_wvalid && axi_wlast)
                begin
                    exec_write_state  <= W_KEY_OUTPUT;
                    start_single_burst_write <= 1'b1;                    
                end                
                else if(M_AXI_WREADY && axi_wvalid && axi_wlast)
                begin
                    exec_write_state  <= W_IDLE;
                    start_single_burst_write <= 1'b0;                    
                end
                else
                begin
                    exec_write_state  <= exec_write_state;
                    start_single_burst_write <= 1'b0;                    
                end
              end	                                                                                                            
	          W_KEY_OUTPUT:                                                                                                                                                                      
                begin
	              if(M_AXI_WREADY && axi_wvalid && axi_wlast && key_in_page != 'd0 && M_AXI_RVALID && axi_rready && M_AXI_RLAST)
	              begin
	                  exec_write_state  <= W_EPILOGUE_TIME;
	                  start_single_burst_write <= 1'b1;
	              end                                 
                  else if(M_AXI_WREADY && axi_wvalid && axi_wlast)
                  begin
                      exec_write_state  <= W_IDLE;
                      start_single_burst_write <= 1'b0;
                  end
                  else if(~axi_awvalid && ~start_single_burst_write)
                  begin
                    exec_write_state  <= exec_write_state;
                    start_single_burst_write <= 1'b0;                    
                  end               
                  else
                  begin
                    exec_write_state  <= exec_write_state;
                    start_single_burst_write <= 1'b0;                    
                  end                      
                end                                                                                           
              W_EPILOGUE_TIME:
                begin
//                  if(M_AXI_BID[1:0] == 2'b01  && M_AXI_BVALID && axi_bready)
                  if(M_AXI_WREADY && axi_wvalid && axi_wlast)
                  begin
                      exec_write_state  <= W_EPILOGUE_TDR;
	                  start_single_burst_write <= 1'b1;
	              end
	              else
                  begin
                      exec_write_state  <= exec_write_state;
	                  start_single_burst_write <= 1'b0;
	              end                                            
                end
              W_EPILOGUE_TDR:
                begin
                  if(M_AXI_WREADY && axi_wvalid && axi_wlast)
                  begin
                      exec_write_state  <= W_EPILOGUE_TLR;
	                  start_single_burst_write <= 1'b1;
	              end
                  else
                  begin
                      exec_write_state  <= exec_write_state;
	                  start_single_burst_write <= 1'b0;
	              end
                end                  	                                                                                                         	                                                                                                                                                                                                       
              W_EPILOGUE_TLR:
                  begin
                    if(M_AXI_WREADY && axi_wvalid && axi_wlast)
//                    if(M_AXI_BID[1:0] == 2'b11  && M_AXI_BVALID && axi_bready)
                    begin
                        packet_no <= packet_no + 16'd1;
                        if((read_page_counter == READ_PAGES - 'd1) && ~INFINITE_MODE)
                        begin
                            exec_write_state  <= W_IDLE;
                            start_single_burst_write <= 1'b0;
                        end
                        else
                        begin
                            exec_write_state  <= W_ETH_HEADER;
	                        start_single_burst_write <= 1'b1;
                        end	                                                    
                    end                                         
                    else                    
                    begin
                        exec_write_state  <= exec_write_state;
                        start_single_burst_write <= 1'b0;
                    end
                  end
              W_CHANGE_BAR:
                begin
                  if(M_AXI_BID == {(C_M_AXI_ID_WIDTH){1'b1}} && M_AXI_BVALID && axi_bready)
                  begin
                      exec_write_state  <= W_IDLE;
	                  start_single_burst_write <= 1'b0;
	              end
                  else
                  begin
                      exec_write_state  <= exec_write_state;
	                  start_single_burst_write <= 1'b0;
	              end                                            
                end                                                                                                                                                                                                                                                                                                                                                            
              default :                                                                                         
	            begin                                                                                           
	              exec_write_state  <= W_IDLE;
	              start_single_burst_write <= 1'b0;                                                               
	            end                                                                                             
	        endcase                                                                                             
	      end                                                                                                   
	  end //MASTER_EXECUTION_PROC                                                                               
	                                                                                                                                                                                                                            
                                                                                                                                                                                                                                                                                          	                                                                                                                                                                                                                                                                               

	// Add user logic here
	
	  always @(posedge m128_aclk)                                                                              
	  begin                                                                                                     
	    if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1)                                                                                 
            key_in_page <= 'd0;                                                                                                                                                                                                                
//	    else if (key_hit[1:0] != 2'b00)
	    else if (exec_write_state  == W_KEY_OUTPUT && M_AXI_AWREADY && axi_awvalid)                                                                       
	        key_in_page <= 1'b1;                                                                            
	    else if (exec_write_state == W_EPILOGUE_TIME)                                                                       
	        key_in_page <= 1'b0;                                                                            
	    else	                                                         
            key_in_page <= key_in_page;                                                                               
	    end  		        


    always @(posedge m128_aclk)                                                                              
    begin                                                                                                     

      if(axi_read_next)
      begin
        //read data
        for (i = 0; i < 15; i = i + 1)
        begin
            read_qword_stage[i] <= read_qword_stage[i + 'd1];
        end
        //byteorder convesion
//        read_qword_stage[15] <= M_AXI_RDATA[127:0];
        read_qword_stage[15] <= {M_AXI_RDATA[63:0],M_AXI_RDATA[127:64]};//axi128 aarc64 16byte alignment
      end
      else
      begin
        //read data
        for (i = 0; i < 16; i = i + 1)
        begin
            read_qword_stage[i] <= read_qword_stage[i];
        end
      end                      
    end


    always @(posedge m128_aclk)                                                                              
    begin                                                                                                     
      if(axi_read_next)
      begin
        //read data
        for (i = 0; i < 16; i = i + 1)
        begin
            read_qword_stage_cmp[i] <= read_qword_stage[i];
        end
        read_qword_stage_cmp[16] <= {M_AXI_RDATA[63:0],M_AXI_RDATA[127:64]};//axi128 aarc64 16byte alignment
      end
      else
      begin
        //read data
        for (i = 0; i < 17; i = i + 1)
        begin
            read_qword_stage_cmp[i] <= read_qword_stage_cmp[i];
        end
      end              
    end       
  


    //AES Key Expansion
    //AES128 Full KeySchedule

    AESKeySchedule128_pipeline AESKeySchedule128_pipeline_inst (
        .clk(m128_aclk),
        .aes_key_initial_value(read_qword_stage[11]),
        .aes_128_key_schedule_1(aes128_key_sche[0]),
        .aes_128_key_schedule_2(aes128_key_sche[1]),
        .aes_128_key_schedule_3(aes128_key_sche[2]),
        .aes_128_key_schedule_4(aes128_key_sche[3]),
        .aes_128_key_schedule_5(aes128_key_sche[4]),
        .aes_128_key_schedule_6(aes128_key_sche[5]),
        .aes_128_key_schedule_7(aes128_key_sche[6]),
        .aes_128_key_schedule_8(aes128_key_sche[7]),
        .aes_128_key_schedule_9(aes128_key_sche[8]),
        .aes_128_key_schedule_10(aes128_key_sche[9])
    );

            

    AESKeySchedule256_pipeline AESKeySchedule256_pipeline_inst (
        .clk(m256_aclk),
        .aes_key_initial_value_hi(read_qword_stage[14]),
        .aes_key_initial_value_lo(read_qword_stage[15]),
        .aes_256_key_schedule_1(aes256_key_sche[0]),
        .aes_256_key_schedule_2(aes256_key_sche[1]),
        .aes_256_key_schedule_3(aes256_key_sche[2]),
        .aes_256_key_schedule_4(aes256_key_sche[3]),
        .aes_256_key_schedule_5(aes256_key_sche[4]),
        .aes_256_key_schedule_6(aes256_key_sche[5]),
        .aes_256_key_schedule_7(aes256_key_sche[6]),
        .aes_256_key_schedule_8(aes256_key_sche[7]),
        .aes_256_key_schedule_9(aes256_key_sche[8]),
        .aes_256_key_schedule_10(aes256_key_sche[9]),
        .aes_256_key_schedule_11(aes256_key_sche[10]),
        .aes_256_key_schedule_12(aes256_key_sche[11]),
        .aes_256_key_schedule_13(aes256_key_sche[12])
    );

//if(C_AESKEYFINDER_ALIGN64_ENABLE == 1)
//begin

    AESKeySchedule128_pipeline AESKeySchedule128_64align_pipeline_inst (
        .clk(m128_aclk),
//        .aes_key_initial_value({read_qword_stage[10][127:64],read_qword_stage[11][63:0]}),//入力の8バイト単位は合う
//        .aes_key_initial_value({read_qword_stage[11][63:0],read_qword_stage[10][127:64]}),//これはだめ
//        .aes_key_initial_value({read_qword_stage[11][127:64],read_qword_stage[10][63:0]}),//入力の8バイト単位は合う
        .aes_key_initial_value({read_qword_stage[11][63:0],read_qword_stage[12][127:64]}),//あたり！

        .aes_128_key_schedule_1(aes128_64align_key_sche[0]),
        .aes_128_key_schedule_2(aes128_64align_key_sche[1]),
        .aes_128_key_schedule_3(aes128_64align_key_sche[2]),
        .aes_128_key_schedule_4(aes128_64align_key_sche[3]),
        .aes_128_key_schedule_5(aes128_64align_key_sche[4]),
        .aes_128_key_schedule_6(aes128_64align_key_sche[5]),
        .aes_128_key_schedule_7(aes128_64align_key_sche[6]),
        .aes_128_key_schedule_8(aes128_64align_key_sche[7]),
        .aes_128_key_schedule_9(aes128_64align_key_sche[8]),
        .aes_128_key_schedule_10(aes128_64align_key_sche[9])
    );
    
    
    AESKeySchedule256_pipeline AESKeySchedule256_64align_pipeline_inst (
        .clk(m256_aclk),
//        .aes_key_initial_value({read_qword_stage[10][127:64],read_qword_stage[11][63:0]}),//入力の8バイト単位は合う
//        .aes_key_initial_value({read_qword_stage[11][63:0],read_qword_stage[10][127:64]}),//これはだめ
//        .aes_key_initial_value({read_qword_stage[11][127:64],read_qword_stage[10][63:0]}),//入力の8バイト単位は合う
//        .aes_key_initial_value({read_qword_stage[10][63:0],read_qword_stage[11][127:64]}),//あたり！
        .aes_key_initial_value_hi({read_qword_stage[13][63:0],read_qword_stage[14][127:64]}),
        .aes_key_initial_value_lo({read_qword_stage[14][63:0],read_qword_stage[15][127:64]}),
        
        .aes_256_key_schedule_1(aes256_64align_key_sche[0]),
        .aes_256_key_schedule_2(aes256_64align_key_sche[1]),
        .aes_256_key_schedule_3(aes256_64align_key_sche[2]),
        .aes_256_key_schedule_4(aes256_64align_key_sche[3]),
        .aes_256_key_schedule_5(aes256_64align_key_sche[4]),
        .aes_256_key_schedule_6(aes256_64align_key_sche[5]),
        .aes_256_key_schedule_7(aes256_64align_key_sche[6]),
        .aes_256_key_schedule_8(aes256_64align_key_sche[7]),
        .aes_256_key_schedule_9(aes256_64align_key_sche[8]),
        .aes_256_key_schedule_10(aes256_64align_key_sche[9]),
        .aes_256_key_schedule_11(aes256_64align_key_sche[10]),
        .aes_256_key_schedule_12(aes256_64align_key_sche[11]),
        .aes_256_key_schedule_13(aes256_64align_key_sche[12])
    );
//end
        
    always @(posedge m128_aclk)                                                                              
    begin                                                                                                     
        //read data
        for (i = 0; i < 10; i = i + 1)
        begin
            aes128_64align_key_sche_stage_cmp[i] <= aes128_64align_key_sche[i];            
        end        
    end

    always @(posedge m128_aclk)                                                                              
    begin                                                                                                     
        //read data
        for (i = 0; i < 13; i = i + 1)
        begin
            aes256_64align_key_sche_stage_cmp[i] <= aes256_64align_key_sche[i];            
        end        
    end
       
    always @(posedge m128_aclk)                                                                              
    begin                                                                                                     
        //read data
        for (i = 0; i < 10; i = i + 1)
        begin
            aes128_key_sche_stage_cmp[i] <= aes128_key_sche[i];            
        end        
    end
    
    always @(posedge m128_aclk)                                                                              
    begin                                                                                                     
        //read data
        for (i = 0; i < 13; i = i + 1)
        begin
            aes256_key_sche_stage_cmp[i] <= aes256_key_sche[i];            
        end        
    end
            
    genvar gen_i;
    genvar gen_j;
    wire [14:0] compare_results_128 [9:0];    
    generate                      
    for (gen_i = 0; gen_i < 10; gen_i = gen_i + 'd1)
    begin: compare_aes128_parallel_block
        for (gen_j = 0; gen_j < 15; gen_j = gen_j + 'd1)
        begin
            compare_128bit_DSP # (
                .GENERATE_NUM(gen_i * 10 + gen_j)
                )compare_128bit_parallel_fast_inst(
                .clk(m128_aclk),
                .a(aes128_key_sche_stage_cmp[gen_i]),
                .b(read_qword_stage_cmp[gen_j+2]),
                .equal(compare_results_128[gen_i][gen_j])
                );
        end                                   
    end
    endgenerate

    wire [13:0] compare_results_256 [12:0];    
    generate                      
    for (gen_i = 0; gen_i < 13; gen_i = gen_i + 'd1)
    begin: compare_aes256_parallel_block
        for (gen_j = 0; gen_j < 14; gen_j = gen_j + 'd1)
        begin
            compare_128bit_DSP # (
                .GENERATE_NUM(gen_i * 10 + gen_j + 150)
                ) compare_128bit_parallel_fast_inst(
                .clk(m256_aclk),
                .a(aes256_key_sche_stage_cmp[gen_i]),
                .b(read_qword_stage_cmp[gen_j+3]),
                .equal(compare_results_256[gen_i][gen_j])
                );
        end                                   
    end
    endgenerate    

    wire [13:0] compare_results_128_64align [9:0];    
    generate                      
    for (gen_i = 0; gen_i < 10; gen_i = gen_i + 'd1)
    begin: compare_aes128_64align_parallel_block
        for (gen_j = 0; gen_j < 14; gen_j = gen_j + 'd1)
        begin
            compare_128bit_DSP # (
                .GENERATE_NUM(gen_i * 10 + gen_j + 332)
                )compare_128bit_parallel_fast_inst(
                .clk(m128_aclk),
                .a(aes128_64align_key_sche_stage_cmp[gen_i]),
                .b({read_qword_stage_cmp[gen_j+2][63:0],read_qword_stage_cmp[gen_j+3][127:64]}),
                .equal(compare_results_128_64align[gen_i][gen_j])
                );
        end                                   
    end
    endgenerate    
    
    wire [13:0] compare_results_256_64align [12:0];    
    generate                      
    for (gen_i = 0; gen_i < 13; gen_i = gen_i + 'd1)
    begin: compare_aes256_64align_parallel_block
        for (gen_j = 0; gen_j < 14; gen_j = gen_j + 'd1)
        begin
            compare_128bit_DSP # (
                .GENERATE_NUM(gen_i * 10 + gen_j + 472)
                )compare_128bit_parallel_fast_inst(
                .clk(m256_aclk),
                .a(aes256_64align_key_sche_stage_cmp[gen_i]),
                .b({read_qword_stage_cmp[gen_j+2][63:0],read_qword_stage_cmp[gen_j+3][127:64]}),
                .equal(compare_results_256_64align[gen_i][gen_j])
                );
        end                                   
    end
    endgenerate
    
    reg rsa_cmp_result_128align;
    reg rsa_cmp_result_64align;
    assign key_hit_rsa_128align = rsa_cmp_result_128align;
    assign key_hit_rsa_64align = rsa_cmp_result_64align;
    
    always @(posedge m128_aclk)
    begin
        if (key_hit_en == 1'b0)
            rsa_cmp_result_128align <= 0;
        else if({read_qword_stage_cmp[0][127:96],read_qword_stage_cmp[0][79:64]} == 48'h02000102_8230 && axi_read_next)
            rsa_cmp_result_128align <= 1;
        else
            rsa_cmp_result_128align <= 0;                
    end
    
    always @(posedge m128_aclk)
    begin
        if (key_hit_en == 1'b0)
            rsa_cmp_result_64align <= 0;
        else if({read_qword_stage_cmp[0][63:32],read_qword_stage_cmp[0][15:0]} == 48'h02000102_8230  && axi_read_next)
            rsa_cmp_result_64align <= 1;
        else
            rsa_cmp_result_64align <= 0;                
    end

    reg ecdsa_cmp_result_128align;
    reg ecdsa_cmp_result_64align;
    assign key_hit_ecdsa_128align = ecdsa_cmp_result_128align;
    assign key_hit_ecdsa_64align = ecdsa_cmp_result_64align;
    
    always @(posedge m128_aclk)
    begin
        if (key_hit_en == 1'b0)
            ecdsa_cmp_result_128align <= 0;
        else if({read_qword_stage_cmp[0][111:80],read_qword_stage_cmp[0][71:64]} == 40'h04010102_30 && axi_read_next)
            ecdsa_cmp_result_128align <= 1;
        else
            ecdsa_cmp_result_128align <= 0;                
    end
    
    always @(posedge m128_aclk)
    begin
        if (key_hit_en == 1'b0)
            ecdsa_cmp_result_64align <= 0;
        else if({read_qword_stage_cmp[0][47:16],read_qword_stage_cmp[0][7:0]} == 40'h04010102_30  && axi_read_next)
            ecdsa_cmp_result_64align <= 1;
        else
            ecdsa_cmp_result_64align <= 0;                
    end


    reg pkcs8_cmp_result_128align;
    reg pkcs8_cmp_result_64align;
    assign key_hit_pkcs8_128align = pkcs8_cmp_result_128align;
    assign key_hit_pkcs8_64align = pkcs8_cmp_result_64align;
    
    always @(posedge m128_aclk)
    begin
        if (key_hit_en == 1'b0)
            pkcs8_cmp_result_128align <= 0;
        else if({read_qword_stage_cmp[0][127:96],read_qword_stage_cmp[0][79:64]} == 48'h30000102_8230 && axi_read_next)
            pkcs8_cmp_result_128align <= 1;
        else
            pkcs8_cmp_result_128align <= 0;                
    end
    
    always @(posedge m128_aclk)
    begin
        if (key_hit_en == 1'b0)
            pkcs8_cmp_result_64align <= 0;
        else if({read_qword_stage_cmp[0][63:32],read_qword_stage_cmp[0][15:0]} == 48'h30000102_8230  && axi_read_next)
            pkcs8_cmp_result_64align <= 1;
        else
            pkcs8_cmp_result_64align <= 0;                
    end

              
    reg [14:0] round_key_128_cmp_result [9:0];    
    reg [13:0] round_key_256_cmp_result [12:0];
    reg [13:0] round_key_128_64align_cmp_result [9:0];
    reg [13:0] round_key_256_64align_cmp_result [12:0];
            
    //Compare Stage
    always @(posedge m128_aclk)                                                                              
    begin                                                                                                     
      if (key_hit_en == 1'b0)
      begin //reset
        for (i = 0; i < 10; i = i + 'd1)
        begin
            round_key_128_cmp_result[i] <= 'd0;
        end            
      end        
      else
      begin        
        //test read_qword_stage is keyshcedule                      
        for (i = 0; i < 10; i = i + 'd1)
        begin
            for (j = 0; j < 15; j = j + 'd1)
            begin
                round_key_128_cmp_result[i][j] <= compare_results_128[i][j];
            end                                   
        end        
      end
    end

    //Compare Stage
    always @(posedge m256_aclk)                                                                              
    begin                                                                                                     
      if (key_hit_en == 1'b0)
      begin //reset
        for (i = 0; i < 13; i = i + 'd1)
        begin
            round_key_256_cmp_result[i] <= 'd0;
        end            
      end        
      else
      begin        
        //test read_qword_stage is keyshcedule                                  
        for (i = 0; i < 13; i = i + 'd1)
        begin
            for (j = 0; j < 14; j = j + 'd1)
            begin
                round_key_256_cmp_result[i][j] <= compare_results_256[i][j];
            end                                   
        end
      end
    end

        
    //Compare Stage
    always @(posedge m128_aclk)                                                                              
    begin                                                                                                     
      if (key_hit_en == 1'b0)
      begin //reset
        for (i = 0; i < 10; i = i + 'd1)
        begin
            round_key_128_64align_cmp_result[i] <= 'd0;
        end            
      end        
      else
      begin        
        //test read_qword_stage is keyshcedule                      
        for (i = 0; i < 10; i = i + 'd1)
        begin
            for (j = 0; j < 14; j = j + 'd1)
            begin
                round_key_128_64align_cmp_result[i][j] <= compare_results_128_64align[i][j];
            end                                   
        end        
      end
    end

        
    //Compare Stage
    always @(posedge m256_aclk)                                                                              
    begin                                                                                                     
      if (key_hit_en == 1'b0)
      begin //reset
        for (i = 0; i < 13; i = i + 'd1)
        begin
            round_key_256_64align_cmp_result[i] <= 'd0;
        end            
      end        
      else
      begin        
        //test read_qword_stage is keyshcedule                      
        for (i = 0; i < 13; i = i + 'd1)
        begin
            for (j = 0; j < 14; j = j + 'd1)
            begin
                round_key_256_64align_cmp_result[i][j] <= compare_results_256_64align[i][j];
            end                                   
        end        
      end
    end
        
    //比較結果の集約

    always @(posedge m128_aclk)                                                                              
    begin                                                                                                     
//      if (key_hit_en == 1'b0 || round_key_bitmap128 != 'd0 || round_key_bitmap128_64align != 'd0 || round_key_bitmap256 != 'd0 || round_key_bitmap256_64align != 'd0)
//1サイクルおきにデータが止まる読み込みのときに2サイクル以上round_key_bitmapが非ゼロにならないようにする必要がある
      if (key_hit_en == 1'b0 || axi_read_next == 1'b0)
//      if (key_hit_en == 1'b0)
      begin
        round_key_bitmap128 <= 'd0;
        round_key_bitmap128_64align <= 'd0;
        round_key_bitmap256 <= 'd0;
        round_key_bitmap256_64align <= 'd0;
      end        
      else
      begin                                
        for (i = 0; i < 10; i = i + 'd1)
        begin
            round_key_bitmap128[i] <= (round_key_128_cmp_result[i] != 'd0);
            round_key_bitmap128_64align[i] <= (round_key_128_64align_cmp_result[i] != 'd0);                                   
        end
        for (i = 0; i < 13; i = i + 'd1)
        begin
            round_key_bitmap256[i] <= (round_key_256_cmp_result[i] != 'd0);
            round_key_bitmap256_64align[i] <= (round_key_256_64align_cmp_result[i] != 'd0);
        end
      end
    end

    

    always @(posedge m128_aclk)                                                                              
    begin                                                                                                     
        cand_key_hold_stage[0] <= read_qword_stage_cmp[0];
        cand_key_hold_stage[1] <= read_qword_stage_cmp[1];
        cand_key_hold_stage[2] <= read_qword_stage_cmp[2];
    end

    reg [127:0] cand_key_hold_stage2 [2:0];
    always @(posedge m128_aclk)                                                                              
    begin                                                                                                     
        cand_key_hold_stage2[0] <= cand_key_hold_stage[0];
        cand_key_hold_stage2[1] <= cand_key_hold_stage[1];
        cand_key_hold_stage2[2] <= cand_key_hold_stage[2];
    end


    reg [127:0] cand_key_hold_stage3 [2:0];
    always @(posedge m128_aclk)                                                                              
    begin                                                                                    
        cand_key_hold_stage3[0] <= cand_key_hold_stage2[0];
        cand_key_hold_stage3[1] <= cand_key_hold_stage2[1];
        cand_key_hold_stage3[2] <= cand_key_hold_stage2[2];
    end

    always @(posedge m128_aclk)                                                                              
    begin                                                                                                     
      if(key_hit_128align)
      begin
        key_output_stage[0] <= cand_key_hold_stage3[0];
        key_output_stage[1] <= cand_key_hold_stage3[1];
      end
      else if(key_hit_64align)
      begin
        key_output_stage[0] <= {cand_key_hold_stage3[0][63:0],cand_key_hold_stage3[1][127:64]};
        key_output_stage[1] <= {cand_key_hold_stage3[1][63:0],cand_key_hold_stage3[2][127:64]};
      end
      else if(key_hit_rsa_128align | key_hit_ecdsa_128align | key_hit_pkcs8_128align)
      begin
        key_output_stage[0] <= cand_key_hold_stage[0];
        key_output_stage[1] <= cand_key_hold_stage[1];
      end
      else if(key_hit_rsa_64align | key_hit_ecdsa_64align | key_hit_pkcs8_64align)
      begin
        key_output_stage[0] <= {cand_key_hold_stage[0][63:0],cand_key_hold_stage[1][127:64]};
        key_output_stage[1] <= {cand_key_hold_stage[1][63:0],cand_key_hold_stage[2][127:64]};
      end
      else
      begin
        key_output_stage[0] <= key_output_stage[0];
        key_output_stage[1] <= key_output_stage[1];      
      end
    end



    always @(posedge m128_aclk)                                                                              
    begin                                                                                                     
      if (M_AXI_ARESETN == 1'b0 || init_txn_pulse == 1'b1)
      begin //reset
        key_hit <= 'd0;
      end   
      //test round key bitamap                          
      else if(key_hit_128 && key_hit_en)
      begin
            key_hit <= 'd1;
      end        
      else if(key_hit_256 && key_hit_en)
      begin
            key_hit <= 'd3;
      end                       
      else if(key_hit_rsa_128align && key_hit_en)
      begin
            key_hit <= 'd4;
      end
      else if(key_hit_rsa_64align && key_hit_en)
      begin
            key_hit <= 'd4;
      end
      else if(key_hit_ecdsa_128align && key_hit_en)
      begin
            key_hit <= 'd5;
      end
      else if(key_hit_ecdsa_64align && key_hit_en)
      begin
            key_hit <= 'd5;
      end
      else if(key_hit_pkcs8_128align && key_hit_en)
      begin
            key_hit <= 'd6;
      end
      else if(key_hit_pkcs8_64align && key_hit_en)
      begin
            key_hit <= 'd6;
      end
      else if(exec_write_state == W_KEY_OUTPUT && M_AXI_WREADY && axi_wvalid && axi_wlast)
      begin
            key_hit <= 2'd0;    
      end
      else
      begin
            key_hit <= key_hit;
      end
    end

    always @(posedge m128_aclk)                                                                              
    begin                                                                                                     
      if (M_AXI_ARESETN == 1'b0 || (read_page_counter == 'd0 && read_index<='d18) || (prepare_output_ctr == 2'b11 && no_hit))
      begin //reset
        key_hit_en <= 1'b0;
      end   
      else if(exec_read_state != R_IDLE && exec_write_state != W_KEY_OUTPUT)
      begin
        key_hit_en <= 1'b1;
      end
      else
      begin
            key_hit_en <= key_hit_en;
      end
    end
    
    always @(posedge m128_aclk)                                                                              
    begin
        if(key_hit_pulse && key_hit_en)
        begin                                                                                                    
            if(rk_128_0align_hit) key_round_bitmap <= {5'd0, round_key_bitmap128,1'b1};
            else if(rk_256_0align_hit) key_round_bitmap <= {1'd0,round_key_bitmap256,2'b11};                                   
            else if(rk_128_64align_hit) key_round_bitmap <= {5'd0, round_key_bitmap128_64align,1'b1};
            else if(rk_256_64align_hit) key_round_bitmap <= {1'd0,round_key_bitmap256_64align,2'b11};
            else if(key_hit_rsa_128align) key_round_bitmap <= cand_key_hold_stage[0][95:80];
            else if(key_hit_rsa_64align) key_round_bitmap <= cand_key_hold_stage[0][31:16];
            else if(key_hit_ecdsa_128align) key_round_bitmap <= {8'd0,cand_key_hold_stage[0][79:72]};
            else if(key_hit_ecdsa_64align) key_round_bitmap <= {8'd0,cand_key_hold_stage[0][15:8]};                                                       
            else if(key_hit_pkcs8_128align) key_round_bitmap <= cand_key_hold_stage[0][95:80];
            else if(key_hit_pkcs8_64align) key_round_bitmap <= cand_key_hold_stage[0][31:16];
        end
        else key_round_bitmap <= key_round_bitmap;
    end



    always @(posedge m128_aclk)                                                                              
    begin                                                                                                     

      if(key_hit_128align)
      begin                                   
//        key_addr <= TARGET_READ_ADDR + {read_page_counter,12'd0} + {read_index[7:0],4'h0} - 'h130;
        key_addr <= TARGET_READ_ADDR + {read_page_counter,12'd0} + {read_index[7:0],4'h0} - 'h140;
//        key_addr <= TARGET_READ_ADDR + {read_page_counter,12'd0} + {read_index[7:0],4'h0} - 'h70;               
      end
      else if(key_hit_64align)
      begin                                   
//        key_addr <= TARGET_READ_ADDR + {read_page_counter,12'd0} + {read_index[7:0],4'h0} - 'h128;
        key_addr <= TARGET_READ_ADDR + {read_page_counter,12'd0} + {read_index[7:0],4'h0} - 'h138;
//        key_addr <= TARGET_READ_ADDR + {read_page_counter,12'd0} + {read_index[7:0],4'h0} - 'h68;               
      end
      else if(key_hit_rsa_128align | key_hit_ecdsa_128align | key_hit_pkcs8_128align)
      begin                                   
//        key_addr <= TARGET_READ_ADDR + {read_page_counter,12'd0} + {read_index[7:0],4'h0} - 'h130;
        key_addr <= TARGET_READ_ADDR + {read_page_counter,12'd0} + {read_index[7:0],4'h0} - 'h120;
//        key_addr <= TARGET_READ_ADDR + {read_page_counter,12'd0} + {read_index[7:0],4'h0} - 'h70;               
      end      
      else if(key_hit_rsa_64align | key_hit_ecdsa_64align | key_hit_pkcs8_64align)
      begin                                   
//        key_addr <= TARGET_READ_ADDR + {read_page_counter,12'd0} + {read_index[7:0],4'h0} - 'h130;
        key_addr <= TARGET_READ_ADDR + {read_page_counter,12'd0} + {read_index[7:0],4'h0} - 'h118;
//        key_addr <= TARGET_READ_ADDR + {read_page_counter,12'd0} + {read_index[7:0],4'h0} - 'h70;               
      end
      else
      begin
        key_addr <= key_addr;
      end
    end


    always @(posedge m128_aclk)                                                                              
    begin                                                                                                     
      if (M_AXI_ARESETN == 1'b0 || init_txn_pulse == 1'b1)
      begin //reset
        laps_ctr <= 'd0;
      end        
      else if(read_page_counter == READ_PAGES - 'd1 && axi_read_done)
      begin
        laps_ctr <= laps_ctr + 'd1;            
      end
      else
      begin
        laps_ctr <= laps_ctr;
      end
    end




    always @(posedge m128_aclk)                                                                              
    begin                                                                                                     
      if (M_AXI_ARESETN == 1'b0 || init_txn_pulse == 1'b1)
      begin //reset
        hit_ctr <= 'd0;
      end        
      else if(key_hit_128 | key_hit_256)
      begin
        hit_ctr <= hit_ctr + 8'd1;            
      end
      else
      begin
        hit_ctr <= hit_ctr;
      end
    end

    
    always @(posedge m128_aclk)                                                                              
    begin                                                                                                     
      if (init_txn_pulse == 1'b1)
      begin //reset
        awlen <= 8'd0;    
      end        

      else if(exec_write_state == W_KEY_OUTPUT && start_single_burst_write)
      begin        
        //test round key bitamap                          
        if(key_hit == 'd1)
        begin
            awlen <= 8'h01;
        end        
        else if(key_hit == 'd3)
        begin                                   
            awlen <= 8'h02;
        end                       
        else if(key_hit == 'd4)
        begin                                   
            awlen <= 8'h02;
        end
        else if(key_hit == 'd5)
        begin                                   
            awlen <= 8'h02;
        end
        else if(key_hit == 'd6)
        begin                                   
            awlen <= 8'h02;
        end
      end
      else if(exec_write_state == W_ETH_HEADER && start_single_burst_write)
      begin
            awlen <= 8'h00; 
      end     
      else if(exec_write_state == W_EPILOGUE_TIME && start_single_burst_write)
      begin
            awlen <= 8'h00;
      end    
      else if(exec_write_state == W_EPILOGUE_TDR && start_single_burst_write)
      begin
            awlen <= 8'h00;
      end
      else if(exec_write_state == W_EPILOGUE_TLR && start_single_burst_write)
      begin
            awlen <= 8'h00;
      end      
      else if(exec_write_state == W_KEY_OUTPUT && M_AXI_WREADY & axi_wvalid & axi_wlast)
      begin
            awlen <= 8'h00;  
      end
      else begin
            awlen <= awlen;
      end
    end

    always @(posedge m128_aclk)                                                                              
    begin                                                                                                     

      if(exec_write_state == W_ETH_HEADER && M_AXI_AWREADY && axi_awvalid)
      begin
            packet_words <= 10'd4; 
      end  
      else if(exec_write_state == W_KEY_OUTPUT && M_AXI_AWREADY && axi_awvalid)
      begin
        case(key_hit)
            'd1:
                packet_words <= packet_words + 10'd8;
            'd3:
                packet_words <= packet_words + 10'd12;
            'd4:
                packet_words <= packet_words + 10'd12;
            'd5:
                packet_words <= packet_words + 10'd12;                
            'd6:
                packet_words <= packet_words + 10'd12;
            default:
                packet_words <= 'd0;                
        endcase                                 
      end           
      else if(exec_write_state == W_EPILOGUE_TIME && M_AXI_AWREADY && axi_awvalid)
      begin
            packet_words <= packet_words + 10'd4;
      end
      else if(exec_write_state == W_EPILOGUE_TLR && M_AXI_WREADY & axi_wvalid & axi_wlast)
      begin
            packet_words <= packet_words + 'd0;
      end          
      else begin
            packet_words <= packet_words;
      end
    end
   
    
	// User logic ends
	
    function [C_M_AXI_DATA_WIDTH:0] little2net;
    input [C_M_AXI_DATA_WIDTH:0] in;
    begin    
        for (i = 0; i < C_M_AXI_DATA_WIDTH/8; i = i + 1)begin
            little2net[i*8+:8]=in[C_M_AXI_DATA_WIDTH-i*8-1-:8];
        end
    end
    endfunction
    
endmodule