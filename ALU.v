module ALU(
    ALU_Control_i,
    data1_i,
    data2_i,
    data_o,
    Zero_o  
);

input	[31:0]	data1_i;
input	[31:0]	data2_i;
input	[3:0]	ALU_Control_i;
output	[31:0]	data_o;
output	Zero_o;

reg		[31:0]	data_o;

always@(data1_i or data2_i or ALU_Control_i) begin
	//add
	if(ALU_Control_i == 4'b0010) begin
		data_o = data1_i + data2_i;
	end
	//sub
	if(ALU_Control_i == 4'b0110) begin
		data_o = data1_i - data2_i;
	end
	//and
	if(ALU_Control_i == 4'b0000) begin
		data_o = data1_i & data2_i;
	end
	//or
	if(ALU_Control_i == 4'b0001) begin
		data_o = data1_i | data2_i;
	end
	//mul
	if(ALU_Control_i == 4'b1111) begin
		data_o = data1_i * data2_i;
	end
end

endmodule