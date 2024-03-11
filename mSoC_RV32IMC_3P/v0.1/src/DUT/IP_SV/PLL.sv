//
// Copyright 2024 Tobias Strauch, Munich, Bavaria
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//

module PLL (
   input clk_in,
   output clk);

clk20MHz pll_i (
   // Clock out ports
   .clk_out1(clk),     // output clk_out1
   // Clock in ports
   .clk_in1(clk_in));      // input clk_in1
    
endmodule