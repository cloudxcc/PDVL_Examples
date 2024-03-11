module UART (
   input c_ex_rst,
   output uart_tx,
   input uart_rx,
   output c_user_rst,
   output ic1_c_axi_mst_wr_valid,
   output [31 : 0] ic1_axi_mst_wr_data,
   output [31 : 0] ic1_axi_mst_wr_addr,
   input ic0_c_axi_mst_wr_valid,
   input ic0_c_axi_mst_rd_valid,
   output ic0_c_axi_slv_rd_ready_3,
   output [31 : 0] ic0_axi_slv_rd_data_3,
   input [31 : 0] ic0_axi_mst_wr_data,
   input [31 : 0] ic0_axi_mst_wr_addr,
   input [31 : 0] ic0_axi_mst_rd_addr,
   input clk);

//------------------- Parameter(s):
parameter TX_PROT_STATE_WAIT = 3;
parameter TX_PROT_STATE_START = 2;
parameter TX_PROT_STATE_STOP = 1;
parameter TX_PROT_STATE_SHIFT = 0;
parameter RX_PROT_STATE_WAIT = 3;
parameter RX_PROT_STATE_START = 2;
parameter RX_PROT_STATE_STOP = 1;
parameter RX_PROT_STATE_SHIFT = 0;
parameter BYTE2BUS_STATE_EXEC = 7;
parameter BYTE2BUS_STATE_DAT_B3 = 6;
parameter BYTE2BUS_STATE_DAT_B2 = 5;
parameter BYTE2BUS_STATE_DAT_B1 = 4;
parameter BYTE2BUS_STATE_DAT_B0 = 3;
parameter BYTE2BUS_STATE_COM_MODE = 2;
parameter BYTE2BUS_STATE_ADD_B1 = 1;
parameter BYTE2BUS_STATE_ADD_B0 = 0;

//------------------- Register declaration(s):
reg  [1 : 0] tx_prot;
reg  [1 : 0] rx_prot;
reg  [2 : 0] byte2bus;
reg  [8 : 0] uart_tx_data;
reg uart_tx_com;
reg  [7 : 0] uart_rx_rec;
reg uart_rx_com;
reg user_rst;
reg  [31 : 0] mst_wr_data;
reg  [15 : 0] mst_wr_add;
reg uart_byte_received;
reg  [7 : 0] uart_rx_data;
reg  [31 : 0] uart_rx_baud;
reg rx_maj_dec;
reg  [2 : 0] uart_nrx_filtered;
reg  [7 : 0] uart_tx_baud;
reg uart_tx;

//------------------- Procedural register declaration(s):
reg  [31 : 0] slv_rd_data;
reg  [31 : 0] slv_rd_addr;
reg  [31 : 0] slv_wr_data;
reg  [31 : 0] slv_wr_addr;
reg  [31 : 0] ic1_axi_mst_wr_data;
reg  [31 : 0] ic1_axi_mst_wr_addr;
reg  [31 : 0] ic0_axi_slv_rd_data_3;
reg  [31 : 0] ic0_axi_slv_rd_addr;

//------------------- Condition declaration(s):
reg c_tx_send;
reg c_rx_com_rd;
reg c_rx_rec_rd;
reg c_tx_com_rd;
reg c_user_rst;
reg c_user_com_mode;
reg c_prog_mem;
reg c_user_rst_clr_val;
reg c_user_rst_set_val;
reg c_slv_rd_ready;
reg c_slv_rd_valid;
reg c_slv_wr;
reg c_mst_wr;
reg c_uart_rx_valid;
reg c_byte_received;
reg c_uart_rx_full;
reg c_uart_rx_half;
reg c_uart_rx_negedge;
reg c_uart_tx_valid;
reg c_trans;
reg c_byte_transmitted;
reg c_uart_tx_trig;
reg ic1_c_axi_mst_wr_valid;
reg ic0_c_axi_slv_wr_valid;
reg ic0_c_axi_slv_rd_ready_3;
reg ic0_c_axi_slv_rd_valid;

