module PLL (
   input clk_in,
   output clk);

//------------------- Procedural register declaration(s):
reg clk;

//------------------- Item assignment(s):
assign clk = clk_in;
endmodule