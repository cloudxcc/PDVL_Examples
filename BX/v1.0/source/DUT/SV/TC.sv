module TC (
   input c_sys_rst,
   output [10 - 1 : 0] pc_set,
   output [2 : 0] fifo_0,
   output c_thread_pipe_valid,
   output [6 : 0] thread_pipe_valid,
   output c_pc_pass_current,
   output c_pc_pass_fifo_0,
   output c_pc_pass_set,
   output [2 : 0] tid_rd1,
   output [2 : 0] tid_wr,
   input ic0_c_axi_mst_wr_valid,
   input ic0_c_axi_mst_rd_valid,
   output ic0_c_axi_slv_rd_ready_2,
   output [31 : 0] ic0_axi_slv_rd_data_2,
   input [31 : 0] ic0_axi_mst_wr_data,
   input [31 : 0] ic0_axi_mst_wr_addr,
   input [31 : 0] ic0_axi_mst_rd_addr,
   input clk);

//------------------- Register declaration(s):
reg  [0 : 0] fifo_level;
reg  [2 : 0] fifo [0 : 0];
reg  [10 - 1 : 0] pc_set_c6;
reg  [10 - 1 : 0] pc_set_c5;
reg  [7 : 0] tid_active;
reg  [6 : 0] thread_pipe_valid;
reg  [2 : 0] tid_wr;
reg  [2 : 0] tid_rd5;
reg  [2 : 0] tid_rd4;
reg  [2 : 0] tid_rd3;
reg  [2 : 0] tid_rd2;
reg  [2 : 0] tid_rd1;
reg  [2 : 0] tid_rd0;

//------------------- Procedural register declaration(s):
reg  [2 : 0] fifo_0;
reg  [3 : 0] tid_next_avail;
reg  [10 - 1 : 0] pc_set;
reg  [31 : 0] slv_rd_data;
reg  [31 : 0] slv_rd_addr;
reg  [31 : 0] slv_wr_data;
reg  [11 : 0] slv_wr_addr;
reg  [31 : 0] ic0_axi_slv_rd_data_2;
reg  [31 : 0] ic0_axi_slv_rd_addr;

//------------------- Condition declaration(s):
reg c_tc_kill_c4;
reg c_tc_kill_c6;
reg c_tc_kill_c5;
reg c_tc_start_c4;
reg c_tc_start_c6;
reg c_tc_start_c5;
reg c_fifo_not_empty;
reg c_thread_pipe_valid;
reg c_tc_kill;
reg c_tc_start;
reg c_pc_pass_set;
reg c_pc_pass_fifo_0;
reg c_pc_pass_current;
reg c_slv_rd_ready;
reg c_slv_rd;
reg c_slv_wr;
reg ic0_c_axi_slv_wr_valid;
reg ic0_c_axi_slv_rd_ready_2;
reg ic0_c_axi_slv_rd_valid;

//------------------- Register assignment(s):
always_ff @ (posedge clk or posedge c_sys_rst) begin
   if (c_sys_rst) begin
      fifo_level <= 0;
   end
   else begin
      if (c_thread_pipe_valid) begin
         if (c_tc_start_c6) begin
            fifo_level <= fifo_level + 1;
         end
      end
      else begin
         if (c_fifo_not_empty) begin
            fifo_level <= fifo_level - 1;
         end
      end
   end
end
always_ff @ (posedge clk) begin
   if (c_thread_pipe_valid) begin
      if (c_tc_start_c6) begin
         fifo [fifo_level] <= tid_wr;
      end
      else begin
         if (!(c_tc_kill_c6)) begin
            if (c_fifo_not_empty) begin
               fifo [fifo_level - 1] <= tid_wr;
            end
         end
      end
   end
end
always_ff @ (posedge clk) begin
   pc_set_c6 <= pc_set_c5;
end
always_ff @ (posedge clk) begin
   pc_set_c5 <= slv_wr_data;
end
always_ff @ (posedge clk or posedge c_sys_rst) begin
   if (c_sys_rst) begin
      tid_active <= 1;
   end
   else begin
      if (c_thread_pipe_valid) begin
         if (c_tc_start_c6) begin
            tid_active [tid_next_avail] <= 1'b1;
         end
         else begin
            if (c_tc_kill_c6) begin
               tid_active [tid_wr] <= 1'b0;
            end
         end
      end
   end