//------------------- Register assignment(s):
always_ff @ (posedge clk or posedge c_ex_rst) begin
   if (c_ex_rst) begin
      tx_prot <= TX_PROT_STATE_WAIT;
   end
   else begin
      unique if (tx_prot == TX_PROT_STATE_WAIT) begin
         if (c_trans) begin
            tx_prot <= TX_PROT_STATE_START;
         end
      end
      else if (tx_prot == TX_PROT_STATE_START) begin
         if (c_uart_tx_trig) begin
            tx_prot <= TX_PROT_STATE_SHIFT;
         end
      end
      else if (tx_prot == TX_PROT_STATE_SHIFT) begin
         if (c_byte_transmitted) begin
            tx_prot <= TX_PROT_STATE_STOP;
         end
      end
      else if (tx_prot == TX_PROT_STATE_STOP) begin
         if (c_uart_tx_trig) begin
            tx_prot <= TX_PROT_STATE_WAIT;
         end
      end
   end
end
always_ff @ (posedge clk or posedge c_ex_rst) begin
   if (c_ex_rst) begin
      rx_prot <= RX_PROT_STATE_WAIT;
   end
   else begin
      unique if (rx_prot == RX_PROT_STATE_WAIT) begin
         if (c_uart_rx_negedge) begin
            rx_prot <= RX_PROT_STATE_START;
         end
      end
      else if (rx_prot == RX_PROT_STATE_START) begin
         if (c_uart_rx_half) begin
            rx_prot <= RX_PROT_STATE_SHIFT;
         end
      end
      else if (rx_prot == RX_PROT_STATE_SHIFT) begin
         if (c_byte_received) begin
            rx_prot <= RX_PROT_STATE_STOP;
         end
      end
      else if (rx_prot == RX_PROT_STATE_STOP) begin
         if (c_uart_rx_full) begin
            rx_prot <= RX_PROT_STATE_WAIT;
         end
      end
   end
end
always_ff @ (posedge clk or posedge c_ex_rst) begin
   if (c_ex_rst) begin
      byte2bus <= BYTE2BUS_STATE_EXEC;
   end
   else begin
      unique if (byte2bus == BYTE2BUS_STATE_EXEC) begin
         if (c_uart_rx_valid) begin
            if (c_prog_mem) begin
               byte2bus <= BYTE2BUS_STATE_ADD_B0;
            end
            if (c_user_com_mode) begin
               byte2bus <= BYTE2BUS_STATE_COM_MODE;
            end
         end
      end
      else if (byte2bus == BYTE2BUS_STATE_ADD_B0) begin
         if (c_uart_rx_valid) begin
            byte2bus <= BYTE2BUS_STATE_ADD_B1;
         end
      end
      else if (byte2bus == BYTE2BUS_STATE_ADD_B1) begin
         if (c_uart_rx_valid) begin
            byte2bus <= BYTE2BUS_STATE_DAT_B0;
         end
      end
      else if (byte2bus == BYTE2BUS_STATE_DAT_B0) begin
         if (c_uart_rx_valid) begin
            byte2bus <= BYTE2BUS_STATE_DAT_B1;
         end
      end
      else if (byte2bus == BYTE2BUS_STATE_DAT_B1) begin
         if (c_uart_rx_valid) begin
            byte2bus <= BYTE2BUS_STATE_DAT_B2;
         end
      end
      else if (byte2bus == BYTE2BUS_STATE_DAT_B2) begin
         if (c_uart_rx_valid) begin
            byte2bus <= BYTE2BUS_STATE_DAT_B3;
         end
      end
      else if (byte2bus == BYTE2BUS_STATE_DAT_B3) begin
         if (c_uart_rx_valid) begin
            byte2bus <= BYTE2BUS_STATE_EXEC;
         end
      end
      else if (byte2bus == BYTE2BUS_STATE_COM_MODE);
   end
