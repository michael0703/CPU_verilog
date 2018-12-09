module CPU
(
    clk_i, 
    rst_i,
    start_i
);

// Ports
input               clk_i;
input               rst_i;
input               start_i;

wire [31:0] instr_addr;

Adder Add_PC(
    .stall_i    (HazzardDetectUnit.stall_o),
    .data1_in   (instr_addr),
    .data2_in   (Flush_Unit.Imm_o),
    .data_o     ()
);


PC PC(
    .clk_i      (clk_i),
    .rst_i      (rst_i),
    .start_i    (start_i),
    .pc_i       (Add_PC.data_o),
    .pc_o       (instr_addr)
);

/*
MUX32 MUX_PCSrc(
    .data1_i    (),
    .data2_i    (),
    .select_i   (),
    .data_o     (PC.pc_i)
);
*/

Instruction_Memory Instruction_Memory(
    .addr_i     (instr_addr), 
    .instr_o    ()
);

IF_ID_Reg   IF_ID_Reg(
    .stall_i    (HazzardDetectUnit.stall_o),
    .clk_i     (clk_i),
    .inst_i   (Instruction_Memory.instr_o),
    .flush_i    (Flush_Unit.If_flush_o),
    .pc_i   (instr_addr),
    .inst_o    (),
    .pc_o   ()
);

//////////////////////////////////

Registers Registers(
    .clk_i      (clk_i),
    .RSaddr_i   (IF_ID_Reg.inst_o[19:15]),
    .RTaddr_i   (IF_ID_Reg.inst_o[24:20]),
    .RDaddr_i   (MEM_WB_Reg.inst_o[11:7]), 
    .RDdata_i   (MUX_WriteBackSrc.data_o),
    .RegWrite_i (MEM_WB_Reg.WB_signal_o), 
    .RSdata_o   (), 
    .RTdata_o   () 
);

Control Control(
    .inst_i     (IF_ID_Reg.inst_o),
    .EX_signal_o    (),
    .MEM_signal_o   (),
    .WB_signal_o    ()
);

ID_EX_Reg   ID_EX_Reg(
    .clk_i      (clk_i),
    .inst_i     (IF_ID_Reg.inst_o),
    .RSdata_i   (Registers.RSdata_o),
    .RTdata_i   (Registers.RTdata_o),
    .EX_signal_i    (MUX_Control.EX_signal_o),
    .MEM_signal_i   (MUX_Control.MEM_signal_o),
    .WB_signal_i    (MUX_Control.WB_signal_o),
    .RS2Data_o  (),
    .ImmData_o  (),
    .Immsig_o   (),
    .EX_signal_o    (),
    .MEM_signal_o   (),
    .WB_signal_o    (),
    .inst_o     (),
    .RSdata_o   (),
    .RTdata_o   ()
);

HazzardDetectUnit HazzardDetectUnit(
    .MEM_signal_i   (ID_EX_Reg.MEM_signal_o),
    .RS_addr_i  (IF_ID_Reg.inst_o[19:15]),
    .RT_addr_i  (IF_ID_Reg.inst_o[24:20]),
    .RD_addr_i  (ID_EX_Reg.inst_o[11:7]),
    .stall_o    ()
);

MUX8 MUX_Control(
    .stall_select_i   (HazzardDetectUnit.stall_o),
    .flush_select_i   (Flush_Unit.If_flush_o),
    .EX_signal_i    (Control.EX_signal_o),
    .MEM_signal_i   (Control.MEM_signal_o),
    .WB_signal_i    (Control.WB_signal_o),
    .EX_signal_o    (),
    .MEM_signal_o   (),
    .WB_signal_o    ()
);

