module GPIO_1 (
   input c_sys_rst,
   inout [b1_bw - 1 : 0] b1_data_io,
   input ic0_c_axi_mst_wr_valid,
   input ic0_c_axi_mst_rd_valid,
   output ic0_c_axi_slv_rd_ready_1,
   output [31 : 0] ic0_axi_slv_rd_data_1,
   input [31 : 0] ic0_axi_mst_wr_data,
   input [31 : 0] ic0_axi_mst_wr_addr,
   input [31 : 0] ic0_axi_mst_rd_addr,
   input clk);

//------------------- Parameter(s):
parameter BASE = 32'h80030000;
parameter b1_bw = 8;
parameter OFFSET = 32'h00000100 * 1;

//------------------- Register declaration(s):
reg  [7 : 0] gpio_data_in_reg;
reg  [7 : 0] gpio_data_out_reg;
reg  [7 : 0] gpio_data_tri_reg;
reg  [7 : 0] gpio_data_dir_reg;

//------------------- Procedural register declaration(s):
reg  [b1_bw - 1 : 0] b1_data_in;
reg  [b1_bw - 1 : 0] b1_data_out;
reg  [b1_bw - 1 : 0] b1_data_tri;
reg  [b1_bw - 1 : 0] b1_data_io_out;
reg  [b1_bw - 1 : 0] b1_data_io_in;
reg  [31 : 0] slv_rd_data;
reg  [31 : 0] slv_rd_addr;
reg  [31 : 0] slv_wr_data;
reg  [31 : 0] slv_wr_addr;
reg  [31 : 0] ic0_axi_slv_rd_data_1;
reg  [31 : 0] ic0_axi_slv_rd_addr;

//------------------- Condition declaration(s):
reg c_data_in_rd;
reg c_data_out_set;
reg c_data_out_clr;
reg c_data_tri_set;
reg c_data_tri_clr;
reg c_data_dir_set;
reg c_data_dir_clr;
reg c_slv_rd_ready;
reg c_slv_rd;
reg c_slv_wr;
reg ic0_c_axi_slv_wr_valid;
reg ic0_c_axi_slv_rd_ready_1;
reg ic0_c_axi_slv_rd_valid;

//------------------- Register assignment(s):
always_ff @ (posedge clk or posedge c_sys_rst) begin
   if (c_sys_rst) begin
      gpio_data_in_reg <= 0;
   end
   else begin
      gpio_data_in_reg <= b1_data_in;
   end
end
always_ff @ (posedge clk or posedge c_sys_rst) begin
   if (c_sys_rst) begin
      gpio_data_out_reg <= 0;
   end
   else begin
      if (c_data_out_clr) begin
         gpio_data_out_reg <= gpio_data_out_reg & !slv_wr_data;
      end
      if (c_data_out_set) begin
         gpio_data_out_reg <= gpio_data_out_reg | slv_wr_data;
      end
   end
end
always_ff @ (posedge clk or posedge c_sys_rst) begin
   if (c_sys_rst) begin
      gpio_data_tri_reg <= 0;
   end
   else begin
      if (c_data_tri_clr) begin
         gpio_data_tri_reg <= gpio_data_tri_reg & !slv_wr_data;
      end
      if (c_data_tri_set) begin
         gpio_data_tri_reg <= gpio_data_tri_reg | slv_wr_data;
      end
   end
end
always_ff @ (posedge clk or posedge c_sys_rst) begin
   if (c_sys_rst) begin
      gpio_data_dir_reg <= 0;
   end
   else begin
      if (c_data_dir_clr) begin
         gpio_data_dir_reg <= gpio_data_dir_reg & !slv_wr_data;
      end
      if (c_data_dir_set) begin
         gpio_data_dir_reg <= gpio_data_dir_reg | slv_wr_data;
      end
   end
end

//------------------- Item assignment(s):
always_comb begin
   for (integer i = 0; i < $size (b1_data_in); i = i + 1) begin
      b1_data_in [i] = 1'bx;
   end
   for (int b = 0; b < b1_bw; b = b + 1) begin
      if (!b1_data_io_in [b]) b1_data_in [b] = 1'b0;
      else b1_data_in [b] = 1'b1;
   end
end
assign b1_data_out = gpio_data_out_reg;
assign b1_data_tri = gpio_data_tri_reg;
always_comb begin
   for (integer i = 0; i < $size (b1_data_io_out); i = i + 1) begin
      b1_data_io_out [i] = 1'bx;
   end
   for (int b = 0; b < b1_bw; b = b + 1) begin
      if (b1_data_tri [b]) begin
         if (b1_data_out [b]) b1_data_io_out [b] = 1'bZ;
         else b1_data_io_out [b] = 1'b0;
      end
      else b1_data_io_out [b] = b1_data_out [b];
   end
end
assign b1_data_io_in = b1_data_io;
assign b1_data_io = b1_data_io_out;
always_comb begin
   slv_rd_data = 32'hxxxxxxxx;
   if (c_data_in_rd) begin
      slv_rd_data = gpio_data_in_reg;
   end
end
assign slv_rd_addr = ic0_axi_slv_rd_addr;
assign slv_wr_data = ic0_axi_mst_wr_data;
assign slv_wr_addr = ic0_axi_mst_wr_addr;
assign ic0_axi_slv_rd_data_1 = slv_rd_data;
assign ic0_axi_slv_rd_addr = ic0_axi_mst_rd_addr;

//------------------- Condition assignment(s):
assign c_data_in_rd = (c_slv_rd & (slv_rd_addr == (BASE + OFFSET + 32'h00000020)));
assign c_data_out_set = (c_slv_wr & (slv_wr_addr == (BASE + OFFSET + 32'h00000014)));
assign c_data_out_clr = (c_slv_wr & (slv_wr_addr == (BASE + OFFSET + 32'h00000010)));
assign c_data_tri_set = (c_slv_wr & (slv_wr_addr == (BASE + OFFSET + 32'h0000000C)));
assign c_data_tri_clr = (c_slv_wr & (slv_wr_addr == (BASE + OFFSET + 32'h00000008)));
assign c_data_dir_set = (c_slv_wr & (slv_wr_addr == (BASE + OFFSET + 32'h00000004)));
assign c_data_dir_clr = (c_slv_wr & (slv_wr_addr == (BASE + OFFSET + 32'h00000000)));
assign c_slv_rd_ready = (c_data_in_rd);
assign c_slv_rd = ic0_c_axi_slv_rd_valid;
assign c_slv_wr = ic0_c_axi_slv_wr_valid;
assign ic0_c_axi_slv_wr_valid = (ic0_c_axi_mst_wr_valid);
assign ic0_c_axi_slv_rd_ready_1 = c_slv_rd_ready;
assign ic0_c_axi_slv_rd_valid = (ic0_c_axi_mst_rd_valid);
endmodule