`timescale 1ns / 1ps
/*
nearly identical except rx_data and rx are manually given by testbench file

*/


module graphics_demo_debug

#(parameter frameRows=75,parameter frameCols=75)//config for window resolution)
(input clock, input reset, 
    input debug_dv,
    input transmitButton, //<--only have a transmit button before I am ready to test automatic transmission
    
    input rx,
    input [7:0] rx_data,
    output tx
    );
    
localparam rowBits=$clog2(frameRows);
localparam colBits=$clog2(frameCols);
localparam RGB_bits=24;


initial
begin
    $display("===============================================================");
    $display("GRAPHICS TOP MOD HARDWARE CHECK: row count=%d. col count=%d, rowbits=%d, colBits=%d",
        frameRows, frameCols, rowBits, colBits);
end


wire [rowBits-1:0] x, inputRows, receiver_x;
reg [rowBits-1:0] currentX;
wire [colBits-1:0] y, inputCols, receiver_y;
reg [colBits-1:0] currentY;



wire [RGB_bits-1:0] writeData;
wire receiver_writeEn;
reg processor_writeEn;
wire write_en=receiver_writeEn|processor_writeEn; //There will be 2 types of write enables: 1 coming from the receiver, the next is whenever the image gets modified
wire [RGB_bits-1:0] readData;

/* Real hardware only
wire transmit_pulse;
   debouncer DEBOUNCE (
        .clk(clock),
        .PB(transmitButton),
        .PB_down(transmit_pulse)
        ); */ 

assign transmit_pulse=transmitButton;

large_receiver_debug  receiverDebug 
(clock,reset,rx,rx_data,debug_dv, inputRows,receiver_x, inputCols, receiver_y, receiver_writeEn, writeData);

reg transmitAuthorizer;
wire active;
wire transmitDone;

uart_tx TX (.i_Clock(clock),
        .i_Clocks_per_Bit('d1),   //if using the simulator, change this to 1
        //.i_Clocks_per_Bit('d100),   //if using the simulator, change this to 1
        .i_Tx_DV(transmitAuthorizer),
        .i_Reset(reset),
        .i_Tx_Byte(subpixelValue),
        .o_Tx_Serial(tx),
        .o_Tx_Active(active),
        .o_Tx_Done(transmitDone)
    );


//only set x from the receiver when receiver sends its unique write enable
assign x=receiver_writeEn? receiver_x: currentX;
assign y=receiver_writeEn? receiver_y: currentY;
register_file  frameBuffer
(clock,reset,write_en, x,y,writeData,readData);

localparam TRANSMIT_IDLE=0;
parameter SEND_SUBPIXEL=1; parameter TRANSMIT_WAIT=2;//reads are synchronous, so you need 1 clock to set address
parameter NEXT_SUBPIXEL=3; parameter SUBPIXEL_WAIT=4;

reg [3:0] graphics_state;
reg [1:0] subpixel;
reg [7:0] subpixelValue;

always@(posedge clock or posedge reset)
begin
    if(reset)
        begin
            graphics_state<=0;
            processor_writeEn<=0;
            currentX<=0;
            currentY<=0;
            subpixel<=0;
        end
    else
        begin
            //$display("================================================");
            //$display("Top Module state=%d. Timestamp=%0t",graphics_state, $realtime);
            
            case(graphics_state)
                TRANSMIT_IDLE:
                    begin
                        //wait until either the transmit button or automatic signal is high
                        //set current pixel to (0,0) and subpixel=0
                        if(transmit_pulse)
                        begin   
                            $display("=========================================================");   
                            $display("starting transmitter sequence....");
                            currentX<=0;
                            currentY<=0;
                            subpixel<=0;
                            graphics_state<=SEND_SUBPIXEL;
                        end
                    end
                SEND_SUBPIXEL:
                    begin

                        $display("Read from x=%d y=%d. Data=%h",currentX,currentY,readData);
                        $display("subpixel=%h",((readData>>(subpixel*8) ) & 24'h0000FF));
                        subpixelValue<=(readData>>((2-subpixel)*8) ) & 24'h0000FF;
                        transmitAuthorizer<=1;
                        graphics_state<=TRANSMIT_WAIT;
                    end
                TRANSMIT_WAIT:
                    begin
                        
                        transmitAuthorizer<=0;
                        graphics_state<=TRANSMIT_WAIT;
                        if(transmitDone)
                            begin
                            //$display("TRANSMITTER FINISHED. NEXT SUBPIXEL");
                            graphics_state<=NEXT_SUBPIXEL;
                            end
                        //$display("At TRANSMIT_WAIT stage:      subpixel=%h",subpixelValue);
                    end

                NEXT_SUBPIXEL:
                    begin
                        graphics_state<=SUBPIXEL_WAIT;
                        subpixel<=subpixel+1;
                        
                        if(subpixel==2)
                            begin
                                //$display("all subpixels sent");
                                subpixel<=0;
                                currentY<=currentY+1;
                                if(currentY==inputCols-1)
                                    begin
                                        currentY<=0;
                                        currentX<=currentX+1;
                                        if(currentX==inputRows-1)
                                            begin
                                                $display("all pixels sent");
                                                currentX<=0;
                                                graphics_state<=TRANSMIT_IDLE;
                                            end
                                    end                                
                            end

                    end
                SUBPIXEL_WAIT:
                    begin
                        graphics_state<=SEND_SUBPIXEL;
                    end
            endcase
        end
end
    
endmodule
