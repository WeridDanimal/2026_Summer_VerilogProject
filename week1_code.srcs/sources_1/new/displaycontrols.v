`timescale 1ns / 1ps

module displaycontrols(
    input clk, input reset,
    input[6:0] in0, input[6:0] in1, input[6:0] in2, input[6:0] in3,//contains values to be displayed on all digits
    output reg[3:0] an, output reg[6:0] sseg //an=determines which digit is active. sseg=output for 7 segments for current active digit
    );
    
    
    reg [1:0] currState, nextState;
    //block 1: handles FSM logic for the digit display
    always@(*)
    begin
        case(currState)
            2'b00:nextState=2'b01;
            2'b01:nextState=2'b10;
            2'b10:nextState=2'b11;
            2'b11:nextState=2'b00;
            default:nextState=2'b00; //if my understanding is correct, when nothing is done or reset is pressed, defaults to this
        endcase
    end
    
    //block 2: pairs segment controls with digit given current state
    always@(*)
    begin
        case(currState)
            2'b00:sseg=in0;
            2'b01:sseg=in1;
            2'b10:sseg=in2;
            2'b11:sseg=in3;
            default: sseg=7'd111_1111; //future proofing, for initial or reset states
        endcase
        
        case(currState)
            2'b00: an=4'b1110;
            2'b01: an=4'b1101;
            2'b10: an=4'b1011;
            2'b11: an=4'b0111;
            default: an=4'b1111; //no digits are on in this extreme case
        endcase
    end
    
    //controls state transition
    always@(posedge clk or posedge reset) //asynchronous resetting
    begin
        if(reset)
            currState<=2'b00;
        else    
            currState<=nextState;
    end
endmodule



