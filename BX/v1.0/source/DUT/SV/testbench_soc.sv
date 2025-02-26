module testbench_soc ();

//------------------- Procedural register declaration(s):
reg uart_rx;
reg arstn;
reg clk_in;

//------------------- Wire declaration(s):
wire [3 : 0] b3_data_io;
wire [3 : 0] b2_data_io;
wire [3 : 0] b1_data_io;
wire [3 : 0] b0_data_io;
wire sys_rst;

//------------------- Item assignment(s):
assign uart_rx = uart_tx | sys_rst;

//------------------- Submodule(s):
FPGA_TOP i_fpga (
	.arstn(arstn),
	.b3_data_io(b3_data_io),
	.b2_data_io(b2_data_io),
	.b1_data_io(b1_data_io),
	.b0_data_io(b0_data_io),
	.sys_rst(sys_rst),
	.clk_in(clk_in));
TB_GPIO i_tb_gpio (
	.b3_data_io(b3_data_io),
	.b2_data_io(b2_data_io),
	.b1_data_io(b1_data_io),
	.b0_data_io(b0_data_io));
endmodule