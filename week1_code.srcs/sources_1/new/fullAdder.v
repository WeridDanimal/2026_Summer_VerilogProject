`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2026 02:51:54 PM
// Design Name: 
// Module Name: fullAdder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fullAdder(A,B,Carry_in,Carry_out,Sum
    );
input A,B,Carry_in;
output Carry_out,Sum;


//the Sum equation can't be simplified because of its 
//k-mapping
//note, a single & is fine because these are singular bit inputs
assign Sum=(A&B&Carry_in)|(A& ~B & ~Carry_in)|(~A&~B&Carry_in)|(~A&B&~Carry_in); 
//side note, the better option is XOR'ing all bits, but I do not remember why. so above line is functionally same but less
//efficient
assign Carry_out=(A&B)|(Carry_in&B)|(Carry_in&A);//no matter what, can only be reduced to 3 terms

endmodule

