`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/26 14:50:59
// Design Name: 
// Module Name: BLOCK_10
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


module BLOCK_10(CLK, RST, BTN, PCK, HCNT, VCNT, turn, BLOCK_1, BLOCK_2, BLOCK_3, BLOCK_4, BLOCK_5, BLOCK_6, BLOCK_7, BLOCK_8, BLOCK_9, VGA_R, VGA_G, VGA_B, flag, BLOCK);
    input CLK, RST, BTN;
    input turn;
    input PCK;
    input [9:0] HCNT, VCNT;
    input [11:0] BLOCK_1, BLOCK_2, BLOCK_3, BLOCK_4, BLOCK_5, BLOCK_6, BLOCK_7, BLOCK_8, BLOCK_9;
    output reg [3:0] VGA_R, VGA_G, VGA_B;
    output flag;
    output reg [11:0] BLOCK;
    
    `include "vga_param.vh"
    
    localparam HSIZE = 10'd40;
    localparam VSIZE = 10'd40;
    
    reg [24:0] cnt25;
    
    always @(posedge CLK) begin
        if(turn == 1'b1) begin
            if(RST == 1'b1) begin
                cnt25 <= 25'b0;
            end else begin
                cnt25 <= cnt25 + 25'b1;
            end
        end else begin
            cnt25 <= 25'b0;
        end
    end
    
    wire blockcnten = (cnt25[20:0] == 21'h1fffff);
    reg flag = 1'b0;
    reg [5:0] cnt6;
    
    always @(posedge CLK) begin
        if(turn == 1'b1) begin
            if(RST == 1'b1) begin
                cnt6 <= 6'b0;
            end else if(BTN == 1'b1) begin
                flag <= 1'b1;
            end else if(flag == 1'b0 && blockcnten == 1'b1) begin
                if(cnt6 == 6'd25) begin
                    cnt6 <= 6'b0;
                end else begin
                    cnt6 <= cnt6 + 6'b1;
                end
            end
        end else begin
            cnt6 <= 6'b0;
        end
    end
    
    reg [13:0] bridge_10;
    
    always @* begin
        case(cnt6)
            6'd0 :   bridge_10 <= 14'b00000000000001;
            6'd1 :   bridge_10 <= 14'b00000000000010;
            6'd2 :   bridge_10 <= 14'b00000000000100;
            6'd3 :   bridge_10 <= 14'b00000000001000;
            6'd4 :   bridge_10 <= 14'b00000000010000;
            6'd5 :   bridge_10 <= 14'b00000000100000;
            6'd6 :   bridge_10 <= 14'b00000001000000;
            6'd7 :   bridge_10 <= 14'b00000010000000;
            6'd8 :   bridge_10 <= 14'b00000100000000;
            6'd9 :   bridge_10 <= 14'b00001000000000;
            6'd10:   bridge_10 <= 14'b00010000000000;
            6'd11:   bridge_10 <= 14'b00100000000000;
            6'd12:   bridge_10 <= 14'b01000000000000;
            6'd13:   bridge_10 <= 14'b10000000000000;
            6'd14:   bridge_10 <= 14'b01000000000000;
            6'd15:   bridge_10 <= 14'b00100000000000;
            6'd16:   bridge_10 <= 14'b00010000000000;
            6'd17:   bridge_10 <= 14'b00001000000000;
            6'd18:   bridge_10 <= 14'b00000100000000;
            6'd19:   bridge_10 <= 14'b00000010000000;
            6'd20:   bridge_10 <= 14'b00000001000000;
            6'd21:   bridge_10 <= 14'b00000000100000;
            6'd22:   bridge_10 <= 14'b00000000010000;
            6'd23:   bridge_10 <= 14'b00000000001000;
            6'd24:   bridge_10 <= 14'b00000000000100;
            6'd25:   bridge_10 <= 14'b00000000000010;
            default: bridge_10 <= 14'b00000000000000;
        endcase
    end
            
    always @(flag, bridge_10) begin
        if(flag == 1'b1) begin
                BLOCK <= bridge_10[12:1];
        end
    end
    
    wire [9:0] HBLANK = HFRONT + HWIDTH + HBACK;
    wire [9:0] VBLANK = VFRONT + VWIDTH + VBACK;
    
    wire disp_enable = (VBLANK <= VCNT) && (HBLANK - 10'd1 <= HCNT) && (HCNT < HPERIOD - 10'd1);
    wire [3:0] hcounter = (HCNT - HBLANK + 10'd1) / HSIZE;
    wire [3:0] vcounter = (VCNT - VBLANK) / VSIZE;
    reg [3:0] R_out, G_out, B_out;
    
    always @* begin
        case(vcounter)
            4'd0:   
                if((bridge_10[1] == 1'b1 && hcounter == 4'd15) || (BLOCK_1[0] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[0] & BLOCK_2[0]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0] & BLOCK_6[0]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0] & BLOCK_6[0] & BLOCK_7[0]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0] & BLOCK_6[0] & BLOCK_7[0] & BLOCK_8[0]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0] & BLOCK_6[0] & BLOCK_7[0] & BLOCK_8[0] & BLOCK_9[0]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd1:   
                if((bridge_10[2] == 1'b1 && hcounter == 4'd15) || (BLOCK_1[1] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[1] & BLOCK_2[1]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1] & BLOCK_6[1]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1] & BLOCK_6[1] & BLOCK_7[1]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1] & BLOCK_6[1] & BLOCK_7[1] & BLOCK_8[1]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1] & BLOCK_6[1] & BLOCK_7[1] & BLOCK_8[1] & BLOCK_9[1]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd2:   
                if((bridge_10[3] == 1'b1 && hcounter == 4'd15) || (BLOCK_1[2] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[2] & BLOCK_2[2]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2] & BLOCK_6[2]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2] & BLOCK_6[2] & BLOCK_7[2]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2] & BLOCK_6[2] & BLOCK_7[2] & BLOCK_8[2]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2] & BLOCK_6[2] & BLOCK_7[2] & BLOCK_8[2] & BLOCK_9[2]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end 
            4'd3:   
                if((bridge_10[4] == 1'b1 && hcounter == 4'd15) || (BLOCK_1[3] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[3] & BLOCK_2[3]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3] & BLOCK_6[3]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3] & BLOCK_6[3] & BLOCK_7[3]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3] & BLOCK_6[3] & BLOCK_7[3] & BLOCK_8[3]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3] & BLOCK_6[3] & BLOCK_7[3] & BLOCK_8[3] & BLOCK_9[3]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd4:   
                if((bridge_10[5] == 1'b1 && hcounter == 4'd15) || (BLOCK_1[4] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[4] & BLOCK_2[4]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4] & BLOCK_6[4]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4] & BLOCK_6[4] & BLOCK_7[4]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4] & BLOCK_6[4] & BLOCK_7[4] & BLOCK_8[4]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4] & BLOCK_6[4] & BLOCK_7[4] & BLOCK_8[4] & BLOCK_9[4]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd5:   
                if((bridge_10[6] == 1'b1 && hcounter == 4'd15) || (BLOCK_1[5] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[5] & BLOCK_2[5]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5] & BLOCK_6[5]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5] & BLOCK_6[5] & BLOCK_7[5]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5] & BLOCK_6[5] & BLOCK_7[5] & BLOCK_8[5]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5] & BLOCK_6[5] & BLOCK_7[5] & BLOCK_8[5] & BLOCK_9[5]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd6:   
                if((bridge_10[7] == 1'b1 && hcounter == 4'd15) || (BLOCK_1[6] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[6] & BLOCK_2[6]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6] & BLOCK_6[6]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6] & BLOCK_6[6] & BLOCK_7[6]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6] & BLOCK_6[6] & BLOCK_7[6] & BLOCK_8[6]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6] & BLOCK_6[6] & BLOCK_7[6] & BLOCK_8[6] & BLOCK_9[6]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd7:   
                if((bridge_10[8] == 1'b1 && hcounter == 4'd15) || (BLOCK_1[7] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[7] & BLOCK_2[7]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7] & BLOCK_6[7]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7] & BLOCK_6[7] & BLOCK_7[7]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7] & BLOCK_6[7] & BLOCK_7[7] & BLOCK_8[7]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7] & BLOCK_6[7] & BLOCK_7[7] & BLOCK_8[7] & BLOCK_9[7]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end 
            4'd8:   
                if((bridge_10[9] == 1'b1 && hcounter == 4'd15) || (BLOCK_1[8] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[8] & BLOCK_2[8]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8] & BLOCK_6[8]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8] & BLOCK_6[8] & BLOCK_7[8]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8] & BLOCK_6[8] & BLOCK_7[8] & BLOCK_8[8]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8] & BLOCK_6[8] & BLOCK_7[8] & BLOCK_8[8] & BLOCK_9[8]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd9:   
                if((bridge_10[10] == 1'b1 && hcounter == 4'd15) || (BLOCK_1[9] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[9] & BLOCK_2[9]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9] & BLOCK_6[9]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9] & BLOCK_6[9] & BLOCK_7[9]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9] & BLOCK_6[9] & BLOCK_7[9] & BLOCK_8[9]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9] & BLOCK_6[9] & BLOCK_7[9] & BLOCK_8[9] & BLOCK_9[9]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd10:   
                if((bridge_10[11] == 1'b1 && hcounter == 4'd15) || (BLOCK_1[10] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[10] & BLOCK_2[10]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10] & BLOCK_6[10]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10] & BLOCK_6[10] & BLOCK_7[10]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10] & BLOCK_6[10] & BLOCK_7[10] & BLOCK_8[10]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10] & BLOCK_6[10] & BLOCK_7[10] & BLOCK_8[10] & BLOCK_9[10]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd11:   
                if((bridge_10[12] == 1'b1 && hcounter == 4'd15) || (BLOCK_1[11] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[11] & BLOCK_2[11]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11] & BLOCK_6[11]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11] & BLOCK_6[11] & BLOCK_7[11]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11] & BLOCK_6[11] & BLOCK_7[11] & BLOCK_8[11]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11] & BLOCK_6[11] & BLOCK_7[11] & BLOCK_8[11] & BLOCK_9[11]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            default:
               {R_out, G_out, B_out} <= 12'b0;               
      endcase 
    end
        
    always @(posedge PCK) begin
        if(turn == 1'b1 && flag == 1'b0) begin
            if(RST == 1'b1) begin
                {VGA_R, VGA_G, VGA_B} <= 12'b0;
            end else if(disp_enable == 1'b1) begin
                {VGA_R, VGA_G, VGA_B} <= {R_out, G_out, B_out};  
            end else begin
                {VGA_R, VGA_G, VGA_B} <= 12'b0;
            end
        end
    end
    
endmodule
