`timescale 1ns / 1ps
/*
Purpose: Near-identical copy of CPU top module except UARTs are replaced with inputs for
testbench simplicity

*/

module cpu_debug#(parameter FETCH=2'd0, parameter DECODE=2'd1, parameter AGEX=2'd2, parameter MEM=2'd3 )

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

    //pipelining registers
    //reg fetch_to_decode, decode_to_agex,agex_to_mem;

    
    reg[2:0] nzpBits;
    reg[15:0] registers[0:7];
    
    wire [2:0] DR, baseReg;
    wire [15:0] offset, read_address,write_address;      //offset: can be used in either math or address calculation
    wire [15:0] agex_result;
    
    wire [1:0] write_en, read_en;
    
    
    //SUB-MODULE INSTANTIATIONS
    
   
    
    instruction_receiver receiver(clock,reset,uart_receive_finish , incomingData, receivedInstruction, decode_ready,fetchOut_valid);
    
    isa_decoder decoder(reset,clock,  fetchOut_valid,receivedInstruction, registers[receivedInstruction[2:0]],DR,baseReg,
    offset,agex_ready,decode_ready, decodeOut_valid,
    
    write_en[0], write_en[1], read_en[0], read_en[1]
    );
    
    alu     calculator(reset,clock, decodeOut_valid, receivedInstruction[15:12],registers[baseReg],offset,agex_result,
    agexOut_valid,agex_ready,mem_ready, receivedInstruction[5:4]);
    
    register_file   memory(clock,reset,agexOut_valid, mem_ready, write_en[0], write_en[1], read_en[0],read_en[1]);
    
    
    assign decodeSignal=decode_ready;
    assign aluSignal=agex_ready;
    assign memSignal=mem_ready;
    
    assign decodeValidOut=decodeOut_valid;
    assign aluValidOut=agexOut_valid;

    //self reminder that this is a combinatorial circuit.
    
    
    always@(*)
    begin
    
    end
    
    
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
             
             if(memOut_valid)
                begin
                    /*
                    check which instruction it 
                    
                    
                    */
                end     
            
            
            
            end
    end
    
    assign encodedInstruct=receivedInstruction; //LED serves as debugging tool when testing real hardware
    assign led=agex_result;
    
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