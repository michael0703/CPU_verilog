module ID_EX_Reg(
	clk_i      ,
    inst_i     ,
    RSdata_i   ,
    RTdata_i   ,
    EX_signal_i    ,
    MEM_signal_i   ,
    WB_signal_i    ,
    EX_signal_o    ,
    MEM_signal_o   ,
    WB_signal_o    ,
    inst_o     ,
    RSdata_o   ,
    RTdata_o   ,
);

input clk_i;
input [31:0]	inst_i;
input [31:0]	RSdata_i, RTdata_i;
input [1:0] 	EX_signal_i;
input [2:0] 	MEM_signal_i;
input [1:0] 	WB_signal_i;

output reg [31:0] 	inst_o;
output reg [31:0] 	RSdata_o, RTdata_o;
output reg [1:0] 	EX_signal_o;
output reg [2:0] 	MEM_signal_o;
output reg [1:0] 	WB_signal_o;

always@(posedge clk_i)	begin
	inst_o <= inst_i;
	EX_signal_o <= EX_signal_i;
	MEM_signal_o <= MEM_signal_i;
	WB_signal_o <= WB_signal_i;
	RSdata_o <= RSdata_i;

	case(inst_i[6:0])
		7'b0000011:	RTdata_o <= {20'd0, inst_i[31:20]};	//load	use imm as second ALU operand 
		7'b0100011:	RTdata_o <= {20'd0, inst_i[31:25], inst_i[11:7]};	//store 	use imm as second ALU operand 
		7'b0010011: RTdata_o <= {20'd0, inst_i[31:20]}; 	//addi use imm as second ALU operand
		7'b1100011:	RTdata_o <= RTdata_i;	//beq
		default:	RTdata_o <= RTdata_i;
	endcase


end


endmodule