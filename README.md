# PDVL Examples

This is a collection of small examples written in PDVL. The PDVL examples can be compiled into SystemVerilog code using the MRPHS compiler.

This collection is licensed under the Apache License, Version 2.0 (the “License”).

## RISCV_PDVL_Spec:  

This example has an "executable spec" character. The original RISC-V specification was extended to include individual transactions similar to instructions right at the location where the instruction is specified in the document.

Grepping the PDVL code from the RISC-V specification generates PDVL code which can be compiled into synthesizable SystemVerilog code.

## RV32IMC_1P:

The executable spec version is not timing optimized. This project now is a manually optimized 1-pipeline stage RV32IMC core.

## mSoC_RV32IMC_1P:

The core from the RV32IMC_1P is taken and embedded is a minimalistic SoC completely written in PDVL. 


