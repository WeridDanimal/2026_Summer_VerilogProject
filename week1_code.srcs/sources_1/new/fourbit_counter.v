`timescale 1ns / 1ps

module fourbit_counter(input clk, input reset, output [3:0] count);

reg[3:0] internalCount;

always @(posedge clk or posedge reset) //should only reset when a reset is pressed once
begin
    if(reset) 
        internalCount<=4'b0;
    else
        internalCount<=internalCount+1;
        
end

assign count=internalCount;
    

endmodule
