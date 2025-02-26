module DMEM (
   input ic0_c_axi_mst_wr_valid,
   input ic0_c_axi_mst_rd_valid,
   output ic0_c_axi_slv_rd_ready_1,
   output [31 : 0] ic0_axi_slv_rd_data_1,
   input [3 : 0] ic0_axi_mst_wr_strobe,
   input [31 : 0] ic0_axi_mst_wr_data,
   input [31 : 0] ic0_axi_mst_wr_addr,
   input [31 : 0] ic0_axi_mst_rd_addr,
   input clk);

//------------------- Register declaration(s):
reg slv_rd_ready_c5;
reg  [32 - 1 : 0] slv_rd_data_c5;
reg  [31 : 0] slv_wr_data_c5;
reg  [3 : 0] slv_wr_strobe_c5;
reg  [7 : 0] slv_wr_addr_c5;
reg  [31 : 0] ram [255 : 0];

//------------------- Procedural register declaration(s):
reg  [31 : 0] slv_rd_data;
reg  [31 : 0] slv_rd_addr;
reg  [3 : 0] slv_wr_strobe;
reg  [31 : 0] slv_wr_data;
reg  [31 : 0] slv_wr_addr;
reg  [31 : 0] ic0_axi_slv_rd_data_1;
reg  [31 : 0] ic0_axi_slv_rd_addr;

//------------------- Condition declaration(s):
reg c_mem_store_c4;
reg c_mem_store_c5;
reg c_slv_rd_ready;
reg c_slv_rd_ready_c4;
reg c_mem_store;
reg c_slv_rd_valid;
reg c_slv_wr;
reg ic0_c_axi_slv_wr_valid;
reg ic0_c_axi_slv_rd_ready_1;
reg ic0_c_axi_slv_rd_valid;

//------------------- Register assignment(s):
always_ff @ (posedge clk) begin
   slv_rd_ready_c5 <= c_slv_rd_ready_c4;
end
always_ff @ (posedge clk) begin
   slv_rd_data_c5 <= ram [slv_rd_addr];
end
always_ff @ (posedge clk) begin
   slv_wr_data_c5 <= slv_wr_data;
end
always_ff @ (posedge clk) begin
   slv_wr_strobe_c5 <= slv_wr_strobe;
end
always_ff @ (posedge clk) begin
   slv_wr_addr_c5 <= slv_wr_addr;
end
always_ff @ (posedge clk) begin
   if (c_mem_store_c5) begin
      ram [slv_wr_addr_c5] <= slv_wr_data_c5 & {{8 {slv_wr_strobe_c5 [3]}}, {8 {slv_wr_strobe_c5 [2]}}, {8 {slv_wr_strobe_c5 [1]}}, {8 {slv_wr_strobe_c5 [0]}}};
   end
end

//------------------- Item assignment(s):
assign slv_rd_data = slv_rd_data_c5;
assign slv_rd_addr = ic0_axi_slv_rd_addr;
assign slv_wr_strobe = ic0_axi_mst_wr_strobe;
assign slv_wr_data = ic0_axi_mst_wr_data;
assign slv_wr_addr = ic0_axi_mst_wr_addr;
assign ic0_axi_slv_rd_data_1 = slv_rd_data;
assign ic0_axi_slv_rd_addr = ic0_axi_mst_rd_addr;

//------------------- Condition assignment(s):
assign c_mem_store_c4 = (c_mem_store);
always_ff @ (posedge clk) begin
   c_mem_store_c5 <= c_mem_store_c4;
end
assign c_slv_rd_ready = (slv_rd_ready_c5 == 1'b1);
assign c_slv_rd_ready_c4 = (c_slv_rd_valid & (slv_rd_addr [11 : 10] != 2'h1));
assign c_mem_store = (c_slv_wr & (slv_wr_addr [11 : 10] != 2'h1));
assign c_slv_rd_valid = ic0_c_axi_slv_rd_valid;
assign c_slv_wr = ic0_c_axi_slv_wr_valid;
assign ic0_c_axi_slv_wr_valid = (ic0_c_axi_mst_wr_valid);
assign ic0_c_axi_slv_rd_ready_1 = c_slv_rd_ready;
assign ic0_c_axi_slv_rd_valid = (ic0_c_axi_mst_rd_valid);
endmodule