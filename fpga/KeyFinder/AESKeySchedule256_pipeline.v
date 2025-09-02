`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/25/2024 02:23:41 PM
// Design Name: 
// Module Name: AESKeySchedule256_pipeline
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


module AESKeySchedule256_pipeline(
    input wire clk,
    input wire [127:0] aes_key_initial_value_hi,
    input wire [127:0] aes_key_initial_value_lo,
    output wire [127:0] aes_256_key_schedule_1,
    output wire [127:0] aes_256_key_schedule_2,
    output wire [127:0] aes_256_key_schedule_3,
    output wire [127:0] aes_256_key_schedule_4,
    output wire [127:0] aes_256_key_schedule_5,
    output wire [127:0] aes_256_key_schedule_6,
    output wire [127:0] aes_256_key_schedule_7,
    output wire [127:0] aes_256_key_schedule_8,
    output wire [127:0] aes_256_key_schedule_9,
    output wire [127:0] aes_256_key_schedule_10,
    output wire [127:0] aes_256_key_schedule_11,
    output wire [127:0] aes_256_key_schedule_12,
    output wire [127:0] aes_256_key_schedule_13
    );
    `include "aes_key_expansion.sv"
    // AES-256 Key Schedule Pipeline Registers
    reg [127:0] aes256_key_sche_stage_1 [1:0];
    reg [127:0] aes256_key_sche_stage_2 [2:0];
    reg [127:0] aes256_key_sche_stage_3 [3:0];
    reg [127:0] aes256_key_sche_stage_4 [4:0];
    reg [127:0] aes256_key_sche_stage_5 [5:0];
    reg [127:0] aes256_key_sche_stage_6 [6:0];
    reg [127:0] aes256_key_sche_stage_7 [7:0];
    reg [127:0] aes256_key_sche_stage_8 [8:0];
    reg [127:0] aes256_key_sche_stage_9 [9:0];
    reg [127:0] aes256_key_sche_stage_10 [10:0];
    reg [127:0] aes256_key_sche_stage_11 [11:0];
    reg [127:0] aes256_key_sche_stage_12 [12:0];
    reg [127:0] aes256_key_sche_stage_13 [13:0];

    integer i; 

    //AES Key Expansion
    //AES256 Full KeySchedule
    //Keysche256 stage 1
    
//    wire [127:0] ex_key_256[12:0];    

//    aes256_key_expansion_dsp  #(
//        .keylen(256),
//        .round(0)
//        )aes256_keysche_1(
//        .clk(clk),
//        .key({aes_key_initial_value_hi,aes_key_initial_value_lo}),
//        .roundkey(ex_key_256[0])
//        );

//    aes256_key_expansion_dsp  #(
//        .keylen(256),
//        .round(1)
//        )aes256_keysche_2(
//        .clk(clk),
//        .key({aes256_key_sche_stage_1[1],aes256_key_sche_stage_1[0]}),
//        .roundkey(ex_key_256[1])
//        );

//    aes256_key_expansion_dsp  #(
//        .keylen(256),
//        .round(2)
//        )aes256_keysche_3(
//        .clk(clk),
//        .key({aes256_key_sche_stage_2[1],aes256_key_sche_stage_2[2]}),
//        .roundkey(ex_key_256[2])
//        );

//    aes256_key_expansion_dsp  #(
//        .keylen(256),
//        .round(3)
//        )aes256_keysche_4(
//        .clk(clk),
//        .key({aes256_key_sche_stage_3[3],aes256_key_sche_stage_3[2]}),
//        .roundkey(ex_key_256[3])
//        );            

//    aes256_key_expansion_dsp  #(
//        .keylen(256),
//        .round(4)
//        )aes256_keysche_5(
//        .clk(clk),
//        .key({aes256_key_sche_stage_4[3],aes256_key_sche_stage_4[4]}),
//        .roundkey(ex_key_256[4])
//        );

//    aes256_key_expansion_dsp  #(
//        .keylen(256),
//        .round(5)
//        )aes256_keysche_6(
//        .clk(clk),
//        .key({aes256_key_sche_stage_5[5],aes256_key_sche_stage_5[4]}),
//        .roundkey(ex_key_256[5])
//        );

//    aes256_key_expansion_dsp  #(
//        .keylen(256),
//        .round(6)
//        )aes256_keysche_7(
//        .clk(clk),
//        .key({aes256_key_sche_stage_6[5],aes256_key_sche_stage_6[6]}),
//        .roundkey(ex_key_256[6])
//        );        

//    aes256_key_expansion_dsp  #(
//        .keylen(256),
//        .round(7)
//        )aes256_keysche_8(
//        .clk(clk),
//        .key({aes256_key_sche_stage_7[7],aes256_key_sche_stage_7[6]}),
//        .roundkey(ex_key_256[7])
//        );

