module MUX32(
	data1_i,    
    data2_i,    
    select_i,   
    data_o     
);

input signed [31:0]	data2_i, data1_i;
input select_i;
output reg signed [31:0]	data_o;



always	@(select_i or data2_i or data1_i) begin
	if (select_i)	
	begin
		data_o <= data1_i ;
	end
	else 
	begin
		data_o <= data2_i ;
	end
end

endmodule