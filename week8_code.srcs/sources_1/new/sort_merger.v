`timescale 1ns / 1ps

//given two sorted sequences, merge into one array.
//I think should require both arrays be of same length
//should probably also output a 


module sort_merger
#(parameter ARRAY_SIZE=8, parameter MERGED_SIZE=ARRAY_SIZE*2, parameter ELEM_SIZE=8,
  parameter ASCENDING=0, parameter DESCENDING=1)

(input [ELEM_SIZE-1:0] sortedA [ARRAY_SIZE-1:0], input [ELEM_SIZE-1:0] sortedB [ARRAY_SIZE-1:0],
input mode,
//output [ELEM_SIZE-1:0] mergedArray [MERGED_SIZE-1:0] //<--intended output
output reg [(ELEM_SIZE*ARRAY_SIZE*2)-1:0] mergedArray //workaround code if 2d arrays are not allowed
);

/*
this could probably just be a combinatorial circuit that routes elements in parallel

*/
integer i;
always@(*)
begin
    for(i=0;i<ARRAY_SIZE;i=i+1)
    begin
        if(mode==ASCENDING)
            begin
                //mergedArray[2*i]= (sortedA[i]>sortedB[i])? sortedB[i]: sortedA[i];
                //mergedArray[(2*i)+1]= (sortedA[i]>sortedB[i])? sortedA[i]: sortedB[i];
            end
        else //DESCENDING MODE
            begin
                //mergedArray[2*i]= (sortedA[i]<sortedB[i])? sortedB[i]: sortedA[i];
                //mergedArray[(2*i)+1]= (sortedA[i]<sortedB[i])? sortedA[i]: sortedB[i];
            end
    end
end
endmodule
