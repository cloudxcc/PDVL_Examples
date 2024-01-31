//
// Copyright 2024 Tobias Strauch, Munich, Bavaria
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

//
// Testbench on SoC level, which is basically the design without UART.
// Write program memory through paralle interface, and runs blinky16 test.
// Checks for correct GPIO values.
//

module TB_mSoC;

reg clk;
reg rstn;

reg [31:0] prog_wea;
reg [12:0] prog_addra;
reg [31:0] prog_dina;
wire [127:0] prog_douta;

reg ic0_c_axi_slv_rvalid_3;
wire [31 : 0] ic0_axi_addr;
reg [31 : 0] ic0_axi_slv_data_3;
wire [31 : 0] ic0_axi_mst_data;
wire [31 : 0] ic0_axi_mst_rd_addr;

wire [7:0] b0_data_io;
wire [7:0] b1_data_io;
reg [7:0] b0_data_io_pu;
reg [7:0] b1_data_io_pu;

reg [7:0] program [100000:0];

integer cycle_cnt, max_cycle_count;
integer ptr_offset = 32'h00010000;

integer ptr;

//////////////////////////////////////////
// handling gpio
//////////////////////////////////////////
integer b;
always @ (b0_data_io) begin
   for (b = 0; b < 8; b = b + 1) begin
      if (b0_data_io[b] == 1'b1) b0_data_io_pu[b] <= 1'b1;
      else if (b0_data_io[b] == 1'b0) b0_data_io_pu[b] <= 1'b0;
      else b0_data_io_pu[b] <= 1'b1;
   end
end

always @ (b1_data_io) begin
   for (b = 0; b < 8; b = b + 1) begin
      if (b1_data_io[b] == 1'b1) b1_data_io_pu[b] <= 1'b1;
      else if (b1_data_io[b] == 1'b0) b1_data_io_pu[b] <= 1'b0;
      else b1_data_io_pu[b] <= 1'b1;
   end
end

initial begin
   clk <= 1'b0;
   cycle_cnt <= 0; 
   rstn <= 1'b0;
   max_cycle_count <= 30000;
   prog_wea <= 4'h0;
   for (ptr = 0; ptr < 100000; ptr = ptr + 4) begin
       program[(ptr) + 0] = 8'h13;
       program[(ptr) + 1] = 8'h00;
       program[(ptr) + 2] = 8'h00;
       program[(ptr) + 3] = 8'h00;
   end
   $readmemh("../../../../../../src/dyn_tests/system/blinky16/work/main_0.hex", program);  
   #7;
   prog_wea <= 32'h000000f;
   for (ptr = 0; ptr < 2048; ptr = ptr + 4) begin
      prog_addra = ptr / 4;
      prog_dina = {program[ptr_offset + ptr + 3], program[ptr_offset + ptr + 2], program[ptr_offset + ptr + 1], program[ptr_offset + ptr]};
      @ (posedge clk);
      #1;
   end
   prog_wea <= 0;

   #7;
   rstn <= 1'b1;
   wait (b0_data_io == 8'hAA);
   wait (b1_data_io == 8'hAA);
   wait (b0_data_io == 8'h00);
   wait (b1_data_io == 8'h00);
   wait (b0_data_io == 8'h55);
   wait (b1_data_io == 8'h55);
   wait (b0_data_io == 8'h00);
   wait (b1_data_io == 8'h00);
   wait (b0_data_io_pu == 8'hAA);
   wait (b1_data_io_pu == 8'hAA);
   #10;
   $display("Test passed."); 
   $finish;
end


always #25 clk <= ~clk;

always @ (posedge clk)
if (cycle_cnt == max_cycle_count) begin
   $display("Test runaway.\n"); 
   $finish;  
end else
   cycle_cnt <= cycle_cnt + 1;

always @(ic0_axi_mst_rd_addr)  begin
   ic0_axi_slv_data_3 <= 32'h00000000;
   ic0_c_axi_slv_rvalid_3 <= 1'b0;
   if (ic0_axi_mst_rd_addr[31:0] == 32'h80020010) begin  // UART_TX_COM
      ic0_axi_slv_data_3 <= 32'h00000000;
      ic0_c_axi_slv_rvalid_3 <= 1'b1;
   end else if (ic0_axi_mst_rd_addr[31:0] == 32'h80020020) begin  // UART_REC
      ic0_axi_slv_data_3 <= 32'h00000081;
      ic0_c_axi_slv_rvalid_3 <= 1'b1;
   end else if (ic0_axi_mst_rd_addr[31:0] == 32'h80020030) begin  // UART_RX_COM
      ic0_axi_slv_data_3 <= 32'h00000001;
      ic0_c_axi_slv_rvalid_3 <= 1'b1;
   end
end

mSoC i_dut (
   .c_sys_rst(~rstn),
   .b1_data_io(b1_data_io),
   .b0_data_io(b0_data_io),
   .ic1_c_axi_mst_wr_valid(prog_wea[0]),
   .ic1_axi_mst_wr_addr({{19{1'b0}},prog_addra}),
   .ic1_axi_mst_wr_data(prog_dina),
   .ic0_c_axi_mst_wr_valid(),
   .ic0_c_axi_mst_rd_valid(),
   .ic0_c_axi_slv_rd_ready_3(ic0_c_axi_slv_rvalid_3),
   .ic0_axi_mst_wr_data(ic0_axi_addr),
   .ic0_axi_slv_rd_data_3(ic0_axi_slv_data_3),
   .ic0_axi_mst_wr_addr(ic0_axi_mst_data),
   .ic0_axi_mst_rd_addr(ic0_axi_mst_rd_addr),
   .clk(clk));

endmodule
