`timescale 1ns / 1ps

/*
different strategy: separating register file and memory instruction handler to make it easier for 
controls and understanding what should be designed

*/
module regFile_redesign(
    input clock, input reset,
    input wr_en,
    input [7:0] writeData,
    output reg [7:0] readData,
    //output [7:0] readData,
    input [15:0] inputAddress
    );
    
reg [7:0] usable_memory [(2**16)-1:0]; //16 bit address space



//disable this block for synthesis
integer i;
	initial begin  //initialize all memory spaces
		for (i = 0; i < (2**16); i = i + 1) begin
			usable_memory[i]=8'd0;
		end
	    $display("proof of initialization-", usable_memory[0]);
	    $display("initial content at #10-", usable_memory[10]);
	    $display("initial content at #256-", usable_memory[16'd256]);
	    $display("content of read_data before reset",readData);
	    readData=0;
	    $display("read_data after reset,",readData);
	end



//Block 1: BRAM Block. i think so far, can only handle 1 write signal at a time
always @(posedge clock)
begin
    $display("======================================================================");
    $display("Memory Bank TIMESTAMP:%0t",$realtime);
    $display("======================================================================");
    if (wr_en)
        begin
        $display("write authorized, writing=%h at address=%h",writeData, inputAddress);
        usable_memory[inputAddress] <= writeData;
        end
    readData <= usable_memory[inputAddress];
    //it's this line right here...
    
    $display("MEMORY: addr=%h readData=%h mem=%h",inputAddress,readData, usable_memory[inputAddress]);
    $display("address x0100 holds data=%h address x0101 holds data=%h",usable_memory[16'h0100],usable_memory[16'h0101]);
end    


endmodule 
