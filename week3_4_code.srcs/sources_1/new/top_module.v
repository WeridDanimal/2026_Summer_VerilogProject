`timescale 1ns / 1ps


/*

most of top module, all of uart_tx and all of uart_rx are
copy+pasted from https://www.physics.umd.edu/hep/drew/495/serial_communication.html
*/

/*
Purpose: learning how to establish communication between the Basys 3 Artix7 board and the laptop
Note: the Basys 3 has a default 100 MHz clock frequency
*/

module top_module (
    input clock,
    input reset,
    input transmit,
    input [7:0] sw,
    input rx,
    output tx,
    output [15:0] led
    //output reg[15:0] led
    //output heartbeat
);
    reg [27:0] counter;
    always @ (posedge clock) counter <= counter + 1;
    //assign heartbeat = counter[27];
    //
    //  debounce the transmit push button
    //
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
   
    //
    //  instantiate uart_tx
    //
    wire active, done;
    
    //isa_decoder basicISA(.reset(reset),.readyButton())
    
    uart_tx TX (
        .i_Clock(clock),
        .i_Clocks_per_Bit('d100),
        .i_Tx_DV(transmit_pulse),
        .i_Reset(reset),
        .i_Tx_Byte(sw),
        .o_Tx_Serial(tx),
        .o_Tx_Active(active),
        .o_Tx_Done(done)
    );
    //
    //  instantiate uart_rx
    //
    wire dv;
    wire [7:0] rx_data;     //receiver
    uart_rx RX (
        .i_Clock(clock),
        .i_Clocks_per_Bit('d100),
        .i_Reset(reset),
        .i_Rx_Serial(rx),
        .o_Rx_DV(dv),
        .o_Rx_Byte(rx_data)
        );
        
    reg byteLocation;
    reg instruction_valid;
    reg [15:0] receivedMachCode;
    reg [15:0] instruction;


    always @(posedge clock or posedge reset)
    begin
        if(reset)
        begin
            byteLocation <= 0;
            instruction_valid <= 0;
            receivedMachCode <= 0;
            instruction <= 0;
        end
    
        else
        begin
    
            // default: no instruction this cycle
            instruction_valid <= 0;
    
            if(dv)
            begin
                if(byteLocation == 0)
                begin
                    receivedMachCode[7:0] <= rx_data;
                    byteLocation <= 1;
                end
                else
                begin
                    receivedMachCode[15:8] <= rx_data;
                    //merges bytes to form instruction
                    instruction <= {rx_data, receivedMachCode[7:0]};
                    //indicates complete, valid instruction
                    instruction_valid <= 1;
                    byteLocation <= 0;
                end
            end
        end
    end    
        
        
        
        
        
        
    /*
    reg byteLocation=0;
    reg readySignal=0;
    
    reg[15:0] receivedMachCode;
    always @(posedge clock or posedge reset)
    begin
        if(reset)
        begin
        byteLocation<=0;
        readySignal<=0;
        receivedMachCode<=0;
        end
        
        else if(dv)
            begin
            if (byteLocation==0)
                begin
                //led[7:0]<=rx_data;
                receivedMachCode[7:0]<=rx_data;
                byteLocation<=1'b1;
                readySignal<=0;
                end
            else
                begin
                //led[15:8]<=rx_data;
                receivedMachCode[15:8]<=rx_data;
                byteLocation<=1'b0;
                readySignal<=1;
                end
            end
    end*/
    
    wire [15:0] tempresult;
    isa_decoder decoder(.machineCode(receivedMachCode),.reset(reset_pulse),.instruction_valid(instruction_valid),.result(tempresult), .clock(clock));  
    assign led=tempresult;
    //assign led=receivedMachCode;
endmodule
/*
Notes: extreme long time to synthesize code could come from the register file
code. my guess is that initialization is making synthesis way too long

*/
