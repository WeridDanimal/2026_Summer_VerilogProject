`timescale 1ns / 1ps

module calculator_tb;

reg clk,reset;
reg [2:0] opcode;
reg calcButton;
reg up,down,left,right;
wire aLED,bLED,sumLED;
wire [15:0] aVAL;

prototype_module p1(.clk(clk), .reset(reset), .opcode(opcode),.calcButton(calcButton),
.up(up),.left(left),.right(right),.down(down),
.opA_LED(aLED), .opB_LED(bLED), .sum_LED(sumLED),
.aVal(aVAL));

initial    
begin
    clk=0; reset=0; calcButton=0; opcode=0; up=0; down=0;right=0;left=0;
    #15 reset=1;
    #10 reset=0;
    #10 calcButton=1;
    #15 calcButton=0;
    
    #10 up=1;
    #10 up=0;
    #10 up=1;
    #10 up=0;
    #10 up=1;
    #10 up=0;
    #10 up=1;
    #10 up=0;
    #10 up=1;
    #10 up=0;
    #10 up=1;
    #10 up=0;
    
    #100 left=1;
    #10 left=0;
    #10 down=1;
    #10 down=0;
    
    #100 left=1;
    #10 left=0;
    #10 up=1;
    #10 up=0;
    
    #100 left=1;
    #10 left=0;
    #10 down=1;
    #10 down=0;
end
always #10 clk=~clk;
//always #15 calcButton=~calcButton;

endmodule

/*
testing indicates opcode switching only correctly resets state machine when in sync with the clock

*/

