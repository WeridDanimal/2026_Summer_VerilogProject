`timescale 1ns / 1ps
/*
potential fatal design flaw: this version doesn't stop multiple executions of the same instruction

another problem identified: handler isn't giving write data on time, passes nothing

*/
module memHandler_debug

#(parameter IDLE=2'b00, parameter MEM_ACCESS1=2'b01,parameter MEM_ACCESS2=2'b10)

(input clock, input reset,
 input agex_isValid, input [15:0] inputAddress, input [15:0] writeData,
 input wr_en0,
 input wr_en1,
 input rd_en0,
 input rd_en1,
 
 input [7:0] regFile_readData,
 output reg [7:0] regFile_writeData,
 output reg memWrite,
 output reg [15:0] outputAddress,
 output reg [15:0] memOutput,
 output memReady
 );

reg memStall;
assign memReady=!memStall;

reg [1:0] memState;

reg [15:0] addressBuffer;
reg [15:0] writeBuffer;
reg [15:0] readBuffer;
reg [1:0] rd_enBuffer, wr_enBuffer;

reg instructionProcessed;

//combinational block, outputs needed items for the memory bank module
always@(*)
begin
    memStall=0;
    memWrite=0;
    //unclear if this is enough
    outputAddress=0;
    regFile_writeData=0;    
    
    case(memState)
        IDLE:
            begin
            memStall=0;
            end
        MEM_ACCESS1:
            begin
                memStall=1;
                regFile_writeData=writeBuffer[7:0];
                outputAddress=addressBuffer; 
                if(wr_enBuffer!=0)
                    begin
                        $display("Set write buffer=1. TIMESTAMP=%0t. writebuffer[7:0]=%h", $realtime,writeBuffer[7:0]);
                        memWrite=1;            
                    end
            end
        MEM_ACCESS2:
            begin
                memStall=1;
                regFile_writeData=writeBuffer[15:8];
                outputAddress=addressBuffer+1;
              
                if(wr_enBuffer!=0)
                    memWrite=1;
            end
    endcase
    
end

//handles state transitions
always@(posedge clock or posedge reset)
begin
    if(reset)
    begin
        memState<=0;
        addressBuffer<=0;
        writeBuffer<=0;
        readBuffer<=0;
        rd_enBuffer<=0;
        wr_enBuffer<=0;
        memOutput<=0;
        instructionProcessed<=0;//tells hanlder this instruction hasn't been processed before
    end
    else
        begin
        
            //this needs to have something to stop multiple reads
            $display("TIMESTAMP of mem handler: %0t",$realtime);
            case(memState)
                IDLE:
                    begin
                        memOutput<=memOutput;
                        if(agex_isValid && memReady)
                        
                            begin
                                $display("authorized to use AGEX outputs, idle state. identified at %0t",$realtime);
                                addressBuffer<=inputAddress;
                                rd_enBuffer<={rd_en1, rd_en0};
                                wr_enBuffer<={wr_en1,wr_en0};
                                writeBuffer<=writeData;
                                
                                //should not use the buffer for this comparison
                                if({rd_en1,rd_en0}!=0 ||  {wr_en1,wr_en0}!=0)
                                    begin
                                        memState<=MEM_ACCESS1;
                                        $display("memory operation recognized. moving to ACCESS 1. Address=%h TIMESTAMP=%0t",inputAddress,$realtime);
                                    end
                                else
                                    begin
                                    memState<=IDLE;
                                    memOutput<=inputAddress;
                                    end
                                    //mem output= input address
                            end
                    end
                MEM_ACCESS1:
                    begin
                        $display("State= MEM_ACCESS1. READ BUFFER=%d. WRITE BUFFER=%d timestamp= %0t",
                            rd_enBuffer,wr_enBuffer, $realtime);
                        if(rd_enBuffer==2'd1)
                            begin
                            //readBuffer might be redundant
                            readBuffer<= regFile_readData[7]? 16'hFF00|regFile_readData: 16'h0000|regFile_readData; 
                            memOutput<= regFile_readData[7]? 16'hFF00|regFile_readData: 16'h0000|regFile_readData;
                            end
                        else if(rd_enBuffer==2'b11)
                            readBuffer[7:0]<= regFile_readData;
                        
                        //to show what is being written at the end of a memory instruction
                        if(wr_enBuffer==2'd1)
                            memOutput<=16'h0000|writeBuffer[7:0];
                        
                        
                        
      
                        if(rd_enBuffer[1]==1 || wr_enBuffer[1]==1)
                            begin
                            $display("ADVANCING to access 2. double-memory operation");
                            memState<=MEM_ACCESS2;
                            end
                        else
                            begin
                                $display("Single-address operation. returning to IDLE");
                                memState<=IDLE;
                            end
                    end
                MEM_ACCESS2:
                    begin
                        $display("MEM STATE= MEM ACCESS 2");
                        if(rd_enBuffer==2'b11)
                            begin
                                readBuffer[15:8]<=regFile_readData;
                                memOutput<=(readBuffer<<8)|regFile_readData;
                            end
                        memState<=IDLE;
                    end
            endcase
       
        $display("MEM output=%h",memOutput);
        end    
end

endmodule