Flush_Unit Flush_Unit(
    .EX_signal_i   (Control.EX_signal_o),
    .Imm_i  ({20'b0, IF_ID_Reg.inst_o[31],IF_ID_Reg.inst_o[7],IF_ID_Reg.inst_o[30:25],IF_ID_Reg.inst_o[11:8]}),
    .RSdata_i   (Registers.RSdata_o),
    .RTdata_i   (Registers.RTdata_o), 
    .If_flush_o (),
    .Imm_o()

);


/*
Sign_Extend Sign_Extend(
    .data_i     (),
    .data_o     ()
);
*/


////////////////////////////////////

EX_MUX MUX_RSSrc(
    .dataOrigin_i    (ID_EX_Reg.RSdata_o),      
    .dataEx_i       (EX_MEM_Reg.ALUResult_o),
    .dataMem_i      (MUX_WriteBackSrc.data_o),
    .select_i   (FowardUnit.forwardA_o),
    .data_o     ()
);

MUX32  MUX_RTSrc(
    .data1_i    (ID_EX_Reg.ImmData_o),
    .data2_i    (MUX_R2Src.data_o),
    .select_i   (ID_EX_Reg.Immsig_o),
    .data_o     ()
);

EX_MUX MUX_R2Src(
    .dataOrigin_i  (ID_EX_Reg.RS2Data_o),
    .dataEx_i   (EX_MEM_Reg.ALUResult_o),
    .dataMem_i  (MUX_WriteBackSrc.data_o),
    .select_i   (FowardUnit.forwardB_o),
    .data_o     ()

);



ALU_Control ALU_Control(
    .EX_signal_i    (ID_EX_Reg.EX_signal_o),
    .func   ({{ID_EX_Reg.inst_o[31:25]}, {ID_EX_Reg.inst_o[14:12]}}), 
    .ALUCtrl_o  ()  
);

ALU ALU(
    .ALU_Control_i  (ALU_Control.ALUCtrl_o),
    .data1_i    (MUX_RSSrc.data_o),
    .data2_i    (MUX_RTSrc.data_o),
    .data_o     (),
    .Zero_o     ()
);

FowardUnit  FowardUnit(
    .ID_EX_RS_i     (ID_EX_Reg.inst_o[19:15]),
    .ID_EX_RT_i     (ID_EX_Reg.inst_o[24:20]),
    .EX_MEM_RD_i    (EX_MEM_Reg.inst_o[11:7]),
    .EX_MEM_RegWrite_i  (EX_MEM_Reg.WB_signal_o),
    .MEM_WB_RD_i    (MEM_WB_Reg.inst_o[11:7]),
    .MEM_WB_RegWrite_i  (MEM_WB_Reg.WB_signal_o),
    .forwardA_o   (),
    .forwardB_o   ()
);

EX_MEM_Reg  EX_MEM_Reg(
    .clk_i  (clk_i),
    .inst_i     (ID_EX_Reg.inst_o),
    .MEM_signal_i   (ID_EX_Reg.MEM_signal_o),
    .WB_signal_i    (ID_EX_Reg.WB_signal_o),
    .ALUResult_i    (ALU.data_o),
    .RTdata_i   (MUX_R2Src.data_o),
    .inst_o     (),
    .MEM_signal_o   (),
    .WB_signal_o    (),
    .ALUResult_o    (),
    .RTdata_o   ()
);

/////////////////////////////////

Data_Memory Data_Memory(
    .clk_i  (clk_i),
    .addr_i  (EX_MEM_Reg.ALUResult_o),
    .data_i  (EX_MEM_Reg.RTdata_o),
    .MEM_signal_i   (EX_MEM_Reg.MEM_signal_o),
    .data_o     ()
);

MEM_WB_Reg  MEM_WB_Reg(
    .clk_i  (clk_i),
    .inst_i     (EX_MEM_Reg.inst_o),
    .WB_signal_i    (EX_MEM_Reg.WB_signal_o),
    .MEMdata_i  (Data_Memory.data_o),
    .ALUResult_i    (EX_MEM_Reg.ALUResult_o),
    .inst_o     (),
    .WB_signal_o    (),
    .MEMdata_o  (),
    .ALUResult_o    ()
);


MUX32 MUX_WriteBackSrc(
    .data1_i    (MEM_WB_Reg.MEMdata_o),
    .data2_i    (MEM_WB_Reg.ALUResult_o),
    .select_i   (MEM_WB_Reg.WB_signal_o[0]),
    .data_o     ()
);


endmodule

