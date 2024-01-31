module DMEM (
   input ic0_c_axi_mst_wr_valid,
   input ic0_c_axi_mst_rd_valid,
   output ic0_c_axi_slv_rd_ready_2,
   output [31 : 0] ic0_axi_slv_rd_data_2,
   input [31 : 0] ic0_axi_mst_wr_data,
   input [31 : 0] ic0_axi_mst_wr_addr,
   input [31 : 0] ic0_axi_mst_rd_addr,
   input clk);

//------------------- Register declaration(s):
reg  [31 : 0] ram [4095 : 0];

//------------------- Procedural register declaration(s):
reg  [31 : 0] slv_rd_data;
reg  [31 : 0] slv_rd_addr;
reg  [31 : 0] slv_wr_data;
reg  [31 : 0] slv_wr_addr;
reg  [31 : 0] ic0_axi_slv_rd_data_2;
reg  [31 : 0] ic0_axi_slv_rd_addr;

//------------------- Condition declaration(s):
reg c_slv_rd_ready;
reg c_mem_store;
reg c_slv_rd_valid;
reg c_slv_wr;
reg ic0_c_axi_slv_wr_valid;
reg ic0_c_axi_slv_rd_ready_2;
reg ic0_c_axi_slv_rd_valid;

//------------------- Register assignment(s):
always_ff @ (posedge clk) begin
   if (c_mem_store) begin
      ram [slv_wr_addr] <= slv_wr_data;
   end
end

//------------------- Item assignment(s):
assign slv_rd_data = ram [slv_rd_addr];
assign slv_rd_addr = ic0_axi_slv_rd_addr;
assign slv_wr_data = ic0_axi_mst_wr_data;
assign slv_wr_addr = ic0_axi_mst_wr_addr;
assign ic0_axi_slv_rd_data_2 = slv_rd_data;
assign ic0_axi_slv_rd_addr = ic0_axi_mst_rd_addr;

//------------------- Condition assignment(s):
assign c_slv_rd_ready = (c_slv_rd_valid & (slv_rd_addr [31 : 16] == 16'h0000));
assign c_mem_store = (c_slv_wr & (slv_wr_addr [31 : 16] == 16'h0000));
assign c_slv_rd_valid = ic0_c_axi_slv_rd_valid;
assign c_slv_wr = ic0_c_axi_slv_wr_valid;
assign ic0_c_axi_slv_wr_valid = (ic0_c_axi_mst_wr_valid);
assign ic0_c_axi_slv_rd_ready_2 = c_slv_rd_ready;
assign ic0_c_axi_slv_rd_valid = (ic0_c_axi_mst_rd_valid);
endmodule