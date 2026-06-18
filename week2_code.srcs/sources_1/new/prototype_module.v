`timescale 1ns / 1ps


/*
prototype to create logic to handle state transition and determining which mode/operand to show

*/
module prototype_module(input clk, input reset,
    input[2:0] opcode,
    input calcButton,
    input up,down,left,right,
    output opA_LED, output opB_LED, sum_LED,
    output [15:0] aVal);

reg[1:0] curr_calcstate, next_calcstate;//stores information about main calculator FSM
reg [1:0] a_digitplace, b_digitplace; //keeps track of which digit will be modified in operand A and B

reg[15:0] opA, opB,sum;

always@(opcode)
begin
    next_calcstate=2'b00;
end


always@(posedge calcButton)
begin
    if(calcButton)
    begin   
        case(curr_calcstate)
            2'b00: next_calcstate=2'b01;
            2'b01: next_calcstate=2'b10;
            2'b10: next_calcstate=2'b11;
            2'b11: next_calcstate=2'b01;
        endcase
    end
end


reg [3:0] isolatedInput;

always@(*)
begin
    case(curr_calcstate)
        2'b00:
            begin
                opA=0;
                opB=0;
                sum=0;
                a_digitplace=0;
                b_digitplace=0;
            end
        2'b01:
            begin
            if(left)
                a_digitplace=a_digitplace+1;
            if(right)
                a_digitplace=a_digitplace-1;
            
            if(up)
                begin
                    //an operand's digit is isolated using the digit_place reg that is shifted by some multiple of 4
                    isolatedInput=opA>>(a_digitplace*4);
                    isolatedInput=isolatedInput+1;
                    opA= (opA & ~(16'hFFFF<<(4*a_digitplace)))+(isolatedInput<<(4*a_digitplace));
                end
            if(down)
                begin
                    isolatedInput=opA>>(a_digitplace*4);
                    isolatedInput=isolatedInput-1;
                    opA= (opA & ~(16'hFFFF<<(4*a_digitplace)))+(isolatedInput<<(4*a_digitplace));
                end
            
            end
        2'b10:
            begin
                if(left)
                    b_digitplace=b_digitplace+1;
                if(right)
                    b_digitplace=b_digitplace-1;
                    
                if(up)
                begin
                    //an operand's digit is isolated using the digit_place reg that is shifted by some multiple of 4
                    isolatedInput=opB>>(b_digitplace*4);
                    isolatedInput=isolatedInput+1;
                    opB= (opB && ~(16'hFFFF<<(4*b_digitplace)))+(isolatedInput<<(4*b_digitplace));
                end
                if(down)
                    begin
                        isolatedInput=opB>>(b_digitplace*4);
                        isolatedInput=isolatedInput-1;
                        opB= (opB && ~(16'hFFFF<<(4*b_digitplace)))+(isolatedInput<<(4*b_digitplace));
                    end    
                    
            end
        2'b11:
            begin
                sum=opA+opB;
            end
    endcase
end


always@(posedge clk or posedge reset)
begin
    if(reset)
        next_calcstate<=0;
    else
        curr_calcstate<=next_calcstate;
end

assign opA_LED=curr_calcstate[0];
assign opB_LED=curr_calcstate[1];
assign sum_LED=curr_calcstate[0]&curr_calcstate[1];
assign aVal=opA;

endmodule

/*
button failed to change anything

hypotheses:
    1. the button works on an inverted logic-->so maybe it works on a neg-edge logic
    2. the state transition should depend on a clock and not the button presses
    3. the lack of button de-bouncing caused inputs to be missed

*/
