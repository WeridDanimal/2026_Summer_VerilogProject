`timescale 1ns / 1ps


/*
NOTICE: THIS FILE IS ONLY FUNCTIONAL IN THE SIMULATIONS. 
CURRENTLY CANNOT BE SYNTHESIZED



*/

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
output reg [15:0] readData,
input [15:0] inputAddress,
output validOutput
    );



/*source of synthesis stalling: too many addresses to process?
256 addresses=no problem*/
(* ram_style = "block" *)
reg [memory_size-1:0] usable_memory [(2**address_bits)-1:0];
//reg [memory_size-1:0] usable_memory [256:0];
/*
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
	    $display("read_data after reset,",readData);
	end
*/


reg valid;


/*
I think I identified a design flaw.

If memory operations are single-cycle, there is never a point where it is stalling, so it should always be ready.

The only kind of limits MEM needs is knowing whether or not the inputs from AGEX are valid.

*/

assign mem_ready=1'b1;
assign validOutput=valid;

always@(posedge clock)
begin
    if(reset)
        begin
            valid<=0;

        end
    
    else
        if (mem_ready)
            begin
            valid<=valid_agex; 
                      
            if(valid_agex)
            begin
                //check read/write perimissions
                 
                case( {rd_en1,rd_en0}  )
                    2'b00:
                        //readData<=readData;
                        readData<=inputAddress; //in theory, any instructions with no read/write permissions
                        //should return an ALU math result
                    2'b01: //only read 1 byte
                        begin
                        //$display("============================================");
                        //$display("byte read authorized. input address=",inputAddress);
                        //$display("contents at address=%h",usable_memory[inputAddress]);
                        readData<=  usable_memory[inputAddress][memory_size-1]?
                        (16'hFF00|usable_memory[inputAddress]):usable_memory[inputAddress];
                        
                        //readData<=usable_memory[inputAddress];
                        
                        end
                    2'b10:  //read both bytes
                        begin
                        readData<={usable_memory[inputAddress+1] ,usable_memory[inputAddress]};
                        end
                    default:
                        readData<=readData;
                endcase 
                            
                
                if( {wr_en1,wr_en0}==2'b01)
                begin
                    //$display("byte write authorized. incoming data=%h",writeData);
                    usable_memory[inputAddress]<=writeData[7:0];
                    //$display("memory at address %h has contents= %h", inputAddress, usable_memory[inputAddress]);
                end
                else if({wr_en1,wr_en0}==2'b10)
                begin
                    //$display("word write authorized");
                    usable_memory[inputAddress]<=writeData[7:0];
                    usable_memory[inputAddress+1]<=writeData[15:8];
                end
                /*
                case({wr_en1,wr_en0})
                    2'b00:
                        usable_memory[inputAddress]<=usable_memory[inputAddress];
                    2'b01:
                        begin
                        $display("byte write authorized");
                        end
                    default:
                        //readData<=readData;
                        
                endcase
                 */  
            
            
            
            end
           
            
            //registers[destinationReg]<=alu_result;
            //version 1: memory operations unsupported. need to test functionality of ALU
            
       end
    
    
end

endmodule
