`timescale 1ns / 1ps

/*
objective: designing a module able to process any message as long as external transmitter indicates 
number of data points and does not exceed FPGA's hardware limits on member's bit size and maximum 
amount of members it can store
*/

module allpurpose_receiver
#(parameter array_limit=100, parameter elementsize=8,
  parameter IDLE=0)(input clock, input reset, input rx);

reg receiverState;

reg [elementsize-1:0] receiverArray[array_limit-1:0];

integer i;

always@(posedge clock or reset)
begin
    if(reset)
    begin

        for(i=0;i<array_limit;i=i+1)
            receiverArray[i]<=0;
    end
end
    
endmodule
