`timescale 1ns / 1ps
/*
prototype for receiver module designed to take an arbitrary amount of data points from the UART receiver

UART Laptop to FPGA protocol:
    1. laptop's message must first indicate how many elements in the array
    2. laptop must check that message sequence does not exceed array size. laptop must also check each element is within size
    limit before transmission
    
*/
module long_receiver
#(parameter elemSize=8, 
receiverLimit=100,//maximum size of receiver sequence this module will accept
IDLE=0, GETDATA=1, WAIT=2, NEXT_DATA=3  //state encoding 
)   
(input clock, input reset);

reg [1:0] receiverState;
reg[elemSize-1:0] receiverArray [receiverLimit:0];
reg [elemSize:0] arrayIndex;
//reg [7:0] messageSize;
integer i;
always@(posedge clock or posedge reset)
begin
    if(reset)
        begin
            receiverState<=0;
            for(i=0;i<receiverLimit+1;i=i+1)
                receiverArray[i]<=0;    //not sure if this will cause problems  
            arrayIndex<=0;
        end
    else
        case(receiverState)
            IDLE:
                begin
                receiverState<=IDLE;
                /*
                can't be a button press this time
                
                if i receive something through UART, initiate receiver storage
                    
                
                */
                end
            //GETDATA
        endcase
end
endmodule
