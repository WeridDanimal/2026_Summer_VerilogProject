`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2026 03:11:54 PM
// Design Name: 
// Module Name: fullAdd_tb
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


module fullAdd_tb;

//passed the test
reg a,b, cin; //the nature of the testbench requires such that a and b are regs
wire s,cout; //we don't need to store output, so z is just a wire
fullAdder addTest(.A(a),.B(b),.Carry_in(cin),.Carry_out(cout),.Sum(s));
initial
    begin
    
        #50
        a=0;b=0; cin=0;
        #50
        a=0;b=0; cin=1;
        #50
        a=0;b=1; cin=0;
        #50
        a=0;b=1; cin=1;
        #50
        a=1;b=0; cin=0;
        #50
        a=1;b=0; cin=1;
        #50
        a=1;b=1; cin=0;
        #50
        a=1;b=1; cin=1;
        
    
    end


endmodule
