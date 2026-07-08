`timescale 1ns / 1ps

module topmodule_tb;
reg clock, reset,transmit, receiverFinish;
//reg [15:0] machineCode;
reg[7:0] sw, receiverData;
wire rx, tx;
wire [15:0] led;
wire decodeSignal, agexSignal, memSignal;
wire [15:0] instruction;

wire aluValidOut;
wire decodeValidOut;
wire [1:0] cpu_state;

cpu_debug topmod_testbench(.clock(clock),.reset(reset),.transmit(transmit),
.incomingData(receiverData), .uart_receive_finish(receiverFinish),.sw(sw),.led(led),
.decodeSignal(decodeSignal),.aluSignal(agexSignal),.memSignal(memSignal), .encodedInstruct(instruction),
 .decodeValidOut(decodeValidOut), .aluValidOut(aluValidOut),
 .cpu_state(cpu_state));


initial
begin
    clock=0; reset=0; transmit=0;
    #5 reset=1;
    #5 reset=0;
    
    
//test 1: execute ADD R1,R1,xF      expected result, R1=xF.                 x126f
    #5 receiverFinish=1; receiverData=8'h6f;
    #10 receiverData=8'h12;
    #5 receiverFinish=0;
/*    
//expectation: LED should be able to change LED lights shown


//test 2: execute ADD R1,R1, x1.    expected result, R1=x0010               x1261
    #20 receiverFinish=1; receiverData=8'h61;
    #15 receiverData=8'h12;
    #5 receiverFinish=0;
    
    
//test 3: execute ADD R2,R1,R1.     expeted  result, R2=x0020               x1441   
    #20 receiverFinish=1; receiverData=8'h41;
    #15 receiverData=8'h14;
    #5 receiverFinish=0;
    
    

    //test 4: execute ADD R2,R2,#0      expected result, R2=x0020           x14a0
    
    
    #20 receiverFinish=1; receiverData=8'ha0;
    #15 receiverData=8'h14;
    #5 receiverFinish=0;
    

    
    //test 5: execute ADD R3,R2,x1F     expected result, R3=x001f           x16bf;
    #20 receiverFinish=1; receiverData=8'hbf;
    #15 receiverData=8'h16;
    #5 receiverFinish=0;
    
    
    //test 6: AND R4,R3, X00            expected result, R4=x0000           x58e0
    #20 receiverFinish=1; receiverData=8'he0;
    #15 receiverData=8'h58;
    #5 receiverFinish=0;
    
    //test 7: XOR R5,R3,R3              expected result, R5=x0000           x9ac3
    #20 receiverFinish=1; receiverData=8'hc3;
    #15 receiverData=8'h9a;
    #5 receiverFinish=0;
    
    
    
    //test 8: LSHF R5, R1, #4                    result, R5=x0100           xda44
    #20 receiverFinish=1; receiverData=8'h44;
    #15 receiverData=8'hda;
    #5 receiverFinish=0;
    //fail. why is it reading R3?
    
    
    
    //test 9: RSHFL R7, R3, #3          expected result, R7= x0003          xded3
    #20 receiverFinish=1; receiverData=8'hd3;
    #15 receiverData=8'hde;
    #5 receiverFinish=0;
    
    //test 10:  XOR R6,R6, x1f          expected result, R6= xFFFF          x9dbf
    #20 receiverFinish=1; receiverData=8'hbf;
    #15 receiverData=8'h9d;
    #5 receiverFinish=0;
    
    //test 11: AND R6,R6, x1a           expected result, r6=xFFFa           x5dba
    #20 receiverFinish=1; receiverData=8'hba;
    #15 receiverData=8'h5d;
    #5 receiverFinish=0;
    
    //test 12: RSHFA R6,R6,#2           expected result, r6=xFFFE           xddb2
    #20 receiverFinish=1; receiverData=8'hb2;
    #15 receiverData=8'hdd;
    #5 receiverFinish=0;
    
    
     //test 13: LDB R0, R5, #0           expected result, R0=0000           x2140
    $display("==================================================");
    $display("test 13 performed");
    #20 receiverFinish=1; receiverData=8'h40;
    #15 receiverData=8'h21;
    #5 receiverFinish=0;
    
    
    $display("==================================================");
    $display("test 14 performed");
    
    //test 14: STB R6, R5,#0            expected result, mem[R5]=xFE        x3d40
    
    #30 receiverFinish=1; receiverData=8'h40;
    #15 receiverData=8'h3d;
    #5 receiverFinish=0;

            
    $display("test 15 performed. reloading address");                       
    //test 15: LBD R0, R5,#0            expected result, R0=xFFFe           x2140
    #20 receiverFinish=1; receiverData=8'h40;
    #15 receiverData=8'h21;
    #5 receiverFinish=0;
    
    
    //test 16: LDW R0, R5, #0           expected result, R0=x00fe           x6140
    #20 receiverFinish=1; receiverData=8'h40;
    #15 receiverData=8'h61;
    #5 receiverFinish=0;
    
    
    //test 17: STW R6, R5, #0
    #40 receiverFinish=1;   receiverData=8'h40;
    #15 receiverData=8'h7d;
    #5 receiverFinish=0;
    
    //test 18: LDW R0,R5,#0             expected result, R0=xFFFE
    #50 receiverFinish=1; receiverData=8'h40;
    #15 receiverData=8'h61;
    #5 receiverFinish=0;*/
end


//simulation verified results up to Test ??




always #5 clock=~clock;
endmodule

/*
observations:
    since i made it an output reg, the information is still preserved when a wire pulls from it.
*/
