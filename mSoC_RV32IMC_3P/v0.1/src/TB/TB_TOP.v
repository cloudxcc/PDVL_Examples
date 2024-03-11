//
// Copyright 2024 Tobias Strauch, Munich, Bavaria
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

//
// Testbench on FPGA top level.
// Write program memory through UART interface, unsets reset and runs blinky16 test.
// Checks for correct GPIO values.
//

module TB_TOP;

reg clk;
reg rstn;

wire [7:0] b0_data_io;
wire [7:0] b1_data_io;
reg [7:0] b0_data_io_pu;
reg [7:0] b1_data_io_pu;
reg uart_rx_in;
wire uart_tx_out;

reg [7:0] program [100000:0];
integer ptr_offset = 32'h00010000;

task uart_send;
input [7:0] send_data;
integer i;
begin
   uart_rx_in <= 1'b0;
   #8680;
   for (i = 0; i < 8; i = i + 1) begin
      uart_rx_in <= send_data[i];
      #8680;
   end
   uart_rx_in <= 1'b1;
   #8680;
   #8680;
end
endtask

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

integer i, ptr;
initial begin
   cycle_cnt <= 0;
   clk <= 1'b0;
   rstn <= 1'b0;
   uart_rx_in <= 1'b1;
   for (ptr = 0; ptr < 100000; ptr = ptr + 4) begin
      program[(ptr) + 0] = 8'h13;
      program[(ptr) + 1] = 8'h00;
      program[(ptr) + 2] = 8'h00;
      program[(ptr) + 3] = 8'h00;
   end

   $readmemh("../../../../../../src/dyn_tests/system/blinky16/work/main_0.hex", program);  
   #500;
   rstn <= 1'b1;

   ///////////////////////////////////////////////////// clear reset
   #2000;
   $display("Clear reset.");
   uart_send(8'h10);               // 0x10 clear reset

   ///////////////////////////////////////////////////// set reset
   $display("Set reset.");
   uart_send(8'h11);               // 0x11 set reset

   ///////////////////////////////////////////////////// 4 byte program write 
   $display("Memory write data 8 byte c1.");
   uart_send(8'h30);               // 0x30 memory programming
   uart_send(8'h01);               // add: 0201
   uart_send(8'h02);
   uart_send(8'h03);               // data: 06050403
   uart_send(8'h04);
   uart_send(8'h05);
   uart_send(8'h06);

   ///////////////////////////////////////////////////// final program
   $display("Final programming.");
   for (i = 0; i < 300; i = i + 4) begin
      uart_send(8'h30);               // 0x30 memory programming
      uart_send((i >> 2) & 8'hff);
      uart_send(i >> 10);
      uart_send(program[ptr_offset + i]);
      uart_send(program[ptr_offset + i + 1]);
      uart_send(program[ptr_offset + i + 2]);
      uart_send(program[ptr_offset + i + 3]);
   end

   ///////////////////////////////////////////////////// clear reset and run
   $display("Clear reset.");
   uart_send(8'h10);               // 0x10 clear reset

   ///////////////////////////////////////////////////// check IO
   
   wait (b1_data_io == 8'h01);
   //wait (b1_data_io == 8'hAA);
   //wait (b0_data_io == 8'h00);
   //wait (b1_data_io == 8'h00);
   //wait (b0_data_io == 8'h55);
   //wait (b1_data_io == 8'h55);
   //wait (b0_data_io == 8'h00);
   //wait (b1_data_io == 8'h00);
   //wait (b0_data_io_pu == 8'hAA);
   //wait (b1_data_io_pu == 8'hAA);

   #10;
   $display("Test passed."); 
   $finish;

$finish;
end

always begin       
   // 55 MHz
   #9;
   clk <= ~clk;
   #9;
   clk <= ~clk;
end

integer cycle_cnt;
always @ (posedge clk)
   if (cycle_cnt == 13000000) begin
      $display("Test runaway.\n");
      $finish;
   end else
      cycle_cnt <= cycle_cnt + 1;


FPGA_TOP i_dut (
   .arstn(rstn),
   .uart_rx(uart_rx_in),
   .uart_tx(uart_tx_out),
   .b1_data_io(b1_data_io),
   .b0_data_io(b0_data_io),
   .clk_in(clk));
   
endmodule
