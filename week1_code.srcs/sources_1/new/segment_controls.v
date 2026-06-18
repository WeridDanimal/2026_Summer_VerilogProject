`timescale 1ns / 1ps

module segments_controls(
//controls toggles for 7 segments
    input [3:0] bcd,
    output reg[6:0] segOut
    );

always@(*)
begin
    case(bcd)//each bit determines which led segment stays on or off.
    //Note: the board only has 7 segment pins, not 7*4=28. This means requiring shuffling which digit the segments are shown in
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
       
        default: segOut=7'b1111_111;
    endcase
end    
endmodule
