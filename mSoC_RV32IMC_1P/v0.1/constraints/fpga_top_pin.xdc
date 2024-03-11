#
# Copyright 2024 Tobias Strauch, Munich, Bavaria, Germany
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#

set_property PACKAGE_PIN E3  [get_ports clk_in]
set_property PACKAGE_PIN C2 [get_ports arstn]
set_property PACKAGE_PIN H5 [get_ports sys_rst]
set_property PACKAGE_PIN A9 [get_ports uart_rx]
set_property PACKAGE_PIN D10 [get_ports uart_tx]
set_property PACKAGE_PIN G13 [get_ports b0_data_io[0]]
set_property PACKAGE_PIN B11 [get_ports b0_data_io[1]]
set_property PACKAGE_PIN A11 [get_ports b0_data_io[2]]
set_property PACKAGE_PIN D12 [get_ports b0_data_io[3]]
set_property PACKAGE_PIN D13 [get_ports b0_data_io[4]]
set_property PACKAGE_PIN B18 [get_ports b0_data_io[5]]
set_property PACKAGE_PIN A18 [get_ports b0_data_io[6]]
set_property PACKAGE_PIN K16 [get_ports b0_data_io[7]]
#set_property PACKAGE_PIN E1  [get_ports b0_data_io[0]]
#set_property PACKAGE_PIN G6  [get_ports b0_data_io[1]]
#set_property PACKAGE_PIN G4  [get_ports b0_data_io[2]]
#set_property PACKAGE_PIN G3  [get_ports b0_data_io[3]]
#set_property PACKAGE_PIN H4  [get_ports b0_data_io[4]]
#set_property PACKAGE_PIN J3  [get_ports b0_data_io[5]]
#set_property PACKAGE_PIN K2  [get_ports b0_data_io[6]]
#set_property PACKAGE_PIN K1  [get_ports b0_data_io[7]]
#set_property PACKAGE_PIN F6  [get_ports b1_data_io[0]]
#set_property PACKAGE_PIN J4  [get_ports b1_data_io[1]]
#set_property PACKAGE_PIN J2  [get_ports b1_data_io[2]]
#set_property PACKAGE_PIN H6  [get_ports b1_data_io[3]]
#set_property PACKAGE_PIN H5  [get_ports b1_data_io[4]]
#set_property PACKAGE_PIN J5  [get_ports b1_data_io[5]]
#set_property PACKAGE_PIN T9  [get_ports b1_data_io[6]]
#set_property PACKAGE_PIN T10 [get_ports b1_data_io[7]]
set_property PACKAGE_PIN E1  [get_ports b1_data_io[0]]
set_property PACKAGE_PIN G6  [get_ports b1_data_io[1]]
set_property PACKAGE_PIN G4  [get_ports b1_data_io[2]]
set_property PACKAGE_PIN G3  [get_ports b1_data_io[3]]
set_property PACKAGE_PIN H4  [get_ports b1_data_io[4]]
set_property PACKAGE_PIN J3  [get_ports b1_data_io[5]]
set_property PACKAGE_PIN K2  [get_ports b1_data_io[6]]
set_property PACKAGE_PIN K1  [get_ports b1_data_io[7]]
                                                                               
set_property IOSTANDARD LVCMOS33 [get_ports clk_in]
set_property IOSTANDARD LVCMOS33 [get_ports arstn]
set_property IOSTANDARD LVCMOS33 [get_ports sys_rst]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rx]
set_property IOSTANDARD LVCMOS33 [get_ports uart_tx]
set_property IOSTANDARD LVCMOS33 [get_ports b0_data_io[*]]
set_property IOSTANDARD LVCMOS33 [get_ports b1_data_io[*]]
