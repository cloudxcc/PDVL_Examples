module RISCV (
   input [31 : 0] instr,
   input c_arst,
   output [2 : 0] dmem_store_width,
   output [31 : 0] dmem_store_data,
   output [32 : 0] dmem_store_addr,
   output [32 : 0] dmem_load_addr,
   input [31 : 0] dmem_load_data,
   output c_dmem_store,
   output c_dmem_load,
   input clk,
   output [PC_LEN - 1 : 0] pc);

//------------------- Parameter(s):
parameter PC_LEN = 15;

//------------------- Register declaration(s):
reg  [31 : 0] rf [15 : 0];
reg  [PC_LEN - 1 : 0] pc;

//------------------- Procedural register declaration(s):
reg  [5 : 0] i_shamt_c;
reg  [31 : 0] sign_ext_imm8;
reg  [31 : 0] sign_ext_imm6_sp;
reg  [31 : 0] sign_ext_imm6;
reg  [31 : 0] sign_ext_imm8_c;
reg  [31 : 0] imm_jal_c;
reg  [31 : 0] imm_j_c;
reg  [31 : 0] offset_swsp_c;
reg  [31 : 0] offset_lwsp_c;
reg  [31 : 0] offset_c;
reg  [3 - 1 : 0] funct2_c;
reg  [3 - 1 : 0] funct3_c;
reg  [2 - 1 : 0] opcode_c;
reg  [63 : 0] i_m_mulhsu;
reg  [63 : 0] i_m_mulhu;
reg  [63 : 0] i_m_mulh;
reg  [63 : 0] i_m_mul;
reg  [31 : 0] dmem_store_data;
reg  [2 : 0] dmem_store_width;
reg  [32 : 0] dmem_store_addr;
reg  [2 : 0] dmem_load_width;
reg  [32 : 0] dmem_load_addr;
reg  [31 : 0] dp_out;
reg  [31 : 0] rd_dati;
reg  [4 : 0] rd_addr;
reg  [4 : 0] rs2_addr;
reg  [4 : 0] rs1_addr;
reg  [31 : 0] rs2_dato;
reg  [31 : 0] rs1_dato;
reg  [3 : 0] succ;
reg  [3 : 0] pred;
reg  [3 : 0] fm;
reg  [11 : 0] imm_11;
reg  [31 : 0] offset_20;
reg  [4 : 0] shamt;
reg  [31 : 0] u_immediate;
reg  [31 : 0] i_immediate;
reg  [19 : 0] j_type;
reg  [11 : 0] b_type;
reg  [12 - 1 : 0] s_type;
reg  [12 - 1 : 0] i_type;
reg  [7 - 1 : 0] opcode_i;
reg  [5 - 1 : 0] rdi;
reg  [5 - 1 : 0] rs1i;
reg  [5 - 1 : 0] rs2i;
reg  [3 - 1 : 0] funct3_i;
reg  [8 - 1 : 0] funct7_i;
reg  [PC_LEN - 1 : 0] pc_next;

//------------------- Condition declaration(s):
reg c_c_nzimm_sp_not_x0;
reg c_c_nzimm_not_x0;
reg c_c_rs2_not_x0;
reg c_c_rs2_x0;
reg c_c_rs1_not_x0;
reg c_c_rs1_x0;
reg c_c_rd_not_x2;
reg c_c_rd_not_x0;
reg c_c_op_2;
reg c_c_op_1;
reg c_c_op_0;
reg c_instr_c_swsp;
reg c_instr_c_add;
reg c_instr_c_jalr;
reg c_instr_c_ebreak;
reg c_instr_c_mv;
reg c_instr_c_jr;
reg c_instr_c_lwsp;
reg c_instr_c_slli;
reg c_instr_c_bnez;
reg c_instr_c_beqz;
reg c_instr_c_j;
reg c_instr_c_and;
reg c_instr_c_or;
reg c_instr_c_xor;
reg c_instr_c_sub;
reg c_instr_c_andi;
reg c_instr_c_srai;
reg c_instr_c_srli;
reg c_instr_c_addi16sp;
reg c_instr_c_lui;
reg c_instr_c_li;
reg c_instr_c_jal;
reg c_instr_c_addi;
reg c_instr_c_nop;
reg c_instr_c_sw;
reg c_instr_c_lw;
reg c_instr_c_addi4sp;
reg c_cond_bnez_c;
reg c_cond_beqz_c;
reg c_instr_m_remu;
reg c_instr_m_rem;
reg c_instr_m_divu;
reg c_instr_m_div;
reg c_instr_m_mulhsu;
reg c_instr_m_mulhu;
reg c_instr_m_mulh;
reg c_instr_m_mul;
reg c_instr_i_ebreak;
reg c_instr_i_ecall;
reg c_instr_i_fence;
reg c_instr_i_and;
reg c_instr_i_or;
reg c_instr_i_sra;
reg c_instr_i_srl;
reg c_instr_i_xor;
reg c_instr_i_sltu;
reg c_instr_i_slt;
reg c_instr_i_sll;
reg c_instr_i_sub;
reg c_instr_i_add;
reg c_instr_i_srai;
reg c_instr_i_srli;
reg c_instr_i_slli;
reg c_instr_i_andi;
reg c_instr_i_ori;
reg c_instr_i_xori;
reg c_instr_i_sltiu;
reg c_instr_i_slti;
reg c_instr_i_addi;
reg c_instr_i_sw;
reg c_instr_i_sh;
reg c_instr_i_sb;
reg c_instr_i_lhu;
reg c_instr_i_lbu;
reg c_instr_i_lw;
reg c_instr_i_lh;
reg c_instr_i_lb;
reg c_instr_i_bgeu;
reg c_instr_i_bltu;
reg c_instr_i_bge;
reg c_instr_i_blt;
reg c_instr_i_bne;
reg c_instr_i_beq;
reg c_instr_i_jalr;
reg c_instr_i_jal;
reg c_instr_i_auipc;
reg c_instr_i_lui;
reg c_dmem_store;
reg c_dmem_load;
reg c_rf_write;
reg c_cond_bgeu;
reg c_cond_bltu;
reg c_cond_bge;
reg c_cond_blt;
reg c_cond_bne;
reg c_cond_beq;

