module mSoC_2 (
   input c_sys_rst,
   inout [3 : 0] b2_data_io,
   input clk);

//------------------- Parameter(s):
parameter ic0_axi_slaves = 3;
parameter ic0_axi_masters = 1;

//------------------- Wire declaration(s):
wire [31 : 0] instr_reg_c1;
wire [10 - 1 : 0] pc_set;
wire [31 : 0] pc_read_c0;
wire [2 : 0] fifo_0;
wire c_thread_pipe_valid;
wire [6 : 0] thread_pipe_valid;
wire c_pc_pass_current;
wire c_pc_pass_fifo_0;
wire c_pc_pass_set;
wire [2 : 0] tid_rd1;
wire [2 : 0] tid_wr;
wire ic0_c_axi_mst_wr_valid;
wire ic0_c_axi_mst_rd_valid;
wire ic0_c_axi_slv_rd_ready_2;
wire ic0_c_axi_slv_rd_ready_1;
wire ic0_c_axi_slv_rd_ready_0;
wire [31 : 0] ic0_axi_slv_rd_data_2;
wire [31 : 0] ic0_axi_slv_rd_data_1;
wire [31 : 0] ic0_axi_slv_rd_data_0;
wire [3 : 0] ic0_axi_mst_wr_strobe;
wire [31 : 0] ic0_axi_mst_wr_data;
wire [31 : 0] ic0_axi_mst_wr_addr;
wire [31 : 0] ic0_axi_mst_rd_addr;

//------------------- Submodule(s):
TC i_tc (
	.c_sys_rst(c_sys_rst),
	.pc_set(pc_set),
	.fifo_0(fifo_0),
	.c_thread_pipe_valid(c_thread_pipe_valid),
	.thread_pipe_valid(thread_pipe_valid),
	.c_pc_pass_current(c_pc_pass_current),
	.c_pc_pass_fifo_0(c_pc_pass_fifo_0),
	.c_pc_pass_set(c_pc_pass_set),
	.tid_rd1(tid_rd1),
	.tid_wr(tid_wr),
	.ic0_c_axi_mst_wr_valid(ic0_c_axi_mst_wr_valid),
	.ic0_c_axi_mst_rd_valid(ic0_c_axi_mst_rd_valid),
	.ic0_c_axi_slv_rd_ready_2(ic0_c_axi_slv_rd_ready_2),
	.ic0_axi_slv_rd_data_2(ic0_axi_slv_rd_data_2),
	.ic0_axi_mst_wr_data(ic0_axi_mst_wr_data),
	.ic0_axi_mst_wr_addr(ic0_axi_mst_wr_addr),
	.ic0_axi_mst_rd_addr(ic0_axi_mst_rd_addr),
	.clk(clk));
RV32i_1P i_rv (
	.c_sys_rst(c_sys_rst),
	.instr_reg_c1(instr_reg_c1),
	.pc_set(pc_set),
	.pc_read_c0(pc_read_c0),
	.fifo_0(fifo_0),
	.c_thread_pipe_valid(c_thread_pipe_valid),
	.thread_pipe_valid(thread_pipe_valid),
	.c_pc_pass_current(c_pc_pass_current),
	.c_pc_pass_fifo_0(c_pc_pass_fifo_0),
	.c_pc_pass_set(c_pc_pass_set),
	.tid_rd1(tid_rd1),
	.tid_wr(tid_wr),
	.ic0_c_axi_mst_wr_valid(ic0_c_axi_mst_wr_valid),
	.ic0_c_axi_mst_rd_valid(ic0_c_axi_mst_rd_valid),
	.ic0_c_axi_slv_rd_ready_2(ic0_c_axi_slv_rd_ready_2),
	.ic0_c_axi_slv_rd_ready_1(ic0_c_axi_slv_rd_ready_1),
	.ic0_c_axi_slv_rd_ready_0(ic0_c_axi_slv_rd_ready_0),
	.ic0_axi_slv_rd_data_2(ic0_axi_slv_rd_data_2),
	.ic0_axi_slv_rd_data_1(ic0_axi_slv_rd_data_1),
	.ic0_axi_slv_rd_data_0(ic0_axi_slv_rd_data_0),
	.ic0_axi_mst_wr_strobe(ic0_axi_mst_wr_strobe),
	.ic0_axi_mst_wr_data(ic0_axi_mst_wr_data),
	.ic0_axi_mst_wr_addr(ic0_axi_mst_wr_addr),
	.ic0_axi_mst_rd_addr(ic0_axi_mst_rd_addr),
	.clk(clk));
DMEM i_dmem (
	.ic0_c_axi_mst_wr_valid(ic0_c_axi_mst_wr_valid),
	.ic0_c_axi_mst_rd_valid(ic0_c_axi_mst_rd_valid),
	.ic0_c_axi_slv_rd_ready_1(ic0_c_axi_slv_rd_ready_1),
	.ic0_axi_slv_rd_data_1(ic0_axi_slv_rd_data_1),
	.ic0_axi_mst_wr_strobe(ic0_axi_mst_wr_strobe),
	.ic0_axi_mst_wr_data(ic0_axi_mst_wr_data),
	.ic0_axi_mst_wr_addr(ic0_axi_mst_wr_addr),
	.ic0_axi_mst_rd_addr(ic0_axi_mst_rd_addr),
	.clk(clk));
PMEM_2 i_pmem (
	.instr_reg_c1(instr_reg_c1),
	.pc_read_c0(pc_read_c0),
	.clk(clk));
GPIO_1 i_gpio (
	.b2_data_io(b2_data_io),
	.ic0_c_axi_mst_wr_valid(ic0_c_axi_mst_wr_valid),
	.ic0_c_axi_mst_rd_valid(ic0_c_axi_mst_rd_valid),
	.ic0_c_axi_slv_rd_ready_0(ic0_c_axi_slv_rd_ready_0),
	.ic0_axi_slv_rd_data_0(ic0_axi_slv_rd_data_0),
	.ic0_axi_mst_wr_data(ic0_axi_mst_wr_data),
	.ic0_axi_mst_wr_addr(ic0_axi_mst_wr_addr),
	.ic0_axi_mst_rd_addr(ic0_axi_mst_rd_addr),
	.clk(clk));
endmodule