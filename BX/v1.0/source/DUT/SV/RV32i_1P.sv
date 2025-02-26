module RV32i_1P (
   input c_sys_rst,
   input [31 : 0] instr_reg_c1,
   input [10 - 1 : 0] pc_set,
   output [31 : 0] pc_read_c0,
   input [2 : 0] fifo_0,
   input c_thread_pipe_valid,
   input [6 : 0] thread_pipe_valid,
   input c_pc_pass_current,
   input c_pc_pass_fifo_0,
   input c_pc_pass_set,
   input [2 : 0] tid_rd1,
   input [2 : 0] tid_wr,
   output ic0_c_axi_mst_wr_valid,
   output ic0_c_axi_mst_rd_valid,
   input ic0_c_axi_slv_rd_ready_2,
   input ic0_c_axi_slv_rd_ready_1,
   input ic0_c_axi_slv_rd_ready_0,
   input [31 : 0] ic0_axi_slv_rd_data_2,
   input [31 : 0] ic0_axi_slv_rd_data_1,
   input [31 : 0] ic0_axi_slv_rd_data_0,
   output [3 : 0] ic0_axi_mst_wr_strobe,
   output [31 : 0] ic0_axi_mst_wr_data,
   output [31 : 0] ic0_axi_mst_wr_addr,
   output [31 : 0] ic0_axi_mst_rd_addr,
   input clk);

//------------------- Parameter(s):
parameter PC_LEN = 10;

//------------------- Register declaration(s):
reg  [2 : 0] funct3_i_c5;
reg  [2 : 0] funct3_i_c4;
reg  [2 : 0] funct3_i_c3;
reg  [31 : 0] pc_i_add_b_c5;
reg  [31 : 0] pc_i_add_b_c4;
reg  [31 : 0] pc_i_add_b_c3;
reg  [31 : 0] pc_i_add_a_c5;
reg  [31 : 0] pc_i_add_a_c4;
reg  [31 : 0] pc_i_add_a_c3;
reg equal_3_c4;
reg equal_2_c4;
reg equal_1_c4;
reg equal_0_c4;
reg less_3_c4;
reg less_2_c4;
reg less_1_c4;
reg less_0_c4;
reg  [32 : 0] i_less_b_c4;
reg  [32 : 0] i_less_b_c3;
reg  [32 : 0] i_less_a_c4;
reg  [32 : 0] i_less_a_c3;
reg  [4 : 0] dp_in_b_shamt_c4;
reg  [4 : 0] dp_in_b_shamt_c3;
reg  [31 : 0] dp_out_reg_c6;
reg  [31 : 0] dp_out_reg_c5;
reg  [31 : 0] dp_out_reg_c4;
reg  [10 : 0] dp_add_1_c6;
reg  [10 : 0] dp_add_1_c5;
reg  [12 : 0] dp_add_0_c6;
reg  [12 : 0] dp_add_0_c5;
reg  [12 : 0] dp_add_0_c4;
reg  [32 : 0] dp_in_b_c5;
reg  [32 : 0] dp_in_b_c4;
reg  [32 : 0] dp_in_b_c3;
reg  [32 : 0] dp_in_a_c5;
reg  [32 : 0] dp_in_a_c4;
reg  [32 : 0] dp_in_a_c3;
reg  [31 : 0] pc_next_c6;
reg  [31 : 0] pc_read_c2;
reg  [31 : 0] pc_read_c1;
reg  [31 : 0] rs2_dato_c3;
reg  [32 : 0] rs1_dato_c3;
reg  [5 - 1 : 0] rs2_addr_c2;
reg  [5 - 1 : 0] rs1_addr_c2;
reg  [8 - 1 : 0] rd_addr_c6;
reg  [8 - 1 : 0] rd_addr_c5;
reg  [8 - 1 : 0] rd_addr_c4;
reg  [8 - 1 : 0] rd_addr_c3;
reg  [8 - 1 : 0] rd_addr_c2;
reg  [31 : 0] instr_reg_c2;
reg  [PC_LEN - 1 : 0] pc_pass;
reg  [PC_LEN - 1 : 0] pc [7 : 0];
reg  [31 : 0] dmem_load_data_c6;
reg  [3 : 0] mst_strobe_c4;
reg c_s_and_c3;
reg c_s_ori_c3;
reg c_s_lui_c3;
reg c_s_xor_c3;
reg c_s_or_c3;
reg c_s_3_add_c1;
reg c_s_andi_c3;
reg c_s_xori_c3;
reg c_s_3_sub_c1;

//------------------- Procedural register declaration(s):
reg  [31 : 0] rd_dati;
reg  [4 : 0] rs2_addr;
reg  [4 : 0] rs1_addr;
reg  [31 : 0] dmem_load_data;
reg  [2 : 0] dmem_width;
reg  [31 : 0] dmem_store_data;
reg  [32 : 0] dmem_addr;
reg  [11 : 0] imm_11;
reg  [31 : 0] offset_20;
reg  [31 : 0] i_immediate_c2;
reg  [4 : 0] shamt;
reg  [31 : 0] pc_dp_add_c5;
reg  [31 : 0] pc_i_add_b_in;
reg  [31 : 0] pc_i_add_a_in;
reg less_result_0_c4;
reg uless_c4;
reg  [31 : 0] dp_add;
reg  [10 : 0] dp_add_2;
reg  [19 : 0] dp_add_1p;
reg  [32 : 0] dp_in_b;
reg  [PC_LEN - 1 : 0] pc_next;
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
reg  [31 : 0] rs2_dato_c2;
reg  [31 : 0] rs1_dato_c2;
reg  [8 - 1 : 0] rs2_addr_c1;
reg  [8 - 1 : 0] rs1_addr_c1;
reg  [31 : 0] pc_read_c0;
reg  [31 : 0] mst_rd_addr;
reg  [31 : 0] mst_strobe;
reg  [31 : 0] mst_wr_data;
reg  [31 : 0] mst_wr_addr;
reg  [31 : 0] axi_mst_rd_data;
reg  [3 : 0] ic0_axi_mst_wr_strobe;
reg  [31 : 0] ic0_axi_mst_wr_data;
reg  [31 : 0] ic0_axi_mst_wr_addr;
reg  [31 : 0] ic0_axi_mst_rd_data;
reg  [31 : 0] ic0_axi_mst_rd_addr;

