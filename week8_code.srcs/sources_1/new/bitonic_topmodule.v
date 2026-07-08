`timescale 1ns / 1ps

/*
states this sorter requires:
1. idle
2. loader: loading items from memory into sorter
3. sort state
4. merge state

*/

module bitonic_topmodule #(
parameter MAX_SUBSET=32,//i think this will be important to inform top module how many mergers are in each layer,

parameter LOGN=$clog2(MAX_SUBSET),
parameter STAGES=(LOGN*(LOGN+1))/2, //mathematical equation required to dynamically generate enough spaces to store input, intermediate calculations, and result

parameter DEPTH=$clog2(MAX_SUBSET),
parameter ELEM_SIZE=8
)
(input clock, input reset, 
 input [(MAX_SUBSET*ELEM_SIZE)-1:0] unsortedArray, //i don't think i can have 2d arrays as an input
 output [(MAX_SUBSET*ELEM_SIZE)-1:0] sortedArray 
    );


wire  [ELEM_SIZE-1:0] sortNetwork[STAGES:0][MAX_SUBSET-1:0]; 
//assign sortNetwork[0]=unsortedArray;


genvar x;
genvar y;
generate
    for(x=0;x<MAX_SUBSET;x=x+1)
    begin
        for(y=0;y<ELEM_SIZE;y=y+1)
            begin
                assign sortNetwork[0][x][y]=unsortedArray[(ELEM_SIZE*x)+y];
            end
    end
endgenerate

generate
    for(x=0;x<MAX_SUBSET;x=x+1)
    begin
        for(y=0;y<ELEM_SIZE;y=y+1)
            begin
            assign sortedArray[y+(ELEM_SIZE*x)]=sortNetwork[STAGES][x][y];
            end
    end
endgenerate


genvar i;
genvar j;
genvar k;
genvar l;



//DO NOT USE, SOME CALCULATIONS MAY BE WRONG
generate 

    initial
    begin
        $display("This network can sort %d elements. The network has %d stages",MAX_SUBSET,STAGES);
    end

    for(i=0;i<DEPTH;i=i+1)//traverses depth by depth
    begin
    
        localparam maxSublayer=i+1;
        
        localparam maxOffset=2**(i+1); //i'm thinking this can be used to determine direction of sort
        
        initial
        begin
            $display("=================================================");
            $display("Current Depth I=%d",i);
            $display("total layers at this depth=%d",maxSublayer);
        end
        
        for(j=0;j<maxSublayer;j=j+1) //instantiates sub-layers, also configures offset between index numbers
            begin
                localparam offset=2**(maxSublayer-j-1);
                

                
                initial
                begin
                    $display("offset=%d",offset);
                end
                
                for(k=0;k<MAX_SUBSET;k=k+(offset*2))
                    begin
                        
                        
                        for(l=0;l<offset;l=l+1)
                        begin
                            
                           
                            localparam currentStage=((i)*(i+1))/2+j; //it's unclear if i can use genvars like this. i can only know
                            //if it is successfully synthesized
                            localparam nextStage=currentStage+1;
                            
                            

                            
                            localparam currentIndex=k+l;
                            localparam var1=currentIndex/maxOffset;
                            localparam tempMode=var1& 1'b1 ? 1:0;
                            
                            localparam mode=(i==DEPTH-1)? 1'b0:tempMode;
                            
                            initial
                            begin
                                $display("CURRENT INDEX=%d compared with index=%d, var1=%d tempMode=%d",
                                currentIndex,(currentIndex+offset), var1,tempMode);
                                //$display("building comparator #%d",comparatorCount);
                                //$display("var1 bit0=%d, L_bit0=%d.  tempMode=%d",trunc1,trunc2,tempMode);                    
                                //$display("take indexes %d and %d from STAGE=%d to STAGE=%d. MODE=%d",
                                //(k+l),(k+l+offset),currentStage,nextStage, mode);
                            end
                            
                            
                            
                            //I can't tell if synthesis correctly wired everything together even from the schematic
                            comparator subunit(mode,sortNetwork[currentStage][k+l], sortNetwork[currentStage][k+l+offset],
                            sortNetwork[currentStage+1][k+l],sortNetwork[currentStage+1][k+l+offset]);
                            
                            /*
                            comparator subunit(1'b0,
                            sortNetwork[currentStage][k+l], 
                            sortNetwork[currentStage][k+l+offset],
                            sortNetwork[currentStage+1][k+l],sortNetwork[currentStage+1][k+l+offset]);
                            */
                        end
                    
                    end
            end
    end
endgenerate 

    
endmodule



/*
Challenges:
    1. how do you sort a smallest chunk?
    2. how do you make the smallest chunk be at least some elements large?
    3. how do you merge chunks into larger chunks?
*/

