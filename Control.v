module Control(
	inst_i,     
    EX_signal_o,
    MEM_signal_o, 
    WB_signal_o  
);

input [31:0] 	inst_i;
output reg [1:0] 	EX_signal_o;		// to give signal to ALUSrc/ALUOp	
output reg [2:0] 	MEM_signal_o;	// to give signal to MemRead/MemWrite/Branch each for 1bit
output reg [1:0] 	WB_signal_o;		// to give signal to RegWrite/MemtoReg each for 1bit

always	@(inst_i) begin
	
	case(inst_i[6:0])	
		7'b0000011:	WB_signal_o = 2'b11;	//load 	// index: n<-0 
		7'b0100011:	WB_signal_o = 2'b0x;	//store
		7'b1100011:	WB_signal_o = 2'b0x;	//beq
		default:	WB_signal_o = 2'b10;	//R format
	endcase

	case(inst_i[6:0])
		7'b0000011:	MEM_signal_o = 3'b010;	//load
		7'b0100011:	MEM_signal_o = 3'b001;	//store
		7'b1100011:	MEM_signal_o = 3'b100;	//beq
		default:	MEM_signal_o = 3'b000;  //R format
	endcase
	
	case(inst_i[6:0])
		7'b0000011:	EX_signal_o = 2'b00;	//load
		7'b0100011:	EX_signal_o = 2'b00;	//store
		7'b1100011:	EX_signal_o = 2'b10;	//beq
		7'b1100011: EX_signal_o = 2'b11;	// addi
		default:	EX_signal_o = 2'b00;    //R format
	endcase


end


  
endmodule
