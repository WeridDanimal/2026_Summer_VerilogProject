`timescale 1ns / 1ps


//takes input data and converts it into 7-segment compatible data
module segment_conversion(
    input [3:0] bcd_data, output reg[6:0] segOut
    );

    
always@(*)
//order of segment output: abcdefg
begin
    case(bcd_data)
    //if displays are wrong, check if each case was correctly encoded
    4'd0: segOut=7'b0000_001; //x01
    4'd1: segOut=7'b1001_111; //x4f
    4'd2: segOut=7'b0010_010; //x1A
    4'd3: segOut=7'b0000_110; //x06
    
    4'd4: segOut=7'b1001_100; //x4C
    4'd5: segOut=7'b0100_100; //x24
    4'd6: segOut=7'b0100_000; //x20
    4'd7: segOut=7'b0001_111; //x0F
    
    4'd8: segOut=7'b0000_000; //x00
    4'd9: segOut=7'b0001_100; //x0C 
    4'd10: segOut=7'b0001_000;//x08
    4'd11: segOut=7'b1100_000;//x60
    
    4'd12: segOut=7'b0110_001;//x31
    4'd13: segOut=7'b1000_010;//x42
    4'd14: segOut=7'b0110_000;//0x30
    4'd15: segOut=7'b0111_000;//0x38
    
    default: segOut=7'b1111_111; //x7F
    endcase
end
endmodule