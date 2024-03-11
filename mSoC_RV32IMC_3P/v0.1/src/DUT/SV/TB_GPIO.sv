module TB_GPIO (
   inout [b1_bw - 1 : 0] b1_data_io,
   inout [b0_bw - 1 : 0] b0_data_io);

//------------------- Parameter(s):
parameter b1_o_bw = 8;
parameter b0_o_bw = 8;
parameter b1_bw = 8;
parameter b0_bw = 8;

//------------------- Procedural register declaration(s):
reg  [b1_bw - 1 : 0] b1_tb_data_io_in;
reg  [b0_bw - 1 : 0] b0_tb_data_io_in;

//------------------- Item assignment(s):
assign b1_tb_data_io_in = b1_data_io;
assign b1_data_io = b1_tb_data_io_out;
assign b0_tb_data_io_in = b0_data_io;
assign b0_data_io = b0_tb_data_io_out;
endmodule