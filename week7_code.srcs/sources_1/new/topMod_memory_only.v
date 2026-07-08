`timescale 1ns / 1ps
/*
Purpose:
    starting with week 7's iteration of the CPU project, deciding to fix it with a bottom-up approach by first
    fixing timing issues with the memory handler

Debug version of top module that only investigates functionality of memory handler



 Criteria of success:
    1. reads single space correctly
    2. writes single space correctly. must be confirmed in both single and double-reads
    3. reads two spaces correctly
    4. writes two spaces correctly. must be confirmed by double-read
    5. ALU must be correctly stalled

AI's suggestion for testing grounds:
read one word
write one word
read-after-write
overwrite
sequential reads
sequential writes
busy timing
request while busy behavior
reset behavior
CPU integration testbench
ALU operation begins
memory access interrupts flow
stall asserted
registers/ALU state frozen
resume after memory completes
*/

module topMod_memory_only(
    input clock, input reset,
    //debug-exlcusive variables
    input [2:0] DR,
    input [15:0] agex_result, 
    input [1:0] wr_en, input [1:0] rd_en,
    input agexOut_valid,
    output [15:0] memOutput
    //output memStall_debug
    );
    
reg [15:0] registers [7:0];


wire [7:0 ] regFile_writeInput, regFile_output;
wire [15:0] memAddress;
wire mem_writeEn;
wire memOut_valid;
wire DR;
wire memReady;
regFile_redesign memoryBank(clock,reset,mem_writeEn, regFile_writeInput,regFile_output, memAddress);

memHandler_debug newHandler(clock,reset, agexOut_valid, agex_result, registers[DR],
    wr_en[0], wr_en[1], rd_en[0], rd_en[1], regFile_output,regFile_writeInput,mem_writeEn, memAddress, memOutput,memReady);


always@(posedge clock or posedge reset)
begin

    if(reset)
    begin
        registers[0]<=0;
        registers[1]<=16'h8888;
        registers[2]<=16'h2222;
        registers[3]<=16'h3333;
        registers[4]<=16'h4444;
        registers[5]<=16'h5555;
        registers[6]<=16'h6666;
        registers[7]<=16'h7777;
    end

end
    
endmodule
