`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/26 14:49:46
// Design Name: 
// Module Name: BLOCK_6
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


module BLOCK_6(CLK, RST, BTN, PCK, HCNT, VCNT, turn, BLOCK_1, BLOCK_2, BLOCK_3, BLOCK_4, BLOCK_5, VGA_R, VGA_G, VGA_B, flag, BLOCK);
    input CLK, RST, BTN;
    input turn;
    input PCK;
    input [9:0] HCNT, VCNT;
    input [11:0] BLOCK_1, BLOCK_2, BLOCK_3, BLOCK_4, BLOCK_5;
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
                if(cnt6 == 6'd33) begin
                    cnt6 <= 6'b0;
                end else begin
                    cnt6 <= cnt6 + 6'b1;
                end
            end
        end else begin
            cnt6 <= 6'b0;
        end
    end
    
    reg [21:0] bridge_6;
    
    always @* begin
        case(cnt6)
            6'd0 :   bridge_6 <= 22'b0000000000000000011111;
            6'd1 :   bridge_6 <= 22'b0000000000000000111110;
            6'd2 :   bridge_6 <= 22'b0000000000000001111100;
            6'd3 :   bridge_6 <= 22'b0000000000000011111000;
            6'd4 :   bridge_6 <= 22'b0000000000000111110000;
            6'd5 :   bridge_6 <= 22'b0000000000001111100000;
            6'd6 :   bridge_6 <= 22'b0000000000011111000000;
            6'd7 :   bridge_6 <= 22'b0000000000111110000000;
            6'd8 :   bridge_6 <= 22'b0000000001111100000000;
            6'd9 :   bridge_6 <= 22'b0000000011111000000000;
            6'd10:   bridge_6 <= 22'b0000000111110000000000;
            6'd11:   bridge_6 <= 22'b0000001111100000000000;
            6'd12:   bridge_6 <= 22'b0000011111000000000000;
            6'd13:   bridge_6 <= 22'b0000111110000000000000;
            6'd14:   bridge_6 <= 22'b0001111100000000000000;
            6'd15:   bridge_6 <= 22'b0011111000000000000000;
            6'd16:   bridge_6 <= 22'b0111110000000000000000;
            6'd17:   bridge_6 <= 22'b1111100000000000000000;
            6'd18:   bridge_6 <= 22'b0111110000000000000000;
            6'd19:   bridge_6 <= 22'b0011111000000000000000;
            6'd20:   bridge_6 <= 22'b0001111100000000000000;
            6'd21:   bridge_6 <= 22'b0000111110000000000000;
            6'd22:   bridge_6 <= 22'b0000011111000000000000;
            6'd23:   bridge_6 <= 22'b0000001111100000000000;
            6'd24:   bridge_6 <= 22'b0000000111110000000000;
            6'd25:   bridge_6 <= 22'b0000000011111000000000;
            6'd26:   bridge_6 <= 22'b0000000001111100000000;
            6'd27:   bridge_6 <= 22'b0000000000111110000000;
            6'd28:   bridge_6 <= 22'b0000000000011111000000;
            6'd29:   bridge_6 <= 22'b0000000000001111100000;
            6'd30:   bridge_6 <= 22'b0000000000000111110000;
            6'd31:   bridge_6 <= 22'b0000000000000011111000;
            6'd32:   bridge_6 <= 22'b0000000000000001111100;
            6'd33:   bridge_6 <= 22'b0000000000000000111110;
            default: bridge_6 <= 22'b0000000000000000000000;
        endcase
    end
    
    always @(flag, bridge_6) begin
        if(flag == 1'b1) begin
                BLOCK <= bridge_6[16:5];
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
                if(bridge_6[5] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8) || BLOCK_1[0] == 1'b1 && hcounter == 4'd0 || (BLOCK_1[0] == 1'b1 && BLOCK_2[0] == 1'b1) && hcounter == 4'd1 || (BLOCK_1[0] == 1'b1 && BLOCK_2[0] == 1'b1 && BLOCK_3[0] == 1'b1) && hcounter == 4'd2 || (BLOCK_1[0] == 1'b1 && BLOCK_2[0] == 1'b1 && BLOCK_3[0] == 1'b1 && BLOCK_4[0] == 1'b1) && hcounter == 4'd3 || (BLOCK_1[0] == 1'b1 && BLOCK_2[0] == 1'b1 && BLOCK_3[0] == 1'b1 && BLOCK_4[0] == 4'b1 && BLOCK_5[0] == 1'b1) && hcounter == 4'd4) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd1:   
                if(bridge_6[6] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8) || BLOCK_1[1] == 1'b1 && hcounter == 4'd0 || (BLOCK_1[1] == 1'b1 && BLOCK_2[1] == 1'b1) && hcounter == 4'd1 || (BLOCK_1[1] == 1'b1 && BLOCK_2[1] == 1'b1 && BLOCK_3[1] == 1'b1) && hcounter == 4'd2 || (BLOCK_1[1] == 1'b1 && BLOCK_2[1] == 1'b1 && BLOCK_3[1] == 1'b1 && BLOCK_4[1] == 1'b1) && hcounter == 4'd3 || (BLOCK_1[1] == 1'b1 && BLOCK_2[1] == 1'b1 && BLOCK_3[1] == 1'b1 && BLOCK_4[1] == 4'b1 && BLOCK_5[1] == 1'b1) && hcounter == 4'd4) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd2:   
                if(bridge_6[7] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8) || BLOCK_1[2] == 1'b1 && hcounter == 4'd0 || (BLOCK_1[2] == 1'b1 && BLOCK_2[2] == 1'b1) && hcounter == 4'd1 || (BLOCK_1[2] == 1'b1 && BLOCK_2[2] == 1'b1 && BLOCK_3[2] == 1'b1) && hcounter == 4'd2 || (BLOCK_1[2] == 1'b1 && BLOCK_2[2] == 1'b1 && BLOCK_3[2] == 1'b1 && BLOCK_4[2] == 1'b1) && hcounter == 4'd3 || (BLOCK_1[2] == 1'b1 && BLOCK_2[2] == 1'b1 && BLOCK_3[2] == 1'b1 && BLOCK_4[2] == 4'b1 && BLOCK_5[2] == 1'b1) && hcounter == 4'd4) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end 
            4'd3:   
                if(bridge_6[8] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8) || BLOCK_1[3] == 1'b1 && hcounter == 4'd0 || (BLOCK_1[3] == 1'b1 && BLOCK_2[3] == 1'b1) && hcounter == 4'd1 || (BLOCK_1[3] == 1'b1 && BLOCK_2[3] == 1'b1 && BLOCK_3[3] == 1'b1) && hcounter == 4'd2 || (BLOCK_1[3] == 1'b1 && BLOCK_2[3] == 1'b1 && BLOCK_3[3] == 1'b1 && BLOCK_4[3] == 1'b1) && hcounter == 4'd3 || (BLOCK_1[3] == 1'b1 && BLOCK_2[3] == 1'b1 && BLOCK_3[3] == 1'b1 && BLOCK_4[3] == 4'b1 && BLOCK_5[3] == 1'b1) && hcounter == 4'd4) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd4:   
                if(bridge_6[9] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8) || BLOCK_1[4] == 1'b1 && hcounter == 4'd0 || (BLOCK_1[4] == 1'b1 && BLOCK_2[4] == 1'b1) && hcounter == 4'd1 || (BLOCK_1[4] == 1'b1 && BLOCK_2[4] == 1'b1 && BLOCK_3[4] == 1'b1) && hcounter == 4'd2 || (BLOCK_1[4] == 1'b1 && BLOCK_2[4] == 1'b1 && BLOCK_3[4] == 1'b1 && BLOCK_4[4] == 1'b1) && hcounter == 4'd3 || (BLOCK_1[4] == 1'b1 && BLOCK_2[4] == 1'b1 && BLOCK_3[4] == 1'b1 && BLOCK_4[4] == 4'b1 && BLOCK_5[4] == 1'b1) && hcounter == 4'd4) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd5:   
                if(bridge_6[10] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8) || BLOCK_1[5] == 1'b1 && hcounter == 4'd0 || (BLOCK_1[5] == 1'b1 && BLOCK_2[5] == 1'b1) && hcounter == 4'd1 || (BLOCK_1[5] == 1'b1 && BLOCK_2[5] == 1'b1 && BLOCK_3[5] == 1'b1) && hcounter == 4'd2 || (BLOCK_1[5] == 1'b1 && BLOCK_2[5] == 1'b1 && BLOCK_3[5] == 1'b1 && BLOCK_4[5] == 1'b1) && hcounter == 4'd3 || (BLOCK_1[5] == 1'b1 && BLOCK_2[5] == 1'b1 && BLOCK_3[5] == 1'b1 && BLOCK_4[5] == 4'b1 && BLOCK_5[5] == 1'b1) && hcounter == 4'd4) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd6:   
                if(bridge_6[11] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8) || BLOCK_1[6] == 1'b1 && hcounter == 4'd0 || (BLOCK_1[6] == 1'b1 && BLOCK_2[6] == 1'b1) && hcounter == 4'd1 || (BLOCK_1[6] == 1'b1 && BLOCK_2[6] == 1'b1 && BLOCK_3[6] == 1'b1) && hcounter == 4'd2 || (BLOCK_1[6] == 1'b1 && BLOCK_2[6] == 1'b1 && BLOCK_3[6] == 1'b1 && BLOCK_4[6] == 1'b1) && hcounter == 4'd3 || (BLOCK_1[6] == 1'b1 && BLOCK_2[6] == 1'b1 && BLOCK_3[6] == 1'b1 && BLOCK_4[6] == 4'b1 && BLOCK_5[6] == 1'b1) && hcounter == 4'd4) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd7:   
                if(bridge_6[12] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8) || BLOCK_1[7] == 1'b1 && hcounter == 4'd0 || (BLOCK_1[7] == 1'b1 && BLOCK_2[7] == 1'b1) && hcounter == 4'd1 || (BLOCK_1[7] == 1'b1 && BLOCK_2[7] == 1'b1 && BLOCK_3[7] == 1'b1) && hcounter == 4'd2 || (BLOCK_1[7] == 1'b1 && BLOCK_2[7] == 1'b1 && BLOCK_3[7] == 1'b1 && BLOCK_4[7] == 1'b1) && hcounter == 4'd3 || (BLOCK_1[7] == 1'b1 && BLOCK_2[7] == 1'b1 && BLOCK_3[7] == 1'b1 && BLOCK_4[7] == 4'b1 && BLOCK_5[7] == 1'b1) && hcounter == 4'd4) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end 
            4'd8:   
                if(bridge_6[13] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8) || BLOCK_1[8] == 1'b1 && hcounter == 4'd0 || (BLOCK_1[8] == 1'b1 && BLOCK_2[8] == 1'b1) && hcounter == 4'd1 || (BLOCK_1[8] == 1'b1 && BLOCK_2[8] == 1'b1 && BLOCK_3[8] == 1'b1) && hcounter == 4'd2 || (BLOCK_1[8] == 1'b1 && BLOCK_2[8] == 1'b1 && BLOCK_3[8] == 1'b1 && BLOCK_4[8] == 1'b1) && hcounter == 4'd3 || (BLOCK_1[8] == 1'b1 && BLOCK_2[8] == 1'b1 && BLOCK_3[8] == 1'b1 && BLOCK_4[8] == 4'b1 && BLOCK_5[8] == 1'b1) && hcounter == 4'd4) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd9:   
                if(bridge_6[14] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8) || BLOCK_1[9] == 1'b1 && hcounter == 4'd0 || (BLOCK_1[9] == 1'b1 && BLOCK_2[9] == 1'b1) && hcounter == 4'd1 || (BLOCK_1[9] == 1'b1 && BLOCK_2[9] == 1'b1 && BLOCK_3[9] == 1'b1) && hcounter == 4'd2 || (BLOCK_1[9] == 1'b1 && BLOCK_2[9] == 1'b1 && BLOCK_3[9] == 1'b1 && BLOCK_4[9] == 1'b1) && hcounter == 4'd3 || (BLOCK_1[9] == 1'b1 && BLOCK_2[9] == 1'b1 && BLOCK_3[9] == 1'b1 && BLOCK_4[9] == 4'b1 && BLOCK_5[9] == 1'b1) && hcounter == 4'd4) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd10:   
                if(bridge_6[15] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8) || BLOCK_1[10] == 1'b1 && hcounter == 4'd0 || (BLOCK_1[10] == 1'b1 && BLOCK_2[10] == 1'b1) && hcounter == 4'd1 || (BLOCK_1[10] == 1'b1 && BLOCK_2[10] == 1'b1 && BLOCK_3[10] == 1'b1) && hcounter == 4'd2 || (BLOCK_1[10] == 1'b1 && BLOCK_2[10] == 1'b1 && BLOCK_3[10] == 1'b1 && BLOCK_4[10] == 1'b1) && hcounter == 4'd3 || (BLOCK_1[10] == 1'b1 && BLOCK_2[10] == 1'b1 && BLOCK_3[10] == 1'b1 && BLOCK_4[10] == 4'b1 && BLOCK_5[10] == 1'b1) && hcounter == 4'd4) begin
                    {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                end else begin
                    {R_out, G_out, B_out} <= 12'b0;
                end
            4'd11:   
                if(bridge_6[16] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8) || BLOCK_1[11] == 1'b1 && hcounter == 4'd0 || (BLOCK_1[11] == 1'b1 && BLOCK_2[11] == 1'b1) && hcounter == 4'd1 || (BLOCK_1[11] == 1'b1 && BLOCK_2[11] == 1'b1 && BLOCK_3[11] == 1'b1) && hcounter == 4'd2 || (BLOCK_1[11] == 1'b1 && BLOCK_2[11] == 1'b1 && BLOCK_3[11] == 1'b1 && BLOCK_4[11] == 1'b1) && hcounter == 4'd3 || (BLOCK_1[11] == 1'b1 && BLOCK_2[11] == 1'b1 && BLOCK_3[11] == 1'b1 && BLOCK_4[11] == 4'b1 && BLOCK_5[11] == 1'b1) && hcounter == 4'd4) begin
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
