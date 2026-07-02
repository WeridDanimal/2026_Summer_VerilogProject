`timescale 1ns / 1ps

module message_tb;

reg clock, reset, transmitButton, rx;
wire tx;
wire [1:0] stateOutput;
wire [4:0] charIndex;
wire [7:0] charRead;
message_transmitter_test troubleshoot(clock, reset, transmitButton,rx,tx,stateOutput, charIndex, charRead);







initial
    begin
    clock=0; reset=0; transmitButton=0;
    #5 reset=1;
    #5 reset=0;
    
    #5 transmitButton=1;
    #5 transmitButton=0;
    
    end

always #5 clock=~clock;
endmodule
