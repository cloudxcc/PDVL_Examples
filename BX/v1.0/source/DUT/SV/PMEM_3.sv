module PMEM_3 (
   output [31 : 0] instr_reg_c1,
   input [31 : 0] pc_read_c0,
   input clk);

//------------------- Register declaration(s):
reg  [31 : 0] instr_reg_c1;
reg  [32 - 1 : 0] mem32 [128 * 256 - 1 : 0];
reg  [16 - 1 : 0] pmeml [512];
reg  [16 - 1 : 0] pmemh [512];

//------------------- Procedural register declaration(s):
reg  [31 : 0] instr0;

//------------------- Register assignment(s):
always_ff @ (posedge clk) begin
   instr_reg_c1 <= instr0;
end

//------------------- Item assignment(s):
assign instr0 = mem32 [pc_read_c0 [31 : 2]];
endmodule