module ALU_Control(
    EX_signal_i,
    func, 
   	ALUCtrl_o   
);
input	[1:0]	EX_signal_i;
input	[9:0]	func;
output	[3:0]	ALUCtrl_o;

reg		[3:0]	ALUCtrl_o;

always@(EX_signal_i or ALUCtrl_o) begin
	//ld sd
	if(EX_signal_i == 2'b00) begin
		ALUCtrl_o = 4'b0010;
	end
	//beq
	//addi
	if(EX_signal_i == 2'b11) begin
		ALUCtrl_o = 4'b0010;
	end
	//others
	if(EX_signal_i == 2'b10) begin
		//or
		if(func == 10'b0000000110)begin
			ALUCtrl_o = 4'b0001;
		end
		//and
		if(func == 10'b0000000111)begin
			ALUCtrl_o = 4'b0000;
		end
		//add
		if(func == 10'b0000000000)begin
			ALUCtrl_o = 4'b0010;
		end
		//sub
		if(func == 10'b0100000000)begin
			ALUCtrl_o = 4'b0110;
		end
		//mul
		if(func == 10'b0000001000)begin
			ALUCtrl_o = 4'b1111;
		end
	end

end

endmodule