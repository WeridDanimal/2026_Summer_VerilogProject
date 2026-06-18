`timescale 1ns / 1ps

module register_file


#(parameter address_bits=16, //number of bits available to encode all addresses
  parameter memory_size=8) //memory_size=number of bits per address
(input clock, input reset,
//input decode_request,//informs MEM if decode needs contents of base register

input valid_agex,
output mem_ready,

input wr_en0,
input wr_en1,
input rd_en0,
input rd_en1,
input [15:0] writeData,
output reg [15:0] readData

    );

reg valid;

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
	    $display("content of read_data before reset",readData);
	    readData=0;
	    $display("read_data after reset,",read_data);
	end




assign mem_ready= !valid;
always@(posedge reset or posedge clock)
begin
    if(reset)
        begin
            valid<=0;

        end
    
    else
        if (mem_ready)
            begin
            
                        
            if(valid_agex)
            begin
                //check read/write perimissions
                 
                case( {rd_en1,rd_en0}  )
                    2'b00:
                        readData<=readData;
                    /*
                    
                    2'b01:  //one byte
                    2'b11:  //both bytes
                    */    
                    
                    default:
                    readData<=readData;
                endcase 
                            
                /*
                case({wr_en1,wr_en0})
                    00=read only
                    01= only one byte allowed
                    10=?
                    11=both bytes allowed??*/
                    
            
            
            
            end
           
            
            //registers[destinationReg]<=alu_result;
            //version 1: memory operations unsupported. need to test functionality of ALU
            
       end
    
    
end

endmodule
