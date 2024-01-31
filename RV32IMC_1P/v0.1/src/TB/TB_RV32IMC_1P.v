//
// Copyright 2024 Tobias Strauch, Munich, Bavaria
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module TB_RV32IMC_1P;

reg clk;
reg rstn;

wire [14:0] pc;
wire [31:0] instr;
wire c_dmem_store;
wire [2 : 0] dmem_store_width;
wire [31 : 0] dmem_store_data;
wire [32 : 0] dmem_store_addr;
wire [32 : 0] dmem_load_addr;
wire [31 : 0] dmem_load_data;

reg [7:0] program [10000:0];
reg [7:0] data8 [1023:0]; 

integer passcnt;
reg go;
integer failures;

integer tc, ptr;
initial begin
   clk <= 1'b0;
   failures <= 0;
   for (tc = 0; tc < 6; tc = tc + 1) begin
      sp = 0;
      go = 1'b1;
      passcnt = 0;
      cycle_cnt = 0;
      rstn <= 1'b0;
      if (tc == 0) begin $readmemh("../../../../../../src/dyn_tests/codeGenHex/generate_0.hex", program); end
      if (tc == 1) begin $readmemh("../../../../../../src/dyn_tests/codeGenHex/generate_1.hex", program); end
      if (tc == 2) begin $readmemh("../../../../../../src/dyn_tests/codeGenHex/generate_2.hex", program); end
      if (tc == 3) begin $readmemh("../../../../../../src/dyn_tests/codeGenHex/generate_3.hex", program); end
      if (tc == 4) begin $readmemh("../../../../../../src/dyn_tests/codeGenHex/generate_4.hex", program); end
      if (tc == 5) begin $readmemh("../../../../../../src/dyn_tests/codeGenHex/generate_5.hex", program); end
      $display("Running test: ", tc);
      #90;
      @ (negedge clk);
         rstn <= 1'b1;
      while (passcnt < 2) #10;
      #3;
   end
   $display("Number of tests failed: ", failures, "\n");
   $finish;
end

always #5 clk <= ~clk;

integer cycle_cnt;
always @ (posedge clk)
   if (cycle_cnt == 800000 * 4) begin
      $display("Test runaway.\n"); 
      $finish;
   end else
      cycle_cnt <= cycle_cnt + 1;

RV32IMC_1P i_rv (
    .instr(instr),
	.c_arst(~rstn),
	.c_dmem_store(c_dmem_store),
	.dmem_store_width(dmem_store_width),
	.dmem_store_data(dmem_store_data),
	.dmem_store_addr(dmem_store_addr),
	.dmem_load_addr(dmem_load_addr),
	.dmem_load_data(dmem_load_data),
	.clk(clk),
	.pc(pc));

assign instr = {program[pc[14:0] + 3], program[pc[14:0] + 2], program[pc[14:0] + 1], program[pc[14:0] + 0]};


integer sp;


always @ (posedge clk)
if (c_dmem_store) begin   
   if (dmem_store_addr[1:0] == 0) begin
      if (1'b1)            data8[dmem_store_addr[9:0]]    <= dmem_store_data[ 7: 0];
      if (dmem_store_width != 0) data8[dmem_store_addr[9:0] + 1] <= dmem_store_data[15: 8];
      if (dmem_store_width[1])   data8[dmem_store_addr[9:0] + 2] <= dmem_store_data[23:16];
      if (dmem_store_width[1])   data8[dmem_store_addr[9:0] + 3] <= dmem_store_data[31:24];
   end
   if (dmem_store_addr[1:0] == 1) begin
      if (1'b1)            data8[dmem_store_addr[9:0]] <= dmem_store_data[ 7: 0];
      if (dmem_store_width != 0) data8[dmem_store_addr[9:0] + 1] <= dmem_store_data[15: 8];
      if (dmem_store_width[1])   data8[dmem_store_addr[9:0] + 2] <= dmem_store_data[23:16];
      if (dmem_store_width[1])   data8[dmem_store_addr[9:0] + 3] <= dmem_store_data[31:24];
   end
   if (dmem_store_addr[1:0] == 2) begin
      if (1'b1)            data8[dmem_store_addr[9:0]] <= dmem_store_data[ 7: 0];
      if (dmem_store_width != 0) data8[dmem_store_addr[9:0] + 1] <= dmem_store_data[15: 8];
      if (dmem_store_width[1])   data8[dmem_store_addr[9:0] + 2] <= dmem_store_data[23:16];
      if (dmem_store_width[1])   data8[dmem_store_addr[9:0] + 3] <= dmem_store_data[31:24];
   end
   if (dmem_store_addr[1:0] == 3) begin
      if (1'b1)            data8[dmem_store_addr[9:0]] <= dmem_store_data[ 7: 0];
      if (dmem_store_width != 0) data8[dmem_store_addr[9:0] + 1] <= dmem_store_data[15: 8];
      if (dmem_store_width[1])   data8[dmem_store_addr[9:0] + 2] <= dmem_store_data[23:16];
      if (dmem_store_width[1])   data8[dmem_store_addr[9:0] + 3] <= dmem_store_data[31:24];
   end
end

assign dmem_load_data = {data8[dmem_load_addr[9:0] + 3], data8[dmem_load_addr[9:0] + 2], data8[dmem_load_addr[9:0] + 1], data8[dmem_load_addr[9:0]]};

integer stalled_cnt = 0;
integer execute_cnt = 0;

always @ (posedge clk)
   if ((rstn == 1'b1) & 
      (go == 1'b1) &
      (tc >= 10)) begin
         execute_cnt <= execute_cnt + 1;
         stalled_cnt <= stalled_cnt + 1;
   end

always @ (posedge clk)
if (c_dmem_store & (dmem_store_addr[31:0] == 32'h1001200c)) begin
   if (dmem_store_data == 32'h00400000) begin
     if (passcnt == 1) begin
        $display("Test passed.");
        go = 1'b0;
        $display("cycles: %d stalled: %d ratio (decimal): %d", execute_cnt, stalled_cnt, execute_cnt / stalled_cnt); 
        $display("==============================================================================");
     end
     passcnt <= passcnt + 1;
   end else if (dmem_store_data == 32'h00080000) begin
     failures <= failures + 1;
     $display("RV32IMAC test failed. ", tc, "\n");
     //$finish;
   end
end


endmodule
