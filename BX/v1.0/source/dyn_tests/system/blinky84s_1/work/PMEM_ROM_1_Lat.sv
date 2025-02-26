module PMEM_1 (
   output [31 : 0] instr_reg_c1,
   input [10 - 1 : 0] pc_read_c0,
   input clk);  
reg  [31 : 0] instr_reg_c1;
reg  [32 - 1 : 0] mem32 [0 : 256 - 1];

always_ff @ (posedge clk)
   instr_reg_c1 <= mem32 [pc_read_c0 [9 : 2]];

always_ff @ (posedge clk)
   mem32 <= {
   32'h00000113,
   32'h00000413,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'h00000013,
   32'hff010113,
   32'h012347b7,
   32'h00112623,
   32'h00812423,
   32'h56778793,
   32'h00f02823,
   32'h01002703,
   32'hfef71ee3,
   32'h40802403,
   32'h00040513,
   32'h1e0000ef,
   32'h00040513,
   32'h204000ef,
   32'h00040513,
   32'h228000ef,
   32'h00040513,
   32'h24c000ef,
   32'h00040513,
   32'h270000ef,
   32'h00040513,
   32'h294000ef,
   32'h00040513,
   32'h2b8000ef,
   32'h00f00513,
   32'h134000ef,
   32'h00002197,
   32'h35018193,
   32'h80818513,
   32'h82418613,
   32'h40a60633,
   32'h00000593,
   32'h438000ef,
   32'h00000517,
   32'h32c50513,
   32'h2d8000ef,
   32'h390000ef,
   32'h00012503,
   32'h00410593,
   32'h00000613,
   32'hf65ff0ef,
   32'h2d40006f,
   32'h00008067,
   32'h00002517,
   32'hb0c50513,
   32'h00002797,
   32'hb0478793,
   32'h00a78a63,
   32'hffff0317,
   32'hed030313,
   32'h00030463,
   32'h00030067,
   32'h00008067,
   32'h00002517,
   32'hae450513,
   32'h00002597,
   32'hadc58593,
   32'h40a585b3,
   32'h4025d593,
   32'h01f5d793,
   32'h00b785b3,
   32'h4015d593,
   32'h00058a63,
   32'hffff0317,
   32'he9430313,
   32'h00030463,
   32'h00030067,
   32'h00008067,
   32'h00002797,
   32'hab07c783,
   32'h04079263,
   32'hff010113,
   32'h00112623,
   32'hf89ff0ef,
   32'hffff0797,
   32'he6878793,
   32'h00078a63,
   32'h00000517,
   32'h64c50513,
   32'hffff0097,
   32'he54080e7,
   32'h00c12083,
   32'h00100793,
   32'h00002717,
   32'ha6f70a23,
   32'h01010113,
   32'h00008067,
   32'h00008067,
   32'hffff0797,
   32'he3078793,
   32'h02078663,
   32'hff010113,
   32'h00002597,
   32'ha5458593,
   32'h00000517,
   32'h60850513,
   32'h00112623,
   32'hffff0097,
   32'he0c080e7,
   32'h00c12083,
   32'h01010113,
   32'hf41ff06f,
   32'hff010113,
   32'h00700593,
   32'h00812423,
   32'h00112623,
   32'h00050413,
   32'h194000ef,
   32'h40145793,
   32'h0037f713,
   32'h00100793,
   32'h0e050513,
   32'h00e797b3,
   32'h00147413,
   32'h00000713,
   32'h00e51a63,
   32'h02040a63,
   32'h44f02823,
   32'h0e000513,
   32'hfedff06f,
   32'h0e000613,
   32'h0e000693,
   32'h44f02223,
   32'hfff68693,
   32'hfe069ce3,
   32'hfff60613,
   32'hfe0616e3,
   32'h00170713,
   32'hfcdff06f,
   32'h44f02a23,
   32'hfd1ff06f,
   32'h00054e63,
   32'h000107b7,
   32'h29878793,
   32'h0017d793,
   32'h3ff7f793,
   32'h40f02023,
   32'h00008067,
   32'hff010113,
   32'h00800513,
   32'h00112623,
   32'hf65ff0ef,
   32'h00054e63,
   32'h000107b7,
   32'h2c478793,
   32'h0017d793,
   32'h3ff7f793,
   32'h40f02023,
   32'h00008067,
   32'hff010113,
   32'h00900513,
   32'h00112623,
   32'hf39ff0ef,
   32'h00054e63,
   32'h000107b7,
   32'h2f078793,
   32'h0017d793,
   32'h3ff7f793,
   32'h40f02023,
   32'h00008067,
   32'hff010113,
   32'h00a00513,
   32'h00112623,
   32'hf0dff0ef,
   32'h00054e63,
   32'h000107b7,
   32'h31c78793,
   32'h0017d793,
   32'h3ff7f793,
   32'h40f02023,
   32'h00008067,
   32'hff010113,
   32'h00b00513,
   32'h00112623,
   32'hee1ff0ef,
   32'h00054e63,
   32'h000107b7,
   32'h34878793,
   32'h0017d793,
   32'h3ff7f793,
   32'h40f02023,
   32'h00008067,
   32'hff010113,
   32'h00c00513,
   32'h00112623,
   32'heb5ff0ef,
   32'h00054e63,
   32'h000107b7,
   32'h37478793,
   32'h0017d793,
   32'h3ff7f793,
   32'h40f02023,
   32'h00008067,
   32'hff010113,
   32'h00d00513,
   32'h00112623,
   32'he89ff0ef,
   32'h00054e63,
   32'h000107b7,
   32'h3a078793,
   32'h0017d793,
   32'h3ff7f793,
   32'h40f02023,
   32'h00008067,
   32'hff010113,
   32'h00e00513,
   32'h00112623,
   32'he5dff0ef,
   32'h00050613,
   32'h00000513,
   32'h0015f693,
   32'h00068463,
   32'h00c50533,
   32'h0015d593,
   32'h00161613,
   32'hfe0596e3,
   32'h00008067,
   32'h00050593,
   32'h00000693,
   32'h00000613,
   32'h00000513,
   32'h2200006f,
   32'hff010113,
   32'h00000593,
   32'h00812423,
   32'h00112623,
   32'h00050413,
   32'h28c000ef};

endmodule
