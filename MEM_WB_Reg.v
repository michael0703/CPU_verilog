module MEM_WB_Reg(
	clk_i,
    inst_i,
    WB_signal_i,
    MEMdata_i,
    ALUResult_i,
    inst_o,
    WB_signal_o,
    MEMdata_o,
    ALUResult_o
);
input	clk_i;
input	[31:0] inst_i;
input	[1:0] WB_signal_i;
input	[31:0] MEMdata_i;
input	[31:0] ALUResult_i;

output	reg [31:0] inst_o;
output	reg [1:0] WB_signal_o;
output	reg [31:0] MEMdata_o	;
output	reg [31:0] ALUResult_o;


always@(posedge clk_i) begin
	ALUResult_o <= ALUResult_i;
	WB_signal_o <= WB_signal_i;
	MEMdata_o <= MEMdata_i;
	inst_o <= inst_i;

end

endmodule