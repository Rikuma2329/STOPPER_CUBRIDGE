`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/28 12:19:01
// Design Name: 
// Module Name: BLOCK_1_tb
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


module BLOCK_1_tb;
    reg CLK = 1, RST = 1;
    reg BTN = 0;
    wire [3:0] VGA_R, VGA_G, VGA_B;
    wire flag;
    wire [11:0] BLOCK;
    wire VGA_HS, VGA_VS;
    
    BLOCK_1 block_1(CLK, RST, BTN, 1'b1, VGA_R1, VGA_G1, VGA_B1, VGA_HS1, VGA_VS1, fin_1, BLOCK_1);
    
    initial begin 
        #1
        RST <= 0;
        
        #300
        BTN <= 1;
        
        #1000000
        $finish;
    end
    
    always #0.001 begin
        CLK <= ~CLK;
    end
    
    always @(fin_1, BLOCK_1) begin
        $display("fin_1 = %d", fin_1);
    end

endmodule
