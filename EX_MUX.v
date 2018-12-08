module EX_MUX(
	dataOrigin_i,      
    dataEx_i,
    dataMem_i,
    select_i,
    data_o
);

input	[31:0]	dataOrigin_i;
input	[31:0]	dataEx_i;
input	[31:0]	dataMem_i;
input	[1:0]	select_i;
output	[31:0]	data_o;

reg		[31:0]	data_o;

always@(select_i or dataOrigin_i or dataEx_i or dataMem_i) begin
	case(select_i)
		2'b00: data_o = dataOrigin_i;
		2'b10: data_o = dataEx_i;
		2'b01: data_o = dataMem_i;
	endcase
end


endmodule