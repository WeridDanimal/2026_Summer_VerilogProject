`timescale 1ns / 1ps
/*
purpose: fixing issues getting inputs from buttons.

if i can make the calculator button change states as indicated by LEDs, then I can add support it
for all other buttons, then make sure that operands A and B can be incremented/decremented correctly
*/
module button_prototype(input clk, input reset,
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
reg[15:0] opA, opB,sum;
reg [1:0] a_digitplace, b_digitplace; //keeps track of which digit will be modified in operand A and B
wire [15:0] calcData;

reg[15:0] isolatedInput;
wire [15:0] mask=16'hFFFF-(15<<(a_digitplace*4));
wire [15:0] maskB=16'hFFFF-(15<<(b_digitplace*4));

wire calcDebounce, upDebounce, downDebounce, leftDebounce, rightDebounce;
wire calcPressed, calcReleased;
button_debouncer cd(.clk(clk),.PB(calcButton),.PB_down(calcDebounce));
button_debouncer ud(.clk(clk),.PB(up),.PB_down(upDebounce));
button_debouncer dd(.clk(clk),.PB(down),.PB_down(downDebounce));
button_debouncer ld(.clk(clk),.PB(left),.PB_down(leftDebounce));
button_debouncer rd(.clk(clk),.PB(right),.PB_down(rightDebounce));


always@(*)
begin
    if(calcDebounce)
        begin
            case(curr_calcstate)
                2'b00:
                    next_calcstate=2'b01;
                2'b01:
                    next_calcstate=2'b10;
                2'b10:
                    next_calcstate=2'b11;
                2'b11:
                    next_calcstate=2'b01;
             endcase
        end
     else
        next_calcstate=curr_calcstate;
end

always@(posedge clk)
begin
    case(curr_calcstate)
        2'b00://default state
            begin
            opA=0;
            opB=0;
            sum=0;
            end
        2'b01:
            begin
            
            if(leftDebounce)
                a_digitplace=a_digitplace+1;
            if(rightDebounce)
                a_digitplace=a_digitplace-1;
            
            if(upDebounce)
                begin
                isolatedInput=opA>>(a_digitplace*4); 
                isolatedInput=16'h000F&(isolatedInput+1); 
                opA=(opA& mask  )    |(isolatedInput)<<(a_digitplace*4) ;
                end
            else
                opA=opA;
                
            
            if(downDebounce)
                begin
                isolatedInput=opA>>(a_digitplace*4);
                isolatedInput=16'h000F&(isolatedInput-1);
                opA=(opA& mask  ) |(isolatedInput)<<(a_digitplace*4) ;  
                end
            else
                opA=opA;
            end

                
        2'b10:
            begin
                if(leftDebounce)
                    b_digitplace=b_digitplace+1;
                if(rightDebounce)
                    b_digitplace=b_digitplace-1;
                 
                if(upDebounce)
                    begin
                    isolatedInput=opB>>(b_digitplace*4); 
                    isolatedInput=16'h000F&(isolatedInput+1); //in theory this should erase overflow
                    opB=(opB& maskB  )    |(isolatedInput)<<(b_digitplace*4) ;
                    end
                else
                    opB=opB;
                    
                    
                 if(downDebounce)
                    begin
                    isolatedInput=opB>>(b_digitplace*4); 
                    isolatedInput=16'h000F&(isolatedInput-1); //in theory this should erase overflow
                    opB=(opB& maskB  )    |(isolatedInput)<<(b_digitplace*4) ;
                    end
                else
                    opB=opB;        
                         
                opA=opA;
            end
        2'b11:
            sum=opA+opB; //does not support other calculator modes
    endcase
end



//calculator state transition
always@(posedge clk or posedge reset)
begin
    if(reset)
        begin
        curr_calcstate<=0;
        //opA<=0;
        end
    else
        curr_calcstate<=next_calcstate;
end

//assign calcData=opA;
assign calcData= curr_calcstate[1]?  (curr_calcstate[0]? sum:opB): (curr_calcstate[0]?   opA: opA); 
//expected behavior: alternate visible numbers

assign opA_LED=curr_calcstate[0]; //need to know if at correct state
assign opB_LED=curr_calcstate[1];
//assign opA_LED=a_digitplace[0];
//assign opB_LED=a_digitplace[1];
assign sum_LED=curr_calcstate[0]&curr_calcstate[1];
//assign sum_LED=upDebounce;
    
segment_conversion s0(.bcd(calcData[3:0]),.segOut(in0));
segment_conversion s1(.bcd(calcData[7:4]),.segOut(in1));
segment_conversion s2(.bcd(calcData[11:8]),.segOut(in2));
segment_conversion s3(.bcd(calcData[15:12]),.segOut(in3));

display_controls d1(.clk(segclk),.reset(reset),.in0(in0),.in1(in1),.in2(in2),.in3(in3),.an(an),.sseg(sseg));


endmodule
/*
operand A looks fully functional

operand B
    error 1:
        unable to visibly change any other digits besides digit 2. but inputs 
        suggest digit places are being shifted
*/