//    aes256_key_expansion_dsp  #(
//        .keylen(256),
//        .round(8)
//        )aes256_keysche_9(
//        .clk(clk),
//        .key({aes256_key_sche_stage_8[7],aes256_key_sche_stage_8[8]}),
//        .roundkey(ex_key_256[8])
//        );

//    aes256_key_expansion_dsp  #(
//        .keylen(256),
//        .round(9)
//        )aes256_keysche_10(
//        .clk(clk),
//        .key({aes256_key_sche_stage_9[9],aes256_key_sche_stage_9[8]}),
//        .roundkey(ex_key_256[9])
//        );

//    aes256_key_expansion_dsp  #(
//        .keylen(256),
//        .round(10)
//        )aes256_keysche_11(
//        .clk(clk),
//        .key({aes256_key_sche_stage_10[9],aes256_key_sche_stage_10[10]}),
//        .roundkey(ex_key_256[10])
//        );

//    aes256_key_expansion_dsp  #(
//        .keylen(256),
//        .round(11)
//        )aes256_keysche_12(
//        .clk(clk),
//        .key({aes256_key_sche_stage_11[11],aes256_key_sche_stage_11[10]}),
//        .roundkey(ex_key_256[11])
//        );

//    aes256_key_expansion_dsp  #(
//        .keylen(256),
//        .round(12)
//        )aes256_keysche_13(
//        .clk(clk),
//        .key({aes256_key_sche_stage_12[11],aes256_key_sche_stage_12[12]}),
//        .roundkey(ex_key_256[12])
//        );        



    
    always @(posedge clk)                                                                              
    begin
        aes256_key_sche_stage_1[0] <= aes_key_initial_value_lo;                                                                                                         
//        aes256_key_sche_stage_1[1] <= ex_key_256[0];
        aes256_key_sche_stage_1[1] <= aes_key_expansion256({aes_key_initial_value_hi,aes_key_initial_value_lo},0);              
    end

    //Keysche256 stage 2
    always @(posedge clk)                                                                              
    begin                                                                                                              
        aes256_key_sche_stage_2[0] <= aes256_key_sche_stage_1[0];
        aes256_key_sche_stage_2[1] <= aes256_key_sche_stage_1[1];
//        aes256_key_sche_stage_2[2] <= ex_key_256[1];
        aes256_key_sche_stage_2[2] <= aes_key_expansion256({aes256_key_sche_stage_1[1],aes256_key_sche_stage_1[0]},1);             
    end

    //Keysche256 stage 3
    always @(posedge clk)                                                                              
    begin                                             
        for (i = 0; i < 3; i = i + 1)
        begin
            aes256_key_sche_stage_3[i] <= aes256_key_sche_stage_2[i];
        end                     
//        aes256_key_sche_stage_3[3] <= ex_key_256[2];
        aes256_key_sche_stage_3[3] <= aes_key_expansion256({aes256_key_sche_stage_2[1],aes256_key_sche_stage_2[2]},2);
    end
    
    //Keysche256 stage 4
    always @(posedge clk)                                                                              
    begin                                             
        for (i = 0; i < 4; i = i + 1)
        begin
            aes256_key_sche_stage_4[i] <= aes256_key_sche_stage_3[i];
        end                     
//        aes256_key_sche_stage_4[4] <= ex_key_256[3];
        aes256_key_sche_stage_4[4] <= aes_key_expansion256({aes256_key_sche_stage_3[3],aes256_key_sche_stage_3[2]},3);
    end

    //Keysche256 stage 5
    always @(posedge clk)                                                                              
    begin                                             
        for (i = 0; i < 5; i = i + 1)
        begin
            aes256_key_sche_stage_5[i] <= aes256_key_sche_stage_4[i];
        end                     
//        aes256_key_sche_stage_5[5] <= ex_key_256[4];
        aes256_key_sche_stage_5[5] <= aes_key_expansion256({aes256_key_sche_stage_4[3],aes256_key_sche_stage_4[4]},4);
    end
    
    //Keysche256 stage 6
    always @(posedge clk)                                                                              
    begin                                             
        for (i = 0; i < 6; i = i + 1)
        begin
            aes256_key_sche_stage_6[i] <= aes256_key_sche_stage_5[i];
        end                     
//        aes256_key_sche_stage_6[6] <= ex_key_256[5];
        aes256_key_sche_stage_6[6] <= aes_key_expansion256({aes256_key_sche_stage_5[5],aes256_key_sche_stage_5[4]},5);
    end    

    //Keysche256 stage 7
    always @(posedge clk)                                                                              
    begin                                             
        for (i = 0; i < 7; i = i + 1)
        begin
            aes256_key_sche_stage_7[i] <= aes256_key_sche_stage_6[i];
        end                     
