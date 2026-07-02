`timescale 1ns / 1ps

/*
changelog: isolating the code relevant to receiving a complete
instruction from UART

-modifying code to follow pipelining structure

*/
module instruction_receiver(input clock, input reset, 
input dv, input [7:0] rx_data, output reg [15:0] instruction_buffer,
input decode_isReady,
output reg instruction_isValid);


//reg [15:0] instruction_buffer;

reg byteLocation;

//reg valid;
//wire fetch_ready;
//assign fetch_ready=!valid | decode_isReady;

always@(posedge clock or posedge reset)
begin
    //$display("At time=%t, incoming data=",rx_data);
    if(reset)
       
        begin
        //$display("internal instruction buffer wiped");
        byteLocation<=0;
        instruction_buffer<=0;
        //valid<=0;
        end
    else
        begin

        
        //i'm not sure if this design makes it impossible to proceed to next instruction
        if(decode_isReady)
        begin
            instruction_isValid<=0;
            /*not sure if this is foolproof. the valid signal is only wiped if decoder is ready
            */
            if(dv)
                begin
                //$display("================================================================");
                //$display("authorized to fill buffer. incoming data=%h",rx_data);
                if(byteLocation==0)
                    begin
                    instruction_buffer[7:0]<=rx_data;
                    byteLocation<=1;
                    //valid<=0;
                    instruction_isValid<=0;
                    end
                else
                    begin
                    instruction_buffer[15:8]<=rx_data;
                    //$display("instruction_receiver claims decoder authorized next cycle");
                    byteLocation<=0;
                    //valid<=1;
                    instruction_isValid<=1;
                    end
                    
                //$display("instruction buffer currently:",instruction_buffer);
                //$display("instruction valid?=",instruction_isValid);
                end
                
            else
                byteLocation<=byteLocation;
            end
        end

end

endmodule
/*
briefly considered complications of decode_ready and dv.
however, in theory, it shouldn't be an issue because
1. uart transmission controlled by buttons for now
2. one of the stages will eventually control when laptop sends next instruction

*/