module FowardUnit(
    ID_EX_RS_i,
    ID_EX_RT_i,
    EX_MEM_RD_i,
    EX_MEM_RegWrite_i,
    MEM_WB_RD_i,
    MEM_WB_RegWrite_i,
    forwardA_o,
    forwardB_o 
);

input	[4:0]	ID_EX_RS_i;
input	[4:0]	ID_EX_RT_i;
input	[4:0]	EX_MEM_RD_i;
input	[4:0]	MEM_WB_RD_i;
input	[1:0]	EX_MEM_RegWrite_i;
input	[1:0]	MEM_WB_RegWrite_i;
output	reg [1:0]	forwardA_o = 2'b11; 
output	reg [1:0]	forwardB_o = 2'b11;

/*
reg 	[1:0]	forwardA_o;
reg 	[1:0]	forwardB_o;
*/

always@(EX_MEM_RegWrite_i or EX_MEM_RD_i or MEM_WB_RegWrite_i or MEM_WB_RD_i or ID_EX_RS_i) begin
	
	if (EX_MEM_RegWrite_i[1]==1'b1 && (EX_MEM_RD_i!=0) && (EX_MEM_RD_i==ID_EX_RS_i))	begin
		forwardA_o = 2'b10;
	end
	else if (MEM_WB_RegWrite_i[1]==1'b1 && (MEM_WB_RD_i!=0) && (MEM_WB_RD_i==ID_EX_RS_i))	begin
		forwardA_o = 2'b01;
	end
	else	begin
		forwardA_o = 2'b00;
	end
end

always@(EX_MEM_RegWrite_i or EX_MEM_RD_i or MEM_WB_RegWrite_i or MEM_WB_RD_i or ID_EX_RT_i) begin
	if (EX_MEM_RegWrite_i[1]==1'b1 && (EX_MEM_RD_i!=0) && (EX_MEM_RD_i==ID_EX_RT_i))	begin
		forwardB_o = 2'b10;
	end
	else if (MEM_WB_RegWrite_i[1]==1'b1 && (MEM_WB_RD_i!=0) && (MEM_WB_RD_i==ID_EX_RT_i))	begin
		forwardB_o = 2'b01;
	end
	else	begin
		forwardB_o = 2'b00;
	end
end


endmodule