//        aes256_key_sche_stage_7[7] <= ex_key_256[6];
        aes256_key_sche_stage_7[7] <= aes_key_expansion256({aes256_key_sche_stage_6[5],aes256_key_sche_stage_6[6]},6);
    end
    
    //Keysche256 stage 8
    always @(posedge clk)                                                                              
    begin                                             
        for (i = 0; i < 8; i = i + 1)
        begin
            aes256_key_sche_stage_8[i] <= aes256_key_sche_stage_7[i];
        end                     
//        aes256_key_sche_stage_8[8] <= ex_key_256[7];
        aes256_key_sche_stage_8[8] <= aes_key_expansion256({aes256_key_sche_stage_7[7],aes256_key_sche_stage_7[6]},7);
    end

    //Keysche256 stage 9
    always @(posedge clk)                                                                              
    begin                                             
        for (i = 0; i < 9; i = i + 1)
        begin
            aes256_key_sche_stage_9[i] <= aes256_key_sche_stage_8[i];
        end                     
//        aes256_key_sche_stage_9[9] <= ex_key_256[8];
        aes256_key_sche_stage_9[9] <= aes_key_expansion256({aes256_key_sche_stage_8[7],aes256_key_sche_stage_8[8]},8);
    end
    
    //Keysche256 stage 10
    always @(posedge clk)                                                                              
    begin                                             
        for (i = 0; i < 10; i = i + 1)
        begin
            aes256_key_sche_stage_10[i] <= aes256_key_sche_stage_9[i];
        end                     
//        aes256_key_sche_stage_10[10] <= ex_key_256[9];
        aes256_key_sche_stage_10[10] <= aes_key_expansion256({aes256_key_sche_stage_9[9],aes256_key_sche_stage_9[8]},9);
    end

    //Keysche256 stage 11
    always @(posedge clk)                                                                              
    begin                                             
        for (i = 0; i < 11; i = i + 1)
        begin
            aes256_key_sche_stage_11[i] <= aes256_key_sche_stage_10[i];
        end                     
//        aes256_key_sche_stage_11[11] <= ex_key_256[10];
        aes256_key_sche_stage_11[11] <= aes_key_expansion256({aes256_key_sche_stage_10[9],aes256_key_sche_stage_10[10]},10);
    end
    
    //Keysche256 stage 12
    always @(posedge clk)                                                                              
    begin                                             
        for (i = 0; i < 12; i = i + 1)
        begin
            aes256_key_sche_stage_12[i] <= aes256_key_sche_stage_11[i];
        end                     
//        aes256_key_sche_stage_12[12] <= ex_key_256[11];
        aes256_key_sche_stage_12[12] <= aes_key_expansion256({aes256_key_sche_stage_11[11],aes256_key_sche_stage_11[10]},11);
    end

    //Keysche256 stage 13
    always @(posedge clk)                                                                              
    begin                                             
        for (i = 0; i < 13; i = i + 1)
        begin
            aes256_key_sche_stage_13[i] <= aes256_key_sche_stage_12[i];
        end                     
//        aes256_key_sche_stage_13[13] <= ex_key_256[12];
        aes256_key_sche_stage_13[13] <= aes_key_expansion256({aes256_key_sche_stage_12[11],aes256_key_sche_stage_12[12]},12);
    end

    
 // Output assignments
    assign aes_256_key_schedule_1 = aes256_key_sche_stage_13[1];
    assign aes_256_key_schedule_2 = aes256_key_sche_stage_13[2];
    assign aes_256_key_schedule_3 = aes256_key_sche_stage_13[3];
    assign aes_256_key_schedule_4 = aes256_key_sche_stage_13[4];
    assign aes_256_key_schedule_5 = aes256_key_sche_stage_13[5];
    assign aes_256_key_schedule_6 = aes256_key_sche_stage_13[6];
    assign aes_256_key_schedule_7 = aes256_key_sche_stage_13[7];
    assign aes_256_key_schedule_8 = aes256_key_sche_stage_13[8];
    assign aes_256_key_schedule_9 = aes256_key_sche_stage_13[9];
    assign aes_256_key_schedule_10 = aes256_key_sche_stage_13[10];
    assign aes_256_key_schedule_11 = aes256_key_sche_stage_13[11];
    assign aes_256_key_schedule_12 = aes256_key_sche_stage_13[12];
    assign aes_256_key_schedule_13 = aes256_key_sche_stage_13[13];
    
endmodule
