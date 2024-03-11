//
// Copyright 2024 Tobias Strauch, Munich, Bavaria
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module PMEM (
   output [31 : 0] instr,
   input ic1_c_axi_mst_wr_valid,
   input ic0_c_axi_mst_rd,
   input [31 : 0] ic1_axi_mst_wr_addr,
   input [31 : 0] ic1_axi_mst_wr_data,
   input clk,
   input [16 : 0] pc);

reg  [31 : 0] instr;
reg  [15 : 0] instrh;
reg  [15 : 0] instrl;
reg  [14 : 0] pch;
reg  [14 : 0] pcl;

reg c_pmem_wr;

assign instr = pc [1] ? {instrl, instrh} : {instrh, instrl};
assign pch = pc [16 : 2];
assign pcl = pc [1] ? (pc [16 : 2] + 1) : pc [16 : 2];

assign c_pmem_wr = (ic1_c_axi_mst_wr_valid == 1);


tdp_ram_16384x16x2 progli (
   .clka(clk),
   .wea({2{c_pmem_wr}}),
   .addra(ic1_axi_mst_wr_addr[14:0]),
   .dina(ic1_axi_mst_wr_data[15:0]),
   .douta(),
   .clkb(~clk),
   .web(2'b00),
   .addrb(pcl),
   .dinb(32'h00000000),
   .doutb(instrl));

tdp_ram_16384x16x2 proghi (
   .clka(clk),
   .wea({2{c_pmem_wr}}),
   .addra(ic1_axi_mst_wr_addr[14:0]),
   .dina(ic1_axi_mst_wr_data[31:16]),
   .douta(),
   .clkb(~clk),
   .web(2'b00),
   .addrb(pch),
   .dinb(32'h00000000),
   .doutb(instrh));

endmodule