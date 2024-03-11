module RV32IMC_3P_RF (
   input c_rf_write,
   input [31 : 0] rd_dati,
   input [4 : 0] rd_addr,
   input [4 : 0] rs2_addr,
   output [31 : 0] rs2_dato_async,
   input [4 : 0] rs1_addr,
   output [31 : 0] rs1_dato_async,
   input clk);

//------------------- Register declaration(s):
reg  [31 : 0] rf [31 : 0];

//------------------- Procedural register declaration(s):
reg  [31 : 0] rs2_dato_async;
reg  [31 : 0] rs1_dato_async;

//------------------- Register assignment(s):
always_ff @ (posedge clk) begin
   if (c_rf_write) begin
      rf [rd_addr] <= rd_dati;
   end
end

//------------------- Item assignment(s):
assign rs2_dato_async = (rs2_addr == 0) ? 0 : rf [rs2_addr];
assign rs1_dato_async = (rs1_addr == 0) ? 0 : rf [rs1_addr];
endmodule