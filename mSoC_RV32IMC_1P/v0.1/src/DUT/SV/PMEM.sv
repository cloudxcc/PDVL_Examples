module PMEM (
   output [31 : 0] instr,
   input ic1_c_axi_mst_wr_valid,
   input [31 : 0] ic1_axi_mst_wr_data,
   input [31 : 0] ic1_axi_mst_wr_addr,
   input clk,
   input [PC_LEN - 1 : 0] pc);

//------------------- Parameter(s):
parameter PC_LEN = 32;

//------------------- Register declaration(s):
reg  [16 - 1 : 0] pmeml [512];
reg  [16 - 1 : 0] pmemh [512];

//------------------- Procedural register declaration(s):
reg  [31 : 0] instr;
reg  [15 : 0] instrh;
reg  [15 : 0] instrl;
reg  [14 : 0] pch;
reg  [12 : 0] pcl;
reg  [31 : 0] slv_wr_data;
reg  [31 : 0] slv_wr_addr;

//------------------- Condition declaration(s):
reg c_slv_wr;
reg ic1_c_axi_slv_wr_valid;

//------------------- Register assignment(s):
always_ff @ (posedge clk) begin
   if (c_slv_wr) begin
      pmeml [slv_wr_addr] <= slv_wr_data [15 : 0];
   end
end
always_ff @ (posedge clk) begin
   if (c_slv_wr) begin
      pmemh [slv_wr_addr] <= slv_wr_data [31 : 16];
   end
end

//------------------- Item assignment(s):
assign instr = pc [1] ? {instrl, instrh} : {instrh, instrl};
assign instrh = pmemh [pch];
assign instrl = pmeml [pcl];
assign pch = pc [14 : 2];
assign pcl = pc [1] ? (pc [14 : 2] + 1) : pc [14 : 2];
assign slv_wr_data = ic1_axi_mst_wr_data;
assign slv_wr_addr = ic1_axi_mst_wr_addr;

//------------------- Condition assignment(s):
assign c_slv_wr = ic1_c_axi_slv_wr_valid;
assign ic1_c_axi_slv_wr_valid = (ic1_c_axi_mst_wr_valid);
endmodule