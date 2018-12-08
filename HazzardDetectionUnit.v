module HazzardDetectUnit(
    MEM_signal_i   ,
    RS_addr_i  ,
    RT_addr_i  ,
    RD_addr_i  ,
    stall_o    
);


input [2:0] 	MEM_signal_i;
input [4:0] 	RS_addr_i, RT_addr_i, RD_addr_i;
output reg stall_o = 0;

always@(MEM_signal_i or RS_addr_i or RT_addr_i or RD_addr_i)begin
	if (MEM_signal_i[1] && ((RD_addr_i == RS_addr_i) || (RD_addr_i == RT_addr_i)))begin
		stall_o = 1;
	end
	else	begin
		stall_o = 0;
	end
end
endmodule