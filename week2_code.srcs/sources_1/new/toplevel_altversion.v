`timescale 1ns / 1ps

/*
challenge: designing a "calculator" where buttons control a digit's position and decimal value.
central button should toggle which operand is being configured
3 levers to determine type of mathematical function:
    currently supported:
        ADD
        SUB
 
Leftmost switch should be used as a reset toggle


Test 1: evaluating functionality of digit controls

*/

/*
WARNING: does not currently have a debouncer to syncrhonize button inputs

*/
module toplevel_altversion(input clk, input reset,
    input[2:0] opcode, output[3:0] an, output [6:0] sseg,
    input calcButton,
    input left,right,up,down,
    output opA_LED, output opB_LED, sum_LED);//debugging tool to confirm which operand is being modified
    
reg [1:0] currstate, nextState;
wire segclk;
wire calc_clk;
wire [6:0] in0,in1,in2,in3;
reg[1:0] curr_calcstate, next_calcstate;

slow_clk slow(.clk(clk), .reset(reset), .clk_out(segclk));
second_clk cslow(.clk(clk),.reset(reset),.clk_out(calc_clk));
reg[15:0] opA, opB,sum;
reg [1:0] a_digitplace, b_digitplace; //keeps track of which digit will be modified in operand A and B
wire [15:0] calcData;


//resets calculator state if opcode ever changes
always@(opcode)
begin
    next_calcstate=2'b00;
end

//state transition when the calculator button is pressed
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


//giant combination block that either controls operand A, operand B or sum's register value
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
                    opA= (opA & ~(16'hFFFF<<(4*a_digitplace)))|(isolatedInput<<(4*a_digitplace));
                end
            if(down)
                begin
                    isolatedInput=opA>>(a_digitplace*4);
                    isolatedInput=isolatedInput-1;
                    opA= (opA & ~(16'hFFFF<<(4*a_digitplace)))|(isolatedInput<<(4*a_digitplace));
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
                    opB= (opB && ~(16'hFFFF<<(4*b_digitplace)))|(isolatedInput<<(4*b_digitplace));
                end
                if(down)
                    begin
                        isolatedInput=opB>>(b_digitplace*4);
                        isolatedInput=isolatedInput-1;
                        opB= (opB && ~(16'hFFFF<<(4*b_digitplace)))|(isolatedInput<<(4*b_digitplace));
                    end    
                    
            end
        2'b11:
            begin
                sum=opA+opB;
            end
    endcase
end



//calculator state transition
always@(posedge calc_clk or posedge reset)
begin
    if(reset)
        next_calcstate<=0;
    else
        curr_calcstate<=next_calcstate;
end

assign calcData= curr_calcstate[1]?  (curr_calcstate[0]? sum:opB): (curr_calcstate[0]?   opA: opA);

assign opA_LED=curr_calcstate[0];
assign opB_LED=curr_calcstate[1];
assign sum_LED=curr_calcstate[0]&curr_calcstate[1];

    
segment_conversion s0(.bcd(calcData[3:0]),.segOut(in0));
segment_conversion s1(.bcd(calcData[7:4]),.segOut(in1));
segment_conversion s2(.bcd(calcData[11:8]),.segOut(in2));
segment_conversion s3(.bcd(calcData[15:12]),.segOut(in3));

display_controls d1(.clk(segclk),.reset(reset),.in0(in0),.in1(in1),.in2(in2),.in3(in3),.an(an),.sseg(sseg));


endmodule


