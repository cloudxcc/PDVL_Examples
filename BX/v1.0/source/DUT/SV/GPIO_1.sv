module GPIO_1 (
   inout [3 : 0] b2_data_io,
   input ic0_c_axi_mst_wr_valid,
   input ic0_c_axi_mst_rd_valid,
   output ic0_c_axi_slv_rd_ready_0,
   output [31 : 0] ic0_axi_slv_rd_data_0,
   input [31 : 0] ic0_axi_mst_wr_data,
   input [31 : 0] ic0_axi_mst_wr_addr,
   input [31 : 0] ic0_axi_mst_rd_addr,
   input clk);

//------------------- Parameter(s):
parameter b2_bw = 4;
parameter OFFSET = 32'h00000040 * 0;
parameter BASE = 32'h00000440;

//------------------- Register declaration(s):
reg data_in_rd_c5;
reg  [5 - 1 : 0] slv_wr_addr_c5;
reg  [31 : 0] slv_wr_data_c5;
reg  [3 : 0] gpio_data_in_reg;
reg  [3 : 0] gpio_data_out_reg;
reg  [3 : 0] gpio_data_tri_reg;
reg  [3 : 0] gpio_data_dir_reg;

//------------------- Procedural register declaration(s):
reg  [3 : 0] b2_data_in;
reg  [3 : 0] b2_data_out;
reg  [3 : 0] b2_data_tri;
reg  [3 : 0] b2_data_dir;
reg  [3 : 0] b2_data_io_out;
reg  [3 : 0] b2_data_io_in;
reg  [12 - 1 : 0] base_offset;
reg  [31 : 0] slv_rd_data;
reg  [11 : 0] slv_rd_addr;
reg  [31 : 0] slv_wr_data;
reg  [11 : 0] slv_wr_addr;
reg  [31 : 0] ic0_axi_slv_rd_data_0;
reg  [31 : 0] ic0_axi_slv_rd_addr;

//------------------- Condition declaration(s):
reg c_base_offset_c4;
reg c_base_offset_c5;
reg c_data_in_rd;
reg c_data_in_rd_c4;
reg c_data_out_set_c5;
reg c_data_out_clr_c5;
reg c_data_tri_set_c5;
reg c_data_tri_clr_c5;
reg c_data_dir_set_c5;
reg c_data_dir_clr_c5;
reg c_base_offset;
reg c_slv_rd_ready;
reg c_slv_rd;
reg c_slv_wr;
reg ic0_c_axi_slv_wr_valid;
reg ic0_c_axi_slv_rd_ready_0;
reg ic0_c_axi_slv_rd_valid;

//------------------- Register assignment(s):
always_ff @ (posedge clk) begin
   data_in_rd_c5 <= c_data_in_rd_c4;
end
always_ff @ (posedge clk) begin
   slv_wr_addr_c5 <= slv_wr_addr;
end
always_ff @ (posedge clk) begin
   slv_wr_data_c5 <= slv_wr_data;
end
always_ff @ (posedge clk) begin
   gpio_data_in_reg <= b2_data_in;
end
always_ff @ (posedge clk) begin
   if (c_data_out_clr_c5) begin
      gpio_data_out_reg <= gpio_data_out_reg & ~slv_wr_data_c5;
   end
   if (c_data_out_set_c5) begin
      gpio_data_out_reg <= gpio_data_out_reg | slv_wr_data_c5;
   end
end
always_ff @ (posedge clk) begin
   if (c_data_tri_clr_c5) begin
      gpio_data_tri_reg <= gpio_data_tri_reg & ~slv_wr_data_c5;
   end
   if (c_data_tri_set_c5) begin
      gpio_data_tri_reg <= gpio_data_tri_reg | slv_wr_data_c5;
   end
end
always_ff @ (posedge clk) begin
   if (c_data_dir_clr_c5) begin
      gpio_data_dir_reg <= gpio_data_dir_reg & ~slv_wr_data_c5;
   end
   if (c_data_dir_set_c5) begin
      gpio_data_dir_reg <= gpio_data_dir_reg | slv_wr_data_c5;
   end
end

//------------------- Item assignment(s):
always_comb begin
   b2_data_in = 4'hx;
   for (int b = 0; b < b2_bw; b = b + 1) begin
      if (!b2_data_io_in [b]) b2_data_in [b] = 1'b0;
      else b2_data_in [b] = 1'b1;
   end
end
assign b2_data_out = gpio_data_out_reg;
assign b2_data_tri = gpio_data_tri_reg;
assign b2_data_dir = gpio_data_dir_reg;
always_comb begin
   b2_data_io_out = 4'hx;
   for (int b = 0; b < b2_bw; b = b + 1) begin
      if (b2_data_dir [b]) begin
         if (b2_data_tri [b]) begin
            if (b2_data_out [b]) b2_data_io_out [b] = 1'bZ;
            else b2_data_io_out [b] = 1'b0;
         end
         else b2_data_io_out [b] = b2_data_out [b];
      end
      else b2_data_io_out [b] = 1'bZ;
   end
end
assign b2_data_io_in = b2_data_io;
assign b2_data_io = b2_data_io_out;
assign base_offset = BASE + OFFSET;
assign slv_rd_data = (c_data_in_rd) ? gpio_data_in_reg : 0;
assign slv_rd_addr = ic0_axi_slv_rd_addr;
assign slv_wr_data = ic0_axi_mst_wr_data;
assign slv_wr_addr = ic0_axi_mst_wr_addr;
assign ic0_axi_slv_rd_data_0 = slv_rd_data;
assign ic0_axi_slv_rd_addr = ic0_axi_mst_rd_addr;

//------------------- Condition assignment(s):
assign c_base_offset_c4 = (c_base_offset);
always_ff @ (posedge clk) begin
   c_base_offset_c5 <= c_base_offset_c4;
end
assign c_data_in_rd = (data_in_rd_c5 == 1'b1);
assign c_data_in_rd_c4 = (c_slv_rd & (slv_rd_addr [11 : 0] == (BASE + OFFSET + 32'h00000020)));
assign c_data_out_set_c5 = (c_base_offset_c5 & (slv_wr_addr_c5 [4 : 0] == 5'h14));
assign c_data_out_clr_c5 = (c_base_offset_c5 & (slv_wr_addr_c5 [4 : 0] == 5'h10));
assign c_data_tri_set_c5 = (c_base_offset_c5 & (slv_wr_addr_c5 [4 : 0] == 5'h0C));
assign c_data_tri_clr_c5 = (c_base_offset_c5 & (slv_wr_addr_c5 [4 : 0] == 5'h08));
assign c_data_dir_set_c5 = (c_base_offset_c5 & (slv_wr_addr_c5 [4 : 0] == 5'h04));
assign c_data_dir_clr_c5 = (c_base_offset_c5 & (slv_wr_addr_c5 [4 : 0] == 5'h00));
assign c_base_offset = (c_slv_wr & (slv_wr_addr [11 : 5] == base_offset [11 : 5]));
assign c_slv_rd_ready = (c_data_in_rd);
assign c_slv_rd = ic0_c_axi_slv_rd_valid;
assign c_slv_wr = ic0_c_axi_slv_wr_valid;
assign ic0_c_axi_slv_wr_valid = (ic0_c_axi_mst_wr_valid);
assign ic0_c_axi_slv_rd_ready_0 = c_slv_rd_ready;
assign ic0_c_axi_slv_rd_valid = (ic0_c_axi_mst_rd_valid);
endmodule