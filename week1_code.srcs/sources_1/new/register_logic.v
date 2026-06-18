`timescale 1ns / 1ps


module register_logic(
    input clk,
    input enable,
    input [3:0] data,
    output reg [3:0] Q

    );


//only update to flip flop if clock reaches a positive edge
always@(posedge clk)
begin
    if(enable)
        //Q<=data;//if my understanding is correct, Q just holds on to a value
        Q<=data;
end


endmodule
