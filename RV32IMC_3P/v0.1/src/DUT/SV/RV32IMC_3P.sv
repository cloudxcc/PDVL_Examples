module RV32IMC_3P (
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
parameter PC_LEN = 32;

//------------------- Register declaration(s):
reg  [31 : 0] math_reg2;
reg  [31 : 0] math_reg1;
reg  [31 : 0] math_reg0;
reg  [31 : 0] rs2_dato;
reg  [31 : 0] rs1_dato;
reg  [32 - 1 : 0] instr_s2;
reg  [32 - 1 : 0] instr_s1;
reg  [PC_LEN - 1 : 0] pc;
reg pc4_s2;
reg pc4_s1;
reg  [1 : 0] pv;
reg  [5 : 0] mc;

//------------------- Procedural register declaration(s):
reg  [5 : 0] i_shamt_c;
reg  [31 : 0] sign_ext_imm8;
reg  [31 : 0] sign_ext_imm6_sp;
reg  [31 : 0] sign_ext_imm6_s1;
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
reg  [3 - 1 : 0] funct2_c_s1;
reg  [3 - 1 : 0] funct3_c_s1;
reg  [2 - 1 : 0] opcode_c_s1;
reg  [31 : 0] divisor_shifted;
reg  [4 : 0] div_init_shift;
reg  [4 : 0] leading_bit_divisor_loc;
reg  [4 : 0] leading_bit_divident_loc;
reg leading_bit_divisor_val;
reg leading_bit_divident_val;
reg  [31 : 0] divisor;
reg  [31 : 0] divident;
reg  [33 : 0] i_mul_out;
reg  [16 : 0] i_mul_b;
reg  [16 : 0] i_mul_a;
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
reg  [3 : 0] succ;
reg  [3 : 0] pred;
reg  [3 : 0] fm;
reg  [11 : 0] imm_11;
reg  [31 : 0] offset_20;
reg  [31 : 0] d_sub_2compl;
reg  [31 : 0] i_sub_b;
reg  [32 : 0] sra_result;
reg  [31 : 0] i_sra_shamt;
reg  [32 : 0] i_sra_data;
reg  [31 : 0] shl_result;
reg  [31 : 0] i_shl_shamt;
reg  [31 : 0] i_shl_data;
reg  [4 : 0] shamt;
reg  [31 : 0] less_result;
reg  [32 : 0] i_less_b;
reg  [32 : 0] i_less_a;
reg  [31 : 0] dp_add;
reg  [31 : 0] i_add_b;
reg  [31 : 0] i_add_a;
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
reg  [3 - 1 : 0] funct3_i_s1;
reg  [8 - 1 : 0] funct7_i_s1;
reg  [7 - 1 : 0] opcode_i_s1;
reg  [PC_LEN - 1 : 0] pc_next;
reg  [31 : 0] pc_clear;

//------------------- Condition declaration(s):
reg c_c_nzimm_not_x0_s1;
reg c_c_nzimm_not_x0;
reg c_c_rs2_not_x0_s1;
reg c_c_rs2_not_x0;
reg c_c_rs2_x0_s1;
reg c_c_rs2_x0;
reg c_c_rs1_not_x0_s1;
reg c_c_rs1_not_x0;
reg c_c_rs1_x0_s1;
reg c_c_rs1_x0;
reg c_c_rd_not_x2_s1;
reg c_c_rd_not_x2;
reg c_c_rd_not_x0_s1;
reg c_c_rd_not_x0;
reg c_instr_c_swsp_s2;
reg c_instr_c_add_s2;
reg c_instr_c_jalr_s2;
reg c_instr_c_ebreak_s2;
reg c_instr_c_mv_s2;
reg c_instr_c_jr_s2;
reg c_instr_c_lwsp_s2;
reg c_instr_c_slli_s2;
reg c_instr_c_bnez_s2;
reg c_instr_c_beqz_s2;
reg c_instr_c_j_s2;
reg c_instr_c_and_s2;
reg c_instr_c_or_s2;
reg c_instr_c_xor_s2;
reg c_instr_c_sub_s2;
reg c_instr_c_andi_s2;
reg c_instr_c_srai_s2;
reg c_instr_c_srli_s2;
reg c_instr_c_addi16sp_s2;
reg c_instr_c_lui_s2;
reg c_instr_c_li_s2;
reg c_instr_c_jal_s2;
reg c_instr_c_addi_s2;
reg c_instr_c_nop_s2;
reg c_instr_c_sw_s2;
reg c_instr_c_lw_s2;
reg c_instr_c_addi4sp_s2;
reg c_instr_c_swsp_s1;
reg c_instr_c_add_s1;
reg c_instr_c_jalr_s1;
reg c_instr_c_ebreak_s1;
reg c_instr_c_mv_s1;
reg c_instr_c_jr_s1;
reg c_instr_c_lwsp_s1;
reg c_instr_c_slli_s1;
reg c_instr_c_bnez_s1;
reg c_instr_c_beqz_s1;
reg c_instr_c_j_s1;
reg c_instr_c_and_s1;
reg c_instr_c_or_s1;
reg c_instr_c_xor_s1;
reg c_instr_c_sub_s1;
reg c_instr_c_andi_s1;
reg c_instr_c_srai_s1;
reg c_instr_c_srli_s1;
reg c_instr_c_addi16sp_s1;
reg c_instr_c_lui_s1;
reg c_instr_c_li_s1;
reg c_instr_c_jal_s1;
reg c_instr_c_addi_s1;
reg c_instr_c_nop_s1;
reg c_instr_c_sw_s1;
reg c_instr_c_lw_s1;
reg c_instr_c_addi4sp_s1;
reg c_cond_bnez_c;
reg c_cond_beqz_c;
reg c_instr_m_remu_s2;
reg c_instr_m_rem_s2;
reg c_instr_m_divu_s2;
reg c_instr_m_div_s2;
reg c_instr_m_mulhsu_s2;
reg c_instr_m_mulhu_s2;
reg c_instr_m_mulh_s2;
reg c_instr_m_mul_s2;
reg c_instr_m_remu_s1;
reg c_instr_m_rem_s1;
reg c_instr_m_divu_s1;
reg c_instr_m_div_s1;
reg c_instr_m_mulhsu_s1;
reg c_instr_m_mulhu_s1;
reg c_instr_m_mulh_s1;
reg c_instr_m_mul_s1;
reg c_div_rem_s2;
reg c_div_rem_s1;
reg c_div_result_neg;
reg c_div_result_pos;
reg c_divisor_neg;
reg c_divident_neg;
reg c_divident_lesser_divisor;
reg c_sign_differ;
reg c_mul_s2;
reg c_mul_s1;
reg c_instr_i_ebreak_s2;
reg c_instr_i_ecall_s2;
reg c_instr_i_fence_s2;
reg c_instr_i_and_s2;
reg c_instr_i_or_s2;
reg c_instr_i_sra_s2;
reg c_instr_i_srl_s2;
reg c_instr_i_xor_s2;
reg c_instr_i_sltu_s2;
reg c_instr_i_slt_s2;
reg c_instr_i_sll_s2;
reg c_instr_i_sub_s2;
reg c_instr_i_add_s2;
reg c_instr_i_srai_s2;
reg c_instr_i_srli_s2;
reg c_instr_i_slli_s2;
reg c_instr_i_andi_s2;
reg c_instr_i_ori_s2;
reg c_instr_i_xori_s2;
reg c_instr_i_sltiu_s2;
reg c_instr_i_slti_s2;
reg c_instr_i_addi_s2;
reg c_instr_i_sw_s2;
reg c_instr_i_sh_s2;
reg c_instr_i_sb_s2;
reg c_instr_i_lhu_s2;
reg c_instr_i_lbu_s2;
reg c_instr_i_lw_s2;
reg c_instr_i_lh_s2;
reg c_instr_i_lb_s2;
reg c_instr_i_bgeu_s2;
reg c_instr_i_bltu_s2;
reg c_instr_i_bge_s2;
reg c_instr_i_blt_s2;
reg c_instr_i_bne_s2;
reg c_instr_i_beq_s2;
reg c_instr_i_jalr_s2;
reg c_instr_i_jal_s2;
reg c_instr_i_auipc_s2;
reg c_instr_i_lui_s2;
reg c_instr_i_ebreak_s1;
reg c_instr_i_ecall_s1;
reg c_instr_i_fence_s1;
reg c_instr_i_and_s1;
reg c_instr_i_or_s1;
reg c_instr_i_sra_s1;
reg c_instr_i_srl_s1;
reg c_instr_i_xor_s1;
reg c_instr_i_sltu_s1;
reg c_instr_i_slt_s1;
reg c_instr_i_sll_s1;
reg c_instr_i_sub_s1;
reg c_instr_i_add_s1;
reg c_instr_i_srai_s1;
reg c_instr_i_srli_s1;
reg c_instr_i_slli_s1;
reg c_instr_i_andi_s1;
reg c_instr_i_ori_s1;
reg c_instr_i_xori_s1;
reg c_instr_i_sltiu_s1;
reg c_instr_i_slti_s1;
reg c_instr_i_addi_s1;
reg c_instr_i_sw_s1;
reg c_instr_i_sh_s1;
reg c_instr_i_sb_s1;
reg c_instr_i_lhu_s1;
reg c_instr_i_lbu_s1;
reg c_instr_i_lw_s1;
reg c_instr_i_lh_s1;
reg c_instr_i_lb_s1;
reg c_instr_i_bgeu_s1;
reg c_instr_i_bltu_s1;
reg c_instr_i_bge_s1;
reg c_instr_i_blt_s1;
reg c_instr_i_bne_s1;
reg c_instr_i_beq_s1;
reg c_instr_i_jalr_s1;
reg c_instr_i_jal_s1;
reg c_instr_i_auipc_s1;
reg c_instr_i_lui_s1;
reg c_dmem_store;
reg c_dmem_load;
reg c_rf_write;
reg c_less;
reg c_cond_beq;
reg c_pipe_invalid;
reg c_div_rem_non_trivial;
reg c_mc_3;
reg c_mc_2;
reg c_mc_1;
reg c_mc_0;
reg c_wrth_rs2;
reg c_wrth_rs1;
reg c_pv_2;
reg c_pv_1;
reg c_pv_0;
reg c_instr_i;

//------------------- Wire declaration(s):
wire [31 : 0] rs2_dato_async;
wire [31 : 0] rs1_dato_async;

//------------------- Register assignment(s):
always_ff @ (posedge clk) begin
   if (c_div_rem_s2) begin
      if (c_mc_0) begin
         if (!(c_cond_beq)) begin
            if (!(c_divident_lesser_divisor)) begin
               math_reg2 <= 32'h00000000;
            end
         end
      end
      else begin
         if (!(c_mc_1)) begin
            if (c_instr_m_divu_s2) begin
               if (c_div_result_neg) begin
                  math_reg2 <= {math_reg2 [30 : 0], 1'b0};
               end
               else begin
                  math_reg2 <= {math_reg2 [30 : 0], 1'b1};
               end
            end
            else begin
               if (c_divisor_neg) begin
                  if (c_div_result_pos) begin
                     math_reg2 <= {math_reg2 [30 : 0], 1'b0};
                  end
                  else begin
                     math_reg2 <= {math_reg2 [30 : 0], 1'b1};
                  end
               end
               else begin
                  if (c_div_result_neg) begin
                     math_reg2 <= {math_reg2 [30 : 0], 1'b0};
                  end
                  else begin
                     math_reg2 <= {math_reg2 [30 : 0], 1'b1};
                  end
               end
            end
         end
      end
   end
end
always_ff @ (posedge clk) begin
   if (c_mul_s2) begin
      if (c_mc_0) begin
         math_reg1 [15 : 0] <= 16'h000;
      end
      if (c_mc_3) begin
         if (c_instr_m_mulh_s2) begin
            math_reg1 [15 : 0] <= dp_add [31 : 16];
         end
         if (c_instr_m_mulhu_s2) begin
            math_reg1 [15 : 0] <= dp_add [31 : 16];
         end
         if (c_instr_m_mulhsu_s2) begin
            math_reg1 [15 : 0] <= dp_add [31 : 16];
         end
      end
      if (c_mc_2) begin
         if (c_instr_m_mul_s2) begin
            math_reg1 [15 : 0] <= dp_add [31 : 16];
         end
         if (c_instr_m_mulh_s2) begin
            math_reg1 [15 : 0] <= dp_add [31 : 16];
         end
         if (c_instr_m_mulhu_s2) begin
            math_reg1 [15 : 0] <= dp_add [31 : 16];
         end
         if (c_instr_m_mulhsu_s2) begin
            math_reg1 [15 : 0] <= dp_add [31 : 16];
         end
      end
   end
   if (c_div_rem_s2) begin
      if (c_mc_0) begin
         math_reg1 <= divisor_shifted;
      end
      else begin
         if (!(c_mc_1)) begin
            if (c_instr_m_div_s2) begin
               math_reg1 <= {math_reg1 [31], math_reg1 [31 : 1]};
            end
            if (c_instr_m_divu_s2) begin
               math_reg1 <= {1'b0, math_reg1 [31 : 1]};
            end
            if (c_instr_m_rem_s2) begin
               math_reg1 <= {math_reg1 [31], math_reg1 [31 : 1]};
            end
            if (c_instr_m_remu_s2) begin
               math_reg1 <= {1'b0, math_reg1 [31 : 1]};
            end
         end
      end
   end
end
always_ff @ (posedge clk) begin
   if (c_mul_s2) begin
      if (c_mc_0) begin
         math_reg0 <= dp_add;
      end
      if (c_mc_3) begin
         if (c_instr_m_mulh_s2) begin
            math_reg0 [31 : 16] <= dp_add [15 : 0];
         end
         if (c_instr_m_mulhu_s2) begin
            math_reg0 [31 : 16] <= dp_add [15 : 0];
         end
         if (c_instr_m_mulhsu_s2) begin
            math_reg0 [31 : 16] <= dp_add [15 : 0];
         end
      end
      if (c_mc_2) begin
         if (c_instr_m_mul_s2) begin
            math_reg0 [31 : 16] <= dp_add [15 : 0];
         end
         if (c_instr_m_mulh_s2) begin
            math_reg0 [31 : 16] <= dp_add [15 : 0];
         end
         if (c_instr_m_mulhu_s2) begin
            math_reg0 [31 : 16] <= dp_add [15 : 0];
         end
         if (c_instr_m_mulhsu_s2) begin
            math_reg0 [31 : 16] <= dp_add [15 : 0];
         end
      end
   end
   if (c_div_rem_s2) begin
      if (c_mc_0) begin
         if (!(c_cond_beq)) begin
            if (!(c_divident_lesser_divisor)) begin
               if (c_instr_m_div_s2) begin
                  if (c_sign_differ) begin
                     math_reg0 <= 0 - rs1_dato;
                  end
                  else begin
                     math_reg0 <= rs1_dato;
                  end
               end
               if (c_instr_m_divu_s2) begin
                  math_reg0 <= rs1_dato;
               end
               if (c_instr_m_rem_s2) begin
                  if (c_sign_differ) begin
                     math_reg0 <= 0 - rs1_dato;
                  end
                  else begin
                     math_reg0 <= rs1_dato;
                  end
               end
               if (c_instr_m_remu_s2) begin
                  math_reg0 <= rs1_dato;
               end
            end
         end
      end
      else begin
         if (!(c_mc_1)) begin
            if (c_instr_m_divu_s2) begin
               if (!(c_div_result_neg)) begin
                  math_reg0 <= dp_add;
               end
            end
            else begin
               if (c_divisor_neg) begin
                  if (!(c_div_result_pos)) begin
                     math_reg0 <= dp_add;
                  end
               end
               else begin
                  if (!(c_div_result_neg)) begin
                     math_reg0 <= dp_add;
                  end
               end
            end
         end
      end
   end
end
always_ff @ (posedge clk) begin
   if (!(c_arst)) begin
      if (c_pv_0) begin
         if (!(c_pipe_invalid)) begin
            if (c_rf_write) begin
               if (c_wrth_rs2) begin
                  rs2_dato <= rd_dati;
               end
               else begin
                  rs2_dato <= rs2_dato_async;
               end
            end
            else begin
               if (c_mul_s2) begin
                  if (c_mc_1) begin
                     rs2_dato <= rs2_dato_async;
                  end
               end
               else begin
                  if (c_div_rem_s2) begin
                     if (c_mc_1) begin
                        rs2_dato <= rs2_dato_async;
                     end
                  end
                  else begin
                     rs2_dato <= rs2_dato_async;
                  end
               end
            end
         end
      end
   end
end
always_ff @ (posedge clk) begin
   if (!(c_arst)) begin
      if (c_pv_0) begin
         if (!(c_pipe_invalid)) begin
            if (c_rf_write) begin
               if (c_wrth_rs1) begin
                  rs1_dato <= rd_dati;
               end
               else begin
                  rs1_dato <= rs1_dato_async;
               end
            end
            else begin
               if (c_mul_s2) begin
                  if (c_mc_1) begin
                     rs1_dato <= rs1_dato_async;
                  end
               end
               else begin
                  if (c_div_rem_s2) begin
                     if (c_mc_1) begin
                        rs1_dato <= rs1_dato_async;
                     end
                  end
                  else begin
                     rs1_dato <= rs1_dato_async;
                  end
               end
            end
         end
      end
   end
end
always_ff @ (posedge clk or posedge c_arst) begin
   if (c_arst) begin
      instr_s2 <= 32'h00000013;
   end
   else begin
      if (c_pv_0) begin
         if (c_pipe_invalid) begin
            instr_s2 <= 32'h00000013;
         end
         else begin
            if (c_mc_0) begin
               if (!(c_mul_s2)) begin
                  if (!(c_div_rem_non_trivial)) begin
                     instr_s2 <= instr_s1;
                  end
               end
            end
            else begin
               if (c_mc_1) begin
                  instr_s2 <= instr_s1;
               end
            end
         end
      end
      else begin
         if (c_pv_1) begin
            instr_s2 <= instr_s1;
         end
         else begin
            instr_s2 <= 32'h00000013;
         end
      end
   end
end
always_ff @ (posedge clk or posedge c_arst) begin
   if (c_arst) begin
      instr_s1 <= 32'h00000013;
   end
   else begin
      if (c_pv_0) begin
         if (c_pipe_invalid) begin
            instr_s1 <= 32'h00000013;
         end
         else begin
            if (c_mc_0) begin
               if (!(c_mul_s2)) begin
                  if (!(c_div_rem_non_trivial)) begin
                     instr_s1 <= instr;
                  end
               end
            end
            else begin
               if (c_mc_1) begin
                  instr_s1 <= instr;
               end
            end
         end
      end
      else begin
         if (c_pv_1) begin
            instr_s1 <= instr;
         end
         else begin
            instr_s1 <= instr;
         end
      end
   end
end
always_ff @ (posedge clk or posedge c_arst) begin
   if (c_arst) begin
      pc <= 0;
   end
   else begin
      if (c_pv_0) begin
         if (c_pipe_invalid) begin
            pc <= pc_next;
         end
         else begin
            if (c_mc_0) begin
               if (!(c_mul_s2)) begin
                  if (!(c_div_rem_non_trivial)) begin
                     if (c_instr_i) begin
                        pc <= pc + 4;
                     end
                     else begin
                        pc <= pc + 2;
                     end
                  end
               end
            end
            else begin
               if (c_mc_1) begin
                  if (c_instr_i) begin
                     pc <= pc + 4;
                  end
                  else begin
                     pc <= pc + 2;
                  end
               end
            end
         end
      end
   end
end
always_ff @ (posedge clk or posedge c_arst) begin
   if (c_arst) begin
      pc4_s2 <= 1'b1;
   end
   else begin
      if (c_pv_0) begin
         if (!(c_pipe_invalid)) begin
            if (c_mc_0) begin
               if (!(c_mul_s2)) begin
                  if (!(c_div_rem_non_trivial)) begin
                     pc4_s2 <= pc4_s1;
                  end
               end
            end
            else begin
               if (c_mc_1) begin
                  pc4_s2 <= pc4_s1;
               end
            end
         end
      end
   end
end
always_ff @ (posedge clk or posedge c_arst) begin
   if (c_arst) begin
      pc4_s1 <= 1'b1;
   end
   else begin
      if (c_pv_0) begin
         if (!(c_pipe_invalid)) begin
            if (c_mc_0) begin
               if (!(c_mul_s2)) begin
                  if (!(c_div_rem_non_trivial)) begin
                     if (c_instr_i) begin
                        pc4_s1 <= 1'b1;
                     end
                     else begin
                        pc4_s1 <= 1'b0;
                     end
                  end
               end
            end
            else begin
               if (c_mc_1) begin
                  if (c_instr_i) begin
                     pc4_s1 <= 1'b1;
                  end
                  else begin
                     pc4_s1 <= 1'b0;
                  end
               end
            end
         end
      end
   end
end
always_ff @ (posedge clk or posedge c_arst) begin
   if (c_arst) begin
      pv <= 0;
   end
   else begin
      if (!(c_pv_0)) begin
         if (c_pv_1) begin
            pv <= pv - 1;
         end
         else begin
            pv <= pv - 1;
         end
      end
   end
end
always_ff @ (posedge clk or posedge c_arst) begin
   if (c_arst) begin
      mc <= 0;
   end
   else begin
      if (c_mc_0) begin
         if (c_instr_m_mul_s2) begin
            mc <= 2;
         end
         if (c_instr_m_mulh_s2) begin
            mc <= 3;
         end
         if (c_instr_m_mulhu_s2) begin
            mc <= 3;
         end
         if (c_instr_m_mulhsu_s2) begin
            mc <= 3;
         end
         if (c_instr_m_div_s2) begin
            if (!(c_cond_beq)) begin
               if (!(c_divident_lesser_divisor)) begin
                  mc <= div_init_shift + 1;
               end
            end
         end
         if (c_instr_m_divu_s2) begin
            if (!(c_cond_beq)) begin
               if (!(c_divident_lesser_divisor)) begin
                  mc <= div_init_shift + 1;
               end
            end
         end
         if (c_instr_m_rem_s2) begin
            if (!(c_cond_beq)) begin
               if (!(c_divident_lesser_divisor)) begin
                  mc <= div_init_shift + 1;
               end
            end
         end
         if (c_instr_m_remu_s2) begin
            if (!(c_cond_beq)) begin
               if (!(c_divident_lesser_divisor)) begin
                  mc <= div_init_shift + 1;
               end
            end
         end
      end
      else begin
         mc <= mc - 1;
      end
   end
end

//------------------- Item assignment(s):
assign i_shamt_c = {instr_s2 [12], instr_s2 [6 : 2]};
assign sign_ext_imm8 = {{22 {instr_s2 [10]}}, instr_s2 [10 : 7], instr_s2 [12 : 11], instr_s2 [5], instr_s2 [6], 2'b00};
assign sign_ext_imm6_sp = {{22 {instr_s2 [12]}}, instr_s2 [12], instr_s2 [4 : 3], instr_s2 [5], instr_s2 [2], instr_s2 [6], 4'h0};
assign sign_ext_imm6_s1 = {{26 {instr_s1 [12]}}, instr_s1 [12], instr_s1 [6 : 2]};
assign sign_ext_imm6 = {{26 {instr_s2 [12]}}, instr_s2 [12], instr_s2 [6 : 2]};
assign sign_ext_imm8_c = {{26 {instr_s2 [12]}}, instr_s2 [12], instr_s2 [6 : 5], instr_s2 [2], instr_s2 [11 : 10], instr_s2 [4 : 3], 1'b0};
assign imm_jal_c = {{26 {instr_s2 [12]}}, instr_s2 [12], instr_s2 [8], instr_s2 [10 : 9], instr_s2 [6], instr_s2 [7], instr_s2 [2], instr_s2 [11], instr_s2 [5 : 3], 1'b0};
assign imm_j_c = {{26 {instr_s2 [12]}}, instr_s2 [12], instr_s2 [8], instr_s2 [10 : 9], instr_s2 [6], instr_s2 [7], instr_s2 [2], instr_s2 [11], instr_s2 [5 : 3], 1'b0};
assign offset_swsp_c = {{25 {1'b0}}, instr_s2 [8 : 7], instr_s2 [12 : 9], 2'b00};
assign offset_lwsp_c = {{26 {1'b0}}, instr_s2 [3 : 2], instr_s2 [12], instr_s2 [6 : 4], 2'b00};
assign offset_c = {{26 {1'b0}}, instr_s2 [5], instr_s2 [12 : 10], instr_s2 [6], 2'b00};
assign funct2_c = instr_s2 [6 : 5];
assign funct3_c = instr_s2 [15 : 13];
assign opcode_c = instr_s2 [1 : 0];
assign funct2_c_s1 = instr_s1 [6 : 5];
assign funct3_c_s1 = instr_s1 [15 : 13];
assign opcode_c_s1 = instr_s1 [1 : 0];
assign divisor_shifted = shl_result;
assign div_init_shift = leading_bit_divident_loc - leading_bit_divisor_loc;
always_comb begin
   leading_bit_divisor_loc = 5'hxx;
   leading_bit_divisor_loc = 0;
   for (int i = 31; i >= 0; i = i - 1) if (divisor [i] == leading_bit_divisor_val) if (leading_bit_divisor_loc == 0) leading_bit_divisor_loc = i;
end
always_comb begin
   leading_bit_divident_loc = 5'hxx;
   leading_bit_divident_loc = 0;
   for (int i = 31; i >= 0; i = i - 1) if (divident [i] == leading_bit_divident_val) if (leading_bit_divident_loc == 0) leading_bit_divident_loc = i;
end
always_comb begin
   leading_bit_divisor_val = 1'bx;
   if (c_instr_m_divu_s2) begin
      leading_bit_divisor_val = 1'b1;
   end
   else begin
      if (c_instr_m_remu_s2) begin
         leading_bit_divisor_val = 1'b1;
      end
      else begin
         if (c_divisor_neg) begin
            leading_bit_divisor_val = 1'b0;
         end
         else begin
            leading_bit_divisor_val = 1'b1;
         end
      end
   end
end
always_comb begin
   leading_bit_divident_val = 1'bx;
   if (c_instr_m_divu_s2) begin
      leading_bit_divident_val = 1'b1;
   end
   else begin
      if (c_instr_m_remu_s2) begin
         leading_bit_divident_val = 1'b1;
      end
      else begin
         if (c_divident_neg) begin
            leading_bit_divident_val = 1'b0;
         end
         else begin
            leading_bit_divident_val = 1'b1;
         end
      end
   end
end
assign divisor = rs2_dato;
assign divident = rs1_dato;
assign i_mul_out = $signed (i_mul_a) * $signed (i_mul_b);
always_comb begin
   i_mul_b = 17'hxxxxx;
   if (c_mul_s2) begin
      if (c_mc_0) begin
         i_mul_b = {1'b0, rs2_dato [15 : 0]};
      end
      if (c_mc_3) begin
         if (c_instr_m_mulh_s2) begin
            i_mul_b = {rs2_dato [31], rs2_dato [31 : 16]};
         end
         if (c_instr_m_mulhu_s2) begin
            i_mul_b = {1'b0, rs2_dato [31 : 16]};
         end
         if (c_instr_m_mulhsu_s2) begin
            i_mul_b = {1'b0, rs2_dato [31 : 16]};
         end
      end
      if (c_mc_2) begin
         if (c_instr_m_mul_s2) begin
            i_mul_b = {1'b0, rs2_dato [31 : 16]};
         end
         if (c_instr_m_mulh_s2) begin
            i_mul_b = {1'b0, rs2_dato [15 : 0]};
         end
         if (c_instr_m_mulhu_s2) begin
            i_mul_b = {1'b0, rs2_dato [15 : 0]};
         end
         if (c_instr_m_mulhsu_s2) begin
            i_mul_b = {1'b0, rs2_dato [15 : 0]};
         end
      end
      if (c_mc_1) begin
         if (c_instr_m_mul_s2) begin
            i_mul_b = {1'b0, rs2_dato [15 : 0]};
         end
         if (c_instr_m_mulh_s2) begin
            i_mul_b = {rs2_dato [31], rs2_dato [31 : 16]};
         end
         if (c_instr_m_mulhu_s2) begin
            i_mul_b = {1'b0, rs2_dato [31 : 16]};
         end
         if (c_instr_m_mulhsu_s2) begin
            i_mul_b = {1'b0, rs2_dato [31 : 16]};
         end
      end
   end
end
always_comb begin
   i_mul_a = 17'hxxxxx;
   if (c_mul_s2) begin
      if (c_mc_0) begin
         i_mul_a = {1'b0, rs1_dato [15 : 0]};
      end
      if (c_mc_3) begin
         if (c_instr_m_mulh_s2) begin
            i_mul_a = {1'b0, rs1_dato [15 : 0]};
         end
         if (c_instr_m_mulhu_s2) begin
            i_mul_a = {1'b0, rs1_dato [15 : 0]};
         end
         if (c_instr_m_mulhsu_s2) begin
            i_mul_a = {1'b0, rs1_dato [15 : 0]};
         end
      end
      if (c_mc_2) begin
         if (c_instr_m_mul_s2) begin
            i_mul_a = {1'b0, rs1_dato [15 : 0]};
         end
         if (c_instr_m_mulh_s2) begin
            i_mul_a = {rs1_dato [31], rs1_dato [31 : 16]};
         end
         if (c_instr_m_mulhu_s2) begin
            i_mul_a = {1'b0, rs1_dato [31 : 16]};
         end
         if (c_instr_m_mulhsu_s2) begin
            i_mul_a = {rs1_dato [31], rs1_dato [31 : 16]};
         end
      end
      if (c_mc_1) begin
         if (c_instr_m_mul_s2) begin
            i_mul_a = {1'b0, rs1_dato [31 : 16]};
         end
         if (c_instr_m_mulh_s2) begin
            i_mul_a = {rs1_dato [31], rs1_dato [31 : 16]};
         end
         if (c_instr_m_mulhu_s2) begin
            i_mul_a = {1'b0, rs1_dato [31 : 16]};
         end
         if (c_instr_m_mulhsu_s2) begin
            i_mul_a = {rs1_dato [31], rs1_dato [31 : 16]};
         end
      end
   end
end
always_comb begin
   dmem_store_data = 32'hxxxxxxxx;
   if (c_instr_i_sb_s2) begin
      dmem_store_data = rs2_dato;
   end
   if (c_instr_i_sh_s2) begin
      dmem_store_data = rs2_dato;
   end
   if (c_instr_i_sw_s2) begin
      dmem_store_data = rs2_dato;
   end
   if (c_instr_c_sw_s2) begin
      dmem_store_data = rs2_dato;
   end
   if (c_instr_c_swsp_s2) begin
      dmem_store_data = rs2_dato;
   end
end
always_comb begin
   dmem_store_width = 3'hx;
   if (c_instr_i_sb_s2) begin
      dmem_store_width = funct3_i [2 : 0];
   end
   if (c_instr_i_sh_s2) begin
      dmem_store_width = funct3_i [2 : 0];
   end
   if (c_instr_i_sw_s2) begin
      dmem_store_width = funct3_i [2 : 0];
   end
   if (c_instr_c_sw_s2) begin
      dmem_store_width = 2;
   end
   if (c_instr_c_swsp_s2) begin
      dmem_store_width = 2;
   end
end
always_comb begin
   dmem_store_addr = 33'hxxxxxxxxx;
   if (c_instr_i_sb_s2) begin
      dmem_store_addr = dp_add;
   end
   if (c_instr_i_sh_s2) begin
      dmem_store_addr = dp_add;
   end
   if (c_instr_i_sw_s2) begin
      dmem_store_addr = dp_add;
   end
   if (c_instr_c_sw_s2) begin
      dmem_store_addr = dp_add;
   end
   if (c_instr_c_swsp_s2) begin
      dmem_store_addr = dp_add;
   end
end
always_comb begin
   dmem_load_width = 3'hx;
   if (c_instr_i_lb_s2) begin
      dmem_load_width = funct3_i [2 : 0];
   end
   if (c_instr_i_lh_s2) begin
      dmem_load_width = funct3_i [2 : 0];
   end
   if (c_instr_i_lw_s2) begin
      dmem_load_width = funct3_i [2 : 0];
   end
   if (c_instr_i_lbu_s2) begin
      dmem_load_width = funct3_i [2 : 0];
   end
   if (c_instr_i_lhu_s2) begin
      dmem_load_width = funct3_i [2 : 0];
   end
   if (c_instr_c_lw_s2) begin
      dmem_load_width = 2;
   end
   if (c_instr_c_lwsp_s2) begin
      dmem_load_width = 2;
   end
end
always_comb begin
   dmem_load_addr = 33'hxxxxxxxxx;
   if (c_instr_i_lb_s2) begin
      dmem_load_addr = dp_add;
   end
   if (c_instr_i_lh_s2) begin
      dmem_load_addr = dp_add;
   end
   if (c_instr_i_lw_s2) begin
      dmem_load_addr = dp_add;
   end
   if (c_instr_i_lbu_s2) begin
      dmem_load_addr = dp_add;
   end
   if (c_instr_i_lhu_s2) begin
      dmem_load_addr = dp_add;
   end
   if (c_instr_c_lw_s2) begin
      dmem_load_addr = dp_add;
   end
   if (c_instr_c_lwsp_s2) begin
      dmem_load_addr = dp_add;
   end
end
always_comb begin
   dp_out = 32'hxxxxxxxx;
   if (c_instr_i_lui_s2) begin
      dp_out = u_immediate;
   end
   if (c_instr_i_auipc_s2) begin
      dp_out = dp_add;
   end
   if (c_instr_i_jal_s2) begin
      dp_out = pc - pc_clear + 4;
   end
   if (c_instr_i_jalr_s2) begin
      dp_out = pc - pc_clear + 4;
   end
   if (c_instr_i_blt_s2) begin
      dp_out = less_result;
   end
   if (c_instr_i_bge_s2) begin
      dp_out = less_result;
   end
   if (c_instr_i_bltu_s2) begin
      dp_out = less_result;
   end
   if (c_instr_i_bgeu_s2) begin
      dp_out = less_result;
   end
   if (c_instr_i_lb_s2) begin
      dp_out = {{24 {dmem_load_data [7]}}, dmem_load_data [7 : 0]};
   end
   if (c_instr_i_lh_s2) begin
      dp_out = {{16 {dmem_load_data [15]}}, dmem_load_data [15 : 0]};
   end
   if (c_instr_i_lw_s2) begin
      dp_out = dmem_load_data;
   end
   if (c_instr_i_lbu_s2) begin
      dp_out = {{24 {1'b0}}, dmem_load_data [7 : 0]};
   end
   if (c_instr_i_lhu_s2) begin
      dp_out = {{16 {1'b0}}, dmem_load_data [15 : 0]};
   end
   if (c_instr_i_addi_s2) begin
      dp_out = dp_add;
   end
   if (c_instr_i_slti_s2) begin
      dp_out = less_result;
   end
   if (c_instr_i_sltiu_s2) begin
      dp_out = less_result;
   end
   if (c_instr_i_xori_s2) begin
      dp_out = rs1_dato ^ i_immediate;
   end
   if (c_instr_i_ori_s2) begin
      dp_out = rs1_dato | i_immediate;
   end
   if (c_instr_i_andi_s2) begin
      dp_out = rs1_dato & i_immediate;
   end
   if (c_instr_i_slli_s2) begin
      dp_out = shl_result;
   end
   if (c_instr_i_srli_s2) begin
      dp_out = sra_result [31 : 0];
   end
   if (c_instr_i_srai_s2) begin
      dp_out = sra_result [31 : 0];
   end
   if (c_instr_i_add_s2) begin
      dp_out = dp_add;
   end
   if (c_instr_i_sub_s2) begin
      dp_out = dp_add;
   end
   if (c_instr_i_sll_s2) begin
      dp_out = shl_result;
   end
   if (c_instr_i_slt_s2) begin
      dp_out = less_result;
   end
   if (c_instr_i_sltu_s2) begin
      dp_out = less_result;
   end
   if (c_instr_i_xor_s2) begin
      dp_out = rs1_dato ^ rs2_dato;
   end
   if (c_instr_i_srl_s2) begin
      dp_out = sra_result [31 : 0];
   end
   if (c_instr_i_sra_s2) begin
      dp_out = sra_result [31 : 0];
   end
   if (c_instr_i_or_s2) begin
      dp_out = rs1_dato | rs2_dato;
   end
   if (c_instr_i_and_s2) begin
      dp_out = rs1_dato & rs2_dato;
   end
   if (c_mul_s2) begin
      if (c_instr_m_mul_s2) begin
         dp_out = {dp_add [15 : 0], math_reg0 [15 : 0]};
      end
      if (c_instr_m_mulh_s2) begin
         dp_out = dp_add;
      end
      if (c_instr_m_mulhu_s2) begin
         dp_out = dp_add;
      end
      if (c_instr_m_mulhsu_s2) begin
         dp_out = dp_add;
      end
   end
   if (c_div_rem_s2) begin
      if (c_instr_m_div_s2) begin
         dp_out = less_result;
      end
      if (c_instr_m_divu_s2) begin
         dp_out = less_result;
      end
      if (c_instr_m_rem_s2) begin
         dp_out = less_result;
      end
      if (c_instr_m_remu_s2) begin
         dp_out = less_result;
      end
      if (c_mc_0) begin
         if (c_cond_beq) begin
            if (c_instr_m_div_s2) begin
               dp_out = 32'h00000001;
            end
            if (c_instr_m_divu_s2) begin
               dp_out = 32'h00000001;
            end
            if (c_instr_m_rem_s2) begin
               dp_out = 32'h00000000;
            end
            if (c_instr_m_remu_s2) begin
               dp_out = 32'h00000000;
            end
         end
         else begin
            if (c_divident_lesser_divisor) begin
               if (c_instr_m_div_s2) begin
                  dp_out = 32'h00000000;
               end
               if (c_instr_m_divu_s2) begin
                  dp_out = 32'h00000000;
               end
               if (c_instr_m_rem_s2) begin
                  dp_out = divident;
               end
               if (c_instr_m_remu_s2) begin
                  dp_out = divident;
               end
            end
         end
      end
      else begin
         if (c_mc_1) begin
            if (c_instr_m_div_s2) begin
               if (c_sign_differ) begin
                  dp_out = 0 - {math_reg2 [30 : 0], 1'b1};
               end
               else begin
                  if (c_divisor_neg) begin
                     if (c_div_result_neg) begin
                        dp_out = {math_reg2 [30 : 0], 1'b1};
                     end
                     else begin
                        dp_out = {math_reg2 [30 : 0], 1'b0};
                     end
                  end
                  else begin
                     if (c_div_result_neg) begin
                        dp_out = {math_reg2 [30 : 0], 1'b0};
                     end
                     else begin
                        dp_out = {math_reg2 [30 : 0], 1'b1};
                     end
                  end
               end
            end
            if (c_instr_m_divu_s2) begin
               if (c_div_result_neg) begin
                  dp_out = {math_reg2 [30 : 0], 1'b0};
               end
               else begin
                  dp_out = {math_reg2 [30 : 0], 1'b1};
               end
            end
            if (c_instr_m_rem_s2) begin
               if (c_sign_differ) begin
                  if (c_divisor_neg) begin
                     dp_out = math_reg0 [31 : 0];
                  end
                  else begin
                     dp_out = 0 - math_reg0 [31 : 0];
                  end
               end
               else begin
                  if (c_divisor_neg) begin
                     dp_out = 0 - math_reg0 [31 : 0];
                  end
                  else begin
                     if (c_div_result_neg) begin
                        dp_out = math_reg0 [31 : 0];
                     end
                     else begin
                        dp_out = dp_add [31 : 0];
                     end
                  end
               end
            end
            if (c_instr_m_remu_s2) begin
               if (c_div_result_neg) begin
                  dp_out = math_reg0 [31 : 0];
               end
               else begin
                  dp_out = dp_add [31 : 0];
               end
            end
         end
      end
   end
   if (c_instr_c_addi4sp_s2) begin
      dp_out = dp_add;
   end
   if (c_instr_c_lw_s2) begin
      dp_out = dmem_load_data;
   end
   if (c_instr_c_addi_s2) begin
      dp_out = dp_add;
   end
   if (c_instr_c_jal_s2) begin
      dp_out = pc - pc_clear + 2;
   end
   if (c_instr_c_li_s2) begin
      dp_out = {{26 {instr_s2 [12]}}, instr_s2 [12], instr_s2 [6 : 2]};
   end
   if (c_instr_c_lui_s2) begin
      dp_out = {{14 {instr_s2 [12]}}, instr_s2 [12], instr_s2 [6 : 2], 12'h000};
   end
   if (c_instr_c_addi16sp_s2) begin
      dp_out = dp_add;
   end
   if (c_instr_c_srli_s2) begin
      dp_out = sra_result [31 : 0];
   end
   if (c_instr_c_srai_s2) begin
      dp_out = sra_result [31 : 0];
   end
   if (c_instr_c_andi_s2) begin
      dp_out = rs1_dato & sign_ext_imm6;
   end
   if (c_instr_c_sub_s2) begin
      dp_out = dp_add;
   end
   if (c_instr_c_xor_s2) begin
      dp_out = rs1_dato ^ rs2_dato;
   end
   if (c_instr_c_or_s2) begin
      dp_out = rs1_dato | rs2_dato;
   end
   if (c_instr_c_and_s2) begin
      dp_out = rs1_dato & rs2_dato;
   end
   if (c_instr_c_slli_s2) begin
      dp_out = shl_result;
   end
   if (c_instr_c_lwsp_s2) begin
      dp_out = dmem_load_data;
   end
   if (c_instr_c_mv_s2) begin
      dp_out = rs2_dato;
   end
   if (c_instr_c_jalr_s2) begin
      dp_out = dp_add;
   end
   if (c_instr_c_add_s2) begin
      dp_out = dp_add;
   end
end
always_comb begin
   rd_dati = 32'hxxxxxxxx;
   if (c_instr_i_lui_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_auipc_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_jal_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_jalr_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_lb_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_lh_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_lw_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_lbu_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_lhu_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_addi_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_slti_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_sltiu_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_xori_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_ori_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_andi_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_slli_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_srli_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_srai_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_add_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_sub_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_sll_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_slt_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_sltu_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_xor_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_srl_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_sra_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_or_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_and_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_i_fence_s2) begin
      rd_dati = dp_out;
   end
   if (c_mul_s2) begin
      rd_dati = dp_out;
   end
   if (c_div_rem_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_c_addi4sp_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_c_lw_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_c_addi_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_c_jal_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_c_li_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_c_lui_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_c_addi16sp_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_c_srli_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_c_srai_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_c_andi_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_c_sub_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_c_xor_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_c_or_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_c_and_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_c_slli_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_c_lwsp_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_c_mv_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_c_jalr_s2) begin
      rd_dati = dp_out;
   end
   if (c_instr_c_add_s2) begin
      rd_dati = dp_out;
   end
end
always_comb begin
   rd_addr = 5'hxx;
   if (c_instr_i_lui_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_auipc_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_jal_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_jalr_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_lb_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_lh_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_lw_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_lbu_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_lhu_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_addi_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_slti_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_sltiu_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_xori_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_ori_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_andi_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_slli_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_srli_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_srai_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_add_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_sub_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_sll_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_slt_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_sltu_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_xor_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_srl_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_sra_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_or_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_and_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_i_fence_s2) begin
      rd_addr = rdi;
   end
   if (c_mul_s2) begin
      rd_addr = rdi;
   end
   if (c_div_rem_s2) begin
      rd_addr = rdi;
   end
   if (c_instr_c_addi4sp_s2) begin
      rd_addr = {2'b01, instr_s2 [4 : 2]};
   end
   if (c_instr_c_lw_s2) begin
      rd_addr = {2'b01, instr_s2 [4 : 2]};
   end
   if (c_instr_c_addi_s2) begin
      rd_addr = instr_s2 [11 : 7];
   end
   if (c_instr_c_jal_s2) begin
      rd_addr = 1;
   end
   if (c_instr_c_li_s2) begin
      rd_addr = instr_s2 [11 : 7];
   end
   if (c_instr_c_lui_s2) begin
      rd_addr = instr_s2 [11 : 7];
   end
   if (c_instr_c_addi16sp_s2) begin
      rd_addr = instr_s2 [11 : 7];
   end
   if (c_instr_c_srli_s2) begin
      rd_addr = {2'b01, instr_s2 [9 : 7]};
   end
   if (c_instr_c_srai_s2) begin
      rd_addr = {2'b01, instr_s2 [9 : 7]};
   end
   if (c_instr_c_andi_s2) begin
      rd_addr = {2'b01, instr_s2 [9 : 7]};
   end
   if (c_instr_c_sub_s2) begin
      rd_addr = {2'b01, instr_s2 [9 : 7]};
   end
   if (c_instr_c_xor_s2) begin
      rd_addr = {2'b01, instr_s2 [9 : 7]};
   end
   if (c_instr_c_or_s2) begin
      rd_addr = {2'b01, instr_s2 [9 : 7]};
   end
   if (c_instr_c_and_s2) begin
      rd_addr = {2'b01, instr_s2 [9 : 7]};
   end
   if (c_instr_c_slli_s2) begin
      rd_addr = instr_s2 [11 : 7];
   end
   if (c_instr_c_lwsp_s2) begin
      rd_addr = instr_s2 [11 : 7];
   end
   if (c_instr_c_mv_s2) begin
      rd_addr = instr_s2 [11 : 7];
   end
   if (c_instr_c_jalr_s2) begin
      rd_addr = 1;
   end
   if (c_instr_c_add_s2) begin
      rd_addr = instr_s2 [11 : 7];
   end
end
always_comb begin
   rs2_addr = 5'hxx;
   if (c_instr_i_beq_s1) begin
      rs2_addr = rs2i;
   end
   if (c_instr_i_bne_s1) begin
      rs2_addr = rs2i;
   end
   if (c_instr_i_blt_s1) begin
      rs2_addr = rs2i;
   end
   if (c_instr_i_bge_s1) begin
      rs2_addr = rs2i;
   end
   if (c_instr_i_bltu_s1) begin
      rs2_addr = rs2i;
   end
   if (c_instr_i_bgeu_s1) begin
      rs2_addr = rs2i;
   end
   if (c_instr_i_sb_s1) begin
      rs2_addr = rs2i;
   end
   if (c_instr_i_sh_s1) begin
      rs2_addr = rs2i;
   end
   if (c_instr_i_sw_s1) begin
      rs2_addr = rs2i;
   end
   if (c_instr_i_add_s1) begin
      rs2_addr = rs2i;
   end
   if (c_instr_i_sub_s1) begin
      rs2_addr = rs2i;
   end
   if (c_instr_i_sll_s1) begin
      rs2_addr = rs2i;
   end
   if (c_instr_i_slt_s1) begin
      rs2_addr = rs2i;
   end
   if (c_instr_i_sltu_s1) begin
      rs2_addr = rs2i;
   end
   if (c_instr_i_xor_s1) begin
      rs2_addr = rs2i;
   end
   if (c_instr_i_srl_s1) begin
      rs2_addr = rs2i;
   end
   if (c_instr_i_sra_s1) begin
      rs2_addr = rs2i;
   end
   if (c_instr_i_or_s1) begin
      rs2_addr = rs2i;
   end
   if (c_instr_i_and_s1) begin
      rs2_addr = rs2i;
   end
   if (c_mul_s1) begin
      rs2_addr = rs2i;
   end
   if (c_div_rem_s1) begin
      rs2_addr = rs2i;
   end
   if (c_instr_c_sw_s1) begin
      rs2_addr = {2'b01, instr_s1 [4 : 2]};
   end
   if (c_instr_c_sub_s1) begin
      rs2_addr = {2'b01, instr_s1 [4 : 2]};
   end
   if (c_instr_c_xor_s1) begin
      rs2_addr = {2'b01, instr_s1 [4 : 2]};
   end
   if (c_instr_c_or_s1) begin
      rs2_addr = {2'b01, instr_s1 [4 : 2]};
   end
   if (c_instr_c_and_s1) begin
      rs2_addr = {2'b01, instr_s1 [4 : 2]};
   end
   if (c_instr_c_mv_s1) begin
      rs2_addr = instr_s1 [6 : 2];
   end
   if (c_instr_c_add_s1) begin
      rs2_addr = instr_s1 [6 : 2];
   end
   if (c_instr_c_swsp_s1) begin
      rs2_addr = instr_s1 [6 : 2];
   end
end
always_comb begin
   rs1_addr = 5'hxx;
   if (c_instr_i_jalr_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_beq_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_bne_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_blt_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_bge_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_bltu_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_bgeu_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_lb_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_lh_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_lw_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_lbu_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_lhu_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_sb_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_sh_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_sw_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_addi_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_slti_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_sltiu_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_xori_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_ori_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_andi_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_slli_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_srli_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_srai_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_add_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_sub_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_sll_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_slt_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_sltu_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_xor_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_srl_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_sra_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_or_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_and_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_i_fence_s1) begin
      rs1_addr = rs1i;
   end
   if (c_mul_s1) begin
      rs1_addr = rs1i;
   end
   if (c_div_rem_s1) begin
      rs1_addr = rs1i;
   end
   if (c_instr_c_addi4sp_s1) begin
      rs1_addr = 2;
   end
   if (c_instr_c_lw_s1) begin
      rs1_addr = {2'b01, instr_s1 [9 : 7]};
   end
   if (c_instr_c_sw_s1) begin
      rs1_addr = {2'b01, instr_s1 [9 : 7]};
   end
   if (c_instr_c_addi_s1) begin
      rs1_addr = instr_s1 [11 : 7];
   end
   if (c_instr_c_addi16sp_s1) begin
      rs1_addr = instr_s1 [11 : 7];
   end
   if (c_instr_c_srli_s1) begin
      rs1_addr = {2'b01, instr_s1 [9 : 7]};
   end
   if (c_instr_c_srai_s1) begin
      rs1_addr = {2'b01, instr_s1 [9 : 7]};
   end
   if (c_instr_c_andi_s1) begin
      rs1_addr = {2'b01, instr_s1 [9 : 7]};
   end
   if (c_instr_c_sub_s1) begin
      rs1_addr = {2'b01, instr_s1 [9 : 7]};
   end
   if (c_instr_c_xor_s1) begin
      rs1_addr = {2'b01, instr_s1 [9 : 7]};
   end
   if (c_instr_c_or_s1) begin
      rs1_addr = {2'b01, instr_s1 [9 : 7]};
   end
   if (c_instr_c_and_s1) begin
      rs1_addr = {2'b01, instr_s1 [9 : 7]};
   end
   if (c_instr_c_beqz_s1) begin
      rs1_addr = {2'b01, instr_s1 [9 : 7]};
   end
   if (c_instr_c_bnez_s1) begin
      rs1_addr = {2'b01, instr_s1 [9 : 7]};
   end
   if (c_instr_c_slli_s1) begin
      rs1_addr = instr_s1 [11 : 7];
   end
   if (c_instr_c_lwsp_s1) begin
      rs1_addr = 2;
   end
   if (c_instr_c_jr_s1) begin
      rs1_addr = instr_s1 [11 : 7];
   end
   if (c_instr_c_jalr_s1) begin
      rs1_addr = instr_s1 [11 : 7];
   end
   if (c_instr_c_add_s1) begin
      rs1_addr = instr_s1 [11 : 7];
   end
   if (c_instr_c_swsp_s1) begin
      rs1_addr = 2;
   end
end
always_comb begin
   succ = 4'hx;
   if (c_instr_i_fence_s2) begin
      succ = instr_s2 [23 : 20];
   end
end
always_comb begin
   pred = 4'hx;
   if (c_instr_i_fence_s2) begin
      pred = instr_s2 [27 : 24];
   end
end
always_comb begin
   fm = 4'hx;
   if (c_instr_i_fence_s2) begin
      fm = instr_s2 [31 : 28];
   end
end
assign imm_11 = {{20 {instr_s2 [31]}}, instr_s2 [31 : 20]};
assign offset_20 = {{11 {j_type [19]}}, j_type, 1'b0};
assign d_sub_2compl = 0 - i_sub_b;
always_comb begin
   i_sub_b = 32'hxxxxxxxx;
   if (c_instr_i_sub_s2) begin
      i_sub_b = rs2_dato;
   end
   if (c_div_rem_s2) begin
      if (!(c_mc_0)) begin
         if (c_mc_1) begin
            i_sub_b = math_reg1;
         end
         else begin
            i_sub_b = math_reg1;
         end
      end
   end
   if (c_instr_c_sub_s2) begin
      i_sub_b = rs2_dato;
   end
end
assign sra_result = $signed (i_sra_data) >>> $signed (i_sra_shamt);
always_comb begin
   i_sra_shamt = 32'hxxxxxxxx;
   if (c_instr_i_srli_s2) begin
      i_sra_shamt = shamt;
   end
   if (c_instr_i_srai_s2) begin
      i_sra_shamt = shamt;
   end
   if (c_instr_i_srl_s2) begin
      i_sra_shamt = rs2_dato [4 : 0];
   end
   if (c_instr_i_sra_s2) begin
      i_sra_shamt = rs2_dato [4 : 0];
   end
   if (c_instr_c_srli_s2) begin
      i_sra_shamt = i_shamt_c;
   end
   if (c_instr_c_srai_s2) begin
      i_sra_shamt = i_shamt_c;
   end
end
always_comb begin
   i_sra_data = 33'hxxxxxxxxx;
   if (c_instr_i_srli_s2) begin
      i_sra_data = {1'b0, rs1_dato};
   end
   if (c_instr_i_srai_s2) begin
      i_sra_data = {rs1_dato [31], rs1_dato};
   end
   if (c_instr_i_srl_s2) begin
      i_sra_data = {1'b0, rs1_dato};
   end
   if (c_instr_i_sra_s2) begin
      i_sra_data = {rs1_dato [31], rs1_dato};
   end
   if (c_instr_c_srli_s2) begin
      i_sra_data = {1'b0, rs1_dato};
   end
   if (c_instr_c_srai_s2) begin
      i_sra_data = {rs1_dato [31], rs1_dato};
   end
end
assign shl_result = i_shl_data << i_shl_shamt;
always_comb begin
   i_shl_shamt = 32'hxxxxxxxx;
   if (c_instr_i_slli_s2) begin
      i_shl_shamt = shamt;
   end
   if (c_instr_i_sll_s2) begin
      i_shl_shamt = rs2_dato [4 : 0];
   end
   if (c_div_rem_s2) begin
      if (c_mc_0) begin
         i_shl_shamt = div_init_shift;
      end
   end
   if (c_instr_c_slli_s2) begin
      i_shl_shamt = i_shamt_c;
   end
end
always_comb begin
   i_shl_data = 32'hxxxxxxxx;
   if (c_instr_i_slli_s2) begin
      i_shl_data = rs1_dato;
   end
   if (c_instr_i_sll_s2) begin
      i_shl_data = rs1_dato;
   end
   if (c_div_rem_s2) begin
      if (c_mc_0) begin
         i_shl_data = rs2_dato;
      end
   end
   if (c_instr_c_slli_s2) begin
      i_shl_data = rs1_dato;
   end
end
assign shamt = instr_s2 [24 : 20];
assign less_result = $signed (i_less_a) < $signed (i_less_b);
always_comb begin
   i_less_b = 33'hxxxxxxxxx;
   if (c_instr_i_blt_s2) begin
      i_less_b = {rs2_dato [31], rs2_dato};
   end
   if (c_instr_i_bge_s2) begin
      i_less_b = {rs2_dato [31], rs2_dato};
   end
   if (c_instr_i_bltu_s2) begin
      i_less_b = {1'b0, rs2_dato};
   end
   if (c_instr_i_bgeu_s2) begin
      i_less_b = {1'b0, rs2_dato};
   end
   if (c_instr_i_slti_s2) begin
      i_less_b = {i_immediate [31], i_immediate};
   end
   if (c_instr_i_sltiu_s2) begin
      i_less_b = {1'b0, i_immediate};
   end
   if (c_instr_i_slt_s2) begin
      i_less_b = {rs2_dato [31], rs2_dato};
   end
   if (c_instr_i_sltu_s2) begin
      i_less_b = {1'b0, rs2_dato};
   end
   if (c_div_rem_s2) begin
      if (c_instr_m_div_s2) begin
         i_less_b = {rs2_dato [31], rs2_dato};
      end
      if (c_instr_m_divu_s2) begin
         i_less_b = {1'b0, rs2_dato};
      end
      if (c_instr_m_rem_s2) begin
         i_less_b = {rs2_dato [31], rs2_dato};
      end
      if (c_instr_m_remu_s2) begin
         i_less_b = {1'b0, rs2_dato};
      end
   end
end
always_comb begin
   i_less_a = 33'hxxxxxxxxx;
   if (c_instr_i_blt_s2) begin
      i_less_a = {rs1_dato [31], rs1_dato};
   end
   if (c_instr_i_bge_s2) begin
      i_less_a = {rs1_dato [31], rs1_dato};
   end
   if (c_instr_i_bltu_s2) begin
      i_less_a = {1'b0, rs1_dato};
   end
   if (c_instr_i_bgeu_s2) begin
      i_less_a = {1'b0, rs1_dato};
   end
   if (c_instr_i_slti_s2) begin
      i_less_a = {rs1_dato [31], rs1_dato};
   end
   if (c_instr_i_sltiu_s2) begin
      i_less_a = {1'b0, rs1_dato};
   end
   if (c_instr_i_slt_s2) begin
      i_less_a = {rs1_dato [31], rs1_dato};
   end
   if (c_instr_i_sltu_s2) begin
      i_less_a = {1'b0, rs1_dato};
   end
   if (c_div_rem_s2) begin
      if (c_instr_m_div_s2) begin
         i_less_a = {rs1_dato [31], rs1_dato};
      end
      if (c_instr_m_divu_s2) begin
         i_less_a = {1'b0, rs1_dato};
      end
      if (c_instr_m_rem_s2) begin
         i_less_a = {rs1_dato [31], rs1_dato};
      end
      if (c_instr_m_remu_s2) begin
         i_less_a = {1'b0, rs1_dato};
      end
   end
end
assign dp_add = i_add_a + i_add_b;
always_comb begin
   i_add_b = 32'hxxxxxxxx;
   if (c_instr_i_auipc_s2) begin
      i_add_b = u_immediate;
   end
   if (c_instr_i_jal_s2) begin
      i_add_b = offset_20;
   end
   if (c_instr_i_jalr_s2) begin
      i_add_b = imm_11;
   end
   if (c_instr_i_beq_s2) begin
      if (c_cond_beq) begin
         i_add_b = {{19 {b_type [11]}}, b_type, 1'b0};
      end
   end
   if (c_instr_i_bne_s2) begin
      if (!(c_cond_beq)) begin
         i_add_b = {{19 {b_type [11]}}, b_type, 1'b0};
      end
   end
   if (c_instr_i_blt_s2) begin
      if (c_less) begin
         i_add_b = {{19 {b_type [11]}}, b_type, 1'b0};
      end
   end
   if (c_instr_i_bge_s2) begin
      if (!(c_less)) begin
         i_add_b = {{19 {b_type [11]}}, b_type, 1'b0};
      end
   end
   if (c_instr_i_bltu_s2) begin
      if (c_less) begin
         i_add_b = {{19 {b_type [11]}}, b_type, 1'b0};
      end
   end
   if (c_instr_i_bgeu_s2) begin
      if (!(c_less)) begin
         i_add_b = {{19 {b_type [11]}}, b_type, 1'b0};
      end
   end
   if (c_instr_i_lb_s2) begin
      i_add_b = {{20 {i_type [11]}}, i_type};
   end
   if (c_instr_i_lh_s2) begin
      i_add_b = {{20 {i_type [11]}}, i_type};
   end
   if (c_instr_i_lw_s2) begin
      i_add_b = {{20 {i_type [11]}}, i_type};
   end
   if (c_instr_i_lbu_s2) begin
      i_add_b = {{20 {i_type [11]}}, i_type};
   end
   if (c_instr_i_lhu_s2) begin
      i_add_b = {{20 {i_type [11]}}, i_type};
   end
   if (c_instr_i_sb_s2) begin
      i_add_b = {{20 {s_type [11]}}, s_type};
   end
   if (c_instr_i_sh_s2) begin
      i_add_b = {{20 {s_type [11]}}, s_type};
   end
   if (c_instr_i_sw_s2) begin
      i_add_b = {{20 {s_type [11]}}, s_type};
   end
   if (c_instr_i_addi_s2) begin
      i_add_b = i_immediate;
   end
   if (c_instr_i_add_s2) begin
      i_add_b = rs2_dato;
   end
   if (c_instr_i_sub_s2) begin
      i_add_b = d_sub_2compl;
   end
   if (c_mul_s2) begin
      if (c_mc_0) begin
         i_add_b = i_mul_out;
      end
      if (c_mc_3) begin
         if (c_instr_m_mulh_s2) begin
            i_add_b = i_mul_out;
         end
         if (c_instr_m_mulhu_s2) begin
            i_add_b = i_mul_out;
         end
         if (c_instr_m_mulhsu_s2) begin
            i_add_b = i_mul_out;
         end
      end
      if (c_mc_2) begin
         if (c_instr_m_mul_s2) begin
            i_add_b = i_mul_out;
         end
         if (c_instr_m_mulh_s2) begin
            i_add_b = i_mul_out;
         end
         if (c_instr_m_mulhu_s2) begin
            i_add_b = i_mul_out;
         end
         if (c_instr_m_mulhsu_s2) begin
            i_add_b = i_mul_out;
         end
      end
      if (c_mc_1) begin
         if (c_instr_m_mul_s2) begin
            i_add_b = i_mul_out;
         end
         if (c_instr_m_mulh_s2) begin
            i_add_b = i_mul_out;
         end
         if (c_instr_m_mulhu_s2) begin
            i_add_b = i_mul_out;
         end
         if (c_instr_m_mulhsu_s2) begin
            i_add_b = i_mul_out;
         end
      end
   end
   if (c_div_rem_s2) begin
      if (!(c_mc_0)) begin
         if (c_mc_1) begin
            i_add_b = d_sub_2compl;
         end
         else begin
            i_add_b = d_sub_2compl;
         end
      end
   end
   if (c_instr_c_addi4sp_s2) begin
      i_add_b = sign_ext_imm8;
   end
   if (c_instr_c_lw_s2) begin
      i_add_b = offset_c;
   end
   if (c_instr_c_sw_s2) begin
      i_add_b = offset_c;
   end
   if (c_instr_c_addi_s2) begin
      i_add_b = sign_ext_imm6;
   end
   if (c_instr_c_jal_s2) begin
      i_add_b = imm_j_c;
   end
   if (c_instr_c_addi16sp_s2) begin
      i_add_b = sign_ext_imm6_sp;
   end
   if (c_instr_c_sub_s2) begin
      i_add_b = d_sub_2compl;
   end
   if (c_instr_c_j_s2) begin
      i_add_b = imm_j_c;
   end
   if (c_instr_c_beqz_s2) begin
      if (c_cond_beqz_c) begin
         i_add_b = sign_ext_imm8_c;
      end
   end
   if (c_instr_c_bnez_s2) begin
      if (c_cond_bnez_c) begin
         i_add_b = sign_ext_imm8_c;
      end
   end
   if (c_instr_c_lwsp_s2) begin
      i_add_b = offset_lwsp_c;
   end
   if (c_instr_c_jalr_s2) begin
      i_add_b = 2;
   end
   if (c_instr_c_add_s2) begin
      i_add_b = rs2_dato;
   end
   if (c_instr_c_swsp_s2) begin
      i_add_b = offset_swsp_c;
   end
end
always_comb begin
   i_add_a = 32'hxxxxxxxx;
   if (c_instr_i_auipc_s2) begin
      i_add_a = pc - pc_clear;
   end
   if (c_instr_i_jal_s2) begin
      i_add_a = pc - pc_clear;
   end
   if (c_instr_i_jalr_s2) begin
      i_add_a = rs1_dato;
   end
   if (c_instr_i_beq_s2) begin
      if (c_cond_beq) begin
         i_add_a = pc - pc_clear;
      end
   end
   if (c_instr_i_bne_s2) begin
      if (!(c_cond_beq)) begin
         i_add_a = pc - pc_clear;
      end
   end
   if (c_instr_i_blt_s2) begin
      if (c_less) begin
         i_add_a = pc - pc_clear;
      end
   end
   if (c_instr_i_bge_s2) begin
      if (!(c_less)) begin
         i_add_a = pc - pc_clear;
      end
   end
   if (c_instr_i_bltu_s2) begin
      if (c_less) begin
         i_add_a = pc - pc_clear;
      end
   end
   if (c_instr_i_bgeu_s2) begin
      if (!(c_less)) begin
         i_add_a = pc - pc_clear;
      end
   end
   if (c_instr_i_lb_s2) begin
      i_add_a = rs1_dato;
   end
   if (c_instr_i_lh_s2) begin
      i_add_a = rs1_dato;
   end
   if (c_instr_i_lw_s2) begin
      i_add_a = rs1_dato;
   end
   if (c_instr_i_lbu_s2) begin
      i_add_a = rs1_dato;
   end
   if (c_instr_i_lhu_s2) begin
      i_add_a = rs1_dato;
   end
   if (c_instr_i_sb_s2) begin
      i_add_a = rs1_dato;
   end
   if (c_instr_i_sh_s2) begin
      i_add_a = rs1_dato;
   end
   if (c_instr_i_sw_s2) begin
      i_add_a = rs1_dato;
   end
   if (c_instr_i_addi_s2) begin
      i_add_a = rs1_dato;
   end
   if (c_instr_i_add_s2) begin
      i_add_a = rs1_dato;
   end
   if (c_instr_i_sub_s2) begin
      i_add_a = rs1_dato;
   end
   if (c_mul_s2) begin
      if (c_mc_0) begin
         i_add_a = 0;
      end
      if (c_mc_3) begin
         if (c_instr_m_mulh_s2) begin
            i_add_a [15 : 0] = math_reg0 [31 : 16];
            i_add_a [31 : 16] = math_reg1 [15 : 0];
         end
         if (c_instr_m_mulhu_s2) begin
            i_add_a [15 : 0] = math_reg0 [31 : 16];
            i_add_a [31 : 16] = math_reg1 [15 : 0];
         end
         if (c_instr_m_mulhsu_s2) begin
            i_add_a [15 : 0] = math_reg0 [31 : 16];
            i_add_a [31 : 16] = math_reg1 [15 : 0];
         end
      end
      if (c_mc_2) begin
         if (c_instr_m_mul_s2) begin
            i_add_a = {math_reg1 [15 : 0], math_reg0 [31 : 16]};
         end
         if (c_instr_m_mulh_s2) begin
            i_add_a [15 : 0] = math_reg0 [31 : 16];
            i_add_a [31 : 16] = math_reg1 [15 : 0];
         end
         if (c_instr_m_mulhu_s2) begin
            i_add_a [15 : 0] = math_reg0 [31 : 16];
            i_add_a [31 : 16] = math_reg1 [15 : 0];
         end
         if (c_instr_m_mulhsu_s2) begin
            i_add_a [15 : 0] = math_reg0 [31 : 16];
            i_add_a [31 : 16] = math_reg1 [15 : 0];
         end
      end
      if (c_mc_1) begin
         if (c_instr_m_mul_s2) begin
            i_add_a [15 : 0] = math_reg0 [31 : 16];
            i_add_a [31 : 16] = math_reg1 [15 : 0];
         end
         if (c_instr_m_mulh_s2) begin
            i_add_a = {16'h0000, math_reg1 [15 : 0]};
         end
         if (c_instr_m_mulhu_s2) begin
            i_add_a = {16'h0000, math_reg1 [15 : 0]};
         end
         if (c_instr_m_mulhsu_s2) begin
            i_add_a = {16'h0000, math_reg1 [15 : 0]};
         end
      end
   end
   if (c_div_rem_s2) begin
      if (!(c_mc_0)) begin
         if (c_mc_1) begin
            i_add_a = math_reg0;
         end
         else begin
            i_add_a = math_reg0;
         end
      end
   end
   if (c_instr_c_addi4sp_s2) begin
      i_add_a = rs1_dato;
   end
   if (c_instr_c_lw_s2) begin
      i_add_a = rs1_dato;
   end
   if (c_instr_c_sw_s2) begin
      i_add_a = rs1_dato;
   end
   if (c_instr_c_addi_s2) begin
      i_add_a = rs1_dato;
   end
   if (c_instr_c_jal_s2) begin
      i_add_a = pc - pc_clear;
   end
   if (c_instr_c_addi16sp_s2) begin
      i_add_a = rs1_dato;
   end
   if (c_instr_c_sub_s2) begin
      i_add_a = rs1_dato;
   end
   if (c_instr_c_j_s2) begin
      i_add_a = pc - pc_clear;
   end
   if (c_instr_c_beqz_s2) begin
      if (c_cond_beqz_c) begin
         i_add_a = pc - pc_clear;
      end
   end
   if (c_instr_c_bnez_s2) begin
      if (c_cond_bnez_c) begin
         i_add_a = pc - pc_clear;
      end
   end
   if (c_instr_c_lwsp_s2) begin
      i_add_a = rs1_dato;
   end
   if (c_instr_c_jalr_s2) begin
      i_add_a = pc - pc_clear;
   end
   if (c_instr_c_add_s2) begin
      i_add_a = rs1_dato;
   end
   if (c_instr_c_swsp_s2) begin
      i_add_a = rs1_dato;
   end
end
assign u_immediate = {instr_s2 [31 : 12], 12'h000};
assign i_immediate = {{20 {instr_s2 [31]}}, instr_s2 [31 : 20]};
assign j_type = {instr_s2 [31], instr_s2 [19 : 12], instr_s2 [20], instr_s2 [30 : 21]};
assign b_type = {instr_s2 [31], instr_s2 [7], instr_s2 [30 : 25], instr_s2 [11 : 8]};
assign s_type = {instr_s2 [31 : 25], instr_s2 [11 : 7]};
assign i_type = instr_s2 [31 : 20];
assign opcode_i = instr_s2 [6 : 0];
assign rdi = instr_s2 [11 : 7];
assign rs1i = instr_s1 [19 : 15];
assign rs2i = instr_s1 [24 : 20];
assign funct3_i = instr_s2 [14 : 12];
assign funct7_i = instr_s2 [31 : 25];
assign funct3_i_s1 = instr_s1 [14 : 12];
assign funct7_i_s1 = instr_s1 [31 : 25];
assign opcode_i_s1 = instr_s1 [6 : 0];
always_comb begin
   for (integer i = 0; i < $size (pc_next); i = i + 1) begin
      pc_next [i] = 1'bx;
   end
   if (c_instr_i_jal_s2) begin
      pc_next = dp_add;
   end
   if (c_instr_i_jalr_s2) begin
      pc_next = dp_add;
   end
   if (c_instr_i_beq_s2) begin
      if (c_cond_beq) begin
         pc_next = dp_add;
      end
   end
   if (c_instr_i_bne_s2) begin
      if (!(c_cond_beq)) begin
         pc_next = dp_add;
      end
   end
   if (c_instr_i_blt_s2) begin
      if (c_less) begin
         pc_next = dp_add;
      end
   end
   if (c_instr_i_bge_s2) begin
      if (!(c_less)) begin
         pc_next = dp_add;
      end
   end
   if (c_instr_i_bltu_s2) begin
      if (c_less) begin
         pc_next = dp_add;
      end
   end
   if (c_instr_i_bgeu_s2) begin
      if (!(c_less)) begin
         pc_next = dp_add;
      end
   end
   if (c_instr_c_jal_s2) begin
      pc_next = dp_add;
   end
   if (c_instr_c_j_s2) begin
      pc_next = dp_add;
   end
   if (c_instr_c_beqz_s2) begin
      if (c_cond_beqz_c) begin
         pc_next = dp_add;
      end
   end
   if (c_instr_c_bnez_s2) begin
      if (c_cond_bnez_c) begin
         pc_next = dp_add;
      end
   end
   if (c_instr_c_jr_s2) begin
      pc_next = rs1_dato;
   end
   if (c_instr_c_jalr_s2) begin
      pc_next = rs1_dato;
   end
end
assign pc_clear = (pc4_s1 & pc4_s2) ? 8 : (!pc4_s1 & !pc4_s2) ? 4 : 6;

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
assign c_c_nzimm_not_x0_s1 = (sign_ext_imm6_s1 != 32'h00000000);
assign c_c_nzimm_not_x0 = (sign_ext_imm6 != 32'h00000000);
assign c_c_rs2_not_x0_s1 = (instr_s1 [6 : 2] != 5'b00000);
assign c_c_rs2_not_x0 = (instr_s2 [6 : 2] != 5'b00000);
assign c_c_rs2_x0_s1 = (instr_s1 [6 : 2] == 5'b00000);
assign c_c_rs2_x0 = (instr_s2 [6 : 2] == 5'b00000);
assign c_c_rs1_not_x0_s1 = (instr_s1 [11 : 7] != 5'b00000);
assign c_c_rs1_not_x0 = (instr_s2 [11 : 7] != 5'b00000);
assign c_c_rs1_x0_s1 = (instr_s1 [11 : 7] == 5'b00000);
assign c_c_rs1_x0 = (instr_s2 [11 : 7] == 5'b00000);
assign c_c_rd_not_x2_s1 = (instr_s1 [11 : 7] != 5'b00010);
assign c_c_rd_not_x2 = (instr_s2 [11 : 7] != 5'b00010);
assign c_c_rd_not_x0_s1 = (instr_s1 [11 : 7] != 5'b00000);
assign c_c_rd_not_x0 = (instr_s2 [11 : 7] != 5'b00000);
assign c_instr_c_swsp_s2 = ((c_cmp (opcode_c, 2)) & (c_cmp (funct3_c, 6)));
assign c_instr_c_add_s2 = ((c_cmp (opcode_c, 2)) & (c_cmp (funct3_c, 4)) & (c_cmp (instr_s2 [12], 1)) & (c_c_rd_not_x0) & (c_c_rs1_not_x0) & (c_c_rs2_not_x0));
assign c_instr_c_jalr_s2 = ((c_cmp (opcode_c, 2)) & (c_cmp (funct3_c, 4)) & (c_cmp (instr_s2 [12], 1)) & (c_c_rs1_not_x0) & (c_c_rs2_x0));
assign c_instr_c_ebreak_s2 = ((c_cmp (opcode_c, 2)) & (c_cmp (funct3_c, 4)) & (c_cmp (instr_s2 [12], 1)) & (c_c_rs1_x0) & (c_c_rs2_x0));
assign c_instr_c_mv_s2 = ((c_cmp (opcode_c, 2)) & (c_cmp (funct3_c, 4)) & (c_cmp (instr_s2 [12], 0)) & (c_c_rd_not_x0) & (c_c_rs2_not_x0));
assign c_instr_c_jr_s2 = ((c_cmp (opcode_c, 2)) & (c_cmp (funct3_c, 4)) & (c_cmp (instr_s2 [12], 0)) & (c_c_rs1_not_x0) & (c_c_rs2_x0));
assign c_instr_c_lwsp_s2 = ((c_cmp (opcode_c, 2)) & (c_cmp (funct3_c, 2)));
assign c_instr_c_slli_s2 = ((c_cmp (opcode_c, 2)) & (c_cmp (funct3_c, 0)) & (c_c_rd_not_x0));
assign c_instr_c_bnez_s2 = ((c_cmp (opcode_c, 1)) & (c_cmp (funct3_c, 7)));
assign c_instr_c_beqz_s2 = ((c_cmp (opcode_c, 1)) & (c_cmp (funct3_c, 6)));
assign c_instr_c_j_s2 = ((c_cmp (opcode_c, 1)) & (c_cmp (funct3_c, 5)));
assign c_instr_c_and_s2 = ((c_cmp (opcode_c, 1)) & (c_cmp (funct3_c, 4)) & (c_cmp (instr_s2 [11 : 10], 3)) & (c_cmp (instr_s2 [12], 0)) & (c_cmp (instr_s2 [6 : 5], 3)));
assign c_instr_c_or_s2 = ((c_cmp (opcode_c, 1)) & (c_cmp (funct3_c, 4)) & (c_cmp (instr_s2 [11 : 10], 3)) & (c_cmp (instr_s2 [12], 0)) & (c_cmp (instr_s2 [6 : 5], 2)));
assign c_instr_c_xor_s2 = ((c_cmp (opcode_c, 1)) & (c_cmp (funct3_c, 4)) & (c_cmp (instr_s2 [11 : 10], 3)) & (c_cmp (instr_s2 [12], 0)) & (c_cmp (instr_s2 [6 : 5], 1)));
assign c_instr_c_sub_s2 = ((c_cmp (opcode_c, 1)) & (c_cmp (funct3_c, 4)) & (c_cmp (instr_s2 [11 : 10], 3)) & (c_cmp (instr_s2 [12], 0)) & (c_cmp (instr_s2 [6 : 5], 0)));
assign c_instr_c_andi_s2 = ((c_cmp (opcode_c, 1)) & (c_cmp (funct3_c, 4)) & (c_cmp (instr_s2 [11 : 10], 2)));
assign c_instr_c_srai_s2 = ((c_cmp (opcode_c, 1)) & (c_cmp (funct3_c, 4)) & (c_cmp (instr_s2 [11 : 10], 1)));
assign c_instr_c_srli_s2 = ((c_cmp (opcode_c, 1)) & (c_cmp (funct3_c, 4)) & (c_cmp (instr_s2 [11 : 10], 0)));
assign c_instr_c_addi16sp_s2 = ((c_cmp (opcode_c, 1)) & (c_cmp (funct3_c, 3)) & (c_cmp (instr_s2 [11 : 7], 2)));
assign c_instr_c_lui_s2 = ((c_cmp (opcode_c, 1)) & (c_cmp (funct3_c, 3)) & (c_c_rd_not_x0) & (c_c_rd_not_x2));
assign c_instr_c_li_s2 = ((c_cmp (opcode_c, 1)) & (c_cmp (funct3_c, 2)));
assign c_instr_c_jal_s2 = ((c_cmp (opcode_c, 1)) & (c_cmp (funct3_c, 1)));
assign c_instr_c_addi_s2 = ((c_cmp (opcode_c, 1)) & (c_cmp (funct3_c, 0)) & (c_c_nzimm_not_x0) & (c_c_rd_not_x0));
assign c_instr_c_nop_s2 = ((c_cmp (opcode_c, 1)) & (c_cmp (funct3_c, 0)) & (c_c_rs1_x0));
assign c_instr_c_sw_s2 = ((c_cmp (opcode_c, 0)) & (c_cmp (funct3_c, 6)));
assign c_instr_c_lw_s2 = ((c_cmp (opcode_c, 0)) & (c_cmp (funct3_c, 2)));
assign c_instr_c_addi4sp_s2 = ((c_cmp (opcode_c, 0)) & (c_cmp (funct3_c, 0)));
assign c_instr_c_swsp_s1 = ((c_cmp (opcode_c_s1, 2)) & (c_cmp (funct3_c_s1, 6)));
assign c_instr_c_add_s1 = ((c_cmp (opcode_c_s1, 2)) & (c_cmp (funct3_c_s1, 4)) & (c_cmp (instr_s1 [12], 1)) & (c_c_rd_not_x0_s1) & (c_c_rs1_not_x0_s1) & (c_c_rs2_not_x0_s1));
assign c_instr_c_jalr_s1 = ((c_cmp (opcode_c_s1, 2)) & (c_cmp (funct3_c_s1, 4)) & (c_cmp (instr_s1 [12], 1)) & (c_c_rs1_not_x0_s1) & (c_c_rs2_x0_s1));
assign c_instr_c_ebreak_s1 = ((c_cmp (opcode_c_s1, 2)) & (c_cmp (funct3_c_s1, 4)) & (c_cmp (instr_s1 [12], 1)) & (c_c_rs1_x0_s1) & (c_c_rs2_x0_s1));
assign c_instr_c_mv_s1 = ((c_cmp (opcode_c_s1, 2)) & (c_cmp (funct3_c_s1, 4)) & (c_cmp (instr_s1 [12], 0)) & (c_c_rd_not_x0_s1) & (c_c_rs2_not_x0_s1));
assign c_instr_c_jr_s1 = ((c_cmp (opcode_c_s1, 2)) & (c_cmp (funct3_c_s1, 4)) & (c_cmp (instr_s1 [12], 0)) & (c_c_rs1_not_x0_s1) & (c_c_rs2_x0_s1));
assign c_instr_c_lwsp_s1 = ((c_cmp (opcode_c_s1, 2)) & (c_cmp (funct3_c_s1, 2)));
assign c_instr_c_slli_s1 = ((c_cmp (opcode_c_s1, 2)) & (c_cmp (funct3_c_s1, 0)) & (c_c_rd_not_x0_s1));
assign c_instr_c_bnez_s1 = ((c_cmp (opcode_c_s1, 1)) & (c_cmp (funct3_c_s1, 7)));
assign c_instr_c_beqz_s1 = ((c_cmp (opcode_c_s1, 1)) & (c_cmp (funct3_c_s1, 6)));
assign c_instr_c_j_s1 = ((c_cmp (opcode_c_s1, 1)) & (c_cmp (funct3_c_s1, 5)));
assign c_instr_c_and_s1 = ((c_cmp (opcode_c_s1, 1)) & (c_cmp (funct3_c_s1, 4)) & (c_cmp (instr_s1 [11 : 10], 3)) & (c_cmp (instr_s1 [12], 0)) & (c_cmp (instr_s1 [6 : 5], 3)));
assign c_instr_c_or_s1 = ((c_cmp (opcode_c_s1, 1)) & (c_cmp (funct3_c_s1, 4)) & (c_cmp (instr_s1 [11 : 10], 3)) & (c_cmp (instr_s1 [12], 0)) & (c_cmp (instr_s1 [6 : 5], 2)));
assign c_instr_c_xor_s1 = ((c_cmp (opcode_c_s1, 1)) & (c_cmp (funct3_c_s1, 4)) & (c_cmp (instr_s1 [11 : 10], 3)) & (c_cmp (instr_s1 [12], 0)) & (c_cmp (instr_s1 [6 : 5], 1)));
assign c_instr_c_sub_s1 = ((c_cmp (opcode_c_s1, 1)) & (c_cmp (funct3_c_s1, 4)) & (c_cmp (instr_s1 [11 : 10], 3)) & (c_cmp (instr_s1 [12], 0)) & (c_cmp (instr_s1 [6 : 5], 0)));
assign c_instr_c_andi_s1 = ((c_cmp (opcode_c_s1, 1)) & (c_cmp (funct3_c_s1, 4)) & (c_cmp (instr_s1 [11 : 10], 2)));
assign c_instr_c_srai_s1 = ((c_cmp (opcode_c_s1, 1)) & (c_cmp (funct3_c_s1, 4)) & (c_cmp (instr_s1 [11 : 10], 1)));
assign c_instr_c_srli_s1 = ((c_cmp (opcode_c_s1, 1)) & (c_cmp (funct3_c_s1, 4)) & (c_cmp (instr_s1 [11 : 10], 0)));
assign c_instr_c_addi16sp_s1 = ((c_cmp (opcode_c_s1, 1)) & (c_cmp (funct3_c_s1, 3)) & (c_cmp (instr_s1 [11 : 7], 2)));
assign c_instr_c_lui_s1 = ((c_cmp (opcode_c_s1, 1)) & (c_cmp (funct3_c_s1, 3)) & (c_c_rd_not_x0_s1) & (c_c_rd_not_x2_s1));
assign c_instr_c_li_s1 = ((c_cmp (opcode_c_s1, 1)) & (c_cmp (funct3_c_s1, 2)));
assign c_instr_c_jal_s1 = ((c_cmp (opcode_c_s1, 1)) & (c_cmp (funct3_c_s1, 1)));
assign c_instr_c_addi_s1 = ((c_cmp (opcode_c_s1, 1)) & (c_cmp (funct3_c_s1, 0)) & (c_c_nzimm_not_x0_s1) & (c_c_rd_not_x0_s1));
assign c_instr_c_nop_s1 = ((c_cmp (opcode_c_s1, 1)) & (c_cmp (funct3_c_s1, 0)) & (c_c_rs1_x0_s1));
assign c_instr_c_sw_s1 = ((c_cmp (opcode_c_s1, 0)) & (c_cmp (funct3_c_s1, 6)));
assign c_instr_c_lw_s1 = ((c_cmp (opcode_c_s1, 0)) & (c_cmp (funct3_c_s1, 2)));
assign c_instr_c_addi4sp_s1 = ((c_cmp (opcode_c_s1, 0)) & (c_cmp (funct3_c_s1, 0)));
assign c_cond_bnez_c = (rs1_dato != 0);
assign c_cond_beqz_c = (rs1_dato == 0);
assign c_instr_m_remu_s2 = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct7_i, 7'b0000001)) & (c_cmp (funct3_i, 7)));
assign c_instr_m_rem_s2 = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct7_i, 7'b0000001)) & (c_cmp (funct3_i, 6)));
assign c_instr_m_divu_s2 = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct7_i, 7'b0000001)) & (c_cmp (funct3_i, 5)));
assign c_instr_m_div_s2 = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct7_i, 7'b0000001)) & (c_cmp (funct3_i, 4)));
assign c_instr_m_mulhsu_s2 = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct7_i, 7'b0000001)) & (c_cmp (funct3_i, 2)));
assign c_instr_m_mulhu_s2 = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct7_i, 7'b0000001)) & (c_cmp (funct3_i, 3)));
assign c_instr_m_mulh_s2 = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct7_i, 7'b0000001)) & (c_cmp (funct3_i, 1)));
assign c_instr_m_mul_s2 = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct7_i, 7'b0000001)) & (c_cmp (funct3_i, 0)));
assign c_instr_m_remu_s1 = ((c_cmp (opcode_i_s1, 7'b0110011)) & (c_cmp (funct7_i_s1, 7'b0000001)) & (c_cmp (funct3_i_s1, 7)));
assign c_instr_m_rem_s1 = ((c_cmp (opcode_i_s1, 7'b0110011)) & (c_cmp (funct7_i_s1, 7'b0000001)) & (c_cmp (funct3_i_s1, 6)));
assign c_instr_m_divu_s1 = ((c_cmp (opcode_i_s1, 7'b0110011)) & (c_cmp (funct7_i_s1, 7'b0000001)) & (c_cmp (funct3_i_s1, 5)));
assign c_instr_m_div_s1 = ((c_cmp (opcode_i_s1, 7'b0110011)) & (c_cmp (funct7_i_s1, 7'b0000001)) & (c_cmp (funct3_i_s1, 4)));
assign c_instr_m_mulhsu_s1 = ((c_cmp (opcode_i_s1, 7'b0110011)) & (c_cmp (funct7_i_s1, 7'b0000001)) & (c_cmp (funct3_i_s1, 2)));
assign c_instr_m_mulhu_s1 = ((c_cmp (opcode_i_s1, 7'b0110011)) & (c_cmp (funct7_i_s1, 7'b0000001)) & (c_cmp (funct3_i_s1, 3)));
assign c_instr_m_mulh_s1 = ((c_cmp (opcode_i_s1, 7'b0110011)) & (c_cmp (funct7_i_s1, 7'b0000001)) & (c_cmp (funct3_i_s1, 1)));
assign c_instr_m_mul_s1 = ((c_cmp (opcode_i_s1, 7'b0110011)) & (c_cmp (funct7_i_s1, 7'b0000001)) & (c_cmp (funct3_i_s1, 0)));
always_comb begin
   c_div_rem_s2 = 1'b0;
   if (c_instr_m_div_s2) begin
      c_div_rem_s2 = 1'b1;
   end
   if (c_instr_m_divu_s2) begin
      c_div_rem_s2 = 1'b1;
   end
   if (c_instr_m_rem_s2) begin
      c_div_rem_s2 = 1'b1;
   end
   if (c_instr_m_remu_s2) begin
      c_div_rem_s2 = 1'b1;
   end
end
always_comb begin
   c_div_rem_s1 = 1'b0;
   if (c_instr_m_div_s1) begin
      c_div_rem_s1 = 1'b1;
   end
   if (c_instr_m_divu_s1) begin
      c_div_rem_s1 = 1'b1;
   end
   if (c_instr_m_rem_s1) begin
      c_div_rem_s1 = 1'b1;
   end
   if (c_instr_m_remu_s1) begin
      c_div_rem_s1 = 1'b1;
   end
end
assign c_div_result_neg = (dp_add [31] == 1'b1);
assign c_div_result_pos = (dp_add [31] == 1'b0);
assign c_divisor_neg = (rs2_dato [31] == 1'b1);
assign c_divident_neg = (rs1_dato [31] == 1'b1);
always_comb begin
   c_divident_lesser_divisor = 1'b0;
   if (c_instr_m_div_s2) begin
      if (!(c_sign_differ)) begin
         if (c_less) begin
            if (!(c_divident_neg)) begin
               c_divident_lesser_divisor = 1'b1;
            end
         end
         else begin
            if (c_divident_neg) begin
               c_divident_lesser_divisor = 1'b1;
            end
         end
      end
   end
   if (c_instr_m_divu_s2) begin
      if (c_less) begin
         c_divident_lesser_divisor = 1'b1;
      end
   end
   if (c_instr_m_rem_s2) begin
      if (!(c_sign_differ)) begin
         if (c_less) begin
            if (!(c_divident_neg)) begin
               c_divident_lesser_divisor = 1'b1;
            end
         end
         else begin
            if (c_divident_neg) begin
               c_divident_lesser_divisor = 1'b1;
            end
         end
      end
   end
   if (c_instr_m_remu_s2) begin
      if (c_less) begin
         c_divident_lesser_divisor = 1'b1;
      end
   end
end
assign c_sign_differ = (rs1_dato [31] != rs2_dato [31]);
always_comb begin
   c_mul_s2 = 1'b0;
   if (c_instr_m_mul_s2) begin
      c_mul_s2 = 1'b1;
   end
   if (c_instr_m_mulh_s2) begin
      c_mul_s2 = 1'b1;
   end
   if (c_instr_m_mulhu_s2) begin
      c_mul_s2 = 1'b1;
   end
   if (c_instr_m_mulhsu_s2) begin
      c_mul_s2 = 1'b1;
   end
end
always_comb begin
   c_mul_s1 = 1'b0;
   if (c_instr_m_mul_s1) begin
      c_mul_s1 = 1'b1;
   end
   if (c_instr_m_mulh_s1) begin
      c_mul_s1 = 1'b1;
   end
   if (c_instr_m_mulhu_s1) begin
      c_mul_s1 = 1'b1;
   end
   if (c_instr_m_mulhsu_s1) begin
      c_mul_s1 = 1'b1;
   end
end
assign c_instr_i_ebreak_s2 = ((c_cmp (opcode_i, 7'b1110011)) & (c_cmp (instr_s2 [31 : 7], 25'h002000)));
assign c_instr_i_ecall_s2 = ((c_cmp (opcode_i, 7'b1110011)) & (c_cmp (instr_s2 [31 : 7], 25'h000000)));
assign c_instr_i_fence_s2 = ((c_cmp (opcode_i, 7'b1110011)) & (c_cmp (funct3_i, 0)));
assign c_instr_i_and_s2 = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct3_i, 7)) & (c_cmp (funct7_i, 0)));
assign c_instr_i_or_s2 = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct3_i, 6)) & (c_cmp (funct7_i, 0)));
assign c_instr_i_sra_s2 = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct3_i, 5)) & (c_cmp (funct7_i, 32)));
assign c_instr_i_srl_s2 = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct3_i, 5)) & (c_cmp (funct7_i, 0)));
assign c_instr_i_xor_s2 = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct3_i, 4)) & (c_cmp (funct7_i, 0)));
assign c_instr_i_sltu_s2 = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct3_i, 3)) & (c_cmp (funct7_i, 0)));
assign c_instr_i_slt_s2 = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct3_i, 2)) & (c_cmp (funct7_i, 0)));
assign c_instr_i_sll_s2 = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct3_i, 1)) & (c_cmp (funct7_i, 0)));
assign c_instr_i_sub_s2 = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct3_i, 0)) & (c_cmp (funct7_i, 32)));
assign c_instr_i_add_s2 = ((c_cmp (opcode_i, 7'b0110011)) & (c_cmp (funct3_i, 0)) & (c_cmp (funct7_i, 0)));
assign c_instr_i_srai_s2 = ((c_cmp (opcode_i, 7'b0010011)) & (c_cmp (funct3_i, 5)) & (c_cmp (funct7_i, 32)));
assign c_instr_i_srli_s2 = ((c_cmp (opcode_i, 7'b0010011)) & (c_cmp (funct3_i, 5)) & (c_cmp (funct7_i, 0)));
assign c_instr_i_slli_s2 = ((c_cmp (opcode_i, 7'b0010011)) & (c_cmp (funct3_i, 1)) & (c_cmp (funct7_i, 0)));
assign c_instr_i_andi_s2 = ((c_cmp (opcode_i, 7'b0010011)) & (c_cmp (funct3_i, 7)));
assign c_instr_i_ori_s2 = ((c_cmp (opcode_i, 7'b0010011)) & (c_cmp (funct3_i, 6)));
assign c_instr_i_xori_s2 = ((c_cmp (opcode_i, 7'b0010011)) & (c_cmp (funct3_i, 4)));
assign c_instr_i_sltiu_s2 = ((c_cmp (opcode_i, 7'b0010011)) & (c_cmp (funct3_i, 3)));
assign c_instr_i_slti_s2 = ((c_cmp (opcode_i, 7'b0010011)) & (c_cmp (funct3_i, 2)));
assign c_instr_i_addi_s2 = ((c_cmp (opcode_i, 7'b0010011)) & (c_cmp (funct3_i, 0)));
assign c_instr_i_sw_s2 = ((c_cmp (opcode_i, 7'b0100011)) & (c_cmp (funct3_i, 2)));
assign c_instr_i_sh_s2 = ((c_cmp (opcode_i, 7'b0100011)) & (c_cmp (funct3_i, 1)));
assign c_instr_i_sb_s2 = ((c_cmp (opcode_i, 7'b0100011)) & (c_cmp (funct3_i, 0)));
assign c_instr_i_lhu_s2 = ((c_cmp (opcode_i, 7'b0000011)) & (c_cmp (funct3_i, 5)));
assign c_instr_i_lbu_s2 = ((c_cmp (opcode_i, 7'b0000011)) & (c_cmp (funct3_i, 4)));
assign c_instr_i_lw_s2 = ((c_cmp (opcode_i, 7'b0000011)) & (c_cmp (funct3_i, 2)));
assign c_instr_i_lh_s2 = ((c_cmp (opcode_i, 7'b0000011)) & (c_cmp (funct3_i, 1)));
assign c_instr_i_lb_s2 = ((c_cmp (opcode_i, 7'b0000011)) & (c_cmp (funct3_i, 0)));
assign c_instr_i_bgeu_s2 = ((c_cmp (opcode_i, 7'b1100011)) & (c_cmp (funct3_i, 7)));
assign c_instr_i_bltu_s2 = ((c_cmp (opcode_i, 7'b1100011)) & (c_cmp (funct3_i, 6)));
assign c_instr_i_bge_s2 = ((c_cmp (opcode_i, 7'b1100011)) & (c_cmp (funct3_i, 5)));
assign c_instr_i_blt_s2 = ((c_cmp (opcode_i, 7'b1100011)) & (c_cmp (funct3_i, 4)));
assign c_instr_i_bne_s2 = ((c_cmp (opcode_i, 7'b1100011)) & (c_cmp (funct3_i, 1)));
assign c_instr_i_beq_s2 = ((c_cmp (opcode_i, 7'b1100011)) & (c_cmp (funct3_i, 0)));
assign c_instr_i_jalr_s2 = ((c_cmp (opcode_i, 7'b1100111)) & (c_cmp (funct3_i, 0)));
assign c_instr_i_jal_s2 = (c_cmp (opcode_i, 7'b1101111));
assign c_instr_i_auipc_s2 = (c_cmp (opcode_i, 7'b0010111));
assign c_instr_i_lui_s2 = (c_cmp (opcode_i, 7'b0110111));
assign c_instr_i_ebreak_s1 = ((c_cmp (opcode_i_s1, 7'b1110011)) & (c_cmp (instr_s1 [31 : 7], 25'h002000)));
assign c_instr_i_ecall_s1 = ((c_cmp (opcode_i_s1, 7'b1110011)) & (c_cmp (instr_s1 [31 : 7], 25'h000000)));
assign c_instr_i_fence_s1 = ((c_cmp (opcode_i_s1, 7'b1110011)) & (c_cmp (funct3_i_s1, 0)));
assign c_instr_i_and_s1 = ((c_cmp (opcode_i_s1, 7'b0110011)) & (c_cmp (funct3_i_s1, 7)) & (c_cmp (funct7_i_s1, 0)));
assign c_instr_i_or_s1 = ((c_cmp (opcode_i_s1, 7'b0110011)) & (c_cmp (funct3_i_s1, 6)) & (c_cmp (funct7_i_s1, 0)));
assign c_instr_i_sra_s1 = ((c_cmp (opcode_i_s1, 7'b0110011)) & (c_cmp (funct3_i_s1, 5)) & (c_cmp (funct7_i_s1, 32)));
assign c_instr_i_srl_s1 = ((c_cmp (opcode_i_s1, 7'b0110011)) & (c_cmp (funct3_i_s1, 5)) & (c_cmp (funct7_i_s1, 0)));
assign c_instr_i_xor_s1 = ((c_cmp (opcode_i_s1, 7'b0110011)) & (c_cmp (funct3_i_s1, 4)) & (c_cmp (funct7_i_s1, 0)));
assign c_instr_i_sltu_s1 = ((c_cmp (opcode_i_s1, 7'b0110011)) & (c_cmp (funct3_i_s1, 3)) & (c_cmp (funct7_i_s1, 0)));
assign c_instr_i_slt_s1 = ((c_cmp (opcode_i_s1, 7'b0110011)) & (c_cmp (funct3_i_s1, 2)) & (c_cmp (funct7_i_s1, 0)));
assign c_instr_i_sll_s1 = ((c_cmp (opcode_i_s1, 7'b0110011)) & (c_cmp (funct3_i_s1, 1)) & (c_cmp (funct7_i_s1, 0)));
assign c_instr_i_sub_s1 = ((c_cmp (opcode_i_s1, 7'b0110011)) & (c_cmp (funct3_i_s1, 0)) & (c_cmp (funct7_i_s1, 32)));
assign c_instr_i_add_s1 = ((c_cmp (opcode_i_s1, 7'b0110011)) & (c_cmp (funct3_i_s1, 0)) & (c_cmp (funct7_i_s1, 0)));
assign c_instr_i_srai_s1 = ((c_cmp (opcode_i_s1, 7'b0010011)) & (c_cmp (funct3_i_s1, 5)) & (c_cmp (funct7_i_s1, 32)));
assign c_instr_i_srli_s1 = ((c_cmp (opcode_i_s1, 7'b0010011)) & (c_cmp (funct3_i_s1, 5)) & (c_cmp (funct7_i_s1, 0)));
assign c_instr_i_slli_s1 = ((c_cmp (opcode_i_s1, 7'b0010011)) & (c_cmp (funct3_i_s1, 1)) & (c_cmp (funct7_i_s1, 0)));
assign c_instr_i_andi_s1 = ((c_cmp (opcode_i_s1, 7'b0010011)) & (c_cmp (funct3_i_s1, 7)));
assign c_instr_i_ori_s1 = ((c_cmp (opcode_i_s1, 7'b0010011)) & (c_cmp (funct3_i_s1, 6)));
assign c_instr_i_xori_s1 = ((c_cmp (opcode_i_s1, 7'b0010011)) & (c_cmp (funct3_i_s1, 4)));
assign c_instr_i_sltiu_s1 = ((c_cmp (opcode_i_s1, 7'b0010011)) & (c_cmp (funct3_i_s1, 3)));
assign c_instr_i_slti_s1 = ((c_cmp (opcode_i_s1, 7'b0010011)) & (c_cmp (funct3_i_s1, 2)));
assign c_instr_i_addi_s1 = ((c_cmp (opcode_i_s1, 7'b0010011)) & (c_cmp (funct3_i_s1, 0)));
assign c_instr_i_sw_s1 = ((c_cmp (opcode_i_s1, 7'b0100011)) & (c_cmp (funct3_i_s1, 2)));
assign c_instr_i_sh_s1 = ((c_cmp (opcode_i_s1, 7'b0100011)) & (c_cmp (funct3_i_s1, 1)));
assign c_instr_i_sb_s1 = ((c_cmp (opcode_i_s1, 7'b0100011)) & (c_cmp (funct3_i_s1, 0)));
assign c_instr_i_lhu_s1 = ((c_cmp (opcode_i_s1, 7'b0000011)) & (c_cmp (funct3_i_s1, 5)));
assign c_instr_i_lbu_s1 = ((c_cmp (opcode_i_s1, 7'b0000011)) & (c_cmp (funct3_i_s1, 4)));
assign c_instr_i_lw_s1 = ((c_cmp (opcode_i_s1, 7'b0000011)) & (c_cmp (funct3_i_s1, 2)));
assign c_instr_i_lh_s1 = ((c_cmp (opcode_i_s1, 7'b0000011)) & (c_cmp (funct3_i_s1, 1)));
assign c_instr_i_lb_s1 = ((c_cmp (opcode_i_s1, 7'b0000011)) & (c_cmp (funct3_i_s1, 0)));
assign c_instr_i_bgeu_s1 = ((c_cmp (opcode_i_s1, 7'b1100011)) & (c_cmp (funct3_i_s1, 7)));
assign c_instr_i_bltu_s1 = ((c_cmp (opcode_i_s1, 7'b1100011)) & (c_cmp (funct3_i_s1, 6)));
assign c_instr_i_bge_s1 = ((c_cmp (opcode_i_s1, 7'b1100011)) & (c_cmp (funct3_i_s1, 5)));
assign c_instr_i_blt_s1 = ((c_cmp (opcode_i_s1, 7'b1100011)) & (c_cmp (funct3_i_s1, 4)));
assign c_instr_i_bne_s1 = ((c_cmp (opcode_i_s1, 7'b1100011)) & (c_cmp (funct3_i_s1, 1)));
assign c_instr_i_beq_s1 = ((c_cmp (opcode_i_s1, 7'b1100011)) & (c_cmp (funct3_i_s1, 0)));
assign c_instr_i_jalr_s1 = ((c_cmp (opcode_i_s1, 7'b1100111)) & (c_cmp (funct3_i_s1, 0)));
assign c_instr_i_jal_s1 = (c_cmp (opcode_i_s1, 7'b1101111));
assign c_instr_i_auipc_s1 = (c_cmp (opcode_i_s1, 7'b0010111));
assign c_instr_i_lui_s1 = (c_cmp (opcode_i_s1, 7'b0110111));
always_comb begin
   c_dmem_store = 1'b0;
   if (c_instr_i_sb_s2) begin
      c_dmem_store = 1'b1;
   end
   if (c_instr_i_sh_s2) begin
      c_dmem_store = 1'b1;
   end
   if (c_instr_i_sw_s2) begin
      c_dmem_store = 1'b1;
   end
   if (c_instr_c_sw_s2) begin
      c_dmem_store = 1'b1;
   end
   if (c_instr_c_swsp_s2) begin
      c_dmem_store = 1'b1;
   end
end
always_comb begin
   c_dmem_load = 1'b0;
   if (c_instr_i_lb_s2) begin
      c_dmem_load = 1'b1;
   end
   if (c_instr_i_lh_s2) begin
      c_dmem_load = 1'b1;
   end
   if (c_instr_i_lw_s2) begin
      c_dmem_load = 1'b1;
   end
   if (c_instr_i_lbu_s2) begin
      c_dmem_load = 1'b1;
   end
   if (c_instr_i_lhu_s2) begin
      c_dmem_load = 1'b1;
   end
   if (c_instr_c_lw_s2) begin
      c_dmem_load = 1'b1;
   end
   if (c_instr_c_lwsp_s2) begin
      c_dmem_load = 1'b1;
   end
end
always_comb begin
   c_rf_write = 1'b0;
   if (c_instr_i_lui_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_auipc_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_jal_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_jalr_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_lb_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_lh_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_lw_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_lbu_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_lhu_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_addi_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_slti_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_sltiu_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_xori_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_ori_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_andi_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_slli_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_srli_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_srai_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_add_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_sub_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_sll_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_slt_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_sltu_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_xor_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_srl_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_sra_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_or_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_and_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_i_fence_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_mul_s2) begin
      if (c_mc_1) begin
         c_rf_write = 1'b1;
      end
   end
   if (c_div_rem_s2) begin
      if (c_mc_0) begin
         if (c_cond_beq) begin
            c_rf_write = 1'b1;
         end
         else begin
            if (c_divident_lesser_divisor) begin
               c_rf_write = 1'b1;
            end
         end
      end
      else begin
         if (c_mc_1) begin
            c_rf_write = 1'b1;
         end
      end
   end
   if (c_instr_c_addi4sp_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_c_lw_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_c_addi_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_c_jal_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_c_li_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_c_lui_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_c_addi16sp_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_c_srli_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_c_srai_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_c_andi_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_c_sub_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_c_xor_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_c_or_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_c_and_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_c_slli_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_c_lwsp_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_c_mv_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_c_jalr_s2) begin
      c_rf_write = 1'b1;
   end
   if (c_instr_c_add_s2) begin
      c_rf_write = 1'b1;
   end
end
assign c_less = (less_result [0] == 1'b1);
assign c_cond_beq = (rs1_dato == rs2_dato);
always_comb begin
   c_pipe_invalid = 1'b0;
   if (c_instr_i_jal_s2) begin
      c_pipe_invalid = 1'b1;
   end
   if (c_instr_i_jalr_s2) begin
      c_pipe_invalid = 1'b1;
   end
   if (c_instr_i_beq_s2) begin
      if (c_cond_beq) begin
         c_pipe_invalid = 1'b1;
      end
   end
   if (c_instr_i_bne_s2) begin
      if (!(c_cond_beq)) begin
         c_pipe_invalid = 1'b1;
      end
   end
   if (c_instr_i_blt_s2) begin
      if (c_less) begin
         c_pipe_invalid = 1'b1;
      end
   end
   if (c_instr_i_bge_s2) begin
      if (!(c_less)) begin
         c_pipe_invalid = 1'b1;
      end
   end
   if (c_instr_i_bltu_s2) begin
      if (c_less) begin
         c_pipe_invalid = 1'b1;
      end
   end
   if (c_instr_i_bgeu_s2) begin
      if (!(c_less)) begin
         c_pipe_invalid = 1'b1;
      end
   end
   if (c_instr_c_jal_s2) begin
      c_pipe_invalid = 1'b1;
   end
   if (c_instr_c_j_s2) begin
      c_pipe_invalid = 1'b1;
   end
   if (c_instr_c_beqz_s2) begin
      if (c_cond_beqz_c) begin
         c_pipe_invalid = 1'b1;
      end
   end
   if (c_instr_c_bnez_s2) begin
      if (c_cond_bnez_c) begin
         c_pipe_invalid = 1'b1;
      end
   end
   if (c_instr_c_jr_s2) begin
      c_pipe_invalid = 1'b1;
   end
   if (c_instr_c_jalr_s2) begin
      c_pipe_invalid = 1'b1;
   end
end
always_comb begin
   c_div_rem_non_trivial = 1'b0;
   if (!(c_cond_beq)) begin
      if (!(c_divident_lesser_divisor)) begin
         if (c_instr_m_div_s2) begin
            c_div_rem_non_trivial = 1'b1;
         end
         else begin
            if (c_instr_m_divu_s2) begin
               c_div_rem_non_trivial = 1'b1;
            end
            else begin
               if (c_instr_m_rem_s2) begin
                  c_div_rem_non_trivial = 1'b1;
               end
               else begin
                  if (c_instr_m_remu_s2) begin
                     c_div_rem_non_trivial = 1'b1;
                  end
               end
            end
         end
      end
   end
end
assign c_mc_3 = (mc == 3);
assign c_mc_2 = (mc == 2);
assign c_mc_1 = (mc == 1);
assign c_mc_0 = (mc == 0);
assign c_wrth_rs2 = ((rd_addr == rs2_addr) & (rd_addr != 0));
assign c_wrth_rs1 = ((rd_addr == rs1_addr) & (rd_addr != 0));
assign c_pv_2 = (pv == 2);
assign c_pv_1 = (pv == 1);
assign c_pv_0 = (pv == 0);
assign c_instr_i = (instr [1 : 0] == 2'b11);

//------------------- Submodule(s):
RV32IMC_3P_RF i_rf (
	.c_rf_write(c_rf_write),
	.rd_dati(rd_dati),
	.rd_addr(rd_addr),
	.rs2_addr(rs2_addr),
	.rs2_dato_async(rs2_dato_async),
	.rs1_addr(rs1_addr),
	.rs1_dato_async(rs1_dato_async),
	.clk(clk));
endmodule