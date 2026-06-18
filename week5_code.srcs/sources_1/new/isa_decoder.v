`timescale 1ns / 1ps


/*
purpose: take some character/(string? line?) input and determine these things:
    1. instruction type
    2. operand A
    3. operand B
    4. operand C
    5. "junk" if line does not follow ISA syntax
*/

module isa_decoder
#(parameter ADD=4'b0001, parameter AND=4'b0101, parameter BR=4'b0000,
parameter JMP=4'b1100, parameter JSRR=4'b0100, parameter LDB=4'b0010,
parameter LDW=4'b0110, parameter LEA=4'b1110, parameter RTI=4'b1000,
parameter SHF=4'b1101, parameter STB=4'b0011, parameter STW=4'b0111,
parameter TRAP=4'b1111, parameter XOR=4'b1001)


(
 input reset,
 input clock,
 
 //inputs from FETCH stage
 input valid_inputs,    //tells decode that fetch gives decode valid data. single bit
 input [15:0] machineCode, 
 input [15:0] SR2,          //note: this has the CONTENTS of SR2
 
 output reg [2:0] DR,       //since these ones are regs, it should mean contents preserved even in a stall right?
 output reg [2:0] BaseR,
 output reg [15:0] offset,
 
 
 
 input agex_ready,       //tells decode that agex_ready has room to take decode's outputs
 output decode_ready,    //
 
 output valid_outputs,   //tells system that its output is not junk
 output reg wr_en0,
 output reg wr_en1,
 output reg rd_en0,
 output reg rd_en1
    );

wire [4:0] imm5=machineCode[4:0]; //5-bit immediate value from the machine code.
wire [15:0] sext_5bit= machineCode[4]? (16'hFFE0|imm5):(16'd0|imm5); //need multiple sign-extend versions?

reg valid;
wire decode_ready_internal=!valid|agex_ready;
assign decode_ready=decode_ready_internal;
assign valid_outputs=valid;

always@(posedge clock or posedge reset)
begin

    if(reset)
    begin
        DR<=0;
        BaseR<=0;
        offset<=0;
        valid<=0;
        
        wr_en0<=0;
        wr_en1<=0;
        rd_en0<=0;
        rd_en1<=0;
    end
    else 
    begin
        if(decode_ready_internal)
        begin
            valid<=valid_inputs;//this tells decoder if fetch gave it valid data
            $display("DECODE phase is processing instruction=%h",machineCode);
            $display("is DECODER inputs valid?=",valid_inputs);
            if(valid_inputs) //narrowed source of bug to valid_inputs. why did it not generate a valid_input for instruction 2?
                begin    
                DR<=machineCode[11:9];
                BaseR<=machineCode[8:6];
                case(machineCode[15:12])
                     ADD:
                        begin
                            offset<=machineCode[5]? sext_5bit:SR2;
                            
                            wr_en0<=0;
                            wr_en1<=0;
                            rd_en0<=0;
                            rd_en1<=0; 
                        end
                     AND:
                        begin
                            offset<=machineCode[5]? sext_5bit:SR2;
                            
                            wr_en0<=0;
                            wr_en1<=0;
                            rd_en0<=0;
                            rd_en1<=0; 
                        end 
                     XOR:
                        begin
                            offset<=machineCode[5]? sext_5bit:SR2;
                            
                            wr_en0<=0;
                            wr_en1<=0;
                            rd_en0<=0;
                            rd_en1<=0; 
                        end
                     SHF:
                        begin
                            offset<=machineCode[3:0];
                            
                            wr_en0<=0;
                            wr_en1<=0;
                            rd_en0<=0;
                            rd_en1<=0; 
                        end   
                     
                     
                     LDB: //need to set up a usable amount of memory space to test this....
                        begin
                        //self-note: makes offset negative or positive depending on bit 5      
                        
                        /*    
                        addr_offset= machineCode[5]? machineCode[5:0]|16'hFFC0: machineCode[5:0];
                        offset=addr_offset+registers[baseR];
                        */
                        
                        wr_en0<=1;
                        wr_en1<=0;
                        rd_en0<=0;
                        rd_en1<=0;
                        
                        
                        end
                     /*
                     //these 2 commands are going to cause a problem.
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
                        offset<=0;
                        end
                    endcase
                    
                    
                    $display("obtained DR=%d, Base Reg=%d, offset=%h",DR,BaseR,offset);
                    end
            end 
    end
end  


endmodule
