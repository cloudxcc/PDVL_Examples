module RV32_1P_RF (
   input c_rf_wr,
   input [31 : 0] rd_dati,
   input [8 - 1 : 0] rd_addr_c6,
   input [8 - 1 : 0] rs2_addr_c1,
   output [31 : 0] rs2_dato_reg_c2,
   input [8 - 1 : 0] rs1_addr_c1,
   output [31 : 0] rs1_dato_reg_c2,
   input clk);

//------------------- Register declaration(s):
reg  [31 : 0] rf [255 : 0];
reg  [31 : 0] rs2_dato_reg_c2;
reg  [31 : 0] rs1_dato_reg_c2;

//------------------- Register assignment(s):
always_ff @ (posedge clk) begin
   if (c_rf_wr) begin
      rf [rd_addr_c6] <= rd_dati;
   end
end
always_ff @ (posedge clk) begin
   rs2_dato_reg_c2 <= rf [rs2_addr_c1];
end
always_ff @ (posedge clk) begin
   rs1_dato_reg_c2 <= rf [rs1_addr_c1];
end
endmodule