//------------------- Register assignment(s):
always_ff @ (posedge clk) begin
   if (c_rf_write) begin
      rf [rd_addr] <= rd_dati;
   end
end
always_ff @ (posedge clk or posedge c_arst) begin
   if (c_arst) begin
      pc <= 0;
   end
   else begin
      pc <= pc_next;
   end
end

//------------------- Item assignment(s):
assign i_shamt_c = {instr [12], instr [6 : 2]};
assign sign_ext_imm8 = {{22 {instr [10]}}, instr [10 : 7], instr [12 : 11], instr [5], instr [6], 2'b00};
assign sign_ext_imm6_sp = {{22 {instr [12]}}, instr [12], instr [4 : 3], instr [5], instr [2], instr [6], 4'h0};
assign sign_ext_imm6 = {{26 {instr [12]}}, instr [12], instr [6 : 2]};
assign sign_ext_imm8_c = {{26 {instr [12]}}, instr [12], instr [6 : 5], instr [2], instr [11 : 10], instr [4 : 3], 1'b0};
assign imm_jal_c = {{26 {instr [12]}}, instr [12], instr [8], instr [10 : 9], instr [6], instr [7], instr [2], instr [11], instr [5 : 3], 1'b0};
assign imm_j_c = {{26 {instr [12]}}, instr [12], instr [8], instr [10 : 9], instr [6], instr [7], instr [2], instr [11], instr [5 : 3], 1'b0};
assign offset_swsp_c = {{25 {1'b0}}, instr [8 : 7], instr [12 : 9], 2'b00};
assign offset_lwsp_c = {{26 {1'b0}}, instr [3 : 2], instr [12], instr [6 : 4], 2'b00};
assign offset_c = {{26 {1'b0}}, instr [5], instr [12 : 10], instr [6], 2'b00};
assign funct2_c = instr [6 : 5];
assign funct3_c = instr [15 : 13];
assign opcode_c = instr [1 : 0];
assign i_m_mulhsu = {{32 {rs1_dato [31]}}, rs1_dato} * {32'h00000000, rs2_dato};
assign i_m_mulhu = rs1_dato * rs2_dato;
assign i_m_mulh = $signed (rs1_dato) * $signed (rs2_dato);
assign i_m_mul = rs1_dato * rs2_dato;
always_comb begin
   dmem_store_data = 32'hxxxxxxxx;
   unique if (c_instr_i_sb) begin
      dmem_store_data = rs2_dato;
   end
   else if (c_instr_i_sh) begin
      dmem_store_data = rs2_dato;
   end
   else if (c_instr_i_sw) begin
      dmem_store_data = rs2_dato;
   end
   else if (c_instr_c_sw) begin
      dmem_store_data = rs2_dato;
   end
   else if (c_instr_c_swsp) begin
      dmem_store_data = rs2_dato;
   end
end
always_comb begin
   dmem_store_width = 3'hx;
   unique if (c_instr_i_sb) begin
      dmem_store_width = funct3_i [2 : 0];
   end
   else if (c_instr_i_sh) begin
      dmem_store_width = funct3_i [2 : 0];
   end
   else if (c_instr_i_sw) begin
      dmem_store_width = funct3_i [2 : 0];
   end
   else if (c_instr_c_sw) begin
      dmem_store_width = 2;
   end
   else if (c_instr_c_swsp) begin
      dmem_store_width = 2;
   end
end
always_comb begin
   dmem_store_addr = 33'hxxxxxxxxx;
   unique if (c_instr_i_sb) begin
      dmem_store_addr = {{20 {s_type [11]}}, s_type} + rs1_dato;
   end
   else if (c_instr_i_sh) begin
      dmem_store_addr = {{20 {s_type [11]}}, s_type} + rs1_dato;
   end
   else if (c_instr_i_sw) begin
      dmem_store_addr = {{20 {s_type [11]}}, s_type} + rs1_dato;
   end
   else if (c_instr_c_sw) begin
      dmem_store_addr = offset_c + rs1_dato;
   end
   else if (c_instr_c_swsp) begin
      dmem_store_addr = offset_swsp_c + rs1_dato;
   end
end
always_comb begin
   dmem_load_width = 3'hx;
   unique if (c_instr_i_lb) begin
      dmem_load_width = funct3_i [2 : 0];
   end
   else if (c_instr_i_lh) begin
      dmem_load_width = funct3_i [2 : 0];
   end
   else if (c_instr_i_lw) begin
      dmem_load_width = funct3_i [2 : 0];
   end
   else if (c_instr_i_lbu) begin
      dmem_load_width = funct3_i [2 : 0];
   end
   else if (c_instr_i_lhu) begin
      dmem_load_width = funct3_i [2 : 0];
   end
   else if (c_instr_c_lw) begin
      dmem_load_width = 2;
   end
   else if (c_instr_c_lwsp) begin
      dmem_load_width = 2;
   end
end
always_comb begin
   dmem_load_addr = 33'hxxxxxxxxx;
   unique if (c_instr_i_lb) begin
      dmem_load_addr = {{20 {i_type [11]}}, i_type} + rs1_dato;
   end
   else if (c_instr_i_lh) begin
      dmem_load_addr = {{20 {i_type [11]}}, i_type} + rs1_dato;
   end
   else if (c_instr_i_lw) begin
      dmem_load_addr = {{20 {i_type [11]}}, i_type} + rs1_dato;
   end
   else if (c_instr_i_lbu) begin
      dmem_load_addr = {{20 {i_type [11]}}, i_type} + rs1_dato;
   end
   else if (c_instr_i_lhu) begin
      dmem_load_addr = {{20 {i_type [11]}}, i_type} + rs1_dato;
   end
   else if (c_instr_c_lw) begin
      dmem_load_addr = offset_c + rs1_dato;
   end
   else if (c_instr_c_lwsp) begin
      dmem_load_addr = offset_lwsp_c + rs1_dato;
   end
end
always_comb begin
   dp_out = 32'hxxxxxxxx;
   unique if (c_instr_i_lui) begin
      dp_out = u_immediate;
   end
   else if (c_instr_i_auipc) begin
      dp_out = pc + u_immediate;
   end
   else if (c_instr_i_jal) begin
      dp_out = pc + 4;
   end
   else if (c_instr_i_jalr) begin
      dp_out = pc + 4;
   end
   else if (c_instr_i_lb) begin
      dp_out = {{24 {dmem_load_data [7]}}, dmem_load_data [7 : 0]};
   end
   else if (c_instr_i_lh) begin
      dp_out = {{16 {dmem_load_data [15]}}, dmem_load_data [15 : 0]};
   end
   else if (c_instr_i_lw) begin
      dp_out = dmem_load_data;
   end
   else if (c_instr_i_lbu) begin
      dp_out = {{24 {1'b0}}, dmem_load_data [7 : 0]};
   end
   else if (c_instr_i_lhu) begin
      dp_out = {{16 {1'b0}}, dmem_load_data [15 : 0]};
   end
   else if (c_instr_i_addi) begin
      dp_out = rs1_dato + i_immediate;
   end
   else if (c_instr_i_slti) begin
      dp_out = $signed (rs1_dato) < $signed (i_immediate);
   end
   else if (c_instr_i_sltiu) begin
      dp_out = rs1_dato < i_immediate;
   end
   else if (c_instr_i_xori) begin
      dp_out = rs1_dato ^ i_immediate;
   end
   else if (c_instr_i_ori) begin
      dp_out = rs1_dato | i_immediate;
   end
   else if (c_instr_i_andi) begin
      dp_out = rs1_dato & i_immediate;
   end
   else if (c_instr_i_slli) begin
      dp_out = rs1_dato << shamt;
   end
   else if (c_instr_i_srli) begin
      dp_out = rs1_dato >> shamt;
   end
   else if (c_instr_i_srai) begin
      dp_out = $signed (rs1_dato) >>> shamt;
   end
   else if (c_instr_i_add) begin
      dp_out = rs1_dato + rs2_dato;
   end
   else if (c_instr_i_sub) begin
      dp_out = rs1_dato - rs2_dato;
   end
   else if (c_instr_i_sll) begin
      dp_out = rs1_dato << rs2_dato;
   end
   else if (c_instr_i_slt) begin
      dp_out = $signed (rs1_dato) < $signed (rs2_dato);
   end
   else if (c_instr_i_sltu) begin
      dp_out = rs1_dato < rs2_dato;
   end
   else if (c_instr_i_xor) begin
      dp_out = rs1_dato ^ rs2_dato;
   end
   else if (c_instr_i_srl) begin
      dp_out = rs1_dato >> rs2_dato;
   end
   else if (c_instr_i_sra) begin
      dp_out = $signed (rs1_dato) >>> rs2_dato;
   end
   else if (c_instr_i_or) begin
      dp_out = rs1_dato | rs2_dato;
   end
   else if (c_instr_i_and) begin
      dp_out = rs1_dato & rs2_dato;
   end
   else if (c_instr_m_mul) begin
      dp_out = i_m_mul [31 : 0];
   end
   else if (c_instr_m_mulh) begin
      dp_out = i_m_mulh [63 : 32];
   end
   else if (c_instr_m_mulhu) begin
      dp_out = i_m_mulhu [63 : 32];
   end
   else if (c_instr_m_mulhsu) begin
      dp_out = i_m_mulhsu [63 : 32];
   end
   else if (c_instr_m_div) begin
      dp_out = $signed (rs1_dato) / $signed (rs2_dato);
   end
   else if (c_instr_m_divu) begin
      dp_out = rs1_dato / rs2_dato;
   end
   else if (c_instr_m_rem) begin
      dp_out = $signed (rs1_dato) % $signed (rs2_dato);
   end
   else if (c_instr_m_remu) begin
      dp_out = rs1_dato % rs2_dato;
   end
   else if (c_instr_c_addi4sp) begin
      dp_out = rs1_dato + sign_ext_imm8;
   end
   else if (c_instr_c_lw) begin
      dp_out = dmem_load_data;
   end
   else if (c_instr_c_addi) begin
      dp_out = rs1_dato + sign_ext_imm6;
   end
   else if (c_instr_c_jal) begin
      dp_out = pc + 2;
   end
   else if (c_instr_c_li) begin
      dp_out = {{26 {instr [12]}}, instr [12], instr [6 : 2]};
   end
   else if (c_instr_c_lui) begin
      dp_out = {{14 {instr [12]}}, instr [12], instr [6 : 2], 12'h000};
   end
   else if (c_instr_c_addi16sp) begin
      dp_out = rs1_dato + sign_ext_imm6_sp;
   end
   else if (c_instr_c_srli) begin
      dp_out = rs1_dato >> i_shamt_c;
   end
   else if (c_instr_c_srai) begin
      dp_out = $signed (rs1_dato) >>> i_shamt_c;
   end
   else if (c_instr_c_andi) begin
      dp_out = rs1_dato & sign_ext_imm6;
   end
   else if (c_instr_c_sub) begin
      dp_out = rs1_dato - rs2_dato;
   end
   else if (c_instr_c_xor) begin
      dp_out = rs1_dato ^ rs2_dato;
   end
   else if (c_instr_c_or) begin
      dp_out = rs1_dato | rs2_dato;
   end
   else if (c_instr_c_and) begin
      dp_out = rs1_dato & rs2_dato;
   end
   else if (c_instr_c_slli) begin
      dp_out = rs1_dato << i_shamt_c;
   end
   else if (c_instr_c_lwsp) begin
      dp_out = dmem_load_data;
   end
   else if (c_instr_c_mv) begin
      dp_out = rs2_dato;
   end
   else if (c_instr_c_jalr) begin
      dp_out = pc + 2;
   end
   else if (c_instr_c_add) begin
      dp_out = rs1_dato + rs2_dato;
   end
end
always_comb begin
   rd_dati = 32'hxxxxxxxx;
   unique if (c_instr_i_lui) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_auipc) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_jal) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_jalr) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_lb) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_lh) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_lw) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_lbu) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_lhu) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_addi) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_slti) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_sltiu) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_xori) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_ori) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_andi) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_slli) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_srli) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_srai) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_add) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_sub) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_sll) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_slt) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_sltu) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_xor) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_srl) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_sra) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_or) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_and) begin
      rd_dati = dp_out;
   end
   else if (c_instr_i_fence) begin
      rd_dati = dp_out;
   end
   else if (c_instr_m_mul) begin
      rd_dati = dp_out;
   end
   else if (c_instr_m_mulh) begin
      rd_dati = dp_out;
   end
   else if (c_instr_m_mulhu) begin
      rd_dati = dp_out;
   end
   else if (c_instr_m_mulhsu) begin
      rd_dati = dp_out;
   end
   else if (c_instr_m_div) begin
      rd_dati = dp_out;
   end
   else if (c_instr_m_divu) begin
      rd_dati = dp_out;
   end
   else if (c_instr_m_rem) begin
      rd_dati = dp_out;
   end
   else if (c_instr_m_remu) begin
      rd_dati = dp_out;
   end
   else if (c_instr_c_addi4sp) begin
      rd_dati = dp_out;
   end
   else if (c_instr_c_lw) begin
      rd_dati = dp_out;
   end
   else if (c_instr_c_addi) begin
      rd_dati = dp_out;
   end
   else if (c_instr_c_jal) begin
      rd_dati = dp_out;
   end
   else if (c_instr_c_li) begin
      rd_dati = dp_out;
   end
   else if (c_instr_c_lui) begin
      rd_dati = dp_out;
   end
   else if (c_instr_c_addi16sp) begin
      rd_dati = dp_out;
   end
   else if (c_instr_c_srli) begin
      rd_dati = dp_out;
   end
   else if (c_instr_c_srai) begin
      rd_dati = dp_out;
   end
   else if (c_instr_c_andi) begin
      rd_dati = dp_out;
   end
   else if (c_instr_c_sub) begin
      rd_dati = dp_out;
   end
   else if (c_instr_c_xor) begin
      rd_dati = dp_out;
   end
   else if (c_instr_c_or) begin
      rd_dati = dp_out;
   end
   else if (c_instr_c_and) begin
      rd_dati = dp_out;
   end
   else if (c_instr_c_slli) begin
      rd_dati = dp_out;
   end
   else if (c_instr_c_lwsp) begin
      rd_dati = dp_out;
   end
   else if (c_instr_c_mv) begin
      rd_dati = dp_out;
   end
   else if (c_instr_c_jalr) begin
      rd_dati = dp_out;
   end
   else if (c_instr_c_add) begin
      rd_dati = dp_out;
   end
