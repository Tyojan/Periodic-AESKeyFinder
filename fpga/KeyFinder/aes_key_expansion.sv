

    function [127:0] aes_key_expansion128;
    input [127:0] key;
    input [3:0]round;
    begin   
        aes_key_expansion128[127:96] = subwordx({key[39:32],key[63:40]}) ^ {24'h000000,rcon128(round)} ^ key[95:64] ^ key[127:96];
        aes_key_expansion128[95:64]  = subwordx({key[39:32],key[63:40]}) ^ {24'h000000,rcon128(round)} ^ key[95:64];                        
        aes_key_expansion128[63:32]  = subwordx({key[39:32],key[63:40]}) ^ {24'h000000,rcon128(round)} ^ key[95:64] ^ key[127:96] ^ key[63:32] ^ key[31:0];        
        aes_key_expansion128[31:0]   = subwordx({key[39:32],key[63:40]}) ^ {24'h000000,rcon128(round)} ^ key[95:64] ^ key[127:96] ^ key[31:0];
    end
    endfunction

//    function [255:0] aes_key_expansion256;
//    input [255:0] key;
//    input [3:0]round;
//    begin   
//        aes_key_expansion256[255:224] = subwordx({key[39:32],key[63:40]}) ^ {24'h000000,rcon256(round)} ^ key[223:192] ^ key[255:224];
//        aes_key_expansion256[223:192] = subwordx({key[39:32],key[63:40]}) ^ {24'h000000,rcon256(round)} ^ key[223:192];
//        aes_key_expansion256[191:160] = subwordx({key[39:32],key[63:40]}) ^ {24'h000000,rcon256(round)} ^ key[223:192] ^ key[255:224] ^ key[191:160] ^ key[159:128];
//        aes_key_expansion256[159:128] = subwordx({key[39:32],key[63:40]}) ^ {24'h000000,rcon256(round)} ^ key[223:192] ^ key[255:224] ^ key[159:128];        
////        aes_key_expansion256[127:96] = subwordx(aes_key_expansion256[191:160]) ^ key[95:64] ^ key[127:96];
////        aes_key_expansion256[95:64]  = subwordx(aes_key_expansion256[191:160]) ^ key[95:64];                 
////        aes_key_expansion256[63:32]  = subwordx(aes_key_expansion256[191:160]) ^ key[95:64] ^ key[127:96] ^ key[63:32] ^ key[31:0];
////        aes_key_expansion256[31:0]   = subwordx(aes_key_expansion256[191:160]) ^ key[95:64] ^ key[127:96] ^ key[31:0];        
//        aes_key_expansion256[127:96] = subwordx(subwordx({key[39:32],key[63:40]}) ^ {24'h000000,rcon256(round)} ^ key[223:192] ^ key[255:224] ^ key[191:160] ^ key[159:128]) ^ key[95:64] ^ key[127:96];
//        aes_key_expansion256[95:64]  = subwordx(subwordx({key[39:32],key[63:40]}) ^ {24'h000000,rcon256(round)} ^ key[223:192] ^ key[255:224] ^ key[191:160] ^ key[159:128]) ^ key[95:64];                 
//        aes_key_expansion256[63:32]  = subwordx(subwordx({key[39:32],key[63:40]}) ^ {24'h000000,rcon256(round)} ^ key[223:192] ^ key[255:224] ^ key[191:160] ^ key[159:128]) ^ key[95:64] ^ key[127:96] ^ key[63:32] ^ key[31:0];
//        aes_key_expansion256[31:0]   = subwordx(subwordx({key[39:32],key[63:40]}) ^ {24'h000000,rcon256(round)} ^ key[223:192] ^ key[255:224] ^ key[191:160] ^ key[159:128]) ^ key[95:64] ^ key[127:96] ^ key[31:0];        

//    end
//    endfunction

    function [127:0] aes_key_expansion256;
    input [255:0] key;
    input [3:0]round;
    begin
        if (round[0] == 1'b0)
        begin   
            aes_key_expansion256[127:96] = subwordx({key[39:32],key[63:40]}) ^ {24'h000000,rcon256(round)} ^ key[223:192] ^ key[255:224];
            aes_key_expansion256[95:64] = subwordx({key[39:32],key[63:40]}) ^ {24'h000000,rcon256(round)} ^ key[223:192];
            aes_key_expansion256[63:32] = subwordx({key[39:32],key[63:40]}) ^ {24'h000000,rcon256(round)} ^ key[223:192] ^ key[255:224] ^ key[191:160] ^ key[159:128];
            aes_key_expansion256[31:0] = subwordx({key[39:32],key[63:40]}) ^ {24'h000000,rcon256(round)} ^ key[223:192] ^ key[255:224] ^ key[159:128];        
        end
        else
        begin
            aes_key_expansion256[127:96] = subwordx(key[191:160]) ^ key[95:64] ^ key[127:96];
            aes_key_expansion256[95:64]  = subwordx(key[191:160]) ^ key[95:64];                 
            aes_key_expansion256[63:32]  = subwordx(key[191:160]) ^ key[95:64] ^ key[127:96] ^ key[63:32] ^ key[31:0];
            aes_key_expansion256[31:0]   = subwordx(key[191:160]) ^ key[95:64] ^ key[127:96] ^ key[31:0];        
        end
    end
    endfunction

     
    function [7:0] rcon128;
    input [3:0]round;
    begin                            
        case (round)              
           4'h0: rcon128=8'h01;
           4'h1: rcon128=8'h02;
           4'h2: rcon128=8'h04;
           4'h3: rcon128=8'h08;
           4'h4: rcon128=8'h10;
           4'h5: rcon128=8'h20;
           4'h6: rcon128=8'h40;
           4'h7: rcon128=8'h80;
           4'h8: rcon128=8'h1b;
           4'h9: rcon128=8'h36;           
           default: rcon128=8'h00;
        endcase
    end
    endfunction
    
    function [7:0] rcon256;
    input [3:0]round;
    begin                            
        case (round)              
           4'h0: rcon256=8'h01;
           4'h2: rcon256=8'h02;
           4'h4: rcon256=8'h04;
           4'h6: rcon256=8'h08;
           4'h8: rcon256=8'h10;
           4'hA: rcon256=8'h20;
           4'hC: rcon256=8'h40;
           default: rcon256=8'h00;
        endcase
    end
    endfunction
	
	    
    function [31:0] subwordx;
    input [31:0] word;
    begin
        subwordx[7:0]=substitution(word[7:0]);
        subwordx[15:8]=substitution(word[15:8]);
        subwordx[23:16]=substitution(word[23:16]);
        subwordx[31:24]=substitution(word[31:24]);
    end
    endfunction


    function [7:0] substitution(input [7:0] in_8bits);  
    begin
        case (in_8bits)
           8'h00: substitution=8'h63;
           8'h01: substitution=8'h7c;
           8'h02: substitution=8'h77;
           8'h03: substitution=8'h7b;
           8'h04: substitution=8'hf2;
           8'h05: substitution=8'h6b;
           8'h06: substitution=8'h6f;
           8'h07: substitution=8'hc5;
           8'h08: substitution=8'h30;
           8'h09: substitution=8'h01;
           8'h0a: substitution=8'h67;
           8'h0b: substitution=8'h2b;
           8'h0c: substitution=8'hfe;
           8'h0d: substitution=8'hd7;
           8'h0e: substitution=8'hab;
           8'h0f: substitution=8'h76;
           8'h10: substitution=8'hca;
           8'h11: substitution=8'h82;
           8'h12: substitution=8'hc9;
           8'h13: substitution=8'h7d;
           8'h14: substitution=8'hfa;
           8'h15: substitution=8'h59;
           8'h16: substitution=8'h47;
           8'h17: substitution=8'hf0;
           8'h18: substitution=8'had;
           8'h19: substitution=8'hd4;
           8'h1a: substitution=8'ha2;
           8'h1b: substitution=8'haf;
           8'h1c: substitution=8'h9c;
           8'h1d: substitution=8'ha4;
           8'h1e: substitution=8'h72;
           8'h1f: substitution=8'hc0;
           8'h20: substitution=8'hb7;
           8'h21: substitution=8'hfd;
           8'h22: substitution=8'h93;
           8'h23: substitution=8'h26;
           8'h24: substitution=8'h36;
           8'h25: substitution=8'h3f;
           8'h26: substitution=8'hf7;
           8'h27: substitution=8'hcc;
           8'h28: substitution=8'h34;
           8'h29: substitution=8'ha5;
           8'h2a: substitution=8'he5;
           8'h2b: substitution=8'hf1;
           8'h2c: substitution=8'h71;
           8'h2d: substitution=8'hd8;
           8'h2e: substitution=8'h31;
           8'h2f: substitution=8'h15;
           8'h30: substitution=8'h04;
           8'h31: substitution=8'hc7;
           8'h32: substitution=8'h23;
           8'h33: substitution=8'hc3;
           8'h34: substitution=8'h18;
           8'h35: substitution=8'h96;
           8'h36: substitution=8'h05;
           8'h37: substitution=8'h9a;
           8'h38: substitution=8'h07;
           8'h39: substitution=8'h12;
           8'h3a: substitution=8'h80;
           8'h3b: substitution=8'he2;
           8'h3c: substitution=8'heb;
           8'h3d: substitution=8'h27;
           8'h3e: substitution=8'hb2;
           8'h3f: substitution=8'h75;
           8'h40: substitution=8'h09;
           8'h41: substitution=8'h83;
           8'h42: substitution=8'h2c;
           8'h43: substitution=8'h1a;
           8'h44: substitution=8'h1b;
           8'h45: substitution=8'h6e;
           8'h46: substitution=8'h5a;
           8'h47: substitution=8'ha0;
           8'h48: substitution=8'h52;
           8'h49: substitution=8'h3b;
           8'h4a: substitution=8'hd6;
           8'h4b: substitution=8'hb3;
           8'h4c: substitution=8'h29;
           8'h4d: substitution=8'he3;
           8'h4e: substitution=8'h2f;
           8'h4f: substitution=8'h84;
           8'h50: substitution=8'h53;
           8'h51: substitution=8'hd1;
           8'h52: substitution=8'h00;
           8'h53: substitution=8'hed;
           8'h54: substitution=8'h20;
           8'h55: substitution=8'hfc;
           8'h56: substitution=8'hb1;
           8'h57: substitution=8'h5b;
           8'h58: substitution=8'h6a;
           8'h59: substitution=8'hcb;
           8'h5a: substitution=8'hbe;
           8'h5b: substitution=8'h39;
           8'h5c: substitution=8'h4a;
           8'h5d: substitution=8'h4c;
           8'h5e: substitution=8'h58;
           8'h5f: substitution=8'hcf;
           8'h60: substitution=8'hd0;
           8'h61: substitution=8'hef;
           8'h62: substitution=8'haa;
           8'h63: substitution=8'hfb;
           8'h64: substitution=8'h43;
           8'h65: substitution=8'h4d;
           8'h66: substitution=8'h33;
           8'h67: substitution=8'h85;
           8'h68: substitution=8'h45;
           8'h69: substitution=8'hf9;
           8'h6a: substitution=8'h02;
           8'h6b: substitution=8'h7f;
           8'h6c: substitution=8'h50;
           8'h6d: substitution=8'h3c;
           8'h6e: substitution=8'h9f;
           8'h6f: substitution=8'ha8;
           8'h70: substitution=8'h51;
           8'h71: substitution=8'ha3;
           8'h72: substitution=8'h40;
           8'h73: substitution=8'h8f;
           8'h74: substitution=8'h92;
           8'h75: substitution=8'h9d;
           8'h76: substitution=8'h38;
           8'h77: substitution=8'hf5;
           8'h78: substitution=8'hbc;
           8'h79: substitution=8'hb6;
           8'h7a: substitution=8'hda;
           8'h7b: substitution=8'h21;
           8'h7c: substitution=8'h10;
           8'h7d: substitution=8'hff;
           8'h7e: substitution=8'hf3;
           8'h7f: substitution=8'hd2;
           8'h80: substitution=8'hcd;
           8'h81: substitution=8'h0c;
           8'h82: substitution=8'h13;
           8'h83: substitution=8'hec;
           8'h84: substitution=8'h5f;
           8'h85: substitution=8'h97;
           8'h86: substitution=8'h44;
           8'h87: substitution=8'h17;
           8'h88: substitution=8'hc4;
           8'h89: substitution=8'ha7;
           8'h8a: substitution=8'h7e;
           8'h8b: substitution=8'h3d;
           8'h8c: substitution=8'h64;
           8'h8d: substitution=8'h5d;
           8'h8e: substitution=8'h19;
           8'h8f: substitution=8'h73;
           8'h90: substitution=8'h60;
           8'h91: substitution=8'h81;
           8'h92: substitution=8'h4f;
           8'h93: substitution=8'hdc;
           8'h94: substitution=8'h22;
           8'h95: substitution=8'h2a;
           8'h96: substitution=8'h90;
           8'h97: substitution=8'h88;
           8'h98: substitution=8'h46;
           8'h99: substitution=8'hee;
           8'h9a: substitution=8'hb8;
           8'h9b: substitution=8'h14;
           8'h9c: substitution=8'hde;
           8'h9d: substitution=8'h5e;
           8'h9e: substitution=8'h0b;
           8'h9f: substitution=8'hdb;
           8'ha0: substitution=8'he0;
           8'ha1: substitution=8'h32;
           8'ha2: substitution=8'h3a;
           8'ha3: substitution=8'h0a;
           8'ha4: substitution=8'h49;
           8'ha5: substitution=8'h06;
           8'ha6: substitution=8'h24;
           8'ha7: substitution=8'h5c;
           8'ha8: substitution=8'hc2;
           8'ha9: substitution=8'hd3;
           8'haa: substitution=8'hac;
           8'hab: substitution=8'h62;
           8'hac: substitution=8'h91;
           8'had: substitution=8'h95;
           8'hae: substitution=8'he4;
           8'haf: substitution=8'h79;
           8'hb0: substitution=8'he7;
           8'hb1: substitution=8'hc8;
           8'hb2: substitution=8'h37;
           8'hb3: substitution=8'h6d;
           8'hb4: substitution=8'h8d;
           8'hb5: substitution=8'hd5;
           8'hb6: substitution=8'h4e;
           8'hb7: substitution=8'ha9;
           8'hb8: substitution=8'h6c;
           8'hb9: substitution=8'h56;
           8'hba: substitution=8'hf4;
           8'hbb: substitution=8'hea;
           8'hbc: substitution=8'h65;
           8'hbd: substitution=8'h7a;
           8'hbe: substitution=8'hae;
           8'hbf: substitution=8'h08;
           8'hc0: substitution=8'hba;
           8'hc1: substitution=8'h78;
           8'hc2: substitution=8'h25;
           8'hc3: substitution=8'h2e;
           8'hc4: substitution=8'h1c;
           8'hc5: substitution=8'ha6;
           8'hc6: substitution=8'hb4;
           8'hc7: substitution=8'hc6;
           8'hc8: substitution=8'he8;
           8'hc9: substitution=8'hdd;
           8'hca: substitution=8'h74;
           8'hcb: substitution=8'h1f;
           8'hcc: substitution=8'h4b;
           8'hcd: substitution=8'hbd;
           8'hce: substitution=8'h8b;
           8'hcf: substitution=8'h8a;
           8'hd0: substitution=8'h70;
           8'hd1: substitution=8'h3e;
           8'hd2: substitution=8'hb5;
           8'hd3: substitution=8'h66;
           8'hd4: substitution=8'h48;
           8'hd5: substitution=8'h03;
           8'hd6: substitution=8'hf6;
           8'hd7: substitution=8'h0e;
           8'hd8: substitution=8'h61;
           8'hd9: substitution=8'h35;
           8'hda: substitution=8'h57;
           8'hdb: substitution=8'hb9;
           8'hdc: substitution=8'h86;
           8'hdd: substitution=8'hc1;
           8'hde: substitution=8'h1d;
           8'hdf: substitution=8'h9e;
           8'he0: substitution=8'he1;
           8'he1: substitution=8'hf8;
           8'he2: substitution=8'h98;
           8'he3: substitution=8'h11;
           8'he4: substitution=8'h69;
           8'he5: substitution=8'hd9;
           8'he6: substitution=8'h8e;
           8'he7: substitution=8'h94;
           8'he8: substitution=8'h9b;
           8'he9: substitution=8'h1e;
           8'hea: substitution=8'h87;
           8'heb: substitution=8'he9;
           8'hec: substitution=8'hce;
           8'hed: substitution=8'h55;
           8'hee: substitution=8'h28;
           8'hef: substitution=8'hdf;
           8'hf0: substitution=8'h8c;
           8'hf1: substitution=8'ha1;
           8'hf2: substitution=8'h89;
           8'hf3: substitution=8'h0d;
           8'hf4: substitution=8'hbf;
           8'hf5: substitution=8'he6;
           8'hf6: substitution=8'h42;
           8'hf7: substitution=8'h68;
           8'hf8: substitution=8'h41;
           8'hf9: substitution=8'h99;
           8'hfa: substitution=8'h2d;
           8'hfb: substitution=8'h0f;
           8'hfc: substitution=8'hb0;
           8'hfd: substitution=8'h54;
           8'hfe: substitution=8'hbb;
           8'hff: substitution=8'h16;
        endcase
    end
    endfunction


	    

