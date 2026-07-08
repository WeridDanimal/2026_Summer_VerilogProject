`timescale 1ns / 1ps


module topmod_memonly_tb;

reg clock, reset;
reg [15:0] address;
reg [2:0] destReg;
reg [1:0] wr_en, rd_en;
reg agexout_valid;
wire [15:0] memResult;

topMod_memory_only debug(clock,reset,destReg, address,wr_en,rd_en,agexout_valid,memResult);

initial
begin
    clock=0; reset=0; address=0; wr_en=0; rd_en=0; agexout_valid=0; destReg=0;
    #5 reset=1;
    #5 reset=0;
    
    $display("===============================================================");
    $display("test 0: no permissions. passing agex result down to memory result");
    $display("===============================================================");
    #5 agexout_valid=1; address=16'h1234;
    
    
    //new debug version of memory hanlder takes ? steps to finish single-byte read
    $display("===============================================================");
    $display("test 1: single byte read");
    #5 agexout_valid=1; address=16'h0100; rd_en=1;
    //#20 agexout_valid=0;
   
    
    $display("=================================================================");
    $display("test 2: single byte write");
    #25 rd_en=0; wr_en=1; destReg=1;
    #10 agexout_valid=0;
    
    
    $display("=================================================================");
    $display("test 3: confirming single byte write");
    $display("=================================================================");
    #20 wr_en=0; rd_en=1; destReg=1; agexout_valid=1;

    
    /*
    $display("=================================================================");
    $display("test 4: double-byte read");
    $display("=================================================================");
    */
    
    
    
    //#25 agexout_valid=1; rd_en=3;
end

always #5 clock=~clock;

endmodule
