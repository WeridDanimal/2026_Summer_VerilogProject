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
                 
                 /*
                 LDB: //need to set up a usable amount of memory space to test this....
                    begin
                    //self-note: makes offset negative or positive depending on bit 5          
                    addr_offset= machineCode[5]? machineCode[5:0]|16'hFFC0: machineCode[5:0];
                    read_address=addr_offset+registers[baseR];
                    $display("read address calculated=",read_address);
                    $display("read data=",read_data);
                    internal_result=read_data[7]? 16'hFF00|read_data: read_data;
                    result<=internal_result;
                    registers[DR]<=internal_result;
                    
                    end
                 
                 /* these 2 commands are going to cause a problem.
                 LDW:
                    begin
                    addr_offset= machineCode[5]? machineCode[5:0]|16'hFFC0: machineCode[5:0];
                    read_address=addr_offset+registers[baseR];
                    registers[DR][7:0]=read_data;
                    read_address=read_address+1;
                    registers[DR][15:8]=read_data;
                    result=registers[DR];
                    
                    end
                 
                 STW:
                    begin
                    addr_offset= machineCode[5]? machineCode[5:0]|16'hFFC0: machineCode[5:0];
                    write_address=addr_offset+registers[baseR];
                    wr_en=1;
                    write_data=registers[DR]& 16'h00FF;
                    write_data=(registers[DR]& 16'hFF00) >>8;
                    wr_en=0;
                    
                    end
                  
                 
                 STB: //since addresses store 1 byte, you need to isolate halves for word-size memory operations
                    begin
                    $display("confirming attempt to write");
                    addr_offset= machineCode[5]? machineCode[5:0]|16'hFFC0: machineCode[5:0];
                    write_address=addr_offset+registers[baseR];
                    wr_en=1;
                    write_data=registers[DR]& 16'h00FF;
                    wr_en=0;
                    result<=write_data;
                    end
                 */
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
