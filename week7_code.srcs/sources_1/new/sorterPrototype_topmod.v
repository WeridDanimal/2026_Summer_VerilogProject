`timescale 1ns / 1ps
/*
Design goal:
    Successfully create some type of array sorter
    
    for now, preset the unsorted array

    and for now, start with the relatively simple brick sort(even/odd)

    This prototype uses a FSM-approach to handle an arbitrary size of data. 
    Each state represents a process in the sorting. 
    
        I think the significant bottleneck comes from the amount of intermediate variables required to prevent 
        invalid array accesses for each comparator

*/

module sorterPrototype_topmod
#(parameter IDLE=0, EVEN_ODDSORT=1, ODD_EVENSORT=2,EVAL_SORT=3)
(input clock, input reset, input startButton, input mode,

output [3:0] elem0, output [3:0]elem1, output[3:0]elem2, output[3:0] elem3, output [3:0]elem4,
output [3:0]elem5, output[3:0] elem6,output [3:0]elem7,output [3:0]elem8, output [3:0]elem9,
output [1:0] sortProgressOut, output [2:0] sortStateOut

    );

reg [3:0] sampleArray [9:0];
    
reg [3:0] a1,b1,a2,b2,a3,b3;    //index variables for comparators 1,2,3
reg [3:0] ain1, bin1, ain2, bin2, ain3, bin3;   //middle-layer variables designed to prevent invalid index accesses
reg [1:0] sortProgress; 
//informs top module if array is completely sorted. Bit 1= is even/odd completely sorted? Bit 0= is odd/even completely sorted?

assign sortProgressOut=sortProgress;

reg [2:0] sorterState;
assign sortStateOut=sorterState;

wire [3:0] aout_1, bout_1, aout_2, bout_2, aout_3,bout_3;
wire unsorted1, unsorted2, unsorted3;
sorter_comparator sorter1(mode, ain1, bin1, aout_1, bout_1,unsorted1);
sorter_comparator sorter2(mode, ain2, bin2, aout_2, bout_2,unsorted2);
sorter_comparator sorter3(mode, ain3, bin3, aout_3, bout_3,unsorted3);

assign elem0=sampleArray[0];
assign elem1=sampleArray[1];
assign elem2=sampleArray[2];
assign elem3=sampleArray[3];
assign elem4=sampleArray[4];
assign elem5=sampleArray[5];
assign elem6=sampleArray[6];
assign elem7=sampleArray[7];
assign elem8=sampleArray[8];
assign elem9=sampleArray[9];

always@(posedge clock or posedge reset)
begin
    if(reset)
        begin
        sampleArray[0]<=3;
        sampleArray[1]<=2;
        sampleArray[2]<=0;
        sampleArray[3]<=5;
        sampleArray[4]<=4;
        
        sampleArray[5]<=7;
        sampleArray[6]<=15;
        sampleArray[7]<=9;
        sampleArray[8]<=11;
        sampleArray[9]<=13;
        
        sortProgress<=0;
        sorterState<=0;
        
        a1<=0;
        a2<=2;
        a3<=4;
        b1<=1;
        b2<=3;
        b3<=5;
        
        end
    else
        begin
        
        case(sorterState)
            IDLE:
                begin
                    sorterState<=IDLE;
                    sortProgress<=0;
                    
                    ain1<=(0>=9)? 0: sampleArray[a1];
                    ain2<=(2>=9)? 0: sampleArray[a2];
                    ain3<=(4>=9)? 0: sampleArray[a3];
                    bin1<=(1>=9)? 0: sampleArray[b1];
                    bin2<=(3>=9)? 0: sampleArray[b2];
                    bin3<=(5>=9)? 0: sampleArray[b3];
                          
                    if(startButton)
                        begin
                        $display("Begining Sorting Process. TIMESTAMP: %0t",$realtime);
                        sorterState<=EVEN_ODDSORT;
                        end
                end
            EVEN_ODDSORT://compares all even-odd index pairs (such as 0 to 1, 2 to 3, 4 to 5, etc...)
                begin
                    
                    sorterState<=EVEN_ODDSORT;
                    $display("======================================================================");
                    $display("EVEN-ODD sort state. TIMESTAMP: %0t",$realtime);
                    $display("Inputs A1=%d, B1=%d, A2=%d, B2=%d, A3=%d, B3=%d", a1,b1,a2,b2,a3,b3);
                    $display("Outputs Aout1=%d, Bout1=%d, Aout2=%d, Bout2=%d, Aout3=%d, Bout3=%d",
                        aout_1,bout_1,aout_2,bout_2,aout_3,bout_3);
                    
                    if(a1>=9) //if first left-sided index is at last or exceeds last index, move to odd/even sort
                        begin
                        $display("INSUFFICIENT COMPARSIONS.Moving to Odd-Even sort");
                        sorterState<=ODD_EVENSORT;
                        
                        a1<=1;
                        a2<=3;
                        a3<=5;
                        b1<=2;
                        b2<=4;
                        b3<=6;
                        
                        ain1<=(1>=9)? 0: sampleArray[1];
                        ain2<=(3>=9)? 0: sampleArray[3];
                        ain3<=(5>=9)? 0: sampleArray[5];
                        bin1<=(2>=9)? 0: sampleArray[2];
                        bin2<=(4>=9)? 0: sampleArray[4];
                        bin3<=(6>=9)? 0: sampleArray[6];
                        
                        end
                    else
                        begin
                        //must have information of previous sorting progrss on this stage.
                        //IF IT EVER BECOMES 1, IT CANNOT BE UNDONE AT THIS STAGE. IT SIGNALS THE HALF IS NOT SORTED
                        sortProgress[0]<= sortProgress[0] | unsorted1 | unsorted2 | unsorted3;
                        
                        //only sent comparator outputs to array if indexes are within bounds
                        if(a1<=9)
                            sampleArray[a1]<=aout_1;
                        else
                            $display("index a1=%d is out of bounds. do not store",a1);
                        if(a2<=9)
                            sampleArray[a2]<=aout_2;
                        else
                            $display("index a2=%d is out of bounds. do not store",a2);
                        if(a3<=9)
                            sampleArray[a3]<=aout_3;
                        else
                            $display("index a3=%d is out of bounds. do not store",a3);
                            
                        if(b1<=9)
                            sampleArray[b1]<=bout_1;
                        else
                            $display("index b1=%d is out of bounds. do not store",b1);
                        if(b2<=9)
                            sampleArray[b2]<=bout_2;
                            else
                            $display("index b2=%d is out of bounds. do not store",b2);
                        if(b3<=9)
                            sampleArray[b3]<=bout_3;
                            else
                            $display("index b3=%d is out of bounds. do not store",b1);
                      
                        a1<=(a1+6>=9)? 11:a1+6;     
                        a2<=(a2+6>=9)? 11:a2+6;
                        a3<=(a3+6>=9)? 11:a3+6;
                        b1<=(a1+6>=9)? 11:b1+6;
                        b2<=(a2+6>=9)? 11:b2+6;
                        b3<=(a3+6>=9)? 11:b3+6;
                        
                        //display only
                        if(a1+3>=9)
                            $display("a1 will be out of bounds");
                        if(a2+3>=9)
                            $display("a2 will be out of bounds");
                        if(a3+3>=9)
                            $display("a3 will be out of bounds");
                        if(b1+3>=9)
                            $display("b1 will be out of bounds");
                        if(b2+3>=9)
                            $display("b2 will be out of bounds");
                        if(b3+3>=9)
                            $display("b3 will be out of bounds");
                        //display: only show if indexes are within bounds
                        if(a1<=9)
                            $display("sampleArray[a1]=%d",aout_1);
                        if(b1<=9)
                            $display("sampleArray[b1]=%d",bout_1);
                        if(a2<=9)
                            $display("sampleArray[a2]=%d",aout_2);
                        if(b2<=9)
                            $display("sampleArray[b2]=%d",bout_2);
                        if(a3<=9)
                            $display("sampleArray[a3]=%d",aout_3);
                        if(b3<=9)
                            $display("sampleArray[b3]=%d",bout_3);
                        
                        
                        
                        ain1<=(a1+6>=9)? 0: sampleArray[a1+6];
                        ain2<=(a2+6>=9)? 0: sampleArray[a2+6];
                        ain3<=(a3+6>=9)? 0: sampleArray[a3+6];
                        bin1<=(a1+6>=9)? 0: sampleArray[b1+6];
                        bin2<=(a2+6>=9)? 0: sampleArray[b2+6];
                        bin3<=(a3+6>=9)? 0: sampleArray[b3+6];
                        
                        end
                    $display("======================================================================");
                end
                
                
            ODD_EVENSORT:
                begin
                    $display("ODD-EVEN SORT STATE. TIMESTAMP=%0t",$realtime);
                    $display("Inputs A1=%d, B1=%d, A2=%d, B2=%d, A3=%d, B3=%d", a1,b1,a2,b2,a3,b3);
                    $display("Outputs Aout1=%d, Bout1=%d, Aout2=%d, Bout2=%d, Aout3=%d, Bout3=%d",
                        aout_1,bout_1,aout_2,bout_2,aout_3,bout_3);
                    
                    
                    sorterState<=ODD_EVENSORT;
                    
                    if(a1>=9)
                        begin
                        $display("INSUFFICIENT COMPARISONS. MOVING TO SORT EVALUATION");
                        sorterState<=EVAL_SORT;
                        end
                    else
                        begin
                            sortProgress[1]<= sortProgress[1] | unsorted1 | unsorted2 | unsorted3;
                            if(a1<=9)
                            sampleArray[a1]<=aout_1;
                            else
                                $display("index a1=%d is out of bounds. do not store",a1);
                            if(a2<=9)
                                sampleArray[a2]<=aout_2;
                            else
                                $display("index a2=%d is out of bounds. do not store",a2);
                            if(a3<=9)
                                sampleArray[a3]<=aout_3;
                            else
                                $display("index a3=%d is out of bounds. do not store",a3);
                            
                            if(b1<=9)
                                sampleArray[b1]<=bout_1;
                            else
                                $display("index b1=%d is out of bounds. do not store",b1);
                            if(b2<=9)
                                sampleArray[b2]<=bout_2;
                                else
                                $display("index b2=%d is out of bounds. do not store",b2);
                            if(b3<=9)
                                sampleArray[b3]<=bout_3;
                                else
                                $display("index b3=%d is out of bounds. do not store",b1);
                                    
                                a1<=(a1+6>=9)? 11:a1+6;     
                                a2<=(a2+6>=9)? 11:a2+6;
                                a3<=(a3+6>=9)? 11:a3+6;
                                b1<=(a1+6>=9)? 11:b1+6;
                                b2<=(a2+6>=9)? 11:b2+6;
                                b3<=(a3+6>=9)? 11:b3+6;
                                
                                ain1<=(a1+6>=9)? 0: sampleArray[a1+6];
                                ain2<=(a2+6>=9)? 0: sampleArray[a2+6];
                                ain3<=(a3+6>=9)? 0: sampleArray[a3+6];
                                bin1<=(a1+6>=9)? 0: sampleArray[b1+6];
                                bin2<=(a2+6>=9)? 0: sampleArray[b2+6];
                                bin3<=(a3+6>=9)? 0: sampleArray[b3+6];
                        end    
                end
            EVAL_SORT:
                begin
                    $display("Sort Evalution State. TIMESTAMP=%0t",$realtime);
                    //sorterState<=EVAL_SORT;
                    
                    if(sortProgress==0)
                        begin
                        $display("Sorting Completed");
                        sorterState<=IDLE;
                        end
                    else
                        begin
                        $display("Sorting Failed");
                        
                        sortProgress<=0;
                        sorterState<=EVEN_ODDSORT;
                        a1<=0;
                        a2<=2;
                        a3<=4;
                        b1<=1;
                        b2<=3;
                        b3<=5;
                        ain1<=(0>=9)? 0: sampleArray[0];
                        ain2<=(2>=9)? 0: sampleArray[2];
                        ain3<=(4>=9)? 0: sampleArray[4];
                        bin1<=(1>=9)? 0: sampleArray[1];
                        bin2<=(3>=9)? 0: sampleArray[3];
                        bin3<=(5>=9)? 0: sampleArray[5];
                        
                        //reset all indexes too
                        end
                end
        endcase
              
        end
end

endmodule
/*

STATUS:     FAILURE
    1. Did not return to Idle State until much later, not clear why
    2. did not stay at Idle State despite the start button not being pressed

*/