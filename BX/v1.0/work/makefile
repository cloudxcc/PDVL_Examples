#
# Copyright 2025 Tobias Strauch, Munich, Bavaria
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#

quad:
	rm ../source/DUT/SV/*.sv ;\
	MRPHS_D.exe -pdvl2sv -s ../source/DUT/PDVL/RISCV/RISCV_opt.pdvl \
	                        ../source/DUT/PDVL/RISCV/RV32i_1P.pdvl \
	                        ../source/DUT/PDVL/SoC_Quad/TC.pdvl \
	                        ../source/DUT/PDVL/SoC_Quad/MEM.pdvl \
	                        ../source/DUT/PDVL/SoC_Quad/GPIO.pdvl \
	                        ../source/DUT/PDVL/SoC_Quad/PMEM.pdvl \
	                        ../source/DUT/PDVL/SoC_Quad/SoC_Quad.pdvl \
	                        ../source/DUT/PDVL/SoC_Quad/FPGA_TOP_Quad.pdvl \
	                        ../source/DUT/PDVL/SoC_Quad/TB_Quad.pdvl \
	                        ../source/DUT/PDVL/AXI/axi.pdvl \
	                     -top testbench_soc \
	                     -o ../source/DUT/SV

blinky84s :
	cd ../source/dyn_tests/system/blinky84s_0/work ;\
	cp ../ws_blinky84s_0/blinky84s_0/Release/blinky84s_0.elf . ;\
	riscv64-unknown-elf-objdump.exe -S blinky84s_0.elf > main_0.disasm ;\
	riscv64-unknown-elf-objcopy.exe -O verilog blinky84s_0.elf blinky84s_0.hex ;\
	riscv64-unknown-elf-objcopy.exe -j.text -O verilog blinky84s_0.elf main_0.hex ;\
	riscv64-unknown-elf-objcopy.exe -j.data -O verilog blinky84s_0.elf data_0.hex ;\
	cd ../../blinky84s_1/work ;\
	cp ../ws_blinky84s_1/blinky84s_1/Release/blinky84s_1.elf . ;\
	riscv64-unknown-elf-objdump.exe -S blinky84s_1.elf > main_0.disasm ;\
	riscv64-unknown-elf-objcopy.exe -O verilog blinky84s_1.elf blinky84s_1.hex ;\
	riscv64-unknown-elf-objcopy.exe -j.text -O verilog blinky84s_1.elf main_0.hex ;\
	riscv64-unknown-elf-objcopy.exe -j.data -O verilog blinky84s_1.elf data_0.hex ;\
	cd ../../blinky84s_2/work ;\
	cp ../ws_blinky84s_2/blinky84s_2/Release/blinky84s_2.elf . ;\
	riscv64-unknown-elf-objdump.exe -S blinky84s_2.elf > main_0.disasm ;\
	riscv64-unknown-elf-objcopy.exe -O verilog blinky84s_2.elf blinky84s_2.hex ;\
	riscv64-unknown-elf-objcopy.exe -j.text -O verilog blinky84s_2.elf main_0.hex ;\
	riscv64-unknown-elf-objcopy.exe -j.data -O verilog blinky84s_2.elf data_0.hex ;\
	cd ../../blinky84s_3/work ;\
	cp ../ws_blinky84s_3/blinky84s_3/Release/blinky84s_3.elf . ;\
	riscv64-unknown-elf-objdump.exe -S blinky84s_3.elf > main_0.disasm ;\
	riscv64-unknown-elf-objcopy.exe -O verilog blinky84s_3.elf blinky84s_3.hex ;\
	riscv64-unknown-elf-objcopy.exe -j.text -O verilog blinky84s_3.elf main_0.hex ;\
	riscv64-unknown-elf-objcopy.exe -j.data -O verilog blinky84s_3.elf data_0.hex ;\

