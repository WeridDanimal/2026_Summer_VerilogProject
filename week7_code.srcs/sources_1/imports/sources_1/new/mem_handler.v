`timescale 1ns / 1ps

/*
maybe I should separate large memory bank from the MEM stage to make it easier to understand what to do

*/
module mem_handler

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

reg mem_stall;
assign mem_ready=!mem_stall; 

wire [7:0] tempReadData;

//regFile_redesign memBank(clock,reset,wr_enBuffer[0],rd_enBuffer[0],writingBuffer[7:0],tempReadData,addressBuffer);

reg [1:0] memState;
reg [1:0] rd_enBuffer, wr_enBuffer;
assign memwrite_en=wr_enBuffer[0];

always@(posedge clock or posedge reset)
begin
    $display("====================================================================================");
    $display(
    "Memory FSM=%d addr=%h regFileData=%h readData=%h", memState, outputAddress, regFileData,readData);
    
    if(reset)
    begin
        memState<=2'b00;
        readData<=0;
        mem_stall<=0;
        validOutput<=0;
        rd_enBuffer<=0;
        wr_enBuffer<=0;
        outputAddress<=0;
        savedAddress<=0;
        savedAddress_2<=0;
        writeBack<=0;
    end
 
    else
    begin
        //$display("MEM State=",memState);
        //$display("valid_agex?=",valid_agex);
        
        
        validOutput<=0; //preliminary wipe, unclear if will cause problems with memory operations
        case(memState)
            2'b00:
                begin
                    if(valid_agex)
                        begin
                        savedAddress<=inputAddress;
                        savedAddress_2<=inputAddress+1;
                        //$display("agex output authorized to be used by MEM");
                        mem_stall<=0;
                        wr_enBuffer<={wr_en1,wr_en0};
                        rd_enBuffer<={rd_en1,rd_en0};
                        
                        case({rd_en1,rd_en0,wr_en1,wr_en0})
                        
                            4'b0100: //LDB
                                begin
                                outputAddress<=inputAddress;
                                memState<=2'b01;
                                mem_stall<=1;
                                end
                            //4'b1100
                            
                            4'b1100:
                                begin //LDW
                                $display("LDW RECOGNIZED. STARTING SEND ADDRESS 1");
                                outputAddress<=inputAddress;
                                memState<=2'b01;
                                mem_stall<=1;
                                end
                            
                            4'b0001: //STB
                                begin
                                $display("Store Byte-sized recognized. input address=%h",inputAddress);
                                outputAddress<=inputAddress;
                                memState<=2'b01;
                                writeBack<=writeData[7:0];
                                mem_stall<=1;
                                end
                            
                            4'b0011:
                                begin
                                $display("Store WORD recognized. input address=%h",inputAddress);
                                outputAddress<=inputAddress;
                                memState<=2'b01;
                                writeBack<=writeData[7:0];
                                mem_stall<=1;
                                end
                            
                            default:
                                begin
                                readData<=inputAddress;
                                end
                        endcase
                        //readData<=inputAddress;
                        end
                  end
                  
            2'b01:  //STATE 1: Either byte-sized or middle of word-sized operation
                begin
                $display("mem state=1. should indicate retrieve something from memory bank");
                $display("read en buffer=",rd_enBuffer);
                
                
                if(rd_enBuffer==2'b01) //BYTE SIZED
                    begin
                        $display("memory bank read returns=%h at address=%h",regFileData,outputAddress);
                        readData<=regFileData[7]? 16'hff00|regFileData: 16'h0000|regFileData;
                        validOutput<=1;
                        memState<=0;
                        mem_stall<=0;
                        rd_enBuffer<=0;
                    end
                else if(rd_enBuffer==2'b11)
                    begin
                        //$display("LDW")
                        memState<=2'b10;
                        rd_enBuffer<=rd_enBuffer>>1;
                        readData[7:0]<=regFileData;
                        $display("LDW IN PROGRESS. next address to read=%h",savedAddress_2);
                        $display("previous address should be:%h",savedAddress);
                        outputAddress<=savedAddress_2;
                    end    
                
                if(wr_enBuffer==2'b01)
                    begin
                        memState<=0;
                        mem_stall<=0;
                        //what if i left shift the write enable?
                        wr_enBuffer<=wr_enBuffer>>1;
                    end
                else if(wr_enBuffer==2'b11)
                    begin
                        $display("STW IN PROGRESS. NEXT ADDRESS TO READ=%h",savedAddress_2);
                        memState<=2;
                        wr_enBuffer<=wr_enBuffer>>1;
                        writeBack<=writeData[15:8];
                        outputAddress<=savedAddress_2;
                    end
                
                
                end
            2'b10:
                //it feels like bad design to have one state whose only function is to stall to allow proper reads/(writes?)
                
                begin
                /*
                    if(rd_enBuffer==2'b01)
                    begin
                        $display("LDW complete. memory bank read returns=%h at address=%h",regFileData,outputAddress);
                        readData[15:8]<=regFileData;
                        rd_enBuffer<=rd_enBuffer>>1;
                        memState<=0;
                        validOutput<=1;
                        mem_stall<=0;
                    end
  */
                memState<=2'b11;
                end
                
            2'b11:  //State 4: end of LDW or STW
                begin
                    
                    if(rd_enBuffer==2'b01)
                    begin
                        $display("LDW complete. memory bank read returns=%h at address=%h",regFileData,outputAddress);
                        readData[15:8]<=regFileData;
                        rd_enBuffer<=rd_enBuffer>>1;
                        memState<=0;
                        validOutput<=1;
                        mem_stall<=0;
                    end
                    //readData<=3;
                    
                    if(wr_enBuffer==2'b01)
                    begin
                        $display("STW complete");
                        memState<=0;
                        wr_enBuffer<=wr_enBuffer>>1;
                        validOutput<=0;
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


