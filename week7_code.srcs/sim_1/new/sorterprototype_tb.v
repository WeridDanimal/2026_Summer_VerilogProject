`timescale 1ns / 1ps

/*
so far, reset state is functional

*/
module sorterprototype_tb;
reg clock,reset, mode, startButton;
wire [3:0] elem0,elem1,elem2,elem3,elem4,elem5,elem6,elem7,elem8,elem9;
wire [1:0] sortProgressOut;
wire [2:0] sortStateOut;
sorterPrototype_topmod tenElems(clock,reset,startButton,mode,
 elem0,elem1,elem2,elem3,elem4,elem5,elem6,elem7,elem8,elem9,
 sortProgressOut,sortStateOut);

initial
begin
    clock=0;reset=0; mode=0; startButton=0;
    #5 reset=1;
    #5 reset=0;
    #5 startButton=1;
    #5 startButton=0;
    
end

always #5 clock=~clock;

endmodule
