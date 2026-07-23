`timescale 1ns / 1ps
/*

nearly identical except "rx_data" is manually fed by testbench
*/


module large_receiver_debug

#(parameter maxBytes=3, parameter maxRows=75, parameter maxCols=75)

(input clock,input reset, input rx, input [7:0] rx_data, 
 input dv, 

output reg [rowBits-1:0] inputRows, output reg [rowBits-1:0] x,
output reg [colBits-1:0] inputCols, output reg [colBits-1:0] y, 
output reg write_en,
output reg [maxSize-1:0] write_data ); //debug only

localparam maxSize=maxBytes*8;
localparam byteBits=$clog2(maxBytes);

localparam rowBits=$clog2(maxRows+1);
localparam colBits=$clog2(maxCols+1);

parameter IDLE=0; parameter GET_COLUMNS=1; parameter GET_SIZE=2; parameter READ=3;
parameter NEXT_DATA=4;


initial 
begin
    $display("===============================================================");
    $display("RECEIVER HARDWARE CHECK: max row count=%d. max col count=%d, rowbits=%d, colBits=%d",
        maxRows, maxCols, rowBits, colBits);
    $display("maximum elements=%d",(maxRows*maxCols));
end
assign rowCount=inputRows;
assign colCount=inputCols;

reg [byteBits-1:0] inputBytes;
reg [byteBits-1:0] currentByte;

/*      //Actual receiver module is disabled during simulation testing
uart_rx RX (
        .i_Clock(clock),
        .i_Clocks_per_Bit('d100),
        .i_Reset(reset),
        .i_Rx_Serial(rx),
        .o_Rx_DV(dv),   //this indicates a byte has completed a read
        .o_Rx_Byte(rx_data)
        );
        */

reg [2:0] state;

always@(posedge clock or posedge reset)
begin
    if(reset)
        begin
            x<=0;
            y<=0;
            currentByte<=0;
            inputBytes<=0;
            inputRows<=0;
            inputCols<=0;
            state<=0;
            write_en<=0;

        end
    else
        begin
            //$display("================================================");
            //$display("STATE #=%d. TIMESTAMP=%0t",state,$realtime);
            //$display("input rows=%d input columns=%d, input bytes=%d.    RGB encoding=%h", inputRows, inputCols,
            //inputBytes, write_data);
            //$display("pixel x=%d, y=%d",x,y);
            //$display("DOUBLECHECK. output rows=%d, output cols=%d",)
            
            write_en<=0;    //all states initially remove write permissions.
            
            case(state)
                IDLE:
                    begin
                        state<=IDLE;
                        
                        if(dv)
                            begin
                                //$display("Incoming data, column count=%d",rx_data);
                                inputRows<=rx_data;
                                state<=GET_COLUMNS;
                            end
                        
                    end
                 GET_COLUMNS:
                    begin
                        state<=GET_COLUMNS;
                        if(dv)
                            begin
                                //$display("Incoming data, row count=%d",rx_data);
                                inputCols<=rx_data;
                                state<=GET_SIZE;
                            end
                    end
                 
                 GET_SIZE:
                    begin
                        state<=GET_SIZE;
                        if(dv)
                            begin
                                //$display("Incoming data, byte count=%d",rx_data); 
                                inputBytes<=rx_data; //NOTE: THIS TELLS RECEIVER HOW MANY BYTES AN ARRAY ELEMENT WILL OCCUPY
                                currentByte<=0;
                                //state<=IDLE;
                                state<=READ;
                            end
                    end
                 
                 READ:
                    begin
                        state<=READ;
                          //I am going to pause this until I can confirm that data on rows, columns, and size/section are stored right
                        if(dv)
                        begin                            
                            currentByte<=currentByte+1;
                            
                            //this shows the write data being shifted by a byte to allow new data in
                            write_data<=(write_data<<8)|rx_data; 
                            //how do I correctly store data?
                            
                            if(currentByte==inputBytes-1)
                                begin
                                //$display("RGB info complete");
                                write_en<=1;    //Enable for one cycle only
                                currentByte<=0;
                                state<=NEXT_DATA;
                            end
                        end
                    end
                    
               NEXT_DATA:
               begin
                    state<=READ;
                    y<=y+1;    
                    if(y==inputCols-1)
                    begin
                        //$display("end of columns. next row");
                        y<=0;
                        x<=x+1;
                        if(x==inputRows-1)
                        begin
                            $display("Received all data. RETURNING TO IDLE. TIMESTAMP=%0t",$realtime);
                            x<=0;
                            y<=0;
                            state<=IDLE;
                        end
                    end
                        
               end                
               
            endcase
        end
end

endmodule
