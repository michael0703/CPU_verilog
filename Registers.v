module Registers
(
    clk_i,
    RSaddr_i,
    RTaddr_i,
    RDaddr_i, 
    RDdata_i,
    RegWrite_i, 
    RSdata_o, 
    RTdata_o 
);

// Ports
input               clk_i;
input   [4:0]       RSaddr_i;
input   [4:0]       RTaddr_i;
input   [4:0]       RDaddr_i;
input   signed [31:0]      RDdata_i;
input   [1:0]            RegWrite_i;
output  reg [31:0]      RSdata_o; 
output  reg [31:0]      RTdata_o;

// Register File
reg     signed [31:0]      register        [0:31];

// Read Data      
//assign  RSdata_o = register[RSaddr_i];
//assign  RTdata_o = register[RTaddr_i];

// Write Data   
always@(posedge clk_i) begin
    if(RegWrite_i[1])begin
        register[RDaddr_i] = RDdata_i;
    end
    /*
    if (RSaddr_i == RDaddr_i)begin
        RSdata_o = register[RSaddr_i]; 
    end
    if (RTaddr_i == RDaddr_i)begin
        RTdata_o = register[RTaddr_i];
    end*/
    RSdata_o = register[RSaddr_i]; 
    RTdata_o = register[RTaddr_i];
    //$display("CLK:%b RS:%d and RT:%d and RD:%d\n", clk_i, RSdata_o, RTdata_o, RDdata_i); 
end


always@(negedge clk_i) begin
    RSdata_o = register[RSaddr_i]; 
    RTdata_o = register[RTaddr_i];
        //$display("CLK:%b RS:%d and RT:%d and RD:%d\n", clk_i, RSdata_o, RTdata_o, RDdata_i);
end



   
endmodule 
