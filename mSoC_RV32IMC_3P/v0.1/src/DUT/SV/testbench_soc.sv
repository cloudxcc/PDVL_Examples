module testbench_soc ();

//------------------- Parameter(s):
parameter b1_bw = 8;
parameter b0_bw = 8;

//------------------- Procedural register declaration(s):
reg uart_rx;
reg arstn;
reg clk_in;

//------------------- Wire declaration(s):
wire uart_tx;
wire [b1_bw - 1 : 0] b1_data_io;
wire [b0_bw - 1 : 0] b0_data_io;
wire sys_rst;

//------------------- Item assignment(s):
assign uart_rx = uart_tx | sys_rst;

//------------------- Submodule(s):
FPGA_TOP i_fpga (
	.arstn(arstn),
	.uart_tx(uart_tx),
	.uart_rx(uart_rx),
	.b1_data_io(b1_data_io),
	.b0_data_io(b0_data_io),
	.sys_rst(sys_rst),
	.clk_in(clk_in));
TB_GPIO i_tb_gpio (
	.b1_data_io(b1_data_io),
	.b0_data_io(b0_data_io));
endmodule