end
always_comb begin
   rd_addr = 5'hxx;
   unique if (c_instr_i_lui) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_auipc) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_jal) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_jalr) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_lb) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_lh) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_lw) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_lbu) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_lhu) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_addi) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_slti) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_sltiu) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_xori) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_ori) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_andi) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_slli) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_srli) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_srai) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_add) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_sub) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_sll) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_slt) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_sltu) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_xor) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_srl) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_sra) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_or) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_and) begin
      rd_addr = rdi;
   end
   else if (c_instr_i_fence) begin
      rd_addr = rdi;
   end
   else if (c_instr_m_mul) begin
      rd_addr = rdi;
   end
   else if (c_instr_m_mulh) begin
      rd_addr = rdi;
   end
   else if (c_instr_m_mulhu) begin
      rd_addr = rdi;
   end
   else if (c_instr_m_mulhsu) begin
      rd_addr = rdi;
   end
   else if (c_instr_m_div) begin
      rd_addr = rdi;
   end
   else if (c_instr_m_divu) begin
      rd_addr = rdi;
   end
   else if (c_instr_m_rem) begin
      rd_addr = rdi;
   end
   else if (c_instr_m_remu) begin
      rd_addr = rdi;
   end
   else if (c_instr_c_addi4sp) begin
      rd_addr = {2'b01, instr [4 : 2]};
   end
   else if (c_instr_c_lw) begin
      rd_addr = {2'b01, instr [4 : 2]};
   end
   else if (c_instr_c_addi) begin
      rd_addr = instr [11 : 7];
   end
   else if (c_instr_c_jal) begin
      rd_addr = 1;
   end
   else if (c_instr_c_li) begin
      rd_addr = instr [11 : 7];
   end
   else if (c_instr_c_lui) begin
      rd_addr = instr [11 : 7];
   end
   else if (c_instr_c_addi16sp) begin
      rd_addr = instr [11 : 7];
   end
   else if (c_instr_c_srli) begin
      rd_addr = {2'b01, instr [9 : 7]};
   end
   else if (c_instr_c_srai) begin
      rd_addr = {2'b01, instr [9 : 7]};
   end
   else if (c_instr_c_andi) begin
      rd_addr = {2'b01, instr [9 : 7]};
   end
   else if (c_instr_c_sub) begin
      rd_addr = {2'b01, instr [9 : 7]};
   end
   else if (c_instr_c_xor) begin
      rd_addr = {2'b01, instr [9 : 7]};
   end
   else if (c_instr_c_or) begin
      rd_addr = {2'b01, instr [9 : 7]};
   end
   else if (c_instr_c_and) begin
      rd_addr = {2'b01, instr [9 : 7]};
   end
   else if (c_instr_c_slli) begin
      rd_addr = instr [11 : 7];
   end
   else if (c_instr_c_lwsp) begin
      rd_addr = instr [11 : 7];
   end
   else if (c_instr_c_mv) begin
      rd_addr = instr [11 : 7];
   end
   else if (c_instr_c_jalr) begin
      rd_addr = 1;
   end
   else if (c_instr_c_add) begin
      rd_addr = instr [11 : 7];
   end
end
always_comb begin
   rs2_addr = 5'hxx;
   unique if (c_instr_i_beq) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_i_bne) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_i_blt) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_i_bge) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_i_bltu) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_i_bgeu) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_i_sb) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_i_sh) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_i_sw) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_i_add) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_i_sub) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_i_sll) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_i_slt) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_i_sltu) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_i_xor) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_i_srl) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_i_sra) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_i_or) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_i_and) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_m_mul) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_m_mulh) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_m_mulhu) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_m_mulhsu) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_m_div) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_m_divu) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_m_rem) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_m_remu) begin
      rs2_addr = rs2i;
   end
   else if (c_instr_c_sw) begin
      rs2_addr = {2'b01, instr [4 : 2]};
   end
   else if (c_instr_c_sub) begin
      rs2_addr = {2'b01, instr [4 : 2]};
   end
   else if (c_instr_c_xor) begin
      rs2_addr = {2'b01, instr [4 : 2]};
   end
   else if (c_instr_c_or) begin
      rs2_addr = {2'b01, instr [4 : 2]};
   end
   else if (c_instr_c_and) begin
      rs2_addr = {2'b01, instr [4 : 2]};
   end
   else if (c_instr_c_mv) begin
      rs2_addr = instr [6 : 2];
   end
   else if (c_instr_c_add) begin
      rs2_addr = instr [6 : 2];
   end
   else if (c_instr_c_swsp) begin
      rs2_addr = instr [6 : 2];
   end
end
always_comb begin
   rs1_addr = 5'hxx;
   unique if (c_instr_i_jalr) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_beq) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_bne) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_blt) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_bge) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_bltu) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_bgeu) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_lb) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_lh) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_lw) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_lbu) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_lhu) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_sb) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_sh) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_sw) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_addi) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_slti) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_sltiu) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_xori) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_ori) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_andi) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_slli) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_srli) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_srai) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_add) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_sub) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_sll) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_slt) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_sltu) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_xor) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_srl) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_sra) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_or) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_and) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_i_fence) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_m_mul) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_m_mulh) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_m_mulhu) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_m_mulhsu) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_m_div) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_m_divu) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_m_rem) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_m_remu) begin
      rs1_addr = rs1i;
   end
   else if (c_instr_c_addi4sp) begin
      rs1_addr = 2;
   end
   else if (c_instr_c_lw) begin
      rs1_addr = {2'b01, instr [9 : 7]};
   end
   else if (c_instr_c_sw) begin
      rs1_addr = {2'b01, instr [9 : 7]};
   end
   else if (c_instr_c_addi) begin
      rs1_addr = instr [11 : 7];
   end
   else if (c_instr_c_addi16sp) begin
      rs1_addr = instr [11 : 7];
   end
   else if (c_instr_c_srli) begin
      rs1_addr = {2'b01, instr [9 : 7]};
   end
   else if (c_instr_c_srai) begin
      rs1_addr = {2'b01, instr [9 : 7]};
   end
   else if (c_instr_c_andi) begin
      rs1_addr = {2'b01, instr [9 : 7]};
   end
   else if (c_instr_c_sub) begin
      rs1_addr = {2'b01, instr [9 : 7]};
   end
   else if (c_instr_c_xor) begin
      rs1_addr = {2'b01, instr [9 : 7]};
   end
   else if (c_instr_c_or) begin
      rs1_addr = {2'b01, instr [9 : 7]};
   end
   else if (c_instr_c_and) begin
      rs1_addr = {2'b01, instr [9 : 7]};
   end
   else if (c_instr_c_beqz) begin
      rs1_addr = {2'b01, instr [9 : 7]};
   end
   else if (c_instr_c_bnez) begin
      rs1_addr = {2'b01, instr [9 : 7]};
   end
   else if (c_instr_c_slli) begin
      rs1_addr = instr [11 : 7];
   end
   else if (c_instr_c_lwsp) begin
      rs1_addr = 2;
   end
   else if (c_instr_c_jr) begin
      rs1_addr = instr [11 : 7];
   end
   else if (c_instr_c_jalr) begin
      rs1_addr = instr [11 : 7];
   end
   else if (c_instr_c_add) begin
      rs1_addr = instr [11 : 7];
   end
   else if (c_instr_c_swsp) begin
      rs1_addr = 2;
   end
end
assign rs2_dato = (rs2_addr == 0) ? 0 : rf [rs2_addr];
assign rs1_dato = (rs1_addr == 0) ? 0 : rf [rs1_addr];
always_comb begin
   succ = 4'hx;
   unique if (c_instr_i_fence) begin
      succ = instr [23 : 20];
   end
end
always_comb begin
   pred = 4'hx;
   unique if (c_instr_i_fence) begin
      pred = instr [27 : 24];
   end
end
always_comb begin
   fm = 4'hx;
   unique if (c_instr_i_fence) begin
      fm = instr [31 : 28];
   end
end
assign imm_11 = {{20 {instr [31]}}, instr [31 : 20]};
assign offset_20 = {{11 {j_type [19]}}, j_type, 1'b0};
assign shamt = instr [24 : 20];
assign u_immediate = {instr [31 : 12], 12'h000};
assign i_immediate = {{20 {instr [31]}}, instr [31 : 20]};
assign j_type = {instr [31], instr [19 : 12], instr [20], instr [30 : 21]};
assign b_type = {instr [31], instr [7], instr [30 : 25], instr [11 : 8]};
assign s_type = {instr [31 : 25], instr [11 : 7]};
assign i_type = instr [31 : 20];
assign opcode_i = instr [6 : 0];
assign rdi = instr [11 : 7];
assign rs1i = instr [19 : 15];
assign rs2i = instr [24 : 20];
assign funct3_i = instr [14 : 12];
assign funct7_i = instr [31 : 25];
always_comb begin
   for (integer i = 0; i < $size (pc_next); i = i + 1) begin
      pc_next [i] = 1'bx;
   end
   unique if (c_instr_i_lui) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_auipc) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_jal) begin
      pc_next = pc + offset_20;
   end
   else if (c_instr_i_jalr) begin
      pc_next = rs1_dato + imm_11;
   end
   else if (c_instr_i_beq) begin
      if (c_cond_beq) begin
         pc_next = pc + {b_type, 1'b0};
      end
      else begin
         pc_next = pc + 4;
      end
   end
   else if (c_instr_i_bne) begin
      if (c_cond_bne) begin
         pc_next = pc + {b_type, 1'b0};
      end
      else begin
         pc_next = pc + 4;
      end
   end
   else if (c_instr_i_blt) begin
      if (c_cond_blt) begin
         pc_next = pc + {b_type, 1'b0};
      end
      else begin
         pc_next = pc + 4;
      end
   end
   else if (c_instr_i_bge) begin
      if (c_cond_bge) begin
         pc_next = pc + {b_type, 1'b0};
      end
      else begin
         pc_next = pc + 4;
      end
   end
   else if (c_instr_i_bltu) begin
      if (c_cond_bltu) begin
         pc_next = pc + {b_type, 1'b0};
      end
      else begin
         pc_next = pc + 4;
      end
   end
   else if (c_instr_i_bgeu) begin
      if (c_cond_bgeu) begin
         pc_next = pc + {b_type, 1'b0};
      end
      else begin
         pc_next = pc + 4;
      end
   end
   else if (c_instr_i_lb) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_lh) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_lw) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_lbu) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_lhu) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_sb) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_sh) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_sw) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_addi) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_slti) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_sltiu) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_xori) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_ori) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_andi) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_slli) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_srli) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_srai) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_add) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_sub) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_sll) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_slt) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_sltu) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_xor) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_srl) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_sra) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_or) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_and) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_fence) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_ecall) begin
      pc_next = pc + 4;
   end
   else if (c_instr_i_ebreak) begin
      pc_next = pc + 4;
   end
   else if (c_instr_m_mul) begin
      pc_next = pc + 4;
   end
   else if (c_instr_m_mulh) begin
      pc_next = pc + 4;
   end
   else if (c_instr_m_mulhu) begin
      pc_next = pc + 4;
   end
   else if (c_instr_m_mulhsu) begin
      pc_next = pc + 4;
   end
   else if (c_instr_m_div) begin
      pc_next = pc + 4;
   end
   else if (c_instr_m_divu) begin
      pc_next = pc + 4;
   end
   else if (c_instr_m_rem) begin
      pc_next = pc + 4;
   end
   else if (c_instr_m_remu) begin
      pc_next = pc + 4;
   end
   else if (c_instr_c_addi4sp) begin
      pc_next = pc + 2;
   end
   else if (c_instr_c_lw) begin
      pc_next = pc + 2;
   end
   else if (c_instr_c_sw) begin
      pc_next = pc + 2;
   end
   else if (c_instr_c_nop) begin
      pc_next = pc + 2;
   end
   else if (c_instr_c_addi) begin
      pc_next = pc + 2;
   end
   else if (c_instr_c_jal) begin
      pc_next = pc + imm_j_c;
   end
   else if (c_instr_c_li) begin
      pc_next = pc + 2;
   end
   else if (c_instr_c_lui) begin
      pc_next = pc + 2;
   end
   else if (c_instr_c_addi16sp) begin
      pc_next = pc + 2;
   end
   else if (c_instr_c_srli) begin
      pc_next = pc + 2;
   end
   else if (c_instr_c_srai) begin
      pc_next = pc + 2;
   end
   else if (c_instr_c_andi) begin
      pc_next = pc + 2;
   end
   else if (c_instr_c_sub) begin
      pc_next = pc + 2;
   end
   else if (c_instr_c_xor) begin
      pc_next = pc + 2;
   end
   else if (c_instr_c_or) begin
      pc_next = pc + 2;
   end
   else if (c_instr_c_and) begin
      pc_next = pc + 2;
   end
   else if (c_instr_c_j) begin
      pc_next = pc + imm_j_c;
   end
   else if (c_instr_c_beqz) begin
      if (c_cond_beqz_c) begin
         pc_next = pc + sign_ext_imm8_c;
      end
      else begin
         pc_next = pc + 2;
      end
   end
   else if (c_instr_c_bnez) begin
      if (c_cond_bnez_c) begin
         pc_next = pc + sign_ext_imm8_c;
      end
      else begin
         pc_next = pc + 2;
      end
   end
   else if (c_instr_c_slli) begin
      pc_next = pc + 2;
   end
   else if (c_instr_c_lwsp) begin
      pc_next = pc + 2;
   end
   else if (c_instr_c_jr) begin
      pc_next = rs1_dato;
   end
   else if (c_instr_c_mv) begin
      pc_next = pc + 2;
   end
   else if (c_instr_c_ebreak) begin
      pc_next = pc + 2;
   end
   else if (c_instr_c_jalr) begin
      pc_next = rs1_dato;
   end
   else if (c_instr_c_add) begin
      pc_next = pc + 2;
   end
   else if (c_instr_c_swsp) begin
      pc_next = pc + 2;
   end
