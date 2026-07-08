`timescale 1ns / 1ps


module bitonic_tb;

reg clock, reset;
reg[7:0] unsortedArray [31:0];
wire [7:0] sortedArray[31:0];


bitonic_topmodule test1(clock,reset,

{unsortedArray[31],unsortedArray[30],unsortedArray[29],unsortedArray[28],
unsortedArray[27],unsortedArray[26],unsortedArray[25],unsortedArray[24],
unsortedArray[23],unsortedArray[22],unsortedArray[21],unsortedArray[20],
unsortedArray[19],unsortedArray[18],unsortedArray[17],unsortedArray[16],
unsortedArray[15],unsortedArray[14],unsortedArray[13],unsortedArray[12],
unsortedArray[11],unsortedArray[10],unsortedArray[9],unsortedArray[8],
unsortedArray[7],unsortedArray[6],unsortedArray[5],unsortedArray[4],
unsortedArray[3],unsortedArray[2],unsortedArray[1],unsortedArray[0]},

{sortedArray[31],sortedArray[30],sortedArray[29],sortedArray[28],
sortedArray[27],sortedArray[26],sortedArray[25],sortedArray[24],
sortedArray[23],sortedArray[22],sortedArray[21],sortedArray[20],
sortedArray[19],sortedArray[18],sortedArray[17],sortedArray[16],

sortedArray[15],sortedArray[14],sortedArray[13],sortedArray[12],
sortedArray[11],sortedArray[10],sortedArray[9],sortedArray[8],
sortedArray[7],sortedArray[6],sortedArray[5],sortedArray[4],
sortedArray[3],sortedArray[2],sortedArray[1],sortedArray[0]});


//43 16 7 37 27 26 11 29 
//15 40 5 31 10 1 0 23 
//32 14 34 25 46 48 49 33 
//24 30 45 47 22 3 4 44

initial
begin
    clock=0; reset=0;
    
    unsortedArray[0]=43; 
    unsortedArray[1]=16;     
    unsortedArray[2]=7;     
    unsortedArray[3]=37;     
    unsortedArray[4]=27;     
    unsortedArray[5]=26;   
    unsortedArray[6]=11;    
    unsortedArray[7]=29;    
    
    unsortedArray[8]=15; 
    unsortedArray[9]=40;     
    unsortedArray[10]=5;     
    unsortedArray[11]=31;     
    unsortedArray[12]=10;     
    unsortedArray[13]=1;   
    unsortedArray[14]=0;    
    unsortedArray[15]=23; 
    
    //32 14 34 25 46 48 49 33 
    unsortedArray[16]=32; 
    unsortedArray[17]=14;     
    unsortedArray[18]=34;     
    unsortedArray[19]=25;     
    unsortedArray[20]=46;     
    unsortedArray[21]=48;   
    unsortedArray[22]=49;    
    unsortedArray[23]=33; 
    //24 30 45 47 22 3 4 44
    unsortedArray[24]=24; 
    unsortedArray[25]=30;     
    unsortedArray[26]=45;     
    unsortedArray[27]=47;     
    unsortedArray[28]=22;     
    unsortedArray[29]=3;   
    unsortedArray[30]=4;    
    unsortedArray[31]=44; 
end


/*
Test 1: Results *appear* accurate for 8 elements

More tests:
    8 elements, PASSED
    16 elements, PASSED
    32 elements, PASSED
    64 elements

*/

endmodule
