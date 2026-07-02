`timescale 1ns / 1ps

/*
maybe I should separate large memory bank from the MEM stage to make it easier to understand what to do

*/
module memhandler_experimental

//#(parameter IDLE=2'b00, parameter ACTIVE=2'b01,parameter FINISHED=2'b10)
(
    input clock, input reset,
    input valid_agex,
    output mem_ready,
    
    input wr_en0,
    input wr_en1,
    input rd_en0,
    input rd_en1,
    
    input [7:0] regFileData,    //input supplied by register file
    input [15:0] writeData,     //i think this one is fine because it's pulling from the 8 registers
    output reg [15:0] readData,
    output reg [7:0] writeBack, //output to write back to register file
    output  memwrite_en,  
  
    
    output reg [15:0] outputAddress, //output to register file for read/write (but not both?)
    input [15:0] inputAddress,       //fed by AGEX. gets processed to outputAddress IF needed    
    output reg validOutput  //flag signaling that mem's output is valid

    );
    
reg [15:0] savedAddress, savedAddress_2;
reg [15:0] savedWriteData;

reg mem_stall;
assign mem_ready=!mem_stall; 

wire [7:0] tempReadData;

reg [2:0] memState;
reg [1:0] rd_enBuffer, wr_enBuffer;

assign memwrite_en=wr_enBuffer[0];

always@(posedge clock or posedge reset)
begin

    $display("MEM TIMESTAMP=%0t. Memory FSM=%d addr=%h regFileData=%h readData=%h",$realtime, 
    memState, outputAddress, regFileData,readData);

    if(reset)
    begin
        memState<=3'b00;
        readData<=0;
        mem_stall<=0;
        validOutput<=0;
        rd_enBuffer<=0;
        wr_enBuffer<=0;
        outputAddress<=0;
        savedAddress<=0;
        savedAddress_2<=0;
        savedWriteData<=0;
        writeBack<=0;
    end
 
    else
    begin
        
        validOutput<=0;

        case(memState)

        // IDLE
        3'b000:
        begin
            if(valid_agex)
            begin

                savedAddress<=inputAddress;
                savedAddress_2<=inputAddress+1;
                savedWriteData<=writeData;

                wr_enBuffer<={wr_en1,wr_en0};
                rd_enBuffer<={rd_en1,rd_en0};

                case({rd_en1,rd_en0,wr_en1,wr_en0})

                    // LDB
                    4'b0100:
                    begin
                        outputAddress<=inputAddress;
                        memState<=3'd1;
                        mem_stall<=1;
                    end

                    // LDW
                    4'b1100:
                    begin
                        $display("LDW START");
                        outputAddress<=inputAddress;
                        memState<=3'd1;
                        mem_stall<=1;
                    end

                    // STB
                    4'b0001:
                    begin
                        outputAddress<=inputAddress;
                        writeBack<=writeData[7:0];
                        memState<=3'd1;
                        mem_stall<=1;
                    end
                    // STW
                    4'b0011:
                    begin
                        $display("STW START addr=%h",inputAddress);
                        outputAddress<=inputAddress;
                        // first byte
                        writeBack<=writeData[7:0];
                        // keep second byte pending
                        wr_enBuffer<=2'b11;
                        memState<=3'd1;
                        mem_stall<=1;
                    end
                    default:
                    begin
                        readData<=inputAddress;
                    end

                endcase
            end
        end
        
        3'b001:
            memState<=3'b010;
        
        

        3'b010: //should have read data ready
        begin

            $display("MEM STATE 2. Read_EN=%d, Write_EN=%d. memory bank returned:%h",rd_enBuffer, wr_enBuffer,
                regFileData);

            // BYTE LOAD
            if(rd_enBuffer==2'b01)
            begin
                readData<=regFileData[7] ? 16'hff00|regFileData : 16'h0000|regFileData;
                validOutput<=1;
                memState<=0;
                mem_stall<=0;
                rd_enBuffer<=0;
            end

            // WORD LOAD first half
            else if(rd_enBuffer==2'b11)
            begin
                $display("2nd read required. going to savedAddress_2=%h",savedAddress_2);
                readData[7:0]<=regFileData;
                rd_enBuffer<=2'b01;
                outputAddress<=savedAddress_2;
                memState<=3'b011;

            end
            // STW first byte finished
            else if(wr_enBuffer==2'b11)
            begin
                $display("STW FIRST BYTE DONE");
                // second byte next cycle
                outputAddress<=savedAddress_2;
                writeBack<=savedWriteData[15:8];
                wr_enBuffer<=2'b01;
                memState<=3'b011;

            end
            // STB done
            else if(wr_enBuffer==2'b01)
            begin
                wr_enBuffer<=0;
                memState<=0;
                mem_stall<=0;
            end

        end

        // delay state to allow address/data settle
        3'b011:
        begin
            memState<=3'b100;
        end

        // finish second half
        3'b100:
        begin

            // finish LDW
            if(rd_enBuffer==2'b01)
            begin
            
                readData[15:8]<=regFileData;
                rd_enBuffer<=0;
                memState<=0;
                validOutput<=1;
                mem_stall<=0;
            end
            // finish STW
            else if(wr_enBuffer==2'b01)
            begin
                $display("STW SECOND BYTE DONE");
                wr_enBuffer<=0;
                memState<=0;
                mem_stall<=0;
            end

        end


        endcase
    end

end
    
endmodule    
    
 
    /*
    explanation for the structure:
    because both register file and memory handler trigger at the same cycle, that means if i need to do an LDB or a 
    STW, i cannot  do a read/write on the same cycle. 
    
    
    State 0="IDLE", all non-memory instructions pass on agex output to mem output.
        All memory instructions go to State 1 and pass one of the address(es) to register file
    
    State 1= either a write happened or a read. if a read happened, store in low-byte. memory output may or may not be valid.
        if another address space is required, send next address to register file
    
    State 2= return to state 0 regardless. output is valid here.
    
    
    */
    
/*

the ultimate test: can this pass synthesis and up to bitstream generation?


*/


