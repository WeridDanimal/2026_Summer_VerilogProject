`timescale 1ns / 1ps
/*
designed specifically to test very large image arrays

*/


module large_image_tb;

reg clock; reg reset; reg transmitButton;
wire tx;
reg rx;
reg dv;
reg [7:0] receiverInput;
//reg [7:0] imgArray [29:0];

reg [7:0] dummyData;

reg [7:0] imgDimensions [2:0];

integer i;

graphics_demo_debug simple_test(clock,reset,dv,transmitButton, rx, receiverInput, tx);
initial
begin
    clock=0;
    reset=0;
    dv=0;
    
    imgDimensions[0]=64; imgDimensions[1]=64; imgDimensions[2]=3;
    dummyData=0;
    
    rx=0;
   
    
    
    #1 reset=1;
    #1 reset=0;
    #1 dv=1; receiverInput=imgDimensions[0]; //row size
    #1 dv=0;
    #1 dv=1; receiverInput=imgDimensions[1]; //column size
    #1 dv=0;
    #1 dv=1; receiverInput=imgDimensions[2]; //byte size
    #1 dv=0;
    
    //FIRST PIXEL
    #1 dv=1; receiverInput=dummyData; dummyData=dummyData+1; 
    #1 dv=0;
    #1 dv=1; receiverInput=dummyData; dummyData=dummyData+1;
    #1 dv=0;
    #1 dv=1; receiverInput=dummyData; dummyData=dummyData+1;
    #1 dv=0;
    
    for(i=0;i<4095;i=i+1)//loop all remaining pixels
    begin
        #3 dv=1; receiverInput=dummyData; dummyData=dummyData+1; 
        #1 dv=0;
        #1 dv=1; receiverInput=dummyData; dummyData=dummyData+1; 
        #1 dv=0;
        #1 dv=1; receiverInput=dummyData; dummyData=dummyData+1; 
        #1 dv=0;
        
    end
    
    #3 transmitButton=1;
    #1 transmitButton=0;
    /*
    #3 dv=1; receiverInput=imgArray[6]; //pixel 2 in RGB order
    #1 dv=0;
    #1 dv=1; receiverInput=imgArray[7];
    #1 dv=0;
    #1 dv=1; receiverInput=imgArray[8];
    #1 dv=0;
    */
    
    
    
end
always #1 clock=~clock;

endmodule