end

//------------------- Condition(s) as function(s):
function bit c_cmp;
input integer a;
input integer b;
begin
   c_cmp = 1'b0;
   if (a == b) begin
      c_cmp = 1'b1;
   end
end
endfunction

//------------------- Condition assignment(s):
assign c_c_nzimm_sp_not_x0 = (sign_ext_imm6_sp != 32'h00000000);
assign c_c_nzimm_not_x0 = (sign_ext_imm6 != 32'h00000000);
assign c_c_rs2_not_x0 = (instr [6 : 2] != 5'b00000);
assign c_c_rs2_x0 = (instr [6 : 2] == 5'b00000);
assign c_c_rs1_not_x0 = (instr [11 : 7] != 5'b00000);
assign c_c_rs1_x0 = (instr [11 : 7] == 5'b00000);
assign c_c_rd_not_x2 = (instr [11 : 7] != 5'b00010);
assign c_c_rd_not_x0 = (instr [11 : 7] != 5'b00000);
assign c_c_op_2 = (instr [1 : 0] == 2'b10);
assign c_c_op_1 = (instr [1 : 0] == 2'b01);
assign c_c_op_0 = (instr [1 : 0] == 2'b00);
assign c_instr_c_swsp = ((c_c_op_2) & (c_cmp (funct3_c, 6)));
assign c_instr_c_add = ((c_c_op_2) & (c_cmp (funct3_c, 4)) & (c_cmp (instr [12], 1)) & (c_c_rd_not_x0) & (c_c_rs1_not_x0) & (c_c_rs2_not_x0));
assign c_instr_c_jalr = ((c_c_op_2) & (c_cmp (funct3_c, 4)) & (c_cmp (instr [12], 1)) & (c_c_rs1_not_x0) & (c_c_rs2_x0));
assign c_instr_c_ebreak = ((c_c_op_2) & (c_cmp (funct3_c, 4)) & (c_cmp (instr [12], 1)) & (c_c_rs1_x0) & (c_c_rs2_x0));
assign c_instr_c_mv = ((c_c_op_2) & (c_cmp (funct3_c, 4)) & (c_cmp (instr [12], 0)) & (c_c_rd_not_x0) & (c_c_rs2_not_x0));
assign c_instr_c_jr = ((c_c_op_2) & (c_cmp (funct3_c, 4)) & (c_cmp (instr [12], 0)) & (c_c_rs1_not_x0) & (c_c_rs2_x0));
assign c_instr_c_lwsp = ((c_c_op_2) & (c_cmp (funct3_c, 2)));
assign c_instr_c_slli = ((c_c_op_2) & (c_cmp (funct3_c, 0)) & (c_c_rd_not_x0));
assign c_instr_c_bnez = ((c_c_op_1) & (c_cmp (funct3_c, 7)));
assign c_instr_c_beqz = ((c_c_op_1) & (c_cmp (funct3_c, 6)));
assign c_instr_c_j = ((c_c_op_1) & (c_cmp (funct3_c, 5)));
assign c_instr_c_and = ((c_c_op_1) & (c_cmp (funct3_c, 4)) & (c_cmp (instr [11 : 10], 3)) & (c_cmp (instr [12], 0)) & (c_cmp (instr [6 : 5], 3)));
assign c_instr_c_or = ((c_c_op_1) & (c_cmp (funct3_c, 4)) & (c_cmp (instr [11 : 10], 3)) & (c_cmp (instr [12], 0)) & (c_cmp (instr [6 : 5], 2)));
assign c_instr_c_xor = ((c_c_op_1) & (c_cmp (funct3_c, 4)) & (c_cmp (instr [11 : 10], 3)) & (c_cmp (instr [12], 0)) & (c_cmp (instr [6 : 5], 1)));
assign c_instr_c_sub = ((c_c_op_1) & (c_cmp (funct3_c, 4)) & (c_cmp (instr [11 : 10], 3)) & (c_cmp (instr [12], 0)) & (c_cmp (instr [6 : 5], 0)));
assign c_instr_c_andi = ((c_c_op_1) & (c_cmp (funct3_c, 4)) & (c_cmp (instr [11 : 10], 2)));
assign c_instr_c_srai = ((c_c_op_1) & (c_cmp (funct3_c, 4)) & (c_cmp (instr [11 : 10], 1)));
assign c_instr_c_srli = ((c_c_op_1) & (c_cmp (funct3_c, 4)) & (c_cmp (instr [11 : 10], 0)));
assign c_instr_c_addi16sp = ((c_c_op_1) & (c_cmp (funct3_c, 3)) & (c_cmp (instr [11 : 7], 2)));
assign c_instr_c_lui = ((c_c_op_1) & (c_cmp (funct3_c, 3)) & (c_c_rd_not_x0) & (c_c_rd_not_x2));
assign c_instr_c_li = ((c_c_op_1) & (c_cmp (funct3_c, 2)));
assign c_instr_c_jal = ((c_c_op_1) & (c_cmp (funct3_c, 1)));
assign c_instr_c_addi = ((c_c_op_1) & (c_cmp (funct3_c, 0)) & (c_c_nzimm_not_x0) & (c_c_rd_not_x0));
assign c_instr_c_nop = ((c_c_op_1) & (c_cmp (funct3_c, 0)) & (c_c_rs1_x0));
assign c_instr_c_sw = ((c_cmp (opcode_c, 0)) & (c_cmp (funct3_c, 6)));
assign c_instr_c_lw = ((c_cmp (opcode_c, 0)) & (c_cmp (funct3_c, 2)));
assign c_instr_c_addi4sp = ((c_cmp (opcode_c, 0)) & (c_cmp (funct3_c, 0)));
assign c_cond_bnez_c = (rs1_dato != 0);
assign c_cond_beqz_c = (rs1_dato == 0);
assign c_instr_m_remu = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct7_i, 7'b0000001)) & (c_cmp (funct3_i, 7)));
assign c_instr_m_rem = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct7_i, 7'b0000001)) & (c_cmp (funct3_i, 6)));
assign c_instr_m_divu = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct7_i, 7'b0000001)) & (c_cmp (funct3_i, 5)));
assign c_instr_m_div = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct7_i, 7'b0000001)) & (c_cmp (funct3_i, 4)));
assign c_instr_m_mulhsu = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct7_i, 7'b0000001)) & (c_cmp (funct3_i, 2)));
assign c_instr_m_mulhu = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct7_i, 7'b0000001)) & (c_cmp (funct3_i, 3)));
assign c_instr_m_mulh = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct7_i, 7'b0000001)) & (c_cmp (funct3_i, 1)));
assign c_instr_m_mul = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct7_i, 7'b0000001)) & (c_cmp (funct3_i, 0)));
assign c_instr_i_ebreak = ((c_cmp (opcode_i, 7'b1110011)) & (c_cmp (instr [31 : 7], 25'h002000)));
assign c_instr_i_ecall = ((c_cmp (opcode_i, 7'b1110011)) & (c_cmp (instr [31 : 7], 25'h000000)));
assign c_instr_i_fence = ((c_cmp (opcode_i, 7'b1110011)) & (c_cmp (funct3_i, 0)));
assign c_instr_i_and = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct3_i, 7)) & (c_cmp (funct7_i, 0)));
assign c_instr_i_or = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct3_i, 6)) & (c_cmp (funct7_i, 0)));
assign c_instr_i_sra = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct3_i, 5)) & (c_cmp (funct7_i, 32)));
assign c_instr_i_srl = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct3_i, 5)) & (c_cmp (funct7_i, 0)));
assign c_instr_i_xor = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct3_i, 4)) & (c_cmp (funct7_i, 0)));
assign c_instr_i_sltu = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct3_i, 3)) & (c_cmp (funct7_i, 0)));
assign c_instr_i_slt = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct3_i, 2)) & (c_cmp (funct7_i, 0)));
assign c_instr_i_sll = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct3_i, 1)) & (c_cmp (funct7_i, 0)));
assign c_instr_i_sub = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct3_i, 0)) & (c_cmp (funct7_i, 32)));
assign c_instr_i_add = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct3_i, 0)) & (c_cmp (funct7_i, 0)));
assign c_instr_i_srai = ((c_cmp (opcode_i, 7'b0010011)) & (c_cmp (funct3_i, 5)) & (c_cmp (funct7_i, 32)));
assign c_instr_i_srli = ((c_cmp (opcode_i, 7'b0010011)) & (c_cmp (funct3_i, 5)) & (c_cmp (funct7_i, 0)));
assign c_instr_i_slli = ((c_cmp (opcode_i, 7'b0010011)) & (c_cmp (funct3_i, 1)) & (c_cmp (funct7_i, 0)));
assign c_instr_i_andi = ((c_cmp (opcode_i, 7'b0010011)) & (c_cmp (funct3_i, 7)));
assign c_instr_i_ori = ((c_cmp (opcode_i, 7'b0010011)) & (c_cmp (funct3_i, 6)));
assign c_instr_i_xori = ((c_cmp (opcode_i, 7'b0010011)) & (c_cmp (funct3_i, 4)));
assign c_instr_i_sltiu = ((c_cmp (opcode_i, 7'b0010011)) & (c_cmp (funct3_i, 3)));
assign c_instr_i_slti = ((c_cmp (opcode_i, 7'b0010011)) & (c_cmp (funct3_i, 2)));
assign c_instr_i_addi = ((c_cmp (opcode_i, 7'b0010011)) & (c_cmp (funct3_i, 0)));
assign c_instr_i_sw = ((c_cmp (opcode_i, 7'b0100011)) & (c_cmp (funct3_i, 2)));
assign c_instr_i_sh = ((c_cmp (opcode_i, 7'b0100011)) & (c_cmp (funct3_i, 1)));
assign c_instr_i_sb = ((c_cmp (opcode_i, 7'b0100011)) & (c_cmp (funct3_i, 0)));
assign c_instr_i_lhu = ((c_cmp (opcode_i, 7'b0000011)) & (c_cmp (funct3_i, 5)));
assign c_instr_i_lbu = ((c_cmp (opcode_i, 7'b0000011)) & (c_cmp (funct3_i, 4)));
assign c_instr_i_lw = ((c_cmp (opcode_i, 7'b0000011)) & (c_cmp (funct3_i, 2)));
assign c_instr_i_lh = ((c_cmp (opcode_i, 7'b0000011)) & (c_cmp (funct3_i, 1)));
assign c_instr_i_lb = ((c_cmp (opcode_i, 7'b0000011)) & (c_cmp (funct3_i, 0)));
assign c_instr_i_bgeu = ((c_cmp (opcode_i, 7'b1100011)) & (c_cmp (funct3_i, 7)));
assign c_instr_i_bltu = ((c_cmp (opcode_i, 7'b1100011)) & (c_cmp (funct3_i, 6)));
assign c_instr_i_bge = ((c_cmp (opcode_i, 7'b1100011)) & (c_cmp (funct3_i, 5)));
assign c_instr_i_blt = ((c_cmp (opcode_i, 7'b1100011)) & (c_cmp (funct3_i, 4)));
assign c_instr_i_bne = ((c_cmp (opcode_i, 7'b1100011)) & (c_cmp (funct3_i, 1)));
assign c_instr_i_beq = ((c_cmp (opcode_i, 7'b1100011)) & (c_cmp (funct3_i, 0)));
assign c_instr_i_jalr = ((c_cmp (opcode_i, 7'b1100111)) & (c_cmp (funct3_i, 0)));
assign c_instr_i_jal = (c_cmp (opcode_i, 7'b1101111));
assign c_instr_i_auipc = (c_cmp (opcode_i, 7'b0010111));
assign c_instr_i_lui = (c_cmp (opcode_i, 7'b0110111));
always_comb begin
   c_dmem_store = 1'b0;
   unique if (c_instr_i_sb) begin
      c_dmem_store = 1'b1;
   end
   else if (c_instr_i_sh) begin
      c_dmem_store = 1'b1;
   end
   else if (c_instr_i_sw) begin
      c_dmem_store = 1'b1;
   end
   else if (c_instr_c_sw) begin
      c_dmem_store = 1'b1;
   end
   else if (c_instr_c_swsp) begin
      c_dmem_store = 1'b1;
   end
end
always_comb begin
   c_dmem_load = 1'b0;
   unique if (c_instr_i_lb) begin
      c_dmem_load = 1'b1;
   end
   else if (c_instr_i_lh) begin
      c_dmem_load = 1'b1;
   end
   else if (c_instr_i_lw) begin
      c_dmem_load = 1'b1;
   end
   else if (c_instr_i_lbu) begin
      c_dmem_load = 1'b1;
   end
   else if (c_instr_i_lhu) begin
      c_dmem_load = 1'b1;
   end
   else if (c_instr_c_lw) begin
      c_dmem_load = 1'b1;
   end
   else if (c_instr_c_lwsp) begin
      c_dmem_load = 1'b1;
   end
end
always_comb begin
   c_rf_write = 1'b0;
   unique if (c_instr_i_lui) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_auipc) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_jal) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_jalr) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_lb) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_lh) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_lw) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_lbu) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_lhu) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_addi) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_slti) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_sltiu) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_xori) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_ori) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_andi) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_slli) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_srli) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_srai) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_add) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_sub) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_sll) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_slt) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_sltu) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_xor) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_srl) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_sra) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_or) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_and) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_i_fence) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_m_mul) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_m_mulh) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_m_mulhu) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_m_mulhsu) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_m_div) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_m_divu) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_m_rem) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_m_remu) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_c_addi4sp) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_c_lw) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_c_addi) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_c_jal) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_c_li) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_c_lui) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_c_addi16sp) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_c_srli) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_c_srai) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_c_andi) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_c_sub) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_c_xor) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_c_or) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_c_and) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_c_slli) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_c_lwsp) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_c_mv) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_c_jalr) begin
      c_rf_write = 1'b1;
   end
   else if (c_instr_c_add) begin
      c_rf_write = 1'b1;
   end
end
assign c_cond_bgeu = (rs1_dato >= rs2_dato);
assign c_cond_bltu = (rs1_dato < rs2_dato);
assign c_cond_bge = ($signed (rs1_dato) >= $signed (rs2_dato));
assign c_cond_blt = ($signed (rs1_dato) < $signed (rs2_dato));
assign c_cond_bne = (rs1_dato != rs2_dato);
assign c_cond_beq = (rs1_dato == rs2_dato);
endmodule