//------------------- Condition declaration(s):
reg c_instr_i_bgeu_c2;
reg c_instr_i_bltu_c2;
reg c_instr_i_bge_c2;
reg c_instr_i_blt_c2;
reg c_instr_i_bne_c2;
reg c_instr_i_beq_c2;
reg c_instr_i_and_c2;
reg c_instr_i_or_c2;
reg c_instr_i_sra_c2;
reg c_instr_i_srl_c2;
reg c_instr_i_xor_c2;
reg c_instr_i_sltu_c2;
reg c_instr_i_slt_c2;
reg c_instr_i_sll_c2;
reg c_instr_i_sub_c2;
reg c_instr_i_add_c2;
reg c_instr_i_shift_c2;
reg c_instr_i_store_c2;
reg c_instr_i_andi_c2;
reg c_instr_i_ori_c2;
reg c_instr_i_srai_c2;
reg c_instr_i_srli_c2;
reg c_instr_i_xori_c2;
reg c_instr_i_sltiu_c2;
reg c_instr_i_slti_c2;
reg c_instr_i_slli_c2;
reg c_instr_i_addi_c2;
reg c_instr_i_load_c2;
reg c_instr_i_jalr_c2;
reg c_instr_i_jal_c2;
reg c_instr_i_auipc_c2;
reg c_instr_i_lui_c2;
reg c_dmem_store_c2;
reg c_dmem_store_c4;
reg c_dmem_store_c3;
reg c_dmem_load_c2;
reg c_dmem_load_c5;
reg c_dmem_load_c4;
reg c_dmem_load_c3;
reg c_bge_c2;
reg c_bge_c5;
reg c_bge_c4;
reg c_bge_c3;
reg c_blt_c2;
reg c_blt_c5;
reg c_blt_c4;
reg c_blt_c3;
reg c_bne_c2;
reg c_bne_c5;
reg c_bne_c4;
reg c_bne_c3;
reg c_beq_c2;
reg c_beq_c5;
reg c_beq_c4;
reg c_beq_c3;
reg c_instr_i_j_c2;
reg c_instr_i_j_c5;
reg c_instr_i_j_c4;
reg c_instr_i_j_c3;
reg c_s_xor_c2;
reg c_s_or_c2;
reg c_s_and_c2;
reg c_s_3_sub_c0;
reg c_sub_c2;
reg c_sub_c3;
reg c_s_3_add_c0;
reg c_s_lui_c2;
reg c_dp_out_sra_result_c2;
reg c_dp_out_sra_result_c4;
reg c_dp_out_sra_result_c3;
reg c_dp_out_shl_result_c2;
reg c_dp_out_shl_result_c4;
reg c_dp_out_shl_result_c3;
reg c_s_xori_c2;
reg c_s_ori_c2;
reg c_s_andi_c2;
reg c_dp_out_less_c2;
reg c_dp_out_less_c4;
reg c_dp_out_less_c3;
reg c_dp_out_add_c2;
reg c_dp_out_add_c5;
reg c_dp_out_add_c4;
reg c_dp_out_add_c3;
reg c_rf_write_c2;
reg c_rf_write_c5;
reg c_rf_write_c4;
reg c_rf_write_c3;
reg c_rf_wr;
reg c_dmem_load_lhu_c5;
reg c_dmem_load_lhu_c6;
reg c_dmem_load_lbu_c5;
reg c_dmem_load_lbu_c6;
reg c_dmem_load_lw_c5;
reg c_dmem_load_lw_c6;
reg c_dmem_load_lh_c5;
reg c_dmem_load_lh_c6;
reg c_dmem_load_lb_c5;
reg c_dmem_load_lb_c6;
reg c_rf_write;
reg c_dmem_load_lhu;
reg c_dmem_load_lbu;
reg c_dmem_load_lw;
reg c_dmem_load_lh;
reg c_dmem_load_lb;
reg c_less_c5;
reg c_equal_c5;
reg c_equal_c4;
reg c_equal;
reg c_pc_next_pc_branch;
reg c_pc_next_pc4;
reg c_rf_write_c6;
reg c_thread_valid_c3;
reg c_thread_valid_c4;
reg c_thread_valid_c5;
reg c_thread_valid_c6;
reg c_dmem_width_2;
reg c_dmem_width_1;
reg c_dmem_width_0;
reg c_mst_rd;
reg c_mst_wr;
reg ic0_c_axi_mst_wr_valid;
reg ic0_c_axi_mst_rd_valid;

//------------------- Wire declaration(s):
wire [31 : 0] rs2_dato_reg_c2;
wire [31 : 0] rs1_dato_reg_c2;

//------------------- Register assignment(s):
always_ff @ (posedge clk) begin
   funct3_i_c5 <= funct3_i_c4;
end
always_ff @ (posedge clk) begin
   funct3_i_c4 <= funct3_i_c3;
end
always_ff @ (posedge clk) begin
   funct3_i_c3 <= funct3_i;
end
always_ff @ (posedge clk) begin
   pc_i_add_b_c5 <= pc_i_add_b_c4;
end
always_ff @ (posedge clk) begin
   pc_i_add_b_c4 <= pc_i_add_b_c3;
