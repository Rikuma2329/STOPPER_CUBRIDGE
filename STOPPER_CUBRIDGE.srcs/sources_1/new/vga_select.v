`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/23 22:59:42
// Design Name: 
// Module Name: vga_select
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


module vga_select(fin_1, fin_2, fin_3, fin_4, fin_5, fin_6, fin_7, fin_8, fin_9, fin_10, start_flag, gameover_flag, gameclear_flag,
                  VGA_R_start, VGA_G_start, VGA_B_start, VGA_R1, VGA_G1, VGA_B1, VGA_R2, VGA_G2, VGA_B2, VGA_R3, VGA_G3, VGA_B3, VGA_R4, VGA_G4, VGA_B4,
                  VGA_R5, VGA_G5, VGA_B5, VGA_R6, VGA_G6, VGA_B6, VGA_R7, VGA_G7, VGA_B7, VGA_R8, VGA_G8, VGA_B8, VGA_R9, VGA_G9, VGA_B9,
                  VGA_R10, VGA_G10, VGA_B10, VGA_R_end, VGA_G_end, VGA_B_end, VGA_R_clear, VGA_G_clear, VGA_B_clear, VGA_R_out, VGA_G_out, VGA_B_out);
    input fin_1, fin_2, fin_3, fin_4, fin_5, fin_6, fin_7, fin_8, fin_9, fin_10;
    input start_flag, gameover_flag, gameclear_flag;
    input [3:0] VGA_R_start, VGA_G_start, VGA_B_start;
    input [3:0] VGA_R1, VGA_G1, VGA_B1;
    input [3:0] VGA_R2, VGA_G2, VGA_B2;
    input [3:0] VGA_R3, VGA_G3, VGA_B3;
    input [3:0] VGA_R4, VGA_G4, VGA_B4;
    input [3:0] VGA_R5, VGA_G5, VGA_B5;
    input [3:0] VGA_R6, VGA_G6, VGA_B6;
    input [3:0] VGA_R7, VGA_G7, VGA_B7;
    input [3:0] VGA_R8, VGA_G8, VGA_B8;
    input [3:0] VGA_R9, VGA_G9, VGA_B9;
    input [3:0] VGA_R10, VGA_G10, VGA_B10;
    input [3:0] VGA_R_end, VGA_G_end, VGA_B_end;
    input [3:0] VGA_R_clear, VGA_G_clear, VGA_B_clear;
    output reg [3:0] VGA_R_out, VGA_G_out, VGA_B_out;

    always @* begin
        if(gameover_flag == 1'b1) begin
            {VGA_R_out, VGA_G_out, VGA_B_out} <= {VGA_R_end, VGA_G_end, VGA_B_end};
        end else if(gameclear_flag == 1'b1) begin
             {VGA_R_out, VGA_G_out, VGA_B_out} <= {VGA_R_clear, VGA_G_clear, VGA_B_clear};
        end else begin
            if(fin_9 == 1'b1) begin
                {VGA_R_out, VGA_G_out, VGA_B_out} <= {VGA_R10, VGA_G10, VGA_B10};
            end else if(fin_8 == 1'b1) begin
                {VGA_R_out, VGA_G_out, VGA_B_out} <= {VGA_R9, VGA_G9, VGA_B9};
            end else if(fin_7 == 1'b1) begin
                {VGA_R_out, VGA_G_out, VGA_B_out} <= {VGA_R8, VGA_G8, VGA_B8};
            end else if(fin_6 == 1'b1) begin
                {VGA_R_out, VGA_G_out, VGA_B_out} <= {VGA_R7, VGA_G7, VGA_B7};
            end else if(fin_5 == 1'b1) begin
                {VGA_R_out, VGA_G_out, VGA_B_out} <= {VGA_R6, VGA_G6, VGA_B6};
            end else if(fin_4 == 1'b1) begin
                {VGA_R_out, VGA_G_out, VGA_B_out} <= {VGA_R5, VGA_G5, VGA_B5};
            end else if(fin_3 == 1'b1) begin
                {VGA_R_out, VGA_G_out, VGA_B_out} <= {VGA_R4, VGA_G4, VGA_B4};
            end else if(fin_2 == 1'b1) begin
                {VGA_R_out, VGA_G_out, VGA_B_out} <= {VGA_R3, VGA_G3, VGA_B3};
            end else if(fin_1 == 1'b1) begin
                {VGA_R_out, VGA_G_out, VGA_B_out} <= {VGA_R2, VGA_G2, VGA_B2};
            end else if(start_flag == 1'b1) begin
                {VGA_R_out, VGA_G_out, VGA_B_out} <= {VGA_R1, VGA_G1, VGA_B1};
            end else begin
                {VGA_R_out, VGA_G_out, VGA_B_out} <= {VGA_R_start, VGA_G_start, VGA_B_start};
            end
        end
    end
endmodule
