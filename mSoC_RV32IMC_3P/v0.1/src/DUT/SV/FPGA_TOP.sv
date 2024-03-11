module FPGA_TOP (
   input arstn,
   output uart_tx,
   input uart_rx,
   inout [b1_bw - 1 : 0] b1_data_io,
   inout [b0_bw - 1 : 0] b0_data_io,
   output sys_rst,
   input clk_in);

//------------------- Parameter(s):
parameter b1_bw = 8;
parameter b0_bw = 8;
parameter ic1_axi_slaves = 1;
parameter ic1_axi_masters = 1;
parameter ic0_axi_slaves = 4;
parameter ic0_axi_masters = 1;

//------------------- Register declaration(s):
reg sys_rst;

//------------------- Condition declaration(s):
reg c_ex_rst;
reg c_sys_rst;

//------------------- Wire declaration(s):
wire c_user_rst;
wire ic1_c_axi_mst_wr_valid;
wire [31 : 0] ic1_axi_mst_wr_data;
wire [31 : 0] ic1_axi_mst_wr_addr;
wire ic0_c_axi_mst_wr_valid;
wire ic0_c_axi_mst_rd_valid;
wire ic0_c_axi_slv_rd_ready_3;
wire [31 : 0] ic0_axi_slv_rd_data_3;
wire [31 : 0] ic0_axi_mst_wr_data;
wire [31 : 0] ic0_axi_mst_wr_addr;
wire [31 : 0] ic0_axi_mst_rd_addr;
wire clk;

//------------------- Register assignment(s):
always_ff @ (posedge clk or posedge c_ex_rst) begin
   if (c_ex_rst) begin
      sys_rst <= 1;
   end
   else begin
      sys_rst <= 0;
      if (c_user_rst) begin
         sys_rst <= 1;
      end
   end
end

//------------------- Condition assignment(s):
assign c_ex_rst = (arstn == 0);
assign c_sys_rst = (sys_rst == 1);

//------------------- Submodule(s):
PLL i_pll (
	.clk_in(clk_in),
	.clk(clk));
mSoC i_soc (
	.c_sys_rst(c_sys_rst),
	.b1_data_io(b1_data_io),
	.b0_data_io(b0_data_io),
	.ic1_c_axi_mst_wr_valid(ic1_c_axi_mst_wr_valid),
	.ic1_axi_mst_wr_data(ic1_axi_mst_wr_data),
	.ic1_axi_mst_wr_addr(ic1_axi_mst_wr_addr),
	.ic0_c_axi_mst_wr_valid(ic0_c_axi_mst_wr_valid),
	.ic0_c_axi_mst_rd_valid(ic0_c_axi_mst_rd_valid),
	.ic0_c_axi_slv_rd_ready_3(ic0_c_axi_slv_rd_ready_3),
	.ic0_axi_slv_rd_data_3(ic0_axi_slv_rd_data_3),
	.ic0_axi_mst_wr_data(ic0_axi_mst_wr_data),
	.ic0_axi_mst_wr_addr(ic0_axi_mst_wr_addr),
	.ic0_axi_mst_rd_addr(ic0_axi_mst_rd_addr),
	.clk(clk));
UART i_uart (
	.c_ex_rst(c_ex_rst),
	.uart_tx(uart_tx),
	.uart_rx(uart_rx),
	.c_user_rst(c_user_rst),
	.ic1_c_axi_mst_wr_valid(ic1_c_axi_mst_wr_valid),
	.ic1_axi_mst_wr_data(ic1_axi_mst_wr_data),
	.ic1_axi_mst_wr_addr(ic1_axi_mst_wr_addr),
	.ic0_c_axi_mst_wr_valid(ic0_c_axi_mst_wr_valid),
	.ic0_c_axi_mst_rd_valid(ic0_c_axi_mst_rd_valid),
	.ic0_c_axi_slv_rd_ready_3(ic0_c_axi_slv_rd_ready_3),
	.ic0_axi_slv_rd_data_3(ic0_axi_slv_rd_data_3),
	.ic0_axi_mst_wr_data(ic0_axi_mst_wr_data),
	.ic0_axi_mst_wr_addr(ic0_axi_mst_wr_addr),
	.ic0_axi_mst_rd_addr(ic0_axi_mst_rd_addr),
	.clk(clk));
endmodule