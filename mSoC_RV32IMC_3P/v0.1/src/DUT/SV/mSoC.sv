module mSoC (
   input c_sys_rst,
   inout [b1_bw - 1 : 0] b1_data_io,
   inout [b0_bw - 1 : 0] b0_data_io,
   input ic1_c_axi_mst_wr_valid,
   input [31 : 0] ic1_axi_mst_wr_data,
   input [31 : 0] ic1_axi_mst_wr_addr,
   output ic0_c_axi_mst_wr_valid,
   output ic0_c_axi_mst_rd_valid,
   input ic0_c_axi_slv_rd_ready_3,
   input [31 : 0] ic0_axi_slv_rd_data_3,
   output [31 : 0] ic0_axi_mst_wr_data,
   output [31 : 0] ic0_axi_mst_wr_addr,
   output [31 : 0] ic0_axi_mst_rd_addr,
   input clk);

//------------------- Parameter(s):
parameter b1_bw = 8;
parameter b0_bw = 8;
parameter PC_LEN = 32;

//------------------- Wire declaration(s):
wire [31 : 0] instr;
wire ic0_c_axi_mst_wr_valid;
wire ic0_c_axi_mst_rd_valid;
wire ic0_c_axi_slv_rd_ready_2;
wire ic0_c_axi_slv_rd_ready_1;
wire ic0_c_axi_slv_rd_ready_0;
wire [31 : 0] ic0_axi_slv_rd_data_2;
wire [31 : 0] ic0_axi_slv_rd_data_1;
wire [31 : 0] ic0_axi_slv_rd_data_0;
wire [31 : 0] ic0_axi_mst_wr_data;
wire [31 : 0] ic0_axi_mst_wr_addr;
wire [31 : 0] ic0_axi_mst_rd_addr;
wire [PC_LEN - 1 : 0] pc;

//------------------- Submodule(s):
RV32IMC_3P i_rv (
	.c_sys_rst(c_sys_rst),
	.instr(instr),
	.ic0_c_axi_mst_wr_valid(ic0_c_axi_mst_wr_valid),
	.ic0_c_axi_mst_rd_valid(ic0_c_axi_mst_rd_valid),
	.ic0_c_axi_slv_rd_ready_3(ic0_c_axi_slv_rd_ready_3),
	.ic0_c_axi_slv_rd_ready_2(ic0_c_axi_slv_rd_ready_2),
	.ic0_c_axi_slv_rd_ready_1(ic0_c_axi_slv_rd_ready_1),
	.ic0_c_axi_slv_rd_ready_0(ic0_c_axi_slv_rd_ready_0),
	.ic0_axi_slv_rd_data_3(ic0_axi_slv_rd_data_3),
	.ic0_axi_slv_rd_data_2(ic0_axi_slv_rd_data_2),
	.ic0_axi_slv_rd_data_1(ic0_axi_slv_rd_data_1),
	.ic0_axi_slv_rd_data_0(ic0_axi_slv_rd_data_0),
	.ic0_axi_mst_wr_data(ic0_axi_mst_wr_data),
	.ic0_axi_mst_wr_addr(ic0_axi_mst_wr_addr),
	.ic0_axi_mst_rd_addr(ic0_axi_mst_rd_addr),
	.clk(clk),
	.pc(pc));
DMEM i_dmem (
	.ic0_c_axi_mst_wr_valid(ic0_c_axi_mst_wr_valid),
	.ic0_c_axi_mst_rd_valid(ic0_c_axi_mst_rd_valid),
	.ic0_c_axi_slv_rd_ready_2(ic0_c_axi_slv_rd_ready_2),
	.ic0_axi_slv_rd_data_2(ic0_axi_slv_rd_data_2),
	.ic0_axi_mst_wr_data(ic0_axi_mst_wr_data),
	.ic0_axi_mst_wr_addr(ic0_axi_mst_wr_addr),
	.ic0_axi_mst_rd_addr(ic0_axi_mst_rd_addr),
	.clk(clk));
PMEM i_pmem (
	.instr(instr),
	.ic1_c_axi_mst_wr_valid(ic1_c_axi_mst_wr_valid),
	.ic1_axi_mst_wr_data(ic1_axi_mst_wr_data),
	.ic1_axi_mst_wr_addr(ic1_axi_mst_wr_addr),
	.clk(clk),
	.pc(pc));
GPIO_0 i_gpio_0 (
	.c_sys_rst(c_sys_rst),
	.b0_data_io(b0_data_io),
	.ic0_c_axi_mst_wr_valid(ic0_c_axi_mst_wr_valid),
	.ic0_c_axi_mst_rd_valid(ic0_c_axi_mst_rd_valid),
	.ic0_c_axi_slv_rd_ready_0(ic0_c_axi_slv_rd_ready_0),
	.ic0_axi_slv_rd_data_0(ic0_axi_slv_rd_data_0),
	.ic0_axi_mst_wr_data(ic0_axi_mst_wr_data),
	.ic0_axi_mst_wr_addr(ic0_axi_mst_wr_addr),
	.ic0_axi_mst_rd_addr(ic0_axi_mst_rd_addr),
	.clk(clk));
GPIO_1 i_gpio_1 (
	.c_sys_rst(c_sys_rst),
	.b1_data_io(b1_data_io),
	.ic0_c_axi_mst_wr_valid(ic0_c_axi_mst_wr_valid),
	.ic0_c_axi_mst_rd_valid(ic0_c_axi_mst_rd_valid),
	.ic0_c_axi_slv_rd_ready_1(ic0_c_axi_slv_rd_ready_1),
	.ic0_axi_slv_rd_data_1(ic0_axi_slv_rd_data_1),
	.ic0_axi_mst_wr_data(ic0_axi_mst_wr_data),
	.ic0_axi_mst_wr_addr(ic0_axi_mst_wr_addr),
	.ic0_axi_mst_rd_addr(ic0_axi_mst_rd_addr),
	.clk(clk));
endmodule