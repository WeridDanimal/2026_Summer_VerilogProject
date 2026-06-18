`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2026 09:50:55 AM
// Design Name: 
// Module Name: rehearsal
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

//DO NOT FORGET THIS PART NAME: xc7a35tcpg236-1

//do not upload to FPGA board yet, limited to simulation runs only

//implement AND, OR, XOR
//to see results of these gates, enable one of the Z assignments, disable the rest

module rehearsal(A,B,Z
    );

input A,B;
output Z;
 

//assign Z=A&&B; //AND Gate, Passed the test
//assign Z=A||B;//OR Gate, Passed the test
assign Z=A^B; //XOR Gate, Passed the test


//Day ?? has an interesting one that I can use the FPGA for
//a Counter...

endmodule
