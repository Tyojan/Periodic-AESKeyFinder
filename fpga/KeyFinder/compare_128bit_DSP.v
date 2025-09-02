`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/29/2024 09:04:11 PM
// Design Name: 
// Module Name: compare_128bit_DSP
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


module compare_128bit_DSP #(
    parameter integer GENERATE_NUM = 0
    )(
    input wire clk,
    input wire [127:0] a,
    input wire [127:0] b,
    output wire equal
    );

    localparam integer SHIFT = (GENERATE_NUM % 4);
    
    wire [26:0] first_xnor_result;
    integer lut;

    function integer lut_range (input integer pattern, input integer i);              
    begin                                                           
        case(pattern)
        0: lut_range = i*3;
        1: lut_range = (i < 18) ? i*3 : 48+i*3;
        2: lut_range = (i < 9) ? i*3 : 48+i*3;
        3: lut_range = i*3+48;
        endcase                            
    end                                                           
    endfunction
        
    function integer dsp_range (input integer pattern);              
    begin                                                           
        case(pattern)
        0: dsp_range = 80;
        1: dsp_range = 54;
        2: dsp_range = 27;
        3: dsp_range = 0;
        endcase                            
    end                                                           
    endfunction
               
    genvar i;
    generate
        
        for (i = 0; i < 27; i = i + 1) begin : lut_xnor
            if(i != 26)
            begin
                LUT6 #(
                    .INIT(64'h9009000000009009)
                ) LUT6_inst (
                    .O(first_xnor_result[i]),
                    .I0(a[lut_range(SHIFT,i)]),
                    .I1(a[lut_range(SHIFT,i)]),
                    .I2(a[lut_range(SHIFT,i) + 1]),
                    .I3(b[lut_range(SHIFT,i) + 1]),
                    .I4(a[lut_range(SHIFT,i) + 2]),
                    .I5(b[lut_range(SHIFT,i) + 2])
                );
            end            
            else
            begin                
                LUT4 #(
                    .INIT(16'h9009)
                ) LUT4_inst (
                    .O(first_xnor_result[i]),
                    .I0(a[lut_range(SHIFT,i)]),
                    .I1(b[lut_range(SHIFT,i)]),
                    .I2(a[lut_range(SHIFT,i) + 1]),
                    .I3(b[lut_range(SHIFT,i) + 1])
                );  
            end            
        end
    endgenerate    



    wire dsp_equal;
    wire [47:0] dummy_dsp48e2_P;
    DSP_Magnitude_comparator DSP48_MC(
        .CLK(clk),
        .a(a[dsp_range(SHIFT)+:48]),
        .b(b[dsp_range(SHIFT)+:48]),
        .p(dummy_dsp48e2_P),
        .equal(dsp_equal)
        );
        
    wire [7:0] carry8_result [2:0];
    wire [7:0] dummy_carry8_O;
    generate
        for (i = 0; i < 3; i = i + 1) begin : carry8_Magnitude_comparator
            CARRY8 CARRY8_inst (
                .CI(first_xnor_result[i+24]),
                .CI_TOP(1'b0),
                .DI(8'b0),
                .S(first_xnor_result[i*8+:8]),
                .O(dummy_carry8_O),
                .CO(carry8_result[i])
            );
        end
    endgenerate 

    reg carry8_result_stage [2:0];
    always @(posedge clk)begin
        carry8_result_stage[0] <= carry8_result[0][7];
        carry8_result_stage[1] <= carry8_result[1][7];
        carry8_result_stage[2] <= carry8_result[2][7];
    end

    reg carry8_result_stage2 [2:0];
    always @(posedge clk)begin
        carry8_result_stage2[0] <= carry8_result_stage[0];
        carry8_result_stage2[1] <= carry8_result_stage[1];
        carry8_result_stage2[2] <= carry8_result_stage[2];
    end
    
    wire equal_result;
    assign equal = equal_result;
        
//    LUT4 #(
//        .INIT(32'h8000)
//    ) LUT4_128equal_result (
//        .O(equal_result),
//        .I0(carry8_result_stage[0]),
//        .I1(carry8_result_stage[1]),
//        .I2(carry8_result_stage[2]),
//        .I3(dsp_equal)
//    );
    LUT4 #(
        .INIT(32'h8000)
    ) LUT4_128equal_result (
        .O(equal_result),
        .I0(carry8_result_stage2[0]),
        .I1(carry8_result_stage2[1]),
        .I2(carry8_result_stage2[2]),
        .I3(dsp_equal)
    );           

          
endmodule
