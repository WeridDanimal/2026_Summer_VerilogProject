`timescale 1ns / 1ps

//purpose of this TB: only checks functionality of the counter. Does not check correctness of 4-digit segment display
module counter_nodisp_tb;
reg clk,enable,reset;
wire [3:0] val;


fourbit_counter basicCount(.clk(clk),.enable(enable),.reset(reset),.count(val));
initial 
begin

    #5 clk=0;enable=1;reset=1;
    #5 reset=0;
    
    #100 reset=1;
    #10 reset=0;

end

always #5 clk=~clk;
endmodule
