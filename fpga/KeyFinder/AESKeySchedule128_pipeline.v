`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2024 01:58:36 PM
// Design Name: 
// Module Name: AESKeySchedule128_pipeline
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


module AESKeySchedule128_pipeline(
    input wire clk,
    input wire [127:0] aes_key_initial_value,
    output wire [127:0] aes_128_key_schedule_1,
    output wire [127:0] aes_128_key_schedule_2,
    output wire [127:0] aes_128_key_schedule_3,
    output wire [127:0] aes_128_key_schedule_4,
    output wire [127:0] aes_128_key_schedule_5,
    output wire [127:0] aes_128_key_schedule_6,
    output wire [127:0] aes_128_key_schedule_7,
    output wire [127:0] aes_128_key_schedule_8,
    output wire [127:0] aes_128_key_schedule_9,
    output wire [127:0] aes_128_key_schedule_10
    );
    `include "aes_key_expansion.sv"
    // AES-128 Key Schedule Pipeline Registers
    reg [127:0] aes128_key_sche_stage_1 [0:0];
    reg [127:0] aes128_key_sche_stage_2 [1:0];
    reg [127:0] aes128_key_sche_stage_3 [2:0];
    reg [127:0] aes128_key_sche_stage_4 [3:0];
    reg [127:0] aes128_key_sche_stage_5 [4:0];
    reg [127:0] aes128_key_sche_stage_6 [5:0];
    reg [127:0] aes128_key_sche_stage_7 [6:0];
    reg [127:0] aes128_key_sche_stage_8 [7:0];
    reg [127:0] aes128_key_sche_stage_9 [8:0];
    reg [127:0] aes128_key_sche_stage_10 [9:0];

    integer i;        


//    wire [127:0] ex_key_128[9:0];    

//    aes_key_expansion_dsp  #(
//        .keylen(128),
//        .round(0)
//        )aes128_keysche_1(
//        .clk(clk),
//        .key(aes_key_initial_value),
//        .roundkey(ex_key_128[0])
//        );                            


//    aes_key_expansion_dsp  #(
//        .keylen(128),
//        .round(1)
//        )aes128_keysche_2(
//        .clk(clk),
//        .key(aes128_key_sche_stage_1[0]),
//        .roundkey(ex_key_128[1])
//        );                            

//    aes_key_expansion_dsp  #(
//        .keylen(128),
//        .round(2)
//        )aes128_keysche_3(
//        .clk(clk),
//        .key(aes128_key_sche_stage_2[1]),
//        .roundkey(ex_key_128[2])
//        );                            

//    aes_key_expansion_dsp  #(
//        .keylen(128),
//        .round(3)
//        )aes128_keysche_4(
//        .clk(clk),
//        .key(aes128_key_sche_stage_3[2]),
//        .roundkey(ex_key_128[3])
//        );                            

//    aes_key_expansion_dsp  #(
//        .keylen(128),
//        .round(4)
//        )aes128_keysche_5(
//        .clk(clk),
//        .key(aes128_key_sche_stage_4[3]),
//        .roundkey(ex_key_128[4])
//        );                            

//    aes_key_expansion_dsp  #(
//        .keylen(128),
//        .round(5)
//        )aes128_keysche_6(
//        .clk(clk),
//        .key(aes128_key_sche_stage_5[4]),
//        .roundkey(ex_key_128[5])
//        );                            

//    aes_key_expansion_dsp  #(
//        .keylen(128),
//        .round(6)
//        )aes128_keysche_7(
//        .clk(clk),
//        .key(aes128_key_sche_stage_6[5]),
//        .roundkey(ex_key_128[6])
//        );                            

//    aes_key_expansion_dsp  #(
//        .keylen(128),
//        .round(7)
//        )aes128_keysche_8(
//        .clk(clk),
//        .key(aes128_key_sche_stage_7[6]),
//        .roundkey(ex_key_128[7])
//        );                            

//    aes_key_expansion_dsp  #(
//        .keylen(128),
//        .round(8)
//        )aes128_keysche_9(
//        .clk(clk),
//        .key(aes128_key_sche_stage_8[7]),
//        .roundkey(ex_key_128[8])
//        );                            

//    aes_key_expansion_dsp  #(
//        .keylen(128),
//        .round(9)
//        )aes128_keysche_10(
//        .clk(clk),
//        .key(aes128_key_sche_stage_9[8]),
//        .roundkey(ex_key_128[9])
//        );                            

        
    // Keysche128 stage 1
    always @(posedge clk)                                                                              
    begin
        aes128_key_sche_stage_1[0] <= aes_key_expansion128(aes_key_initial_value,0); // 初期値を設定
//        aes128_key_sche_stage_1[0] <= ex_key_128[0];
    end
    
    // Keysche128 stage 2
    always @(posedge clk)                                                                              
    begin                                                                                                     
        aes128_key_sche_stage_2[0] <= aes128_key_sche_stage_1[0];
        aes128_key_sche_stage_2[1] <= aes_key_expansion128(aes128_key_sche_stage_1[0],1);
