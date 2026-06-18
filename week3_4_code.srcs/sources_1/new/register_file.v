`timescale 1ns / 1ps


module register_file
#(parameter address_bits=16, //number of bits available to encode all addresses
  parameter memory_size=8) //memory_size=number of bits per address
(input [address_bits-1:0] read_address,
 input [address_bits-1:0] write_address,
 output reg [memory_size-1:0] read_data,
 input [memory_size-1:0] write_data,
 input wr_en,    //write enable,
                 //do i need write enable 2?
 input clk,
 input rd_en
 
    );

/*source of synthesis stalling: too many addresses to process?
256 addresses=no problem*/
reg [memory_size-1:0] usable_memory [(2**address_bits)-1:0];
     

integer i;
	initial begin  //initialize all memory spaces
		for (i = 0; i < (2**address_bits); i = i + 1) begin
			usable_memory[i]=8'd0;
		end
	    $display("proof of initialization-", usable_memory[0]);
	    $display("initial content at #10-", usable_memory[10]);
	    $display("initial content at #256-", usable_memory[16'd256]);
	    $display("content of read_data before reset",read_data);
	    read_data=0;
	    $display("read_data after reset,",read_data);
	end
     
     
always@(posedge clk)
begin
    $display("write enable?", wr_en);
    if(wr_en)
        begin
            $display("writing enable check trigger. write data=",write_data);
            $display("writing address=", write_address);
            $display("write enable", wr_en);    //only shows that the writing data is being sent, but not clear if it is being saved
            usable_memory[write_address]<=write_data;
            $display("content saved=",usable_memory[write_address]);
        end
    
    
    

    $display("trying to read address,",read_address);
    $display("contents=",usable_memory[read_address]);
    read_data<=usable_memory[read_address];

end
endmodule
