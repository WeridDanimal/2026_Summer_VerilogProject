`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 04:59:27 PM
// Design Name: 
// Module Name: toplevel_fsm
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


module toplevel_fsm(input clk,input reset,
input [3:0] A, input[3:0] B, input[2:0] opcode, 
output[3:0] an, output [6:0] sseg
    );

reg [1:0] currstate, nextState;
wire [6:0] in0,in1,in2,in3;
wire [3:0] sum;

wire segclk;
alu_logic a1(.A(A),.B(B),.opcode(opcode),.sum(sum));
slow_clk slow(.clk(clk), .reset(reset), .clk_out(segclk));

segment_conversion s0(.bcd({0,0,0,sum[0]}),.segOut(in0));
segment_conversion s1(.bcd({0,0,0,sum[1]}),.segOut(in1));
segment_conversion s2(.bcd({0,0,0,sum[2]}),.segOut(in2));
segment_conversion s3(.bcd({0,0,0,sum[3]}),.segOut(in3));

display_controls d1(.clk(segclk),.reset(reset),.in0(in0),.in1(in1),.in2(in2),.in3(in3),.an(an),.sseg(sseg));

endmodule

