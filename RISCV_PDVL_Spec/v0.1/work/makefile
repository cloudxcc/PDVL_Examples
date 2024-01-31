#
# Copyright 2024 Tobias Strauch, Munich, Bavaria
# Licensed under the Apache License, Version 2.0, see LICENSE for details.
# SPDX-License-Identifier: Apache-2.0
#

riscv_spec_tex_to_pdvl :     
	grep -h pdvlrvi ../src/tex/rv32.tex | awk -f ../src/support/pdvlExtraction.awk > ../src/PDVL/RISCV.pdvl ;\
	grep -h pdvlrvi ../src/tex/gmaps.tex | awk -f ../src/support/pdvlExtraction.awk >> ../src/PDVL/RISCV.pdvl ;\
	grep -h pdvlrvm ../src/tex/gmaps.tex | awk -f ../src/support/pdvlExtraction.awk >> ../src/PDVL/RISCV.pdvl ;\
	grep -h pdvlrvm ../src/tex/m.tex | awk -f ../src/support/pdvlExtraction.awk >> ../src/PDVL/RISCV.pdvl ;\
	grep -h pdvlrvc ../src/tex/c.tex | awk -f ../src/support/pdvlExtraction.awk >> ../src/PDVL/RISCV.pdvl ;\
	grep -h riscv123 ../src/tex/riscv-spec.tex | awk -f ../src/support/pdvlExtraction.awk >> ../src/PDVL/RISCV.pdvl

riscv_i_spec_tex_to_pdvl :     
	grep -h pdvlrvi ../src/tex/rv32.tex | awk -f ../src/support/pdvlExtraction.awk > ../src/PDVL/RISCV.pdvl ;\
	grep -h pdvlrvi ../src/tex/gmaps.tex | awk -f ../src/support/pdvlExtraction.awk >> ../src/PDVL/RISCV.pdvl ;\
	grep -h riscv123 ../src/tex/riscv-spec.tex | awk -f ../src/support/pdvlExtraction.awk >> ../src/PDVL/RISCV.pdvl

pdvl2sv_riscv:
	rm ../src/SV/*.sv ;\
	MRPHS_D.exe -pdvl2sv -s ../src/PDVL/RISCV.pdvl \
	                        ../src/PDVL/TB_RISCV.pdvl \
                         -o ../src/SV ;\
