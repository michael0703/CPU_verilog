#!/bin/bash

iverilog -o Mycpu Adder.v ALU.v ALU_Control.v Control.v CPU.v Data_Memory.v \
	EX_MEM_Reg.v EX_MUX.v ForwardUnit.v ID_EX_Reg.v IF_ID_Reg.v Instruction_Memory.v \
	MEM_WB_Reg.v MUX32.v PC.v Registers.v HazzardDetectionUnit.v MUX8.v testbench.v

