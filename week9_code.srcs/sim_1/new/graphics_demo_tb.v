`timescale 1ns / 1ps

/*
Using a debug version that needs the testbench to give array of RGB values:
    test 1: check that the register file is correctly storing each pixel's RGB info (Note that RGB might be read as BGR)
        contents must be verified in console
        
        For a 3x3 sample, yes. The receiver returns to its idle state after completing all reads.
        It is evident that the write data is not accurate at the same clock cycle the last subpixel is received
        earliest point of accurate RGB encoding is next clock cycle.
        
    test 2: check that the top module is correctly sending R,G,and B to the transmitter
        data confirmed correctly parsed by the time it reaches the framebuffer.
        however, timing issue happens at last element when it appears that x and y got reset from the initial


    test 3: fetching data to transmitter
        transmitter module is disabled for now. data is correctly obtained. 
        
        I have to add back the transmitter to be sure it works with the transmitter module
            I think it does although i did not check if the simulator examined all subpixels before running out of time
    
    
===========================================================================================================================
Hardware test:

1. checking receiver module.
    i cannot directly verify if the receiver data is stored correctly. i can only read the rows, columns, and bytes used

2. laptop receiver:
    confirmed to receive all original data. only in 3x3 small sample size.
    confirmed to look identical when size is 63x63 for a downscaled image.
    
    failure at 64x64 up to 75x75 images
        peculiarly...pressing transmit button again makes the hardware unstuck
        
            but wait, that's not how it works. why? because the laptop is programmed to terminate the loop after receiving 
            all supposed required pixels.
                so I think the transmitter sequence prematurely ended, and pressing again means starting over from beginning
                of image
       
        but the rest of the data is looks corrupted, like it's copying from certain regions it shouldn't have visited
        again
        
    The debug/simulator version with UART receiver disabled suggests it SHOULD have received and transmitted everything correctly
    
        
next steps:
    laptop: make a module to interpret incoming data as RGB data
        this requires having to turn a 1D array back into a 2D array with each cell having RGB values
        
    laptop: finish the module designed to either only select a portion of the original input image array OR downscale it
    
    FPGA:
        test my idea of row image processing.
            because if the FPGA only sequentially accesses cell by cell, it defeats the purpose    
            feasibility of parallel read and writes is questionable. HOWEVER, parallel row processing is undoubtably possible
            and simple to do
        
*/



module graphics_demo_tb;
reg clock; reg reset; reg transmitButton;
wire tx;
reg rx;
reg dv;
reg [7:0] receiverInput;
reg [7:0] imgArray [29:0];

graphics_demo_debug simple_test(clock,reset,dv,transmitButton, rx, receiverInput, tx);
initial
begin
    clock=0;
    reset=0;
    dv=0;
    imgArray[0]=3; imgArray[1]=3; imgArray[2]=3;
    
    imgArray[3]=1; imgArray[4]=2; imgArray[5]=3;
    imgArray[6]=1; imgArray[7]=1; imgArray[8]=1;
    
    imgArray[9]=5; imgArray[10]=5; imgArray[11]=5;
    imgArray[12]=12; imgArray[13]=11; imgArray[14]=10;
   
    imgArray[15]=22; imgArray[16]=23; imgArray[17]=24;
    imgArray[18]=33; imgArray[19]=36; imgArray[20]=39;
    
    imgArray[21]=47; imgArray[22]=42; imgArray[23]=49;
    imgArray[24]=58; imgArray[25]=52; imgArray[26]=51;
    
    imgArray[27]=64; imgArray[28]=65; imgArray[29]=66;
    rx=0;
   
    
    
    #2 reset=1;
    #2 reset=0;
    #2 dv=1; receiverInput=imgArray[0]; //row size
    #2 dv=0;
    #2 dv=1; receiverInput=imgArray[1]; //column size
    #2 dv=0;
    #2 dv=1; receiverInput=imgArray[2]; //byte size
    #2 dv=0;
    
    
    
    #2 dv=1; receiverInput=imgArray[3]; //pixel 1 in RGB order
    #2 dv=0;
    #2 dv=1; receiverInput=imgArray[4];
    #2 dv=0;
    #2 dv=1; receiverInput=imgArray[5];
    #2 dv=0;
    
    
    #6 dv=1; receiverInput=imgArray[6]; //pixel 2 in RGB order
    #2 dv=0;
    #2 dv=1; receiverInput=imgArray[7];
    #2 dv=0;
    #2 dv=1; receiverInput=imgArray[8];
    #2 dv=0;
    
    
    #6 dv=1; receiverInput=imgArray[9]; //pixel 3 in RGB order
    #2 dv=0;
    #2 dv=1; receiverInput=imgArray[10];
    #2 dv=0;
    #2 dv=1; receiverInput=imgArray[11];
    #2 dv=0;
    
    
    
    #6 dv=1; receiverInput=imgArray[12]; //pixel 4 in RGB order //<--tested up to here
    #2 dv=0;
    #2 dv=1; receiverInput=imgArray[13];
    #2 dv=0;
    #2 dv=1; receiverInput=imgArray[14];
    #2 dv=0;
    
    #6 dv=1; receiverInput=imgArray[15]; //pixel 5 in RGB order
    #2 dv=0;
    #2 dv=1; receiverInput=imgArray[16];
    #2 dv=0;
    #2 dv=1; receiverInput=imgArray[17];
    #2 dv=0;
    
    #6 dv=1; receiverInput=imgArray[18]; //pixel 6 in RGB order
    #2 dv=0;
    #2 dv=1; receiverInput=imgArray[19];
    #2 dv=0;
    #2 dv=1; receiverInput=imgArray[20];
    #2 dv=0;
    
    #6 dv=1; receiverInput=imgArray[21]; //pixel 7 in RGB order
    #2 dv=0;
    #2 dv=1; receiverInput=imgArray[22];
    #2 dv=0;
    #2 dv=1; receiverInput=imgArray[23];
    #2 dv=0;
    
    #6 dv=1; receiverInput=imgArray[24]; //pixel 8 in RGB order
    #2 dv=0;
    #2 dv=1; receiverInput=imgArray[25];
    #2 dv=0;
    #2 dv=1; receiverInput=imgArray[26];
    #2 dv=0;
    
    #6 dv=1; receiverInput=imgArray[27]; //pixel 9 in RGB order. For a 3x3 grid, it SHOULD go to IDLE
    #2 dv=0;
    #2 dv=1; receiverInput=imgArray[28];
    #2 dv=0;
    #2 dv=1; receiverInput=imgArray[29];
    #2 dv=0;
    
    #6 transmitButton=1;
    #2 transmitButton=0;
    
end
always #2 clock=~clock;
endmodule
