`timescale 1ns / 1ps


module isa_tb;

reg reset, readyButton;
reg [15:0] machineCode;
reg clock;
wire [15:0] result;

isa_decoder andTester(machineCode,reset,clock,readyButton,result);
initial
begin

    //test 1: execute ADD R1,R1,xF.     expected result, R1=xF. result=x000F
    reset=0; readyButton=0; machineCode=16'h126F; clock=0;
    #5 reset=1;
    #5 reset=0;
 
    #5 readyButton=1;
    #5 readyButton=0;
    
    
    
    //test 2: execute ADD R1,R1, x1.    expected result, R1=x0010   passed
    #5 machineCode=16'h1261; readyButton=1;
    #5 readyButton=0;
    
    //test 3: execute ADD R2,R1,R1.     expeted  result, R2=x0020   passed
    #5 readyButton=1; machineCode=16'h1441;
    #5 readyButton=0;
    
    //test 4: execute ADD R2,R2,#0      expected result, R2=x0020   passed
    #5 machineCode=16'h14a0; readyButton=1;
    #5 readyButton=0;
    
    //test 5: execute ADD R3,R2,x1F     expected result, R3=x001f   passed
    #5 machineCode=16'h16bf; readyButton=1;
    #5 readyButton=0;
    
    
    //test 6: AND R4,R3, X00            expected result, R4=x0000   passed
    #5 machineCode=16'h58e0; readyButton=1;
    #5 readyButton=0;
    
    //test 7: XOR R5,R3,R3              expected result, R5=x0000   passed
    #5 readyButton=1; machineCode=16'h9ac3;
    #5 readyButton=0;
    //test 8: LSHF R5, R1, #4                    result, R5=x0100
    #5 readyButton=1; machineCode=16'hda44;
    #5 readyButton=0;
    
    //test 9: RSHFL R7, R3, #3          expected result, R7= x0003  passed
    #5 machineCode=16'hded3; readyButton=1;
    #5 readyButton=0; 
    
    //test 10:  XOR R6,R6, x1f          expected result, R6= xFFFF  passed
    #5 machineCode=16'h9dbf; readyButton=1;
    #5 readyButton=0;
    
    //test 11: AND R6,R6, x1a           expected result, r6=xFFFa   passed
    #5 machineCode= 16'h5dba; readyButton=1;
    #5 readyButton=0;
    
    //test 12: RSHFA R6,R6,#2           expected result, r6=xFFFE   passed
    #5 machineCode= 16'hddb2; readyButton=1;
    #5 readyButton=0;
    
    //test 13: LDB R0, R5, #0           expected result, R0=0000
    $display("==================================================");
    $display("test 13 performed");
    #5 machineCode= 16'h2140; readyButton=1;
    #5 readyButton=0;
    
    $display("==================================================");
    $display("test 14 performed");
    //test 14: STB R6, R5,#0            expected result, mem[R5]=xFE
    #5 machineCode= 16'h3d40; readyButton=1;
    #5 readyButton=0;
    
    $display("test 15 performed. reloading address");
    //test 15: LBD R0, R5,#0            expected result, R0=xFFFa
    #5 machineCode= 16'h2140; readyButton=1;
    #5 readyButton=0;
      
  
    //test ?? STW
    
    //test ?? LDW ??,??,??
    
end

always #5 clock=~clock;
endmodule


/*
debug logs:
ADD passed the test
XOR passed the test




*/