`timescale 1ns / 1ps
/*
individual comparator module.

module needs to know what type of comparison it must perform(0=ascending, 1=descending)

i think module should also generate a signal that indicates a swap is required, indicating that the entire array is not sorted

if all modules show no swap done, then indicates half of the brick sort is finished

it might(?) be possible to swap elements within here

*/

module sorter_comparator(
    input mode,
    input [3:0] A_in, input [3:0] B_in, output [3:0] A_out, output [3:0] B_out,
    output unsorted //tells the system that one of the array's halves failed the sorting check
    );
      
assign A_out=mode? ( (A_in<B_in)?   B_in:A_in ): ((A_in>B_in) ? B_in:A_in);
assign B_out=mode? (  (A_in<B_in)?  A_in:B_in):  ((A_in>B_in)? A_in:B_in);

assign unsorted= mode? ( (A_in<B_in)? 1:0):     ( (A_in>B_in)? 1:0);

endmodule
