`timescale 1ns / 1ps


//given two inputs of uniform size for 2 array elements and mode, determine where input A and input B are routed
//mode=0 means ascending, mode=1 means descending
module comparator #(parameter elementSize=8)
(   input mode,
    input [elementSize-1:0] A_in, input [elementSize-1:0] B_in, 
    output [elementSize-1:0] A_out, output [elementSize-1:0] B_out);
    
    assign A_out=mode? ( (A_in<B_in)?   B_in:A_in ): ((A_in>B_in) ? B_in:A_in);
    assign B_out=mode? (  (A_in<B_in)?  A_in:B_in):  ((A_in>B_in)? A_in:B_in);

    
endmodule
