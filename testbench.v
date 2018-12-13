`define CYCLE_TIME 50            

module TestBench;

reg                Clk;
reg                Start;
reg                Reset;
integer            i, outfile, counter;
integer            stall, flush;

always #(`CYCLE_TIME/2) Clk = ~Clk;    

CPU CPU(
    .clk_i  (Clk),
    .rst_i  (Reset),
    .start_i(Start)
);
  
initial begin
    counter = 0;
    stall = 0;
    flush = 0;
    
    // initialize instruction memory
    for(i=0; i<256; i=i+1) begin
        CPU.Instruction_Memory.memory[i] = 32'b0;
    end
    
    // initialize data memory
    for(i=0; i<32; i=i+1) begin
        CPU.Data_Memory.memory[i] = 8'b0;
    end    
        
    // initialize Register File
    for(i=0; i<32; i=i+1) begin
        CPU.Registers.register[i] = 32'b0;
    end
    
    // Load instructions into instruction memory
    $readmemb("../testcase_Fibonacci/Fibonacci_instruction.txt", CPU.Instruction_Memory.memory);
    
    // Open output file
    outfile = $fopen("output.txt") | 1;
    
    // Set Input n into data memory at 0x00
    CPU.Data_Memory.memory[0] = 8'h5;       // n = 5 for example
    
    Clk = 0;
    Reset = 0;
    Start = 0;
    
    #(`CYCLE_TIME/4) 
    Reset = 1;
    Start = 1;
        
    
end
  
