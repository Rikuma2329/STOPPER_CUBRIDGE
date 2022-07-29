`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/23 23:55:31
// Design Name: 
// Module Name: GAME_CONTROL
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

(* keep_hierarchy = "yes" *)
module GAME_CONTROL(CLK, RST, BTN, PCK, HCNT, VCNT, fin_1, fin_2, fin_3, fin_4, fin_5, fin_6, fin_7, fin_8, fin_9, fin_10, start_flag, gameover_flag, gameclear_flag,
                    VGA_R_start, VGA_G_start, VGA_B_start, VGA_R1, VGA_G1, VGA_B1, VGA_R2, VGA_G2, VGA_B2, VGA_R3, VGA_G3, VGA_B3, VGA_R4, VGA_G4, VGA_B4,
                    VGA_R5, VGA_G5, VGA_B5, VGA_R6, VGA_G6, VGA_B6, VGA_R7, VGA_G7, VGA_B7, VGA_R8, VGA_G8, VGA_B8, VGA_R9, VGA_G9, VGA_B9,
                    VGA_R10, VGA_G10, VGA_B10, VGA_R_end, VGA_G_end, VGA_B_end, VGA_R_clear, VGA_G_clear, VGA_B_clear);               
    input CLK, RST, BTN;
    input PCK;
    input [9:0] HCNT, VCNT;
    output fin_1, fin_2, fin_3, fin_4, fin_5, fin_6, fin_7, fin_8, fin_9, fin_10;
    output start_flag, gameover_flag, gameclear_flag;
    output [3:0] VGA_R_start, VGA_G_start, VGA_B_start;
    output [3:0] VGA_R1, VGA_G1, VGA_B1;
    output [3:0] VGA_R2, VGA_G2, VGA_B2;
    output [3:0] VGA_R3, VGA_G3, VGA_B3;
    output [3:0] VGA_R4, VGA_G4, VGA_B4;
    output [3:0] VGA_R5, VGA_G5, VGA_B5;
    output [3:0] VGA_R6, VGA_G6, VGA_B6;
    output [3:0] VGA_R7, VGA_G7, VGA_B7;
    output [3:0] VGA_R8, VGA_G8, VGA_B8;
    output [3:0] VGA_R9, VGA_G9, VGA_B9;
    output [3:0] VGA_R10, VGA_G10, VGA_B10;
    output [3:0] VGA_R_end, VGA_G_end, VGA_B_end;
    output [3:0] VGA_R_clear, VGA_G_clear, VGA_B_clear;

    wire [11:0] BLOCK_1, BLOCK_2, BLOCK_3, BLOCK_4, BLOCK_5, BLOCK_6, BLOCK_7, BLOCK_8, BLOCK_9, BLOCK_10;

    GAME_START game_start(CLK, RST, STOP, PCK, HCNT, VCNT, 1'b1, VGA_R_start, VGA_G_start, VGA_B_start, start_flag);
    
    BLOCK_1 block_1(CLK, RST, STOP, PCK, HCNT, VCNT, start_flag, VGA_R1, VGA_G1, VGA_B1, fin_1, BLOCK_1);
    BLOCK_2 block_2(CLK, RST, STOP, PCK, HCNT, VCNT, fin_1, BLOCK_1, VGA_R2, VGA_G2, VGA_B2, fin_2, BLOCK_2);
    BLOCK_3 block_3(CLK, RST, STOP, PCK, HCNT, VCNT, fin_2, BLOCK_1, BLOCK_2, VGA_R3, VGA_G3, VGA_B3, fin_3, BLOCK_3);
    BLOCK_4 block_4(CLK, RST, STOP, PCK, HCNT, VCNT, fin_3, BLOCK_1, BLOCK_2, BLOCK_3, VGA_R4, VGA_G4, VGA_B4, fin_4, BLOCK_4);
    BLOCK_5 block_5(CLK, RST, STOP, PCK, HCNT, VCNT, fin_4, BLOCK_1, BLOCK_2, BLOCK_3, BLOCK_4, VGA_R5, VGA_G5, VGA_B5, fin_5, BLOCK_5);
    BLOCK_6 block_6(CLK, RST, STOP, PCK, HCNT, VCNT, fin_5, BLOCK_1, BLOCK_2, BLOCK_3, BLOCK_4, BLOCK_5, VGA_R6, VGA_G6, VGA_B6, fin_6, BLOCK_6);
    BLOCK_7 block_7(CLK, RST, STOP, PCK, HCNT, VCNT, fin_6, BLOCK_1, BLOCK_2, BLOCK_3, BLOCK_4, BLOCK_5, BLOCK_6, VGA_R7, VGA_G7, VGA_B7, fin_7, BLOCK_7);
    BLOCK_8 block_8(CLK, RST, STOP, PCK, HCNT, VCNT, fin_7, BLOCK_1, BLOCK_2, BLOCK_3, BLOCK_4, BLOCK_5, BLOCK_6, BLOCK_7, VGA_R8, VGA_G8, VGA_B8, fin_8, BLOCK_8);
    BLOCK_9 block_9(CLK, RST, STOP, PCK, HCNT, VCNT, fin_8, BLOCK_1, BLOCK_2, BLOCK_3, BLOCK_4, BLOCK_5, BLOCK_6, BLOCK_7, BLOCK_8, VGA_R9, VGA_G9, VGA_B9, fin_9, BLOCK_9);
    BLOCK_10 block_10(CLK, RST, STOP, PCK, HCNT, VCNT, fin_9, BLOCK_1, BLOCK_2, BLOCK_3, BLOCK_4, BLOCK_5, BLOCK_6, BLOCK_7, BLOCK_8, BLOCK_9, VGA_R10, VGA_G10, VGA_B10, fin_10, BLOCK_10);
    
    FAILURE failure(CLK, RST, fin_1, fin_2, fin_3, fin_4, fin_5, fin_6, fin_7, fin_8, fin_9, fin_10, BLOCK_1, BLOCK_2, BLOCK_3, BLOCK_4, BLOCK_5, BLOCK_6, BLOCK_7, BLOCK_8, BLOCK_9, BLOCK_10, gameover_flag);
    GAME_OVER game_over(CLK, RST, PCK, HCNT, VCNT, gameover_flag, fin_1, fin_2, fin_3, fin_4, fin_5, fin_6, fin_7, fin_8, fin_9, fin_10, BLOCK_1, BLOCK_2, BLOCK_3, BLOCK_4, BLOCK_5, BLOCK_6, BLOCK_7, BLOCK_8, BLOCK_9, BLOCK_10, VGA_R_end, VGA_G_end, VGA_B_end);

    SUCCESS success(CLK, RST, fin_1, fin_2, fin_3, fin_4, fin_5, fin_6, fin_7, fin_8, fin_9, fin_10, BLOCK_1, BLOCK_2, BLOCK_3, BLOCK_4, BLOCK_5, BLOCK_6, BLOCK_7, BLOCK_8, BLOCK_9, BLOCK_10, gameclear_flag);
    GAME_CLEAR game_clear(CLK, RST, PCK, HCNT, VCNT, gameclear_flag, BLOCK_1, BLOCK_2, BLOCK_3, BLOCK_4, BLOCK_5, BLOCK_6, BLOCK_7, BLOCK_8, BLOCK_9, BLOCK_10, VGA_R_clear, VGA_G_clear, VGA_B_clear);

endmodule
