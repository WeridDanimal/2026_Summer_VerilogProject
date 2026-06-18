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


(input [15:0] machineCode, 
 input reset,
 input clock,
 input instruction_valid,
output reg [15:0] result
    );

//intermediate variables for destination register, base/source 1 register, and source 2 register
wire [2:0] DR=machineCode[11:9], baseR=machineCode[8:6], SR2=machineCode[2:0];

reg[15:0] registers [0:7]; //8 16-bit registers



wire [4:0] imm5=machineCode[4:0]; //a 5-bit immediate value, signed if I remember correctly
wire [15:0] sext= machineCode[4]? (16'hFFE0|imm5):(16'd0|imm5);



//memory address offset, depends if requires byte or word-sized offsets
reg [15:0] addr_offset;

reg [15:0] read_address,write_address;
reg [7:0] write_data;
wire [7:0] read_data;
reg wr_en;
reg [2:0] nzpBits; //important for branch pathing
reg [15:0] internal_result;

register_file memaccess(.read_address(read_address), .write_address(write_address), .read_data(read_data), 
.write_data(write_data), .wr_en(wr_en),.clk(clock));

//always@(posedge clock or posedge readyButton)
always@(posedge clock or posedge reset)
//always@(posedge readySignal, posedge reset)
begin
    
    if(reset)
    begin
        
        registers[0]<=0;
        registers[1]<=0;
        registers[2]<=0;
        registers[3]<=0;
        registers[4]<=0;
        registers[5]<=0;
        registers[6]<=0;
        registers[7]<=0;
        result<=16'd0;
    end

    else if(instruction_valid)
    begin
        case(machineCode[15:12])
             ADD:
                begin
                    internal_result=machineCode[5]? (sext+registers[baseR]):(registers[baseR]+registers[SR2]);
                    registers[DR]<=internal_result;
                    result<=internal_result;
                end
             AND:
                begin
                
                    internal_result=machineCode[5]? (sext&registers[baseR]):(registers[baseR]&registers[SR2]);
                    registers[DR]<=internal_result;
                    result<=internal_result;
                end 
             XOR:
                begin
                    internal_result=machineCode[5]? (sext^registers[baseR]):(registers[baseR]^registers[SR2]);
                    registers[DR]<=internal_result;
                    result<=internal_result;
                end
             SHF:
                begin
                    case(machineCode[5:4])
                    
                        2'b00://left shift
                            internal_result=registers[baseR]<<machineCode[3:0];            
                        2'b01://logical right shift
                            internal_result=registers[baseR]>>machineCode[3:0];
                        2'b11:
                            internal_result=(16'hFFFF<<(16-machineCode[3:0])) | (registers[baseR]>>machineCode[3:0]);
                        default:
                            internal_result=registers[DR];
                    endcase
                    
                    result<=internal_result;
                    registers[DR]<=internal_result;
                end   
             
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
              */
             
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
             
             default://where all unused or invalid opcodes go
                begin
                result<=0;
                end
        endcase
    end
end  

endmodule
