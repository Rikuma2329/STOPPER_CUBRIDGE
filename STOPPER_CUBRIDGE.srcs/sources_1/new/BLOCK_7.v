`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/26 14:50:05
// Design Name: 
// Module Name: BLOCK_7
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


module BLOCK_7(CLK, RST, BTN, PCK, HCNT, VCNT, turn, BLOCK_1, BLOCK_2, BLOCK_3, BLOCK_4, BLOCK_5, BLOCK_6, VGA_R, VGA_G, VGA_B, flag, BLOCK);
    input CLK, RST, BTN;
    input turn;
    input PCK;
    input [9:0] HCNT, VCNT;
    input [11:0] BLOCK_1, BLOCK_2, BLOCK_3, BLOCK_4, BLOCK_5, BLOCK_6;
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
    
    wire blockcnten = (cnt25[21:0] == 22'h3fffff);
    reg flag = 1'b0;
    reg [5:0] cnt6;
    
    always @(posedge CLK) begin
        if(turn == 1'b1) begin
            if(RST == 1'b1) begin
                cnt6 <= 6'b0;
            end else if(BTN == 1'b1) begin
                flag <= 1'b1;
            end else if(flag == 1'b0 && blockcnten == 1'b1) begin
                if(cnt6 == 6'd31) begin
                    cnt6 <= 6'b0;
                end else begin
                    cnt6 <= cnt6 + 6'b1;
                end
            end
        end else begin
            cnt6 <= 6'b0;
        end
    end
    
    reg [19:0] bridge_7;
    
    always @* begin
        case(cnt6)
            6'd0 :   bridge_7 <= 20'b00000000000000001111;
            6'd1 :   bridge_7 <= 20'b00000000000000011110;
            6'd2 :   bridge_7 <= 20'b00000000000000111100;
            6'd3 :   bridge_7 <= 20'b00000000000001111000;
            6'd4 :   bridge_7 <= 20'b00000000000011110000;
            6'd5 :   bridge_7 <= 20'b00000000000111100000;
            6'd6 :   bridge_7 <= 20'b00000000001111000000;
            6'd7 :   bridge_7 <= 20'b00000000011110000000;
            6'd8 :   bridge_7 <= 20'b00000000111100000000;
            6'd9 :   bridge_7 <= 20'b00000001111000000000;
            6'd10:   bridge_7 <= 20'b00000011110000000000;
            6'd11:   bridge_7 <= 20'b00000111100000000000;
            6'd12:   bridge_7 <= 20'b00001111000000000000;
            6'd13:   bridge_7 <= 20'b00011110000000000000;
            6'd14:   bridge_7 <= 20'b00111100000000000000;
            6'd15:   bridge_7 <= 20'b01111000000000000000;
            6'd16:   bridge_7 <= 20'b11110000000000000000;
            6'd17:   bridge_7 <= 20'b01111000000000000000;
            6'd18:   bridge_7 <= 20'b00111100000000000000;
            6'd19:   bridge_7 <= 20'b00011110000000000000;
            6'd20:   bridge_7 <= 20'b00001111000000000000;
            6'd21:   bridge_7 <= 20'b00000111100000000000;
            6'd22:   bridge_7 <= 20'b00000011110000000000;
            6'd23:   bridge_7 <= 20'b00000001111000000000;
            6'd24:   bridge_7 <= 20'b00000000111100000000;
            6'd25:   bridge_7 <= 20'b00000000011110000000;
            6'd26:   bridge_7 <= 20'b00000000001111000000;
            6'd27:   bridge_7 <= 20'b00000000000111100000;
            6'd28:   bridge_7 <= 20'b00000000000011110000;
            6'd29:   bridge_7 <= 20'b00000000000001111000;
            6'd30:   bridge_7 <= 20'b00000000000000111100;
            6'd31:   bridge_7 <= 20'b00000000000000011110;
            default: bridge_7 <= 20'b00000000000000000000;
        endcase
    end
            
    always @(flag, bridge_7) begin
        if(flag == 1'b1) begin
                BLOCK <= bridge_7[15:4];
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
                if((bridge_7[4] == 1'b1 && hcounter == 4'd9) || (BLOCK_1[0] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[0] & BLOCK_2[0]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0] & BLOCK_6[0]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd1:   
                if((bridge_7[5] == 1'b1 && hcounter == 4'd9) || (BLOCK_1[1] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[1] & BLOCK_2[1]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1] & BLOCK_6[1]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd2:   
                if((bridge_7[6] == 1'b1 && hcounter == 4'd9) || (BLOCK_1[2] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[2] & BLOCK_2[2]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2] & BLOCK_6[2]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end 
            4'd3:   
                if((bridge_7[7] == 1'b1 && hcounter == 4'd9) || (BLOCK_1[3] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[3] & BLOCK_2[3]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3] & BLOCK_6[3]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd4:   
                if((bridge_7[8] == 1'b1 && hcounter == 4'd9) || (BLOCK_1[4] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[4] & BLOCK_2[4]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4] & BLOCK_6[4]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd5:   
                if((bridge_7[9] == 1'b1 && hcounter == 4'd9) || (BLOCK_1[5] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[5] & BLOCK_2[5]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5] & BLOCK_6[5]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd6:   
                if((bridge_7[10] == 1'b1 && hcounter == 4'd9) || (BLOCK_1[6] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[6] & BLOCK_2[6]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6] & BLOCK_6[6]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd7:   
                if((bridge_7[11] == 1'b1 && hcounter == 4'd9) || (BLOCK_1[7] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[7] & BLOCK_2[7]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7] & BLOCK_6[7]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end 
            4'd8:   
                if((bridge_7[12] == 1'b1 && hcounter == 4'd9) || (BLOCK_1[8] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[8] & BLOCK_2[8]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8] & BLOCK_6[8]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd9:   
                if((bridge_7[13] == 1'b1 && hcounter == 4'd9) || (BLOCK_1[9] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[9] & BLOCK_2[9]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9] & BLOCK_6[9]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd10:   
                if((bridge_7[14] == 1'b1 && hcounter == 4'd9) || (BLOCK_1[10] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[10] & BLOCK_2[10]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10] & BLOCK_6[10]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd11:   
                if((bridge_7[15] == 1'b1 && hcounter == 4'd9) || (BLOCK_1[11] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[11] & BLOCK_2[11]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11] & BLOCK_6[11]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
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
