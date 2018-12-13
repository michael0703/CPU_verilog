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
always@(posedge clk_i) begin
    if(MEM_signal_i[0])begin
        memory[addr_i] = data_i[7:0];
        memory[addr_i+1] = data_i[15:8];
        memory[addr_i+2] = data_i[23:16];
        memory[addr_i+3] = data_i[31:24];
    end	
end
always@(negedge clk_i)begin
    if(MEM_signal_i[1])begin
        data_o = {memory[addr_i+3], memory[addr_i+2], memory[addr_i+1], memory[addr_i]};
    end 
end


endmodule
