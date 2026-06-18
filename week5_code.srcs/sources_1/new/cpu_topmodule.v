`timescale 1ns / 1ps

/*
Purpose: a re-write of week 3/4's top module. This will more closely follow the traditional CPU instruction cycle.

Fetch, Decode, Address Generation/Execution(AGEX), Mem Access/Store

after analyzing use of register file, I realized the top module is fundamentally flawed for one reason: the decoder 
simply can't do memory accesses in one cycle, at least not by its previous design. 

i might also restructure the isa decoder.
from now on, the decoder will only parse register numbers when authorized. 
the math operations will be split into the ALU

self note: it appears I have unknowingly jumped right into pipelining. because i realized my second iteration of 
"ready signals" cannot function the way it is without either a dependency on next stage or some form of foolproof clearing
to prevent erroneous stage executions

however, with these changes, there is the fatal flaw of not being able to handle dependencies

*/
module cpu_topmodule

#(parameter FETCH=2'd0, parameter DECODE=2'd1, parameter AGEX=2'd2, parameter MEM=2'd3 )

(   input clock,
    input reset,
    input transmit,
    input [7:0] sw,
    input rx,
    output tx,
    output [15:0] led

    );
    
   reg [2:0] current_cpuState, next_cpuState;   
 
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
   
   
    //  instantiate uart_tx
    wire active, done;
    uart_tx TX (
        .i_Clock(clock),
        .i_Clocks_per_Bit('d100),
        .i_Tx_DV(transmit_pulse),
        .i_Reset(reset),
        .i_Tx_Byte(sw),
        .o_Tx_Serial(tx),
        .o_Tx_Active(active),
        .o_Tx_Done(done)
    );
    //  instantiate uart_rx
    wire dv;
    wire [7:0] rx_data;     //receiver
    uart_rx RX (
        .i_Clock(clock),
        .i_Clocks_per_Bit('d100),
        .i_Reset(reset),
        .i_Rx_Serial(rx),
        .o_Rx_DV(dv),
        .o_Rx_Byte(rx_data)
        );
        
   
    wire [15:0] receivedInstruction; //should i leave it as a wire or reg?
    wire decode_ready, agex_ready, mem_ready ;//signals authorizing procession to next stage

    wire fetchOut_valid, decodeOut_valid, agexOut_valid;
    reg[2:0] nzpBits;
    reg[15:0] registers[0:7];
    
    wire [2:0] DR, baseReg;
    wire [15:0] offset, read_address,write_address;      //offset: can be used in either math or address calculation
    wire [15:0] agex_result;
    reg write_en, read_en;
    

    
    //reg[15:0] PC; //<--unused. not sure how to integrate program counter yet.
    //basically means branching and jumps are unusuable
    
    instruction_receiver receiver(clock,reset,dv,rx_data, receivedInstruction, decode_ready,fetchOut_valid);
    
    isa_decoder decoder(reset,clock,  fetchOut_valid,receivedInstruction, registers[receivedInstruction[2:0]],DR,baseReg,
    offset,agex_ready,decode_ready, decodeOut_valid);
    
    alu     calculator(reset,clock, decodeOut_valid, receivedInstruction[15:12],registers[baseReg],offset,agex_result,
    agexOut_valid,agex_ready,mem_ready);
    
    register_file   memory(clock,reset,agexOut_valid, mem_ready);
    
    /*
    always@(*)
    begin
    
    if(agexOut_valid)
                    begin
                    $display("=============================================");
                    $display("AGEX authorized to store to registers");
                        case(receivedInstruction[15:12])
                                4'b0001:    //ADD
                                    registers[DR]=agex_result;
                                4'b0101:    //AND
                                    registers[DR]=agex_result;
                                4'b1110:    //LEA
                                    registers[DR]=agex_result;
                                4'b1101:    //SHF
                                    registers[DR]=agex_result;
                                4'b1001:    //XOR
                                    registers[DR]=agex_result;
                                default:
                                    registers[DR]=registers[DR];
                        endcase
                    end
                       
    
    
    end*/
    
    
    /*
    always@(*)
    begin
        next_cpuState=current_cpuState;
        case(current_cpuState)
            FETCH:
                if(decode_ready)
                    next_cpuState=DECODE;
            DECODE:
                if(agex_ready)
                    next_cpuState=AGEX;
            AGEX:
                //call alu
                next_cpuState=AGEX;
            MEM:
                next_cpuState=MEM;
        endcase
    end*/
    
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
                                4'b0001:    //ADD
                                    registers[DR]=agex_result;
                                4'b0101:    //AND
                                    registers[DR]=agex_result;
                                4'b1110:    //LEA
                                    registers[DR]=agex_result;
                                4'b1101:    //SHF
                                    registers[DR]=agex_result;
                                4'b1001:    //XOR
                                    registers[DR]=agex_result;
                                default:
                                    registers[DR]=registers[DR];
                        endcase
                    end
            
            
            
            end
    end
    
    //assign led=receivedInstruction; //LED serves as debugging tool when testing real hardware
    assign led=agex_result;
    
endmodule
