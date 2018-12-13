// If_flush_o connect to PC and IF_ID, change PC and flush IF_ID
// Control tell If_branch_i if this is an branch instruction
// RS and RT are both 32 bit value

module Flush_Unit(
	EX_signal_i,
	Imm_i,
    RSdata_i,
    RTdata_i, 
    If_flush_o,
    Imm_o
);


input [1:0]  EX_signal_i;
input [31:0] RSdata_i;
input [31:0] RTdata_i;
input [31:0] Imm_i;
integer i;

output reg If_flush_o;
output reg [31:0] Imm_o = 32'd4;
reg [31:0] tmp;	


always@(EX_signal_i or RSdata_i or RTdata_i)begin
	tmp = Imm_i;
	if (tmp[11] == 1)begin
		for(i=0; i<20; i=i+1)begin
			tmp[12+i] = 1;
		end
	end
	if (EX_signal_i == 2'b01 && (RSdata_i == RTdata_i)) begin
		If_flush_o = 1;
		Imm_o = (tmp << 1 )- 4;
	end
	else begin
		If_flush_o = 0;
		Imm_o = 32'd4;
	end
end
endmodule