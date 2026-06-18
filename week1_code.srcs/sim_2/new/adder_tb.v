`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2026 10:30:15 AM
// Design Name: 
// Module Name: adder_tb
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


module adder_tb;

reg [3:0] a,b;
reg c, clk, enable;
wire [3:0] s;

fourbit_adder fb_add(.A(a),.B(b),.cin(c),.Sum(s),.clk(clk),.enable(enable));

initial
    begin
        #50 clk=0;enable=1;
        
        #50
        a=4'b0000;b=4'b0000; c=1'b0; 
        #50
        a=4'b0000;b=4'b0000; c=1'b1;
        #50
        a=4'b0000;b=4'b0001; c=1'b0;
        #50
        a=4'b0000;b=4'b0001; c=1'b1;
        
        #50
        a=4'b0000;b=4'b0010; c=1'b0;
        #50
        a=4'b0000;b=4'b0010; c=1'b1;
        #50
        a=4'b0000;b=4'b0011; c=1'b0;    
        #50
        a=4'b0000;b=4'b0011; c=1'b1;
        
        #50
        a=4'b0000;b=4'b0100; c=1'b0;
        #50
        a=4'b0000;b=4'b0100; c=1'b1;
        #50
        a=4'b0000;b=4'b0101; c=1'b0;
        #50
        a=4'b0000;b=4'b0101; c=1'b1;
        
        #50
        a=4'b0000;b=4'b0110; c=1'b0;
        #50
        a=4'b0000;b=4'b0110; c=1'b1;
        #50
        a=4'b0000;b=4'b0111; c=1'b0;
        #50
        a=4'b0000;b=4'b0111; c=1'b1;
        
        #50
        a=4'b0000;b=4'b1000; c=1'b0;
        #50
        a=4'b0000;b=4'b1000; c=1'b1;
        #50
        a=4'b0000;b=4'b1001; c=1'b0;
        #50
        a=4'b0000;b=4'b1001; c=1'b1;
        
        #50
        a=4'b0000;b=4'b1010; c=1'b0;
        #50
        a=4'b0000;b=4'b1010; c=1'b1;
        #50
        a=4'b0000;b=4'b1011; c=1'b0;
        #50
        a=4'b0000;b=4'b1011; c=1'b1;
        
        #50
        a=4'b0000;b=4'b1100; c=1'b0;
        #50
        a=4'b0000;b=4'b1100; c=1'b1;
        #50
        a=4'b0000;b=4'b1101; c=1'b0;
        #50
        a=4'b0000;b=4'b1101; c=1'b1;
        
        #50
        a=4'b0000;b=4'b1110; c=1'b0;
        #50
        a=4'b0000;b=4'b1110; c=1'b1;
        #50
        a=4'b0000;b=4'b1111; c=1'b0;
        #50
        a=4'b0000;b=4'b1111; c=1'b1;
       
    end
    always #5 clk=~clk;
endmodule



/*
`timescale 1ns / 1ps


module tb_CLA_4bits;

reg [3:0] A,B;
reg clk,enable,Cin;
wire [4:0]Q;
wire outLed;

CLA_4bits c1(A,B,clk,enable,Cin,Q,outLed);

initial
begin
    #50;
    clk=0;enable=1;
    
    #50 A<=4'b0000; B<=4'b0101; Cin=0;
    #50 A<=4'b0101; B<=4'b0111; Cin=0;
    #50 A<=4'b1000; B<=4'b0111; Cin=1;
    #50 A<=4'b1001; B<=4'b0100; Cin=0;
    #50 A<=4'b1000; B<=4'b1000; Cin=1;
    #50 A<=4'b1101; B<=4'b1010; Cin=1;
    #50 A<=4'b1110; B<=4'b1111; Cin=0;
    

end
always #5 clk=~clk;

endmodule


*/