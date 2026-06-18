`timescale 1ns / 1ps
/*Purpose of this file: to be used as a template that combines: 
    the logic of the segment display controls
    the logic of digits controls
    the logic of converting data to segment-compatible inputs
    the logic of a slow clock
    
    the logic of the module that gives internal data to the digits

*/

module highlevel_statemachine(input clk, input reset, 
output[3:0] an, output[6:0] sseg, output slow_clk,
output counter_clk,
output[3:0] countOut
    );
    
reg [1:0] currState, nextState;
wire [6:0] in0,in1,in2,in3;//intermediate values to pass to 7-segment digits

slowclk slow(.clk(clk),.reset(reset), .clk_out(slow_clk),.counter_clk(counter_clk));
fourbit_counter counter(.clk(counter_clk),.reset(reset),.count(countOut));


segment_conversion s0(.bcd_data(countOut),.segOut(in0));
segment_conversion s1(.bcd_data(countOut),.segOut(in1));
segment_conversion s2(.bcd_data(countOut),.segOut(in2));
segment_conversion s3(.bcd_data(countOut),.segOut(in3));

displaycontrols d1(.clk(slow_clk),.reset(reset),
    .in0(in0),.in1(in1),.in2(in2),.in3(in3),.an(an),.sseg(sseg));


//a counter should tick slower than the clock used rotate active segments
endmodule