always@(posedge Clk) begin
    if(counter == 30)    // stop after 30 cycles
        $stop;

    // put in your own signal to count stall and flush
    if(CPU.HazzardDetectUnit.stall_o == 1)stall = stall + 1;
    if(CPU.Flush_Unit.If_flush_o== 1)flush = flush + 1;  
    //$display("HazzardDetectUnit:%b, %b, %b, %b %b\n", CPU.HazzardDetectUnit.MEM_signal_i, CPU.HazzardDetectUnit.RS_addr_i,  CPU.HazzardDetectUnit.RT_addr_i,  CPU.HazzardDetectUnit.RD_addr_i, CPU.HazzardDetectUnit.stall_o);
    $display("IF/ID  Reg %b\n", CPU.IF_ID_Reg.inst_o);
    $display("ID/EX  Reg %b\n", CPU.ID_EX_Reg.inst_o);
    //$display("EX/MEM Reg %b\n", CPU.EX_MEM_Reg.inst_o);
    //$display("MEM/WB Reg %b\n", CPU.MEM_WB_Reg.inst_o);
    //$display("rs1:%d, rs2:%d, rd':%d, rd'':%d, regwrite:%d,%d\n", CPU.FowardUnit.ID_EX_RS_i,CPU.FowardUnit.ID_EX_RT_i,CPU.FowardUnit.EX_MEM_RD_i, CPU.FowardUnit.MEM_WB_RD_i, CPU.FowardUnit.EX_MEM_RegWrite_i[1], CPU.FowardUnit.MEM_WB_RegWrite_i[1]);
    //$display("Datapath of RS2 ID_EX_Reg:%d, RS1:%d, RS2:%d\n", CPU.ID_EX_Reg.RS2Data_o, CPU.ID_EX_Reg.RSdata_o,CPU.ID_EX_Reg.RTdata_o);
    //$display("EX_MEM_Reg:%d\nData_Mem:%d\n",CPU.EX_MEM_Reg.RTdata_o, CPU.Data_Memory.data_i);
    //$display("MemData:%d\n",CPU.Data_Memory.data_o);
    $display("Registers data RS1:%d,RS2:%d RD:%d\n", CPU.Registers.RSdata_o, CPU.Registers.RTdata_o, CPU.Registers.RDdata_i);
    $display("Registers addr RS1:%d,RS2:%d RD:%d\n", CPU.Registers.RSaddr_i, CPU.Registers.RTaddr_i, CPU.Registers.RDaddr_i);
    //$display("Stall:%d\n",CPU.MUX_Control.stall_select_i);
    //$display("Control Signal: %b %b %b\n", CPU.MUX_Control.EX_signal_o, CPU.MUX_Control.MEM_signal_o, CPU.MUX_Control.WB_signal_o);
    $display("ALUControl :%b, EX_signal: %b, Funt:%b\n", CPU.ALU_Control.ALUCtrl_o, CPU.ALU_Control.EX_signal_i, CPU.ALU_Control.func);
    $display("ALU operand1(rs1):%d, operand2(rs2orImm):%d Ans:%d\n", CPU.ALU.data1_i, CPU.ALU.data2_i, CPU.ALU.data_o);
    $display("ForwardA:%b, ForwardB:%b\n", CPU.FowardUnit.forwardA_o, CPU.FowardUnit.forwardB_o);


    //$display("ALU Result :%d\n", CPU.ALU.data_o);
    //$display("WB MUX :%d,%d,%d,%d\n", CPU.MUX_WriteBackSrc.select_i, CPU.MUX_WriteBackSrc.data1_i, CPU.MUX_WriteBackSrc.data2_i, CPU.MUX_WriteBackSrc.data_o);
    //$display("Data_Memory addr:%d, signal:%b\n", CPU.Data_Memory.addr_i, CPU.Data_Memory.MEM_signal_i);
    // print PC
    $fdisplay(outfile, "cycle = %d, Start = %d, Stall = %d, Flush = %d\nPC = %d", counter, Start, stall, flush, CPU.PC.pc_o);
    
    // print Registers
    $fdisplay(outfile, "Registers");
    $fdisplay(outfile, "R0(r0) = %d, R8 (t0) = %d, R16(s0) = %d, R24(t8) = %d", CPU.Registers.register[0], CPU.Registers.register[8] , CPU.Registers.register[16], CPU.Registers.register[24]);
    $fdisplay(outfile, "R1(at) = %d, R9 (t1) = %d, R17(s1) = %d, R25(t9) = %d", CPU.Registers.register[1], CPU.Registers.register[9] , CPU.Registers.register[17], CPU.Registers.register[25]);
    $fdisplay(outfile, "R2(v0) = %d, R10(t2) = %d, R18(s2) = %d, R26(k0) = %d", CPU.Registers.register[2], CPU.Registers.register[10], CPU.Registers.register[18], CPU.Registers.register[26]);
    $fdisplay(outfile, "R3(v1) = %d, R11(t3) = %d, R19(s3) = %d, R27(k1) = %d", CPU.Registers.register[3], CPU.Registers.register[11], CPU.Registers.register[19], CPU.Registers.register[27]);
    $fdisplay(outfile, "R4(a0) = %d, R12(t4) = %d, R20(s4) = %d, R28(gp) = %d", CPU.Registers.register[4], CPU.Registers.register[12], CPU.Registers.register[20], CPU.Registers.register[28]);
    $fdisplay(outfile, "R5(a1) = %d, R13(t5) = %d, R21(s5) = %d, R29(sp) = %d", CPU.Registers.register[5], CPU.Registers.register[13], CPU.Registers.register[21], CPU.Registers.register[29]);
    $fdisplay(outfile, "R6(a2) = %d, R14(t6) = %d, R22(s6) = %d, R30(s8) = %d", CPU.Registers.register[6], CPU.Registers.register[14], CPU.Registers.register[22], CPU.Registers.register[30]);
    $fdisplay(outfile, "R7(a3) = %d, R15(t7) = %d, R23(s7) = %d, R31(ra) = %d", CPU.Registers.register[7], CPU.Registers.register[15], CPU.Registers.register[23], CPU.Registers.register[31]);

    // print Data Memory
    $fdisplay(outfile, "Data Memory: 0x00 = %d", {CPU.Data_Memory.memory[3] , CPU.Data_Memory.memory[2] , CPU.Data_Memory.memory[1] , CPU.Data_Memory.memory[0] });
    $fdisplay(outfile, "Data Memory: 0x04 = %d", {CPU.Data_Memory.memory[7] , CPU.Data_Memory.memory[6] , CPU.Data_Memory.memory[5] , CPU.Data_Memory.memory[4] });
    $fdisplay(outfile, "Data Memory: 0x08 = %d", {CPU.Data_Memory.memory[11], CPU.Data_Memory.memory[10], CPU.Data_Memory.memory[9] , CPU.Data_Memory.memory[8] });
    $fdisplay(outfile, "Data Memory: 0x0c = %d", {CPU.Data_Memory.memory[15], CPU.Data_Memory.memory[14], CPU.Data_Memory.memory[13], CPU.Data_Memory.memory[12]});
    $fdisplay(outfile, "Data Memory: 0x10 = %d", {CPU.Data_Memory.memory[19], CPU.Data_Memory.memory[18], CPU.Data_Memory.memory[17], CPU.Data_Memory.memory[16]});
    $fdisplay(outfile, "Data Memory: 0x14 = %d", {CPU.Data_Memory.memory[23], CPU.Data_Memory.memory[22], CPU.Data_Memory.memory[21], CPU.Data_Memory.memory[20]});
    $fdisplay(outfile, "Data Memory: 0x18 = %d", {CPU.Data_Memory.memory[27], CPU.Data_Memory.memory[26], CPU.Data_Memory.memory[25], CPU.Data_Memory.memory[24]});
    $fdisplay(outfile, "Data Memory: 0x1c = %d", {CPU.Data_Memory.memory[31], CPU.Data_Memory.memory[30], CPU.Data_Memory.memory[29], CPU.Data_Memory.memory[28]});
	
    $fdisplay(outfile, "\n");
    
    counter = counter + 1;
    
      
end

  
endmodule