end
always_ff @ (posedge clk or posedge c_sys_rst) begin
   if (c_sys_rst) begin
      thread_pipe_valid <= 7'h01;
   end
   else begin
      if (c_thread_pipe_valid) begin
         if (c_tc_start_c6) begin
            thread_pipe_valid <= {thread_pipe_valid [5 : 0], thread_pipe_valid [6]};
         end
         else begin
            if (c_tc_kill_c6) begin
               thread_pipe_valid <= {thread_pipe_valid [5 : 0], 1'b0};
            end
            else begin
               if (c_fifo_not_empty) begin
                  thread_pipe_valid <= {thread_pipe_valid [5 : 0], 1'b1};
               end
               else begin
                  thread_pipe_valid <= {thread_pipe_valid [5 : 0], thread_pipe_valid [6]};
               end
            end
         end
      end
      else begin
         if (c_fifo_not_empty) begin
            thread_pipe_valid <= {thread_pipe_valid [5 : 0], 1'b1};
         end
         else begin
            thread_pipe_valid <= {thread_pipe_valid [5 : 0], thread_pipe_valid [6]};
         end
      end
   end
end
always_ff @ (posedge clk or posedge c_sys_rst) begin
   if (c_sys_rst) begin
      tid_wr <= 0;
   end
   else begin
      if (c_thread_pipe_valid) begin
         if (c_tc_start_c6) begin
            tid_wr <= tid_rd5;
         end
         else begin
            if (c_tc_kill_c6) begin
               tid_wr <= tid_rd5;
            end
            else begin
               if (c_fifo_not_empty) begin
                  tid_wr <= tid_rd5;
               end
               else begin
                  tid_wr <= tid_rd5;
               end
            end
         end
      end
      else begin
         if (c_fifo_not_empty) begin
            tid_wr <= tid_rd5;
         end
         else begin
            tid_wr <= tid_rd5;
         end
      end
   end
end
always_ff @ (posedge clk or posedge c_sys_rst) begin
   if (c_sys_rst) begin
      tid_rd5 <= 0;
   end
   else begin
      if (c_thread_pipe_valid) begin
         if (c_tc_start_c6) begin
            tid_rd5 <= tid_rd4;
         end
         else begin
            if (c_tc_kill_c6) begin
               tid_rd5 <= tid_rd4;
            end
            else begin
               if (c_fifo_not_empty) begin
                  tid_rd5 <= tid_rd4;
               end
               else begin
                  tid_rd5 <= tid_rd4;
               end
            end
         end
      end
      else begin
         if (c_fifo_not_empty) begin
            tid_rd5 <= tid_rd4;
         end
         else begin
            tid_rd5 <= tid_rd4;
         end
      end
   end
end
always_ff @ (posedge clk or posedge c_sys_rst) begin
   if (c_sys_rst) begin
      tid_rd4 <= 0;
   end
   else begin
      if (c_thread_pipe_valid) begin
         if (c_tc_start_c6) begin
            tid_rd4 <= tid_rd3;
         end
         else begin
            if (c_tc_kill_c6) begin
               tid_rd4 <= tid_rd3;
            end
            else begin
               if (c_fifo_not_empty) begin
                  tid_rd4 <= tid_rd3;
               end
               else begin
                  tid_rd4 <= tid_rd3;
               end
            end
         end
      end
      else begin
         if (c_fifo_not_empty) begin
            tid_rd4 <= tid_rd3;
         end
         else begin
            tid_rd4 <= tid_rd3;
         end
      end
   end
end
always_ff @ (posedge clk or posedge c_sys_rst) begin
   if (c_sys_rst) begin
      tid_rd3 <= 0;
   end
   else begin
      if (c_thread_pipe_valid) begin
         if (c_tc_start_c6) begin
            tid_rd3 <= tid_rd2;
         end
         else begin
            if (c_tc_kill_c6) begin
               tid_rd3 <= tid_rd2;
            end
            else begin
               if (c_fifo_not_empty) begin
                  tid_rd3 <= tid_rd2;
               end
               else begin
                  tid_rd3 <= tid_rd2;
               end
            end
         end
      end
      else begin
         if (c_fifo_not_empty) begin
            tid_rd3 <= tid_rd2;
         end
         else begin
            tid_rd3 <= tid_rd2;
         end
      end
   end
end
always_ff @ (posedge clk or posedge c_sys_rst) begin
   if (c_sys_rst) begin
      tid_rd2 <= 0;
   end
   else begin
      if (c_thread_pipe_valid) begin
         if (c_tc_start_c6) begin
            tid_rd2 <= tid_rd1;
         end
         else begin
            if (c_tc_kill_c6) begin
               tid_rd2 <= tid_rd1;
            end
            else begin
               if (c_fifo_not_empty) begin
                  tid_rd2 <= tid_rd1;
               end
               else begin
                  tid_rd2 <= tid_rd1;
               end
            end
         end
      end
      else begin
         if (c_fifo_not_empty) begin
            tid_rd2 <= tid_rd1;
         end
         else begin
            tid_rd2 <= tid_rd1;
         end
      end
   end
end
always_ff @ (posedge clk or posedge c_sys_rst) begin
   if (c_sys_rst) begin
      tid_rd1 <= 0;
   end
   else begin
      if (c_thread_pipe_valid) begin
         if (c_tc_start_c6) begin
            tid_rd1 <= tid_rd0;
         end
         else begin
            if (c_tc_kill_c6) begin
               tid_rd1 <= tid_rd0;
            end
            else begin
               if (c_fifo_not_empty) begin
                  tid_rd1 <= tid_rd0;
               end
               else begin
                  tid_rd1 <= tid_rd0;
               end
            end
         end
      end
      else begin
         if (c_fifo_not_empty) begin
            tid_rd1 <= tid_rd0;
         end
         else begin
            tid_rd1 <= tid_rd0;
         end
      end
   end
end
always_ff @ (posedge clk or posedge c_sys_rst) begin
   if (c_sys_rst) begin
      tid_rd0 <= 0;
   end
   else begin
      if (c_thread_pipe_valid) begin
         if (c_tc_start_c6) begin
            tid_rd0 <= tid_next_avail;
         end
         else begin
            if (c_tc_kill_c6) begin
               tid_rd0 <= 3'h0;
            end
            else begin
               if (c_fifo_not_empty) begin
                  tid_rd0 <= fifo [0];
               end
               else begin
                  tid_rd0 <= tid_wr;
               end
            end
         end
      end
      else begin
         if (c_fifo_not_empty) begin
            tid_rd0 <= fifo [0];
         end
         else begin
            tid_rd0 <= tid_wr;
         end
      end
   end
end

//------------------- Item assignment(s):
assign fifo_0 = fifo [0];
assign tid_next_avail = !tid_active [0] ? 0 : !tid_active [1] ? 1 : !tid_active [2] ? 2 : !tid_active [3] ? 3 : !tid_active [4] ? 4 : !tid_active [5] ? 5 : !tid_active [6] ? 6 : 7;
assign pc_set = pc_set_c6;
assign slv_rd_data = 0;
assign slv_rd_addr = ic0_axi_slv_rd_addr;
assign slv_wr_data = ic0_axi_mst_wr_data;
assign slv_wr_addr = ic0_axi_mst_wr_addr;
assign ic0_axi_slv_rd_data_2 = slv_rd_data;
assign ic0_axi_slv_rd_addr = ic0_axi_mst_rd_addr;

//------------------- Condition assignment(s):
assign c_tc_kill_c4 = (c_tc_kill);
always_ff @ (posedge clk) begin
   c_tc_kill_c6 <= c_tc_kill_c5;
end
always_ff @ (posedge clk) begin
   c_tc_kill_c5 <= c_tc_kill_c4;
end
assign c_tc_start_c4 = (c_tc_start);
always_ff @ (posedge clk) begin
   c_tc_start_c6 <= c_tc_start_c5;
end
always_ff @ (posedge clk) begin
   c_tc_start_c5 <= c_tc_start_c4;
end
assign c_fifo_not_empty = (fifo_level != 0);
assign c_thread_pipe_valid = (thread_pipe_valid [6] == 1'b1);
assign c_tc_kill = (c_slv_wr & (slv_wr_addr [11 : 0] == 12'h404));
assign c_tc_start = (c_slv_wr & (slv_wr_addr [11 : 0] == 12'h400));
always_comb begin
   c_pc_pass_set = 1'b0;
   c_pc_pass_set = 1'b1;
end
always_comb begin
   c_pc_pass_fifo_0 = 1'b0;
   if (c_thread_pipe_valid) begin
      if (!(c_tc_start_c6)) begin
         if (!(c_tc_kill_c6)) begin
            if (c_fifo_not_empty) begin
               c_pc_pass_fifo_0 = 1'b1;
            end
         end
      end
   end
   else begin
      if (c_fifo_not_empty) begin
         c_pc_pass_fifo_0 = 1'b1;
      end
   end
end
assign c_pc_pass_current = ((c_thread_pipe_valid) & (!(c_tc_start_c6)) & (!(c_tc_kill_c6)) & (!(c_fifo_not_empty)));
assign c_slv_rd_ready = 1'b0;
assign c_slv_rd = ic0_c_axi_slv_rd_valid;
assign c_slv_wr = ic0_c_axi_slv_wr_valid;
assign ic0_c_axi_slv_wr_valid = (ic0_c_axi_mst_wr_valid);
assign ic0_c_axi_slv_rd_ready_2 = c_slv_rd_ready;
assign ic0_c_axi_slv_rd_valid = (ic0_c_axi_mst_rd_valid);
endmodule