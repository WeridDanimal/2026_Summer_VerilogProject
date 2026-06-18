`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2026 10:44:42 AM
// Design Name: 
// Module Name: simple_tb
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


module simple_tb;

reg a,b; //the nature of the testbench requires such that a and b are regs
wire z; //we don't need to store output, so z is just a wire
rehearsal testLogs(.A(a),.B(b),.Z(z));
initial
    begin
    
        #50
        a=0;b=0;
        #50
        a=0;b=1;
        #50
        a=1;b=0;
        #50
        a=1;b=1;
    
    end
   
endmodule
