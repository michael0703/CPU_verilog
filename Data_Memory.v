module Data_Memory
(
    clk_i,
    addr_i,
    data_i,     
    MEM_signal_i,
    data_o
);

// Interface
input clk_i;
input [31:0]	addr_i;
input [31:0] data_i;
input [2:0] MEM_signal_i;
output reg [31:0]	data_o;

// data memory
reg [7:0]	memory[31:0];




// Write Data   
always@(clk_i) begin
    if(MEM_signal_i[0])begin
        memory[addr_i] <= data_i[7:0];
    end
    if(MEM_signal_i[1])begin
        data_o <= {24'd0, memory[addr_i]};
    end
		
end
endmodule
