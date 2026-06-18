`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2026 10:12:09 AM
// Design Name: 
// Module Name: alu_logic
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu_logic(input [3:0] A, input [3:0] B, input [2:0] opcode,
output reg [3:0] sum);



always@(*)
begin
    case(opcode)
        3'b000://add
            sum=A+B;
        3'b001://subtract
            sum=A-B;
        3'b010://bitwise AND
            sum=A&B;
        3'b011://bitwise OR
            sum=A|B; 
        3'b100://bitwise XOR
            sum=A^B;
        3'b101://shift left.        NOTE: both shift operations are NOT barrel shifters
            sum=A<<B;
        3'b110://shift right
            sum=A>>B;
        3'b111: //compare
            begin
            
            if(A==B)
                sum=0;
            else if(A>B)
                sum=1;
            else if(A<B)
                sum=2;
            end
    endcase

end

endmodule
