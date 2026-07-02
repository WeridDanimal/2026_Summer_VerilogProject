`timescale 1ns / 1ps

/*
This file archives the most basic skeleton/structure of the message transmitter test file.
It is archived for visibility purposes, to be able to see how states should progress when all other aspects are simplified

*/
module execute_once_test

#(parameter IDLE=0, parameter PRINT_CHAR=1, parameter UART_WAIT=2, parameter NEXT_CHAR=3)
(input clock, input reset, input transmitButton,
input rx,
output tx,
output [1:0] stateOutput,    // for simulation only
output [4:0] charIndex,
output [7:0] sentCharacter 
    );
    
wire [7:0] testMessage [3:0];
reg [1:0] messageState;
assign stateOutput=messageState;


reg [4:0] messageCounter;
assign charIndex=messageCounter;
assign sentCharacter=testMessage[messageCounter];

assign testMessage[0]="H";
assign testMessage[1]="i";
assign testMessage[2]="\n";

wire slowclock;
slow_clk(clock,reset,slowclock);

//instantiating button debouncers
   wire transmit_pulse;
   debouncer DEBOUNCE (
        .clk(clock),
        .PB(transmitButton),
        .PB_down(transmit_pulse)
        );  

    //  instantiate uart_tx
    wire active, char_done;
    uart_tx TX (
        .i_Clock(clock),
        .i_Clocks_per_Bit('d100),   //if using the simulator, change this to 1
        //.i_Clocks_per_Bit('d100),   //if using the simulator, change this to 1
        .i_Tx_DV(transmitAuthorizer),
        .i_Reset(reset),
        .i_Tx_Byte(testMessage[messageCounter]),
        .o_Tx_Serial(tx),
        .o_Tx_Active(active),
        .o_Tx_Done(char_done)
    );

//always @(posedge clock or posedge reset)
always @(posedge slowclock or posedge reset)
begin

    if(reset)
        begin
        messageState<=0;
        end
    else
        begin
        
        case(messageState)
            IDLE:
                begin
                messageCounter<=0;
                
                if(transmitButton)
                    messageState<=PRINT_CHAR;
                else
                    messageState<=IDLE;
                end
            PRINT_CHAR:
                begin
                messageState<=UART_WAIT;
                end
            UART_WAIT:
                begin
                messageState<=NEXT_CHAR;
                end
            NEXT_CHAR:
                begin
                if(messageCounter==2)
                    messageState<=IDLE;
                else
                    begin
                    messageState<=PRINT_CHAR;
                    messageCounter<=messageCounter+1;
                    end
                end
        endcase
        
        
        end
end

endmodule
