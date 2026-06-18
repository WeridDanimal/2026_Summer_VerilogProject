`timescale 1ns / 1ps


module second_clk(
    input clk,
    input reset,
    output clk_out
    );

reg [27:0] COUNT;
    assign clk_out=COUNT[8]; 
    

    always@(posedge clk)
        begin
        if(reset) begin
            COUNT=0;
            end
        else
            begin
            COUNT=COUNT+1;
            end
        end    
    
endmodule
