`timescale 1ns / 1ps
/*
Purpose: Near-identical copy of CPU top module except UARTs are replaced with inputs for
testbench simplicity

*/

module cpu_debug#(parameter ADD=4'b0001, parameter AND=4'b0101, parameter BR=4'b0000,
parameter JMP=4'b1100, parameter JSRR=4'b0100, parameter LDB=4'b0010,
parameter LDW=4'b0110, parameter LEA=4'b1110, parameter RTI=4'b1000,
parameter SHF=4'b1101, parameter STB=4'b0011, parameter STW=4'b0111,
parameter TRAP=4'b1111, parameter XOR=4'b1001)

(   input clock,
    input reset,
    input transmit,
    input [7:0] incomingData,
    input uart_receive_finish, //represents a complete byte being received 
    input [7:0] sw,
    output [15:0] led,
    output decodeSignal,
    output aluSignal,
    output memSignal,
    output [15:0] encodedInstruct,
    
    output decodeValidOut,
    output aluValidOut,
    output [1:0] cpu_state
    );
    
   reg [1:0] current_cpuState, next_cpuState;   
   
   //instantiating button debouncers
   wire transmit_level, transmit_pulse;
   debouncer DEBOUNCE (
        .clk(clock),
        .PB(transmit),
        .PB_down(transmit_pulse)
        );  
   wire reset_pulse;
   debouncer DEBOUNCE_2 (
        .clk(clock),
        .PB(reset),
        .PB_down(reset_pulse)
        );
   
    
      wire [15:0] receivedInstruction; //should i leave it as a wire or reg?
    wire decode_ready, agex_ready, mem_ready ;//signals authorizing procession to next stage

    wire fetchOut_valid, decodeOut_valid, agexOut_valid, memOut_valid;
    reg[2:0] nzpBits;
    reg[15:0] registers[0:7];
    
    wire [2:0] DR, baseReg;
    wire [15:0] offset, read_address,write_address;      //offset: can be used in either math or address calculation
    wire [15:0] agex_result;
    wire [1:0] write_en, read_en;
    wire [15:0] mem_result;

    //SUB-MODULE INSTANTIATIONS
    instruction_receiver receiver(clock,reset,uart_receive_finish , incomingData, receivedInstruction, decode_ready,fetchOut_valid);
    
    isa_decoder decoder(reset,clock,  fetchOut_valid,receivedInstruction, registers[receivedInstruction[2:0]],DR,baseReg,
    offset,agex_ready,decode_ready, decodeOut_valid,    
    write_en[0], write_en[1], read_en[0], read_en[1]
    );
    
    alu     calculator(reset,clock, decodeOut_valid, receivedInstruction[15:12],registers[baseReg],offset,agex_result,
    agexOut_valid,agex_ready,mem_ready, receivedInstruction[5:4]);
    
    
    memhandler_experimental mem(clock,reset,agexOut_valid,mem_ready, 
    write_en[0], write_en[1], read_en[0], read_en[1],
    regFile_output, registers[DR], mem_result, regFile_writeInput, trueWriteEn,
    memAddress, agex_result, memOut_valid);    
    /*
    mem_handler mem(clock,reset,agexOut_valid,mem_ready, 
    write_en[0], write_en[1], read_en[0], read_en[1],
    regFile_output, registers[DR], mem_result, regFile_writeInput, trueWriteEn,
    memAddress, agex_result, memOut_valid);
    */
    wire [7:0] regFile_output, regFile_writeInput;
    wire [15:0] memAddress;
    wire trueWriteEn;
    
    //SELF NOTE: REDESIGN THIS TO ONLY TAKE READ AND WRITE FROM MEM, NOT DECODE. AND MEM SHOULD CLEAR 
    //READ/WRITE FLAGS WHENEVER UNNEEDED
    regFile_redesign memoryBank(clock,reset,trueWriteEn, regFile_writeInput,regFile_output, memAddress);
    //ONLY MEM CAN PASS ADDRESSES TO THE REGISTER FILE
    //unsure if current design even makes it possible to have both read/write requests from different instructions
    
    assign decodeSignal=decode_ready;
    assign aluSignal=agex_ready;
    assign memSignal=mem_ready;
    
    assign decodeValidOut=decodeOut_valid;
    assign aluValidOut=agexOut_valid;

    //self reminder that this is a combinatorial circuit.
    
    
    always@(*)
    begin
    
    end
    
    //reg [15:0] resultBuffer;
    
    always@(posedge clock or posedge reset)
    begin
        if(reset)
            begin
            current_cpuState<=0;
            registers[0]<=0;
            registers[1]<=0;
            registers[2]<=0;
            registers[3]<=0;
            registers[4]<=0;
            registers[5]<=0;
            registers[6]<=0;
            registers[7]<=0;
            end
        else
            begin
            current_cpuState<=next_cpuState;
 
            
            if(agexOut_valid)
                    begin
                    $display("=============================================");
                    $display("AGEX authorized to store to registers");
                        case(receivedInstruction[15:12])
                                ADD:    //ADD
                                    registers[DR]<=agex_result;
                                AND:    //AND
                                    registers[DR]<=agex_result;
                                LEA:    //LEA
                                    registers[DR]<=agex_result;
                                SHF:    //SHF
                                    registers[DR]<=agex_result;
                                XOR:    //XOR
                                    registers[DR]<=agex_result;
                                default:
                                    registers[DR]<=registers[DR];
                        endcase
                    end
             
             if(memOut_valid)
                begin
                    case(receivedInstruction[15:12])
                                LDB:    //LDB
                                    registers[DR]<=mem_result;
                                LDW:
                                    registers[DR]<=mem_result;
                                default:
                                    registers[DR]<=registers[DR];
                    endcase
                end     
            
            
            
            end
    end
    
    assign encodedInstruct=receivedInstruction; //LED serves as debugging tool when testing real hardware
    //assign led=agex_result;
    assign led=mem_result;
    assign cpu_state=current_cpuState;
    
endmodule


/*
notes:
-this type of cpu has a fatal design flaw.
without the manual button presses to get the next instruction, it does not actually know if one of the 
register dependencies are outdated or not

*/

/*
bug report:
i think i am running into same design problem. i dont think i've actually figured out how to 
toggle ready signals for each stage
*/