end
always_ff @ (posedge clk) begin
   pc_i_add_b_c3 <= {{19 {b_type [11]}}, b_type, 1'b0};
   if (c_instr_i_jal_c2) begin
      pc_i_add_b_c3 <= offset_20;
   end
   if (c_instr_i_jalr_c2) begin
      pc_i_add_b_c3 <= imm_11;
   end
end
always_ff @ (posedge clk) begin
   pc_i_add_a_c5 <= pc_i_add_a_c4;
end
always_ff @ (posedge clk) begin
   pc_i_add_a_c4 <= pc_i_add_a_c3;
end
always_ff @ (posedge clk) begin
   pc_i_add_a_c3 <= pc_read_c2;
   if (c_instr_i_jal_c2) begin
      pc_i_add_a_c3 <= pc_read_c2;
   end
   if (c_instr_i_jalr_c2) begin
      pc_i_add_a_c3 <= rs1_dato_c2;
   end
end
always_ff @ (posedge clk) begin
   equal_3_c4 <= i_less_a_c3 [31 : 24] == i_less_b_c3 [31 : 24];
end
always_ff @ (posedge clk) begin
   equal_2_c4 <= i_less_a_c3 [23 : 16] == i_less_b_c3 [23 : 16];
end
always_ff @ (posedge clk) begin
   equal_1_c4 <= i_less_a_c3 [15 : 8] == i_less_b_c3 [15 : 8];
end
always_ff @ (posedge clk) begin
   equal_0_c4 <= i_less_a_c3 [7 : 0] == i_less_b_c3 [7 : 0];
end
always_ff @ (posedge clk) begin
   less_3_c4 <= i_less_a_c3 [31 : 24] < i_less_b_c3 [31 : 24];
end
always_ff @ (posedge clk) begin
   less_2_c4 <= i_less_a_c3 [23 : 16] < i_less_b_c3 [23 : 16];
end
always_ff @ (posedge clk) begin
   less_1_c4 <= i_less_a_c3 [15 : 8] < i_less_b_c3 [15 : 8];
end
always_ff @ (posedge clk) begin
   less_0_c4 <= i_less_a_c3 [7 : 0] < i_less_b_c3 [7 : 0];
end
always_ff @ (posedge clk) begin
   i_less_b_c4 <= i_less_b_c3;
end
always_ff @ (posedge clk) begin
   i_less_b_c3 <= {rs2_dato_c2 [31], rs2_dato_c2};
   if (c_instr_i_slti_c2) begin
      i_less_b_c3 <= {i_immediate [31], i_immediate};
   end
   if (c_instr_i_sltiu_c2) begin
      i_less_b_c3 <= {1'b0, i_immediate};
   end
   if (c_instr_i_beq_c2) begin
      i_less_b_c3 <= {1'b0, rs2_dato_c2};
   end
   if (c_instr_i_bne_c2) begin
      i_less_b_c3 <= {1'b0, rs2_dato_c2};
   end
   if (c_instr_i_bltu_c2) begin
      i_less_b_c3 <= {1'b0, rs2_dato_c2};
   end
   if (c_instr_i_bgeu_c2) begin
      i_less_b_c3 <= {1'b0, rs2_dato_c2};
   end
end
always_ff @ (posedge clk) begin
   i_less_a_c4 <= i_less_a_c3;
end
always_ff @ (posedge clk) begin
   i_less_a_c3 <= {rs1_dato_c2 [31], rs1_dato_c2};
   if (c_instr_i_sltiu_c2) begin
      i_less_a_c3 <= {1'b0, rs1_dato_c2};
   end
   if (c_instr_i_beq_c2) begin
      i_less_a_c3 <= {1'b0, rs1_dato_c2};
   end
   if (c_instr_i_bne_c2) begin
      i_less_a_c3 <= {1'b0, rs1_dato_c2};
   end
   if (c_instr_i_bltu_c2) begin
      i_less_a_c3 <= {1'b0, rs1_dato_c2};
   end
   if (c_instr_i_bgeu_c2) begin
      i_less_a_c3 <= {1'b0, rs1_dato_c2};
   end
end
always_ff @ (posedge clk) begin
   dp_in_b_shamt_c4 <= dp_in_b_shamt_c3;
end
always_ff @ (posedge clk) begin
   if (c_instr_i_shift_c2) begin
      dp_in_b_shamt_c3 [4 : 0] <= rs2_dato_c2 [4 : 0];
   end
   else begin
      dp_in_b_shamt_c3 [4 : 0] <= shamt;
   end
end
always_ff @ (posedge clk) begin
   dp_out_reg_c6 <= dp_out_reg_c5;
   if (c_dp_out_add_c5) begin
      dp_out_reg_c6 <= {dp_add_2 [9 : 0], dp_add_1_c5 [9 : 0], dp_add_0_c5 [11 : 0]};
   end
end
always_ff @ (posedge clk) begin
   dp_out_reg_c5 <= dp_out_reg_c4;
   if (c_dp_out_less_c4) begin
      dp_out_reg_c5 <= {{31 {1'b0}}, less_result_0_c4};
   end
   if (c_dp_out_shl_result_c4) begin
      dp_out_reg_c5 <= dp_in_a_c4 << {dp_in_b_shamt_c4 [4 : 3], 3'h0};
   end
   if (c_dp_out_sra_result_c4) begin
      dp_out_reg_c5 <= $signed (dp_in_a_c4) >>> {dp_in_b_shamt_c4 [4 : 3], 3'h0};
   end
end
always_ff @ (posedge clk) begin
   dp_out_reg_c4 <= rs2_dato_c3;
   if (c_s_andi_c3) begin
      dp_out_reg_c4 <= rs1_dato_c3 [31 : 0] & rs2_dato_c3;
   end
   if (c_s_ori_c3) begin
      dp_out_reg_c4 <= rs1_dato_c3 [31 : 0] | rs2_dato_c3;
   end
   if (c_s_xori_c3) begin
      dp_out_reg_c4 <= rs1_dato_c3 [31 : 0] ^ rs2_dato_c3;
   end
   if (c_s_lui_c3) begin
      dp_out_reg_c4 <= rs2_dato_c3;
   end
   if (c_s_and_c3) begin
      dp_out_reg_c4 <= rs1_dato_c3 [31 : 0] & rs2_dato_c3 [31 : 0];
   end
   if (c_s_or_c3) begin
      dp_out_reg_c4 <= rs1_dato_c3 [31 : 0] | rs2_dato_c3 [31 : 0];
   end
   if (c_s_xor_c3) begin
      dp_out_reg_c4 <= rs1_dato_c3 [31 : 0] ^ rs2_dato_c3 [31 : 0];
   end
end
always_ff @ (posedge clk) begin
   dp_add_1_c6 <= dp_add_1_c5;
end
always_ff @ (posedge clk) begin
   dp_add_1_c5 <= dp_in_a_c4 [21 : 12] + dp_in_b_c4 [21 : 12] + dp_add_0_c4 [12];
end
always_ff @ (posedge clk) begin
   dp_add_0_c6 <= dp_add_0_c5;
end
always_ff @ (posedge clk) begin
   dp_add_0_c5 <= dp_add_0_c4;
end
always_ff @ (posedge clk) begin
   dp_add_0_c4 <= dp_in_a_c3 [11 : 0] + dp_in_b [11 : 0] + c_sub_c3;
end
always_ff @ (posedge clk) begin
   dp_in_b_c5 <= dp_in_b_c4;
end
always_ff @ (posedge clk) begin
   dp_in_b_c4 <= dp_in_b_c3;
   if (c_s_3_add_c1) begin
      dp_in_b_c4 <= {1'bx, rs2_dato_c3};
   end
   if (c_s_3_sub_c1) begin
      dp_in_b_c4 <= {1'bx, ~rs2_dato_c3};
   end
end
always_ff @ (posedge clk) begin
   dp_in_b_c3 <= i_immediate_c2;
   if (c_instr_i_auipc_c2) begin
      dp_in_b_c3 [19 : 0] <= u_immediate [19 : 0];
   end
   if (c_instr_i_jal_c2) begin
      dp_in_b_c3 <= 4;
   end
   if (c_instr_i_jalr_c2) begin
      dp_in_b_c3 <= 4;
   end
   if (c_instr_i_store_c2) begin
      dp_in_b_c3 <= {{20 {s_type [11]}}, s_type};
   end
   if (c_instr_i_load_c2) begin
      dp_in_b_c3 <= {{20 {i_type [11]}}, i_type};
   end
end
always_ff @ (posedge clk) begin
   dp_in_a_c5 <= dp_in_a_c4;
end
always_ff @ (posedge clk) begin
   dp_in_a_c4 <= dp_in_a_c3;
   if (c_dp_out_shl_result_c3) begin
      dp_in_a_c4 <= rs1_dato_c3 << dp_in_b_shamt_c3 [2 : 0];
   end
   else begin
      if (c_dp_out_sra_result_c3) begin
         dp_in_a_c4 <= $signed (rs1_dato_c3) >>> (dp_in_b_shamt_c3 [2 : 0]);
      end
   end
end
always_ff @ (posedge clk) begin
   dp_in_a_c3 <= {1'bx, rs1_dato_c2};
   if (c_instr_i_auipc_c2) begin
      dp_in_a_c3 <= pc_read_c2;
   end
   if (c_instr_i_jal_c2) begin
      dp_in_a_c3 <= pc_read_c2;
   end
   if (c_instr_i_jalr_c2) begin
      dp_in_a_c3 <= pc_read_c2;
   end
end
always_ff @ (posedge clk) begin
   pc_next_c6 <= pc_next;
end
always_ff @ (posedge clk) begin
   pc_read_c2 <= pc_read_c1;
end
always_ff @ (posedge clk) begin
   pc_read_c1 <= pc_read_c0;
end
always_ff @ (posedge clk) begin
   rs2_dato_c3 <= rs2_dato_c2;
   if (c_instr_i_andi_c2) begin
      rs2_dato_c3 <= i_immediate;
   end
   if (c_instr_i_ori_c2) begin
      rs2_dato_c3 <= i_immediate;
   end
   if (c_instr_i_xori_c2) begin
      rs2_dato_c3 <= i_immediate;
   end
   if (c_instr_i_lui_c2) begin
      rs2_dato_c3 <= u_immediate;
   end
end
always_ff @ (posedge clk) begin
   if (c_instr_i_sra_c2) begin
      rs1_dato_c3 <= {rs1_dato_c2 [31], rs1_dato_c2};
   end
   else begin
      if (c_instr_i_srai_c2) begin
         rs1_dato_c3 <= {rs1_dato_c2 [31], rs1_dato_c2};
      end
      else begin
         rs1_dato_c3 <= {1'b0, rs1_dato_c2};
      end
   end
end
always_ff @ (posedge clk) begin
   rs2_addr_c2 <= instr_reg_c1 [24 : 20];
end
always_ff @ (posedge clk) begin
   rs1_addr_c2 <= instr_reg_c1 [19 : 15];
end
always_ff @ (posedge clk) begin
   rd_addr_c6 <= rd_addr_c5;
end
always_ff @ (posedge clk) begin
   rd_addr_c5 <= rd_addr_c4;
end
always_ff @ (posedge clk) begin
   rd_addr_c4 <= rd_addr_c3;
end
always_ff @ (posedge clk) begin
   rd_addr_c3 <= rd_addr_c2;
end
always_ff @ (posedge clk) begin
   rd_addr_c2 <= {tid_rd1, instr_reg_c1 [11 : 7]};
end
always_ff @ (posedge clk) begin
   instr_reg_c2 <= instr_reg_c1;
end
always_ff @ (posedge clk or posedge c_sys_rst) begin
   if (c_sys_rst) begin
      pc_pass <= 0;
   end
   else begin
      if (c_pc_pass_current) begin
         pc_pass <= pc_next_c6;
      end
      else begin
         if (c_pc_pass_fifo_0) begin
            pc_pass <= pc [fifo_0];
         end
         else begin
            if (c_pc_pass_set) begin
               pc_pass <= {10'h000, pc_set [10 - 2 : 0], 1'b0};
            end
         end
      end
   end
end
always_ff @ (posedge clk or posedge c_sys_rst) begin
   if (c_sys_rst) begin
      pc [0] <= 0;
      pc [1] <= 0;
      pc [2] <= 0;
      pc [3] <= 0;
      pc [4] <= 0;
      pc [5] <= 0;
      pc [6] <= 0;
      pc [7] <= 0;
   end
   else begin
      pc [tid_wr] <= pc_next_c6;
   end
end
always_ff @ (posedge clk) begin
   dmem_load_data_c6 <= ic0_axi_slv_rd_data_2 | ic0_axi_slv_rd_data_1 | ic0_axi_slv_rd_data_0;
end
always_ff @ (posedge clk) begin
   if (c_dmem_width_0) begin
      mst_strobe_c4 <= 4'b0001;
   end
   if (c_dmem_width_1) begin
      mst_strobe_c4 <= 4'b0011;
   end
   if (c_dmem_width_2) begin
      mst_strobe_c4 <= 4'b1111;
   end
end
always_ff @ (posedge clk) begin
   c_s_and_c3 <= c_s_and_c2;
end
always_ff @ (posedge clk) begin
   c_s_ori_c3 <= c_s_ori_c2;
end
always_ff @ (posedge clk) begin
   c_s_lui_c3 <= c_s_lui_c2;
end
always_ff @ (posedge clk) begin
   c_s_xor_c3 <= c_s_xor_c2;
end
always_ff @ (posedge clk) begin
   c_s_or_c3 <= c_s_or_c2;
end
always_ff @ (posedge clk) begin
   c_s_3_add_c1 <= c_s_3_add_c0;
end
always_ff @ (posedge clk) begin
   c_s_andi_c3 <= c_s_andi_c2;
end
always_ff @ (posedge clk) begin
   c_s_xori_c3 <= c_s_xori_c2;
end
always_ff @ (posedge clk) begin
   c_s_3_sub_c1 <= c_s_3_sub_c0;
end

//------------------- Item assignment(s):
always_comb begin
   rd_dati = 32'hxxxxxxxx;
   rd_dati = dp_out_reg_c6;
   if (c_dmem_load_lb_c6) begin
      rd_dati = {{24 {dmem_load_data_c6 [7]}}, dmem_load_data_c6 [7 : 0]};
   end
   if (c_dmem_load_lh_c6) begin
      rd_dati = {{16 {dmem_load_data_c6 [15]}}, dmem_load_data_c6 [15 : 0]};
   end
   if (c_dmem_load_lw_c6) begin
      rd_dati = dmem_load_data_c6;
   end
   if (c_dmem_load_lbu_c6) begin
      rd_dati = {{24 {1'b0}}, dmem_load_data_c6 [7 : 0]};
   end
   if (c_dmem_load_lhu_c6) begin
      rd_dati = {{16 {1'b0}}, dmem_load_data_c6 [15 : 0]};
   end
end
assign rs2_addr = rs2i;
assign rs1_addr = rs1i;
assign dmem_load_data = axi_mst_rd_data;
assign dmem_width = funct3_i_c3 [2 : 0];
assign dmem_store_data = dp_out_reg_c4;
assign dmem_addr = {dp_add_1p [19 : 4], dp_add_1p [3 : 0], dp_add_0_c4 [11 : 0]};
assign imm_11 = {{20 {instr_reg_c2 [31]}}, instr_reg_c2 [31 : 20]};
assign offset_20 = {{11 {j_type [19]}}, j_type, 1'b0};
assign i_immediate_c2 = {{20 {instr_reg_c2 [31]}}, instr_reg_c2 [31 : 20]};
assign shamt = instr_reg_c2 [24 : 20];
assign pc_dp_add_c5 = pc_i_add_a_in + pc_i_add_b_in;
always_comb begin
   pc_i_add_b_in = 32'hxxxxxxxx;
   pc_i_add_b_in = 4;
   if (c_beq_c5) begin
      if (c_equal_c5) begin
         pc_i_add_b_in = pc_i_add_b_c5;
      end
      else begin
         pc_i_add_b_in = 4;
      end
   end
   if (c_bne_c5) begin
      if (c_equal_c5) begin
         pc_i_add_b_in = 4;
      end
      else begin
         pc_i_add_b_in = pc_i_add_b_c5;
      end
   end
   if (c_blt_c5) begin
      if (c_less_c5) begin
         pc_i_add_b_in = pc_i_add_b_c5;
      end
      else begin
         pc_i_add_b_in = 4;
      end
   end
   if (c_bge_c5) begin
      if (c_less_c5) begin
         pc_i_add_b_in = 4;
      end
      else begin
         pc_i_add_b_in = pc_i_add_b_c5;
      end
   end
   if (c_instr_i_j_c5) begin
      pc_i_add_b_in = pc_i_add_b_c5;
   end
end
assign pc_i_add_a_in = pc_i_add_a_c5;
assign less_result_0_c4 = (~i_less_a_c4 [32] & i_less_b_c4 [32]) ? 1'b0 : (i_less_a_c4 [32] & ~i_less_b_c4 [32]) ? 1'b1 : uless_c4;
assign uless_c4 = less_3_c4 | (equal_3_c4 & less_2_c4) | (equal_3_c4 & equal_2_c4 & less_1_c4) | (equal_3_c4 & equal_2_c4 & equal_1_c4 & less_0_c4);
assign dp_add = {dp_add_2 [9 : 0], dp_add_1_c6 [9 : 0], dp_add_0_c6 [11 : 0]};
assign dp_add_2 = dp_in_a_c5 [31 : 22] + dp_in_b_c5 [31 : 22] + dp_add_1_c5 [10];
assign dp_add_1p = dp_in_a_c4 [31 : 12] + dp_in_b_c4 [31 : 12] + dp_add_0_c4 [12];
always_comb begin
   dp_in_b = dp_in_b_c3;
   if (c_s_3_add_c1) begin
      dp_in_b = {1'bx, rs2_dato_c3 [31 : 0]};
   end
   if (c_s_3_sub_c1) begin
      dp_in_b = {1'bx, ~rs2_dato_c3 [31 : 0]};
   end
end
assign pc_next = pc_dp_add_c5;
assign u_immediate = {instr_reg_c2 [31 : 12], 12'h000};
assign i_immediate = {{20 {instr_reg_c2 [31]}}, instr_reg_c2 [31 : 20]};
assign j_type = {instr_reg_c2 [31], instr_reg_c2 [19 : 12], instr_reg_c2 [20], instr_reg_c2 [30 : 21]};
assign b_type = {instr_reg_c2 [31], instr_reg_c2 [7], instr_reg_c2 [30 : 25], instr_reg_c2 [11 : 8]};
assign s_type = {instr_reg_c2 [31 : 25], instr_reg_c2 [11 : 7]};
assign i_type = instr_reg_c2 [31 : 20];
assign opcode_i = instr_reg_c2 [6 : 0];
assign rdi = instr_reg_c2 [11 : 7];
assign rs1i = instr_reg_c2 [19 : 15];
assign rs2i = instr_reg_c2 [24 : 20];
assign funct3_i = instr_reg_c2 [14 : 12];
assign funct7_i = instr_reg_c2 [31 : 25];
assign rs2_dato_c2 = (rs2_addr_c2 == 0) ? 0 : rs2_dato_reg_c2;
assign rs1_dato_c2 = (rs1_addr_c2 == 0) ? 0 : rs1_dato_reg_c2;
assign rs2_addr_c1 = {tid_rd1, instr_reg_c1 [24 : 20]};
assign rs1_addr_c1 = {tid_rd1, instr_reg_c1 [19 : 15]};
assign pc_read_c0 = pc_pass;
assign mst_rd_addr = dmem_addr;
assign mst_strobe = mst_strobe_c4;
assign mst_wr_data = dmem_store_data;
assign mst_wr_addr = dmem_addr;
assign axi_mst_rd_data = ic0_axi_mst_rd_data;
assign ic0_axi_mst_wr_strobe = mst_strobe;
assign ic0_axi_mst_wr_data = mst_wr_data;
assign ic0_axi_mst_wr_addr = mst_wr_addr;
always_comb begin
   if (ic0_c_axi_slv_rd_ready_2) begin
      ic0_axi_mst_rd_data = ic0_axi_slv_rd_data_2;
   end
   if (ic0_c_axi_slv_rd_ready_1) begin
      ic0_axi_mst_rd_data = ic0_axi_slv_rd_data_1;
   end
   if (ic0_c_axi_slv_rd_ready_0) begin
      ic0_axi_mst_rd_data = ic0_axi_slv_rd_data_0;
   end
end
assign ic0_axi_mst_rd_addr = mst_rd_addr;

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
assign c_instr_i_bgeu_c2 = ((c_cmp (opcode_i [6 : 2], 5'b11000)) & (c_cmp (funct3_i, 7)));
assign c_instr_i_bltu_c2 = ((c_cmp (opcode_i [6 : 2], 5'b11000)) & (c_cmp (funct3_i, 6)));
assign c_instr_i_bge_c2 = ((c_cmp (opcode_i [6 : 2], 5'b11000)) & (c_cmp (funct3_i, 5)));
assign c_instr_i_blt_c2 = ((c_cmp (opcode_i [6 : 2], 5'b11000)) & (c_cmp (funct3_i, 4)));
assign c_instr_i_bne_c2 = ((c_cmp (opcode_i [6 : 2], 5'b11000)) & (c_cmp (funct3_i, 1)));
assign c_instr_i_beq_c2 = ((c_cmp (opcode_i [6 : 2], 5'b11000)) & (c_cmp (funct3_i, 0)));
assign c_instr_i_and_c2 = ((c_cmp (opcode_i [6 : 2], 5'b01100)) & (c_cmp (funct3_i, 7)));
assign c_instr_i_or_c2 = ((c_cmp (opcode_i [6 : 2], 5'b01100)) & (c_cmp (funct3_i, 6)));
assign c_instr_i_sra_c2 = ((c_cmp (opcode_i [6 : 2], 5'b01100)) & (c_cmp (funct3_i, 5)) & (c_cmp (funct7_i [5], 1'b1)));
assign c_instr_i_srl_c2 = ((c_cmp (opcode_i [6 : 2], 5'b01100)) & (c_cmp (funct3_i, 5)) & (c_cmp (funct7_i [5], 0)));
assign c_instr_i_xor_c2 = ((c_cmp (opcode_i [6 : 2], 5'b01100)) & (c_cmp (funct3_i, 4)));
assign c_instr_i_sltu_c2 = ((c_cmp (opcode_i [6 : 2], 5'b01100)) & (c_cmp (funct3_i, 3)));
assign c_instr_i_slt_c2 = ((c_cmp (opcode_i [6 : 2], 5'b01100)) & (c_cmp (funct3_i, 2)));
assign c_instr_i_sll_c2 = ((c_cmp (opcode_i [6 : 2], 5'b01100)) & (c_cmp (funct3_i, 1)));
assign c_instr_i_sub_c2 = ((c_cmp (opcode_i [6 : 2], 5'b01100)) & (c_cmp (funct3_i, 0)) & (c_cmp (funct7_i [5], 1'b1)));
assign c_instr_i_add_c2 = ((c_cmp (opcode_i [6 : 2], 5'b01100)) & (c_cmp (funct3_i, 0)) & (c_cmp (funct7_i [5], 0)));
assign c_instr_i_shift_c2 = (c_cmp (opcode_i [6 : 2], 5'b01100));
assign c_instr_i_store_c2 = (c_cmp (opcode_i [6 : 2], 5'b01000));
assign c_instr_i_andi_c2 = ((c_cmp (opcode_i [6 : 2], 5'b00100)) & (c_cmp (funct3_i, 7)));
assign c_instr_i_ori_c2 = ((c_cmp (opcode_i [6 : 2], 5'b00100)) & (c_cmp (funct3_i, 6)));
assign c_instr_i_srai_c2 = ((c_cmp (opcode_i [6 : 2], 5'b00100)) & (c_cmp (funct3_i, 5)) & (c_cmp (funct7_i [5], 1'b1)));
assign c_instr_i_srli_c2 = ((c_cmp (opcode_i [6 : 2], 5'b00100)) & (c_cmp (funct3_i, 5)) & (c_cmp (funct7_i [5], 0)));
assign c_instr_i_xori_c2 = ((c_cmp (opcode_i [6 : 2], 5'b00100)) & (c_cmp (funct3_i, 4)));
assign c_instr_i_sltiu_c2 = ((c_cmp (opcode_i [6 : 2], 5'b00100)) & (c_cmp (funct3_i, 3)));
assign c_instr_i_slti_c2 = ((c_cmp (opcode_i [6 : 2], 5'b00100)) & (c_cmp (funct3_i, 2)));
assign c_instr_i_slli_c2 = ((c_cmp (opcode_i [6 : 2], 5'b00100)) & (c_cmp (funct3_i, 1)));
assign c_instr_i_addi_c2 = ((c_cmp (opcode_i [6 : 2], 5'b00100)) & (c_cmp (funct3_i, 0)));
assign c_instr_i_load_c2 = (c_cmp (opcode_i [6 : 2], 5'b00000));
assign c_instr_i_jalr_c2 = ((c_cmp (opcode_i [2 : 2], 1'b1)) & (c_cmp (opcode_i [6 : 6], 1'b1)) & (c_cmp (opcode_i [3 : 3], 1'b0)));
assign c_instr_i_jal_c2 = ((c_cmp (opcode_i [2 : 2], 1'b1)) & (c_cmp (opcode_i [6 : 6], 1'b1)) & (c_cmp (opcode_i [3 : 3], 1'b1)));
assign c_instr_i_auipc_c2 = ((c_cmp (opcode_i [2 : 2], 1'b1)) & (c_cmp (opcode_i [6 : 5], 2'b00)));
assign c_instr_i_lui_c2 = ((c_cmp (opcode_i [2 : 2], 1'b1)) & (c_cmp (opcode_i [6 : 5], 2'b01)));
assign c_dmem_store_c2 = (c_instr_i_store_c2);
always_ff @ (posedge clk) begin
   c_dmem_store_c4 <= c_dmem_store_c3;
end
always_ff @ (posedge clk) begin
   c_dmem_store_c3 <= c_dmem_store_c2;
end
assign c_dmem_load_c2 = (c_instr_i_load_c2);
always_ff @ (posedge clk) begin
   c_dmem_load_c5 <= c_dmem_load_c4;
end
always_ff @ (posedge clk) begin
   c_dmem_load_c4 <= c_dmem_load_c3;
end
always_ff @ (posedge clk) begin
   c_dmem_load_c3 <= c_dmem_load_c2;
end
always_comb begin
   c_bge_c2 = 1'b0;
   if (c_instr_i_bge_c2) begin
      c_bge_c2 = 1'b1;
   end
   if (c_instr_i_bgeu_c2) begin
      c_bge_c2 = 1'b1;
   end
end
always_ff @ (posedge clk) begin
   c_bge_c5 <= c_bge_c4;
end
always_ff @ (posedge clk) begin
   c_bge_c4 <= c_bge_c3;
end
always_ff @ (posedge clk) begin
   c_bge_c3 <= c_bge_c2;
end
always_comb begin
   c_blt_c2 = 1'b0;
   if (c_instr_i_blt_c2) begin
      c_blt_c2 = 1'b1;
   end
   if (c_instr_i_bltu_c2) begin
      c_blt_c2 = 1'b1;
   end
end
always_ff @ (posedge clk) begin
   c_blt_c5 <= c_blt_c4;
end
always_ff @ (posedge clk) begin
   c_blt_c4 <= c_blt_c3;
end
always_ff @ (posedge clk) begin
   c_blt_c3 <= c_blt_c2;
end
assign c_bne_c2 = (c_instr_i_bne_c2);
always_ff @ (posedge clk) begin
   c_bne_c5 <= c_bne_c4;
end
always_ff @ (posedge clk) begin
   c_bne_c4 <= c_bne_c3;
end
always_ff @ (posedge clk) begin
   c_bne_c3 <= c_bne_c2;
end
assign c_beq_c2 = (c_instr_i_beq_c2);
always_ff @ (posedge clk) begin
   c_beq_c5 <= c_beq_c4;
end
always_ff @ (posedge clk) begin
   c_beq_c4 <= c_beq_c3;
end
always_ff @ (posedge clk) begin
   c_beq_c3 <= c_beq_c2;
end
always_comb begin
   c_instr_i_j_c2 = 1'b0;
   if (c_instr_i_jal_c2) begin
      c_instr_i_j_c2 = 1'b1;
   end
   if (c_instr_i_jalr_c2) begin
      c_instr_i_j_c2 = 1'b1;
   end
end
always_ff @ (posedge clk) begin
   c_instr_i_j_c5 <= c_instr_i_j_c4;
end
always_ff @ (posedge clk) begin
   c_instr_i_j_c4 <= c_instr_i_j_c3;
end
always_ff @ (posedge clk) begin
   c_instr_i_j_c3 <= c_instr_i_j_c2;
end
assign c_s_xor_c2 = (c_instr_i_xor_c2);
assign c_s_or_c2 = (c_instr_i_or_c2);
assign c_s_and_c2 = (c_instr_i_and_c2);
assign c_s_3_sub_c0 = (c_instr_i_sub_c2);
assign c_sub_c2 = (c_instr_i_sub_c2);
always_ff @ (posedge clk) begin
   c_sub_c3 <= c_sub_c2;
end
assign c_s_3_add_c0 = (c_instr_i_add_c2);
assign c_s_lui_c2 = (c_instr_i_lui_c2);
always_comb begin
   c_dp_out_sra_result_c2 = 1'b0;
   if (c_instr_i_srli_c2) begin
      c_dp_out_sra_result_c2 = 1'b1;
   end
   if (c_instr_i_srai_c2) begin
      c_dp_out_sra_result_c2 = 1'b1;
   end
   if (c_instr_i_srl_c2) begin
      c_dp_out_sra_result_c2 = 1'b1;
   end
   if (c_instr_i_sra_c2) begin
      c_dp_out_sra_result_c2 = 1'b1;
   end
end
always_ff @ (posedge clk) begin
   c_dp_out_sra_result_c4 <= c_dp_out_sra_result_c3;
end
always_ff @ (posedge clk) begin
   c_dp_out_sra_result_c3 <= c_dp_out_sra_result_c2;
end
always_comb begin
   c_dp_out_shl_result_c2 = 1'b0;
   if (c_instr_i_slli_c2) begin
      c_dp_out_shl_result_c2 = 1'b1;
   end
   if (c_instr_i_sll_c2) begin
      c_dp_out_shl_result_c2 = 1'b1;
   end
end
always_ff @ (posedge clk) begin
   c_dp_out_shl_result_c4 <= c_dp_out_shl_result_c3;
end
always_ff @ (posedge clk) begin
   c_dp_out_shl_result_c3 <= c_dp_out_shl_result_c2;
end
assign c_s_xori_c2 = (c_instr_i_xori_c2);
assign c_s_ori_c2 = (c_instr_i_ori_c2);
assign c_s_andi_c2 = (c_instr_i_andi_c2);
always_comb begin
   c_dp_out_less_c2 = 1'b0;
   if (c_instr_i_slti_c2) begin
      c_dp_out_less_c2 = 1'b1;
   end
   if (c_instr_i_sltiu_c2) begin
      c_dp_out_less_c2 = 1'b1;
   end
   if (c_instr_i_slt_c2) begin
      c_dp_out_less_c2 = 1'b1;
   end
   if (c_instr_i_sltu_c2) begin
      c_dp_out_less_c2 = 1'b1;
   end
   if (c_instr_i_blt_c2) begin
      c_dp_out_less_c2 = 1'b1;
   end
   if (c_instr_i_bge_c2) begin
      c_dp_out_less_c2 = 1'b1;
   end
   if (c_instr_i_bltu_c2) begin
      c_dp_out_less_c2 = 1'b1;
   end
   if (c_instr_i_bgeu_c2) begin
      c_dp_out_less_c2 = 1'b1;
   end
end
always_ff @ (posedge clk) begin
   c_dp_out_less_c4 <= c_dp_out_less_c3;
end
always_ff @ (posedge clk) begin
   c_dp_out_less_c3 <= c_dp_out_less_c2;
end
always_comb begin
   c_dp_out_add_c2 = 1'b0;
   if (c_instr_i_addi_c2) begin
      c_dp_out_add_c2 = 1'b1;
   end
   if (c_instr_i_add_c2) begin
      c_dp_out_add_c2 = 1'b1;
   end
   if (c_instr_i_sub_c2) begin
      c_dp_out_add_c2 = 1'b1;
   end
   if (c_instr_i_jal_c2) begin
      c_dp_out_add_c2 = 1'b1;
   end
   if (c_instr_i_jalr_c2) begin
      c_dp_out_add_c2 = 1'b1;
   end
end
always_ff @ (posedge clk) begin
   c_dp_out_add_c5 <= c_dp_out_add_c4;
end
always_ff @ (posedge clk) begin
   c_dp_out_add_c4 <= c_dp_out_add_c3;
end
always_ff @ (posedge clk) begin
   c_dp_out_add_c3 <= c_dp_out_add_c2;
end
always_comb begin
   c_rf_write_c2 = 1'b0;
   if (c_instr_i_addi_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_slti_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_sltiu_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_andi_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_ori_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_xori_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_slli_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_srli_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_srai_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_lui_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_auipc_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_add_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_slt_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_sltu_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_sub_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_and_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_or_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_xor_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_sll_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_srl_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_sra_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_jal_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_jalr_c2) begin
      c_rf_write_c2 = 1'b1;
   end
   if (c_instr_i_load_c2) begin
      c_rf_write_c2 = 1'b1;
   end
end
always_ff @ (posedge clk) begin
   c_rf_write_c5 <= c_rf_write_c4;
end
always_ff @ (posedge clk) begin
   c_rf_write_c4 <= c_rf_write_c3;
end
always_ff @ (posedge clk) begin
   c_rf_write_c3 <= c_rf_write_c2;
end
assign c_rf_wr = ((c_rf_write_c6) & (c_thread_pipe_valid));
assign c_dmem_load_lhu_c5 = (c_dmem_load_lhu);
always_ff @ (posedge clk) begin
   c_dmem_load_lhu_c6 <= c_dmem_load_lhu_c5;
end
assign c_dmem_load_lbu_c5 = (c_dmem_load_lbu);
always_ff @ (posedge clk) begin
   c_dmem_load_lbu_c6 <= c_dmem_load_lbu_c5;
end
assign c_dmem_load_lw_c5 = (c_dmem_load_lw);
always_ff @ (posedge clk) begin
   c_dmem_load_lw_c6 <= c_dmem_load_lw_c5;
end
assign c_dmem_load_lh_c5 = (c_dmem_load_lh);
always_ff @ (posedge clk) begin
   c_dmem_load_lh_c6 <= c_dmem_load_lh_c5;
end
assign c_dmem_load_lb_c5 = (c_dmem_load_lb);
always_ff @ (posedge clk) begin
   c_dmem_load_lb_c6 <= c_dmem_load_lb_c5;
end
assign c_rf_write = 1'b0;
assign c_dmem_load_lhu = (c_dmem_load_c5 & (funct3_i_c5 == 3'h5));
assign c_dmem_load_lbu = (c_dmem_load_c5 & (funct3_i_c5 == 3'h4));
assign c_dmem_load_lw = (c_dmem_load_c5 & (funct3_i_c5 == 3'h2));
assign c_dmem_load_lh = (c_dmem_load_c5 & (funct3_i_c5 == 3'h1));
assign c_dmem_load_lb = (c_dmem_load_c5 & (funct3_i_c5 == 3'h0));
assign c_less_c5 = (dp_out_reg_c5 [0] == 1'b1);
always_ff @ (posedge clk) begin
   c_equal_c5 <= c_equal_c4;
end
assign c_equal_c4 = (c_equal);
assign c_equal = (equal_0_c4 & equal_1_c4 & equal_2_c4 & equal_3_c4);
assign c_pc_next_pc_branch = 1'b0;
assign c_pc_next_pc4 = 1'b0;
always_ff @ (posedge clk) begin
   c_rf_write_c6 <= c_rf_write_c5;
end
assign c_thread_valid_c3 = (thread_pipe_valid [3] == 1'b1);
assign c_thread_valid_c4 = (thread_pipe_valid [4] == 1'b1);
assign c_thread_valid_c5 = (thread_pipe_valid [5] == 1'b1);
assign c_thread_valid_c6 = (thread_pipe_valid [6] == 1'b1);
assign c_dmem_width_2 = (dmem_width [1 : 0] == 2'b10);
assign c_dmem_width_1 = (dmem_width [1 : 0] == 2'b01);
assign c_dmem_width_0 = (dmem_width [1 : 0] == 2'b00);
assign c_mst_rd = ((c_thread_valid_c4) & (c_dmem_load_c4));
assign c_mst_wr = ((c_thread_valid_c4) & (c_dmem_store_c4));
assign ic0_c_axi_mst_wr_valid = c_mst_wr;
assign ic0_c_axi_mst_rd_valid = c_mst_rd;

//------------------- Submodule(s):
RV32_1P_RF i_rf (
	.c_rf_wr(c_rf_wr),
	.rd_dati(rd_dati),
	.rd_addr_c6(rd_addr_c6),
	.rs2_addr_c1(rs2_addr_c1),
	.rs2_dato_reg_c2(rs2_dato_reg_c2),
	.rs1_addr_c1(rs1_addr_c1),
	.rs1_dato_reg_c2(rs1_dato_reg_c2),
	.clk(clk));
endmodule