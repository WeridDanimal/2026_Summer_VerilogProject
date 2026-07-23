`timescale 1ns / 1ps

/*
I think I will try to emulate some aspects of the NES hardware based on documentation I could find and understand

*/

module cpu_module(

    );

reg [15:0] PC;
reg [7:0] SP;//stack pointer
reg [7:0] accumulator;
reg [7:0] indexReg_X, indexRegY;    
    
endmodule
