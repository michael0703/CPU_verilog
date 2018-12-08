module EX_MEM_Reg(
    clk_i,
    inst_i,
    MEM_signal_i,
    WB_signal_i,
    ALUResult_i,
    RTdata_i,
    inst_o,
    MEM_signal_o,
    WB_signal_o,
    ALUResult_o,
    RTdata_o,
);

input           clk_i;
input   [31:0]  inst_i;
input   [2:0]   MEM_signal_i;
input   [1:0]   WB_signal_i;
input   [31:0]  ALUResult_i;
input   [31:0]  RTdata_i;
output  reg     [31:0]  inst_o;
output  reg     [2:0]   MEM_signal_o;
output  reg     [1:0]   WB_signal_o;
output  reg     [31:0]  ALUResult_o;
output  reg     [31:0]  RTdata_o;


always@(posedge clk_i) begin
    inst_o <= inst_i;
    MEM_signal_o <= MEM_signal_i;
    WB_signal_o <= WB_signal_i;
    ALUResult_o <= ALUResult_i;
    RTdata_o <= RTdata_i;
end

endmodule