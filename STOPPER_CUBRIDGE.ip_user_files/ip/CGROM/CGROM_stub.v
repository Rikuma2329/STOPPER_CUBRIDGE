// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Fri May 14 14:49:51 2021
// Host        : DESKTOP-HNHOAVF running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               f:/rikuma/OneDrive/Vivado/STOPPER_CUBRIDGE/STOPPER_CUBRIDGE.gen/sources_1/ip/CGROM/CGROM_stub.v
// Design      : CGROM
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.2" *)
module CGROM(clka, addra, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,addra[8:0],douta[499:0]" */;
  input clka;
  input [8:0]addra;
  output [499:0]douta;
endmodule
