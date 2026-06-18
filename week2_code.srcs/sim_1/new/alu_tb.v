`timescale 1ns / 1ps

module alu_tb;

reg [3:0] a,b;
reg [2:0] opcode;
wire [3:0] out; 

alu_logic a1(.A(a),.B(b),.opcode(opcode),.sum(out));

initial
begin

//a=4'b1110; b=4'b0001; opcode=3'b000;
a=4'b0000; b=4'b0000;opcode=3'b000;

#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;


#2 a=4'b0000; b=4'b0001;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0000; b=4'b0010;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0000; b=4'b0011;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0000; b=4'b0100;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0000; b=4'b0101;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0000; b=4'b0110;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0000; b=4'b0111;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0000; b=4'b1000;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0000; b=4'b1001;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0000; b=4'b1010;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0000; b=4'b1011;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0000; b=4'b1100;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0000; b=4'b1101;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0000; b=4'b1110;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0000; b=4'b1111;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

//=====================================================================================

#2 a=4'b0001; b=4'b0000;opcode=3'b000;

#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;


#2 a=4'b0001; b=4'b0001;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0001; b=4'b0010;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0001; b=4'b0011;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0001; b=4'b0100;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0001; b=4'b0101;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0001; b=4'b0110;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0001; b=4'b0111;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0001; b=4'b1000;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0001; b=4'b1001;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0001; b=4'b1010;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0001; b=4'b1011;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0001; b=4'b1100;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0001; b=4'b1101;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0001; b=4'b1110;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0001; b=4'b1111;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;
//=============================================================================

#2 a=4'b0010; b=4'b0000;opcode=3'b000;

#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;


#2 a=4'b0010; b=4'b0001;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0010; b=4'b0010;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0010; b=4'b0011;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0010; b=4'b0100;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0010; b=4'b0101;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0010; b=4'b0110;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0010; b=4'b0111;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0010; b=4'b1000;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0010; b=4'b1001;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0010; b=4'b1010;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0010; b=4'b1011;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0010; b=4'b1100;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0010; b=4'b1101;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0010; b=4'b1110;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0010; b=4'b1111;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;
//==============================================================

#2 a=4'b0011; b=4'b0000;opcode=3'b000;

#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;


#2 a=4'b0011; b=4'b0001;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0011; b=4'b0010;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0011; b=4'b0011;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0011; b=4'b0100;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0011; b=4'b0101;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0011; b=4'b0110;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0011; b=4'b0111;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0011; b=4'b1000;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0011; b=4'b1001;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0011; b=4'b1010;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0011; b=4'b1011;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#2 a=4'b0011; b=4'b1100;opcode=3'b000;
#2 opcode=3'b001;
#2 opcode=3'b010;
#2 opcode=3'b011;
#2 opcode=3'b100;
#2 opcode=3'b101;
#2 opcode=3'b110;
#2 opcode=3'b111;

#1 a=4'b0011; b=4'b1101;opcode=3'b000;
#1 opcode=3'b001;
#1 opcode=3'b010;
#1 opcode=3'b011;
#1 opcode=3'b100;
#1 opcode=3'b101;
#1 opcode=3'b110;
#1 opcode=3'b111;

#1 a=4'b0011; b=4'b1110;opcode=3'b000;
#1 opcode=3'b001;
#1 opcode=3'b010;
#1 opcode=3'b011;
#1 opcode=3'b100;
#1 opcode=3'b101;
#1 opcode=3'b110;
#1 opcode=3'b111;

#1 a=4'b0011; b=4'b1111;opcode=3'b000;
#1 opcode=3'b001;
#1 opcode=3'b010;
#1 opcode=3'b011;
#1 opcode=3'b100;
#1 opcode=3'b101;
#1 opcode=3'b110;
#1 opcode=3'b111;
end

endmodule
