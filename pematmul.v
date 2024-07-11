`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2024 07:33:16 PM
// Design Name: 
// Module Name: pematmul
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


module pematmul(
    input [7:0] a1,
    input [7:0] b1,
    input [7:0] a2,
    input [7:0] b2,
    input [7:0] a3,
    input [7:0] b3,
    input [7:0] a4,
    input [7:0] b4,
    output [15:0] c
    );
    assign c = a1 * b1 + a2 * b2 + a3 * b3 + a4 * b4;
endmodule
