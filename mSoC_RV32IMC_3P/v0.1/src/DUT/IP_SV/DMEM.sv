//
// Copyright 2024 Tobias Strauch, Munich, Bavaria
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module DMEM (
   input ic0_c_axi_mst_wr_valid,
   output ic0_c_axi_slv_rd_ready_2,
   input ic0_c_axi_mst_rd_valid,
   input [31 : 0] ic0_axi_mst_wr_addr,
   output [31 : 0] ic0_axi_slv_rd_data_2,
   input [31 : 0] ic0_axi_mst_wr_data,
   input [31 : 0] ic0_axi_mst_rd_addr,
   input clk);

sdp_ram_4096x32x4 datali (
   .clka(clk),
   .wea({4{ic0_c_axi_mst_wr_valid}}),
   .addra(ic0_axi_mst_wr_addr[14:2]),
   .dina(ic0_axi_mst_wr_data[31:0]),
   .clkb(clk),
   .addrb(ic0_axi_mst_rd_addr[14:2]),
   .doutb(ic0_axi_slv_rd_data_2[31:0]));

assign ic0_c_axi_slv_rd_ready_2 = (ic0_axi_mst_rd_addr [31 : 16] == 16'h0000);
                         
endmodule