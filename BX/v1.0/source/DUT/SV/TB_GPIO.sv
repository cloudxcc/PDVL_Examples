module TB_GPIO (
   inout [3 : 0] b3_data_io,
   inout [3 : 0] b2_data_io,
   inout [3 : 0] b1_data_io,
   inout [3 : 0] b0_data_io);

//------------------- Parameter(s):
parameter b3_o_bw = 4;
parameter b2_o_bw = 4;
parameter b1_o_bw = 4;
parameter b0_o_bw = 4;
parameter b3_bw = 4;
parameter b2_bw = 4;
parameter b1_bw = 4;
parameter b0_bw = 4;

//------------------- Procedural register declaration(s):
reg  [3 : 0] b3_tb_data_io_in;
reg  [3 : 0] b2_tb_data_io_in;
reg  [3 : 0] b1_tb_data_io_in;
reg  [3 : 0] b0_tb_data_io_in;

//------------------- Item assignment(s):
assign b3_tb_data_io_in = b3_data_io;
assign b3_data_io = b3_tb_data_io_out;
assign b2_tb_data_io_in = b2_data_io;
assign b2_data_io = b2_tb_data_io_out;
assign b1_tb_data_io_in = b1_data_io;
assign b1_data_io = b1_tb_data_io_out;
assign b0_tb_data_io_in = b0_data_io;
assign b0_data_io = b0_tb_data_io_out;
endmodule