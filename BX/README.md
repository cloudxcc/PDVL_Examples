# BX v1.0

This example is based on the TinyFPGA BX board (Lattice, ICE40LP8K).

A CUBE-V core is a RISC-V compatible core (RV32I), which supports the design concept System-Hyper-Pipelining (8 harts).

Four CUBE-V cores fit on the device which results in a total hart-count of 32.

The design runs at 114 MHz. Because each instruction is executed in a single macro-cycle, 456 MIPS (4*114) can be reached.

The CUBE-V core is limited to a programming element (PE) of a processor array. Therefor no system registers, no fence, no ecall and no invalid instruction detection.

This project is licensed under the Apache License, Version 2.0 (the “License”).

