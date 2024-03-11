module TB_RV32IMC_1P ();

//------------------- Parameter(s):
parameter PC_LEN = 32;

//------------------- Procedural register declaration(s):
reg dummy;
reg  [31 : 0] dmem_load_data;
reg  [31 : 0] dmem_load_addr;
reg  [31 : 0] dmem_store_addr;
reg  [1 : 0] dmem_store_width;
reg  [31 : 0] dmem_store_data;
reg  [31 : 0] pc;
reg  [31 : 0] instr;
reg clk;

//------------------- Condition declaration(s):
reg c_arst;

//------------------- Wire declaration(s):
wire c_dmem_store;
wire c_dmem_load;

//------------------- Item assignment(s):
always_comb begin
   dummy = 1'bx;
   if (c_dmem_store) begin
      dummy = 0;
   end
   if (c_dmem_load) begin
      dummy = 0;
   end
end

//------------------- Condition assignment(s):
assign c_arst = 1'b0;

//------------------- Submodule(s):
RV32IMC_1P i_rv (
	.instr(instr),
	.c_arst(c_arst),
	.dmem_store_width(dmem_store_width),
	.dmem_store_data(dmem_store_data),
	.dmem_store_addr(dmem_store_addr),
	.dmem_load_addr(dmem_load_addr),
	.dmem_load_data(dmem_load_data),
	.c_dmem_store(c_dmem_store),
	.c_dmem_load(c_dmem_load),
	.clk(clk),
	.pc(pc));
endmodule