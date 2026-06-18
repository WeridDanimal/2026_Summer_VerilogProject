`timescale 1ns / 1ps

module fourbit_adder(A,B, Sum,cin,clk, enable);
input clk,enable;
input [3:0] A,B;
input cin;
output [3:0] Sum;


//how do I instantiate modules again??
wire c0,c1,c2,c3;
wire [3:0] tempSum;

fullAdder bit0(.A(A[0]),.B(B[0]),.Carry_in(cin),.Carry_out(c0),.Sum(tempSum[0]));
fullAdder bit1(.A(A[1]),.B(B[1]),.Carry_in(c0),.Carry_out(c1),.Sum(tempSum[1]));
fullAdder bit2(.A(A[2]),.B(B[2]),.Carry_in(c1),.Carry_out(c2),.Sum(tempSum[2]));
fullAdder bit3(.A(A[3]),.B(B[3]),.Carry_in(c2),.Carry_out(c3),.Sum(tempSum[3]));

register_logic r1(clk, enable,tempSum,Sum);
/*

module RCA_4bits(
    input clk,
    input enable,
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [4:0] Q,
    output enable_led
    );
    
//i think i might have already coded a version of this before.
wire c1,c2,c3;
wire [4:0] temp;




fullAdder f0(A[0],B[0],Cin,temp[0],c1);
fullAdder f1(A[1],B[1],c1,temp[1],c2);
fullAdder f2(A[2],B[2],c2,temp[2],c3);
fullAdder f3(A[3],B[3],c3,temp[3],temp[4]); //a final carry of 0 implies no overflow?

register_logic r1(clk,enable,temp,Q); //temp should be fed into Q;

assign enable_led = enable; //<--that's only useful for the actual FPGA
endmodule



*/

endmodule
