//
// Copyright 2025 Tobias Strauch, Munich, Bavaria
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module PLL (
   //input c_sys_rst,
   input clk_in,
   output clk);

SB_PLL40_CORE FPGA_TOP_pll_inst(.REFERENCECLK(clk_in),
                                .PLLOUTCORE(), //PLLOUTCORE),
                                .PLLOUTGLOBAL(clk), //PLLOUTGLOBAL),
                                .EXTFEEDBACK(),
                                .DYNAMICDELAY(),
                                .RESETB(1'b1),
                                .BYPASS(1'b0),
                                .LATCHINPUTVALUE(),
                                .LOCK(),
                                .SDI(),
                                .SDO(),
                                .SCLK());

//\\ Fin=16, Fout=114;
defparam FPGA_TOP_pll_inst.DIVR = 4'b0000;
defparam FPGA_TOP_pll_inst.DIVF = 7'b0111000;
defparam FPGA_TOP_pll_inst.DIVQ = 3'b011;
defparam FPGA_TOP_pll_inst.FILTER_RANGE = 3'b001;
defparam FPGA_TOP_pll_inst.FEEDBACK_PATH = "SIMPLE";
defparam FPGA_TOP_pll_inst.DELAY_ADJUSTMENT_MODE_FEEDBACK = "FIXED";
defparam FPGA_TOP_pll_inst.FDA_FEEDBACK = 4'b0000;
defparam FPGA_TOP_pll_inst.DELAY_ADJUSTMENT_MODE_RELATIVE = "FIXED";
defparam FPGA_TOP_pll_inst.FDA_RELATIVE = 4'b0000;
defparam FPGA_TOP_pll_inst.SHIFTREG_DIV_MODE = 2'b00;
defparam FPGA_TOP_pll_inst.PLLOUT_SELECT = "GENCLK";
defparam FPGA_TOP_pll_inst.ENABLE_ICEGATE = 1'b0;

endmodule