#
# Copyright 2024 Tobias Strauch, Munich, Bavaria
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#


pdvl2sv_RV32IMC_1P:
	rm ../src/DUT/SV/*.sv ;\
	MRPHS_D.exe -pdvl2sv -s ../src/DUT/PDVL/RISCV_opt.pdvl \
	                        ../src/DUT/PDVL/RV32M_1P_syn.pdvl \
	                        ../src/DUT/PDVL/RV32IMC_1P.pdvl \
	                        ../src/DUT/PDVL/TB_RV32IMC_1P.pdvl \
                         -o ../src/DUT/SV ;\

codeGenHex:
	cd ../src/dyn_tests/codeGenHex  ;\
	g++ codeGenHex.cpp -o codeGenHex.exe ;\
	./codeGenHex.exe
	
