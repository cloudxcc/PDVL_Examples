module FPGA_TOP (
   input arstn,
   inout [3 : 0] b3_data_io,
   inout [3 : 0] b2_data_io,
   inout [3 : 0] b1_data_io,
   inout [3 : 0] b0_data_io,
   output sys_rst,
   input clk_in);

//------------------- Register declaration(s):
reg  [4 - 1 : 0] rst_cnt;
reg sys_rst;

//------------------- Condition declaration(s):
reg c_ex_rst;
reg c_rst_cnt;
reg c_sys_rst;

//------------------- Wire declaration(s):
wire clk;

//------------------- Register assignment(s):
always_ff @ (posedge clk) begin
   if (c_rst_cnt) begin
      rst_cnt <= rst_cnt + 1;
   end
end
always_ff @ (posedge clk or posedge c_ex_rst) begin
   if (c_ex_rst) begin
      sys_rst <= 1;
   end
   else begin
      sys_rst <= !rst_cnt [3];
   end
end

//------------------- Condition assignment(s):
assign c_ex_rst = (arstn == 0);
assign c_rst_cnt = (rst_cnt != 4'ha);
assign c_sys_rst = (sys_rst == 1);

//------------------- Submodule(s):
PLL i_pll (
	.clk_in(clk_in),
	.clk(clk));
mSoC_0 i_soc_0 (
	.c_sys_rst(c_sys_rst),
	.b0_data_io(b0_data_io),
	.clk(clk));
mSoC_1 i_soc_1 (
	.c_sys_rst(c_sys_rst),
	.b1_data_io(b1_data_io),
	.clk(clk));
mSoC_2 i_soc_2 (
	.c_sys_rst(c_sys_rst),
	.b2_data_io(b2_data_io),
	.clk(clk));
mSoC_3 i_soc_3 (
	.c_sys_rst(c_sys_rst),
	.b3_data_io(b3_data_io),
	.clk(clk));
endmodule