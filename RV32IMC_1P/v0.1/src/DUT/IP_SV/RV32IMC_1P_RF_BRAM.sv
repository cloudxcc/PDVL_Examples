//
// Copyright 2024 Tobias Strauch, Munich, Bavaria
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module RV32IMC_1P_RF (
   input c_rf_write,
   input [31 : 0] rd_dati,
   input [4 : 0] rd_addr,
   input [4 : 0] rs2_addr,
   output [31 : 0] rs2_dato,
   input [4 : 0] rs1_addr,
   output [31 : 0] rs1_dato,
   input clk);

//------------------- Register declaration(s):
reg  [31 : 0] rf [15 : 0];

//------------------- Procedural register declaration(s):
reg  [31 : 0] rs2_dato;
reg  [31 : 0] rs1_dato;

//------------------- Register assignment(s):
always_ff @ (posedge clk) begin
   if (c_rf_write) begin
      rf [rd_addr] <= rd_dati;
   end
end

//------------------- Item assignment(s):
wire [31:0] rs2_dato_tmp;
wire [31:0] rs1_dato_tmp;

sdp_ram_32x32 rs1 (
  .clka(clk),    // input wire clka
  .wea(c_rf_write),      // input wire [0 : 0] wea
  .addra(rd_addr),  // input wire [4 : 0] addra
  .dina(rd_dati),    // input wire [31 : 0] dina
  .clkb(~clk),    // input wire clkb
  .addrb(rs1_addr),  // input wire [4 : 0] addrb
  .doutb(rs1_dato_tmp)  // output wire [31 : 0] doutb
);

sdp_ram_32x32 rs2 (
  .clka(clk),    // input wire clka
  .wea(c_rf_write),      // input wire [0 : 0] wea
  .addra(rd_addr),  // input wire [4 : 0] addra
  .dina(rd_dati),    // input wire [31 : 0] dina
  .clkb(~clk),    // input wire clkb
  .addrb(rs2_addr),  // input wire [4 : 0] addrb
  .doutb(rs2_dato_tmp)  // output wire [31 : 0] doutb
);

reg last_write;
reg [4:0] last_rd_addr;
reg [31:0] last_rd_dati;

always_ff @ (posedge clk) begin
   if (c_rf_write)
      last_write <= 1'b1;
   else
      last_write <= 1'b0;
   last_rd_addr <= rd_addr;
   last_rd_dati <= rd_dati;
end

assign rs2_dato = (rs2_addr == 0) ? 0 : 
                  (last_write & (last_rd_addr == rs2_addr)) ? last_rd_dati : rs2_dato_tmp;
assign rs1_dato = (rs1_addr == 0) ? 0 : 
                  (last_write & (last_rd_addr == rs1_addr)) ? last_rd_dati : rs1_dato_tmp;

endmodule