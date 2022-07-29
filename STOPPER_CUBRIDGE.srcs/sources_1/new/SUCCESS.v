`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/07 22:54:20
// Design Name: 
// Module Name: SUCCESS
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


module SUCCESS(CLK, RST, fin_1, fin_2, fin_3, fin_4, fin_5, fin_6, fin_7, fin_8, fin_9, fin_10, BLOCK_1, BLOCK_2, BLOCK_3, BLOCK_4, BLOCK_5, BLOCK_6, BLOCK_7, BLOCK_8, BLOCK_9, BLOCK_10, flag);
    input CLK, RST;
    input fin_1, fin_2, fin_3, fin_4, fin_5, fin_6, fin_7, fin_8, fin_9, fin_10;
    input [11:0] BLOCK_1, BLOCK_2, BLOCK_3, BLOCK_4, BLOCK_5, BLOCK_6, BLOCK_7, BLOCK_8, BLOCK_9, BLOCK_10;
    output reg flag = 1'b0;
    
    always @(posedge CLK) begin
        if(RST == 1'b1) begin
            flag <= 1'b0;
        end else begin
            if((fin_10 == 1'b1) && ((BLOCK_1 & BLOCK_2 & BLOCK_3 & BLOCK_4 & BLOCK_5 & BLOCK_6 & BLOCK_7 & BLOCK_8 & BLOCK_9 & BLOCK_10) != 12'b0)) begin
                 flag <= 1'b1;
            end
        end
    end
            
endmodule