end
always_ff @ (posedge clk) begin
   if (!(c_ex_rst)) begin
      unique if (tx_prot == TX_PROT_STATE_WAIT);
      else if (tx_prot == TX_PROT_STATE_START);
      else if (tx_prot == TX_PROT_STATE_SHIFT) begin
         if (c_uart_tx_trig) begin
            uart_tx_data <= {1'b0, uart_tx_data [8 : 1]};
         end
      end
      else if (tx_prot == TX_PROT_STATE_STOP);
      if (c_slv_wr) begin
         if (c_tx_send) begin
            uart_tx_data <= {1'b1, slv_wr_data [7 : 0]};
         end
      end
   end
end
always_ff @ (posedge clk or posedge c_ex_rst) begin
   if (c_ex_rst) begin
      uart_tx_com <= 0;
   end
   else begin
      if (c_slv_wr) begin
         if (c_tx_send) begin
            uart_tx_com <= 1'b1;
         end
      end
      if (c_uart_tx_valid) begin
         uart_tx_com <= 1'b0;
      end
   end
end
always_ff @ (posedge clk or posedge c_ex_rst) begin
   if (c_ex_rst) begin
      uart_rx_rec <= 0;
   end
   else begin
      unique if (byte2bus == BYTE2BUS_STATE_EXEC);
      else if (byte2bus == BYTE2BUS_STATE_ADD_B0);
      else if (byte2bus == BYTE2BUS_STATE_ADD_B1);
      else if (byte2bus == BYTE2BUS_STATE_DAT_B0);
      else if (byte2bus == BYTE2BUS_STATE_DAT_B1);
      else if (byte2bus == BYTE2BUS_STATE_DAT_B2);
      else if (byte2bus == BYTE2BUS_STATE_DAT_B3);
      else if (byte2bus == BYTE2BUS_STATE_COM_MODE) begin
         if (c_uart_rx_valid) begin
            uart_rx_rec <= uart_rx_data;
         end
      end
   end
end
always_ff @ (posedge clk or posedge c_ex_rst) begin
   if (c_ex_rst) begin
      uart_rx_com <= 0;
   end
   else begin
      unique if (byte2bus == BYTE2BUS_STATE_EXEC);
      else if (byte2bus == BYTE2BUS_STATE_ADD_B0);
      else if (byte2bus == BYTE2BUS_STATE_ADD_B1);
      else if (byte2bus == BYTE2BUS_STATE_DAT_B0);
      else if (byte2bus == BYTE2BUS_STATE_DAT_B1);
      else if (byte2bus == BYTE2BUS_STATE_DAT_B2);
      else if (byte2bus == BYTE2BUS_STATE_DAT_B3);
      else if (byte2bus == BYTE2BUS_STATE_COM_MODE) begin
         if (c_uart_rx_valid) begin
            uart_rx_com <= 1'b1;
         end
         if (c_rx_rec_rd) begin
            uart_rx_com <= 1'b0;
         end
      end
   end
end
always_ff @ (posedge clk or posedge c_ex_rst) begin
   if (c_ex_rst) begin
      user_rst <= 1;
   end
   else begin
      unique if (byte2bus == BYTE2BUS_STATE_EXEC) begin
         if (c_uart_rx_valid) begin
            if (c_user_rst_set_val) begin
               user_rst <= 1'b1;
            end
            if (c_user_rst_clr_val) begin
               user_rst <= 1'b0;
            end
         end
      end
      else if (byte2bus == BYTE2BUS_STATE_ADD_B0);
      else if (byte2bus == BYTE2BUS_STATE_ADD_B1);
      else if (byte2bus == BYTE2BUS_STATE_DAT_B0);
      else if (byte2bus == BYTE2BUS_STATE_DAT_B1);
      else if (byte2bus == BYTE2BUS_STATE_DAT_B2);
      else if (byte2bus == BYTE2BUS_STATE_DAT_B3);
      else if (byte2bus == BYTE2BUS_STATE_COM_MODE);
   end
end
always_ff @ (posedge clk or posedge c_ex_rst) begin
   if (c_ex_rst) begin
      mst_wr_data <= 0;
   end
   else begin
      unique if (byte2bus == BYTE2BUS_STATE_EXEC);
      else if (byte2bus == BYTE2BUS_STATE_ADD_B0);
      else if (byte2bus == BYTE2BUS_STATE_ADD_B1);
      else if (byte2bus == BYTE2BUS_STATE_DAT_B0) begin
         mst_wr_data [7 : 0] <= uart_rx_data;
      end
      else if (byte2bus == BYTE2BUS_STATE_DAT_B1) begin
         mst_wr_data [15 : 8] <= uart_rx_data;
      end
      else if (byte2bus == BYTE2BUS_STATE_DAT_B2) begin
         mst_wr_data [23 : 16] <= uart_rx_data;
      end
      else if (byte2bus == BYTE2BUS_STATE_DAT_B3) begin
         mst_wr_data [31 : 24] <= uart_rx_data;
      end
      else if (byte2bus == BYTE2BUS_STATE_COM_MODE);
   end
end
always_ff @ (posedge clk or posedge c_ex_rst) begin
   if (c_ex_rst) begin
      mst_wr_add <= 0;
   end
   else begin
      unique if (byte2bus == BYTE2BUS_STATE_EXEC) begin
         mst_wr_add [7 : 0] <= uart_rx_data;
      end
      else if (byte2bus == BYTE2BUS_STATE_ADD_B0) begin
         mst_wr_add [7 : 0] <= uart_rx_data;
      end
      else if (byte2bus == BYTE2BUS_STATE_ADD_B1) begin
         mst_wr_add [15 : 8] <= uart_rx_data;
      end
      else if (byte2bus == BYTE2BUS_STATE_DAT_B0);
      else if (byte2bus == BYTE2BUS_STATE_DAT_B1);
      else if (byte2bus == BYTE2BUS_STATE_DAT_B2);
      else if (byte2bus == BYTE2BUS_STATE_DAT_B3);
      else if (byte2bus == BYTE2BUS_STATE_COM_MODE);
   end
end
always_ff @ (posedge clk or posedge c_ex_rst) begin
   if (c_ex_rst) begin
      uart_byte_received <= 0;
   end
   else begin
      unique if (rx_prot == RX_PROT_STATE_WAIT) begin
         uart_byte_received <= 1'b0;
      end
      else if (rx_prot == RX_PROT_STATE_START);
      else if (rx_prot == RX_PROT_STATE_SHIFT) begin
         if (c_uart_rx_full) begin
            uart_byte_received <= uart_rx_data [0];
         end
      end
      else if (rx_prot == RX_PROT_STATE_STOP);
   end
end
always_ff @ (posedge clk or posedge c_ex_rst) begin
   if (c_ex_rst) begin
      uart_rx_data <= 0;
   end
   else begin
      unique if (rx_prot == RX_PROT_STATE_WAIT) begin
         uart_rx_data <= 8'h80;
      end
      else if (rx_prot == RX_PROT_STATE_START);
      else if (rx_prot == RX_PROT_STATE_SHIFT) begin
         if (c_uart_rx_full) begin
            uart_rx_data <= {!rx_maj_dec, uart_rx_data [7 : 1]};
         end
      end
      else if (rx_prot == RX_PROT_STATE_STOP);
   end
end
always_ff @ (posedge clk or posedge c_ex_rst) begin
   if (c_ex_rst) begin
      uart_rx_baud <= 0;
   end
   else begin
      unique if (rx_prot == RX_PROT_STATE_WAIT) begin
         uart_rx_baud <= 0;
      end
      else if (rx_prot == RX_PROT_STATE_START) begin
         uart_rx_baud <= uart_rx_baud + 1;
         if (c_uart_rx_half) begin
            uart_rx_baud <= 0;
         end
      end
      else if (rx_prot == RX_PROT_STATE_SHIFT) begin
         uart_rx_baud <= uart_rx_baud + 1;
         if (c_uart_rx_full) begin
            uart_rx_baud <= 0;
         end
      end
      else if (rx_prot == RX_PROT_STATE_STOP) begin
         uart_rx_baud <= uart_rx_baud + 1;
      end
   end
end
always_ff @ (posedge clk or posedge c_ex_rst) begin
   if (c_ex_rst) begin
      rx_maj_dec <= 1;
   end
   else begin
      rx_maj_dec <= (uart_nrx_filtered == 3'h7) | (uart_nrx_filtered == 3'h3) | (uart_nrx_filtered == 3'h5) | (uart_nrx_filtered == 3'h6);
   end
end
always_ff @ (posedge clk or posedge c_ex_rst) begin
   if (c_ex_rst) begin
      uart_nrx_filtered <= 0;
   end
   else begin
      uart_nrx_filtered <= {uart_nrx_filtered [1 : 0], !uart_rx};
   end
end
always_ff @ (posedge clk) begin
   if (!(c_ex_rst)) begin
      unique if (tx_prot == TX_PROT_STATE_WAIT) begin
         if (c_trans) begin
            uart_tx_baud <= 0;
         end
      end
      else if (tx_prot == TX_PROT_STATE_START) begin
         uart_tx_baud <= uart_tx_baud + 1;
         if (c_uart_tx_trig) begin
            uart_tx_baud <= 0;
         end
      end
      else if (tx_prot == TX_PROT_STATE_SHIFT) begin
         uart_tx_baud <= uart_tx_baud + 1;
         if (c_uart_tx_trig) begin
            uart_tx_baud <= 0;
         end
      end
      else if (tx_prot == TX_PROT_STATE_STOP) begin
         uart_tx_baud <= uart_tx_baud + 1;
      end
   end
end
always_ff @ (posedge clk or posedge c_ex_rst) begin
   if (c_ex_rst) begin
      uart_tx <= 1'b1;
   end
   else begin
      unique if (tx_prot == TX_PROT_STATE_WAIT) begin
         uart_tx <= 1'b1;
         if (c_trans) begin
            uart_tx <= 1'b1;
         end
      end
      else if (tx_prot == TX_PROT_STATE_START);
      else if (tx_prot == TX_PROT_STATE_SHIFT) begin
         uart_tx <= uart_tx_data [0];
      end
      else if (tx_prot == TX_PROT_STATE_STOP) begin
         uart_tx <= 1'b1;
      end
   end
end

//------------------- Item assignment(s):
always_comb begin
   slv_rd_data = 32'hxxxxxxxx;
   if (c_tx_com_rd) begin
      slv_rd_data = {{31 {1'b0}}, uart_tx_com};
   end
   if (c_rx_com_rd) begin
      slv_rd_data = {{31 {1'b0}}, uart_rx_com};
   end
   if (c_rx_rec_rd) begin
      slv_rd_data = {{24 {1'b0}}, uart_rx_rec};
   end
end
assign slv_rd_addr = ic0_axi_slv_rd_addr;
assign slv_wr_data = ic0_axi_mst_wr_data;
assign slv_wr_addr = ic0_axi_mst_wr_addr;
assign ic1_axi_mst_wr_data = mst_wr_data;
assign ic1_axi_mst_wr_addr = mst_wr_add;
assign ic0_axi_slv_rd_data_3 = slv_rd_data;
assign ic0_axi_slv_rd_addr = ic0_axi_mst_rd_addr;

//------------------- Condition assignment(s):
assign c_tx_send = (slv_wr_addr [31 : 0] == 32'h80020000);
assign c_rx_com_rd = (c_slv_rd_valid & (slv_rd_addr [31 : 0] == 32'h80020030));
assign c_rx_rec_rd = (c_slv_rd_valid & (slv_rd_addr [31 : 0] == 32'h80020020));
assign c_tx_com_rd = (c_slv_rd_valid & (slv_rd_addr [31 : 0] == 32'h80020010));
assign c_user_rst = (user_rst == 1'b1);
assign c_user_com_mode = (uart_rx_data == 8'h50);
assign c_prog_mem = (uart_rx_data == 8'h30);
assign c_user_rst_clr_val = (uart_rx_data == 8'h10);
assign c_user_rst_set_val = (uart_rx_data == 8'h11);
always_comb begin
   c_slv_rd_ready = 1'b0;
   if (c_tx_com_rd) begin
      c_slv_rd_ready = 1'b1;
   end
   if (c_rx_com_rd) begin
      c_slv_rd_ready = 1'b1;
   end
   if (c_rx_rec_rd) begin
      c_slv_rd_ready = 1'b1;
   end
end
assign c_slv_rd_valid = ic0_c_axi_slv_rd_valid;
assign c_slv_wr = ic0_c_axi_slv_wr_valid;
always_comb begin
   c_mst_wr = 1'b0;
   unique if (byte2bus == BYTE2BUS_STATE_EXEC);
   else if (byte2bus == BYTE2BUS_STATE_ADD_B0);
   else if (byte2bus == BYTE2BUS_STATE_ADD_B1);
   else if (byte2bus == BYTE2BUS_STATE_DAT_B0);
   else if (byte2bus == BYTE2BUS_STATE_DAT_B1);
   else if (byte2bus == BYTE2BUS_STATE_DAT_B2);
   else if (byte2bus == BYTE2BUS_STATE_DAT_B3) begin
      if (c_uart_rx_valid) begin
         c_mst_wr = 1'b1;
      end
   end
   else if (byte2bus == BYTE2BUS_STATE_COM_MODE);
end
always_comb begin
   c_uart_rx_valid = 1'b0;
   unique if (rx_prot == RX_PROT_STATE_WAIT);
   else if (rx_prot == RX_PROT_STATE_START);
   else if (rx_prot == RX_PROT_STATE_SHIFT);
   else if (rx_prot == RX_PROT_STATE_STOP) begin
      if (c_uart_rx_full) begin
         c_uart_rx_valid = 1'b1;
      end
   end
end
assign c_byte_received = (uart_byte_received == 1'b1);
assign c_uart_rx_full = (uart_rx_baud == 477);
assign c_uart_rx_half = (uart_rx_baud == 239);
assign c_uart_rx_negedge = (uart_nrx_filtered == 3'h7);
always_comb begin
   c_uart_tx_valid = 1'b0;
   unique if (tx_prot == TX_PROT_STATE_WAIT);
   else if (tx_prot == TX_PROT_STATE_START);
   else if (tx_prot == TX_PROT_STATE_SHIFT);
   else if (tx_prot == TX_PROT_STATE_STOP) begin
      if (c_uart_tx_trig) begin
         c_uart_tx_valid = 1'b1;
      end
   end
end
assign c_trans = ((c_slv_wr) & (c_tx_send));
assign c_byte_transmitted = (uart_tx_data == 9'h001);
assign c_uart_tx_trig = (uart_tx_baud == 477);
assign ic1_c_axi_mst_wr_valid = c_mst_wr;
assign ic0_c_axi_slv_wr_valid = (ic0_c_axi_mst_wr_valid);
assign ic0_c_axi_slv_rd_ready_3 = c_slv_rd_ready;
assign ic0_c_axi_slv_rd_valid = (ic0_c_axi_mst_rd_valid);
endmodule