#
# Copyright 2024 Tobias Strauch, Munich, Bavaria
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#


pdvl2sv_mSoC:
	rm ../src/DUT/SV/*.sv ;\
	MRPHS_D.exe -pdvl2sv -s ../src/DUT/PDVL/RISCV/RISCV_opt.pdvl \
	                        ../src/DUT/PDVL/RISCV/RV32IMC_1P.pdvl \
	                        ../src/DUT/PDVL/SoC/MEM.pdvl \
	                        ../src/DUT/PDVL/SoC/GPIO.pdvl \
	                        ../src/DUT/PDVL/SoC/PMEM.pdvl \
	                        ../src/DUT/PDVL/SoC/SoC.pdvl \
	                        ../src/DUT/PDVL/SoC/FPGA_TOP.pdvl \
	                        ../src/DUT/PDVL/SoC/TB.pdvl \
	                        ../src/DUT/PDVL/SoC/UART.pdvl \
	                        ../src/DUT/PDVL/SoC/UART_Byte2Bus.pdvl \
	                        ../src/DUT/PDVL/AXI/axi.pdvl \
	                     -o ../src/DUT/SV

