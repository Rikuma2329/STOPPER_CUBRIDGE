`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/04/22 13:11:10
// Design Name: 
// Module Name: syncgen
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


module syncgen(CLK, RST, PCK, VGA_HS, VGA_VS, HCNT, VCNT);
    input CLK, RST;
    output PCK;
    output reg VGA_HS, VGA_VS;
    output reg [9:0] HCNT, VCNT;

    /* VGA(640�~480)�p�p�����[�^�ǂݍ��� */
    `include "vga_param.vh"
    
    /* MMCM��ڑ�����PCK�𐶐� */
    pckgen pckgen(CLK, PCK);
    
    /* �����J�E���^ */
    wire hcntend = (HCNT == HPERIOD - 10'h001);
    
    always @(posedge PCK) begin
        if(RST == 1'b1) begin
            HCNT <= 10'h000;
        end else if(hcntend == 1'b1) begin
            HCNT <= 10'h000;
        end else begin
            HCNT <= HCNT + 10'h001;
        end
    end
    
    /* �����J�E���^ */
    always @(posedge PCK) begin
        if(RST == 1'b1) begin
            VCNT <= 10'h000;
        end else if(hcntend == 1'b1) begin
            if(VCNT == VPERIOD - 10'h001) begin
                VCNT <= 10'h000;
            end else begin
                VCNT <= VCNT + 10'h001;
            end
        end
    end
 
    /* �����M�� */
    wire [9:0] hsstart = HFRONT - 10'h001;
    wire [9:0] hsend   = HFRONT + HWIDTH - 10'h001;
    wire [9:0] vsstart = VFRONT;
    wire [9:0] vsend   = VFRONT + VWIDTH;
    
    always @(posedge PCK) begin
        if(RST == 1'b1) begin
            VGA_HS <= 1'b1;
        end else if(HCNT == hsstart) begin
            VGA_HS <= 1'b0;
        end else if(HCNT == hsend)
            VGA_HS <= 1'b1;
    end
    
    always @(posedge PCK) begin
        if(RST == 1'b1) begin 
            VGA_VS <= 1'b1;
        end else if(HCNT == hsstart) begin
            if(VCNT == vsstart) begin
                VGA_VS <= 1'b0;
            end else if(VCNT == vsend) begin
                VGA_VS <= 1'b1;
            end
        end
    end
    
endmodule
