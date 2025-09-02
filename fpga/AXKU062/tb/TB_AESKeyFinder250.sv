`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/19/2024 06:59:05 PM
// Design Name: 
// Module Name: TB_AESKeyFinder250
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
import axi_vip_pkg::*;
import design_2_axi_vip_0_0_pkg::*;
import design_2_axi_vip_1_0_pkg::*;

module TB_AESKeyFinder250;
    
    reg tb_ACLK;
    reg tb_CLK_200MHz;
    reg tb_ARESETn;
   
    wire temp_clk;
    wire temp_rstn;
    reg resp;
    reg [31:0] read_data;
        
    
    initial 
    begin       
        tb_ACLK = 1'b0;
        tb_CLK_200MHz = 1'b0;
    end    

    always #5ns tb_ACLK = !tb_ACLK;
    always #2.5ns tb_CLK_200MHz = !tb_CLK_200MHz;

    // VIP decreation
    design_2_axi_vip_0_0_mst_t   mst_agent;
    design_2_axi_vip_1_0_slv_mem_t slv_mem_agent;
    axi_ready_gen wready_gen;
    
    initial
    begin    

        tb_ARESETn = 1'b0;
        repeat(20)@(posedge tb_ACLK);        
        tb_ARESETn = 1'b1;
//        @(posedge tb_ACLK);        
//        repeat(5) @(posedge tb_ACLK);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.read_data(32'hA000000C,4, read_data, resp);        
        $display ("%t, running the testbench, data read from PL Ethernet 32'h%x",$time, read_data);


        mst_agent = new("master vip agent",dut.design_2_i.axi_vip_0.inst.IF);
        //slv_agent = new("slave vip agent",dut.design_2_i.axi_vip_1.inst.IF);
        //slv_agent.set_verbosity(400);
        
        
        slv_mem_agent = new("slave vip mem agent",dut.design_2_i.axi_vip_1.inst.IF);
        slv_mem_agent.set_agent_tag("My Slave VIP");
        slv_mem_agent.set_verbosity(0);
        
        
        $display("start master.");
        mst_agent.start_master();
        $display("start slave.");
        //slv_agent.start_slave();  
        
        
        //axi_vip_0_mem_stimulus.svhを参考にする              
        slv_mem_agent.start_slave();
        slv_mem_agent.mem_model.set_memory_fill_policy(XIL_AXI_MEMORY_FILL_FIXED);
//        slv_mem_agent.mem_model.set_default_memory_value(32'haddedace);
        slv_mem_agent.mem_model.set_default_memory_value(32'h00000000);
        //slv_mem_agent.mem_model.set_memory_fill_policy(XIL_AXI_MEMORY_FILL_RANDOM);

//        slv_mem_agent.mem_model.pre_load_mem("/home/sawa/AXKU062/AXKU062_Periodic-KeyFinder/bit/14L/combined_meminit.bin",40'h0100004000);
        slv_mem_agent.mem_model.pre_load_mem("/home/sawa/AXKU062/AXKU062_Periodic-KeyFinder/bit/14L/meminit.bin",40'h0100003680);
//        slv_mem_agent.mem_model.pre_load_mem("/home/sawa/AXKU062/AXKU062_Periodic-KeyFinder/bit/14L/meminit_3B46_AD8B_A59A_F205_1E6D_996F_000D_10B9.bin",40'h0100003000);
//        slv_mem_agent.mem_model.get_inter_beat_gap_delay_policy();
        slv_mem_agent.mem_model.set_inter_beat_gap_delay_policy(XIL_AXI_MEMORY_DELAY_RANDOM);
        slv_mem_agent.mem_model.set_inter_beat_gap_range(0,2);
        slv_mem_agent.mem_model.set_bresp_delay(10);
        
        
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.pre_load_mem(2'b01, 32'h00000000,'d16777216);
        
//  	    TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.por_srstb_reset(1'b1);
//        #100;
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.por_srstb_reset(1'b0);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.fpga_soft_reset(32'h1);
//        #1000 ;  // This delay depends on your clock frequency. It should be at least 16 clock cycles. 
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.por_srstb_reset(1'b1);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.fpga_soft_reset(32'h0);
//		//#2000 ;
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.read_data(32'hA000000C,4, read_data, resp);        
        $display ("%t, running the testbench, data read from PL Ethernet 32'h%x",$time, read_data);

//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.set_slave_profile("ALL", 2'b11);

            //ILA captured data//AES128 openssh+openssl
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'he59c15798eae746d_f8bed8dc3661e86a,32'h00002200, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h13348ffaf6a89a83_7806eeee80b83632,32'h00002210, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h305fd5d4236b5a2e_d5c3c0adadc52e43,32'h00002220, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h2336ae1313697bc7_300221e9e5c1e144,32'h00002230, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h98ba1095bb8cbe86_a8e5c54198e7e4a8,32'h00002240, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h39727b20a1c86bb5_1a44d533b2a11072,32'h00002250, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h874d95d5be3feef5_1ff7854005b35073,32'h00002260, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h20214d79a76cd8ac_1953365906a4b319,32'h00002270, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h2e0dedf60e2ca08f_a9407823b0134e7a,32'h00002280, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h7b43ac6e554e4198_5b62e117f2229934,32'h00002290, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h186c8f72632f231c_366162846d038393,32'h000022A0, 'd16);

        
        
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h0f0e0d0c0b0a0908_0706050403020100, 32'h00003f10, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h1f1e1d1c1b1a1918_1716151413121110, 32'h00003f20, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h9cc072a593ce7fa9_98c476a19fc273a5, 32'h00003f30, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'hdeba4006c1a45d1a_dabe4402cda85116, 32'h00003f40, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h6715fc03fbd58ea6_681bf10ff0df87ae, 32'h00003f50, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h8d51b87353ebf875_924fa56f48f1e16d, 32'h00003f60, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h8b59d56cec4c296f_1799a7c97f8256c6, 32'h00003f70, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h39cf0754b49ebf27_e7754752753ae23d, 32'h00003f80, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h2f1c87c1a44552ad_48097bc25f90dc0b, 32'h00003f90, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h0a820a64334d0d30_87d3b21760a6f545, 32'h00003fa0, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'hdfa761d2f0bbe613_54feb4be1cf7cf7c, 32'h00003fb0, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h40e6afb34a64a5d7_7929a8e7fefa1af0, 32'h00003fc0, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h0a1c725ad5bb1388_2500f59b71fe4125, 32'h00003fd0, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'heacdf8cdaa2b577e_e04ff2a999665a4e, 32'h00003fe0, 'd16);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_mem(128'h36de686d3cc21a37_e97909bfcc79fc24, 32'h00003ff0, 'd16);



slv_mem_agent.mem_model.backdoor_memory_write(40'h0100001300, {convert_to_little_endian(128'h1f352c073b6108d7_2d9810a30914dff4), convert_to_little_endian(128'h603deb1015ca71be_2b73aef0857d7781)}, 32'hFFFFFFFF);
slv_mem_agent.mem_model.backdoor_memory_write(40'h0100001320, {convert_to_little_endian(128'ha8b09c1a93d194cd_be49846eb75d5b9a), convert_to_little_endian(128'h9ba354118e6925af_a51a8b5f2067fcde)}, 32'hFFFFFFFF);
slv_mem_agent.mem_model.backdoor_memory_write(40'h0100001340, {convert_to_little_endian(128'hb5a9328a2678a647_983122292f6c79b3), convert_to_little_endian(128'hd59aecb85bf3c917_fee94248de8ebe96)}, 32'hFFFFFFFF);
slv_mem_agent.mem_model.backdoor_memory_write(40'h0100001360, {convert_to_little_endian(128'h98c5bfc9bebd198e_268c3ba709e04214), convert_to_little_endian(128'h812c81addadf48ba_24360af2fab8b464)}, 32'hFFFFFFFF);
slv_mem_agent.mem_model.backdoor_memory_write(40'h0100001380, {convert_to_little_endian(128'hc814e20476a9fb8a_5025c02d59c58239), convert_to_little_endian(128'h68007bacb2df3316_96e939e46c518d80)}, 32'hFFFFFFFF);
slv_mem_agent.mem_model.backdoor_memory_write(40'h01000013A0, {convert_to_little_endian(128'h5886ca5d2e2f31d7_7e0af1fa27cf73c3), convert_to_little_endian(128'hde1369676ccc5a71_fa2563959674ee15)}, 32'hFFFFFFFF);
slv_mem_agent.mem_model.backdoor_memory_write(40'h01000013C0, {convert_to_little_endian(128'hcafaaae3e4d59b34_9adf6acebd10190d), convert_to_little_endian(128'h749c47ab18501dda_e2757e4f7401905a)}, 32'hFFFFFFFF);
slv_mem_agent.mem_model.backdoor_memory_write(40'h01000013E0, {convert_to_little_endian(128'h0000000000000000_0000000000000000), convert_to_little_endian(128'hfe4890d1e6188d0b_046df344706c631e)}, 32'hFFFFFFFF);


        //FIPS Test Vector AES256//Little Endian       
//        slv_mem_agent.mem_model.backdoor_memory_write(40'h0100001300, convert_to_little_endian(128'h603deb1015ca71be_2b73aef0857d7781), 16'hFFFF);
//        slv_mem_agent.mem_model.backdoor_memory_write(40'h0100001310, convert_to_little_endian(128'h1f352c073b6108d7_2d9810a30914dff4), 16'hFFFF);
//        slv_mem_agent.mem_model.backdoor_memory_write(40'h0100001320, convert_to_little_endian(128'h9ba354118e6925af_a51a8b5f2067fcde), 16'hFFFF);
//        slv_mem_agent.mem_model.backdoor_memory_write(40'h0100001330, convert_to_little_endian(128'ha8b09c1a93d194cd_be49846eb75d5b9a), 16'hFFFF);
//        slv_mem_agent.mem_model.backdoor_memory_write(40'h0100001340, convert_to_little_endian(128'hd59aecb85bf3c917_fee94248de8ebe96), 16'hFFFF);
//        slv_mem_agent.mem_model.backdoor_memory_write(40'h0100001350, convert_to_little_endian(128'hb5a9328a2678a647_983122292f6c79b3), 16'hFFFF);
//        slv_mem_agent.mem_model.backdoor_memory_write(40'h0100001360, convert_to_little_endian(128'h812c81addadf48ba_24360af2fab8b464), 16'hFFFF);
//        slv_mem_agent.mem_model.backdoor_memory_write(40'h0100001370, convert_to_little_endian(128'h98c5bfc9bebd198e_268c3ba709e04214), 16'hFFFF);            
//        slv_mem_agent.mem_model.backdoor_memory_write(40'h0100001380, convert_to_little_endian(128'h68007bacb2df3316_96e939e46c518d80), 16'hFFFF);
//        slv_mem_agent.mem_model.backdoor_memory_write(40'h0100001390, convert_to_little_endian(128'hc814e20476a9fb8a_5025c02d59c58239), 16'hFFFF);
//        slv_mem_agent.mem_model.backdoor_memory_write(40'h01000013A0, convert_to_little_endian(128'hde1369676ccc5a71_fa2563959674ee15), 16'hFFFF);            
//        slv_mem_agent.mem_model.backdoor_memory_write(40'h01000013B0, convert_to_little_endian(128'h5886ca5d2e2f31d7_7e0af1fa27cf73c3), 16'hFFFF);
//        slv_mem_agent.mem_model.backdoor_memory_write(40'h01000013C0, convert_to_little_endian(128'h749c47ab18501dda_e2757e4f7401905a), 16'hFFFF);
//        slv_mem_agent.mem_model.backdoor_memory_write(40'h01000013D0, convert_to_little_endian(128'hcafaaae3e4d59b34_9adf6acebd10190d), 16'hFFFF);            
//        slv_mem_agent.mem_model.backdoor_memory_write(40'h01000013E0, convert_to_little_endian(128'hfe4890d1e6188d0b_046df344706c631e), 16'hFFFF);                   


        //FIPS Test Vector AES256//Little Endian
//        slv_mem_agent.mem_model.backdoor_memory_write(40'h01000018B0, 128'h0f0e0d0c0b0a0908_0706050403020100, 16'hFFFF);
//        slv_mem_agent.mem_model.backdoor_memory_write(40'h01000018C0, 128'h1f1e1d1c1b1a1918_1716151413121110, 16'hFFFF);
//        slv_mem_agent.mem_model.backdoor_memory_write(40'h01000018D0, 128'h9cc072a593ce7fa9_98c476a19fc273a5, 16'hFFFF);
//        slv_mem_agent.mem_model.backdoor_memory_write(40'h01000018E0, 128'hdeba4006c1a45d1a_dabe4402cda85116, 16'hFFFF);
        
slv_mem_agent.mem_model.backdoor_memory_write(40'h01000018A0, {128'h1f1e1d1c1b1a1918_1716151413121110, 128'h0f0e0d0c0b0a0908_0706050403020100}, 32'hFFFFFFFF);
slv_mem_agent.mem_model.backdoor_memory_write(40'h01000018C0, {128'hdeba4006c1a45d1a_dabe4402cda85116, 128'h9cc072a593ce7fa9_98c476a19fc273a5}, 32'hFFFFFFFF);
                        
                    
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.read_data(32'hA000000C,4, read_data, resp);        
        $display ("%t, running the testbench, data read from PL Ethernet 32'h%x",$time, read_data);

//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.set_verbosity(32'd400);
       
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_data(32'ha00c0000,4, 32'h00000008, resp);  //SA
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_data(32'ha00c0004,4, 32'h00000000, resp);  //SA
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_data(32'ha00c0008,4, 32'h00000000, resp);  //DA
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_data(32'ha00c000c,4, 32'ha0050000, resp);  //DA

//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_data(32'ha00c0014,4, 32'hC0000000, resp);  //AxPROT
        
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_data(32'ha00c0040,4, 32'h01012070, resp);  //Eth header
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_data(32'ha00c0044,4, 32'h30363203, resp);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_data(32'ha00c0048,4, 32'h5D00FFFF, resp);
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_data(32'ha00c004c,4, 32'hFFFFFFFF, resp);

//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_data(32'ha00c0050,4, 32'ha0040000, resp);  //FIFO addr       
        #3us
          mst_agent.AXI4LITE_WRITE_BURST(32'hC0004004,0,32'h0200_0000,resp);//fifo interrput
          mst_agent.AXI4LITE_WRITE_BURST(32'hC0001010,0,32'h0000_0040,resp);//read pages
          

                
//        #30us;
        
//        TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_data(32'ha00c0014,4, 32'h00000000, resp);  //STOP command        
//        #20us
        
//        while (read_data == 0)
//        begin
//            #100us
//            TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.read_data(32'hA000000C,4, read_data, resp);        
//            $display ("%t, running the testbench, data read from PL Ethernet 32'h%x",$time, read_data);
//        end
//            TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.read_data(32'hA000000C,4, read_data, resp);        
            $display ("%t, running the testbench, data read from PL Ethernet 32'h%x",$time, read_data);
//            TB_AESKeyFinder250.design_2_i.design_2_i.axi_vip_0.inst.write_data(32'hA000000C, 4, 32'h000001C0 , resp);        
        #15us
        $display ("inter_beat_gap_delay_policy: %t",slv_mem_agent.mem_model.get_inter_beat_gap_delay_policy());
        $display ("bresp_delay: %t",slv_mem_agent.mem_model.get_bresp_delay());
        $display("end");
        $finish;
    end
    
    assign temp_clk = tb_ACLK;
    assign temp_rstn = tb_ARESETn;
    

    design_2_wrapper dut(
        .reset_rtl_0(tb_ARESETn),
        .CLK_IN_D_0_clk_n(~tb_ACLK),
        .CLK_IN_D_0_clk_p(tb_ACLK),
        .clk_200MHz_n(~tb_CLK_200MHz),
        .clk_200MHz_p(tb_CLK_200MHz)
    );
     
endmodule


//gdb x/16bx command out put
function automatic logic [127:0] convert_to_little_endian(logic [127:0] big_endian_data);
    logic [63:0] chunk1, chunk2;
    
    // 入力データを2つの64ビットチャンクに分割
    chunk1 = big_endian_data[127:64];
    chunk2 = big_endian_data[63:0];
    
    // 各チャンクのバイトオーダーを反転
    chunk1 = {chunk1[7:0], chunk1[15:8], chunk1[23:16], chunk1[31:24], 
              chunk1[39:32], chunk1[47:40], chunk1[55:48], chunk1[63:56]};
    chunk2 = {chunk2[7:0], chunk2[15:8], chunk2[23:16], chunk2[31:24], 
              chunk2[39:32], chunk2[47:40], chunk2[55:48], chunk2[63:56]};
    
    // 反転させたチャンクを結合して返す
    return {chunk2, chunk1};
endfunction

function automatic logic [127:0] swap_hi_lo_128(logic [127:0] data_128);
    // 反転させたチャンクを結合して返す
    return {data_128[63:0], data_128[127:64]};
endfunction