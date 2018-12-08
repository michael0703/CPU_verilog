module Adder(
	data1_in,
	data2_in,
	stall_i,
	data_o
);

input [31:0]	data1_in, data2_in;
input stall_i;
output reg [31:0]	data_o;

always@(data1_in or data2_in or stall_i)begin
	if (~stall_i)begin
		data_o = data1_in + data2_in;
	end
	else	begin
		data_o = data1_in;
	end
end
endmodule 