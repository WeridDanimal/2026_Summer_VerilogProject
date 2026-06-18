`timescale 1ns / 1ps

/*
Purpose: Verification in these steps=
Step 1. Make sure that the Counter obeys slow clock and async reset     PASSED
Step 2. Make sure that the Segmented Display shows same counter value on all digits
*/
module counter_display_version;
reg clk,reset;
wire [3:0] an;
wire [6:0] sseg;
wire slow_clk;
wire counter_clk;
wire [3:0] countOut;


highlevel_statemachine h1(.clk(clk),.reset(reset),.an(an),.sseg(sseg),.slow_clk(slow_clk),
.counter_clk(counter_clk),.countOut(countOut));

initial
begin
    #5 clk=0; reset=0;
    #5 reset=1;
    #10 reset=0;
    
end

always #5 clk=~clk;
endmodule

/*

real-life problems:
    1. first testing showed LED display flashed too slow
    2. LED lights indicate Counter correctly worked but not the output of the 7-segments

*/