`timescale 1ns / 1ps


module register_file

#(parameter imgRows=75, parameter imgCols=75, parameter elemSize=24)



(input clock, input reset,
input write_enable,
//input writeRow_enable, //experimental only
input [rowBits-1:0] x, 
input [colBits-1:0] y, 



//input [elemSize*imgCols-1:0] writeRow_data, //experimental only
input [elemSize-1:0] writeCell_data,
output reg [elemSize-1:0] readCell_data
//output [elemSize*imgCols-1:0] readRow_data  //experimental only
    );

parameter rowBits=$clog2(imgRows); parameter colBits=$clog2(imgCols);

localparam ADDR_BITS = $clog2(imgRows*imgCols);

wire [ADDR_BITS-1:0] addr;

assign addr = x*imgCols + y;



initial 
begin
    $display("===============================================================");
    $display("REGISTER FILE HARDWARE CHECK: row count=%d. col count=%d, rowbits=%d, colBits=%d",
        imgRows, imgCols, rowBits, colBits);
    $display("TOTAL AVAIALABLE ADDRESSES=%d",(imgRows*imgCols));
end


integer i,j;


//attempt 1: storing image as a 1D BRAM block.
reg [elemSize-1:0] imgBRam [(imgRows*imgCols)-1:0];

//wire [15:0] addr = x * imgCols + y;
always@(posedge clock)
begin
    if(write_enable)
        begin
        imgBRam[addr]<=writeCell_data; //it shouldn't cause errors right? is there any circumstance that could lead to erroneous wraparounds?
        $display("writing RGB=%h to pixel x=%d, y=%d",writeCell_data,x,y); //this would only tell me that the input data is correct
        end 
    else
        readCell_data<=imgBRam[(x*imgCols)+y];
    begin
        
    end
end

    
endmodule
