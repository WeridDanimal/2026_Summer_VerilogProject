`timescale 1ns / 1ps

/*

Previous plan was making a video game system, but lack of compatible hardware makes a system impractical to display and test

Current Design goals:
    1.to design a UART transmitter module that knows how big the array of input pixels will be and properly store them
    2. to design an image processor that can modify pixels in parallel, either all at once or just line by line
    
    Test 1: Does the largeReceiver recognize and correctly store all elements for a large but 1D array?
    Test 2: Does the largeReceiver recognize an image and transmit it correctly?

*/
module graphics_demo

#(parameter frameRows=75,parameter frameCols=75,//config for window resolution
  parameter RGB_bits=24, //self-note, if you do not use 24 bits, you are responsible for translating the info on the laptop side
  parameter rowBits=$clog2(frameRows),
  parameter colBits=$clog2(frameCols)
  
)
(
    input clock, input reset,
    
    input transmitButton, //<--only have a transmit button before I am ready to test automatic transmission
    
    input rx,
    output tx,
    
    //these 3 outputs are indirect confirmation of receiving data. the real test is the transmitter
    output [6:0] rowCount,  //testing only
    output [6:0] colCount,  //testing only
    output [1:0] eightsCount //testing only

    );
    
        
wire [7:0] rx_data;
wire [rowBits-1:0] x, inputRows, receiver_x;
reg [rowBits-1:0] currentX;
wire [colBits-1:0] y, inputCols, receiver_y;
reg [colBits-1:0] currentY;



wire [RGB_bits-1:0] writeData;
wire [RGB_bits-1:0] readData;
wire receiver_writeEn;
reg processor_writeEn;
wire write_en=receiver_writeEn|processor_writeEn; //There will be 2 types of write enables: 1 coming from the receiver, the next is whenever the image gets modified



wire transmit_pulse;
   debouncer DEBOUNCE (
        .clk(clock),
        .PB(transmitButton),
        .PB_down(transmit_pulse)
        );  

largeReceiver imageReceiver(clock,reset,rx,rx_data,
    inputRows,receiver_x,
    inputCols, receiver_y,
    eightsCount, receiver_writeEn, writeData);

reg transmitAuthorizer;
wire active;
wire transmitDone;

uart_tx TX (.i_Clock(clock),
        //.i_Clocks_per_Bit('d1),   //if using the simulator, change this to 1
        .i_Clocks_per_Bit('d100),   //if using the simulator, change this to 1
        .i_Tx_DV(transmitAuthorizer),
        .i_Reset(reset),
        .i_Tx_Byte(subpixelValue),
        .o_Tx_Serial(tx),
        .o_Tx_Active(active),
        .o_Tx_Done(transmitDone)
    );


assign x=receiver_writeEn? receiver_x: currentX;
assign y=receiver_writeEn? receiver_y: currentY;
register_file frameBuffer(clock,reset,write_en, x,y,writeData,readData);


//assign rowCount=inputRows; assign colCount=inputCols;
assign rowCount=currentX; assign colCount=currentY;
//I think I can encode the long-transmitter at top module level?



localparam TRANSMIT_IDLE=0;
parameter SEND_SUBPIXEL=1; parameter TRANSMIT_WAIT=2;//reads are synchronous, so you need 1 clock to set address
parameter NEXT_SUBPIXEL=3; parameter SUBPIXEL_WAIT=4;

reg [3:0] graphics_state;
reg [1:0] subpixel;
reg [7:0] subpixelValue;

wire slowerClock;
slow_clk(clock,reset,slowerClock);

//always@(posedge clock or posedge reset)
always@(posedge slowerClock or posedge reset)
begin
    if(reset)
        begin
            graphics_state<=0;
            processor_writeEn<=0;
            currentX<=0;
            currentY<=0;
            subpixel<=0;
            transmitAuthorizer<=0;
        end
    else
        begin
            transmitAuthorizer<=0;
            case(graphics_state)
                TRANSMIT_IDLE:
                    begin
                        //wait until either the transmit button or automatic signal is high
                        //set current pixel to (0,0) and subpixel=0
                        //if(transmit_pulse)
                        if(transmitButton)
                        begin
                            currentX<=0;
                            currentY<=0;
                            subpixel<=0;
                            graphics_state<=SEND_SUBPIXEL;
                        end
                    end
                SEND_SUBPIXEL:
                    begin
                        $display("Read from x=%d y=%d. Data=%h",currentX,currentY,readData);
                        //$display("subpixel=%h",((readData>>(subpixel*8) ) & 24'h0000FF));
                        subpixelValue<=(readData>>((2-subpixel)*8) ) & 24'h0000FF;
                        transmitAuthorizer<=1;
                        graphics_state<=TRANSMIT_WAIT;
                    end
                TRANSMIT_WAIT:
                    begin
                        
                        graphics_state<=TRANSMIT_WAIT;
                        if(transmitDone)
                            graphics_state<=NEXT_SUBPIXEL;
                    end
                NEXT_SUBPIXEL:
                    begin
                        graphics_state<=SUBPIXEL_WAIT;
                        
                        if (subpixel != 2)
                        begin
                            subpixel <= subpixel + 1;
                        end
                        else
                        begin
                            subpixel <= 0; //All RGB finished
                    
                            if (currentY < inputCols - 1)
                            begin
                                currentY <= currentY + 1;
                            end
                            else
                            begin   //all parts of row finished
 
                                currentY <= 0;
                                if (currentX < inputRows - 1)
                                begin
                                    currentX <= currentX + 1;
                                end
                                else
                                begin
                                    // Entire image finished
                                    currentX <= 0;
                                    currentY <= 0;
                                    graphics_state <= TRANSMIT_IDLE;
                                    $display("All pixels sent.");
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
 