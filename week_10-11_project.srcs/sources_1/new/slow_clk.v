`timescale 1ns / 1ps


module slow_clk(
    input clk,
    input reset,
    output clk_out
    );
    

    /*notes on COUNT length, 
            24bit: barely slow enough to see individual segments flash
            28bit: feels a little too long to wait
    */
    reg [27:0] COUNT;
    //assign clk_out=COUNT[27]; //<--for real hardware only
    //reg [15:0] COUNT; //16 bits not slow enough to see digits flashing
    //assign clk_out=COUNT[15]; //<-- too long for simulation
    //reg [1:0] COUNT;          //simulator only
    assign clk_out=COUNT[18]; 
    

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