//        aes128_key_sche_stage_2[1] <= ex_key_128[1];
    end
    
    // Keysche128 stage 3
    always @(posedge clk)                                                                              
    begin                                                                                                     
        for (i = 0; i < 2; i = i + 1)
        begin
            aes128_key_sche_stage_3[i] <= aes128_key_sche_stage_2[i];
        end        
        aes128_key_sche_stage_3[2] <= aes_key_expansion128(aes128_key_sche_stage_2[1],2);
//        aes128_key_sche_stage_3[2] <= ex_key_128[2];          
    end
    
    // Keysche128 stage 4
    always @(posedge clk)                                                                              
    begin                                                                                                     
        for (i = 0; i < 3; i = i + 1)
        begin
            aes128_key_sche_stage_4[i] <= aes128_key_sche_stage_3[i];
        end
        aes128_key_sche_stage_4[3] <= aes_key_expansion128(aes128_key_sche_stage_3[2],3);          
//        aes128_key_sche_stage_4[3] <= ex_key_128[3];
    end
    
    // Keysche128 stage 5
    always @(posedge clk)                                                                              
    begin                                                                                                     
        for (i = 0; i < 4; i = i + 1)
        begin
            aes128_key_sche_stage_5[i] <= aes128_key_sche_stage_4[i];
        end
        aes128_key_sche_stage_5[4] <= aes_key_expansion128(aes128_key_sche_stage_4[3],4);
//        aes128_key_sche_stage_5[4] <= ex_key_128[4];          
    end
    
    // Keysche128 stage 6
    always @(posedge clk)                                                                              
    begin                                                                                                     
        for (i = 0; i < 5; i = i + 1)
        begin
            aes128_key_sche_stage_6[i] <= aes128_key_sche_stage_5[i];
        end
        aes128_key_sche_stage_6[5] <= aes_key_expansion128(aes128_key_sche_stage_5[4],5);
//        aes128_key_sche_stage_6[5] <= ex_key_128[5];          
    end
    
    // Keysche128 stage 7
    always @(posedge clk)                                                                              
    begin                                                                                                     
        for (i = 0; i < 6; i = i + 1)
        begin
            aes128_key_sche_stage_7[i] <= aes128_key_sche_stage_6[i];
        end
        aes128_key_sche_stage_7[6] <= aes_key_expansion128(aes128_key_sche_stage_6[5],6);
//        aes128_key_sche_stage_7[6] <= ex_key_128[6];          
    end
    
    // Keysche128 stage 8
    always @(posedge clk)                                                                              
    begin                                                                                                     
        for (i = 0; i < 7; i = i + 1)
        begin
            aes128_key_sche_stage_8[i] <= aes128_key_sche_stage_7[i];
        end
        aes128_key_sche_stage_8[7] <= aes_key_expansion128(aes128_key_sche_stage_7[6],7);
//        aes128_key_sche_stage_8[7] <= ex_key_128[7];          
    end
    
    // Keysche128 stage 9
    always @(posedge clk)                                                                              
    begin                                                                                                     
        for (i = 0; i < 8; i = i + 1)
        begin
            aes128_key_sche_stage_9[i] <= aes128_key_sche_stage_8[i];
        end
        aes128_key_sche_stage_9[8] <= aes_key_expansion128(aes128_key_sche_stage_8[7],8);
//        aes128_key_sche_stage_9[8] <= ex_key_128[8];          
    end
    
    // Keysche128 stage 10
    always @(posedge clk)                                                                              
    begin                                                                                                     
        for (i = 0; i < 9; i = i + 1)
        begin
            aes128_key_sche_stage_10[i] <= aes128_key_sche_stage_9[i];
        end
        aes128_key_sche_stage_10[9] <= aes_key_expansion128(aes128_key_sche_stage_9[8],9);
//        aes128_key_sche_stage_10[9] <= ex_key_128[9];          
    end

 // Output assignments
    assign aes_128_key_schedule_1 = aes128_key_sche_stage_10[0];
    assign aes_128_key_schedule_2 = aes128_key_sche_stage_10[1];
    assign aes_128_key_schedule_3 = aes128_key_sche_stage_10[2];
    assign aes_128_key_schedule_4 = aes128_key_sche_stage_10[3];
    assign aes_128_key_schedule_5 = aes128_key_sche_stage_10[4];
    assign aes_128_key_schedule_6 = aes128_key_sche_stage_10[5];
    assign aes_128_key_schedule_7 = aes128_key_sche_stage_10[6];
    assign aes_128_key_schedule_8 = aes128_key_sche_stage_10[7];
    assign aes_128_key_schedule_9 = aes128_key_sche_stage_10[8];
    assign aes_128_key_schedule_10 = aes128_key_sche_stage_10[9];    
        
endmodule
