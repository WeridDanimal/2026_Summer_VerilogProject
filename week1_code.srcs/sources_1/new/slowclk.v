`timescale 1ns / 1ps


module slowclk( input clk, input reset, output clk_out, output counter_clk);

reg [27:0] COUNT;

always@(posedge clk)
begin 
    if(reset)
        COUNT=0;
    else
        COUNT=COUNT+1;
end

assign counter_clk=COUNT[24];   //HARDWARE ONLY
assign clk_out=COUNT[18];       //HARDWARE ONLY

//assign clk_out=COUNT[1];  //simulator only
//assign counter_clk=COUNT[2];    //simulator only
endmodule


