`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/06 10:57:14
// Design Name: 
// Module Name: GAME_START
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


module GAME_START(CLK, RST, BTN, PCK, HCNT, VCNT, flag, VGA_R, VGA_G, VGA_B, start_flag);
    input CLK, RST, BTN, PCK;
    input [9:0] HCNT, VCNT;
    input flag;
    output reg [3:0] VGA_R, VGA_G, VGA_B;
    output start_flag;
    
    `include "vga_param.vh"
    
    reg start_flag = 1'b0;
    
    always @(posedge CLK) begin
        if(flag == 1'b1) begin
            if(RST == 1'b1) begin
                start_flag <= 1'b0;
            end else begin
                if(BTN == 1'b1) begin
                    start_flag <= 1'b1;
                end
            end
        end
    end
    
    wire [9:0] HBLANK = HFRONT + HWIDTH + HBACK;
    wire [9:0] VBLANK = VFRONT + VWIDTH + VBACK;

    wire [9:0] iHCNT = HCNT - HBLANK - 10'd70;
    wire [9:0] iVCNT = VCNT - VBLANK - 10'd160;
    
    wire disp_enable = (VBLANK + 10'd160 < VCNT) && (HBLANK - 10'd1 + 10'd70 < HCNT) && (HCNT < HPERIOD - 10'd1) && (HBLANK - 10'd1 + 10'd570 > HCNT) && (VBLANK + 10'd320 > VCNT);
   
    wire [499:0] cgout;
    wire [8:0] vdotcnt = iVCNT[8:0];

    CGROM GAME_START(.addra(vdotcnt), .douta(cgout), .clka(PCK));

    reg [499:0] sreg;
    wire sregld = (iHCNT == 10'd498);

    always @(posedge PCK) begin
        if(RST == 1'b1) begin
            sreg <= 500'b0;
        end else if(sregld) begin
            sreg <= cgout;
        end else if(disp_enable) begin
            sreg <= {sreg[498:0], 1'b0};
        end
    end
    
    always @(posedge PCK) begin
        if(flag == 1'b1 && start_flag == 1'b0) begin
            if(RST == 1'b1) begin
                {VGA_R, VGA_G, VGA_B} <= 12'b0;
            end else if(disp_enable == 1'b1) begin
                {VGA_R, VGA_G, VGA_B} <= {12{sreg[499]}};  
            end else begin
                {VGA_R, VGA_G, VGA_B} <= 12'b0;
            end
        end
    end
    
    
endmodule
