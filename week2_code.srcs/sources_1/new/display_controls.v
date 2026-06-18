`timescale 1ns / 1ps


module display_controls(input clk, input reset,
input [6:0] in0, input[6:0] in1, input[6:0] in2, input [6:0] in3,
output reg[3:0] an,
output reg[6:0] sseg);
    
reg [1:0] currState, nextState;
    
    //main block to determine assignment to next state
    always@(*)
        case(currState)
            2'b00: nextState=2'b01;
            2'b01: nextState=2'b10;
            2'b10: nextState=2'b11;
            2'b11: nextState=2'b00;
            default: nextState=2'b00;//should only be triggered at a reset 
        endcase
    begin
    end    
    
    //block 2: determines which 7segments to display, based on current(?) state
    always@(*)
    begin
        case(currState)
            2'b00: sseg=in0;
            2'b01: sseg=in1;
            2'b10: sseg=in2;
            2'b11: sseg=in3;
            default: sseg=7'd111_1111;//in initial or reset state, no active segments
        endcase
        
        //i can only guess the lab instructions structured the block like this because it needs to sequentially
        //determine which segments to select, then determine which digit to turn on
        case(currState)
            2'b00: an=4'b1110; //state 0=digit 0 on
            2'b01: an=4'b1101; //state 1=digit 1 on
            2'b10: an=4'b1011; //state 2=digit 2 on
            2'b11: an=4'b0111; //state 3=digit 3 on
            default: an=4'b1111;//in initial or reset state, no active digits
        endcase     
    end

    //main logic block determining assignment for current state
    always@(posedge clk or posedge reset)
    begin
    
        if(reset)
            //begin
            //display("Reset triggered");//debug only
            currState<=2'b00;
            //end
        else
            //begin
                currState<=nextState;
            //end
    end
endmodule