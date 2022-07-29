`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/06 10:58:01
// Design Name: 
// Module Name: GAME_OVER
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


module GAME_OVER(CLK, RST, PCK, HCNT, VCNT, flag, fin_1, fin_2, fin_3, fin_4, fin_5, fin_6, fin_7, fin_8, fin_9, fin_10, BLOCK_1, BLOCK_2, BLOCK_3, BLOCK_4, BLOCK_5, BLOCK_6, BLOCK_7, BLOCK_8, BLOCK_9, BLOCK_10, VGA_R, VGA_G, VGA_B);
    input CLK, RST, PCK;
    input [9:0] HCNT, VCNT;
    input flag;
    input fin_1, fin_2, fin_3, fin_4, fin_5, fin_6, fin_7, fin_8, fin_9, fin_10;
    input [11:0] BLOCK_1, BLOCK_2, BLOCK_3, BLOCK_4, BLOCK_5, BLOCK_6, BLOCK_7, BLOCK_8, BLOCK_9, BLOCK_10;
    output reg [3:0] VGA_R, VGA_G, VGA_B;
    
    localparam HSIZE = 10'd40;
    localparam VSIZE = 10'd40;

    reg [26:0] cnt27;

    wire disp_cnten = (cnt27 == 27'd100000000);

    always @(posedge CLK) begin
        if(flag == 1'b1) begin
            if(RST == 1'b1) begin
                cnt27 <= 27'b0;
            end else begin
                if(disp_cnten == 1'b1) begin
                    cnt27 <= 27'b0;
                end else begin
                    cnt27 <= cnt27 + 1'b1;
                end
            end
        end else begin
            cnt27 <= 27'b0;
        end
    end
    
    reg disp_change;
    
    always @(posedge CLK) begin
        if(RST == 1'b1) begin
            disp_change <= 1'b0;
        end else if (disp_cnten == 1'b1) begin
            if(disp_change == 1'b1) begin
                disp_change <= 1'b0;
            end else begin
                disp_change <= 1'b1;
            end
        end
    end

    `include "vga_param.vh"
    
    wire [9:0] HBLANK = HFRONT + HWIDTH + HBACK;
    wire [9:0] VBLANK = VFRONT + VWIDTH + VBACK;

    wire disp_enable1 = (VBLANK <= VCNT) && (HBLANK - 10'd1 <= HCNT) && (HCNT < HPERIOD - 10'd1);
    wire [3:0] hcounter = (HCNT - HBLANK + 10'd1) / HSIZE;
    wire [3:0] vcounter = (VCNT - VBLANK) / VSIZE;
    reg [3:0] R_out, G_out, B_out;

    always @* begin
        if(fin_10 == 1'b1) begin
            case(vcounter)
                4'd0:   
                    if((BLOCK_1[0] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[0] & BLOCK_2[0]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0] & BLOCK_6[0]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0] & BLOCK_6[0] & BLOCK_7[0]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0] & BLOCK_6[0] & BLOCK_7[0] & BLOCK_8[0]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0] & BLOCK_6[0] & BLOCK_7[0] & BLOCK_8[0] & BLOCK_9[0]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14)) || (BLOCK_10[0] == 1'b1 && hcounter == 4'd15)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd1:   
                    if((BLOCK_1[1] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[1] & BLOCK_2[1]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1] & BLOCK_6[1]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1] & BLOCK_6[1] & BLOCK_7[1]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1] & BLOCK_6[1] & BLOCK_7[1] & BLOCK_8[1]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1] & BLOCK_6[1] & BLOCK_7[1] & BLOCK_8[1] & BLOCK_9[1]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14)) || (BLOCK_10[1] == 1'b1 && hcounter == 4'd15)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd2:   
                    if((BLOCK_1[2] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[2] & BLOCK_2[2]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2] & BLOCK_6[2]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2] & BLOCK_6[2] & BLOCK_7[2]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2] & BLOCK_6[2] & BLOCK_7[2] & BLOCK_8[2]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2] & BLOCK_6[2] & BLOCK_7[2] & BLOCK_8[2] & BLOCK_9[2]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14)) || (BLOCK_10[2] == 1'b1 && hcounter == 4'd15)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end 
                4'd3:   
                    if((BLOCK_1[3] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[3] & BLOCK_2[3]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3] & BLOCK_6[3]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3] & BLOCK_6[3] & BLOCK_7[3]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3] & BLOCK_6[3] & BLOCK_7[3] & BLOCK_8[3]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3] & BLOCK_6[3] & BLOCK_7[3] & BLOCK_8[3] & BLOCK_9[3]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14)) || (BLOCK_10[3] == 1'b1 && hcounter == 4'd15)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd4:   
                    if((BLOCK_1[4] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[4] & BLOCK_2[4]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4] & BLOCK_6[4]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4] & BLOCK_6[4] & BLOCK_7[4]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4] & BLOCK_6[4] & BLOCK_7[4] & BLOCK_8[4]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4] & BLOCK_6[4] & BLOCK_7[4] & BLOCK_8[4] & BLOCK_9[4]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14)) || (BLOCK_10[4] == 1'b1 && hcounter == 4'd15)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd5:   
                    if((BLOCK_1[5] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[5] & BLOCK_2[5]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5] & BLOCK_6[5]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5] & BLOCK_6[5] & BLOCK_7[5]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5] & BLOCK_6[5] & BLOCK_7[5] & BLOCK_8[5]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5] & BLOCK_6[5] & BLOCK_7[5] & BLOCK_8[5] & BLOCK_9[5]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14)) || (BLOCK_10[5] == 1'b1 && hcounter == 4'd15)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd6:   
                    if((BLOCK_1[6] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[6] & BLOCK_2[6]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6] & BLOCK_6[6]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6] & BLOCK_6[6] & BLOCK_7[6]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6] & BLOCK_6[6] & BLOCK_7[6] & BLOCK_8[6]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6] & BLOCK_6[6] & BLOCK_7[6] & BLOCK_8[6] & BLOCK_9[6]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14)) || (BLOCK_10[6] == 1'b1 && hcounter == 4'd15)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd7:   
                    if((BLOCK_1[7] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[7] & BLOCK_2[7]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7] & BLOCK_6[7]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7] & BLOCK_6[7] & BLOCK_7[7]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7] & BLOCK_6[7] & BLOCK_7[7] & BLOCK_8[7]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7] & BLOCK_6[7] & BLOCK_7[7] & BLOCK_8[7] & BLOCK_9[7]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14)) || (BLOCK_10[7] == 1'b1 && hcounter == 4'd15)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end 
                4'd8:   
                    if((BLOCK_1[8] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[8] & BLOCK_2[8]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8] & BLOCK_6[8]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8] & BLOCK_6[8] & BLOCK_7[8]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8] & BLOCK_6[8] & BLOCK_7[8] & BLOCK_8[8]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8] & BLOCK_6[8] & BLOCK_7[8] & BLOCK_8[8] & BLOCK_9[8]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14)) || (BLOCK_10[8] == 1'b1 && hcounter == 4'd15)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd9:   
                    if((BLOCK_1[9] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[9] & BLOCK_2[9]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9] & BLOCK_6[9]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9] & BLOCK_6[9] & BLOCK_7[9]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9] & BLOCK_6[9] & BLOCK_7[9] & BLOCK_8[9]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9] & BLOCK_6[9] & BLOCK_7[9] & BLOCK_8[9] & BLOCK_9[9]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14)) || (BLOCK_10[9] == 1'b1 && hcounter == 4'd15)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd10:   
                    if((BLOCK_1[10] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[10] & BLOCK_2[10]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10] & BLOCK_6[10]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10] & BLOCK_6[10] & BLOCK_7[10]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10] & BLOCK_6[10] & BLOCK_7[10] & BLOCK_8[10]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10] & BLOCK_6[10] & BLOCK_7[10] & BLOCK_8[10] & BLOCK_9[10]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14)) || (BLOCK_10[10] == 1'b1 && hcounter == 4'd15)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd11:   
                    if((BLOCK_1[11] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[11] & BLOCK_2[11]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11] & BLOCK_6[11]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11] & BLOCK_6[11] & BLOCK_7[11]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11] & BLOCK_6[11] & BLOCK_7[11] & BLOCK_8[11]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11] & BLOCK_6[11] & BLOCK_7[11] & BLOCK_8[11] & BLOCK_9[11]) == 1'b1) && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14)) || (BLOCK_10[11] == 1'b1 && hcounter == 4'd15)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                default:
                    {R_out, G_out, B_out} <= 12'b0;
            endcase
        end else if(fin_9 == 1'b1) begin
            case(vcounter)
                4'd0:   
                    if((BLOCK_1[0] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[0] & BLOCK_2[0]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0] & BLOCK_6[0]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0] & BLOCK_6[0] & BLOCK_7[0]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0] & BLOCK_6[0] & BLOCK_7[0] & BLOCK_8[0]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (BLOCK_9[0] == 1'b1 && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd1:   
                    if((BLOCK_1[1] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[1] & BLOCK_2[1]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1] & BLOCK_6[1]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1] & BLOCK_6[1] & BLOCK_7[1]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1] & BLOCK_6[1] & BLOCK_7[1] & BLOCK_8[1]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (BLOCK_9[1] == 1'b1 && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd2:   
                    if((BLOCK_1[2] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[2] & BLOCK_2[2]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2] & BLOCK_6[2]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2] & BLOCK_6[2] & BLOCK_7[2]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2] & BLOCK_6[2] & BLOCK_7[2] & BLOCK_8[2]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (BLOCK_9[2] == 1'b1 && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end 
                4'd3:   
                    if((BLOCK_1[3] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[3] & BLOCK_2[3]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3] & BLOCK_6[3]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3] & BLOCK_6[3] & BLOCK_7[3]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3] & BLOCK_6[3] & BLOCK_7[3] & BLOCK_8[3]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (BLOCK_9[3] == 1'b1 && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd4:   
                    if((BLOCK_1[4] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[4] & BLOCK_2[4]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4] & BLOCK_6[4]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4] & BLOCK_6[4] & BLOCK_7[4]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4] & BLOCK_6[4] & BLOCK_7[4] & BLOCK_8[4]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (BLOCK_9[4] == 1'b1 && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd5:   
                    if((BLOCK_1[5] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[5] & BLOCK_2[5]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5] & BLOCK_6[5]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5] & BLOCK_6[5] & BLOCK_7[5]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5] & BLOCK_6[5] & BLOCK_7[5] & BLOCK_8[5]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (BLOCK_9[5] == 1'b1 && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd6:   
                    if((BLOCK_1[6] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[6] & BLOCK_2[6]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6] & BLOCK_6[6]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6] & BLOCK_6[6] & BLOCK_7[6]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6] & BLOCK_6[6] & BLOCK_7[6] & BLOCK_8[6]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (BLOCK_9[6] == 1'b1 && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd7:   
                    if((BLOCK_1[7] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[7] & BLOCK_2[7]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7] & BLOCK_6[7]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7] & BLOCK_6[7] & BLOCK_7[7]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7] & BLOCK_6[7] & BLOCK_7[7] & BLOCK_8[7]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (BLOCK_9[7] == 1'b1 && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end 
                4'd8:   
                    if((BLOCK_1[8] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[8] & BLOCK_2[8]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8] & BLOCK_6[8]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8] & BLOCK_6[8] & BLOCK_7[8]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8] & BLOCK_6[8] & BLOCK_7[8] & BLOCK_8[8]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (BLOCK_9[8] == 1'b1 && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd9:   
                    if((BLOCK_1[9] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[9] & BLOCK_2[9]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9] & BLOCK_6[9]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9] & BLOCK_6[9] & BLOCK_7[9]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9] & BLOCK_6[9] & BLOCK_7[9] & BLOCK_8[9]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (BLOCK_9[9] == 1'b1 && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd10:   
                    if((BLOCK_1[10] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[10] & BLOCK_2[10]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10] & BLOCK_6[10]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10] & BLOCK_6[10] & BLOCK_7[10]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10] & BLOCK_6[10] & BLOCK_7[10] & BLOCK_8[10]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (BLOCK_9[10] == 1'b1 && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd11:   
                    if((BLOCK_1[11] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[11] & BLOCK_2[11]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11] & BLOCK_6[11]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11] & BLOCK_6[11] & BLOCK_7[11]) == 1'b1) && hcounter == 4'd9) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11] & BLOCK_6[11] & BLOCK_7[11] & BLOCK_8[11]) == 1'b1) && (hcounter == 4'd10 || hcounter == 4'd11)) || (BLOCK_9[11] == 1'b1 && (hcounter == 4'd12 || hcounter == 4'd13 || hcounter == 4'd14))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                default:
                    {R_out, G_out, B_out} <= 12'b0;
            endcase
        end else if(fin_8 == 1'b1) begin
            case(vcounter)
                4'd0:   
                    if((BLOCK_1[0] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[0] & BLOCK_2[0]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0] & BLOCK_6[0]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0] & BLOCK_6[0] & BLOCK_7[0]) == 1'b1) && hcounter == 4'd9) || (BLOCK_8[0] == 1'b1 && (hcounter == 4'd10 || hcounter == 4'd11))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd1:   
                    if((BLOCK_1[1] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[1] & BLOCK_2[1]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1] & BLOCK_6[1]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1] & BLOCK_6[1] & BLOCK_7[1]) == 1'b1) && hcounter == 4'd9) || (BLOCK_8[1] == 1'b1 && (hcounter == 4'd10 || hcounter == 4'd11))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd2:   
                    if((BLOCK_1[2] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[2] & BLOCK_2[2]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2] & BLOCK_6[2]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2] & BLOCK_6[2] & BLOCK_7[2]) == 1'b1) && hcounter == 4'd9) || (BLOCK_8[2] == 1'b1 && (hcounter == 4'd10 || hcounter == 4'd11))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end 
                4'd3:   
                    if((BLOCK_1[3] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[3] & BLOCK_2[3]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3] & BLOCK_6[3]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3] & BLOCK_6[3] & BLOCK_7[3]) == 1'b1) && hcounter == 4'd9) || (BLOCK_8[3] == 1'b1 && (hcounter == 4'd10 || hcounter == 4'd11))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd4:   
                    if((BLOCK_1[4] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[4] & BLOCK_2[4]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4] & BLOCK_6[4]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4] & BLOCK_6[4] & BLOCK_7[4]) == 1'b1) && hcounter == 4'd9) || (BLOCK_8[4] == 1'b1 && (hcounter == 4'd10 || hcounter == 4'd11))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd5:   
                    if((BLOCK_1[5] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[5] & BLOCK_2[5]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5] & BLOCK_6[5]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5] & BLOCK_6[5] & BLOCK_7[5]) == 1'b1) && hcounter == 4'd9) || (BLOCK_8[5] == 1'b1 && (hcounter == 4'd10 || hcounter == 4'd11))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd6:   
                    if((BLOCK_1[6] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[6] & BLOCK_2[6]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6] & BLOCK_6[6]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6] & BLOCK_6[6] & BLOCK_7[6]) == 1'b1) && hcounter == 4'd9) || (BLOCK_8[6] == 1'b1 && (hcounter == 4'd10 || hcounter == 4'd11))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd7:   
                    if((BLOCK_1[7] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[7] & BLOCK_2[7]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7] & BLOCK_6[7]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7] & BLOCK_6[7] & BLOCK_7[7]) == 1'b1) && hcounter == 4'd9) || (BLOCK_8[7] == 1'b1 && (hcounter == 4'd10 || hcounter == 4'd11))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end 
                4'd8:   
                    if((BLOCK_1[8] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[8] & BLOCK_2[8]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8] & BLOCK_6[8]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8] & BLOCK_6[8] & BLOCK_7[8]) == 1'b1) && hcounter == 4'd9) || (BLOCK_8[8] == 1'b1 && (hcounter == 4'd10 || hcounter == 4'd11))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd9:   
                    if((BLOCK_1[9] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[9] & BLOCK_2[9]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9] & BLOCK_6[9]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9] & BLOCK_6[9] & BLOCK_7[9]) == 1'b1) && hcounter == 4'd9) || (BLOCK_8[9] == 1'b1 && (hcounter == 4'd10 || hcounter == 4'd11))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd10:   
                    if((BLOCK_1[10] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[10] & BLOCK_2[10]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10] & BLOCK_6[10]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10] & BLOCK_6[10] & BLOCK_7[10]) == 1'b1) && hcounter == 4'd9) || (BLOCK_8[10] == 1'b1 && (hcounter == 4'd10 || hcounter == 4'd11))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd11:   
                    if((BLOCK_1[11] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[11] & BLOCK_2[11]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11] & BLOCK_6[11]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11] & BLOCK_6[11] & BLOCK_7[11]) == 1'b1) && hcounter == 4'd9) || (BLOCK_8[11] == 1'b1 && (hcounter == 4'd10 || hcounter == 4'd11))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                default:
                    {R_out, G_out, B_out} <= 12'b0;
            endcase
        end else if(fin_7 == 1'b1) begin
            case(vcounter)
                4'd0:   
                    if((BLOCK_1[0] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[0] & BLOCK_2[0]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0] & BLOCK_6[0]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (BLOCK_7[0] == 1'b1 && hcounter == 4'd9)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd1:   
                    if((BLOCK_1[1] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[1] & BLOCK_2[1]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1] & BLOCK_6[1]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (BLOCK_7[1] == 1'b1 && hcounter == 4'd9)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd2:   
                    if((BLOCK_1[2] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[2] & BLOCK_2[2]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2] & BLOCK_6[2]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (BLOCK_7[2] == 1'b1 && hcounter == 4'd9)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end 
                4'd3:   
                    if((BLOCK_1[3] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[3] & BLOCK_2[3]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3] & BLOCK_6[3]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (BLOCK_7[3] == 1'b1 && hcounter == 4'd9)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd4:   
                    if((BLOCK_1[4] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[4] & BLOCK_2[4]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4] & BLOCK_6[4]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (BLOCK_7[4] == 1'b1 && hcounter == 4'd9)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd5:   
                    if((BLOCK_1[5] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[5] & BLOCK_2[5]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5] & BLOCK_6[5]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (BLOCK_7[5] == 1'b1 && hcounter == 4'd9)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd6:   
                    if((BLOCK_1[6] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[6] & BLOCK_2[6]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6] & BLOCK_6[6]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (BLOCK_7[6] == 1'b1 && hcounter == 4'd9)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd7:   
                    if((BLOCK_1[7] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[7] & BLOCK_2[7]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7] & BLOCK_6[7]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (BLOCK_7[7] == 1'b1 && hcounter == 4'd9)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end 
                4'd8:   
                    if((BLOCK_1[8] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[8] & BLOCK_2[8]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8] & BLOCK_6[8]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (BLOCK_7[8] == 1'b1 && hcounter == 4'd9)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd9:   
                    if((BLOCK_1[9] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[9] & BLOCK_2[9]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9] & BLOCK_6[9]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (BLOCK_7[9] == 1'b1 && hcounter == 4'd9)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd10:   
                    if((BLOCK_1[10] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[10] & BLOCK_2[10]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10] & BLOCK_6[10]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (BLOCK_7[10] == 1'b1 && hcounter == 4'd9)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd11:   
                    if((BLOCK_1[11] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[11] & BLOCK_2[11]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11]) == 1'b1) && hcounter == 4'd4) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11] & BLOCK_6[11]) == 1'b1) && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8)) || (BLOCK_7[11] == 1'b1 && hcounter == 4'd9)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                default:
                    {R_out, G_out, B_out} <= 12'b0;
            endcase
        end else if(fin_6 == 1'b1) begin
            case(vcounter)
                4'd0:   
                    if((BLOCK_1[0] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[0] & BLOCK_2[0]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0] & BLOCK_5[0]) == 1'b1) && hcounter == 4'd4) || (BLOCK_6[0] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd1:   
                    if((BLOCK_1[1] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[1] & BLOCK_2[1]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1] & BLOCK_5[1]) == 1'b1) && hcounter == 4'd4) || (BLOCK_6[1] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd2:   
                    if((BLOCK_1[2] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[2] & BLOCK_2[2]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2] & BLOCK_5[2]) == 1'b1) && hcounter == 4'd4) || (BLOCK_6[2] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end 
                4'd3:   
                    if((BLOCK_1[3] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[3] & BLOCK_2[3]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3] & BLOCK_5[3]) == 1'b1) && hcounter == 4'd4) || (BLOCK_6[3] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd4:   
                    if((BLOCK_1[4] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[4] & BLOCK_2[4]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4] & BLOCK_5[4]) == 1'b1) && hcounter == 4'd4) || (BLOCK_6[4] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd5:   
                    if((BLOCK_1[5] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[5] & BLOCK_2[5]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5] & BLOCK_5[5]) == 1'b1) && hcounter == 4'd4) || (BLOCK_6[5] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd6:   
                    if((BLOCK_1[6] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[6] & BLOCK_2[6]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6] & BLOCK_5[6]) == 1'b1) && hcounter == 4'd4) || (BLOCK_6[6] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd7:   
                    if((BLOCK_1[7] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[7] & BLOCK_2[7]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7] & BLOCK_5[7]) == 1'b1) && hcounter == 4'd4) || (BLOCK_6[7] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end 
                4'd8:   
                    if((BLOCK_1[8] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[8] & BLOCK_2[8]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8] & BLOCK_5[8]) == 1'b1) && hcounter == 4'd4) || (BLOCK_6[8] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd9:   
                    if((BLOCK_1[9] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[9] & BLOCK_2[9]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9] & BLOCK_5[9]) == 1'b1) && hcounter == 4'd4) || (BLOCK_6[9] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd10:   
                    if((BLOCK_1[10] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[10] & BLOCK_2[10]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10] & BLOCK_5[10]) == 1'b1) && hcounter == 4'd4) || (BLOCK_6[10] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd11:   
                    if((BLOCK_1[11] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[11] & BLOCK_2[11]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11]) == 1'b1) && hcounter == 4'd3) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11] & BLOCK_5[11]) == 1'b1) && hcounter == 4'd4) || (BLOCK_6[11] == 1'b1 && (hcounter == 4'd5 || hcounter == 4'd6 || hcounter == 4'd7 || hcounter == 4'd8))) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                default:
                    {R_out, G_out, B_out} <= 12'b0;
            endcase
        end else if(fin_5 == 1'b1) begin
            case(vcounter)
                4'd0:   
                    if((BLOCK_1[0] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[0] & BLOCK_2[0]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0] & BLOCK_4[0]) == 1'b1) && hcounter == 4'd3) || (BLOCK_5[0] == 1'b1 && hcounter == 4'd4)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd1:   
                    if((BLOCK_1[1] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[1] & BLOCK_2[1]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1] & BLOCK_4[1]) == 1'b1) && hcounter == 4'd3) || (BLOCK_5[1] == 1'b1 && hcounter == 4'd4)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd2:   
                    if((BLOCK_1[2] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[2] & BLOCK_2[2]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2] & BLOCK_4[2]) == 1'b1) && hcounter == 4'd3) || (BLOCK_5[2] == 1'b1 && hcounter == 4'd4)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end 
                4'd3:   
                    if((BLOCK_1[3] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[3] & BLOCK_2[3]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3] & BLOCK_4[3]) == 1'b1) && hcounter == 4'd3) || (BLOCK_5[3] == 1'b1 && hcounter == 4'd4)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd4:   
                    if((BLOCK_1[4] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[4] & BLOCK_2[4]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4] & BLOCK_4[4]) == 1'b1) && hcounter == 4'd3) || (BLOCK_5[4] == 1'b1 && hcounter == 4'd4)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd5:   
                    if((BLOCK_1[5] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[5] & BLOCK_2[5]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5] & BLOCK_4[5]) == 1'b1) && hcounter == 4'd3) || (BLOCK_5[5] == 1'b1 && hcounter == 4'd4)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd6:   
                    if((BLOCK_1[6] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[6] & BLOCK_2[6]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6] & BLOCK_4[6]) == 1'b1) && hcounter == 4'd3) || (BLOCK_5[6] == 1'b1 && hcounter == 4'd4)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd7:   
                    if((BLOCK_1[7] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[7] & BLOCK_2[7]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7] & BLOCK_4[7]) == 1'b1) && hcounter == 4'd3) || (BLOCK_5[7] == 1'b1 && hcounter == 4'd4)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end 
                4'd8:   
                    if((BLOCK_1[8] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[8] & BLOCK_2[8]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8] & BLOCK_4[8]) == 1'b1) && hcounter == 4'd3) || (BLOCK_5[8] == 1'b1 && hcounter == 4'd4)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd9:   
                    if((BLOCK_1[9] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[9] & BLOCK_2[9]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9] & BLOCK_4[9]) == 1'b1) && hcounter == 4'd3) || (BLOCK_5[9] == 1'b1 && hcounter == 4'd4)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd10:   
                    if((BLOCK_1[10] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[10] & BLOCK_2[10]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10] & BLOCK_4[10]) == 1'b1) && hcounter == 4'd3) || (BLOCK_5[10] == 1'b1 && hcounter == 4'd4)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd11:   
                    if((BLOCK_1[11] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[11] & BLOCK_2[11]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11]) == 1'b1) && hcounter == 4'd2) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11] & BLOCK_4[11]) == 1'b1) && hcounter == 4'd3) || (BLOCK_5[11] == 1'b1 && hcounter == 4'd4)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                default:
                    {R_out, G_out, B_out} <= 12'b0;
            endcase
        end else if(fin_4 == 1'b1) begin
            case(vcounter)
                4'd0:   
                    if((BLOCK_1[0] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[0] & BLOCK_2[0]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[0] & BLOCK_2[0] & BLOCK_3[0]) == 1'b1) && hcounter == 4'd2) || (BLOCK_4[0] == 1'b1 && hcounter == 4'd3)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd1:   
                    if((BLOCK_1[1] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[1] & BLOCK_2[1]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[1] & BLOCK_2[1] & BLOCK_3[1]) == 1'b1) && hcounter == 4'd2) || (BLOCK_4[1] == 1'b1 && hcounter == 4'd3)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd2:   
                    if((BLOCK_1[2] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[2] & BLOCK_2[2]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[2] & BLOCK_2[2] & BLOCK_3[2]) == 1'b1) && hcounter == 4'd2) || (BLOCK_4[2] == 1'b1 && hcounter == 4'd3)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end 
                4'd3:   
                    if((BLOCK_1[3] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[3] & BLOCK_2[3]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[3] & BLOCK_2[3] & BLOCK_3[3]) == 1'b1) && hcounter == 4'd2) || (BLOCK_4[3] == 1'b1 && hcounter == 4'd3)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd4:   
                    if((BLOCK_1[4] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[4] & BLOCK_2[4]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[4] & BLOCK_2[4] & BLOCK_3[4]) == 1'b1) && hcounter == 4'd2) || (BLOCK_4[4] == 1'b1 && hcounter == 4'd3)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd5:   
                    if((BLOCK_1[5] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[5] & BLOCK_2[5]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[5] & BLOCK_2[5] & BLOCK_3[5]) == 1'b1) && hcounter == 4'd2) || (BLOCK_4[5] == 1'b1 && hcounter == 4'd3)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd6:   
                    if((BLOCK_1[6] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[6] & BLOCK_2[6]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[6] & BLOCK_2[6] & BLOCK_3[6]) == 1'b1) && hcounter == 4'd2) || (BLOCK_4[6] == 1'b1 && hcounter == 4'd3)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd7:   
                    if((BLOCK_1[7] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[7] & BLOCK_2[7]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[7] & BLOCK_2[7] & BLOCK_3[7]) == 1'b1) && hcounter == 4'd2) || (BLOCK_4[7] == 1'b1 && hcounter == 4'd3)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end 
                4'd8:   
                    if((BLOCK_1[8] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[8] & BLOCK_2[8]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[8] & BLOCK_2[8] & BLOCK_3[8]) == 1'b1) && hcounter == 4'd2) || (BLOCK_4[8] == 1'b1 && hcounter == 4'd3)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd9:   
                    if((BLOCK_1[9] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[9] & BLOCK_2[9]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[9] & BLOCK_2[9] & BLOCK_3[9]) == 1'b1) && hcounter == 4'd2) || (BLOCK_4[9] == 1'b1 && hcounter == 4'd3)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd10:   
                    if((BLOCK_1[10] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[10] & BLOCK_2[10]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[10] & BLOCK_2[10] & BLOCK_3[10]) == 1'b1) && hcounter == 4'd2) || (BLOCK_4[10] == 1'b1 && hcounter == 4'd3)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd11:   
                    if((BLOCK_1[11] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[11] & BLOCK_2[11]) == 1'b1) && hcounter == 4'd1) || (((BLOCK_1[11] & BLOCK_2[11] & BLOCK_3[11]) == 1'b1) && hcounter == 4'd2) || (BLOCK_4[11] == 1'b1 && hcounter == 4'd3)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                default:
                    {R_out, G_out, B_out} <= 12'b0;
            endcase
        end else if(fin_3 == 1'b1) begin
            case(vcounter)
                4'd0:   
                    if((BLOCK_1[0] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[0] & BLOCK_2[0]) == 1'b1) && hcounter == 4'd1) || (BLOCK_3[0] == 1'b1 && hcounter == 4'd2)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd1:   
                    if((BLOCK_1[1] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[1] & BLOCK_2[1]) == 1'b1) && hcounter == 4'd1) || (BLOCK_3[1] == 1'b1 && hcounter == 4'd2)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd2:   
                    if((BLOCK_1[2] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[2] & BLOCK_2[2]) == 1'b1) && hcounter == 4'd1) || (BLOCK_3[2] == 1'b1 && hcounter == 4'd2)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end 
                4'd3:   
                    if((BLOCK_1[3] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[3] & BLOCK_2[3]) == 1'b1) && hcounter == 4'd1) || (BLOCK_3[3] == 1'b1 && hcounter == 4'd2)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd4:   
                    if((BLOCK_1[4] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[4] & BLOCK_2[4]) == 1'b1) && hcounter == 4'd1) || (BLOCK_3[4] == 1'b1 && hcounter == 4'd2)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd5:   
                    if((BLOCK_1[5] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[5] & BLOCK_2[5]) == 1'b1) && hcounter == 4'd1) || (BLOCK_3[5] == 1'b1 && hcounter == 4'd2)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd6:   
                    if((BLOCK_1[6] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[6] & BLOCK_2[6]) == 1'b1) && hcounter == 4'd1) || (BLOCK_3[6] == 1'b1 && hcounter == 4'd2)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd7:   
                    if((BLOCK_1[7] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[7] & BLOCK_2[7]) == 1'b1) && hcounter == 4'd1) || (BLOCK_3[7] == 1'b1 && hcounter == 4'd2)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end 
                4'd8:   
                    if((BLOCK_1[8] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[8] & BLOCK_2[8]) == 1'b1) && hcounter == 4'd1) || (BLOCK_3[8] == 1'b1 && hcounter == 4'd2)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd9:   
                    if((BLOCK_1[9] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[9] & BLOCK_2[9]) == 1'b1) && hcounter == 4'd1) || (BLOCK_3[9] == 1'b1 && hcounter == 4'd2)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd10:   
                    if((BLOCK_1[10] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[10] & BLOCK_2[10]) == 1'b1) && hcounter == 4'd1) || (BLOCK_3[10] == 1'b1 && hcounter == 4'd2)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd11:   
                    if((BLOCK_1[11] == 1'b1 && hcounter == 4'd0) || (((BLOCK_1[11] & BLOCK_2[11]) == 1'b1) && hcounter == 4'd1) || (BLOCK_3[11] == 1'b1 && hcounter == 4'd2)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                default:
                    {R_out, G_out, B_out} <= 12'b0;
            endcase
        end else if(fin_2 == 1'b1) begin
            case(vcounter)
                4'd0:   
                    if((BLOCK_1[0] == 1'b1 && hcounter == 4'd0) || (BLOCK_2[0] == 1'b1 && hcounter == 4'd1)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd1:   
                    if((BLOCK_1[1] == 1'b1 && hcounter == 4'd0) || (BLOCK_2[1] == 1'b1 && hcounter == 4'd1)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd2:   
                    if((BLOCK_1[2] == 1'b1 && hcounter == 4'd0) || (BLOCK_2[2] == 1'b1 && hcounter == 4'd1)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end 
                4'd3:   
                    if((BLOCK_1[3] == 1'b1 && hcounter == 4'd0) || (BLOCK_2[3] == 1'b1 && hcounter == 4'd1)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd4:   
                    if((BLOCK_1[4] == 1'b1 && hcounter == 4'd0) || (BLOCK_2[4] == 1'b1 && hcounter == 4'd1)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd5:   
                    if((BLOCK_1[5] == 1'b1 && hcounter == 4'd0) || (BLOCK_2[5] == 1'b1 && hcounter == 4'd1)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd6:   
                    if((BLOCK_1[6] == 1'b1 && hcounter == 4'd0) || (BLOCK_2[6] == 1'b1 && hcounter == 4'd1)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd7:   
                    if((BLOCK_1[7] == 1'b1 && hcounter == 4'd0) || (BLOCK_2[7] == 1'b1 && hcounter == 4'd1)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end 
                4'd8:   
                    if((BLOCK_1[8] == 1'b1 && hcounter == 4'd0) || (BLOCK_2[8] == 1'b1 && hcounter == 4'd1)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd9:   
                    if((BLOCK_1[9] == 1'b1 && hcounter == 4'd0) || (BLOCK_2[9] == 1'b1 && hcounter == 4'd1)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd10:   
                    if((BLOCK_1[10] == 1'b1 && hcounter == 4'd0) || (BLOCK_2[10] == 1'b1 && hcounter == 4'd1)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd11:   
                    if((BLOCK_1[11] == 1'b1 && hcounter == 4'd0) || (BLOCK_2[11] == 1'b1 && hcounter == 4'd1)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                default:
                    {R_out, G_out, B_out} <= 12'b0;
            endcase
        end else if(fin_1 == 1'b1) begin
            case(vcounter)
                4'd0:   
                    if((BLOCK_1[0] == 1'b1 && hcounter == 4'd0)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd1:   
                    if((BLOCK_1[1] == 1'b1 && hcounter == 4'd0)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd2:   
                    if((BLOCK_1[2] == 1'b1 && hcounter == 4'd0)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end 
                4'd3:   
                    if((BLOCK_1[3] == 1'b1 && hcounter == 4'd0)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd4:   
                    if((BLOCK_1[4] == 1'b1 && hcounter == 4'd0)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd5:   
                    if((BLOCK_1[5] == 1'b1 && hcounter == 4'd0)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd6:   
                    if((BLOCK_1[6] == 1'b1 && hcounter == 4'd0)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd7:   
                    if((BLOCK_1[7] == 1'b1 && hcounter == 4'd0)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end 
                4'd8:   
                    if((BLOCK_1[8] == 1'b1 && hcounter == 4'd0)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd9:   
                    if((BLOCK_1[9] == 1'b1 && hcounter == 4'd0)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd10:   
                    if((BLOCK_1[10] == 1'b1 && hcounter == 4'd0)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                4'd11:   
                    if((BLOCK_1[11] == 1'b1 && hcounter == 4'd0)) begin
                        {R_out, G_out, B_out} <= 12'b1111_1111_0000;
                    end else begin
                        {R_out, G_out, B_out} <= 12'b0;
                    end
                default:
                    {R_out, G_out, B_out} <= 12'b0;
            endcase
        end
    end

    wire [9:0] iHCNT = HCNT - HBLANK - 10'd70;
    wire [9:0] iVCNT = VCNT - VBLANK - 10'd160;
    
    wire disp_enable2 = (VBLANK + 10'd160 < VCNT) && (HBLANK - 10'd1 + 10'd70 < HCNT) && (HCNT < HPERIOD - 10'd1) && (HBLANK - 10'd1 + 10'd570 > HCNT) && (VBLANK + 10'd320 > VCNT);
   
    wire [499:0] cgout;
    wire [8:0] vdotcnt = iVCNT[8:0];

    CGROM GAME_OVER(.addra(vdotcnt + 9'd320), .douta(cgout), .clka(PCK));

    reg [499:0] sreg;
    wire sregld = (iHCNT == 10'd498);

    always @(posedge PCK) begin
        if(RST == 1'b1) begin
            sreg <= 500'b0;
        end else if(sregld) begin
            sreg <= cgout;
        end else if(disp_enable2) begin
            sreg <= {sreg[498:0], 1'b0};
        end
    end
    
    always @(posedge PCK) begin
        if(flag == 1'b1) begin
            if(RST == 1'b1) begin
                {VGA_R, VGA_G, VGA_B} <= 12'b0;
            end else if(disp_change == 1'b1) begin
                if(disp_enable1 == 1'b1) begin
                    {VGA_R, VGA_G, VGA_B} <= {R_out, G_out, B_out};  
                end else begin
                    {VGA_R, VGA_G, VGA_B} <= 12'b0;
                end
            end else begin
                if(disp_enable2 == 1'b1) begin
                    if(sreg[499] == 1'b1) begin
                        {VGA_R, VGA_G, VGA_B} <= {12{sreg[499]}}; 
                    end else begin
                        {VGA_R, VGA_G, VGA_B} <= 12'b1111_0000_0000; 
                    end
                end else begin
                    {VGA_R, VGA_G, VGA_B} <= 12'b0;
                end
            end
        end
    end
    
endmodule
