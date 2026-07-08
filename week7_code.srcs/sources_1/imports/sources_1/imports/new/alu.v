`timescale 1ns / 1ps


module alu

#(parameter ADD=4'b0001, parameter AND=4'b0101, parameter BR=4'b0000,
parameter JMP=4'b1100, parameter JSRR=4'b0100, parameter LDB=4'b0010,
parameter LDW=4'b0110, parameter LEA=4'b1110, parameter RTI=4'b1000,
parameter SHF=4'b1101, parameter STB=4'b0011, parameter STW=4'b0111,
parameter TRAP=4'b1111, parameter XOR=4'b1001)

( input reset,
  input clock,
  

  input validInputs,//tells ALU that decoder passed valid items
  input [3:0] opcode,
  input [15:0] opA, input [15:0] opB, 
  output reg [15:0] alu_result,
  output validOutput, //tells memory that sum is not junk
  output agex_ready,
  input mem_ready,
  input [1:0] shiftType
    );

reg valid;
assign agex_ready=!valid|mem_ready;
//case 1: mem is busy and input data is junk: do nothing.
//case 2: input data is valid, but memory is busy. i think it shouldn't be able to do anything 
assign validOutput=valid;

always@(posedge clock or posedge reset)
begin
    if(reset)
        begin
        alu_result=0;
        valid=0;
        end
    else
    begin
        if(agex_ready)
        begin
            valid=validInputs;
            $display("ALU is computing with %h and %h",opA,opB);
            if(validInputs)
            begin
                case(opcode)
                
                    ADD:
                    begin
                        alu_result=opA+opB;
              
                    end
                 AND:
                    begin
                        alu_result=opA&opB;
                    end 
                 XOR:
                    begin
                        alu_result=opA^opB;
                    end
                 
                 SHF:
                    begin
                        $display("==============================");
                        $display("processing shift instruction, opA=%h, opB=%h", opA, opB);
                        case(shiftType)
                        
                            2'b00://left shift
                                alu_result=opA<<opB;            
                            2'b01://logical right shift
                                alu_result=opA>>opB;
                            2'b11:
                                alu_result=(16'hFFFF<<(16-opB)) | (opA>>opB);
                            default:
                                alu_result=opA;
                        endcase
                    end   
                 
                 
                 LDB: //need to set up a usable amount of memory space to test this....
                    begin
                        alu_result=opA+opB; //reminder, opA should equal baseReg contents, opB=address offset
                    end
                 
                 STB:
                    alu_result=opA+opB;
                 
                 
                  //these 2 commands might cause a problem.
                 LDW:
                    begin
                    alu_result=opA+(opB<<1);
                    
                    end
                 
                 STW:
                    begin
                    alu_result=opA+(opB<<1);
                    end
                  
                
                 default://where all unused or invalid opcodes go
                    begin
                    alu_result=0;
                    end
                endcase
            end
        end
    end
end    
    
endmodule
